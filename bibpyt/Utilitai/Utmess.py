#@ MODIF Utmess Utilitai  DATE 30/08/2010   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY  
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY  
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR     
# (AT YOUR OPTION) ANY LATER VERSION.                                                  
#                                                                       
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT   
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF            
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU      
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.                              
#                                                                       
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE     
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,         
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.        
# ======================================================================
# RESPONSABLE COURTOIS M.COURTOIS

import os
import sys
import traceback
import imp
import re

# protection pour eficas
try:
    import aster
    from aster import error
    aster_exists = True
    from Messages.context_info import message_context_concept
except:
    aster_exists = False
    class error(Exception):
        pass

def _(s):
    return s

MAXLENGTH = 132

contacter_assistance = """
Il y a probablement une erreur dans la programmation.
Veuillez contacter votre assistance technique."""

# voir en fin de fin les faux appels � UTMESS pour la v�rification des messages


def list_unit(code):
    """Retourne la liste des noms de fichiers (logiques) sur lesquels doit
    etre imprim� le message.
    """
    #IDF  = INDEX('EFIDASXZ', ...)
    #'Z' (IDF=8) = LEVEE D'EXCEPTION
    d = {
        'E' : ('ERREUR', 'MESSAGE', 'RESULTAT'),
        'I' : ('MESSAGE',),
        'A' : ('MESSAGE', 'RESULTAT'),
    }
    d['F'] = d['S'] = d['Z'] = d['E']
    d['X'] = d['A']
    return d.get(code, d['F'])


class MESSAGE_LOGGER:
    """Classe g�rant l'impression de messages.
    On ne cr�e qu'une instance de ce type.
    Cette instance est accessible via le module E_Global pour astermodule.c
    """
    def __init__(self):
        """Initialisation
        """
        self.init_buffer()
        
        # est-ce qu'une erreur <E> s'est produite
        self.erreur_E = False
        
        # compteur des alarmes �mises { 'id_alarm' : count }
        self.count_alarm = {}         # dans la commande courante (pour arret � 5)
        self.count_alarm_tot = {}     # au total
        
        # alarmes � ignorer, � masquer (on ne les compte pas temporairement)
        self._ignored_alarm = {}
        self._hidden_alarm  = {}
        
        # on pr�pare le dictionnaire des valeurs par d�faut des arguments (dicarg) :
        self.default_args = {}
        # initialisation des 10 premiers
        for i in range(1,11):
            self.default_args['i%d' % i] = 99999999
            self.default_args['r%d' % i] = 9.9999E99
            self.default_args['k%d' % i] = 'xxxxxx'


    def __call__(self, *args, **kwargs):
        """Raccourci pour simplifier l'appel depuis astermodule.c et UTMESS.
        """
        self.print_message(*args, **kwargs)


    def print_message(self, code, idmess, valk=(), vali=(), valr=(),
                            exception=False, print_as=None, cc=None):
        """Appel� par la routine fortran U2MESG ou � la fonction python UTMESS
        pour afficher un message.
        L'impression de ce message est diff�r�e si le `code` est suivi d'un "+".
            code  : 'A', 'E', 'S', 'F', 'I'
            idmess : identificateur du message
            valk, vali, valr : liste des chaines, entiers ou r�els.
        Si exception==True, on l�ve une exception en cas d'erreur, sinon
        c'est l'appelant qui devra s'en charger (dans le C a priori).
        'print_as' : cf. print_buffer_content.
        """
        # r�cup�ration du texte du message
        dictmess = self.get_message(code, idmess, valk, vali, valr)
        
        # on le met dans le buffer
        self.add_to_buffer(dictmess)
        
        # si on n'attend pas une suite, ...
        if len(code) < 2 or code[1] != '+':
            # mise � jour des compteurs
            self.update_counter()
            
            # on imprime le message en attente
            self.print_buffer_content(print_as, cc)

            if exception and code[0] in ('S', 'F'):
                raise error(idmess, valk, vali, valr)
        
        return None


    def build_dict_args(self, valk, vali, valr):
        """Construit le dictionnaire de formatage du message.
        """
        # homog�n�isation : uniquement des tuples + strip des chaines de caract�res
        valk, vali, valr = map(force_enum, (valk, vali, valr))
        valk    = [k.strip() for k in valk]
        
        # variables pass�es au message
        dicarg = self.default_args.copy()
        for i in range(1,len(valk)+1):
            dicarg['k%d' % i] = valk[i-1]
        for i in range(1,len(vali)+1):
            dicarg['i%d' % i] = vali[i-1]
        for i in range(1,len(valr)+1):
            dicarg['r%d' % i] = valr[i-1]
        # valeur sp�ciale : ktout = concat�nation de toutes les chaines
        dicarg['ktout'] = ' '.join(valk)
    
        return dicarg


    def get_message(self, code, idmess, valk=(), vali=(), valr=()):
        """Retourne le texte du message dans un dictionnaire dont les cl�s sont :
            'code', 'id_message', 'corps_message'
        """
        # d�codage : idmess => (catamess, numess)
        idmess  = idmess.strip()
        x = idmess.split("_")
        assert len(x) > 1, idmess
        catamess='_'.join(x[0:-1]).lower()
        numess = int(x[-1])
        assert numess > 0 and numess < 100, idmess
    
        # import catamess => cata_msg
        try:
            mod = __import__('Messages.%s' % catamess, globals(), locals(), [catamess])
            # si le dictionnaire n'existe pas, on alertera au moment du formatage.
            cata_msg = getattr(mod, 'cata_msg', {})
        except Exception, msg:
            # doit permettre d'�viter la r�cursivit� (catamess r�serv� � Utmess)
            if catamess != 'catamess':
                self.print_message('A', 'CATAMESS_57', valk=(catamess, str(msg)))
            cata_msg = {}
        
        # corps du message
        try:
            dicarg = self.build_dict_args(valk, vali, valr)

            # cata_msg[num] = 'format'
            #              ou {'message' : 'format', 'context' : '�l�ments de contexte'}
            if type(cata_msg[numess]) == dict:
                fmt_msg  = cata_msg[numess]['message']
                ctxt_msg = cata_msg[numess]['context']
            else:
                fmt_msg  = cata_msg[numess]
                ctxt_msg = None
            
            dictmess = {
                'code'          : code,
                'id_message'    : idmess,
                'corps_message' : fmt_msg % dicarg,
                'context_info'  : self.get_context(ctxt_msg, idmess, dicarg),
            }
        except Exception, msg:
            dictmess = {
                'code'          : code,
                'id_message'    : '',
                'corps_message' : """Erreur de programmation.
Le message %s n'a pas pu etre format� correctement.
Arguments :
    entiers : %s
    r�els   : %s
    chaines : %s
--------------------------------------------------------------------------
%s
Exception : %s
--------------------------------------------------------------------------

%s""" \
        % (idmess, vali, valr, valk, ''.join(traceback.format_tb(sys.exc_traceback)), msg, contacter_assistance),
                'context_info'  : '',
            }
        # limite la longueur des ligness
        dictmess['corps_message'] = cut_long_lines(dictmess['corps_message'], MAXLENGTH)
        return dictmess


    def GetText(self, *args, **kwargs):
        """Retourne le texte du message pret a etre imprime.
        """
        return self.format_message(self.get_message(*args, **kwargs))


    def init_buffer(self):
        """Initialise le buffer.
        """
        self._buffer = []


    def add_to_buffer(self, dictmess):
        """Ajoute le message d�crit dans le buffer en vue d'une impression
        ult�rieure.
        """
        self._buffer.append(dictmess)


    def get_current_code(self):
        """Retourne le code du message du buffer = code du message le plus grave
        (cf. dgrav)
        """
        dgrav = { '?' : -9, 'I' : 0, 'A' : 1, 'S' : 4, 'Z' : 4, 'E' : 6, 'F' : 10 }
        
        current = '?'
        for dictmess in self._buffer:
            code = dictmess['code'][0]
            if dgrav.get(code, -9) > dgrav.get(current, -9):
                current = code
        
        return current


    def get_current_id(self):
        """Retourne l'id du message du buffer = id du premier message
        """
        return self._buffer[0]['id_message']


    def print_buffer_content(self, print_as=None, cc=None):
        """Extrait l'ensemble des messages du buffer dans un dictionnaire unique,
        imprime le message, et vide le buffer pour le message suivant.
            - code : celui du message le plus grave (cf. dgrav)
            - id   : celui du premier message qui est affich�
            - corps : concat�nation de tous les messages.
        'print'_as permet d'imprimer un message sur des fichiers autres que les fichiers
        habituels de 'code'. Par ex, imprimer un message d'info sur 'ERREUR'.
        'cc' : liste de noms de fichiers ou objets fichier dans lesquels copier le message
        """
        if len(self._buffer) < 1:
            return None
        
        # construction du dictionnaire du message global
        dglob = {
            'code'          : self.get_current_code(),
            'id_message'    : self.get_current_id(),
            'liste_message' : [],
            'liste_context' : [],
        }
        for dictmess in self._buffer:
            dglob['liste_message'].append(dictmess['corps_message'])
            dglob['liste_context'].append(dictmess['context_info'])
        dglob['corps_message'] = ''.join(dglob['liste_message'])
        dglob['context_info'] = ''.join(dglob['liste_context'])
        
        # liste des unit�s d'impression en fonction du type de message
        l_unit = list_unit(print_as or dglob['code'])
        
        # texte final et impression
        txt = self.format_message(dglob)
        for unite in l_unit:
            self.affiche(unite, txt)
        # "cc"
        if cc:
            copy_text_to(txt, cc)
        
        self.init_buffer()


    def disable_alarm(self, idmess, hide=False):
        """Ignore l'alarme "idmess".
        """
        if hide:
            self._hidden_alarm[idmess] = self._hidden_alarm.get(idmess, 0) + 1
        else:
            self._ignored_alarm[idmess] = self._ignored_alarm.get(idmess, 0) + 1

    def reset_alarm(self, idmess, hide=False):
        """R�active l'alarme "idmess".
        """
        if hide:
            self._hidden_alarm[idmess] = min(self._hidden_alarm.get(idmess, 0) - 1, 0)
        else:
            self._ignored_alarm[idmess] = min(self._ignored_alarm.get(idmess, 0) - 1, 0)

    def is_alarm_disabled(self, idmess):
        """Doit-on ignorer l'alarme "idmess" ?
        """
        return self._ignored_alarm.get(idmess, 0) + self._hidden_alarm.get(idmess, 0) > 0

    def info_alarm(self, only_ignored=False):
        """Fournit les infos sur les alarmes activ�es.
        """
        s_alarm = set(self._ignored_alarm.keys())
        if not only_ignored:
            s_alarm.update(self.count_alarm_tot.keys())
        l_alarm = list(s_alarm)
        l_alarm.sort()
        # on s�pare des �ventuels messages en attente
        self.print_buffer_content()
        # entete
        dictmess = self.get_message('I', 'CATAMESS_89')
        self.add_to_buffer(dictmess)
        # occurrences
        ieff = 0
        for idmess in l_alarm:
            mark = ' '
            ieff += 1
            if self._ignored_alarm.get(idmess) is not None:
                mark = '(*)'
            dictmess = self.get_message('I', 'CATAMESS_90', valk=(mark, idmess),
                                     vali=self.count_alarm_tot.get(idmess, 0))
            self.add_to_buffer(dictmess)
        if ieff == 0:
            dictmess = self.get_message('I', 'CATAMESS_92')
            self.add_to_buffer(dictmess)
        # fermeture
        dictmess = self.get_message('I', 'CATAMESS_91')
        self.add_to_buffer(dictmess)
        self.print_buffer_content(print_as='A')


    def update_counter(self):
        """Mise � jour des compteurs et r�action si besoin.
        """
        nmax_alarm = 5
        code = self.get_current_code()
        if   code == 'E':
            self.erreur_E = True
        elif code == 'F':
            self.erreur_E = False
        elif code == 'A':
            idmess = self.get_current_id()
            # nombre d'occurrence de cette alarme (sauf si cachee)
            if self._hidden_alarm.get(idmess, 0) == 0:
                self.count_alarm[idmess]     = self.count_alarm.get(idmess, 0) + 1
                self.count_alarm_tot[idmess] = self.count_alarm_tot.get(idmess, 0) + 1
            
            if self.is_alarm_disabled(idmess) or self.count_alarm[idmess] > nmax_alarm:
                # ignorer l'alarme ou count_alarm > max, on vide le buffer
                self.init_buffer()
            elif self.count_alarm[idmess] == nmax_alarm:
                # Pour mettre en relief le message CATAMESS_41, on le s�pare
                # de la derni�re alarme
                self.print_buffer_content()
                dictmess = self.get_message(code, 'CATAMESS_41',
                                        valk=idmess, vali=nmax_alarm)
                self.add_to_buffer(dictmess)


    def check_counter(self, info_alarm=0, silent=0):
        """M�thode "jusqu'ici tout va bien" ! (Interface C : chkmsg)
        Si des erreurs <E> se sont produites, on arrete le code en <F>.
        Appel�e par FIN ou directement au cours de l'ex�cution d'une commande.
        Retourne un entier : 0 si tout est ok.
        Si silent==1, on n'�met pas de message, on ne s'arrete pas.
        """
        iret = 0
        if self.erreur_E:
            iret = 4
            self.erreur_E = False
            if not silent:
                self.print_message('F', 'CATAMESS_6', exception=True)
        if info_alarm:
            self.info_alarm()
        return iret


    def reset_command(self):
        """M�thode appel�e entre les commandes. (Interface C : resmsg)
        On remet � z�ro le compteur d'alarme,
        on v�rifie les erreurs <E> en attente."""
        iret = self.check_counter()
        # reset des alarmes
        self.count_alarm = {}


    def format_message(self, dictmess):
        """Formate le message d�crit dans un dico :
            'code'          : A, E, S, F, I
            'id_message'    : identification du message
            'corps_message' : texte
        """
        charh = '-'    # horizontal
        charv = '!'    # vertical
        charc = '!'    # coin
        dcomm = {
            'A' : _("""Ceci est une alarme. Si vous ne comprenez pas le sens de cette
alarme, vous pouvez obtenir des r�sultats inattendus !"""),
            'E' : _("""Cette erreur sera suivie d'une erreur fatale."""),
            'S' : _("""Cette erreur est fatale. Le code s'arrete. Toutes les �tapes
du calcul ont �t� sauv�es dans la base jusqu'au moment de l'arret."""),
            'F' : _("""Cette erreur est fatale. Le code s'arrete."""),
        }
        
        # format complet
        format_general = {
            'decal'  : '   ',
            'header' : """<%(type_message)s> %(str_id_message)s""",
            'ligne'  : '%(charv)s %%-%(maxlen)ds %(charv)s',
            'corps'  : """%(header)s

%(corps_message)s
%(context_info)s

%(commentaire)s
""",
            'final'  : """
%(separateur)s
%(corps)s
%(separateur)s

""",
        }
        # format light pour les infos
        format_light = {
            'decal'  : '',
            'header' : """<%(type_message)s> """,
            'ligne'  : '%%s',
            'corps'  : """%(corps_message)s
%(context_info)s""",
            'final'  : """%(corps)s""",
        }
        dmsg = dictmess.copy()
        dmsg['type_message'] = self.get_type_message(dictmess['code'])
        if dmsg['id_message'] != 'I':
            dmsg['str_id_message'] = '<%s>' % dmsg['id_message']
        else:
            dmsg['str_id_message'] = ''
        
        # format utilis�
        format = format_general
        if dmsg['type_message'] == 'I':
            format = format_light
        if format is format_general:
            dmsg['corps_message'] = dmsg['corps_message'].strip()
        
        dmsg['header']      = format['header'] % dmsg
        dmsg['commentaire'] = dcomm.get(dmsg['type_message'], '')
        if re.search('^DVP', dmsg['id_message']) != None:
            dmsg['commentaire'] += contacter_assistance
        
        dmsg['corps']       = format['corps'] % dmsg
        if format is format_general:
            dmsg['corps'] = dmsg['corps'].strip()
        
        
        # longueur de la ligne la plus longue
        l_line = dmsg['corps'].splitlines()
        maxlen = max([len(line) for line in l_line])
        
        # format des lignes sur maxlen caract�res
        dlin = {
            'charh'  : charh,
            'charv'  : charv,
            'charc'  : charc,
            'maxlen' : maxlen
        }
        fmt_line = format['ligne'] % dlin
        
        # on formate toutes les lignes
        txt = [fmt_line % line for line in l_line]
        dmsg['corps'] = os.linesep.join(txt)
        dmsg['separateur'] = charc + charh * (maxlen + 2) + charc
        
        # ligne haut et bas
        newtxt = format['final'] % dmsg
        # on d�cale
        l_txt = [format['decal'] + line for line in newtxt.splitlines()]
        
        return clean_string(os.linesep.join(l_txt))


    def get_type_message(self, code):
        """Retourne le type du message affich�.
        En cas d'erreur, si on l�ve une exception au lieu de s'arreter,
        on n'affiche pas le type de l'erreur pour ne pas fausser le diagnostic
        """
        typmess = code.strip()
        if self.onFatalError().startswith('EXCEPTION'):
            if typmess in ('E', 'F'):
                typmess = 'EXCEPTION'
        # dans tous les cas, pour S et Z (exception), on affiche EXCEPTION.
        if typmess in ('Z', 'S'):
            typmess = 'EXCEPTION'
        return typmess


    def get_context(self, ctxt_msg, idmess, dicarg):
        """Prise en compte du context du message pour donner d'autres infos
        � l'utilisateur.
        ctxt_msg est un dictionnaire. Les cl�s trait�es sont :
            - CONCEPT
        """
        if not ctxt_msg:
            return ''
        msg = []
        # tout dans un try/except car c'est du bonus, il ne faudrait pas planter !
        try:
            if ctxt_msg.has_key('CONCEPT'):
                l_co =  [dicarg[arg] for arg in force_enum(ctxt_msg['CONCEPT'])]
                for co in l_co:
                    msg.append(message_context_concept(co))
        except:
            pass
        return os.linesep.join(msg)


    # d�finitions pour fonctionner sans le module aster
    def affiche(self, unite, txt):
        """Affichage du message"""
        if aster_exists:
            aster.affiche(unite, txt)
        else:
            print txt


    def onFatalError(self):
        """R�cup�rer le comportement en cas d'erreur fatale."""
        if aster_exists:
            return aster.onFatalError()
        else:
            return 'EXCEPTION'


def clean_string(chaine):
    """Supprime tous les caract�res non imprimables.
    """
    invalid = '?'
    txt = []
    for c in chaine:
        if ord(c) != 0:
            txt.append(c)
        else:
            txt.append(invalid)
    return ''.join(txt)


def force_enum(obj):
    """Retourne `obj` si c'est une liste ou un tuple,
    sinon retourne [obj,]
    """
    if type(obj) not in (list, tuple):
        obj = [obj,]
    return obj


def maximize_lines(l_fields, maxlen, sep):
    """Construit des lignes dont la longueur est au plus de `maxlen` caract�res.
    Les champs sont assembl�s avec le s�parateur `sep`.
    """
    newlines = []
    while len(l_fields) > 0:
        cur = []
        while len(l_fields) > 0 and len(sep.join(cur + [l_fields[0],])) <= maxlen:
            cur.append(l_fields.pop(0))
        newlines.append(sep.join(cur))
    newlines = [l for l in newlines if l != '']
    return newlines

def cut_long_lines(txt, maxlen, sep=os.linesep,
                   l_separ=(' ', ',', ';', '.', ':')):
    """Coupe les morceaux de `txt` (isol�s avec `sep`) de plus de `maxlen`
    caract�res.
    On utilise successivement les s�parateurs de `l_separ`.
    """
    l_lines = txt.split(sep)
    newlines = []
    for line in l_lines:
        if len(line) > maxlen:
            l_sep = list(l_separ)
            line = cut_long_lines(line, maxlen, l_sep[0], l_sep[1:])
            line = maximize_lines(line, maxlen, l_sep[0])
            newlines.extend(line)
        else:
            newlines.append(line)
    # au plus haut niveau, on assemble le texte
    if sep == os.linesep:
        newlines = os.linesep.join(newlines)
    return newlines


def copy_text_to(text, files):
    """Imprime le texte dans les fichiers.
    """
    if type(files) not in (list, tuple):
        files = [files,]
    for f in files:
        assert type(f) in (str, file)
        if type(f) == file:
            fobj = file
        else:
            fobj = open(f, 'a')
            # should be closed automatically
        fobj.write(text)
        fobj.write(os.linesep)
        fobj.flush()


# unique instance du MESSAGE_LOGGER
MessageLog = MESSAGE_LOGGER()


def UTMESS(code, idmess, valk=(), vali=(), valr=(), print_as=None, cc=None):
    """Utilitaire analogue � la routine fortran U2MESS/U2MESG avec les arguments
    optionnels.
        code   : 'A', 'E', 'S', 'F', 'I'
        idmess : identificateur du message
        valk, vali, valr : liste des chaines, entiers ou r�els.
    
    Appel sans valeurs :                avec valeurs :
        UTMESS('A', 'SUPERVIS_40')          UTMESS('A', 'SUPERVIS_40', vali=[1, 2])
    
    Remarques :
        - Nommer les arguments permet de ne pas tous les passer.
        - Meme fonctionnement que U2MESG :
            + appel � MessageLog
            + puis exception ou abort en fonction du niveau d'erreur.
    """
    MessageLog(code, idmess, valk, vali, valr, exception=True, print_as=print_as, cc=cc)


def ASSERT(condition):
    """Remonter un assert dans un message.
    """
    if condition:
        return
    stack = traceback.format_stack(limit=10)
    UTMESS('F', 'DVP_9', valk=(''.join(stack[:-1]),))


def message_exception(code, exc):
    """Retourne le message associ� � une exception aster.error
    tel qu'il aurait �t� imprim� par UTMESS selon la valeur de
    `code` ('I', 'A', 'S', 'F', 'Z'...)."""
    return MessageLog.GetText(code, exc.id_message,
                              exc.valk, exc.vali, exc.valr)


def MasquerAlarme(idmess):
    """Masque une alarme : ni affichee, ni comptee.
    Utilisation dans les macros :
        MasquerAlarme(XXX)  au debut de la macro
        RetablirAlarme(XXX) a la fin de la macro
    Comme il s'agit d'un compteur qui est incremente puis decremente, il est
    imperatif qu'il y ait autant d'appel a MasquerAlarme qu'a RetablirAlarme.
    """
    MessageLog.disable_alarm(idmess, hide=True)


def RetablirAlarme(idmess):
    """Retablit l'etat initial pour l'alarme 'idmess'.
    """
    MessageLog.reset_alarm(idmess, hide=True)


# faux appels � UTMESS
def __fake__():
    UTMESS('I', 'SUPERVIS_40')    # surcharge �mis par asrun
    UTMESS('I', 'SUPERVIS_96')    # �mis depuis le C (inisig)
    UTMESS('I', 'SUPERVIS_97')    # �mis depuis le C (inisig)
    UTMESS('I', 'GENERIC_1')      # dans des tests pour traiter les exceptions
    UTMESS('I', 'CATAMESS_6')
    UTMESS('I', 'CATAMESS_41')
    UTMESS('I', 'CATAMESS_55')    # pour u2mesg.f
    UTMESS('I', 'CATAMESS_57')
    UTMESS('I', 'CATAMESS_69')    # pour u2mesg.f
    UTMESS('I', 'CATAMESS_70')    # pour u2mesg.f
    UTMESS('I', 'CATAMESS_89')
    UTMESS('I', 'CATAMESS_90')
    UTMESS('I', 'CATAMESS_91')
    UTMESS('I', 'CATAMESS_92')
    UTMESS('I', 'MISS0_3')
    UTMESS('I', 'MISS0_5')
    UTMESS('I', 'MISS0_6')
    UTMESS('I', 'MISS0_7')
    UTMESS('I', 'MISS0_8')



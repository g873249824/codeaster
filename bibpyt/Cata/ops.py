#@ MODIF ops Cata  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

# Modules Python
import sys
import os
import os.path as osp
import traceback
import cPickle as pickle
import re
from math import sqrt, pi, atan2, tan, log, exp

# Modules Eficas
import Accas
from Accas import ASSD
from Noyau.ascheckers     import CheckLog
from Noyau.N_info import message, SUPERV
from Noyau.N_types import force_list

try:
   import aster
   import aster_core
   aster_exists = True
   # Si le module aster est pr�sent, on le connecte
   # au JDC
   import Build.B_CODE
   Build.B_CODE.CODE.codex=aster

   from Utilitai.Utmess   import UTMESS, MessageLog
   from Build.B_SENSIBILITE_MEMO_NOM_SENSI import MEMORISATION_SENSIBILITE
except:
   aster_exists = False



def commun_DEBUT_POURSUITE(jdc, PAR_LOT, IMPR_MACRO, CODE, DEBUG, IGNORE_ALARM, LANG, INFO):
   """Fonction sdprod partie commune � DEBUT et POURSUITE.
   (on stocke un entier au lieu du logique)
   """
   jdc.set_par_lot(PAR_LOT, user_value=True)
   jdc.impr_macro = int(IMPR_MACRO == 'OUI')
   jdc.jxveri     = int(CODE != None or (DEBUG != None and DEBUG['JXVERI'] == 'OUI'))
   jdc.sdveri     = int(DEBUG != None and DEBUG['SDVERI'] == 'OUI')
   jdc.fico       = None
   jdc.sd_checker = CheckLog()
   jdc.info_level = INFO
   jdc.hist_etape = (DEBUG != None and DEBUG['HIST_ETAPE'] == 'OUI')
   if CODE != None:
      jdc.fico = CODE['NOM']
   if LANG:
       from Execution.i18n import localization
       localization.install(LANG)
   if aster_exists:
      # pb en cas d'erreur dans FIN : appeler reset_print_function dans traiter_fin_exec ?
      #from functools import partial
      #asprint = partial(aster.affiche, 'MESSAGE')
      #message.register_print_function(asprint)
      # en POURSUITE, ne pas �craser la m�morisation existante.
      if not hasattr(jdc, 'memo_sensi'):
         jdc.memo_sensi = MEMORISATION_SENSIBILITE()
      jdc.memo_sensi.reparent(jdc)
      # ne faire qu'une fois
      if not hasattr(jdc, 'msg_init'):
         # messages d'alarmes d�sactiv�s
         if IGNORE_ALARM:
            if not type(IGNORE_ALARM) in (list, tuple):
               IGNORE_ALARM = [IGNORE_ALARM]
            for idmess in IGNORE_ALARM:
               MessageLog.disable_alarm(idmess)
      # en POURSUITE, conserver le catalogue de comportement pickl�
      if not hasattr(jdc, 'catalc'):
         from Comportement import catalc
         jdc.catalc = catalc
      jdc.msg_init = True


def DEBUT(self, PAR_LOT, IMPR_MACRO, CODE, DEBUG, IGNORE_ALARM, LANG, INFO, **args):
   """
       Fonction sdprod de la macro DEBUT
   """
   # La commande DEBUT ne peut exister qu'au niveau jdc
   if self.jdc is not self.parent :
      raise Accas.AsException("La commande DEBUT ne peut exister qu'au niveau jdc")
   commun_DEBUT_POURSUITE(self.jdc, PAR_LOT, IMPR_MACRO, CODE, DEBUG, IGNORE_ALARM, LANG, INFO)


def build_debut(self,**args):
   """
   Fonction ops pour la macro DEBUT
   """
   self.jdc.UserError=self.codex.error

   if self.jdc.par_lot == 'NON' :
      self.jdc._Build()
   # On execute la fonction debut pour initialiser les bases
   # Cette execution est indispensable avant toute autre action sur ASTER
   # op doit �tre un entier car la fonction debut appelle GCECDU qui demande
   # le num�ro de l'operateur associ� (getoper)
   self.definition.op=0
   self.set_icmd(1)
   self.codex.debut(self)
   # On remet op a None juste apres pour eviter que la commande DEBUT
   # ne soit execut�e dans la phase d'execution
   self.definition.op=None
   return 0

def POURSUITE(self, PAR_LOT, IMPR_MACRO, CODE, DEBUG, IGNORE_ALARM, LANG, INFO, **args):
   """
       Fonction sdprod de la macro POURSUITE
   """
   # La commande POURSUITE ne peut exister qu'au niveau jdc
   if self.jdc is not self.parent :
      raise Accas.AsException("La commande POURSUITE ne peut exister qu'au niveau jdc")

   commun_DEBUT_POURSUITE(self.jdc, PAR_LOT, IMPR_MACRO, CODE, DEBUG, IGNORE_ALARM, LANG, INFO)

   if self.codex:
     base = 'glob.1'
     if aster_exists:
        repglob = aster_core.get_option("repglob")
        bhdf = osp.join(repglob, 'bhdf.1')
        base = osp.join(repglob, 'glob.1')
        if not osp.isfile(base) and not osp.isfile(bhdf):
            UTMESS('F','SUPERVIS_89')
     # Le module d'execution est accessible et glob.1 est present
     # Pour eviter de rappeler plusieurs fois la sequence d'initialisation
     # on memorise avec l'attribut fichier_init que l'initialisation
     # est r�alis�e
     if hasattr(self,'fichier_init'):return
     self.fichier_init='glob.1'
     self.jdc.initexec()
     # le sous programme fortran appel� par self.codex.poursu demande le num�ro
     # de l'operateur (GCECDU->getoper), on lui donne la valeur 0
     self.definition.op=0
     self.codex.poursu(self)
     # Par la suite pour ne pas executer la commande pendant la phase
     # d'execution on le remet � None
     self.definition.op = None
     self.g_context = {}

     # Il peut exister un contexte python sauvegard� sous forme  pickled
     # On r�cup�re ces objets apr�s la restauration des concepts pour que
     # la r�cup�ration des objets pickled soit prioritaire.
     # On v�rifie que les concepts relus dans glob.1 sont bien tous
     # presents sous le m�me nom et du m�me type dans pick.1
     # Le contexte est ensuite updat� (surcharge) et donc enrichi des
     # variables qui ne sont pas des concepts.
     # On supprime du pickle_context les concepts valant None, ca peut
     # �tre le cas des concepts non execut�s, plac�s apr�s FIN.
     UTMESS('I', 'SUPERVIS2_1', valk='pick.1')
     pickle_context = get_pickled_context()
     if pickle_context == None:
        UTMESS('F', 'SUPERVIS_86')
        return
     self.jdc.restore_pickled_attrs(pickle_context)
     # v�rification coh�rence pick/base
     savsign = self.jdc._sign
     newsign = self.jdc.signature(base)
     if args.get('FORMAT_HDF') == 'OUI':
         UTMESS('I', 'SUPERVIS_71')
     elif newsign != savsign:
         UTMESS('A', 'SUPERVIS_69', valk=(savsign, newsign),
                                    vali=self.jdc.jeveux_sysaddr)
     else:
         UTMESS('I', 'SUPERVIS_70', valk=newsign, vali=self.jdc.jeveux_sysaddr)
     from Cata.cata  import entier
     from Noyau.N_CO import CO
     interrupt = []
     count = 0
     UTMESS('I', 'SUPERVIS_65')
     for elem, co in pickle_context.items():
         if isinstance(co, ASSD):
            count += 1
            typnam = co.__class__.__name__
            # on rattache chaque assd au nouveau jdc courant (en poursuite)
            co.jdc = self.jdc
            co.parent = self.jdc
            # le marquer comme 'executed'
            i_int = ''
            if co.executed != 1:
                interrupt.append((co.nom, typnam))
                i_int = 'exception'
            co.executed = 1
            UTMESS('I', 'SUPERVIS_66', valk=(co.nom, typnam.lower(), i_int))
            # pour que sds_dict soit coh�rent avec g_context
            self.jdc.sds_dict[elem] = co
            if elem != co.nom:
               name = re.sub('_([0-9]+)$', '[\\1]', co.nom)
               if self.jdc.info_level > 1:
                  UTMESS('I', 'SUPERVIS2_3',
                         valk=(elem, type(co).__name__.upper()))
               UTMESS('A', 'SUPERVIS_93', valk=(elem, "del %s" % name))
               del pickle_context[elem]
               continue
         if co == None:
            del pickle_context[elem]
     if count == 0:
         UTMESS('I', 'SUPERVIS_67')
     for nom, typnam in interrupt:
         UTMESS('I', 'SUPERVIS_76', valk=(nom, typnam))
     if not interrupt:
         UTMESS('I', 'SUPERVIS_72')
     self.g_context.update(pickle_context)
     return

   else:
     # Si le module d'execution n est pas accessible ou glob.1 absent on
     # demande un fichier (EFICAS)
     # Il faut �viter de r�interpr�ter le fichier � chaque appel de
     # POURSUITE
     if hasattr(self,'fichier_init'):
        return
     self.make_poursuite()

def get_pickled_context():
    """
       Cette fonction permet de r�importer dans le contexte courant du jdc (jdc.g_context)
       les objets python qui auraient �t� sauvegard�s, sous forme pickled, lors d'une
       pr�c�dente �tude. Un fichier pick.1 doit �tre pr�sent dans le r�pertoire de travail
    """
    fpick = 'pick.1'
    if not osp.isfile(fpick):
       return None

    # Le fichier pick.1 est pr�sent. On essaie de r�cup�rer les objets python sauvegard�s
    context={}
    try:
       file=open(fpick,'r')
       # Le contexte sauvegard� a �t� pickl� en une seule fois. Il est seulement
       # possible de le r�cup�rer en bloc. Si cette op�ration echoue, on ne r�cup�re
       # aucun objet.
       context = pickle.load(file)
       file.close()
    except:
       # En cas d'erreur on ignore le contenu du fichier
       traceback.print_exc()
       return None

    return context

def POURSUITE_context(self,d):
   """
       Fonction op_init de la macro POURSUITE
   """
   # self repr�sente la macro POURSUITE ...
   d.update(self.g_context)
   # Une commande POURSUITE n'est possible qu'au niveau le plus haut
   # On ajoute directement les concepts dans le contexte du jdc

def build_poursuite(self,**args):
   """
   Fonction ops pour la macro POURSUITE
   """
   # Pour POURSUITE on ne modifie pas la valeur initialisee dans ops.POURSUITE
   # Il n y a pas besoin d executer self.codex.poursu (c'est deja fait dans
   # la fonction sdprod de la commande (ops.POURSUITE))
   self.set_icmd(1)
   self.jdc.UserError = self.codex.error
   return 0

def INCLUDE(self,UNITE,**args):
   """
       Fonction sd_prod pour la macro INCLUDE
   """
   if not UNITE : return
   if hasattr(self,'unite'):return
   self.unite=UNITE

   if self.jdc and self.jdc.par_lot == 'NON':
      # On est en mode commande par commande, on appelle la methode speciale
      self.Execute_alone()

   self.make_include(unite=UNITE)

def INCLUDE_context(self,d):
   """
       Fonction op_init pour macro INCLUDE
   """
   ctxt = self.g_context
   d.update(ctxt)

def build_include(self,**args):
   """
   Fonction ops de la macro INCLUDE appel�e lors de la phase de Build
   """
   # Pour presque toutes les commandes (sauf FORMULE et POURSUITE)
   # le num�ro de la commande n est pas utile en phase de construction
   # La macro INCLUDE ne sera pas num�rot�e (incr�ment=None)
   ier=0
   self.set_icmd(None)
   # On n'execute pas l'ops d'include en phase BUILD car il ne sert a rien.
   #ier=self.codex.opsexe(self,1)
   return ier

def _detr_list_co(self, context):
    """Utilitaire pour DETRUIRE"""
    list_co = set()
    # par nom de concept (typ=assd)
    for mc in self['CONCEPT'] or []:
        list_co.update(force_list(mc["NOM"]))
    # par chaine de caract�res (typ='TXM')
    for mc in self['OBJET'] or []:
        # longueur <= 8, on cherche les concepts existants
        for nom in force_list(mc['CHAINE']):
            assert type(nom) in (str, unicode), 'On attend une chaine de caract�res : %s' % nom
            if len(nom.strip()) <= 8:
                if self.jdc.sds_dict.get(nom) != None:
                    list_co.add(self.jdc.sds_dict[nom])
                elif context.get(nom) != None:
                    list_co.add(context[nom])
            #else uniquement destruction des objets jeveux
    return list_co

def DETRUIRE(self, CONCEPT, OBJET, **args):
   """Fonction OPS pour la macro DETRUIRE : ex�cution r�elle."""
   # pour les formules, il ne faut pas vider l'attribut "parent_context" trop t�t
   for co in _detr_list_co(self, {}):
       co.supprime(force=True)
   self.set_icmd(1)
   ier = self.codex.opsexe(self, 7)
   return ier

def build_detruire(self, d):
   """Fonction op_init de DETRUIRE."""
   # d est le g_context du jdc ou d'une macro
   #message.debug(SUPERV, "id(d) : %s", id(d))
   for co in _detr_list_co(self, d):
      assert isinstance(co, ASSD), 'On attend un concept : %s (type=%s)' % (co, type(co))
      nom = co.nom
      #message.debug(SUPERV, "refcount_1(%s) = %d", nom, sys.getrefcount(co))
      # traitement particulier pour les listes de concepts, on va mettre � None
      # le terme de l'indice demand� dans la liste :
      # nomconcept_i est supprim�, nomconcept[i]=None
      i = nom.rfind('_')
      if i > 0 and not nom.endswith('_'):
         concept_racine = nom[:i]
         if d.has_key(concept_racine) and type(d[concept_racine]) is list:
            try:
               num = int(nom[i+1:])
               d[concept_racine][num] = None
            except (ValueError, IndexError):
               # cas : RESU_aaa ou (RESU_8 avec RESU[8] non initialis�)
               pass
      # pour tous les concepts :
      if d.has_key(nom):
         del d[nom]
      if self.jdc.sds_dict.has_key(nom):
         del self.jdc.sds_dict[nom]
      # "suppression" du concept
      co.supprime()
      # On signale au parent que le concept n'existe plus apr�s l'�tape self
      self.parent.delete_concept_after_etape(self, co)
      # marque comme d�truit == non execut�
      co.executed = 0


def build_procedure(self,**args):
    """
    Fonction ops de la macro PROCEDURE appel�e lors de la phase de Build
    """
    ier=0
    # Pour presque toutes les commandes (sauf FORMULE et POURSUITE)
    # le num�ro de la commande n est pas utile en phase de construction
    # On ne num�rote pas une macro PROCEDURE (incr�ment=None)
    self.set_icmd(None)
    #ier=self.codex.opsexe(self,3)
    return ier

def build_DEFI_FICHIER(self,**args):
    """
    Fonction ops de la macro DEFI_FICHIER
    """
    self.set_icmd(1)
    ier = self.codex.opsexe(self, 26)
    return ier

def build_formule(self, d):
    """Fonction ops de FORMULE."""
    NOM_PARA = self.etape['NOM_PARA']
    VALE = self.etape['VALE']
    VALE_C = self.etape['VALE_C']
    if type(NOM_PARA) not in (list, tuple):
        NOM_PARA = [NOM_PARA, ]
    for para in NOM_PARA:
        if para.strip() != para:
            raise Accas.AsException("nom de param�tre invalide (contient des blancs)" \
               " : %s" % repr(para))
    if self.sd == None:
        return
    if VALE     != None :
        texte = ''.join(VALE.splitlines())
    elif VALE_C != None :
        texte = ''.join(VALE_C.splitlines())
    self.sd.setFormule(NOM_PARA, texte.strip())

def build_gene_vari_alea(self, d):
    """Fonction ops de la macro GENE_VARI_ALEA."""
    from Utilitai.Utmess import UTMESS
    a = self.etape['BORNE_INF']
    moyen = self.etape['VALE_MOY' ]
    TYPE = self.etape['TYPE']
    if self['INIT_ALEA'] is not None:
        jump = self.etape['INIT_ALEA' ]
        self.iniran(jump)
    if TYPE == 'EXP_TRONQUEE':
        b = self.etape['BORNE_SUP']
        if a >= b:
            UTMESS('F', 'PROBA0_1', valr=[a, b])
        elif moyen <= a or moyen >= b:
            UTMESS('F', 'PROBA0_2', valr=[a, moyen, b])
        k = 1. / (moyen - a)
        if exp(-b * k) < 1.e-12:
            UTMESS('F', 'PROBA0_3')
        # r�solution par point fixe
        eps = 1.E-4
        nitmax = 100000
        test = 0.
        while abs((test - k) / k) > eps:
            test = k
            k = 1. / (moyen - (a * exp(-a * k) - b * exp(-b * k)) / \
                               (exp(-a * k) - exp(-b * k)))
        # g�n�ration de la variable al�atoire
        alpha = exp(-a * k) - exp(-b * k)
        self.sd.valeur = -(log(exp(-a * k) - alpha * self.getran()[0])) / k
    elif TYPE == 'EXPONENTIELLE':
       if moyen <= a:
          UTMESS('F', 'PROBA0_4', valr=[moyen, a])
       v = moyen - a
       u = self.getran()[0]
       x = -log(1 - u)
       self.sd.valeur = a + v * x
    elif TYPE == 'GAMMA':
       delta = self.etape['COEF_VAR' ]
       if moyen <= a:
          UTMESS('F', 'PROBA0_4', valr=[moyen, a])
       v = moyen - a
       alpha = 1. / delta**2
       if alpha <= 1.:
          UTMESS('F', 'PROBA0_5')
       gamma2 = alpha - 1.
       gamm1 = 1. / gamma2
       beta = sqrt(2. * alpha - 1.)
       beta2 = 1. / beta**2
       f0 = 0.5 + (1. / pi) * atan2(-gamma2 / beta, 1.)
       c1 = 1. - f0
       c2 = f0 - 0.5
       vref = 0.
       vv     = -1.
       while -vv > vref:
          u = self.getran()[0]
          gamdev = beta * tan(pi * (u * c1 + c2)) + gamma2
          unif = self.getran()[0]
          if unif < 0.:
             UTMESS('F', 'PROBA0_6')
          vv = -log(unif)
          vref = log(1 + beta2 * ((gamdev - gamma2)**2)) \
               + gamma2 * log(gamdev * gamm1) - gamdev + gamma2
       if vv <= 0.:
          UTMESS('F', 'PROBA0_7')
       self.sd.valeur = a + v * delta**2 * gamdev

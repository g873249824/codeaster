# coding=utf-8
# person_in_charge: mathieu.courtois at edf.fr
# ======================================================================
# COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
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
#
#
# ======================================================================
"""
"""
# Modules Python
from repr import repr as reprlim
import traceback
from os import times
from types import ClassType, TypeType

# Module Eficas
from Noyau.N_utils import prbanner, AsType
from Noyau.N_types import is_int, is_float, is_float_or_int, is_complex, is_str, is_sequence, is_assd
from Noyau import N_MCSIMP, N_MCFACT, N_MCBLOC, N_MCLIST, N_ASSD, N_ENTITE
from Noyau import N_FACT, N_BLOC, N_SIMP
from Noyau.N_Exception import AsException
from Noyau.N_GEOM import GEOM
from Noyau.N_info import message, SUPERV
import B_utils
import B_CODE
import B_OBJECT


class ETAPE(B_OBJECT.OBJECT, B_CODE.CODE):

    """
    Cette classe implémente les méthodes relatives à la phase de construction d'une étape.
    """

    def affiche_cmd(self):
        """
        Permet d'afficher une information apres avoir affecte le numero de commande.
        Ne sert que pour afficher le texte des macros (methode surchargee dans E_MACRO_ETAPE)
        """
        pass

    def set_icmd(self, icmd):
        """
        Demande au jdc un numero de commande unique.

        @param icmd: entier indiquant l'incrément de numero de commande demandé (en général 1)
        """
        if icmd is not None:
            self.icmd = self.jdc.icmd = self.jdc.icmd + icmd
        else:
            self.icmd = None
        self.affiche_cmd()

    def Build(self):
        """
          Fonction : Construction d'une étape de type OPER ou PROC
           En général, il n'y a pas de construction à faire
        """
        ier = self._Build()
        return ier

    def _Build(self):
        """
            Cette méthode réalise le traitement de construction pour
            l'objet lui meme
        """
        if CONTEXT.debug:
            print "ETAPE._Build ", self.nom
        # On demande d incrementer le compteur de la commande de 1
        self.set_icmd(1)
        return 0

    def getres(self):
        """
          Retourne le nom du resultat, le nom du concept
          et le nom de la commande
          Ces noms sont en majuscules et completes par des
          blancs jusqu a une longueur de 8
          Utilise par l interface C-FORTRAN
        """
        if CONTEXT.debug:
            prbanner("getres " + self.nom + " " + reprlim(self))
        # self ne peut etre qu'un objet de type ETAPE
        nom_cmd = self.definition.nom.ljust(8)
        nom_concept = " "
        type_concept = " "
        if self.sd != None:
            nom_concept = self.sd.get_name().ljust(8)
            type_concept = self.sd.__class__.__name__.upper()
        assert(nom_concept != None), "getres : nom_concept est Vide (None)"
        if CONTEXT.debug:
            print "\tGETRES : nom_concept =", '"' + nom_concept + '"'
            print "\tGETRES : type_concept =", '"' + type_concept + '"'
            print "\tGETRES : nom_cmd =", '"' + nom_cmd + '"'
        # message.debug(SUPERV, "commande : %s, concept : %s, type : %s",
        # nom_cmd, nom_concept, type_concept)
        return nom_concept, type_concept, nom_cmd

    def gettyp(self, typaster):
        """Retourne la liste des noms de concepts du type `typaster`.
        `mxval` : longueur maximale de la liste retournée.
        On passe mxval=0, pour savoir comment dimensionner le vecteur résultat.
        """
        from Cata import cata
        lconcept = []
        klass = getattr(cata, typaster.lower().strip(), None)
        if klass:
            ctxt = self.parent.get_contexte_avant(self)
            lconcept = [(co.order, co.nom) for co in ctxt.values()
                        if issubclass(type(co), klass) and co.executed == 1]
            lconcept.sort()
            lconcept = [nom for order, nom in lconcept]
        nbval = len(lconcept)
        return nbval, tuple(lconcept)

    def getfac(self, nom_motfac):
        """
        - Retourne le nombre d occurences du mot cle facteur nom_motfac
          dans l'objet self : on examine les fils presents sinon on recherche dans
          les defauts.
        - est utilise par l'interface C-FORTRAN.
        """
        if CONTEXT.debug:
            prbanner("getfac %s " % (nom_motfac, ))
        nomfac = nom_motfac.strip()
        taille = 0
        for child in self.mc_liste:
            if child.nom == nomfac:
                if isinstance(child, N_MCFACT.MCFACT):
                    taille = 1
                    break
                elif isinstance(child, N_MCLIST.MCList):
                    taille = len(child.data)
                    break
                else:
                    raise AsException("incoherence de type dans getfac")
            elif isinstance(child, N_MCBLOC.MCBLOC):
                taille = child.getfac(nom_motfac)
                if taille:
                    break
        # On cherche si un mot cle par defaut existe
        if taille == 0:
            assert(hasattr(self, 'definition'))
            assert(hasattr(self.definition, 'entites'))
            if self.definition.entites.has_key(nomfac):
                assert isinstance(
                    self.definition.entites[nomfac], N_ENTITE.ENTITE)
                assert(hasattr(self.definition.entites[nomfac], 'statut'))
                if self.definition.entites[nomfac].statut == 'd':
                    taille = 1

        if taille == 0:
            # On verifie que la definition du mot-cle nom_motfac existe
            if self.getexm(nom_motfac, '') == 0:
                raise AsException("le mot clé facteur " + nom_motfac + " n existe pas "
                                  "dans le catalogue de la commande")

        if CONTEXT.debug:
            print '\tGETFAC : ', "taille =", taille
        return taille

    def get_mcsimp(self, nom_motfac, nom_motcle):
        """Fonction :
             retourne le mot-clé si :
                   - le mot-cle de nom nom_motcle existe dans le mot-cle facteur
                            de nom nom_motfac
                   - ou si le mot-cle de nom nom_motcle existe dans l'etape
                            self, dans ce cas nom_motfac est blanc (ou vide)
                   - ou si le mot-cle de nom nom_motfac existe dans l'etape
                            self, dans cas nom_motcle est blanc (ou vide).
             dans le cas contraire get_mcsimp retourne la valeur None.
        """
        if CONTEXT.debug:
            prbanner("get_mcsimp '%s' '%s' " % (nom_motfac, nom_motcle))

        nom_motfac = nom_motfac.strip()
        nom_motcle = nom_motcle.strip()
        assert(nom_motfac != "" or nom_motcle != "")

        mcsimp = None
        if nom_motfac == "":
            mcsimp = self.definition.get_entite(
                nom=nom_motcle, typ=N_SIMP.SIMP)
        else:
            if nom_motcle == "":
                # ici on recherche nom_motfac dans l'etape courante
                mcsimp = self.definition.get_entite(
                    nom=nom_motfac, typ=N_FACT.FACT)
            else:
                l_mot_fac = self.definition.getmcfs(nom_motfac)
                for mot_fac in l_mot_fac:
                    mcsimp = mot_fac.get_entite(
                        nom=nom_motcle, typ=N_SIMP.SIMP)
                    if mcsimp != None:
                        break
        return mcsimp

    def getexm(self, nom_motfac, nom_motcle):
        """ Fonction :
             retourne 1 si :
                   - le mot-cle de nom nom_motcle existe dans le mot-cle facteur
                            de nom nom_motfac
                   - ou si le mot-cle de nom nom_motcle existe dans l'etape
                            self, dans ce cas nom_motfac est blanc (ou vide)
                   - ou si le mot-cle de nom nom_motfac existe dans l'etape
                            self, dans cas nom_motcle est blanc (ou vide).
             dans le cas contraire getexm retourne la valeur 0.
        """
        if CONTEXT.debug:
            prbanner("getexm '%s' '%s' " % (nom_motfac, nom_motcle))

        presence = int(self.get_mcsimp(nom_motfac, nom_motcle) != None)
        if CONTEXT.debug:
            print '\tGETEXM : ', "presence = ", presence
        return presence

    def getvtx(self, nom_motfac, nom_motcle, iocc, mxval):
        """
            Cette méthode retourne la valeur du mot-clé simple nom_motcle de la commande self.
            Ce mot clé peut etre directement sous la commande (nom_motfac == "") ou sous
            un mot cle facteur (nom_motfac != "").
            Dans ce cas iocc indique le numéro du mot-clé facteur à utiliser
        """
        if CONTEXT.debug:
            prbanner("getvtx %s %s %d %d" %
                     (nom_motfac, nom_motcle, iocc, mxval))

        valeur = self.get_valeur_mc(nom_motfac, nom_motcle, iocc, mxval)

        if not self.check_text(valeur[1]):
            # elements de contexte
            print '! Etape  :', getattr(self, 'nom', '?'), '/', nom_motfac, '/', nom_motcle
            print '! Parent :', getattr(self.parent, 'nom', '?')
            print "! ERREUR incoherence fortran/catalogue de commande, " \
                  "chaine de caractères attendue et non :"
            print "!", valeur[1]
            raise AssertionError

        valeur = self.Traite_value(valeur, "TX")
        if CONTEXT.debug:
            B_utils.TraceGet('GETVTX', nom_motfac, iocc, nom_motcle, valeur)
            for k in valeur[1]:
                assert is_str(k)
        iarg = self.getdef(nom_motfac, nom_motcle, iocc)
        return valeur[0], valeur[1], iarg

    def get_valeur_mc(self, nom_motfac, nom_motcle, iocc, mxval):
        """
          Méthode générique pour retourner la valeur de nom_motfac/nom_motcle
        """
        nom_motfac = nom_motfac.strip()
        nom_motcle = nom_motcle.strip()
        valeur = self.get_valeur_motcle(nom_motfac, iocc, nom_motcle)
        if valeur == None:
            retval = 0, ()
        else:
            retval = B_utils.RETLIST(valeur, mxval)

        if CONTEXT.debug:
            print "\tget_valeur_mc : ", retval
        return retval

    def getdef(self, nom_motfac, nom_motcle, iocc):
        """Retourne 0 si le mot-clé a été renseigné par l'utilisateur,
        1 si c'est la valeur par défaut qui a été utilisée."""
        nom_motfac = nom_motfac.strip()
        nom_motcle = nom_motcle.strip()
        idef = 1   # absent ou defaut
        if nom_motfac not in ('', None):
            try:
                motfac = self.get_mocle(nom_motfac)[iocc]
                idef = int(
                    motfac.get_child(nom_motcle, restreint='oui') is None)
            except:
                pass
        else:
            try:
                idef = int(self.get_child(nom_motcle, restreint='oui') is None)
            except:
                pass
        return idef

    def get_valeur_motcle(self, nom_motfac, iocc, nom_motcle):
        """
            Cette méthode a pour but de retourner la valeur du MCS nom_motcle
            de la ième occurrence du MCF nom_motfac, en tenant compte des valeurs par défaut.
        """
        if self.getexm(nom_motfac, nom_motcle) == 0:
            raise AsException("le couple mcfact =" + nom_motfac + " mcsimp =" +
                              nom_motcle + " n existe pas dans le catalogue")

        if nom_motfac != None and nom_motfac != '':
        # on doit rechercher la ième occurrence du MCF nom_motfac
            try:
                motfac = self.get_mocle(nom_motfac)[iocc]
            except:
                if CONTEXT.debug:
                    print "\terreur à la recherche de :", nom_motfac
                    traceback.print_exc()
                return None

            try:
                return motfac.get_mocle(nom_motcle)
            except:
                if CONTEXT.debug:
                    print "\terreur à la recherche de :", nom_motcle
                    traceback.print_exc()
                return None
        else:
            try:
                return self.get_mocle(nom_motcle)
            except:
                if CONTEXT.debug:
                    print "\terreur à la recherche de :", nom_motcle
                    traceback.print_exc()
                return None

    def get_valeur_motcle_pour_getvid(self, nom_motfac, iocc, nom_motcle):
        """
          Cette méthode a pour but de retourner la valeur du MCS nom_motcle
          de la ième occurrence du MCF nom_motfac.
        """
        valeur = self.get_valeur_motcle(nom_motfac, iocc, nom_motcle)

        if valeur:
            chk = self.check_assd(valeur)
            if not chk:
                # elements de contexte
                print '! Etape  :', getattr(self, 'nom', '?'), '/', nom_motfac, '/', nom_motcle
                print '! Parent :', getattr(self.parent, 'nom', '?')
                print "! ERREUR incoherence fortran/catalogue de commande, concept attendu et non :"
                print "!", valeur
                raise AssertionError
            return self.transforme_valeur_nom(valeur)
        else:
            return None

    def transforme_valeur_nom(self, valeur):
        """
          Cette méthode a pour but de retourner soit une chaine de caractères représentant valeur
          (dans le cas ou valeur n'est pas une instance retourne la string valeur, sinon retourne valeur.nom)
          Traite le cas ou valeur est un tuple d'instances et retourne alors le tuple des strings
        """
        if isinstance(valeur, N_ASSD.ASSD):
            return valeur.nom
        elif is_sequence(valeur):
            l = []
            for obj in valeur:
                l.append(self.transforme_valeur_nom(obj))
            return tuple(l)
        else:
            return valeur

    def Traite_value(self, valeur, leType):
        """
          Classe  : B_ETAPE.ETAPE
          Methode : Traite_value
          INTENTION : Traitement du cas ou la donnee est un faux entier ou reel (classe entier et reel)
                      de accas.capy. L'attribut 'valeur' de la sd a été renseigné par la commande qui
                      l'a produite. C'est cette valeur qui est donc renvoyée ici.
        """
        if CONTEXT.debug:
            print "Traite_value: ", valeur
        if valeur[0] == 0:
            return valeur
        tup_avant = valeur[1]
        list_apres = []
        for k in tup_avant:
            if isinstance(k, N_ASSD.ASSD):
                k = k.valeur
            if is_sequence(k):
                if leType == "C8" and k[0] in ("MP", "RI"):
                    # on est en presence d'un complexe isolé
                    list_apres.append(k)
                else:
                    # on est en presence d'une liste de (R8, C8, IS, TX, LS)
                    list_apres.extend(k)
            else:
                # on est en presence d'un (R8, C8, IS, TX, LS) isolé
                list_apres.append(k)
        if valeur[0] < 0:
            # la longueur initiale etait superieure a mxval.
            # Elle ne peut qu'augmenter
            valeur_apres = (-len(list_apres), tuple(list_apres))
        else:
            valeur_apres = (len(list_apres), tuple(list_apres))

        return valeur_apres

    def check_values(self, func, values):
        """Vérifier que les éléments de 'values' sont du bon type (pour getvid, getvtx, getvr8).
        """
        ok = True
        if not is_sequence(values):
            values = [values, ]
        for v in values:
            if is_sequence(v):
                ok = self.check_values(func, v)
                continue
            ok = func(v)
            if not ok:
                break
        return ok

    def check_float(self, values):
        """Vérifier que les éléments de 'values' sont des réels (pour getvtx).
        """
        return self.check_values(is_float_or_int, values)

    def check_text(self, values):
        """Vérifier que les éléments de 'values' sont des chaines de caractères (pour getvtx).
        """
        return self.check_values(is_str, values)

    def check_assd(self, values):
        """Vérifier que les éléments de 'values' sont des concepts (pour getvid).
        """
        return self.check_values(is_assd, values)

    def retnom(self):
        """
            Methode B_ETAPE.ETAPE.retnom
            Auteur : Antoine Yessayan
            Intention : retourne au C le nom de la commande courante
        """
        return self.nom

    def getltx(self, nom_motfac, nom_motcle, iocc, mxval, taille):
        """
            Methode B_ETAPE.ETAPE.getltx
            Auteur : Antoine Tessayan
            Intention : récupérer dans un tuple la longueur des variables de type texte
                            du mocle nom_motcle
        """
        if CONTEXT.debug:
            prbanner("getltx %s %s %d %d" %
                     (nom_motfac, nom_motcle, iocc, mxval))
        # Recuperation des chaines elles memes
        nbval, tup, iarg = self.getvtx(nom_motfac, nom_motcle, iocc, mxval)
        # stockage des longueurs des chaines dans un tuple
        longueurs = []
        k = 0
        for chaine in tup:
            assert is_str(chaine)
            longueurs.append(min(len(chaine), taille))
            k = k + 1
        assert k == abs(nbval), (k, nbval, tup)
        if CONTEXT.debug:
            print "\tGETLTX : isval =", longueurs
        return nbval, tuple(longueurs)

    def getvis(self, nom_motfac, nom_motcle, iocc, mxval):
        """
            Methode B_ETAPE.ETAPE.getvis
            Auteur : Christian Carémoli
            Intention : récupérer la liste des valeurs entières pour le mot-cle passe
                            en argument (cette fonction traite les blocs)
        """
        if CONTEXT.debug:
            prbanner("getvis %s %s %d %d" %
                     (nom_motfac, nom_motcle, iocc, mxval))

        valeur = self.get_valeur_mc(nom_motfac, nom_motcle, iocc, mxval)
        valeur = self.Traite_value(valeur, "IS")
        if CONTEXT.debug:
            B_utils.TraceGet('GETVIS', nom_motfac, iocc, nom_motcle, valeur)
            for k in valeur[1]:
                assert is_int(k), type(k)
        iarg = self.getdef(nom_motfac, nom_motcle, iocc)
        return valeur[0], valeur[1], iarg

    def getoper(self):
        """ Toutes classes : ETAPE, PROC_ETAPE, MACRO_ETAPE
           retourne le numero de l operateur
        """
        assert self.definition.op is not None, "Numero (attribut op) de la commande non defini"
        return self.definition.op

    def getran(self):
        """
            Cette methode retourne un reel aleatoire
        """
        if self.jdc.alea == None:
            # le generateur n'a pas ete initialise, on l'initialise
            bidon = self.iniran(0)
        valeur = self.jdc.alea.random()
        resu = (valeur, )
        return resu

    def iniran(self, jump=0):
        """
            Cette methode initialise le generateur de nombres pseudo-aleatoires,
          et fait faire un saut de jump termes dans la suite de nombre.
        """
        from random import Random
        self.jdc.alea = Random(100)
        self.jdc.alea.jumpahead(jump)
        return None

    def fiintf(self, coderr, nom_fonction, nom_param, val):
        """Cette methode permet d'appeler une formule python depuis le fortran.
        Elle évalue les concepts FORMULE.
        coderr: comportement en cas d'erreur:
            'F': erreur fatale, 'A': alarme, ' ': silencieux (dans ce cas,
            il faut utiliser le code retour)
        nom_fonction: nom de la fonction
        nom_param: nom de ses paramètres
        val: valeurs des paramètres (même cardinal que nom_param)
        Elle retourne 2 valeurs : code_retour, valeur
        """
        def _print_msg(case, **kwargs):
            """Print the error message"""
            from Utilitai.Utmess import UTMESS
            if coderr.strip() == '':
                # silencieux
                return
            suite = coderr + '+'
            UTMESS(suite, 'FONCT0_9', valk=nom_fonction)
            # prend les messages dans le catalogues
            if case == 1:
                UTMESS(suite, 'FONCT0_67', **kwargs)
            elif case == 2:
                UTMESS(suite, 'FONCT0_68', **kwargs)
            elif case == 3:
                UTMESS(suite, 'FONCT0_69', **kwargs)
            elif case == 4:
                UTMESS(suite, 'FONCT0_70', **kwargs)
            UTMESS(coderr, 'FONCT0_52')

        nom_param = tuple([p.strip() for p in nom_param])
        self._cache_func = getattr(self, '_cache_func', {})
        self._cache_ctxt = getattr(self, '_cache_ctxt', (None, {}))

        if self._cache_func.get(nom_fonction):
            objet_sd = self._cache_func[nom_fonction]['fonction']
        else:
            # XXX ne fonctionne pas en poursuite (cf. zzzz100a)
            # objet_sd = self.get_concept(nom_fonction.strip())
            objet_sd = self.parent.get_sd_avant_etape(
                nom_fonction.strip(), self)
            self._cache_func[nom_fonction] = {'fonction': objet_sd}
        assert objet_sd is not None, "concept inconnu : %s" % nom_fonction.strip(
        )

        if len(nom_param) != len(val):
            _print_msg(1)
            return 4, None

        if self._cache_func.get(nom_fonction).get(nom_param):
            inter = self._cache_func[nom_fonction][nom_param]
        else:
            # paramètres manquants, paramètres en double
            miss, inter, dble = B_utils.miss_dble(objet_sd.nompar, nom_param)
            self._cache_func[nom_fonction][nom_param] = inter
            if len(miss) > 0:
                args = list(miss)
                args.sort()
                args = ', '.join([repr(nom) for nom in args])
                _print_msg(2, valk=args)
                return 4, None

            if len(dble) > 0:
                args = list(dble)
                args.sort()
                args = ', '.join(args)
                _print_msg(3, valk=args)
                return 4, None

        # appel de fonction definie dans le corps du jeu de commandes
        try:
            context = {}
            # mettre le contexte du parent de l'étape courante (INCLUDE par
            # exemple)
            last_etape, last_ctxt = self._cache_ctxt
            if last_etape != id(self):
                last_ctxt = {}
                last_ctxt.update(self.parent.get_contexte_avant(self))
                self._cache_ctxt = id(self), last_ctxt
            context = last_ctxt
            # récupération des constantes locales en cas de MACRO
            context.update(getattr(self.parent, 'macro_const_context', {}))
            # on reduit le dict au seul parametre de la formule
            dp = dict(zip(nom_param, val))
            for param in inter:
                context[param] = dp[param]
            res = eval(objet_sd.code, self.jdc.const_context, context)
        except:
            _print_msg(4, valk=traceback.format_exc())
            return 4, None
        return 0, res

    def getvr8(self, nom_motfac, nom_motcle, iocc, mxval):
        """
            Cette methode retourne la valeur du mot cle simple nom_motcle de type R8
        """
        if CONTEXT.debug:
            prbanner("getvr8 %s %s %d %d" %
                     (nom_motfac, nom_motcle, iocc, mxval))

        valeur = self.get_valeur_mc(nom_motfac, nom_motcle, iocc, mxval)
        valeur = self.Traite_value(valeur, "R8")
        if not self.check_float(valeur[1]):
            # elements de contexte
            print '! Etape  :', getattr(self, 'nom', '?'), '/', nom_motfac, '/', nom_motcle
            print '! Parent :', getattr(self.parent, 'nom', '?')
            print "! ERREUR incoherence fortran/catalogue de commande, réel attendu et non :"
            print "!", valeur[1]
            raise AssertionError

        if CONTEXT.debug:
            B_utils.TraceGet('GETVR8', nom_motfac, iocc, nom_motcle, valeur)
            for k in valeur[1]:
                assert is_float_or_int(k), `k` + " n'est pas un float"
        iarg = self.getdef(nom_motfac, nom_motcle, iocc)
        return valeur[0], valeur[1], iarg

    def getvc8(self, nom_motfac, nom_motcle, iocc, mxval):
        """
            Methode B_ETAPE.ETAPE.getvc8
            Auteurs : FR/AY
            Intention : récupérer la liste des valeurs complexes pour le mot-cle passe
                            en argument (cette fonction traite les blocs)
        """
        if CONTEXT.debug:
            prbanner("getvc8 %s %s %d %d" %
                     (nom_motfac, nom_motcle, iocc, mxval))

        valeur = self.get_valeur_mc(nom_motfac, nom_motcle, iocc, mxval)
        valeur = self.Traite_value(valeur, "C8")
        if CONTEXT.debug:
            B_utils.TraceGet('GETVC8', nom_motfac, iocc, nom_motcle, valeur)
        iarg = self.getdef(nom_motfac, nom_motcle, iocc)
        return valeur[0], valeur[1], iarg

    def getvid(self, nom_motfac, nom_motcle, iocc, mxval):
        """
          Methode B_ETAPE.ETAPE.getvid
          Auteur : Christian Carémoli
          Intention : récupérer la liste des valeurs pour le mot-cle passe
                      en argument (cette fonction traite les blocs)
        """
        if CONTEXT.debug:
            prbanner("getvid %s %s %d %d" %
                     (nom_motfac, nom_motcle, iocc, mxval))

        nom_motfac = nom_motfac.strip()
        nom_motcle = nom_motcle.strip()

        valeur = self.get_valeur_motcle_pour_getvid(
            nom_motfac, iocc, nom_motcle)
        if valeur == None:
            if CONTEXT.debug:
                print "\tGETVID : valeur =", None
            return 0, (), 1
        valeur = B_utils.CONVID(valeur)
        valeur = B_utils.RETLIST(valeur, mxval)
        if CONTEXT.debug:
            print "\tGETVID : valeur =", valeur
        iarg = self.getdef(nom_motfac, nom_motcle, iocc)
        return valeur[0], valeur[1], iarg

    def getvls(self, nom_motfac, nom_motcle, iocc, mxval):
        """
            Methode B_ETAPE.ETAPE.getvls
            Auteur : Christian Carémoli
            Intention : récupérer la liste des valeurs logiques pour le mot-cle passe
                            en argument (cette fonction traite les blocs)
        """
        if CONTEXT.debug:
            prbanner("getvls %s %s %d %d" %
                     (nom_motfac, nom_motcle, iocc, mxval))

        valeur = self.get_valeur_mc(nom_motfac, nom_motcle, iocc, mxval)
        valeur = self.Traite_value(valeur, "IS")
        # XXX est ce IS ou LS ????
        if CONTEXT.debug:
            B_utils.TraceGet('GETVLS', nom_motfac, iocc, nom_motcle, valeur)
            for k in valeur[1]:
                assert is_int(k)
        return valeur

    def gettvc(self, nom):
        """
        Entrees:
           nom    nom de la constante
        Sorties:
           val    valeur de la constante
           iret   indicateur d existence de la constante
                        > 0 la constante existe et a pour valeur val
                        = 0 la constante n'existe pas
            Fonction:
           Indiquer si la constante nom existe dans le contexte Python
           et si elle existe retourner sa valeur
        Commentaires:
           la fonction retourne un doublet iret, val
        """
        try:
            val = eval(nom, self.jdc.const_context, self.parent.g_context)
            if val is None:
                return 0, 0
            if isinstance(val, N_ASSD.ASSD):
                return self.getsdval(val)
            if val is not None:
                return 1, val
        except:
            if CONTEXT.debug:
                traceback.print_exc()
            pass
        return 0, 0

    def getsdval(self, sd):
        """
        Fonction:
              Retourne la valeur d'un concept produit (sd) si il a une valeur
        Entrees:
              sd concept produit
        Sorties:
              Un tuple de longueur 2
                - 1er element : indique si le concept sd a une valeur (0 = non, 1 = oui)
                - 2em element : la valeur du concept eventuelle
        """
        if sd.__class__.__name__ == 'reel':
            k = sd.etape['R8']
            return 1, k
        elif sd.__class__.__name__ == 'entier':
            k = sd.etape['IS']
            return 1, k
        else:
            return 0, 0

    def getmjm(self, motfac, iocc, nbval):
        """
            Retourne des informations sur le mot cle facteur motfac du catalogue de la commande nomcmd
           motfac   : nom du mot cle facteur
           iocc     : numero d occurence du mot cle facteur
         Retour:
           motcle : liste des sous mots cles
           typ    : liste des types des sous mots cles
           nbarg  : nombre total d arguments du mot cle facteur(a priori ne doit etre utilise que par le superviseur)
        """
        motfac = motfac.strip()
        if motfac != '':
            mcfact = self.get_mocle(motfac)
            if mcfact == None:
                return ([], [])
            else:
                mcfact = mcfact[iocc]
        else:
            mcfact = self
        # On a trouvé le mot cle facteur
        dico_mcsimp = mcfact.cree_dict_valeurs(mcfact.mc_liste)
        if self.nom == 'TEST_RESU' and dico_mcsimp.get('VALE_C') != None:
            pass
        lmc = []
        lty = []
        for name, obj in dico_mcsimp.items():
            if obj is None:
                continue
            lmc.append(name)
            if is_sequence(obj):
                obj = obj[0]
                # cas liste de complexes sous la forme RI/MP !
                if is_sequence(obj):
                    obj = obj[0]
            if isinstance(obj, (N_ASSD.ASSD, N_ENTITE.ENTITE, N_MCLIST.MCList)):
                lty.append(type(obj).__name__)
            if is_complex(obj):
                lty.append('C8')
            if is_float(obj):
                lty.append('R8')
            if is_str(obj):
                if obj.strip() in ('RI', 'MP'):
                    lty.append('C8')
                else:
                    lty.append('TX')
            if is_int(obj):
            # on gere le cas d un reel entre par l utilisateur sans le '.' distinctif d un entier
            # pour ca on teste la presence de R8 dans la liste des types
            # attendus cote catalogue
                child = mcfact.definition.get_entite(name)
                list_cata = B_utils.Typast(child.type)
                if ('IS ' not in list_cata) and ('R8 ' in list_cata):
                    lty.append('R8')
                elif ('IS ' not in list_cata) and ('C8 ' in list_cata):
                    lty.append('C8')
                else:
                    lty.append('I')
        assert len(lmc) == len(
            lty), "cardinalité différente : \n%s\n%s" % (lmc, lty)
        return (lmc, lty)

    def getmat(self):
        """
          Retourne :
                la liste des noms de mots cles facteur sous l etape
        """
        liste = self.getlfact()
        return (liste, )

    def getlfact(self):
        """
          Retourne :
                la liste des noms de mots cles facteurs sous l etape
        """
        liste = []
        for child in self.mc_liste:
            if isinstance(child, N_MCFACT.MCFACT):
                liste.append(child.nom)
            elif isinstance(child, N_MCLIST.MCList):
                liste.append(child[0].nom)
            elif isinstance(child, N_MCBLOC.MCBLOC):
                liste = liste + child.getlfact()
        return liste

    def gcucon(self, resul, concep):
        """
          Entrees:
                resul  nom du concept
                concep type du concept
          Sorties:
                iexnum indicateur d existence ( 1 = existe du bon type,
                                            0 = n'existe pas,
                                           -1 = existe d un autre type)
          Fonction:
                Retourner l indicateur d existence du concept vid avant
                la commande en cours
        """
        objet_sd = self.parent.get_sd_avant_etape(resul.strip(), self)
        if not objet_sd:
            ret = 0
        elif B_utils.Typast(AsType(objet_sd)).upper() == concep.strip():
            ret = 1
        else:
            ret = -1
        # message.debug(SUPERV, "gcucon(%s, '%s') returns %s", resul.strip(),
        # concep.strip(), ret)
        return ret

    def putvir(self, ival):
        """
          Sorties:
                indicateur sur le type ( 1 = le concept sortant est bien un 'entier',
                                         0 = mauvais type de concept)
          Fonction:
                renvoyer une valeur entière depuis le fortran vers l'attribut
                valeur de la sd 'entier'
        """
        if B_utils.Typast(AsType(self.sd)) != 'IS ':
            raise AsException(
                "Probleme dans putvir: %s, n est pas de type entier !" % (self.sd.nom))
            return 0
        self.sd.valeur = ival
        return 1

    def putvrr(self, rval):
        """
          Sorties:
                indicateur sur le type ( 1 = le concept sortant est bien un 'reel',
                                         0 = mauvais type de concept)
          Fonction:
                renvoyer une valeur entière depuis le fortran vers l'attribut
                valeur de la sd 'entier'
        """
        if B_utils.Typast(AsType(self.sd)) != 'R8 ':
            raise AsException(
                "Probleme dans putvrr: %s, n est pas de type reel !" % (self.sd.nom))
            return 0
        self.sd.valeur = rval
        return 1

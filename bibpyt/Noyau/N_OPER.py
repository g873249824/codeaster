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
    Ce module contient la classe de definition OPER
    qui permet de spécifier les caractéristiques d'un opérateur
"""

import types
import string
import traceback

import N_ENTITE
import N_ETAPE
import nommage
from strfunc import ufmt


class OPER(N_ENTITE.ENTITE):

    """
     Classe pour definir un opérateur

     Cette classe a trois attributs de classe

     - class_instance qui indique la classe qui devra etre utilisée
             pour créer l'objet qui servira à controler la conformité d'un
             opérateur avec sa définition

     - label qui indique la nature de l'objet de définition (ici, OPER)

     - nommage qui est un module Python qui fournit la fonctionnalité de nommage

     et les attributs d'instance suivants :

     - nom   : son nom

     - op   : le numéro d'opérateur

     - sd_prod : le type de concept produit. C'est une classe ou une fonction qui retourne
                       une classe

     - reentrant : vaut 'n' ou 'o'. Indique si l'opérateur est réentrant ou pas. Un opérateur
                         réentrant peut modifier un concept d'entrée et le produire comme concept de sortie

     - repetable : vaut 'n' ou 'o'. Indique si l'opérateur est répetable ou pas. Un opérateur
                         non répétable ne doit apparaitre qu'une fois dans une exécution. C'est du ressort
                         de l'objet gérant le contexte d'exécution de vérifier cette contrainte.

     - fr   : commentaire associé en francais

     - docu : clé de documentation associée

     - regles : liste des règles associées

     - op_init : cet attribut vaut None ou une fonction. Si cet attribut ne vaut pas None, cette
                       fonction est exécutée lors des phases d'initialisation de l'étape associée.

     - niveau : indique le niveau dans lequel est rangé l'opérateur. Les opérateurs peuvent etre
                      rangés par niveau. Ils apparaissent alors exclusivement dans leur niveau de rangement.
                      Si niveau vaut None, l'opérateur est rangé au niveau global.

     - entites : dictionnaire dans lequel sont stockés les sous entités de l'opérateur. Il s'agit
                       des entités de définition pour les mots-clés : FACT, BLOC, SIMP. Cet attribut
                       est initialisé avec args, c'est à dire les arguments d'appel restants.


    """
    class_instance = N_ETAPE.ETAPE
    label = 'OPER'
    nommage = nommage

    def __init__(self, nom, op, sd_prod, reentrant='n', repetable='o', fr="",
                 docu="", regles=(), op_init=None, niveau = None, **args):
        """
           Méthode d'initialisation de l'objet OPER. Les arguments sont utilisés pour initialiser
           les attributs de meme nom
        """
        self.nom = nom
        self.op = op
        self.sd_prod = sd_prod
        self.reentrant = reentrant
        self.fr = fr
        assert args.get('ang') is None, '"ang" does not exist anymore'
        assert args.get('UIinfo') is None, '"UIinfo" does not exist anymore'
        self.repetable = repetable
        self.docu = docu
        if type(regles) == types.TupleType:
            self.regles = regles
        else:
            self.regles = (regles,)
        # Attribut op_init : Fonction a appeler a la construction de l
        # operateur sauf si == None
        self.op_init = op_init
        self.entites = args
        current_cata = CONTEXT.get_current_cata()
        if niveau == None:
            self.niveau = None
            current_cata.enregistre(self)
        else:
            self.niveau = current_cata.get_niveau(niveau)
            self.niveau.enregistre(self)
        self.affecter_parente()
        self.check_definition(self.nom)

    def __call__(self, reuse=None, **args):
        """
            Construit l'objet ETAPE a partir de sa definition (self),
            puis demande la construction de ses sous-objets et du concept produit.
        """
        nomsd = self.nommage.GetNomConceptResultat(self.nom)
        etape = self.class_instance(oper=self, reuse=reuse, args=args)
        etape.McBuild()
        return etape.Build_sd(nomsd)

    def make_objet(self, mc_list='oui'):
        """
             Cette méthode crée l'objet ETAPE dont la définition est self sans
              l'enregistrer ni créer sa sdprod.
             Si l'argument mc_list vaut 'oui', elle déclenche en plus la construction
             des objets MCxxx.
        """
        etape = self.class_instance(oper=self, reuse=None, args={})
        if mc_list == 'oui':
            etape.McBuild()
        return etape

    def verif_cata(self, dummy=None):
        """
            Méthode de vérification des attributs de définition
        """
        self.check_regles()
        self.check_fr()
        self.check_reentrant()
        self.check_docu()
        self.check_nom()
        self.check_op(valmin=0)
        self.verif_cata_regles()

    def supprime(self):
        """
            Méthode pour supprimer les références arrières susceptibles de provoquer
            des cycles de références
        """
        self.niveau = None

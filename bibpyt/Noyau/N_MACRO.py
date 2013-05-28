# -*- coding: iso-8859-1 -*-
# person_in_charge: mathieu.courtois at edf.fr
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
#
#
# ======================================================================


"""
    Ce module contient la classe de definition MACRO
    qui permet de sp�cifier les caract�ristiques d'une macro-commande
"""

import types,string,traceback

import N_ENTITE
import N_MACRO_ETAPE
import nommage
from strfunc import ufmt

class MACRO(N_ENTITE.ENTITE):
   """
    Classe pour definir une macro-commande

    Cette classe a trois attributs de classe

    - class_instance qui indique la classe qui devra etre utilis�e
            pour cr�er l'objet qui servira � controler la conformit� d'un
            macro-commande avec sa d�finition

    - label qui indique la nature de l'objet de d�finition (ici, MACRO)

    - nommage qui est un module Python qui fournit la fonctionnalit� de nommage

    et les attributs d'instance suivants :

    - nom   : son nom

    - op   : le num�ro d'op�rateur

    - sd_prod : le type de concept produit. C'est une classe ou une fonction qui retourne
                      une classe

    - reentrant : vaut 'n' ou 'o'. Indique si l'op�rateur est r�entrant ou pas. Un op�rateur
                        r�entrant peut modifier un concept d'entr�e et le produire comme concept de sortie

    - repetable : vaut 'n' ou 'o'. Indique si l'op�rateur est r�petable ou pas. Un op�rateur
                        non r�p�table ne doit apparaitre qu'une fois dans une ex�cution. C'est du ressort
                        de l'objet g�rant le contexte d'ex�cution de v�rifier cette contrainte.

    - fr   : commentaire associ� en francais

    - ang : commentaire associ� en anglais

    - docu : cl� de documentation associ�e

    - regles : liste des r�gles associ�es

    - op_init : cet attribut vaut None ou une fonction. Si cet attribut ne vaut pas None, cette
                      fonction est ex�cut�e lors des phases d'initialisation de l'�tape associ�e.

    - niveau : indique le niveau dans lequel est rang� l'op�rateur. Les op�rateurs peuvent etre
                     rang�s par niveau. Ils apparaissent alors exclusivement dans leur niveau de rangement.
                     Si niveau vaut None, l'op�rateur est rang� au niveau global.

    - entites : dictionnaire dans lequel sont stock�s les sous entit�s de l'op�rateur. Il s'agit
                      des entit�s de d�finition pour les mots-cl�s : FACT, BLOC, SIMP. Cet attribut
                      est initialis� avec args, c'est � dire les arguments d'appel restants.


   """
   class_instance = N_MACRO_ETAPE.MACRO_ETAPE
   label = 'MACRO'
   nommage = nommage

   def __init__(self,nom,op,sd_prod=None,reentrant='n',repetable='o',fr="",ang="",
                docu="",regles=(),op_init=None,niveau = None,fichier_ini=0,UIinfo=None,**args):
      """
         M�thode d'initialisation de l'objet MACRO. Les arguments sont utilis�s pour initialiser
         les attributs de meme nom
      """
      # XXX fichier_ini n'est pas utilis� pour l'instant
      self.nom=nom
      # op est obligatoire et permet de sp�cifier la proc�dure de construction de la macro
      # - Si op est un entier la construction de la macro est r�alis�e par une subroutine fortran opsxxx ou
      # xxx est donn� par la valeur absolue de op. L'execution est egalement effectu�e via cette subroutine.
      # - Si op est une fonction Python, la construction de la macro est effectu�e par l'appel � cette fonction
      # Suivant le cas on garde l info dans self.op ou dans self.proc
      if type(op) == types.IntType:
        self.proc=None
        self.op=op
      else:
        self.op=None
        self.proc=op

      self.sd_prod=sd_prod
      self.reentrant=reentrant
      self.fr=fr
      self.ang=ang
      self.repetable = repetable
      self.docu=docu
      if type(regles)== types.TupleType:
          self.regles=regles
      else:
          self.regles=(regles,)
      self.fichier_ini = fichier_ini
      # Attribut op_init : Fonction a appeler a la construction de l operateur sauf si == None
      self.op_init=op_init
      self.entites = args
      current_cata=CONTEXT.get_current_cata()
      if niveau == None:
         self.niveau=None
         current_cata.enregistre(self)
      else:
         self.niveau=current_cata.get_niveau(niveau)
         self.niveau.enregistre(self)
      self.UIinfo=UIinfo
      self.affecter_parente()
      self.check_definition(self.nom)

   def __call__(self,reuse=None,**args):
      """
          Construit l'objet MACRO_ETAPE a partir de sa definition (self),
          puis demande la construction de ses sous-objets et du concept produit.
      """
      nomsd = self.nommage.GetNomConceptResultat(self.nom)
      etape = self.class_instance(oper=self,reuse=reuse,args=args)
      etape.McBuild()
      return etape.Build_sd(nomsd)

   def make_objet(self,mc_list='oui'):
      """
           Cette m�thode cr�e l'objet MACRO_ETAPE dont la d�finition est self sans
           cr�er sa sdprod.
           Normalement l'�tape est enregistr�e aupr�s de son parent.
           Si l'argument mc_list vaut 'oui', elle d�clenche en plus la construction
           des objets MCxxx.
      """
      etape= self.class_instance(oper=self,reuse=None,args={})
      if mc_list == 'oui':etape.McBuild()
      return etape

   def verif_cata(self):
      """
          M�thode de v�rification des attributs de d�finition
      """
      self.check_op(valmax=0)
      self.check_proc()
      self.check_regles()
      self.check_fr()
      self.check_docu()
      self.check_nom()
      self.check_reentrant()
      self.verif_cata_regles()

   def supprime(self):
      """
          M�thode pour supprimer les r�f�rences arri�res susceptibles de provoquer
          des cycles de r�f�rences
      """
      self.niveau=None

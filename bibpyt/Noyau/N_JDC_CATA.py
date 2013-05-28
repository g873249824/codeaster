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
    Ce module contient la classe de definition JDC_CATA
    qui permet de sp�cifier les caract�ristiques d'un JDC
"""

import types,string,traceback

import N_ENTITE
import N_JDC
from strfunc import ufmt

class JDC_CATA(N_ENTITE.ENTITE):
   """
    Classe pour definir un jeu de commandes

    Attributs de classe :

    - class_instance qui indique la classe qui devra etre utilis�e
            pour cr�er l'objet qui servira � controler la conformit�
            du jeu de commandes avec sa d�finition

    - label qui indique la nature de l'objet de d�finition (ici, JDC)

   """
   class_instance = N_JDC.JDC
   label = 'JDC'

   def __init__(self,code='',execmodul=None,regles=(),niveaux=(),**args):
      """
      """
      self.code = code
      self.execmodul=execmodul
      if type(regles)== types.TupleType:
        self.regles = regles
      else:
        self.regles=(regles,)
      # Tous les arguments suppl�mentaires sont stock�s dans l'attribut args
      # et seront pass�s au JDC pour initialiser ses param�tres propres
      self.args=args
      self.d_niveaux={}
      self.l_niveaux=niveaux
      self.commandes=[]
      for niveau in niveaux:
         self.d_niveaux[niveau.nom]=niveau
      # On change d'objet catalogue. Il faut d'abord mettre le catalogue
      # courant � None
      CONTEXT.unset_current_cata()
      CONTEXT.set_current_cata(self)

   def __call__(self,procedure=None,cata=None,cata_ord_dico=None,
                     nom='SansNom',parent=None,**args):
      """
          Construit l'objet JDC a partir de sa definition (self),
      """
      return self.class_instance(definition=self,procedure=procedure,
                         cata=cata,cata_ord_dico=cata_ord_dico,
                         nom=nom,
                         parent=parent,
                         **args
                         )

   def enregistre(self,commande):
      """
         Methode qui permet aux definitions de commandes de s'enregistrer aupres
         d'un JDC_CATA
      """
      self.commandes.append(commande)

   def verif_cata(self):
      """
          M�thode de v�rification des attributs de d�finition
      """
      self.check_regles()
      self.verif_cata_regles()

   def verif_cata_regles(self):
      """
         Cette m�thode v�rifie pour tous les objets stock�s dans la liste entit�s
         respectent les REGLES associ�s  � self
      """
      # A FAIRE

   def report(self):
      """
         Methode pour produire un compte-rendu de validation d'un catalogue de commandes
      """
      self.cr = self.CR(debut = u"Compte-rendu de validation du catalogue "+self.code,
                        fin = u"Fin Compte-rendu de validation du catalogue "+self.code)
      self.verif_cata()
      for commande in self.commandes:
        cr = commande.report()
        cr.debut = u"D�but Commande :"+commande.nom
        cr.fin = u"Fin commande :"+commande.nom
        self.cr.add(cr)
      return self.cr

   def supprime(self):
      """
          M�thode pour supprimer les r�f�rences arri�res susceptibles de provoquer
          des cycles de r�f�rences
      """
      for commande in self.commandes:
         commande.supprime()

   def get_niveau(self,nom_niveau):
      """
           Retourne l'objet de type NIVEAU de nom nom_niveau
           ou None s'il n'existe pas
      """
      return self.d_niveaux.get(nom_niveau,None)

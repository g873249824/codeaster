#@ MODIF N_MCBLOC Noyau  DATE 03/09/2002   AUTEUR GNICOLAS G.NICOLAS 
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
    Ce module contient la classe MCBLOC qui sert � controler la valeur
    d'un bloc de mots-cl�s par rapport � sa d�finition port�e par un objet
    de type ENTITE
"""

import types

import N_MCCOMPO

class MCBLOC(N_MCCOMPO.MCCOMPO):
   """
      Classe support d'un bloc de mots-cl�s.
  
   """

   nature = "MCBLOC"
   def __init__(self,val,definition,nom,parent):
      """
         Attributs :

          - val : valeur du bloc (dictionnaire dont les cl�s sont des noms de mots-cl�s et les valeurs
                  les valeurs des mots-cl�s)

          - definition : objet de d�finition de type BLOC associ� au bloc (porte les attributs de d�finition)

          - nom : nom du bloc. Ce nom lui est donn� par celui qui cr�e le bloc de mot-cl�

          - parent : le cr�ateur du bloc. Ce peut etre un mot-cl� facteur ou un autre objet composite de type
                     OBJECT. Si parent vaut None, le bloc ne poss�de pas de contexte englobant.

          - mc_liste : liste des sous-objets du bloc construite par appel � la m�thode build_mc

      """
      self.definition=definition
      self.nom=nom
      self.val = val
      self.parent = parent
      self.valeur = val
      if parent :
         self.jdc = self.parent.jdc
         self.niveau = self.parent.niveau
         self.etape = self.parent.etape
      else:
         # Le mot cle a �t� cr�� sans parent
         self.jdc = None
         self.niveau = None
         self.etape = None
      self.mc_liste=self.build_mc()
         
   def get_valeur(self):
      """
         Retourne la "valeur" de l'objet bloc. Il s'agit d'un dictionnaire dont
         les cl�s seront les noms des objets de self.mc_liste et les valeurs
         les valeurs des objets de self.mc_liste obtenues par application de 
         la m�thode get_valeur.

         Dans le cas particulier d'un objet bloc les �l�ments du dictionnaire
         obtenu par appel de la m�thode get_valeur sont int�gr�s au niveau
         sup�rieur.
          
      """
      dico={}
      for v in self.mc_liste:
        val = v.get_valeur()
        if type(val)==types.DictionaryType:
          for i,w in val.items():
            dico[i]=w
        else :
          dico[v.nom]=val
      return dico
  
   def isBLOC(self):
      """
          Indique si l'objet est un BLOC
      """
      return 1

   def accept(self,visitor):
      """
         Cette methode permet de parcourir l'arborescence des objets
         en utilisant le pattern VISITEUR
      """
      visitor.visitMCBLOC(self)

   def makeobjet(self):
      return self.definition(val = None,  nom = self.nom,parent = self.parent)

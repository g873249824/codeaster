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
    Ce module contient la classe mere pour les classes de definition des regles d exclusion.

    La classe REGLE est la classe de base : elle est virtuelle, elle ne doit pas etre instanciee.

    Les classes regles d�riv�es qui seront instanci�es doivent implementer la methode verif
    dont l argument est le dictionnaire des mots cles effectivement presents
    sur lesquels sera operee la verification de la regle

    A la creation de l'objet regle on lui passe la liste des noms de mots cles concernes

    Exemple ::

    # Cr�ation de l'objet r�gle UNPARMI
    r=UNPARMI("INFO","AFFE")
    # V�rification de la r�gle r sur le dictionnaire pass� en argument
    r.verif({"INFO":v1,"AFFE":v2)
"""

import types

class REGLE:
   def __init__(self,*args):
      """
          Les classes d�riv�es peuvent utiliser cet initialiseur par d�faut ou
          le surcharger
      """
      self.mcs=args

   def verif(self,args):
      """
         Les classes d�riv�es doivent impl�menter cette m�thode
         qui doit retourner une paire dont le premier �l�ment est une chaine de caract�re
         et le deuxi�me un entier.
 
         L'entier peut valoir 0 ou 1. -- s'il vaut 1, la r�gle est v�rifi�e
          s'il vaut 0, la r�gle n'est pas v�rifi�e et le texte joint contient
         un commentaire de la non validit�.
      """
      raise NotImplementedError('class REGLE should be derived')

   def liste_to_dico(self,args):
      """
         Cette m�thode est utilitaire pour les seuls besoins
         des classes d�riv�es. 

         Elle transforme une liste de noms de mots cl�s en un 
         dictionnaire �quivalent dont les cl�s sont les noms des mts-cl�s

         Ceci permet d'avoir un traitement identique pour les listes et les dictionnaires
      """
      if type(args) == types.DictionaryType:
        return args
      elif type(args) == types.ListType:
        dico={}
        for arg in args :
          dico[arg]=0
        return dico
      else :
        raise Exception("Erreur ce n'est ni un dictionnaire ni une liste %s" % args)

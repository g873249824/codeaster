#@ MODIF N_MCSIMP Noyau  DATE 03/09/2002   AUTEUR GNICOLAS G.NICOLAS 
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
    Ce module contient la classe MCSIMP qui sert � controler la valeur
    d'un mot-cl� simple par rapport � sa d�finition port�e par un objet
    de type ENTITE
"""

import types
from copy import copy

from Noyau.N_ASSD import ASSD,assd
import N_OBJECT

class MCSIMP(N_OBJECT.OBJECT):
   """
   """
   nature = 'MCSIMP'
   def __init__(self,val,definition,nom,parent):
      """
         Attributs :

          - val : valeur du mot cl� simple

          - definition

          - nom

          - parent

        Autres attributs :

          - valeur : valeur du mot-cl� simple en tenant compte de la valeur par d�faut

      """
      self.definition=definition
      self.nom=nom
      self.val = val
      self.parent = parent
      self.valeur = self.GETVAL(self.val)
      if parent :
         self.jdc = self.parent.jdc
         self.niveau = self.parent.niveau
         self.etape = self.parent.etape
      else:
         # Le mot cle simple a �t� cr�� sans parent
         self.jdc = None
         self.niveau = None
         self.etape = None
         
   def GETVAL(self,val):
      """ 
          Retourne la valeur effective du mot-cl� en fonction
          de la valeur donn�e. Defaut si val == None
      """
      if (val is None and hasattr(self.definition,'defaut')) :
        return self.definition.defaut
      else:
        return val

   def get_valeur(self):
      """
          Retourne la "valeur" d'un mot-cl� simple.
          Cette valeur est utilis�e lors de la cr�ation d'un contexte 
          d'�valuation d'expressions � l'aide d'un interpr�teur Python
      """
      return self.valeur

   def get_val(self):
      """
          Une autre m�thode qui retourne une "autre" valeur du mot cl� simple.
          Elle est utilis�e par la m�thode get_mocle
      """
      return self.valeur

   def accept(self,visitor):
      """
         Cette methode permet de parcourir l'arborescence des objets
         en utilisant le pattern VISITEUR
      """
      visitor.visitMCSIMP(self)

   def copy(self):
    """ Retourne une copie de self """
    objet = self.makeobjet()
    # il faut copier les listes et les tuples mais pas les autres valeurs
    # possibles (r�el,SD,...)
    if type(self.valeur) in (types.ListType,types.TupleType):
       objet.valeur = copy(self.valeur)
    else:
       objet.valeur = self.valeur
    objet.val = objet.valeur
    return objet

   def makeobjet(self):
    return self.definition(val = None, nom = self.nom,parent = self.parent)

   def reparent(self,parent):
     """
         Cette methode sert a reinitialiser la parente de l'objet
     """
     self.parent=parent
     self.jdc=parent.jdc
     self.etape=parent.etape

   def get_sd_utilisees(self):
    """ 
        Retourne une liste qui contient la SD utilis�e par self si c'est le cas
        ou alors une liste vide
    """
    l=[]
    if type(self.valeur) == types.InstanceType:
      #XXX Est ce diff�rent de isinstance(self.valeur,ASSD) ??
      if issubclass(self.valeur.__class__,ASSD) : l.append(self.valeur)
    elif type(self.valeur) in (types.TupleType,types.ListType):
      for val in self.valeur :
         if type(val) == types.InstanceType:
            if issubclass(val.__class__,ASSD) : l.append(val)
    return l

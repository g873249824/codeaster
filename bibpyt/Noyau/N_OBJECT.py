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
    Ce module contient la classe OBJECT classe m�re de tous les objets
    servant � controler les valeurs par rapport aux d�finitions
"""
from N_CR import CR
from strfunc import ufmt

class OBJECT:
   """
      Classe OBJECT : cette classe est virtuelle et sert de classe m�re
      aux classes de type ETAPE et MOCLES.
      Elle ne peut etre instanci�e.
      Une sous classe doit obligatoirement impl�menter les m�thodes :

      - __init__

   """

   def get_etape(self):
      """
         Retourne l'�tape � laquelle appartient self
         Un objet de la cat�gorie etape doit retourner self pour indiquer que
         l'�tape a �t� trouv�e
         XXX double emploi avec self.etape ???
      """
      if self.parent == None: return None
      return self.parent.get_etape()

   def supprime(self):
      """
         M�thode qui supprime les r�f�rences arri�res suffisantes pour
         que l'objet puisse etre correctement d�truit par le
         garbage collector
      """
      self.parent = None
      self.etape = None
      self.jdc = None
      self.niveau = None

   def get_val(self):
      """
          Retourne la valeur de l'objet. Cette m�thode fournit
          une valeur par defaut. Elle doit etre d�riv�e pour chaque
          type d'objet
      """
      return self

   def isBLOC(self):
      """
          Indique si l'objet est un BLOC
      """
      return 0

   def get_jdc_root(self):
      """
          Cette m�thode doit retourner l'objet racine c'est � dire celui qui
          n'a pas de parent
      """
      if self.parent:
         return self.parent.get_jdc_root()
      else:
         return self

   def GETVAL(self,val):
      """
          Retourne la valeur effective du mot-cl� en fonction
          de la valeur donn�e. Defaut si val == None
      """
      if (val is None and hasattr(self.definition,'defaut')) :
        return self.definition.defaut
      else:
        return val

   def reparent(self,parent):
      """
         Cette methode sert a reinitialiser la parente de l'objet
      """
      self.parent=parent
      self.jdc=parent.jdc

class ErrorObj(OBJECT):
    """Classe pour objets errones : emule le comportement d'un objet tel mcsimp ou mcfact
    """
    def __init__(self,definition,valeur,parent,nom="err"):
        self.nom=nom
        self.definition=definition
        self.valeur=valeur
        self.parent=parent
        self.mc_liste=[]
        if parent :
            self.jdc = self.parent.jdc
            #self.niveau = self.parent.niveau
            #self.etape = self.parent.etape
        else:
            # Pas de parent
            self.jdc = None
            #self.niveau = None
            #self.etape = None
    def isvalid(self,cr='non'):
        return 0

    def report(self):
      """ g�n�re le rapport de validation de self """
      self.cr=CR()
      self.cr.debut = u"Mot-cl� invalide : "+self.nom
      self.cr.fin = u"Fin Mot-cl� invalide : "+self.nom
      self.cr.fatal(_(u"Type non autoris� pour le mot-cl� %s : '%s'"),
                        self.nom, self.valeur)
      return self.cr

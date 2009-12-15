#@ MODIF N_ASSD Noyau  DATE 14/12/2009   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
# RESPONSABLE COURTOIS M.COURTOIS
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

"""

class ASSD(object):
   """
      Classe de base pour definir des types de structures de donnees ASTER
      equivalent d un concept ASTER
   """
   idracine="SD"

   def __init__(self,etape=None,sd=None,reg='oui'):
      """
        reg est un param�tre qui vaut oui ou non :
          - si oui (d�faut) : on enregistre la SD aupr�s du JDC
          - si non : on ne l'enregistre pas
      """
      self.etape=etape
      self.sd=sd
      self.nom=None
      if etape:
        self.parent=etape.parent
      else:
        self.parent=CONTEXT.get_current_step()
      if self.parent :
         self.jdc = self.parent.get_jdc_root()
      else:
         self.jdc = None

      if not self.parent:
        self.id=None
      elif reg == 'oui' :
        self.id = self.parent.reg_sd(self)
      else :
        self.id = self.parent.o_register(self)
      # permet de savoir si le concept a �t� calcul� (1) ou non (0)
      self.executed = 0
      
   def __getitem__(self,key):
      return self.etape[key]
   
   def set_name(self, nom):
      """Positionne le nom de self (et appelle sd_init)
      """
      self.nom = nom
      # initialise la partie "sd" (pas pour entier, reel, formule)
      sup = super(ASSD, self)
      if hasattr(sup, 'nomj'):   # == AsBase
         sup.__init__(nomj=nom)
      self.reparent_sd()
   
   def reparent_sd(self):
      """Repositionne le parent des attributs de la SD associ�e.
      """
      sup = super(ASSD, self)
      if hasattr(sup, 'nomj'):   # == AsBase
         sup.reparent(None, None)

   def get_name(self):
      """
          Retourne le nom de self, �ventuellement en le demandant au JDC
      """
      if not self.nom :
         try:
            self.nom=self.parent.get_name(self) or self.id
         except:
            self.nom=""
      if self.nom.find('sansnom') != -1 or self.nom == '':
         self.nom = self.id
      return self.nom

   def supprime(self):
      """ 
          Cassage des boucles de r�f�rences pour destruction du JDC 
      """
      self.etape = None
      self.sd = None
      self.jdc = None
      self.parent = None

   def accept(self,visitor):
      """
         Cette methode permet de parcourir l'arborescence des objets
         en utilisant le pattern VISITEUR
      """
      visitor.visitASSD(self)

   def __getstate__(self):
      """
          Cette methode permet de pickler les objets ASSD
          Ceci est possible car on coupe les liens avec les objets
          parent, etape et jdc qui conduiraient � pickler de nombreux 
          objets inutiles ou non picklables.
      """
      d=self.__dict__.copy()
      for key in ('parent','etape','jdc'):
          if d.has_key(key):del d[key]
      for key in d.keys():
          if key[0]=='_':del d[key]
      return d


   def accessible(self):
      """Dit si on peut acceder aux "valeurs" (jeveux) de l'ASSD.
      """
      if CONTEXT.debug: print '| accessible ?', self.nom
      is_accessible = CONTEXT.get_current_step().sd_accessible()
      if CONTEXT.debug: print '  `- is_accessible =', repr(is_accessible)
      return is_accessible


   def par_lot(self):
      """Conserver uniquement pour la compatibilite avec le catalogue v9 dans eficas.
      """
      #XXX eficas
      if not hasattr(self, 'jdc') or self.jdc == None:
         val = None
      else:
         val = self.jdc.par_lot
      return val == 'OUI'


class assd(ASSD):
   def __convert__(cls,valeur):
      return valeur
   __convert__=classmethod(__convert__)

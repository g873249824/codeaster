#@ MODIF N_ENTITE Noyau  DATE 14/09/2004   AUTEUR MCOURTOI M.COURTOIS 
# -*- coding: iso-8859-1 -*-
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
    Ce module contient la classe ENTITE qui est la classe de base
    de toutes les classes de definition d'EFICAS.
"""

import N_CR
import N_VALIDATOR

class ENTITE:
   """
      Classe de base pour tous les objets de definition : mots cles et commandes
      Cette classe ne contient que des methodes utilitaires
      Elle ne peut etre instanciee et doit d abord etre specialisee
   """
   CR=N_CR.CR
   factories={'validator':N_VALIDATOR.validatorFactory}

   def __init__(self,validators=None):
      """
         Initialise les deux attributs regles et entites d'une classe d�riv�e
         � : pas de r�gles et pas de sous-entit�s.
        
         L'attribut regles doit contenir la liste des regles qui s'appliquent 
         sur ses sous-entit�s

         L'attribut entit�s doit contenir le dictionnaires des sous-entit�s 
         (cl� = nom, valeur=objet)
      """
      self.regles=()
      self.entites={}
      if validators:
         self.validators=self.factories['validator'](validators)
      else:
         self.validators=validators

   def affecter_parente(self):
      """
          Cette methode a pour fonction de donner un nom et un pere aux
          sous entit�s qui n'ont aucun moyen pour atteindre leur parent 
          directement
          Il s'agit principalement des mots cles 
      """
      for k,v in self.entites.items():
        v.pere = self
        v.nom = k

   def verif_cata(self):
      """
          Cette methode sert � valider les attributs de l'objet de d�finition
      """
      raise "La m�thode verif_cata de la classe %s doit etre impl�ment�e" % self.__class__.__name__

   def __call__(self):
      """
          Cette methode doit retourner un objet d�riv� de la classe OBJECT
      """
      raise "La m�thode __call__ de la classe %s doit etre impl�ment�e" % self.__class__.__name__

   def report(self):
      """
         Cette m�thode construit pour tous les objets d�riv�s de ENTITE un 
         rapport de validation de la d�finition port�e par cet objet
      """
      self.cr = self.CR()
      self.verif_cata()
      for k,v in self.entites.items() :
         try :
            cr = v.report()
            cr.debut = "D�but "+v.__class__.__name__+ ' : ' + k
            cr.fin = "Fin "+v.__class__.__name__+ ' : ' + k
            self.cr.add(cr)
         except:
            self.cr.fatal("Impossible d'obtenir le rapport de %s %s" %(k,`v`))
            print "Impossible d'obtenir le rapport de %s %s" %(k,`v`)
            print "p�re =",self
      return self.cr

   def verif_cata_regles(self):
      """
         Cette m�thode v�rifie pour tous les objets d�riv�s de ENTITE que 
         les objets REGLES associ�s ne portent que sur des sous-entit�s 
         existantes
      """
      for regle in self.regles :
        l=[]
        for mc in regle.mcs :
          if not self.entites.has_key(mc) :
            l.append(mc)
        if l != [] :
          txt = str(regle)
          self.cr.fatal("Argument(s) non permis : %s pour la r�gle : %s" %(`l`,txt))



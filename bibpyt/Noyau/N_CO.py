#@ MODIF N_CO Noyau  DATE 07/09/2009   AUTEUR COURTOIS M.COURTOIS 
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


from N_ASSD import ASSD
from N_Exception import AsException
from N_VALIDATOR import ValError
import N_utils

from asojb import AsBase

class CO(ASSD, AsBase):
   def __init__(self,nom):
      ASSD.__init__(self,etape=None,sd=None,reg='oui')
      #
      #  On demande le nommage du concept
      #
      if self.parent : 
         try:
            self.parent.NommerSdprod(self,nom)
         except AsException,e:
            appel=N_utils.callee_where(niveau=2)
            raise AsException("Concept CO, fichier: ",appel[1]," ligne : ",appel[0],'\n',e)
      else:
         self.nom=nom

   def __convert__(cls,valeur):
         if hasattr(valeur,'_etape') :
            # valeur est un concept CO qui a ete transforme par type_sdprod
            if valeur.etape == valeur._etape:
               # le concept est bien produit par l'etape
               return valeur
         raise ValError("Pas un concept CO")
   __convert__=classmethod(__convert__)

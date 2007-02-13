#@ MODIF co_maillage SD  DATE 13/02/2007   AUTEUR PELLET J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
# ======================================================================

import Accas
from SD import *
from sd_maillage import sd_maillage

# -----------------------------------------------------------------------------
class maillage_sdaster(ASSD, sd_maillage):
   def LIST_GROUP_NO(self) :
      """ retourne la liste des groupes de noeuds sous la forme :
        [ (gno1, nb noeuds  gno1), ...] """
      if self.par_lot() :
         raise Accas.AsException("Erreur dans maillage.LIST_GROUP_NO en PAR_LOT='OUI'")
      nommail=self.get_name()
      dic_gpno=aster.getcolljev(nommail.ljust(8)+".GROUPENO")
      #dic_gpno = self.GROUPENO.get()
      return [(gpno.strip(),len(dic_gpno[gpno])) for gpno in dic_gpno]

   def LIST_GROUP_MA(self) :
      """ retourne la liste des groupes de mailles sous la forme :
        [ (gma1, nb mailles gma1, dime max des mailles gma1), ...] """
      if self.par_lot() :
         raise Accas.AsException("Erreur dans maillage.LIST_GROUP_MA en PAR_LOT='OUI'")
      nommail=self.get_name()
      nommail=nommail.ljust(8)
      ngpma=[]
      ltyma =aster.getvectjev("&CATA.TM.NOMTM")
      catama=aster.getcolljev("&CATA.TM.TMDIM")
      dic_gpma=aster.getcolljev(nommail+".GROUPEMA")
      dimama=[catama[ltyma[ma-1]][0] for ma in aster.getvectjev(nommail+".TYPMAIL")]
      for grp in dic_gpma.keys():
         dim=max([dimama[ma-1] for ma in dic_gpma[grp]])
         ngpma.append((grp.strip(),len(dic_gpma[grp]),dim))
      return ngpma


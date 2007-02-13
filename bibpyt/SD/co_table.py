#@ MODIF co_table SD  DATE 13/02/2007   AUTEUR PELLET J.PELLET 
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
from sd_table import sd_table

# -----------------------------------------------------------------------------
class table_sdaster(ASSD, sd_table):
   def __getitem__(self,key):
      from Utilitai.Utmess import UTMESS
      if self.par_lot():
         raise Accas.AsException("Erreur dans table.__getitem__ en PAR_LOT='OUI'")
      requete = '%-24s' % key[0]
      tblp = '%-19s.TBLP' % self.get_name()
      tabnom = aster.getvectjev(tblp)
      #tabnom = self.TBLP.get()
      if tabnom == None:
         UTMESS('F', 'TABLE[]', "Objet '%s' inexistant" % tblp)
      for i in range(len(tabnom)) :
         if tabnom[i]==requete: break
      resu=aster.getvectjev(tabnom[i+2])
      if resu == None:
         UTMESS('F', 'TABLE[]', "Objet '%s' inexistant" % tabnom[i+2])
      exist=aster.getvectjev(tabnom[i+3])
      if exist == None:
         UTMESS('F', 'TABLE[]', "Objet '%s' inexistant" % tabnom[i+3])
      if key[1]>len(resu) or exist[key[1]-1]==0:
         raise KeyError
      else:
         return resu[key[1]-1]

   def TITRE(self):
      """Retourne le titre d'une table Aster
      (Utile pour r�cup�rer le titre et uniquement le titre d'une table dont
      on souhaite manipuler la d�riv�e).
      """
      if self.par_lot():
         raise Accas.AsException("Erreur dans table.TITRE en PAR_LOT='OUI'")
      titj = aster.getvectjev('%-19s.TITR' % self.get_name())
      #titj = self.TITR.get()
      if titj != None:
         titr = '\n'.join(titj)
      else:
         titr = ''
      return titr

   def EXTR_TABLE(self) :
      """Produit un objet Table � partir du contenu d'une table Aster
      """
      def Nonefy(l1,l2) :
          if l2==0 : return None
          else     : return l1
      if self.par_lot():
         raise Accas.AsException("Erreur dans table.EXTR_TABLE en PAR_LOT='OUI'")
      from Utilitai.Table import Table
      # titre
      titr = self.TITRE()
      # r�cup�ration des param�tres
      v_tblp = aster.getvectjev('%-19s.TBLP' % self.get_name())
      #v_tblp = self.TBLP.get()
      if v_tblp == None:
         # retourne une table vide
         return Table(titr=titr)
      tabnom=list(v_tblp)
      nparam=len(tabnom)/4
      lparam=[tabnom[4*i:4*i+4] for i in range(nparam)]
      dval={}
      # liste des param�tres et des types
      lpar=[]
      ltyp=[]
      for i in lparam :
         value=list(aster.getvectjev(i[2]))
         exist=aster.getvectjev(i[3])
         dval[i[0].strip()] = map(Nonefy,value,exist)
         lpar.append(i[0].strip())
         ltyp.append(i[1].strip())
      n=len(dval[lpar[0]])
      # contenu : liste de dict
      lisdic=[]
      for i in range(n) :
        d={}
        for p in lpar:
           d[p]=dval[p][i]
        lisdic.append(d)
      return Table(lisdic, lpar, ltyp, titr)

# -----------------------------------------------------------------------------
class table_fonction(table_sdaster):
   """Table contenant en plus une colonne FONCTION et/ou FONCTION_C dont les
   valeurs des cellules sont des noms de fonction_sdaster ou fonction_c.
   """

# -----------------------------------------------------------------------------
class table_jeveux(table_sdaster):
   """Classe permettant d'acc�der � une table jeveux qui n'a pas d'ASSD associ�e,
   c'est le cas des concepts r�sultats (table, evol_xxxx) d�riv�s."""
   def __init__(self, nom_jeveux):
      self.nom = nom_jeveux
      AsBase.__init__(self, nomj=self.nom)

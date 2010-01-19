#@ MODIF miss_fichier_sol Miss  DATE 18/01/2010   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
# RESPONSABLE COURTOIS M.COURTOIS

import os
from Utilitai.Utmess import UTMESS, ASSERT

FORMAT_R = "12.5E"


def fichier_sol(tab):
   """Retourne le contenu du fichier de sol construit � partir de 'tab'.
   """
   # v�rification de la table
   try:
      for p in ("NUME_COUCHE", "NUME_MATE", "E", "NU", "RHO", "EPAIS", "AMOR_HYST", "RECEPTEUR", "SUBSTRATUM"):
         assert p in tab.para, p
   except AssertionError, err:
      valk = list(err.args) + ['de sol']
      UTMESS('F', 'TABLE0_2', valk=valk)
   nb_couche = len(tab)
   if max(tab.NUME_COUCHE.values()) != nb_couche:
      UTMESS('F', 'MISS0_5')
   
   # compl�te la table
   tsol = tab.copy()
   # ... niveau r�cepteur
   def f_recep(v):
      res = ""
      if v.strip() == "OUI":
         res = "RECEP"
      return res
   tsol.fromfunction("s_RECEP", f_recep, "RECEPTEUR")
   # ... niveau source
   def f_force(num, v):
      res = 0
      if v.strip() == "OUI":
         res = num
      return res
   tsol.fromfunction("s_FORCE", f_force, ("NUME_COUCHE", "SOURCE"))
   # ... �ta
   tsol.fromfunction("ETA", lambda x : 0., "NUME_COUCHE")

   content = []
   # titre de la table
   content.append("TITRE")
   content.append(tsol.titr)
   # materiaux
   tsol.sort(CLES=["NUME_MATE",])
   nb_mate = max(tsol.NUME_MATE.values())
   content.append("MATERIAU %8d" % nb_mate)
   content.append("RO           E            NU           BETA         ETA")
   format = "%%(RHO)%(fmt)s %%(E)%(fmt)s %%(NU)%(fmt)s %%(AMOR_HYST)%(fmt)s %%(ETA)%(fmt)s" % { 'fmt' : FORMAT_R }
   last_id_mate = 0
   for row in tsol:
      if row['NUME_MATE'] == last_id_mate:   # d�j� vu, on saute
         continue
      last_id_mate = row['NUME_MATE']
      content.append(format % row)
   # couches
   tsol.sort(CLES=["NUME_COUCHE",])
   content.append("COUCHE %8d" % (nb_couche - 1))
   format = "%%(EPAIS)%(fmt)s MATE %%(NUME_MATE)8d %%(s_RECEP)s" % { 'fmt' : FORMAT_R }
   for ic, row in enumerate(tsol):
      if ic == nb_couche - 1:
         continue
      content.append(format % row)
   # substratum
   tsubstr = (tsol.SUBSTRATUM == "OUI")
   ASSERT(len(tsubstr) == 1)
   substr = tsubstr.rows[0]
   content.append("SUBS   MATE %8d" % substr['NUME_MATE'])
   # sources
   nb_source = len(tsol.SOURCE == "OUI")
   content.append("SOURCE %8d 3D" % nb_source)
   # forces
   format = "FORCE HORIZ POSI %(s_FORCE)8d"
   for ic, row in enumerate(tsol):
      if row["s_FORCE"] != 0:
         content.append(format % row)
   # terminer le fichier par un retour chariot
   content.append("")
   return os.linesep.join(content)


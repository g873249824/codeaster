#@ MODIF Sensibilite Utilitai  DATE 07/03/2006   AUTEUR MCOURTOI M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

"""
"""

from types import StringTypes
import aster
from Utilitai.Utmess import UTMESS

# Doit etre en accord avec semeco.f
prefix = '&NOSENSI.MEMO'
nommem = '%-24s' % (prefix + '.CORR')

def NomCompose(nomsd, nomps, msg='A'):
   """Utilitaire analogue � la routine fortran PSRENC.
   Retourne le nom compos� � partir du couple (SD de base, param�tre sensible).
   `msg` : 'A', 'F' ou 'silence' (pas de message)
   """
   nomcomp = None
   vect = aster.getvectjev(nommem)
   if not type(nomsd) in StringTypes:
      nomsd = nomsd.get_name()
   if not type(nomps) in StringTypes:
      nomps = nomps.get_name()
   if vect:
      trouv = False
      for ch in vect[0:len(vect):2]:
         if ch[0:8].strip() == nomsd and ch[8:16].strip() == nomps:
            trouv=True
            nomcomp = ch[16:24].strip()
      if not trouv and msg != 'silence':
         UTMESS(msg, 'NomCompose', 'D�riv�e de %s par rapport � %s non disponible'\
               % (nomsd, nomps))
   elif msg != 'silence':
      UTMESS(msg, 'NomCompose', 'Pas de calcul de sensibilit� accessible.')
   return nomcomp

def SdPara(nomcomp, msg='A'):
   """Retourne le couple (SD de base, param�tre sensible) correspondant au nom
   compos� `nomcomp`.
   `msg` : 'A', 'F' ou 'silence' (pas de message)
   """
   nomsd = None
   nomps = None
   vect = aster.getvectjev(nommem)
   if not type(nomcomp) in StringTypes:
      UTMESS('F', 'SdPara', "Argument de type '%s' invalide" % type(nomcomp).__name__)
   if vect:
      trouv = False
      for ch in vect[0:len(vect):2]:
         if ch[16:24].strip() == nomcomp:
            trouv = True
            nomsd = ch[0:8].strip()
            nomps = ch[8:16].strip()
      if not trouv and msg != 'silence':
         UTMESS(msg, 'SdPara', 'D�riv�e de %s par rapport � %s non disponible'\
               % (nomsd, nomps))
   elif msg != 'silence':
      UTMESS(msg, 'SdPara', 'Pas de calcul de sensibilit� accessible.')
   return nomsd, nomps

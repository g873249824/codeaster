#@ MODIF hoek_brown_tot Comportement  DATE 30/06/2008   AUTEUR PROIX J-M.PROIX 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'HOEK_BROWN_TOT',
   doc = """Relation de comportement de Hoek et Brown modifi�e pour la mod�lisation du comportement
   des roches [R7.01.18] pour la m�canique pure. Le couplage est formul� en contraintes totales.
   Pour faciliter l'int�gration de ce mod�le, 
   on peut utiliser le re-d�coupage local du pas de temps (ITER_INTE_PAS).""",
   num_lc         = 9999,
   nb_vari        = 3,
   nom_vari       = ('GAMMAECR','DPVOLEQ','INDIPLAS'),
   mc_mater       = ('ELAS', 'HOEK_BROWN'),
   modelisation   = ('THM'),
   deformation    = ('PETIT', 'PETIT_REAC', 'EULER_ALMANSI','REAC_GEOM', 'GREEN','GREEN_GR'),
   nom_varc       = ('TEMP',),
   schema         = ('IMPLICITE',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


#@ MODIF viscochab Comportement  DATE 08/12/2009   AUTEUR PROIX J-M.PROIX 
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
# RESPONSABLE GENIAUT S. GENIAUT

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'VISCOCHAB',
   doc = """Mod�le �lastoviscoplastique de Lemaitre-Chaboche avec effet de m�moire et restauration.
   Ce mod�le s'emploie avec les mots cl�s DEFORMATION = PETIT ou PETIT_REAC.""",
   num_lc         = 32,
   nb_vari        = 28,
   nom_vari       = ('VG1','VG2','VG3','VG4','VG5','VG6','VG7','VG8','VG9','VG10','VG11','VG12','VG13','VG14','VG15','VG16','VG17','VG18','VG19','VG20','VG21','VG22','VG23','VG24','VG25','VG26','VG27','VG28',),
   mc_mater       = ('ELAS','VISCOCHAB'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN','C_PLAN'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP'),
   schema         = ('IMPLICITE','RUNGE_KUTTA_2'),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


#@ MODIF visc_irra_log Comportement  DATE 05/03/2012   AUTEUR PROIX J-M.PROIX 
# -*- coding: iso-8859-1 -*-
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
# ======================================================================
# RESPONSABLE FERNANDES R.FERNANDES

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'VISC_IRRA_LOG',
   doc = """Loi de fluage axial sous irradiation des assemblages combustibles. 
   Elle permet de mod�liser le fluage primaire et secondaire, param�tr�s par la fluence neutronique (cf. [R5.03.09]).
   Le champ de fluence est d�fini par le mot-cl� AFFE_VARC de la commande AFFE_MATERIAU.""",
   num_lc         = 28,
   nb_vari        = 2,
   nom_vari       = ('EPSPEQ','IRVECU'),
   mc_mater       = ('VISC_IRRA_LOG'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN','1D'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP', 'IRRA'),
   algo_inte         = ('ANALYTIQUE',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


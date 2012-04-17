#@ MODIF visc_endo_lema Comportement  DATE 16/04/2012   AUTEUR PROIX J-M.PROIX 
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
# RESPONSABLE GENIAUT S.GENIAUT

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'VISC_ENDO_LEMA',
   doc = """Mod�le viscoplastique coupl� � l'endommagement isotrope de Lemaitre-Chaboche [R5.03.15].
   Ce mod�le s'emploie avec les mots cl�s DEFORMATION = PETIT ou PETIT_REAC.""",
   num_lc         = 31,
   nb_vari        = 10,
   nom_vari       = ('EPSPXX','EPSPYY','EPSPZZ','EPSPXY','EPSPXZ','EPSPYZ','EPSPEQ','ECROISOT','ENDO','INDIPLAS'),
   mc_mater       = ('ELAS','VENDOCHAB'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP','GDEF_HYPO_ELAS'),
   nom_varc       = ('TEMP'),
   algo_inte      = ('SECANTE','BRENT','DEKKER',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


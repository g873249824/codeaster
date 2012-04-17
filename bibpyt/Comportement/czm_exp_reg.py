#@ MODIF czm_exp_reg Comportement  DATE 16/04/2012   AUTEUR PROIX J-M.PROIX 
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
# RESPONSABLE LAVERNE J.LAVERNE

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'CZM_EXP_REG',
   doc = """Relation de comportement coh�sive (Cohesive Zone Model EXPonentielle REGularis�e) (Cf. [R7.02.11]) mod�lisant l'ouverture d'une fissure. 
   Cette loi est utilisable avec l'�l�ment fini de type joint (Cf. [R3.06.09]) et permet d'introduire une force de coh�sion entre les l�vres de la fissure. 
   Par ailleurs l'utilisation de ce mod�le requiert souvent la pr�sence du pilotage par PRED_ELAS (cf. [U4.51.03]).""",
   num_lc         = 10,
   nb_vari        = 9,
   nom_vari       = ('SEUILDEP','INDIDISS','INDIENDO','PCENERDI','DISSIP','ENEL_RES','SAUT_N','SAUT_T1','SAUT_T2'),
   mc_mater       = ('RUPT_FRAG'),
   modelisation   = ('3D','PLAN','AXIS','ELEMJOINT','PLAN_JHMS','AXIS_JHMS'),
   deformation    = ('PETIT'),
   nom_varc       = ('TEMP'),
   algo_inte         = ('ANALYTIQUE'),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = ('PRED_ELAS'),
)


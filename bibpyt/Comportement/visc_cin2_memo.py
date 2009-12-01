#@ MODIF visc_cin2_memo Comportement  DATE 06/04/2009   AUTEUR DURAND C.DURAND 
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
# RESPONSABLE PROIX J.M.PROIX


from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'VISC_CIN2_MEMO',
   doc = """Loi �lasto-visco-plastique de Chaboche � 2 variables cin�matiques et effet de memoire""",
   num_lc         = 4,
   nb_vari        = 28,
   nom_vari       = ('DEFPLCUM', 'INDICAT', 'ALPHAXX', 'ALPHAYY', 'ALPHAZZ', 'ALPHAXY', 'ALPHAXZ', 'ALPHAYZ', 'ALPHA2XX', 'ALPHA2YY', 'ALPHA2ZZ', 'ALPHA2XY', 'ALPHA2XZ', 'ALPHA2YZ','RP','Q','KSIXX','KSIYY','KSIZZ','KSIXY','KSIXZ','KSIYZ','EPPXX','EPPYY','EPPZZ','EPPXY','EPPXZ','EPPYZ'),
   mc_mater       = ('ELAS','CIN2_CHAB','LEMAITRE','MEMO_ECRO'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN'),
   deformation    = ('PETIT', 'PETIT_REAC', 'EULER_ALMANSI','REAC_GEOM', 'GREEN','GREEN_GR'),
   nom_varc       = ('TEMP',),
   schema         = ('IMPLICITE',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


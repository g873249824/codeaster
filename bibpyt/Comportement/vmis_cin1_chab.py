#@ MODIF vmis_cin1_chab Comportement  DATE 06/04/2009   AUTEUR DURAND C.DURAND 
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
   nom            = 'VMIS_CIN1_CHAB',
   doc = """Loi �lastoplastique de J.L.Chaboche � 1 variable cin�matique qui rend compte du comportement cyclique en �lasto-plasticit�
   avec un tenseur d'�crouissage cin�matique non lin�aire, un �crouissage isotrope non lin�aire, un effet d'�crouissage sur la variable
   tensorielle de rappel. Toutes les constantes du mat�riau peuvent �ventuellement d�pendre de la temp�rature.""",
   num_lc         = 4,
   nb_vari        = 8,
   nom_vari       = ('DEFPLCUM', 'INDICAT', 'ALPHAXX', 'ALPHAYY', 'ALPHAZZ', 'ALPHAXY', 'ALPHAXZ', 'ALPHAYZ'),
   mc_mater       = ('ELAS', 'CIN1_CHAB'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN'),
   deformation    = ('PETIT', 'PETIT_REAC', 'EULER_ALMANSI','REAC_GEOM', 'GREEN','GREEN_GR'),
   nom_varc       = ('TEMP',),
   schema         = ('IMPLICITE',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


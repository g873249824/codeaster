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
# person_in_charge: jean-michel.proix at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'VMIS_CIN2_NRAD',
   doc = """Loi �lastoplastique de J.L.Chaboche � 2 variables cin�matiques qui rend compte du comportement cyclique en �lasto-plasticit�
   avec 2 tenseurs d'�crouissage cin�matique non lin�aire, un �crouissage isotrope non lin�aire, un effet d'�crouissage sur les variables
   tensorielles de rappel, et prise en compte de la non proportionnalit� du chargement.
   Toutes les constantes du mat�riau peuvent �ventuellement d�pendre de la temp�rature.""",
   num_lc         = 4,
   nb_vari        = 14,
   nom_vari       = ('EPSPEQ', 'INDIPLAS', 'ALPHAXX', 'ALPHAYY', 'ALPHAZZ', 'ALPHAXY', 'ALPHAXZ', 'ALPHAYZ', 'ALPHA2XX', 'ALPHA2YY', 'ALPHA2ZZ', 'ALPHA2XY', 'ALPHA2XZ', 'ALPHA2YZ'),
   mc_mater       = ('ELAS', 'CIN2_CHAB','CIN2_NRAD'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP','GDEF_HYPO_ELAS','GDEF_LOG'),
   nom_varc       = ('TEMP',),
   algo_inte      = ('BRENT','SECANTE',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)

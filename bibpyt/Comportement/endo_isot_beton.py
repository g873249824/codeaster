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
# person_in_charge: sylvie.michel at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'ENDO_ISOT_BETON',
   doc = """Comportement �lastique-fragile qui distingue traction et compression du b�tonRelation de comportement �lastique fragile.
   Il s'agit d'une mod�lisation locale � endommagement scalaire et � �crouissage isotrope lin�aire n�gatif qui distingue le comportement
   en traction et en compression du b�ton (Cf. [R7.01.04] pour plus de d�tails).""",
   num_lc         = 6,
   nb_vari        = 2,
   nom_vari       = ('ENDO', 'INDIENDO'),
   mc_mater       = ('ELAS', 'BETON_ECRO_LINE', 'NON_LOCAL'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN','GRADVARI','GRADEPSI'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP', 'SECH', 'HYDR'),
   algo_inte      =( 'ANALYTIQUE',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION', 'TANGENTE_SECANTE','IMPLEX'),
   proprietes     = None,
)

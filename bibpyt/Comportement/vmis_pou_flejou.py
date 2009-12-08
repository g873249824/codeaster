#@ MODIF vmis_pou_flejou Comportement  DATE 08/12/2009   AUTEUR PROIX J-M.PROIX 
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
# RESPONSABLE FLEJOU J.L.FLEJOU

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'VMIS_POU_FLEJOU',
   doc = """Relation de comportement globale des poutres, � �crouissage isotrope de J.L.Flejou""",
   num_lc         = 9999,
   nb_vari        = 9,
   nom_vari       = ('EPSPX','COURBPLY','COURBPLZ','COURBPLX','V6','V7','COURBEQY','COURBEQZ','VIDE'),
   modelisation   = ('POU_D_E','POU_D_T'),
   deformation    = ('PETIT','PETIT_REAC'),
   nom_varc       = ('TEMP'),
   schema         = ('IMPLICITE','RUNGE_KUTTA_4'),
   type_matr_tang = None,
   proprietes     = None,
)


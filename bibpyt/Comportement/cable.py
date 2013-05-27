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
# person_in_charge: jean-luc.flejou at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'CABLE',
   doc = """Relation de comportement �lastique adapt�e aux c�bles (DEFORMATION: 'GREEN' obligatoire) : 
   le module d'YOUNG du c�ble peut �tre diff�rent en compression et en traction (en particulier il peut �tre nul en compression).""",
   num_lc         = 9999,
   nb_vari        = 1,
   nom_vari       = ('VIDE'),
   mc_mater       = ('ELAS'),
   modelisation   = ('CABLE'),
   deformation    = ('GROT_GDEP'),
   nom_varc       = ('TEMP'),
   algo_inte         = 'ANALYTIQUE',
   type_matr_tang = None,
   proprietes     = None,
)

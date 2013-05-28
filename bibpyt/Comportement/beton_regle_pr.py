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
#

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'BETON_REGLE_PR',
   doc = """Relation de comportement de b�ton (d�velopp�e par la soci�t� NECS) dite 'parabole rectangle' [R7.01.22].
   La loi BETON_REGLE_PR est une loi de b�ton se rapprochant des lois r�glementaires de b�ton (d'o� son nom) 
   qui a les caract�ristiques sommaires suivantes :
-c'est une loi 2D et plus exactement 2 fois 1D : dans le rep�re propre de d�formation, on �crit une loi 1D contrainte-d�formation ;
-la loi 1D sur chaque direction de d�formation propre est la suivante :
* en traction, lin�aire jusqu'� un pic, adoucissement lin�aire jusqu'� 0 ;
* en compression, une loi puissance jusqu'� un plateau (d'ou PR : parabole-rectangle).""",
   num_lc         = 9,
   nb_vari        = 1,
   nom_vari       = ('EPSPEQ'),
   mc_mater       = ('ELAS','BETON_REGLE_PR'),
   modelisation   = ('D_PLAN', 'C_PLAN'),
   deformation    = ('PETIT','PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP'),
   algo_inte         = ('ANALYTIQUE'),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)

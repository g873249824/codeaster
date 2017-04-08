# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
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

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


CALC_ERC_DYN=OPER(nom="CALC_ERC_DYN",op=66,sd_prod=mode_meca,
                  fr="Calcul de l'erreur en relation de comportement en dynamique sous une formulation fr?quentielle",
                  reentrant='n',
         regles=( UN_PARMI('FREQ','LIST_FREQ'),),

         MATR_MASS       =SIMP(statut='o',typ=(matr_asse_depl_r ) ),
         MATR_RIGI       =SIMP(statut='o',typ=(matr_asse_depl_r ) ),
         MATR_NORME      =SIMP(statut='o',typ= matr_asse_gene_r),
         MATR_PROJECTION =SIMP(statut='o',typ= corresp_2_mailla),
         MESURE          =SIMP(statut='o',typ= (dyna_harmo, mode_meca)),
         CHAMP_MESURE    =SIMP(statut='f',typ='TXM',into=("DEPL","VITE","ACCE",),defaut="DEPL" ),
#
         FREQ            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
         LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster ),
#
         GAMMA           =SIMP(statut='o',typ='R',validators=NoRepeat()),
         ALPHA           =SIMP(statut='o',typ='R',validators=NoRepeat()),
# 
         EVAL_FONC=SIMP(statut='f',typ='TXM',into=("OUI","NON"),defaut="NON" ),
         SOLVEUR = C_SOLVEUR('CALC_ERC_DYN'),
         INFO = SIMP(statut='f',typ='I',defaut=1),
         TITRE           =SIMP(statut='f',typ='TXM'),
)  ;

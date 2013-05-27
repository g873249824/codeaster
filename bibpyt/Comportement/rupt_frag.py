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
# person_in_charge: jerome.laverne at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'RUPT_FRAG',
   doc = """Relation de comportement non locale bas�e sur la formulation de J.J. Marigo et G. Francfort de la m�canique de la rupture (pas d'�quivalent en version locale).
   Ce mod�le d�crit l'apparition et la propagation de fissures dans un mat�riau �lastique (cf. [R7.02.11]).""",
   num_lc         = 9999,
   nb_vari        = 1,
   nom_vari       = ('ENDO'),
   mc_mater       = ('ELAS','RUPT_FRAG','NON_LOCAL'),
   modelisation   = ('ELEMDISC','GRADVARI'),
   deformation    = ('PETIT'),
   nom_varc       = None,
   algo_inte         = ('ANALYTIQUE'),
   type_matr_tang = None,
   proprietes     = None,
)

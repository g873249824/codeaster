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
# person_in_charge: mickael.abbas at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'ELAS_HYPER',
   doc = """Relation de comportement hyper-�lastique g�n�ralisant le mod�le de Mooney-Rivlin g�n�ralis�
            Sous sa version incr�mentale (COMP_INCR) : elle permet de prendre en compte des d�placements 
            et contraintes initiaux donn�s sous le mot cl� ETAT_INIT. 
            Cette relation n'est support�e qu'en grandes d�formations (DEFORMATION='GREEN') cf.[R5.03.23]. """,
   num_lc         = 19,
   nb_vari        = 1,
   nom_vari       = ('VIDE'),
   mc_mater       = ('ELAS_HYPER'),
   modelisation   = ('3D', 'C_PLAN', 'D_PLAN'),
   deformation    = ('GROT_GDEP'),
   nom_varc       = ('TEMP'),
   algo_inte         = 'ANALYTIQUE',
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = ' ',
)

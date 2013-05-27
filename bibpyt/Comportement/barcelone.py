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
# person_in_charge: samuel.geniaut at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'BARCELONE',
   doc = """Relation d�crivant le comportement m�canique �lasto-plastique des sols non satur�s 
            coupl� au comportement hydraulique (Cf. [R7.01.14] pour plus de d�tail). 
            Ce mod�le se ram�ne au mod�le de Cam_Clay dans le cas satur�. Deux crit�res interviennent : 
            un crit�re de plasticit� m�canique (celui de Cam_Clay) 
            et un crit�re hydrique contr�l� par la succion (ou pression capillaire).
            Ce mod�le doit �tre utilis� dans des relations KIT_HHM ou KIT_THHM.""",
   num_lc         = 9999,
   nb_vari        = 5,
   nom_vari       = ('PCR','INDIPLAS','SEUILHYD','INDIHYDR','COHESION'),
   mc_mater       = ('ELAS','CAM_CLAY','BARCELONE'),
   modelisation   = ('KIT_HHM', 'KIT_THHM'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP'),
   algo_inte         = 'NEWTON_1D',
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = ' ',
)

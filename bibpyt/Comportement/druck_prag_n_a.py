#@ MODIF druck_prag_n_a Comportement  DATE 16/04/2012   AUTEUR PROIX J-M.PROIX 
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
# RESPONSABLE FERNANDES R.FERNANDES

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'DRUCK_PRAG_N_A',
   doc = """Loi de Drucker_Prager, non associ�e, pour la m�canique des sols (cf. [R7.01.16] pour plus de d�tails).
   On suppose toutefois que le coefficient de dilatation thermique est constant. L'�crouissage peut �tre lin�aire ou parabolique.""",
   num_lc         = 16,
   nb_vari        = 3,
   nom_vari       = ('EPSPEQ','EPSPVOL','INDIPLAS'),
   mc_mater       = ('ELAS', 'DRUCKER_PRAGER'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN','GRADEPSI'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP',),
   algo_inte         = ('ANALYTIQUE',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


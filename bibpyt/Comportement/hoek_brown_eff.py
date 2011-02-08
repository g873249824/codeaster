#@ MODIF hoek_brown_eff Comportement  DATE 08/02/2011   AUTEUR GRANET S.GRANET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
# RESPONSABLE GRANET S.GRANET

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'HOEK_BROWN_EFF',
   doc = """Relation de comportement de Hoek et Brown modifi�e pour la mod�lisation du comportement
   des roches [R7.01.18] pour la m�canique pure. Le couplage est formul� en contraintes effectives.
   Pour faciliter l'int�gration de ce mod�le, on peut utiliser le re-d�coupage local du pas de temps 
   (ITER_INTE_PAS).""",
   num_lc         = 9999,
   nb_vari        = 3,
   nom_vari       = ('GAMMAECR','DPVOLEQ','INDIPLAS'),
   mc_mater       = ('ELAS', 'HOEK_BROWN'),
   modelisation   = ('THM'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP',),
   algo_inte         = ('NEWTON_1D',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


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
# person_in_charge: aurore.parrot at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'ROUSS_PR',
   doc = """Relation de comportement �lasto-plastique de G.Rousselier, en petites d�formations.
   Elle permet de rendre compte de la croissance des cavit�s et de d�crire la rupture ductile, cf. [R5.03.06]). 
   On peut �galement prendre en compte la nucl�ation des cavit�s. 
   Il faut alors renseigner le param�tre AN (mot cl� non activ� pour le mod�le ROUSSELIER et ROUSS_VISC) sous ROUSSELIER(_FO).
   Pour faciliter l'int�gration de ce mod�le, il est conseill� d'utiliser le red�coupage automatique local du pas de temps (mot cl� ITER_INTE_PAS)""",
   num_lc         = 30,
   nb_vari        = 5,
   nom_vari       = ('EPSPEQ','POROSITE','INDIPLAS','DISSIP','EBLOC'),
   mc_mater       = ('ELAS','ROUSSELIER'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP'),
   algo_inte         = ('NEWTON_1D',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)

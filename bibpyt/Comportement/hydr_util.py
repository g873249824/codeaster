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
# person_in_charge: sylvie.granet at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'HYDR_UTIL',
   doc = """Loi de comportement hydraulique, si le comportement m�canique est sans endommagement : 
   Signifie qu'aucune donn�e mat�riau n'est rentr�e en dur. 
   Concr�tement dans le cas satur�, il faudra d�finir les 6 courbes point par point (par DEFI_FONCTION) suivantes :
   - la saturation en fonction de la pression capillaire,
   - la d�riv�e de cette courbe,
   - la perm�abilit� relative au liquide en fonction de la saturation,
   - sa d�riv�e.
   - la perm�abilit� relative au gaz en fonction de la saturation,
   - sa d�riv�e.""",
   num_lc         = 9999,
   nb_vari        = 1,
   nom_vari       = ('HYDRUTI1'),
   mc_mater       = None,
   modelisation   = ('KIT_HH','KIT_HHM','KIT_HM','KIT_THHM','KIT_THH','KIT_THM','KIT_THV'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP'),
   algo_inte         = 'SANS_OBJET',
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = ' ',
)

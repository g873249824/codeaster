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
# person_in_charge: romeo.fernandes at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'LEMAITRE_IRRA',
   doc = """Relation de comportement de fluage et de grandissement sous irradiation pour les assemblages combustibles. 
   Le champ de fluence est d�fini par le mot-cl� AFFE_VARC de la commande AFFE_MATERIAU. 
   Le grandissement ne se faisant que selon une direction, il est n�cessaire dans les cas 3D et 2D de donner la 
   direction du grandissement par l'op�rande ANGL_REP du mot cl� MASSIF de l'op�rateur AFFE_CARA_ELEM. 
   Pour les poutres, le fluage et le grandissement n'ont lieu que dans le sens axial de la poutre : 
   dans les autres directions, le comportement est �lastique. Le sch�ma d'int�gration est DEKKER ou semi-DEKKER, 
   mais on conseille d'utiliser une int�gration semi-DEKKER c'est-�-dire PARM_THETA= 0.5,RESO_INTE=DEKKER.""",
   num_lc         = 28,
   nb_vari        = 3,
   nom_vari       = ('EPSPEQ','IRVECU','EPSGRD'),
   mc_mater       = ('LEMAITRE_IRRA'),
   modelisation   = ('3D', 'AXIS', 'D_PLAN'),
   deformation    = ('PETIT', 'PETIT_REAC', 'GROT_GDEP'),
   nom_varc       = ('TEMP', 'IRRA'),
   algo_inte         = ('DEKKER',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)

#@ MODIF hujeux Comportement  DATE 25/08/2008   AUTEUR KHAM M.KHAM 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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

from cata_comportement import LoiComportement

loi = LoiComportement(
   nom            = 'HUJEUX',
   doc = """Relation de comportement �lasto-plastique cyclique pour la m�canique des sols (g�omat�riaux granulaires :
   argiles sableuses, normalement consolid�es ou sur-consolid�es, graves) (Cf. [R7.01.23] pour plus de d�tails).
   Ce mod�le est un mod�le multi-crit�res qui comporte un m�canisme �lastique non lin�aire, trois m�canismes plastiques d�viatoires et un m�canisme plastique isotrope. 
   Pour faciliter l'int�gration de ce mod�le, on peut utiliser le red�coupage automatique local du pas de temps (ITER_INTE_PAS)""",
   num_lc         = 34,
   nb_vari        = 50,
   nom_vari       = ('FECRDVM1','FECRDVM2','FECRDVM3','FECRISM1','FECRDVC1','FECRDVC2','FECRDVC3','FECRISC1','HIS9','HIS10','HIS11','HIS12','HIS13','HIS14','HIS15','HIS16','HIS17','HIS18','HIS19','HIS20','HIS21','HIS22','DPVOLEQ','INDETAM1','INDETAM1','INDETAM1','INDETAM1','INDETAM2','INDETAM3','INDETAC1','INDETAC2','CRITHILL','INDETAC3','HIS34','HIS35','XHYZ1','XHYZ2','THYZ1','THYZ2','RHYZ','XHXZ1','XHXZ2','THXZ1','THXZ2','RHXZ','XHXY1','XHXY2','THXY1','THXY2','RHYZ'),
   mc_mater       = ('ELAS', 'HUJEUX'),
   modelisation   = ('3D', 'THM'),
   deformation    = ('PETIT', 'PETIT_REAC', 'EULER_ALMANSI','REAC_GEOM', 'GREEN','GREEN_GR'),
   nom_varc       = ('TEMP',),
   schema         = ('IMPLICITE',),
   type_matr_tang = ('PERTURBATION', 'VERIFICATION'),
   proprietes     = None,
)


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
# person_in_charge: mickael.abbas at edf.fr

cata_msg={



11: _(u"""
 <CONTACT_2> Le noeud <%(k1)s> n'est pas appari� car il aurait �t� projet� hors de la zone de tol�rance de la maille <%(k2)s> qui �tait la plus proche. 
 <CONTACT_2> Vous pouvez �ventuellement modifier TOLE_PROJ_EXT ou revoir la d�finition de vos zones esclaves et ma�tres. 
"""),

12: _(u"""
 <CONTACT_2> Le noeud <%(k1)s> n'est pas appari� car aucun noeud n'est dans sa zone TOLE_APPA.  
"""),

13: _(u"""
 <CONTACT_2> Le noeud <%(k1)s> n'est pas appari� car il appartient a SANS_NOEUD ou SANS_GROUP_NO.  
"""),



}

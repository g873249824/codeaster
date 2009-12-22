#@ MODIF unilater Messages  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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

def _(x) : return x

cata_msg = {

42: _("""
D�finition d'une LIAISON_UNILATERALE.
Le nombre de COEF_MULT n'est pas �gal au nombre de grandeurs contenus dans
le vecteur NOM_CMP
"""),

43: _("""
D�finition d'une LIAISON_UNILATERALE.
Il y a trop de grandeurs dans le vecteur NOM_CMP (limit� � 30)
"""),

48 : _("""
D�finition d'une LIAISON_UNILATERALE.
Aucun noeud n'est affect� par une liaison unilat�rale.
"""),

58: _("""
D�finition d'une LIAISON_UNILATERALE.
La composante %(k2)s existe sur le noeud %(k1)s
"""),


75: _("""
D�finition d'une LIAISON_UNILATERALE.
La composante %(k2)s est inexistante sur le noeud %(k1)s
"""),

}

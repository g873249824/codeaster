#@ MODIF mecanonline3 Messages  DATE 19/12/2007   AUTEUR ABBAS M.ABBAS 
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

70 : _("""
 macro_element statique et FETI incompatibles
"""),

71 : _("""
 chargement onde plane et FETI incompatibles
"""),

72 : _("""
 forces fluides sur les grappes et FETI incompatibles
"""),

73 : _("""
 forces d'inertie et FETI incompatibles
"""),

75 : _("""
 forces d'inertie deriv�es et FETI incompatibles
"""),

78 : _("""
 FETI et contact discret incompatibles !
"""),

89 : _("""
 contact et recherche lin�aire peuvent poser des probl�mes de convergence
"""),

90 : _("""
 la combinaison: contact-frottement et solveur GCPC n'est pas disponible.
"""),

91 : _("""
 contact m�thode continue et recherche lin�aire sont incompatibles
"""),

92 : _("""
 contact m�thode continue et pilotage sont incompatibles
"""),

93 : _("""
 la combinaison: m�thode continue en contact et solveur GCPC n'est pas disponible.
"""),

94 : _("""
 LIAISON_UNILATER et PILOTAGE sont des fonctionnalit�s incompatibles
"""),

95 : _("""
 LIAISON_UNILATER et recherche lin�aire peuvent poser des probl�mes de convergence
"""),

}

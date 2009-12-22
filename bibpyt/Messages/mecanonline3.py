#@ MODIF mecanonline3 Messages  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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

1 : _("""
 Il y a trop de colonnes � afficher dans le tableau de convergence.
 La largeur maximale affichable est de 256 caract�res, donc 14 colonnes maximum.
 Or vous avez <%(i1)d> colonnes !
 Si vous avez des colonnes SUIVI_DDL, supprimez-en.
 Sinon, utiliser la commande AFFICHAGE pour choisir les colonnes � afficher.
"""),

2 : _("""
 Votre mod�le contient des variables de commandes (temp�rature, irradiation, etc.)
 or on utilise une matrice �lastique constante au cours du temps.
 Si vous faites de l'amortissement de Rayleigh, il y a un risque de r�sultats faux
 si l'amortissement d�pend de cette variable de commande (via les coefficients �lastiques).
 
 """),

70 : _("""
 macro_element statique et FETI incompatibles
"""),

71 : _("""
 chargement onde plane et FETI incompatibles
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

79 : _("""
 FETI et contact continu incompatibles !
"""),

89 : _("""
 contact et recherche lin�aire peuvent poser des probl�mes de convergence
"""),

90 : _("""
La combinaison: contact-frottement et solveur GCPC n'est pas disponible.
"""),

91 : _("""
Contact m�thode continue et recherche lin�aire sont incompatibles
"""),

92 : _("""
Contact m�thode continue et pilotage sont incompatibles
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

96 : _("""
 la combinaison : LIAISON_UNILATER et solveur GCPC n'est pas disponible.
"""),
}

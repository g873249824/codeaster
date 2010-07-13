#@ MODIF mecanonline3 Messages  DATE 13/07/2010   AUTEUR MASSIN P.MASSIN 
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
# RESPONSABLE DELMAS J.DELMAS

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
  -> Vous utilisez une formulation 'DISCRETE' de contact conjointement avec le solveur lin�aire 'GCPC'.
     Le solveur 'GCPC' n'est actuellement autoris� qu'avec les algorithmes de contact 'VERIF' et 'PENALISATION'.

  -> Conseil :
     Changez d'algorithme de contact en utilisant le mot-cl� ALGO_CONT de DEFI_CONTACT ou bien changez de solveur lin�aire
     en utilisant le mot-cl� METHODE de SOLVEUR.
"""),

91 : _("""
Contact m�thode continue et recherche lin�aire sont incompatibles
"""),

92 : _("""
Contact m�thode continue et pilotage sont incompatibles
"""),

93 : _("""
  -> Vous utilisez la formulation 'CONTINUE' de contact conjointement avec le solveur lin�aire 'GCPC' et le renum�roteur 'RCMK'.
     Le renum�roteur 'RCMK' n'est actuellement pas autoris� avec la formulation 'CONTINUE'.

  -> Conseil :
     Il ne faut pas utiliser de renum�roteur (renseignez RENUM='SANS' sous le mot-cl� facteur SOLVEUR).
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

97 : _("""
  -> Vous utilisez l'algorithme 'PENALISATION' de contact en formulation 'CONTINUE' ou 'XFEM' 
     conjointement avec une matrice de rigidit� sym�trique (mot-cl� SYME='OUI').
     Ces fonctionnalit�s sont incompatibles.

  -> Conseil :
     Changez d'algorithme de contact en utilisant les mots-cl�s ALGO_CONT et ALGO_FROT de DEFI_CONTACT ou bien
     utilisez une matrice non sym�trique en renseignant SYME='NON' sous le mot-cl� facteur SOLVEUR.
"""),

98 : _("""
  -> Vous utilisez le contact frottant X-FEM en grands glissements conjointement avec 
     une matrice de rigidit� sym�trique (mot-cl� SYME='OUI').
     Ces fonctionnalit�s sont incompatibles.

  -> Conseil :
     N'utilisez pas la m�thode grands glissements en donnant une autre valeur que
     "AUTOMATIQUE" au mot cl� REAC_GEOM de DEFI_CONTACT ou bien utilisez une matrice
     non sym�trique en renseignant SYME='NON' sous le mot-cl� facteur SOLVEUR.
"""),
}

# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: josselin.delmas at edf.fr

cata_msg = {


8 : _(u"""
 �l�ment non trait�
"""),

9 : _(u"""
 Vous avez choisie une m�thode � pas de temps adaptatif. Il n'est pas possible de prendre en compte une
 liste d'instants de calcul d�finie a priori.
"""),

10 : _(u"""
  -> Contact avec DYNA_TRAN_MODAL : Il y a interp�n�tration d'une valeur sup�rieure � (DIST_MAIT + DIST_ESCL).
  -> Risque & Conseil :
     DIST_MAIT et DIST_ESCL permettent de tenir compte d'une �paisseur de mat�riau non repr�sent�e dans le maillage
     (rayon d'une poutre, �paisseur d'une coque ou simplement une bosse). Une trop forte interp�n�tration peut venir 
     d'une erreur dans le fichier de commande : RIGI_NOR trop faible ; noeuds de contact qui ne sont en vis � vis ; 
     OBSTACLE et NORM_OBSTACLE incoh�rents. Dans le cas de deux poutres aux fibres neutres confondues, elle peut 
     g�n�rer des erreurs dans l'orientation des forces de contact.
"""),

11 : _(u"""
 m�thode � pas adaptatif : la donn�e du pas est obligatoire 
"""),

12 : _(u"""
 le pas de temps ne peut pas �tre nul  
"""),

13 : _(u"""
 les matrices de masse �l�mentaires doivent obligatoirement avoir �t� calcul�es
 avec l'option MASS_MECA_DIAG
"""),

14 : _(u"""
 on archive au moins un champ.
"""),

15 : _(u"""
 La m�thode d'int�gration %(k1)s n'est pas disponible pour les analyses 
 transitoires sur base modale
"""),

16 : _(u"""
A l'instant %(r1)f, l'erreur vaut %(r2)f
Cette erreur est sup�rieure � 1.
Le pas de temps vaut %(r3)f
On arr�te de le r�duire, car le nombre de r�ductions a atteint %(i1)d, qui est le maximum possible.
"""),

17 : _(u"""
 m�thode � pas adaptatif : pas de temps minimal atteint
"""),

18 : _(u"""
 La liste des instants de calcul ne doit contenir qu'un seul pas
 Conseil: si vous avez d�fini une liste d'instants manuellement par des valeurs discr�tes,
 veillez � ce que le pas soit constant dans tout l'intervalle.
"""),

19 : _(u"""
 La m�thode d'int�gration %(k1)s n'est pas disponible pour les analyses 
 transitoires sur base physique
"""),

20 : _(u"""
 le chargement de type DIRICHLET n�cessite la r�solution par le sch�ma de NEWMARK
"""),

21 : _(u"""
Nombre de pas de calcul : %(i1)d
Nombre d'it�rations     : %(i2)d
"""),

23 : _(u"""
 vous calculez une imp�dance absorbante
"""),

24 : _(u"""
 on n'a pas pu trouver le dernier instant sauv�.
"""),

25 : _(u"""
 le champ "DEPL" n'est pas trouv� dans le concept DYNA_TRANS  %(k1)s 
"""),

26 : _(u"""
 le champ "VITE" n'est pas trouv� dans le concept DYNA_TRANS  %(k1)s 
"""),

27 : _(u"""
 le champ "ACCE" n'est pas trouve dans le concept DYNA_TRANS  %(k1)s 
"""),

28 : _(u"""
 d�placements initiaux nuls.
"""),

29 : _(u"""
 vitesses initiales nulles.
"""),

36 : _(u"""
 NUME_INIT: on n'a pas trouv� le NUME_INIT dans le r�sultat  %(k1)s 
"""),

37 : _(u"""
 incoh�rence sur H, ALPHA, ELAS
"""),

40 : _(u"""
 le NOM_CHAM  %(k1)s n'appartient pas � la structure de donn�es
"""),

41 : _(u"""
 erreur(s) dans les donn�es
"""),

42 : _(u"""
 crit�re inconnu :  %(k1)s 
"""),

43 :_(u"""
 <DPMAT2> PLAS=2
"""),

55 : _(u"""
 ITER_INTE_MAXI insuffisant
"""),

56 : _(u"""
 la dur�e du transitoire est limit�e par les possibilit�s de la transform�e de Fourier rapide 
"""),

57 : _(u"""
 la dur�e de la simulation temporelle est insuffisante pour le passage du transitoire
"""),

58 : _(u"""
 changement de signe de la vitesse --> on prend VITG0(I)
"""),

60 : _(u"""
 la matrice interspectrale poss�de un pivot nul.
"""),

61 : _(u"""
 option non pr�vue !
"""),

62 : _(u"""
 Probl�me 1 test spectre fi par ARPACK
"""),

63 : _(u"""
 Probl�me 2 test spectre fi par ARPACK
"""),

64 : _(u"""
 valeur de STOGI incoh�rente
"""),

65 : _(u"""
 en parall�le STOGI=OUI obligatoire pour l'instant
"""),

66 : _(u"""
 option de calcul incoh�rente
"""),

67 : _(u"""
 Probl�me division par z�ro dans la construction du BETA
"""),

72 : _(u"""
 donn�e erron�e, multiplicit� nulle
"""),

78 : _(u"""
 pas de discr�tisation de l'interspectre non constant.
"""),

80 : _(u"""
 "NB_POIN" n est pas une puissance de 2
 on prend la puissance de 2 sup�rieure
"""),

81 : _(u"""
 coefficient de dispersion trop grand
 consulter la documentation d'utilisation
"""),

82 : _(u"""
 matrice moyenne non d�finie positive
"""),

83 : _(u"""
 le pas tend vers 0 ...
"""),

86 : _(u"""
 pas d'interpolation possible pour les fr�quences.
"""),

87 : _(u"""
 d�riv�e de F nulle
"""),

88 : _(u"""
 GM n�gatif
"""),

89 : _(u"""
 valeurs propres non ordonn�es :
 %(k1)s  %(k2)s  %(k3)s 
"""),

90 : _(u"""
 coefficients paraboliques pas compatibles
"""),

92 : _(u"""
 mod�lisations C_PLAN et 1D pas autoris�es
"""),








}

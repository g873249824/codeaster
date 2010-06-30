#@ MODIF algorith3 Messages  DATE 30/06/2010   AUTEUR DELMAS J.DELMAS 
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


8 : _("""
 �l�ment non trait�
"""),


10 : _("""
  -> Contact avec DYNA_TRAN_MODAL : Il y a interp�n�tration d'une valeur sup�rieure � (DIST_MAIT + DIST_ESCL).
  -> Risque & Conseil :
     DIST_MAIT et DIST_ESCL permettent de tenir compte d'une �paisseur de mat�riau non repr�sent�e dans le maillage
     (rayon d'une poutre, �paisseur d'une coque ou simplement une bosse). Une trop forte interp�n�tration peut venir 
     d'une erreur dans le fichier de commande : RIGI_NOR trop faible ; noeuds de contact qui ne sont en vis � vis ; 
     OBSTACLE et NORM_OBSTACLE incoh�rents. Dans le cas de deux poutres aux fibres neutres confondues, elle peut 
     g�n�rer des erreurs dans l'orientation des forces de contact.
"""),

11 : _("""
 m�thode � pas adaptatif : la donn�e du pas est obligatoire 
"""),

12 : _("""
 m�thode � pas adaptatif : le pas ne peut pas etre nul  
"""),

13 : _("""
 les matrices de masse �l�mentaires doivent obligatoirement avoir �t� calcul�es
 avec l'option MASS_MECA_DIAG
"""),

14 : _("""
 on archive au moins un champ.
"""),

16 : _("""
A l'instant %(r1)f, l'erreur vaut %(r2)f
Cette erreur est sup�rieure � 1.
Le pas de temps vaut %(r3)f
On arrete de le r�duire, car le nombre de r�ductions a atteint %(i1)d, qui est le maximum possible.
"""),

17 : _("""
 m�thode � pas adaptatif : pas de temps minimal atteint
"""),

18 : _("""
 methode des diff�rences centrees:  la donnee du pas est obligatoire 
"""),

19 : _("""
 methode des diff�rences centrees:  le pas ne peut pas etre nul  
"""),

20 : _("""
 le chargement de type dirichlet n�cessite la r�solution par le schema de NEWMARK
"""),

21 : _("""
Nombre de pas de calcul : %(i1)d
Nombre d'it�rations     : %(i2)d
"""),

23 : _("""
 vous calculez une imp�dance absorbante
"""),

24 : _("""
 on n'a pas pu trouver le dernier instant sauv�.
"""),

25 : _("""
 le champ "DEPL" n'est pas trouv� dans le concept DYNA_TRANS  %(k1)s 
"""),

26 : _("""
 le champ "VITE" n'est pas trouv� dans le concept DYNA_TRANS  %(k1)s 
"""),

27 : _("""
 le champ "acce" n'est pas trouve dans le concept dyna_trans  %(k1)s 
"""),

28 : _("""
 d�placements initiaux nuls.
"""),

29 : _("""
 vitesses initiales nulles.
"""),

30 : _("""
 NUME_INIT: on n'a pas trouv� le NUME_INIT dans le r�sultat  %(k1)s 
"""),

31 : _("""
 methode de NEWMARK ou WILSON: la donn�e de LIST_INST ou FONC_INST est obligatoire 
"""),

32 : _("""
 FONC_INST: on attend une fonction.
"""),

33 : _("""
 fonc_inst: il faut une fonction � pas constant.
"""),

34 : _("""
 fonc_inst: temps de reprise sup�rieur � la fonction.
"""),

36 : _("""
 NUME_INIT: on n'a pas trouv� le NUME_INIT dans le r�sultat  %(k1)s 
"""),

37 : _("""
 incoh�rence sur H, ALPHA, ELAS
"""),

40 : _("""
 le nom_cham  %(k1)s n'appartient pas � la sd
"""),

41 : _("""
 erreur(s) dans les donn�es
"""),

42 : _("""
 crit�re inconnu :  %(k1)s 
"""),

43 :_("""
 <DPMAT2> PLAS=2
"""),

55 : _("""
 ITER_INTE_MAXI insuffisant
"""),

56 : _("""
 la dur�e du transitoire est limit�e par les possibilit�s de la transform�e de Fourier rapide 
"""),

57 : _("""
 la dur�e de la simulation temporelle est insuffisante pour le passage du transitoire
"""),

58 : _("""
 changement de signe de la vitesse --> on prend VITG0(I)
"""),

60 : _("""
 la matrice interspectrale poss�de un pivot nul.
"""),

61 : _("""
 option non pr�vue !
"""),

62 : _("""
 pb 1 test spectre fi par ARPACK
"""),

63 : _("""
 pb 2 test spectre fi par ARPACK
"""),

64 : _("""
 valeur de STOGI incoherente
"""),

65 : _("""
 en parall�le STOGI=OUI obligatoire pour l'instant
"""),

66 : _("""
 option de calcul incoh�rente
"""),

67 : _("""
 pb division par z�ro dans la construction du BETA
"""),

72 : _("""
 donn�e erronn�e, multiplicit� nulle
"""),

76 : _("""
 le type de concept: TABLE_SDASTER doit etre associ� au mot cl� NUME_VITE_FLUI
"""),

78 : _("""
 pas de discr�tisation de l'interspectre non constant.
"""),

79 : _("""
 discr�tisations differentes selon les fonctions de l'interspectre
"""),

80 : _("""
 "NB_POIN" n est pas une puissance de 2
 on prend la puissance de 2 sup�rieure
"""),

81 : _("""
 coefficient de dispersion trop grand
 consulter la documentation d'utilisation
"""),

82 : _("""
 matrice moyenne non d�finie positive
"""),

83 : _("""
 le pas tend vers 0 ...
"""),

86 : _("""
 pas d'interpolation possible pour les fr�quences.
"""),

87 : _("""
 deriv�e de F nulle
"""),

88 : _("""
 GM n�gatif
"""),

89 : _("""
 valeurs propres non ordonn�es :
 %(k1)s  %(k2)s  %(k3)s 
"""),

90 : _("""
 coefficients paraboliques pas compatibles
"""),

92 : _("""
 modelisations C_PLAN et 1D pas autoris�es
"""),








}

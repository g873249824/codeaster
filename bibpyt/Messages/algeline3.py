#@ MODIF algeline3 Messages  DATE 01/03/2011   AUTEUR PELLET J.PELLET 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg={

1: _("""
 Le mot-cl� MAILLAGE est obligatoire avec le mot-cle CREA_MAILLE.
"""),

2: _("""
 Le mot-cl� MAILLAGE est obligatoire avec le mot-cle CREA_GROUP_MA.
"""),

3: _("""
 Le mot-cl� MAILLAGE est obligatoire avec le mot-cle CREA_POI1.
"""),

4: _("""
 Le mot-cl� MAILLAGE est obligatoire avec le mot-cle REPERE.
"""),

5: _("""
 Sous le mot-cle "NOM_ORIG" du mot-cl� facteur "REPERE",
 on ne peut donner que les mots "CDG" ou "TORSION".
"""),

6: _("""
 Maille non cr��e  %(k1)s
"""),

7: _("""
 Le groupe de mailles '%(k1)s' existe d�j�.

 Conseil :
    Si vous souhaitez utiliser un nom de groupe existant, il suffit
    de le d�truire avec DEFI_GROUP / DETR_GROUP_MA.
"""),

8: _("""
 Le mot-cle MAILLAGE est obligatoire avec le mot-cl� DETR_GROUP_MA.
"""),

9: _("""
 Mode non compatible.
"""),

10: _("""
 Masses effectives unitaires non calcul�es par NORM_MODE
"""),

11: _("""
 L'extraction des modes a �chou�.
 La structure de donn�es mode_meca est vide ou aucun mode ne remplit le crit�re d'extraction.
 Conseils & solution :
   V�rifiez le r�sultat de votre calcul modal et/ou modifiez votre filtre d'extraction"
"""),

12: _("""
 Le nombre de noeuds sur le contour est insuffisant pour d�terminer correctement
 les ordres de coque.
"""),

13: _("""
 L'azimut n'est pas d�fini pour un des noeuds de la coque.
"""),

14: _("""
 ordre de coque nul pour l'un des modes pris en compte pour le couplage.
 Le mod�le de r�solution ne supporte pas une telle valeur.
"""),

15: _("""
 d�termination du DRMAX et du d�phasage pour le mode  %(k1)s  :
 le d�terminant du syst�me issu du moindre carr� est nul
"""),

16: _("""
 d�termination du d�phasage pour le mode  %(k1)s  :
 THETA0 ind�fini
"""),

17: _("""
 Pivot nul dans la r�solution du syst�me complexe
"""),

18: _("""
 Annulation du num�rateur dans l'expression d un coefficient donnant
 la solution du probl�me fluide instationnaire pour UMOY = 0
"""),

19: _("""
 D�termination des valeurs propres de l'op�rateur diff�rentiel :
 existence d'une racine double
"""),

20: _("""
 La %(k1)s �me valeur propre est trop petite.
"""),

21: _("""
 La MATR_ASSE  %(k1)s  n'est pas stock�e "morse" :
 le GCPC est donc impossible.
"""),

22: _("""
 Conflit : une matrice stock�e morse ne peut avoir qu'un bloc
"""),

23: _("""
Probl�me :
  Le pr�conditionnement LDLT_INC d'une matrice complexe n'est pas impl�ment�
Conseils & solution :
  Il faut choisir un autre solveur que GCPC
"""),

24: _("""
 R�solution LDLT : erreur de programmation.
"""),

25: _("""
 Erreur � l'appel de METIS
"""),

26: _("""
 Probl�me d'affichage FETI dans PREML1
"""),

27: _("""
 Solveur interne LDLT interdit pour l'instant avec FETI
"""),

28: _("""
 Solveur interne MUMPS interdit pour l'instant avec FETI
"""),

29: _("""
 Solveur interne gcpc pour l'instant proscrit  avec feti
"""),

30: _("""
 Matrices A et B incompatibles pour l'op�ration *
"""),

31: _("""
 La section de la poutre doit etre constante.
"""),

32: _("""
 Structure non tubulaire
"""),

33: _("""
 On ne traite pas ce type de CHAM_ELEM, ICOEF diff�rent de 1
"""),

34: _("""
 Le CHAM_NO :  %(k1)s  n'existe pas
"""),

37: _("""
  GCPC n"est pas prevu pour une matrice complexe
"""),

38: _("""
 Pas de matrice de pr�conditionnement : on s'arrete
"""),

40: _("""
 Erreur : LMAT est nul
"""),

41: _("""
La matrice poss�de des ddls impos�s �limin�s: il faut un VCINE
"""),

42: _("""
La matrice et le vecteur cin�matique ne contiennent pas des valeurs de meme type
"""),

44: _("""
La methode de resolution:  %(k1)s  est inconnue. on attend ldlt,gcpc, mult_fro ou feti
"""),

45: _("""
 methode de bathe et wilson : convergence non atteinte
"""),

46: _("""
Recherche de corps rigide : pour l'instant proscrite avec matrice non-symetrique
"""),

47: _("""
Recherche de corps rigide : pour l'instant proscrite avec matrice complexe
"""),





49: _("""
Attention : plus de six modes de corps rigides detect�s
"""),

50: _("""
Attention  %(k1)s .VALF existe d�j�
"""),

51: _("""
Le tableau B est insuffisamment dimensionn� pour l'op�ration *
"""),

53: _("""
Toutes les fr�quences sont des fr�quences de corps rigide
"""),

54: _("""
Calcul des NUME_MODE : matrice non inversible pour la fr�quence consid�r�e
"""),

55: _("""
Probl�me � la r�solution du syst�me r�duit.
"""),

56: _("""
Valeur propre infinie trouv�e
"""),

57: _("""
M�thode QR : probl�me de convergence
"""),

58: _("""
Il y a des valeurs propres tr�s proches
"""),

59: _("""
Erreur d'utilisation :
  Le solveur MULT_FRONT est interdit ici car les ddls de la matrice ne sont pas
  port�s par les noeuds d'un maillage.
  Peut-etre s'agit-il d'une matrice g�n�ralis�e ?

Conseil :
  Il faut changer de solveur
"""),

60: _("""
La matrice : %(k1)s a une num�rotation incoh�rente avec le NUME_DDL.
"""),

61: _("""
Le concept MODE "%(k1)s" a �t� cr�� avec les matrices
 MATR_A:  %(k2)s
 MATR_B:  %(k3)s
 MATR_C:  %(k4)s
 et non avec celles pass�es en arguments.
"""),

62: _("""
Le concept MODE "%(k1)s" a �t� cr�� avec les matrices
 MATR_A:  %(k2)s
 MATR_B:  %(k3)s
 et non avec celles pass�es en arguments.
"""),

63: _("""
Le syst�me � r�soudre n'a pas de DDL actif.
"""),

64: _("""
On trouve plus de 9999 valeurs propres dans la bande demand�e
"""),

66: _("""
  -> La borne minimale de la bande de fr�quences est une valeur propre !
     Malgr� la strat�gie de d�calage, la matrice de raideur est num�riquement
     singuli�re (modes de corps rigide).
  -> Risque & Conseil :
     Augmenter (ou diminuer) la fr�quence (ou la charge critique dans le cas du calcul de
     flambement) qui d�finit la borne minimale de la bande de fr�quence.
"""),

67: _("""
La matrice de raideur est numeriquement singuli�re (malgr� la strat�gie de decalage) :
la borne maximale de la bande est une valeur propre.
On poursuit tout de meme.
"""),

68: _("""
  -> La matrice de raideur est singuli�re malgre la strategie de d�calage
(structure avec des modes de corps rigide).
  -> Risque & Conseil :
Utiliser l'option 'BANDE' avec une borne minimale de la bande de fr�quence
l�g�rement n�gative (ou positive)
"""),

69: _("""
Option  %(k1)s non reconnue.
"""),

70: _("""
Le type des valeurs varie d'un mode � l'autre, r�cup�ration impossible.
"""),

71: _("""
Le nombre d'�quations est variable d'un mode � l'autre, r�cup�ration impossible.
"""),

72: _("""
Probleme interne ARPACK
"""),

73: _("""
Probl�me taille WORKD/L -> augmenter DIM_SOUS_ESPACE
"""),

74: _("""
Probl�me interne LAPACK
"""),

75: _("""
Probleme construction vecteur initial --> si possible diminuer nmax_freq
"""),

76: _("""
Probleme interne LAPACK, routine FLAHQR (forme de SCHUR)
"""),

77: _("""
Probleme interne LAPACK, routine FTREVC (vecteurs propres)
"""),

78: _("""
Aucune valeur propre � la pr�cision requise
 --> augmenter PREC_SOREN ou NMAX_ITER_SOREN ou augmenter DIM_SOUS_ESPACE
"""),

79: _("""
La position modale d'une des fr�quences est n�gative ou nulle
votre syst�me matriciel est surement fortement singulier
(ceci correspond g�n�ralement � un probl�me dans la mod�lisation).
"""),

80: _("""
MODE � cr�er avant appel � VPSTOR
"""),

81: _("""
"%(k1)s" argument du mot cle "OPTION" pour le calcul des fr�quences est invalide.
"""),

82: _("""
Pour l'option "BANDE" il faut exactement 2 fr�quences.
"""),

83: _("""
Fr�quence min. sup�rieure ou �gale � la fr�quence max.
"""),

84: _("""
Pour l'option "CENTRE" il faut exactement une fr�quence.
"""),

85: _("""
Pour les options  "PLUS_PETITE" et "TOUT" les frequences de "FREQ" sont ignor�es.
"""),

86: _("""
Pour l'option  "BANDE" il faut exactement 2 charges critiques.
"""),

87: _("""
Charge crit. min. plus  grande ou egale a la charge crit. max.
"""),

88: _("""
Pour l'option  "CENTRE" il faut exactement une charge critique.
"""),

89: _("""
Pour l'option  "PLUS_PETITE" et "TOUT" les charges critiques de "CHAR_CRIT" sont ignor�es.
"""),

90: _("""
Objet .REFE/.REFA/.CELK inexistant.
"""),

91: _("""
CHAM_NO non FETI
"""),

92: _("""
Liste de CHAM_NO � concat�ner h�t�rog�ne
"""),

93: _("""
Les CHAM_NO  %(k1)s  et  %(k2)s  sont de type inconnu  %(k3)s
"""),

94: _("""
Le CHAM_NO  %(k1)s  de type  %(k2)s  ne peut etre copi� dans le CHAM_NO  %(k3)s  de type  %(k4)s
"""),

95: _("""
Champ � repr�sentation constante : cas non trait�.
"""),

96: _("""
CHOUT non feti
"""),

97: _("""
Type de tri inconnu
"""),

98: _("""
Probl�me interne LAPACK, routine DLAHQR (forme de SCHUR)
"""),

99: _("""
Probl�me interne LAPACK, routine DTREVC (vecteurs propres)
"""),
}

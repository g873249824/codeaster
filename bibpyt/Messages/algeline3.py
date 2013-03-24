#@ MODIF algeline3 Messages  DATE 19/03/2013   AUTEUR BRIE N.BRIE 
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
# RESPONSABLE DELMAS J.DELMAS

cata_msg={

1: _(u"""
 Le mot-cl� MAILLAGE est obligatoire avec le mot-cl� CREA_MAILLE.
"""),

2: _(u"""
 Le mot-cl� MAILLAGE est obligatoire avec le mot-cl� CREA_GROUP_MA.
"""),

3: _(u"""
 Le mot-cl� MAILLAGE est obligatoire avec le mot-cl� CREA_POI1.
"""),

4: _(u"""
 Le mot-cl� MAILLAGE est obligatoire avec le mot-cl� REPERE.
"""),

5: _(u"""
 Sous le mot-cl� "NOM_ORIG" du mot-cl� facteur "REPERE",
 on ne peut donner que les mots "CDG" ou "TORSION".
"""),

6: _(u"""
 Maille non cr��e  %(k1)s
"""),

7: _(u"""
 Le groupe de mailles '%(k1)s' existe d�j�.

 Conseil :
    Si vous souhaitez utiliser un nom de groupe existant, il suffit
    de le d�truire avec DEFI_GROUP / DETR_GROUP_MA.
"""),

8: _(u"""
 Le mot-cl� MAILLAGE est obligatoire avec le mot-cl� DETR_GROUP_MA.
"""),

9: _(u"""
 Mode non compatible.
"""),

10: _(u"""
 Masses effectives unitaires non calcul�es par NORM_MODE
"""),

11: _(u"""
 L'extraction des modes a �chou�.
 La structure de donn�es MODE_MECA est vide ou aucun mode ne remplit le crit�re d'extraction.
 Conseils & solution :
   V�rifiez le r�sultat de votre calcul modal et/ou modifiez votre filtre d'extraction"
"""),

12: _(u"""
 Le nombre de noeuds sur le contour est insuffisant pour d�terminer correctement
 les ordres de coque.
"""),

13: _(u"""
 L'azimut n'est pas d�fini pour un des noeuds de la coque.
"""),

14: _(u"""
 ordre de coque nul pour l'un des modes pris en compte pour le couplage.
 Le mod�le de r�solution ne supporte pas une telle valeur.
"""),

15: _(u"""
 d�termination du DRMAX et du d�phasage pour le mode  %(k1)s  :
 le d�terminant du syst�me issu du moindre carr� est nul
"""),

16: _(u"""
 d�termination du d�phasage pour le mode  %(k1)s  :
 THETA0 ind�fini
"""),

17: _(u"""
 Pivot nul dans la r�solution du syst�me complexe
"""),

18: _(u"""
 Annulation du num�rateur dans l'expression d un coefficient donnant
 la solution du probl�me fluide instationnaire pour UMOY = 0
"""),

19: _(u"""
 D�termination des valeurs propres de l'op�rateur diff�rentiel :
 existence d'une racine double
"""),

20: _(u"""
 La %(k1)s �me valeur propre est trop petite.
"""),

21: _(u"""
 La MATR_ASSE  %(k1)s  n'est pas stock�e "morse" :
 le GCPC est donc impossible.
"""),

22: _(u"""
 Conflit : une matrice stock�e morse ne peut avoir qu'un bloc
"""),

23: _(u"""
Probl�me :
  Le pr�conditionnement LDLT_INC d'une matrice complexe n'est pas impl�ment�
Conseils & solution :
  Il faut choisir un autre solveur que GCPC
"""),

24: _(u"""
 R�solution LDLT : erreur de programmation.
"""),

26: _(u"""
 Probl�me d'affichage FETI dans PREML1
"""),

27: _(u"""
 Solveur interne LDLT interdit pour l'instant avec FETI
"""),

28: _(u"""
 Solveur interne MUMPS interdit pour l'instant avec FETI
"""),

29: _(u"""
 Solveur interne GCPC pour l'instant proscrit  avec FETI
"""),

30: _(u"""
 Matrices A et B incompatibles pour l'op�ration *
"""),

31: _(u"""
 La section de la poutre doit �tre constante.
"""),

32: _(u"""
 Structure non tubulaire
"""),

33: _(u"""
 On ne traite pas ce type de CHAM_ELEM, ICOEF diff�rent de 1
"""),

34: _(u"""
 Le CHAM_NO :  %(k1)s  n'existe pas
"""),

35: _(u"""
MULT_FRONT factorise une Matrice G�n�ralis�e.
On a d�tect� l'existence d'au moins une liaison entre degr� de libert�.
On ne renum�rote pas car les degr�s de libert� sont a priori compris entre  Lagrange1 et Lagrange2 .

Conseil :
  En cas d'arr�t ult�rieur avec MATRICE singuli�re, il faudra changer de SOLVEUR (MUMPS par exemple).
 """),

37: _(u"""
  GCPC n"est pas pr�vu pour une matrice complexe
"""),

38: _(u"""
 Pas de matrice de pr�conditionnement : on s'arr�te
"""),

40: _(u"""
 Erreur : LMAT est nul
"""),

41: _(u"""
La matrice poss�de des ddls impos�s �limin�s: il faut un VCINE
"""),

42: _(u"""
La matrice et le vecteur cin�matique ne contiennent pas des valeurs de m�me type
"""),

43: _(u"""
Attention :
  La pile des matrices frontales a une longueur (%(i1)d) qui, en octets, sera sup�rieure � l'entier maximum pour cette machine (%(i2)d).
  Vous aurez un probl�me dans une allocation ult�rieure.
Conseil :
  Utilisez une machine 64 bits. Si vous y �tes d�j� votre �tude est vraiment trop volumineuse !
"""),


44: _(u"""
La m�thode de r�solution:  %(k1)s  est inconnue. on attend LDLT,GCPC, MULT_FRONT ou FETI
"""),

45: _(u"""
 m�thode de BATHE et WILSON : convergence non atteinte
"""),

46: _(u"""
La matrice %(k1)s est non sym�trique.
Pour l'instant, la recherche des modes de corps rigide n'a pas �t� d�velopp�e
pour une matrice non sym�trique.
"""),

47: _(u"""
La matrice %(k1)s est complexe.
Pour l'instant, la recherche des modes de corps rigide n'a pas �t� d�velopp�e
pour une matrice complexe.
"""),

48: _(u"""
Cet op�rateur a besoin du "proc�d� de STURM" pour tester la validit� de modes propres ou
pour nourrir un algorithme de recherche de modes propres (dichotomie...). Or celui-ci
ne fonctionne, pour l'instant, que sur des matrices r�elles et sym�triques.
  --> La matrice utilis�e ici, %(k1)s ne r�pond pas a ces crit�res !
"""),

49: _(u"""
Attention : plus de six modes de corps rigide ont �t� d�tect�s.

--> Conseil :
Si vous pensez avoir une seule structure dans le mod�le, cela peut provenir de noeud(s) orphelin(s). Dans ce cas, v�rifiez le maillage.
"""),

50: _(u"""
Attention  %(k1)s .VALF existe d�j�
"""),

51: _(u"""
Le tableau B est insuffisamment dimensionn� pour l'op�ration *
"""),

52: _(u"""
Attention :
  Le bloc %(i1)d a une longueur (%(i2)d) qui, en octets, sera sup�rieure � l'entier maximum pour cette machine (%(i3)d).
  Vous aurez un probl�me dans une allocation ult�rieure.
Conseil :
  Utilisez une machine 64 bits. Si vous y �tes d�j� votre �tude est vraiment trop volumineuse.
"""),

53: _(u"""
Toutes les fr�quences sont des fr�quences de corps rigide
"""),

54: _(u"""
Calcul des NUME_MODE : matrice non inversible pour la fr�quence consid�r�e
"""),

55: _(u"""
Probl�me � la r�solution du syst�me r�duit.
"""),

56: _(u"""
Valeur propre infinie trouv�e
"""),

57: _(u"""
M�thode QR : probl�me de convergence
"""),

58: _(u"""
Il y a des valeurs propres tr�s proches
"""),

60: _(u"""
La matrice : %(k1)s a une num�rotation incoh�rente avec le NUME_DDL.
"""),

61: _(u"""
Le concept "%(k1)s" a �t� cr�� avec les matrices
 MATR_RIGI (ou MATR_A) :                   %(k2)s
 MATR_MASS (ou MATR_RIGI_GEOM ou MATR_B) : %(k3)s
 MATR_AMOR (ou MATR_C) :                   %(k4)s
 et non avec celles pass�es en arguments.
"""),

62: _(u"""
Le concept "%(k1)s" a �t� cr�� avec les matrices
 MATR_RIGI (ou MATR_A) :                   %(k2)s
 MATR_MASS (ou MATR_RIGI_GEOM ou MATR_B) : %(k3)s
 et non avec celles pass�es en arguments.
"""),

63: _(u"""
Le syst�me � r�soudre n'a pas de DDL actif.

Conseil :
v�rifier que les DDL ne sont pas tous encastr�s.
"""),

64: _(u"""
On trouve plus de 9999 valeurs propres dans la bande demand�e
"""),






69: _(u"""
Option  %(k1)s non reconnue.
"""),

70: _(u"""
Le type des valeurs varie d'un mode � l'autre, r�cup�ration impossible.
"""),

71: _(u"""
Le nombre d'�quations est variable d'un mode � l'autre, r�cup�ration impossible.
"""),

72: _(u"""
Probl�me interne ARPACK
"""),

73: _(u"""
Probl�me taille WORKD/L -> augmenter DIM_SOUS_ESPACE
"""),

74: _(u"""
Probl�me interne LAPACK
"""),

75: _(u"""
Probl�me de construction du vecteur initial.

Conseil :
si possible, diminuer NMAX_FREQ (ou NMAX_CHAR_CRIT selon le type d'�tude).
"""),

76: _(u"""
Probl�me interne LAPACK, routine FLAHQR (forme de SCHUR)
"""),

77: _(u"""
Probl�me interne LAPACK, routine FTREVC (vecteurs propres)
"""),

78: _(u"""
Aucune valeur propre � la pr�cision requise.

Conseils :
augmenter PREC_SOREN ou NMAX_ITER_SOREN
ou augmenter DIM_SOUS_ESPACE.
"""),

79: _(u"""
La position modale d'une des fr�quences est n�gative ou nulle
votre syst�me matriciel est s�rement fortement singulier
(ceci correspond g�n�ralement � un probl�me dans la mod�lisation).
"""),

80: _(u"""
MODE � cr�er avant appel � VPSTOR
"""),

81: _(u"""
  Le shift=%(r1)g
  utilis� pour construire la matrice dynamique co�ncide avec une valeur propre !
  Avec l'option 'CENTRE', ce shift vaut %(k1)s,
  Avec l'option 'BANDE', c'est le milieu de la bande s�lectionn�e,
  Avec l'option 'PLUS_PETITE' ou 'TOUT', il prend la valeur 0.
  
  Malgr� la strat�gie de d�calage du shift, cette matrice dynamique reste
  num�riquement singuli�re.
  
  -> Risque :
  Cette matrice �tant abondamment utilis�e pour r�soudre des syst�mes lin�aires
  � chaque it�ration du processus modal, cette quasi singularit� peut fausser les r�sultats
  (mauvais conditionnement matriciel).

  -> Conseils :
  La structure analys�e pr�sente probablement des modes de corps rigide.
  
    * si aucun mode de corps rigide n'�tait attendu :
  Vous pouvez modifier les param�tres du solveur lin�aire (par exemple METHODE ou NPREC),
  ou ceux de l'algorithme de d�calage (PREC_SHIFT, NMAX_ITER_SHIFT et %(k2)s)
  pour v�rifier qu'il s'agit bien d'une singularit� et non d'un probl�me num�rique ponctuel.
  Si c'est une singularit�, v�rifiez la mise en donn�e du probl�me :
  conditions aux limites, maillage (pr�sence de noeuds / mailles orphelin(e)s), unit�s, ...

   * si ces modes �taient attendus et que vous ne voulez pas les calculer :
  Utilisez l'option 'BANDE' avec une borne inf�rieure suffisamment positive (par exemple 1.e-1).
   * si ces modes �taient attendus et que vous voulez les calculer :
  - utilisez l'option 'BANDE' avec une borne inf�rieure l�g�rement n�gative (par exemple -1.e-1).
  - utilisez la m�thode 'TRI_DIAG' avec OPTION='MODE_RIGIDE'.
"""),

82: _(u"""
  Cette borne minimale de la bande de recherche est une valeur propre !
"""),

83: _(u"""
  Cette borne maximale de la bande de recherche est une valeur propre !
"""),

84: _(u"""
  Malgr� la strat�gie de d�calage, la matrice dynamique reste num�riquement
  singuli�re.
  
  -> Risque :
  Le test de Sturm qui sert � �valuer le nombre de modes pr�sents dans l'intervalle
  peut �tre fauss�.

  -> Conseils :
  Vous pouvez modifier les param�tres du solveur lin�aire (par exemple METHODE ou NPREC),
  ou ceux de l'algorithme de d�calage (PREC_SHIFT, NMAX_ITER_SHIFT et %(k1)s) pour
  v�rifiez qu'il s'agit bien d'une singularit� et non d'un probl�me num�rique ponctuel.
  
  S'il ne s'agit pas d'un test de v�rification ('VERIFICATION A POSTERIORI DES MODES'),
  vous pouvez aussi relancer un autre calcul en d�calant les bornes de l'intervalle de
  recherche pour �viter cette fr�quence.
"""),

85: _(u"""
  La borne inf�rieure de l'intervalle a �t� d�cal�e plusieurs fois car elle est trop proche
  d'une valeur propre. En raison de ces d�calages, elle est devenue plus grande que la borne
  sup�rieure !

  -> Conseils :
  Relancez votre calcul en espa�ant suffisamment les bornes de l'intervalle (en tenant compte
  des valeurs des param�tres de d�calage NMAX_ITER_SHIFT et PREC_SHIFT).
"""),



90: _(u"""
Objet .REFE/.REFA/.CELK inexistant.
"""),

91: _(u"""
CHAM_NO non FETI
"""),

92: _(u"""
Liste de CHAM_NO � concat�ner h�t�rog�ne
"""),

93: _(u"""
Les CHAM_NO  %(k1)s  et  %(k2)s  sont de type inconnu  %(k3)s
"""),

94: _(u"""
Le CHAM_NO  %(k1)s  de type  %(k2)s  ne peut �tre copi� dans le CHAM_NO  %(k3)s  de type  %(k4)s
"""),

95: _(u"""
Champ � repr�sentation constante : cas non trait�.
"""),

96: _(u"""
CHOUT non FETI
"""),

97: _(u"""
Type de tri inconnu
"""),

98: _(u"""
Probl�me interne LAPACK, routine DLAHQR (forme de SCHUR)
"""),

99: _(u"""
Probl�me interne LAPACK, routine DTREVC (vecteurs propres)
"""),
}

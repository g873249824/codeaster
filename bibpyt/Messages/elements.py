#@ MODIF elements Messages  DATE 18/09/2007   AUTEUR PELLET J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg={

1: _("""
 arret du code
"""),

2: _("""
 ABS(RAYON2-RAYON1).GT.EPSI
"""),

3: _("""
 ABS(THETA2-THETA1).GT.EPSI
"""),

4: _("""
 ABS(OMEGA2-OMEGA1).GT.EPSI
"""),

5: _("""
 probl�me de maillage TUYAU
 pour une maille definie par les noeuds N1 N2 N3  le noeud N3 doit etre le noeud milieu
"""),

6: _("""
  GENE_TUYAU
  il faut donner un vecteur non colin�aire au tuyau
"""),

7: _("""
 angle du coude trop grand
"""),

8: _("""
  mailler plus fin
"""),

9: _("""
 il faut renseigner le coefficient E_N  dans les cas des d�formations planes et de l'axisym�trie
 on ne regarde donc que le cas des contraintes planes.
"""),

10: _("""
 Subroutine CHPVER :
 le champ  %(k1)s n'a pas le bon type :
   type autoris�  :%(k2)s
   type du champ  :%(k3)s
"""),

11: _("""
 la mod�lisation :  %(k1)s n'est pas trait�e.
"""),

12: _("""
 nombre de couches obligatoirement sup�rieur � 0
"""),

13: _("""
 nombre de couches limit� a 10 pour les coques 3d
"""),

14: _("""
 le type d'�l�ment :  %(k1)s n'est pas prevu.
"""),

15: _("""
 la nature du mat�riau  %(k1)s  n'est pas trait�e
 seules sont consid�r�es les natures : ELAS, ELAS_ISTR, ELAS_ORTH .
"""),

16: _("""
 type de maille inconnu
"""),

17: _("""
 noeuds confondus pour un �l�ment
"""),

18: _("""
 NNO invalide
"""),

19: _("""
 PB1
"""),

20: _("""
 aucun type d'�l�ments ne correspond au type demand�
"""),

21: _("""
 pr�dicteur ELAS hors champs
"""),

22: _("""
 IREP (indicateur de changement de rep�re) doit etre �gal � 0 ou 1
"""),

23: _("""
 piles satur&es
"""),

24: _("""
 derivatives of "mp" not defined
"""),

25: _("""
 on passe en m�canisme 2
"""),

26: _("""
 chargement en m�canisme 2 trop important
 � v�rifier
"""),

27: _("""
 on poursuit en m�canisme 2
"""),

28: _("""
 d�charge n�gative sans passer par meca 1 diminuer le pas de temps
"""),

29: _("""
 on revient en m�canisme 1
"""),

30: _("""
 pas de retour dans meca 1 trop important
 diminuer le pas de temps
"""),

31: _("""
 type d'�l�ment  %(k1)s  incompatible avec  %(k2)s
"""),

32: _("""
 comportement inattendu
"""),

33: _("""
 nombre d'it�rations > 1000 .
"""),

34: _("""
 �l�ment non trait�  %(k1)s
"""),

35: _("""
 pas d'excentrement avec STAT_NON_LINE
 maille  : %(k1)s
"""),

36: _("""
 nombre de couches n�gatif ou nul :  %(k1)s
"""),

37: _("""
 Subroutine CHPVER :
 le champ  %(k1)s n'a pas la bonne grandeur :
   grandeur autoris�e  :%(k2)s
   grandeur du champ   :%(k3)s
"""),

38: _("""
 probl�me PHESEN.NE.PHENOM
"""),

39: _("""
 l'axe de r�f�rence est normal � un �l�ment de plaque anisotrope
"""),

40: _("""
  -> L'axe de r�f�rence pour le calcul du rep�re local est normal � un
     au moins un �l�ment de plaque.
  -> Risque & Conseil :
     Il faut modifier l'axe de r�f�rence (axe X par d�faut) en utilisant
     ANGL_REP ou VECTEUR.

"""),

41: _("""
 impossibilit� :
 vous avez un materiau de type "ELAS_COQUE" et vous n'avez pas d�fini la raideur de membrane,
 ni sous la forme "MEMB_L", ni sous la forme "M_LLLL".
"""),

42: _("""
 comportement mat�riau non admis
"""),

43: _("""
 impossibilit� :
 vous avez un materiau de type "ELAS_COQUE" et le determinant de la sous-matrice de Hooke relative au cisaillement est nul.
"""),

44: _("""
 unknown option demanded
"""),

45: _("""
 N < 0
"""),

46: _("""
 nombre de couches n�gatif ou nul
"""),

47: _("""
 pas d excentrement avec FORC_NODA
 maille  : %(k1)s
"""),

48: _("""
 impossibilit�, la surface de l'�l�ment est nulle.
"""),

49: _("""
 l'axe de r�f�rence est normal � un �l�ment de plaque
 calcul option impossible
 orienter ces mailles
"""),

50: _("""
 comportement elastique inexistant
"""),

51: _("""
  -> Le type de comportement %(k1)s n'est pas pr�vu pour le calcul de
     SIGM_ELNO_DEPL. Les seuls comportements autoris�s sont :
     ELAS, ELAS_COQUE, ou ELAS_ORTH
  -> Risque & Conseil :
     Pour les autres comportements, utiliser SIEF_ELNO_ELGA (efforts)
     ou SIGM_ELNO_COQU (contraintes en un point de l'�paisseur).
"""),

52: _("""
 lorsqu'il y a variation de temp�rature dans l'�paisseur, utiliser "STAT_NON_LINE"
"""),

53: _("""
 probl�me: temperature sur la maille: %(k1)s : il manque la composante "TEMP"
"""),

54: _("""
 �l�ment non pr�vu
"""),

55: _("""
 ELREFA inconnu:  %(k1)s
"""),

56: _("""
  erreur programmeur
  ecrasement de dff, dimf est inf�rieur au nombre de noeuds * nombre de composantes
"""),

57: _("""
  erreur programmeur
  �crasement de FF, DIMF est inf�rieur au nombre de noeuds
"""),

58: _("""
 la nature du mat�riau  %(k1)s  n�cessite la d�finition du coefficient  B_ENDOGE dans DEFI_MATERIAU.
"""),

59: _("""
 bizarre :  %(k1)s
"""),

60: _("""
 on ne sait pas traiter :  %(k1)s
"""),

61: _("""
 AXI : R=0
"""),

62: _("""
 GROUP_MA :  %(k1)s  inconnu dans le maillage
"""),

63: _("""
 erreurs GROUP_MA
"""),

64: _("""
  le LIAISON_*** de  %(k1)s  implique les noeuds physiques  %(k2)s  et  %(k3)s et traverse l'interface
"""),

65: _("""
  le LIAISON_*** de  %(k1)s  implique le noeud physique  %(k2)s et touche l'interface
"""),

66: _("""
 si NOEUD_ORIG : donner un GROUP_MA ou une liste de mailles
 on ne r�ordonne pas les GROUP_NO et les listes de noeuds.
"""),

67: _("""
 le GROUP_NO :  %(k1)s n'existe pas.
"""),

68: _("""
 le noeud origine  %(k1)s ne fait pas partie du chemin
"""),

69: _("""
 le noeud origine  %(k1)s  n'est pas une extremit�
"""),

70: _("""
 pas d'origine d�finie par NOEUD_ORIG ou GROUP_NO_ORIG
"""),

71: _("""
 �chec dans la recherche du noeud origine
"""),

72: _("""
 group_no orient� : noeud origine =  %(k1)s
"""),

73: _("""
 le group_ma :  %(k1)s n'existe pas.
"""),

74: _("""
 si le fond est une courbe ferm�e MAILLE_ORIG ou GROUP_MA_ORIG doit accompagner NOEUD_ORIG
"""),

75: _("""
 le noeud_orig n'appartient pas a la maille_orig
"""),

76: _("""
 la maille_orig %(k1)s  n'appartient pas au fond de fissure
"""),

77: _("""
 le noeud extremit�  %(k1)s  n'est pas le dernier noeud
"""),

78: _("""
 GROUP_NO orient� : noeud extremit� =  %(k1)s
"""),

79: _("""
 il y a � la fois des �l�ments volumiques de degr� 1 et de degr� 2 dans le mod�le
 on a besoin de savoir si on est en lineaire ou en quadratique pour choisir la methode de lissage.
"""),

80: _("""
 le concept FOND_FISS est mal cr��
"""),

81: _("""
 le .VALE du CHAM_NO DIRE_THETA n'a pas la bonne taille
"""),

82: _("""
 l'option de lissage 'LAGRANG2' n'a pas ete d�velopp�e lorsque le nombre de noeuds d'un fond de fissure ferm� est pair.
"""),

83: _("""
 le type des mailles des l�vres doit etre quadrangle ou triangle
"""),

84: _("""
  %(k1)s CHAM_NO inexistant
"""),

85: _("""
 initial point NM out of domain
"""),

86: _("""
 NDICHO  .GT.  10000
"""),

87: _("""
 bad definition of MP1 and MP2
"""),

88: _("""
 le fond de fissure ne doit etre d�fini que par un noeud
 ( revoir le GROUP_NO )
"""),

89: _("""
 le fond de fissure ne doit etre d�fini que par un noeud
"""),

90: _("""
Erreur de programmation :
   L'attribut NBSIGM n'est pas d�fini pour cette mod�lisation.
Solution :
   Il faut modifier la catalogue phenomene_modelisation__.cata pour ajouter NBSIGM pour cette mod�lisation.
"""),

91: _("""
 mot cl� FOND_FISS obligatoire
"""),

92: _("""
 le fond de fissure ne doit etre d�fini que par un noeud
 ( revoir FOND_FISS )
"""),

93: _("""
  %(k1)s  n'est pas un GROUP_NO ou un GROUP_MA
"""),

94: _("""
 arret sur erreur(s) utilisateur.
"""),

95: _("""
 les mailles des l�vres doivent etre lin�iques
"""),

96: _("""
 erreur : la levre superieure possede une maille r�p�t�e 2 fois : maille  %(k1)s
 revoir les donn�es
"""),

97: _("""
 erreur : la l�vre inf�rieure poss�de une maille r�p�t�e 2 fois : maille  %(k1)s
 revoir les donn�es
"""),

98: _("""
 erreur : la l�vre inf�rieure et la l�vre superieure ont une maille surfacique en commun
 revoir les donn�es
"""),

99: _("""
 probl�me dans le calcul de la normale � la fissure
"""),
}

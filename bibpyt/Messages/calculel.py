#@ MODIF calculel Messages  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
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
 trop de parametres.
"""),

2: _("""
 stop 1
"""),

3: _("""
 la grandeur :  %(k1)s  n existe pas dans le catalogue des grandeurs.
"""),

4: _("""
 incoherence des maillages : %(k1)s  et  %(k2)s
"""),

5: _("""
 stop 1a
"""),

6: _("""
 stop 1b
"""),

7: _("""
 stop 1c
"""),


9: _("""
 stop 4
"""),

10: _("""
 stop 5
"""),

11: _("""
 le mode_local:  %(k1)s  ne doit pas etre vecteur ou matrice.
"""),

12: _("""
 le mode_local:  %(k1)s  ne doit pas etre "diff__".
"""),

13: _("""
 stop
"""),

14: _("""
  incompatibilite des type_champ ("elga"/"elno")  pour l option :  %(k1)s  entre les 2 type_elem :  %(k2)s  et  %(k3)s
"""),

15: _("""
 type de face non prevu
"""),

16: _("""
 type de maille indisponible
"""),

17: _("""
 type de champ inconnu
"""),

18: _("""
 la partie reelle et imaginaire du champ a assembler ne sont pas du meme type (l un est un cham_no et l autre un cham_elem
"""),

19: _("""
 champ incompatible
"""),

20: _("""
 le champ de grandeur  %(k1)s  ne respecte pas le format xxxx_r
"""),

21: _("""
 les champs reel et imaginaire a assembler ne contiennent pas la meme grandeur
"""),

22: _("""
 probleme dans le catalogue des grandeurs simples, la grandeur %(k1)s  ne possede pas le meme nombre de champ que son homologue complexe %(k2)s
"""),

23: _("""
 probleme dans le catalogue des grandeurs simples, la grandeur  %(k1)s  ne possede pas les memes champs que son homologue complexe  %(k2)s
"""),

24: _("""
 les champs a assembler n ont pas la meme longueur
"""),

25: _("""
 type de champ incorrect
"""),

26: _("""
 longueurs des cham_elem incompatibles
"""),

27: _("""
 cham_elem a combiner incompatible
"""),

28: _("""
  %(k1)s  indisponible
"""),

29: _("""
 option inconnue au catalogue :  %(k1)s
"""),

30: _("""
  -> Le TYPE_ELEMENT %(k1)s  ne sait pas encore calculer l'OPTION:  %(k2)s.
     On ne calcule donc rien sur les �l�ments de ce type.

  -> Risque & Conseil :
     V�rifiez que l'option incompl�tement calcul�e est bien une option de post-traitement
     et que le d�ficit de calcul n'entraine pas de r�sultats faux.

"""),

32: _("""
 dvp : Valeur interdite
"""),

34: _("""
 le calcul de l'option :  %(k1)s  n'est possible pour aucun des types d'elements  du ligrel.
"""),

35: _("""
 erreur programmeur : trop de champs "in"
"""),

36: _("""
 On ne sait pas faire.
"""),

37: _("""
 Erreur dans la lecture des CHAR_CINE ou dans les CHAR_CINE
"""),

38: _("""
 la carte concerne aussi des mailles tardives qui sont oubliees.
"""),

39: _("""
 type scalaire inconnu
"""),

40: _("""
 Erreur Programmeur : type_scalaire: %(k1)s  non autoris� (I/R/C),
"""),

41: _("""
 Erreur Programmeur : type_scalaire: %(k1)s  non autoris� (I/R/C/K8/K16/K24),
"""),

42: _("""
 Erreur Programmeur:
 Incoherence fortran/catalogue type_element:  %(k1)s  option:  %(k2)s
 La routine texxxx.f correspondant au calcul �l�mentaire ci-dessus est buggu�e :
 Elle �crit en dehors de la zone allou�e au param�tre (OUT) %(k3)s.

"""),

43: _("""
 Arret du aux erreurs precedentes.
"""),

44: _("""
 Code interdit:  %(k1)s
"""),

45: _("""
 Erreur Programmeur :
 Transformation non programm�e : �mettre une fiche d'�volution
"""),

46: _("""
 a faire ...  : �mettre une fiche d'�volution
"""),

47: _("""
  le cham_elem:  %(k1)s  n'existe pas.
"""),

48: _("""
 le cham_elem: %(k1)s  n'a pas le meme nombre de cmps dynamiques sur tous ses elements.
"""),

49: _("""
 le cham_elem : %(k1)s  a des sous-points.
"""),

50: _("""
 type de verif. inconnu.
"""),

51: _("""
 argument prol0 invalide.
"""),

52: _("""
 la cmp: %(k1)s  n'appartient pas a la grandeur: %(k2)s
"""),

53: _("""
 option : %(k1)s  inexistante dans les catalogues.
"""),

54: _("""
 le parametre:  %(k1)s  de l'option:  %(k2)s  n'est pas connu des type_elem du ligrel:  %(k3)s
"""),

55: _("""
 il manque la cmp: %(k1)s
"""),

56: _("""
 le ligrel contient des mailles tardives,
"""),

57: _("""
 nombres de points differents pour la maille:  %(k1)s  cham_elem de:  %(k2)s
"""),

58: _("""
 il manque la cmp: %(k1)s  sur la maille: %(k2)s
"""),

59: _("""
 champ 1 inexistant
"""),

60: _("""
 Matrice noeud->gauss n�cessaire
"""),

61: _("""
 Erreur Programmeur :
 Argument cesmod obligatoire
"""),

62: _("""
 champ inexistant
"""),

63: _("""
 on ne traite que des champs "ELNO"
"""),

64: _("""
 le nombre de sous-points ne peut etre >1
"""),

65: _("""
 des reels ou des complexes svp !
"""),

66: _("""
 TYPCES invalide
"""),

67: _("""
 grandeur:  %(k1)s  inconnue au catalogue.
"""),

68: _("""
 numero de maille invalide:  %(k1)s  (<1 ou >nbma)
"""),

69: _("""
 numero de point invalide:  %(k1)s  (<1 ou >nbpt) pour la maille:  %(k2)s
"""),

70: _("""
 numero de sous_point invalide:  %(k1)s  (<1 ou >nbspt) pour la maille:  %(k2)s  et pour le point:  %(k3)s
"""),

71: _("""
 numero de cmp invalide:  %(k1)s  (<1 ou >nbcmp) pour la maille:  %(k2)s  pour le point:  %(k3)s  et pour le sous_point:  %(k4)s
"""),

72: _("""
 nbchs >0 svp
"""),

73: _("""
 maillages differents.
"""),

74: _("""
 grandeurs differentes.
"""),

75: _("""
 types differents (CART/ELNO/ELGA).
"""),

76: _("""
 nombre de points differents.
"""),

77: _("""
 nombre de sous-points differents.
"""),

78: _("""
 cumul interdit sur ce type non-numerique
"""),

79: _("""
 i/r/k8/k16 svp
"""),

80: _("""
 trop de cmps (997)
"""),

81: _("""
 maillages differents
"""),

82: _("""
 nbcmp doit etre >=0
"""),

83: _("""
 nbma doit etre >=0
"""),

84: _("""
 stop nomgd
"""),

85: _("""
 stop nbpt
"""),

86: _("""
 stop nbsp
"""),

87: _("""
 stop iad2
"""),

88: _("""
 caractere illicite.
"""),

89: _("""
 on ne sait pas encore traiter les resuelem
"""),

90: _("""
 type de champ interdit: %(k1)s
"""),

91: _("""
 incoherence des familles de points de gauss pour la maille  %(k1)s  ( %(k2)s / %(k3)s )
"""),

92: _("""
 type scalaire du cham_no :  %(k1)s  non reel.
"""),

93: _("""
 type scalaire du nume_ddl :  %(k1)s  non reel.
"""),

94: _("""
 si ncorr=0, les grandeurs doivent etre identiques : %(k1)s , %(k2)s
"""),

95: _("""
  ncorr doit etre pair.
"""),

96: _("""
 gauss -> noeud a faire ...
"""),

97: _("""
 il faut modele
"""),

98: _("""
 non programme: %(k1)s
"""),

99: _("""
 melange de cham_elem_s et cham_no_s
"""),
}

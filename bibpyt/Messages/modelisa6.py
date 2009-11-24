#@ MODIF modelisa6 Messages  DATE 23/11/2009   AUTEUR DURAND C.DURAND 
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
 Probl�me d'orientation: aucune maille ne touche le noeud indiqu�
"""),

2 : _("""
 Certaines mailles n'ont pas pu �tre r�orient�es. L'ensemble des mailles n'est pas connexe.
"""),

3 : _("""
 on ne trouve pas de noeud assez pr�s du noeud  %(k1)s
"""),

4 : _("""
  Erreurs dans les donn�es
"""),

5 : _("""
 Extraction de plus de noeuds que n'en contient la maille
"""),

6 : _("""
  Nombre de noeuds n�gatif
"""),

7 : _("""
 nombre de noeuds sommets non pr�vu
"""),

8 : _("""
  on est sur 2 mailles orthogonales
"""),

9 : _("""
 le type de maille est inconnu
"""),

10 : _("""
 la maille  %(k1)s  ne fait pas partie du maillage  %(k2)s
"""),

11 : _("""
 PREF_MAILLE est trop long, PREF_NUME est trop grand
"""),

12 : _("""
 PREF_MAILLE est trop long
"""),

13 : _("""
 les %(i1)d noeuds imprim�s ci-dessus n'appartiennent pas au mod�le (c'est � dire qu'ils ne portent aucun degr� de libert�) et pourtant ils ont ete affect�s dans le mot-cl� facteur : %(k1)s
"""),


17 : _("""
 la maille  %(k1)s  du group_ma  %(k2)s donne apres le mot cle  %(k3)s n'a pas un type g�om�trique autoris�
"""),

18 : _("""
 la maille  %(k1)s donn� apr�s le mot cl�  %(k2)s n'a pas un type g�om�trique autoris�
"""),

19 : _("""
  mot cle non admis : %(k1)s  les mots-cl�s admissibles sont :  %(k2)s  ou  %(k3)s  ou  %(k4)s  ou  %(k5)s  ou  %(k6)s  ou  %(k7)s  ou  %(k8)s ou  %(k9)s
"""),

20 : _("""
 ce type de maille n'est pas encore trait� :  %(k1)s
"""),

21 : _("""
 le nombre total de noeuds est /= de la somme des noeuds sommets, ar�tes et int�rieurs
"""),

22 : _("""
 les 2 listes %(k1)s  et  %(k2)s  ne sont pas de meme longueur
"""),

26 : _("""
 AFFE_FIBRE pour " %(k1)s ": il y a  %(k2)s  valeurs pour "VALE", ce devrait �tre un multiple de 3
"""),

27 : _("""
 dans le maillage " %(k1)s " la maille " %(k2)s " est de type " %(k3)s " (ni TRIA3 ni QUAD4)
"""),

30 : _("""
 l'indicateur :  %(k1)s de position des multiplicateurs de lagrange associ�s � une relation lineaire n'est pas correct.
"""),

31 : _("""
  ->  En thermique, les fonctions d�finissant le mat�riau (enthalpie, capacit� calorifique, conductivit�)
      doivent obligatoirement �tre d�crites par des fonctions tabul�es et non des formules.
      En effet, on a besoin d'�valuer la d�riv�e de ces fonctions. Elle peut �tre plus facilement et
      pr�cis�ment obtenue pour une fonction lin�aire par morceaux que pour une expression 'formule'.
  -> Conseil:
      Tabulez votre formule, � une finesse de discr�tisation d'abcisse (TEMP) � votre convenance,
      par la commande CALC_FONC_INTERP
 """),

33 : _("""
 il faut COEF_GROUP ou FONC_GROUP
"""),

34 : _("""
 un element n'est ni TRIA3 ni TRIA6 ni QUAD4 ni QUAD8
"""),

35 : _("""
 un element n'est ni TRIA3 ni TRIA6 ni TRIA7 ni QUAD4 ni QUAD8 ni QUAD9
"""),

36 : _("""
  le noeud  %(k1)s  doit appartenir � une seule maille
"""),

37 : _("""
 la maille � laquelle appartient le noeud  %(k1)s  doit etre de type SEG3
"""),

38 : _("""
 on ne trouve pas les angles nautiques pour le tuyau
"""),

39 : _("""
 option  %(k1)s  invalide
"""),

40 : _("""
 il faut indiquer le mot-cle 'NOEUD_2' ou 'GROUP_NO_2' apr�s le mot-facteur  %(k1)s  pour l'option '3D_POU'.
"""),

41 : _("""
 il ne faut donner qu'un seul noeud de poutre a raccorder au massif.
"""),

42 : _("""
 il ne faut donner qu'un un seul GROUP_NO � un noeud � raccorder au massif.
"""),

43 : _("""
 il ne faut donner q'un seul noeud dans le GROUP_NO :  %(k1)s
"""),

44 : _("""
 impossibilit�, le noeud  %(k1)s porte le ddl de rotation  %(k2)s
"""),

45 : _("""
 impossibilit�, le noeud poutre  %(k1)s  devrait porter le ddl  %(k2)s
"""),

46 : _("""
 impossibilit�, la surface de raccord du massif est nulle
"""),

47 : _("""
 il faut donner un CARA_ELEM pour r�cup�rer les caract�ristiques de tuyau.
"""),

48 : _("""
 il faut indiquer le mot-cle 'NOEUD_2' ou 'GROUP_NO_2' apr�s le mot-facteur  %(k1)s  pour l'option  %(k2)s
"""),

49 : _("""
 il ne faut donner qu'un seul noeud de poutre � raccorder � la coque.
"""),

50 : _("""
 il ne faut donner qu'un seul GROUP_NO � un noeud � raccorder � la coque.
"""),

51 : _("""
 il faut donner un vecteur orientant l'axe de la poutre sous le mot-cle "AXE_POUTRE".
"""),

52 : _("""
 il faut donner un vecteur non nul orientant l'axe de la poutre sous le mot-cle "AXE_POUTRE".
"""),

53 : _("""
 il faut donner un CARA_ELEM pour r�cup�rer l'�paisseur des �l�ments de bord.
"""),

54 : _("""
 impossibilit�, le noeud  %(k1)s ne porte pas le ddl de rotation  %(k2)s
"""),

55 : _("""
 impossibilit�, la surface de raccord de la coque est nulle
"""),

56 : _("""
 plusieurs comportements de type  %(k1)s  ont ete trouv�s
"""),

57 : _("""
 comportement de type  %(k1)s  non trouv�
"""),

58 : _("""
 nappe interdite pour les caract�ristiques mat�riau
"""),

59 : _("""
 d�formation plastique cumul�e p < 0
"""),

60 : _("""
  Le prolongement � droite �tant exclu pour la fonction %(k1)s,
  il n'est pas possible d'extrapoler la fonction R(p) en p = %(r1)f.
"""),

62 : _("""
 la limite d elasticite est deja renseignee dans elas_meta
"""),

63 : _("""
 objet  %(k1)s .materiau.nomrc non trouve
"""),

64 : _("""
 type sd non trait�:  %(k1)s
"""),

69 : _("""
 le mot cle: %(k1)s  est identique (sur ses 8 1ers caracteres) � un autre.
"""),

70 : _("""
 erreur lors de la d�finition de la courbe de traction, il manque le param�tre : %(k1)s
"""),

71 : _("""
 erreur lors de la d�finition de la courbe de traction : %(k1)s  nb de points < 2  !
"""),

72 : _("""
 erreur lors de la d�finition de la courbe de traction : %(k1)s  nb de points < 1  !
"""),

73 : _("""
 erreurs rencontr�es.
"""),

74 : _("""
 erreur lors de la d�finition de la nappe des courbes de traction: nb de points < 2 !
"""),

75 : _("""
 erreur lors de la d�finition de la nappe des courbes de traction:  %(k1)s  nb de points < 1 !
"""),

76 : _("""
  erreur lors de la d�finition de la courbe de traction: fonction ou nappe !
"""),

80 : _("""
 comportement TRACTION non trouve
"""),

81 : _("""
 fonction SIGM non trouv�e
"""),

82 : _("""
 comportement meta_traction non trouv�
"""),

83 : _("""
 fonction SIGM_F1 non trouv�e
"""),

84 : _("""
 fonction SIGM_F2 non trouv�e
"""),

85 : _("""
 fonction SIGM_F3 non trouv�e
"""),

86 : _("""
 fonction SIGM_F4 non trouv�e
"""),

87 : _("""
 fonction SIGM_C non trouv�e
"""),

88 : _("""
 fonction constante interdite pour la courbe de traction %(k1)s
"""),

89 : _("""
 prolongement � gauche EXCLU pour la courbe  %(k1)s
"""),

90 : _("""
 prolongement � droite EXCLU pour la courbe  %(k1)s
"""),

91 : _("""
 concept de type :  %(k1)s  interdit pour la courbe de traction %(k2)s
"""),

92 : _("""
 materiau : %(k1)s  non trouv�
"""),

93 : _("""
  les fonctions complexes ne sont pas implement�es
"""),

94 : _("""
 nb param. > 30 materiau  %(k1)s
"""),

95 : _("""
 mauvaise definition de la plage de frequence, aucun mode pris en compte
"""),

96 : _("""
 les %(i1)d mailles imprim�es ci-dessus n'appartiennent pas au mod�le et pourtant elles ont ete affect�es dans le mot-cl� facteur : %(k1)s
"""),

97 : _("""
 FREQ INIT plus grande que FREQ FIN
"""),

98 : _("""
 FREQ INIT n�cessaire avec CHAMNO
"""),

99 : _("""
 FREQ FIN n�cessaire avec CHAMNO
"""),

}

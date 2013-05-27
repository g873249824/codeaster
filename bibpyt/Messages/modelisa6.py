# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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

1 : _(u"""
 Probl�me d'orientation: aucune maille ne touche le noeud indiqu�
"""),

2 : _(u"""
 Certaines mailles n'ont pas pu �tre r�orient�es. L'ensemble des mailles n'est pas connexe.
"""),

3 : _(u"""
 on ne trouve pas de noeud assez pr�s du noeud  %(k1)s
"""),

4 : _(u"""
  Erreurs dans les donn�es
"""),

5 : _(u"""
 Extraction de plus de noeuds que n'en contient la maille
"""),

6 : _(u"""
  Nombre de noeuds n�gatif
"""),

7 : _(u"""
 nombre de noeuds sommets non pr�vu
"""),

8 : _(u"""
  on est sur 2 mailles orthogonales
"""),

9 : _(u"""
 le type de maille est inconnu
"""),

10 : _(u"""
 la maille  %(k1)s  ne fait pas partie du maillage  %(k2)s
"""),

11 : _(u"""
 PREF_MAILLE est trop long, PREF_NUME est trop grand
"""),

12 : _(u"""
 PREF_MAILLE est trop long
"""),

13 : _(u"""
 Les %(i1)d noeuds imprim�s ci-dessus n'appartiennent pas au mod�le (c'est � dire
 qu'ils ne portent aucun degr� de libert�) et pourtant ils ont �t� affect�s dans
 le mot-cl� facteur : %(k1)s
"""),

14 : _(u"""
 Pour le chargement thermique ECHANGE_PAROI, le mod�le fourni doit �tre homog�ne
 en dimension : 3D, 2D ou AXIS.
"""),

17 : _(u"""
 La maille  %(k1)s du GROUP_MA  %(k2)s donn� apr�s le mot-cl�  %(k3)s n'a pas un
 type g�om�trique autoris�
"""),

18 : _(u"""
 la maille  %(k1)s donn�e apr�s le mot-cl�  %(k2)s n'a pas un type g�om�trique autoris�
"""),

20 : _(u"""
 ce type de maille n'est pas encore trait� :  %(k1)s
"""),

21 : _(u"""
 le nombre total de noeuds est diff�rent de la somme des noeuds sommets, ar�tes et int�rieurs
"""),

22 : _(u"""
 les deux listes %(k1)s  et  %(k2)s  ne sont pas de m�me longueur
"""),

26 : _(u"""
 AFFE_FIBRE pour " %(k1)s ": il y a  %(k2)s  valeurs pour "VALE", ce devrait �tre un multiple de 3
"""),

27 : _(u"""
 Dans le maillage " %(k1)s " la maille " %(k2)s " est de type " %(k3)s " (ni TRIA3 ni QUAD4)
"""),

28 : _(u"""
 Le noeud <%(k1)s> de la poutre, de coordonn�es <%(r1)g  %(r2)g  %(r3)g>,
 ne doit pas appartenir � des mailles constituant la trace de la poutre sur la coque.
 Le probl�me vient de l'occurrence %(i1)d de LIAISON_ELEM.

Solution : Il faut d�doubler le noeud.
"""),

29 : _(u"""
 Une maille des groupes mod�lisant la dalle a une dimension topologique diff�rente
 de 1 et 2.
"""),

30 : _(u"""
 L'indicateur : %(k1)s de position des multiplicateurs de Lagrange associ�s �
 une relation lin�aire n'est pas correct.
"""),

31 : _(u"""
  ->  En thermique, les fonctions d�finissant le mat�riau (enthalpie, capacit� calorifique, conductivit�)
      doivent obligatoirement �tre d�crites par des fonctions tabul�es et non des formules.
      En effet, on a besoin d'�valuer la d�riv�e de ces fonctions. Elle peut �tre plus facilement et
      pr�cis�ment obtenue pour une fonction lin�aire par morceaux que pour une expression 'formule'.
  -> Conseil:
      Tabulez votre formule, � une finesse de discr�tisation d'abscisse (TEMP) � votre convenance,
      par la commande CALC_FONC_INTERP
 """),

32 : _(u"""
 impossibilit�, le noeud  %(k1)s ne porte le degr� de libert� de rotation %(k2)s
"""),

33 : _(u"""
 il faut COEF_GROUP ou FONC_GROUP
"""),

34 : _(u"""
 un �l�ment n'est ni TRIA3 ni TRIA6 ni QUAD4 ni QUAD8
"""),

35 : _(u"""
 Les mailles des groupes mod�lisant la dalle ne sont pas toutes de m�me
 dimension topologique (RIGI_PARASOL)
"""),

36 : _(u"""
  le noeud  %(k1)s  doit appartenir � une seule maille
"""),

37 : _(u"""
 la maille � laquelle appartient le noeud  %(k1)s  doit �tre de type SEG3
"""),

38 : _(u"""
 on ne trouve pas les angles nautiques pour le tuyau
"""),

39 : _(u"""
 option  %(k1)s  invalide
"""),

40 : _(u"""
 il faut indiquer le mot-cl� 'NOEUD_2' ou 'GROUP_NO_2' apr�s le mot-cl� facteur  %(k1)s  pour l'option '3D_POU'.
"""),

41 : _(u"""
 il ne faut donner qu'un seul noeud de poutre � raccorder au massif.
"""),

42 : _(u"""
 il ne faut donner qu'un un seul GROUP_NO � un noeud � raccorder au massif.
"""),

43 : _(u"""
 il ne faut donner qu'un seul noeud dans le GROUP_NO :  %(k1)s
"""),

44 : _(u"""
 impossibilit�, le noeud  %(k1)s porte le degr� de libert� de rotation  %(k2)s
"""),

45 : _(u"""
 impossibilit�, le noeud poutre  %(k1)s  devrait porter le degr� de libert�  %(k2)s
"""),

46 : _(u"""
 impossibilit�, la surface de raccord du massif est nulle
"""),

47 : _(u"""
 il faut donner un CARA_ELEM pour r�cup�rer les caract�ristiques de tuyau.
"""),

48 : _(u"""
 il faut indiquer le mot-cl� 'NOEUD_2' ou 'GROUP_NO_2' apr�s le mot-cl� facteur  %(k1)s  pour l'option  %(k2)s
"""),

49 : _(u"""
 il ne faut donner qu'un seul noeud de poutre � raccorder � la coque.
"""),

50 : _(u"""
 il ne faut donner qu'un seul GROUP_NO � un noeud � raccorder � la coque.
"""),

51 : _(u"""
 il faut donner un vecteur orientant l'axe de la poutre sous le mot-cl� "AXE_POUTRE".
"""),

52 : _(u"""
 il faut donner un vecteur non nul orientant l'axe de la poutre sous le mot-cl� "AXE_POUTRE".
"""),

53 : _(u"""
 il faut donner un CARA_ELEM pour r�cup�rer l'�paisseur des �l�ments de bord.
"""),

54 : _(u"""
 impossibilit�, le noeud  %(k1)s ne porte pas le degr� de libert� de rotation  %(k2)s
"""),

55 : _(u"""
 impossibilit�, la surface de raccord de la coque est nulle
"""),

56 : _(u"""
 plusieurs comportements de type  %(k1)s  ont �t� trouv�s

  -> Conseil:
     Vous avez sans doute enrichi votre mat�riau. Vous ne pouvez pas
     avoir en m�me temps les mots cl�s 'ELAS', 'ELAS_FO', 'ELAS_xxx',...
"""),

57 : _(u"""
 comportement de type  %(k1)s  non trouv�
"""),

58 : _(u"""
 nappe interdite pour les caract�ristiques mat�riau
"""),

59 : _(u"""
 d�formation plastique cumul�e p < 0
"""),

60 : _(u"""
  Le prolongement � droite �tant exclu pour la fonction %(k1)s,
  il n'est pas possible d'extrapoler la fonction R(p) au del� de p = %(r1)f
"""),

62 : _(u"""
 la limite d'�lasticit� est d�j� renseign�e dans ELAS_META
"""),

63 : _(u"""
 objet  %(k1)s .materiau.nomrc non trouv�
"""),

64 : _(u"""
 type sd non trait�:  %(k1)s
"""),

69 : _(u"""
 le mot-cl� : %(k1)s  est identique (sur ses 8 premiers caract�res) � un autre.
"""),

70 : _(u"""
 erreur lors de la d�finition de la courbe de traction, il manque le param�tre : %(k1)s
"""),

71 : _(u"""
 erreur lors de la d�finition de la courbe de traction : %(k1)s  nombre de points < 2  !
"""),

72 : _(u"""
 erreur lors de la d�finition de la courbe de traction : %(k1)s  nombre de points < 1  !
"""),

73 : _(u"""
 erreurs rencontr�es.
"""),

74 : _(u"""
 erreur lors de la d�finition de la nappe des courbes de traction: nombre de points < 2 !
"""),

75 : _(u"""
 erreur lors de la d�finition de la nappe des courbes de traction:  %(k1)s  nombre de points < 1 !
"""),

76 : _(u"""
  erreur lors de la d�finition de la courbe de traction: FONCTION ou NAPPE !
"""),

80 : _(u"""
 comportement TRACTION non trouv�
"""),

81 : _(u"""
 fonction SIGM non trouv�e
"""),

82 : _(u"""
 comportement META_TRACTION non trouv�
"""),

83 : _(u"""
 fonction SIGM_F1 non trouv�e
"""),

84 : _(u"""
 fonction SIGM_F2 non trouv�e
"""),

85 : _(u"""
 fonction SIGM_F3 non trouv�e
"""),

86 : _(u"""
 fonction SIGM_F4 non trouv�e
"""),

87 : _(u"""
 fonction SIGM_C non trouv�e
"""),

88 : _(u"""
 fonction constante interdite pour la courbe de traction %(k1)s
"""),

89 : _(u"""
 prolongement � gauche EXCLU pour la courbe  %(k1)s
"""),

90 : _(u"""
 prolongement � droite EXCLU pour la courbe  %(k1)s
"""),

91 : _(u"""
 concept de type :  %(k1)s  interdit pour la courbe de traction %(k2)s
"""),

92 : _(u"""
 mat�riau : %(k1)s  non affect� par la commande AFFE_MATERIAU.
"""),

93 : _(u"""
  les fonctions complexes ne sont pas impl�ment�es
"""),

94 : _(u"""
 Le nombre de param�tres est sup�rieur � 30 pour le mat�riau  %(k1)s
"""),

95 : _(u"""
 mauvaise d�finition de la plage de fr�quence, aucun mode pris en compte
"""),

96 : _(u"""
 les %(i1)d mailles imprim�es ci-dessus n'appartiennent pas au mod�le et pourtant elles ont �t� affect�es dans le mot-cl� facteur : %(k1)s
"""),

97 : _(u"""
 FREQ INIT plus grande que FREQ FIN
"""),

98 : _(u"""
 FREQ INIT n�cessaire avec CHAMNO
"""),

99 : _(u"""
 FREQ FIN n�cessaire avec CHAMNO
"""),

}

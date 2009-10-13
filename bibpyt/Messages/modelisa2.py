#@ MODIF modelisa2 Messages  DATE 13/10/2009   AUTEUR COURTOIS M.COURTOIS 
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
 Formule interdite pour d�finir ALPHA(TEMP) : la fonction soit etre tabul�e.
 Utilisez CALC_FONC_INTERP
"""),

2: _("""
 resserrer le mot cle precision pour le materiau elas_fo
"""),

3: _("""
 calcul de la tension le long du cable no %(k1)s  : la longueur sur laquelle on devrait prendre en compte les pertes de tension par recul de l ancrage est superieure a la longueur du cable
"""),

4: _("""
 calcul de la tension le long du cable no %(k1)s  : la longueur sur laquelle on doit prendre en compte les pertes de tension par recul de l ancrage est egale a la longueur du cable
"""),

5: _("""
 Formule interdite pour le calcul d'int�grale : la fonction soit etre tabul�e.
 Utilisez CALC_FONC_INTERP pour tabuler la formule %(k1)s
"""),

9: _("""
  Erreur utilisateur :
    l'objet %(k1)s n'existe pas. On ne peut pas continuer.
  Risques & conseils :
    Dans ce contexte, les seuls solveurs autoris�s sont MULT_FRONT et LDLT
"""),

13: _("""
 probl�me pour recuperer une grandeur dans la table "cara_geom"
"""),

14: _("""
 plus petite taille de maille negative ou nulle
"""),

15: _("""
 groupe de maille group_ma_1= %(k1)s  inexistant dans le maillage  %(k2)s
"""),

16: _("""
 groupe de maille group_ma_2= %(k1)s  inexistant dans le maillage  %(k2)s
"""),

17: _("""
 les groupes de mailles group_ma_1= %(k1)s  et group_ma_2= %(k2)s  ont des cardinaux diff�rents
"""),

18: _("""
 nombre de noeuds incoherent sous les 2 group_ma a coller
"""),

19: _("""
 un noeud de group_ma_2 n est geometriquement appariable avec aucun de group_ma_1
"""),

20: _("""
 les 2 maillages doivent etre du meme type : 2d (ou 3d).
"""),

21: _("""
  -> Le group_ma %(k1)s est pr�sent dans les 2 maillages que l'on assemble.
     Il y a conflit de noms. Le group_ma du 2eme maillage est renomm�.
  -> Risque & Conseil :
     V�rifiez que le nom du group_ma retenu est bien celui souhait�.
"""),

22: _("""
  -> Le group_no %(k1)s est pr�sent dans les 2 maillages que l'on assemble.
     Il y a conflit de noms. Le group_no du 2eme maillage est renomm�.
  -> Risque & Conseil :
     V�rifiez que le nom du group_no retenu est bien celui souhait�.
"""),

23: _("""
 traitement non prevu pour un modele avec mailles tardives.
"""),

24: _("""
 abscence de carte d'orientation des elements. la structure etudiee n'est pas une poutre.
"""),

25: _("""
 probleme pour determiner les rangs des composantes <alpha> , <beta> , <gamma> de la grandeur <caorie>
"""),

26: _("""
 erreur a l'appel de la routine etenca pour extension de la carte  %(k1)s .
"""),

27: _("""
 detection d'un element d'un type non admissible. la structure etudiee n'est pas une poutre droite.
"""),

28: _("""
 l'element supporte par la maille no %(k1)s  n'a pas ete oriente.
"""),

29: _("""
 carte d'orientation incomplete pour l'element supporte par la maille no %(k1)s .
"""),

30: _("""
 les elements de la structure ne sont pas d'un type attendu. la structure etudiee n'est pas une poutre droite.
"""),

31: _("""
 l'axe directeur de la poutre doit etre parallele avec l'un des axes du repere global.
"""),

32: _("""
 la structure etudiee n'est pas une poutre droite.
"""),


37: _("""
 valeur inattendue:  %(k1)s
"""),

38: _("""
 les courbures ky et kz ne sont pas prises en compte pour les poutres courbes
"""),

42: _("""
Erreur Utilisateur :
 Le param�tre ALPHA (dilatation) du mat�riau est une fonction de la temp�rature.
 Cette fonction (%(k1)s) n'est d�finie que par 1 point.
 TEMP_DEF_ALPHA et TEMP_REF ne sont pas identiques.
 On ne peut pas faire le changement de variable TEMP_DEF_ALPHA -> TEMP_REF.
 On s'arrete donc.

Risque & Conseil:
 Il faut d�finir la fonction ALPHA avec plus d'1 point.
"""),



43: _("""
 deux mailles poi1 interdit
"""),

45: _("""
 aucun noeud ne connait le ddl:  %(k1)s
"""),

46: _("""
 le descripteur_grandeur associe au modele ne tient pas sur dix entiers codes
"""),

47: _("""
 fonree non traite  %(k1)s
"""),

48: _("""
 recuperation des caracteristiques elementaires du cable no %(k1)s  : detection d un element different du type <meca_barre>
"""),

49: _("""
 les caracteristiques materielles n ont pas ete affectees a la maille no %(k1)s  appartenant au cable no %(k2)s
"""),

50: _("""
 des materiaux differents ont ete affectes aux mailles appartenant au cable no %(k1)s
"""),

51: _("""
 recuperation des caracteristiques du materiau acier associe au cable no %(k1)s  : absence de relation de comportement de type <elas>
"""),

52: _("""
 recuperation des caracteristiques du materiau acier associe au cable no %(k1)s , relation de comportement <elas> : module d young indefini
"""),

53: _("""
 recuperation des caracteristiques du materiau acier associe au cable no %(k1)s , relation de comportement <elas> : valeur invalide pour le module d young
"""),

54: _("""
 recuperation des caracteristiques du materiau acier associe au cable no %(k1)s  : absence de relation de comportement de type <bpel_acier>
"""),

55: _("""
 recuperation des caracteristiques du materiau acier associe au cable no %(k1)s , relation de comportement <bpel_acier> : au moins un parametre indefini
"""),

56: _("""
 recuperation des caracteristiques du materiau acier associe au cable no %(k1)s , relation de comportement <bpel_acier> : au moins une valeur de parametre invalide
"""),

57: _("""
 les caracteristiques geometriques n ont pas ete affectees a la maille no %(k1)s  appartenant au cable no %(k2)s
"""),

58: _("""
 l aire de la section droite n a pas ete affectee a la maille no %(k1)s  appartenant au cable no %(k2)s
"""),

59: _("""
 valeur invalide pour l aire de la section droite affectee a la maille no %(k1)s  appartenant au cable no %(k2)s
"""),

60: _("""
 des aires de section droite differentes ont ete affectees aux mailles appartenant au cable no %(k1)s
"""),

61: _("""
Le mot-clef facteur < %(k1)s > est inconnu. Contactez les d�veloppeurs.
Note DVP: erreur de coh�rence fortran/catalogue.
"""),

62: _("""
  numero d"occurence negatif
"""),

63: _("""
 pas de blocage de deplacement tangent sur des faces d'elements 3d. rentrer la condition aux limites par ddl_impo ou liaison_ddl
"""),

64: _("""
 il faut choisir entre : flux_x ,  flux_y , flux_zet flun , flun_inf , flun_sup.
"""),

65: _("""
 le descripteur_grandeur des forces ne tient pas sur dix entiers codes
"""),

66: _("""
 trop de valeurs d'angles, on ne garde que les 3 premiers.
"""),

82: _("""
 pour liaison_unif entrer plus de un noeud
"""),

83: _("""
 on doit utiliser le mot cle cham_no pour donner le cham_no dont les composantes seront les seconds membres de la relation lineaire.
"""),

84: _("""
 il faut que le cham_no dont les termes  servent de seconds membres a la relation lineaire a ecrire ait ete defini.
"""),

85: _("""
 on doit donner un cham_no apres le mot cle cham_no derriere le mot facteur chamno_impo .
"""),

86: _("""
 il faut definir la valeur du coefficient  de la relation lineaire apres le mot cle coef_mult derriere le mot facteur chamno_impo .
"""),

87: _("""
 le descripteur_grandeur de la grandeur de nom  %(k1)s  ne tient pas sur dix entiers codes
"""),

89: _("""
 Le contenu de la table n'est pas celui attendu !
"""),

90: _("""
 Le calcul par l'op�rateur <CALC_FLUI_STRU> des param�tres du mode no %(i1)d
 n'a pas converg� pour la vitesse no %(i2)d. On ne calcule donc pas
 d'interspectres de r�ponse modale pour cette vitesse.
"""),

91: _("""
La fonction n'a pas �t� trouv�e dans la colonne %(k1)s de la table %(k2)s
(ou bien le param�tre %(k1)s n'existe pas dans la table).
"""),

92: _("""
Les mots-cles admissibles pour definir la premiere liste de noeuds sous le mot-facteur  %(k1)s sont :
"GROUP_NO_1" ou "NOEUD_1" ou "GROUP_MA_1" ou "MAILLE_1".
"""),

93: _("""
Les mots-cles admissibles pour definir la seconde liste de noeuds sous le mot-facteur  %(k1)s  sont :
"GROUP_NO_2" ou "NOEUD_2" ou "GROUP_MA_2" ou "MAILLE_2".
"""),

94: _("""
  LIAISON_GROUP : on ne sait pas calculer la normale a un noeud il faut passer par les mailles
"""),

95: _("""
 le groupe  %(k1)s ne fait pas partie du maillage :  %(k2)s
"""),

96: _("""
  %(k1)s   %(k2)s ne fait pas partie du maillage :  %(k3)s
"""),

98: _("""
 on doit utiliser le mot cle cham_no pour donner le cham_no dont les composantes seront les coefficients de la relation lineaire.
"""),

99: _("""
 il faut que le cham_no dont les termes  servent de coefficients a la relation lineaire a ecrire ait ete defini.
"""),
}

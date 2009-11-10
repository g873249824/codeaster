#@ MODIF modelisa2 Messages  DATE 09/11/2009   AUTEUR DURAND C.DURAND 
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
 resserrer le mot cle PRECISION pour le materiau ELAS_FO
"""),

3: _("""
 calcul de la tension le long du cable num�ro %(k1)s  :
 la longueur sur laquelle on devrait prendre en compte les pertes de tension par recul de l ancrage
 est sup�rieure � la longueur du cable
"""),

4: _("""
 calcul de la tension le long du cable num�ro %(k1)s  :
 la longueur sur laquelle on doit prendre en compte les pertes de tension par recul de l ancrage
 est �gale � la longueur du cable
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
 probl�me pour r�cup�rer une grandeur dans la table CARA_GEOM
"""),

14: _("""
 plus petite taille de maille n�gative ou nulle
"""),

15: _("""
 groupe de maille GROUP_MA_1= %(k1)s  inexistant dans le maillage  %(k2)s
"""),

16: _("""
 groupe de maille GROUP_MA_2= %(k1)s  inexistant dans le maillage  %(k2)s
"""),

17: _("""
 les groupes de mailles GROUP_MA_1= %(k1)s  et GROUP_MA_2= %(k2)s  ont des cardinaux diff�rents
"""),

18: _("""
 nombre de noeuds incoh�rent sous les 2 GROUP_MA � coller
"""),

19: _("""
 un noeud de GROUP_MA_2 n'est g�ometriquement appariable avec aucun de GROUP_MA_1
"""),

20: _("""
 les 2 maillages doivent �tre du m�me type : 2d (ou 3d).
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
 traitement non pr�vu pour un mod�le avec mailles tardives.
"""),

24: _("""
 absence de carte d'orientation des �l�ments. la structure etudi�e n'est pas une poutre.
"""),

25: _("""
 probl�me pour d�terminer les rangs des composantes <ALPHA> , <BETA> , <GAMMA> de la grandeur <CAORIE>
"""),

26: _("""
 erreur � l'appel de la routine ETENCA pour l'extension de la carte  %(k1)s .
"""),

27: _("""
 D�tection d'un �l�ment d'un type non admissible. La structure �tudi�e n'est pas une poutre droite.
"""),

28: _("""
 l'�l�ment support� par la maille num�ro %(k1)s  n'a pas ete orient�.
"""),

29: _("""
 carte d'orientation incompl�te pour l'�l�ment support� par la maille num�ro %(k1)s .
"""),

30: _("""
 les �l�ments de la structure ne sont pas d'un type attendu. la structure �tudi�e n'est pas une poutre droite.
"""),

31: _("""
 l'axe directeur de la poutre doit etre parall�le avec l'un des axes du rep�re global.
"""),

32: _("""
 la structure �tudi�e n'est pas une poutre droite.
"""),


37: _("""
 valeur inattendue:  %(k1)s
"""),

38: _("""
 les courbures KY et KZ ne sont pas prises en compte pour les poutres courbes
"""),

42: _("""
Erreur Utilisateur :
 Le param�tre ALPHA (dilatation) du mat�riau est une fonction de la temp�rature.
 Cette fonction (%(k1)s) n'est d�finie que par un point.
 TEMP_DEF_ALPHA et TEMP_REF ne sont pas identiques.
 On ne peut pas faire le changement de variable TEMP_DEF_ALPHA -> TEMP_REF.
 On s'arr�te donc.

Risque & Conseil:
 Il faut d�finir la fonction ALPHA avec plus d'un point.
"""),


43: _("""
 deux mailles POI1 interdit
"""),

45: _("""
 aucun noeud ne connait le DDL:  %(k1)s
"""),

46: _("""
 le descripteur_grandeur associ� au mod�le ne tient pas sur dix entiers cod�s
"""),

47: _("""
 FONREE non traite  %(k1)s
"""),

48: _("""
 recuperation des caracteristiques elementaires du cable no %(k1)s  : detection d un element different du type <meca_barre>
"""),

49: _("""
 les caract�ristiques mat�rielles n'ont pas ete affect�es � la maille no %(k1)s  appartenant au cable no %(k2)s
"""),

50: _("""
 des mat�riaux diff�rents ont �t� affect�s aux mailles appartenant au cable no %(k1)s
"""),

51: _("""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au cable no %(k1)s  : absence de relation de comportement de type <elas>
"""),

52: _("""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au cable no %(k1)s , relation de comportement <ELAS> : module d'Young ind�fini
"""),

53: _("""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au cable no %(k1)s , relation de comportement <ELAS> : valeur invalide pour le module d'Young
"""),

54: _("""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au cable no %(k1)s  : absence de relation de comportement de type <BPEL_ACIER>
"""),

55: _("""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au cable no %(k1)s , relation de comportement <BPEL_ACIER> : au moins un param�tre ind�fini
"""),

56: _("""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au cable no %(k1)s , relation de comportement <BPEL_ACIER> : au moins une valeur de param�tre invalide
"""),

57: _("""
 les caract�ristiques g�ometriques n'ont pas �t� affect�es � la maille no %(k1)s  appartenant au cable no %(k2)s
"""),

58: _("""
 l'aire de la section droite n a pas �t� affect�e � la maille no %(k1)s  appartenant au cable no %(k2)s
"""),

59: _("""
 valeur invalide pour l'aire de la section droite affect�e � la maille num�ro %(k1)s  appartenant au cable num�ro %(k2)s
"""),

60: _("""
 des aires de section droite diff�rentes ont �t� affect�es aux mailles appartenant au cable no %(k1)s
"""),

61: _("""
Le mot-clef facteur < %(k1)s > est inconnu. Contactez les d�veloppeurs.
Note DVP: erreur de coh�rence fortran/catalogue.
"""),

62: _("""
  numero d"occurence n�gatif
"""),

63: _("""
 pas de blocage de d�placement tangent sur des faces d'�l�ments 3D.
 rentrer la condition aux limites par DDL_IMPO ou LIAISON_DDL
"""),

64: _("""
 il faut choisir entre : FLUX_X ,  FLUX_Y , FLUX_Z et FLUN , FLUN_INF , FLUN_SUP.
"""),

65: _("""
 le descripteur_grandeur des forces ne tient pas sur dix entiers cod�s
"""),

66: _("""
 trop de valeurs d'angles, on ne garde que les 3 premiers.
"""),

82: _("""
 pour LIAISON_UNIF, entrer plus d'un seul noeud
"""),

83: _("""
 on doit utiliser le mot cle CHAM_NO pour donner le CHAM_NO dont les composantes seront les seconds membres de la relation lin�aire.
"""),

84: _("""
 il faut que le CHAM_NO dont les termes servent de seconds membres � la relation lin�aire � �crire ait �t� d�fini.
"""),

85: _("""
 on doit donner un CHAM_NO apr�s le mot cle CHAM_NO derri�re le mot facteur CHAMNO_IMPO .
"""),

86: _("""
 il faut definir la valeur du coefficient de la relation lin�aire apr�s le mot cl� COEF_MULT derri�re le mot facteur CHAMNO_IMPO
"""),

87: _("""
 le descripteur_grandeur de la grandeur de nom  %(k1)s  ne tient pas sur dix entiers cod�s
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
Les mots-cles admissibles pour d�finir la premiere liste de noeuds sous le mot-facteur  %(k1)s sont :
"GROUP_NO_1" ou "NOEUD_1" ou "GROUP_MA_1" ou "MAILLE_1".
"""),

93: _("""
Les mots-cles admissibles pour d�finir la seconde liste de noeuds sous le mot-facteur  %(k1)s  sont :
"GROUP_NO_2" ou "NOEUD_2" ou "GROUP_MA_2" ou "MAILLE_2".
"""),

94: _("""
  LIAISON_GROUP : on ne sait pas calculer la normale � un noeud. Il faut passer par les mailles
"""),

95: _("""
 le groupe  %(k1)s ne fait pas partie du maillage :  %(k2)s
"""),

96: _("""
  %(k1)s   %(k2)s ne fait pas partie du maillage :  %(k3)s
"""),

97: _("""
  Assemblage de maillages : Pr�sence de noeuds confondus dans la zone � coller GROUP_MA_1.
"""),

98: _("""
 on doit utiliser le mot cl� CHAM_NO pour donner le CHAM_NO dont les composantes seront les coefficients de la relation lin�aire.
"""),

99: _("""
 il faut que le CHAM_NO dont les termes servent de coefficients � la relation lin�aire � �crire ait �t� d�fini.
"""),
}

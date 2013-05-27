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

cata_msg={

1: _(u"""
 Formule interdite pour d�finir ALPHA(TEMP) : la fonction soit �tre tabul�e.
 Utilisez CALC_FONC_INTERP
"""),

2: _(u"""
 resserrer le mot cl� PRECISION pour le mat�riau ELAS_FO
"""),

3: _(u"""
 calcul de la tension le long du c�ble num�ro %(k1)s  :
 la longueur sur laquelle on devrait prendre en compte les pertes de tension par recul de l ancrage
 est sup�rieure � la longueur du c�ble"""),

4: _(u"""
  calcul de la tension le long du c�ble num�ro %(k1)s  :
  la longueur sur laquelle on doit prendre en compte les pertes de tension par recul de l ancrage
  est �gale � la longueur du c�ble"""),

5: _(u"""
 Formule interdite pour le calcul d'int�grale : la fonction soit �tre tabul�e.
 Utilisez CALC_FONC_INTERP pour tabuler la formule %(k1)s
"""),

6: _(u"""
Erreur d'utilisation :
 Le mod�le contient un m�lange d'�l�ments 2D (vivant dans le plan Oxy) et 3D.
 Le code n'a pas pr�vu ce cas de figure ici.

Risques et conseils :
 Il faut peut �tre �mettre une demande d'�volution pour pouvoir traiter ce probl�me.
"""),

7: _(u"""
Occurrence de %(k2)s.
La maille %(k1)s a d�j� �t� affect�e par une orientation.
   Orientation pr�c�dente : %(r1)f
   Orientation nouvelle   : %(r2)f
La r�gle de surcharge est appliqu�e
"""),

8: _(u"""
  Il n'y a pas d'�l�ment discret fix� au noeud %(k1)s du radier.
"""),


9: _(u"""
  Erreur utilisateur :
    l'objet %(k1)s n'existe pas. On ne peut pas continuer.
  Risques & conseils :
    Dans ce contexte, les seuls solveurs autoris�s sont MULT_FRONT et LDLT
"""),

10: _(u"""
  Le nombre de noeuds du radier et le nombre d'�l�ments discrets du groupe %(k1)s sont diff�rents :
  Nombre de noeuds du radier : %(i1)d
  Nombre d'�l�ments discrets         : %(i2)d
"""),


13: _(u"""
 probl�me pour r�cup�rer une grandeur dans la table CARA_GEOM
"""),

14: _(u"""
 plus petite taille de maille n�gative ou nulle
"""),

15: _(u"""
 groupe de maille GROUP_MA_1= %(k1)s  inexistant dans le maillage  %(k2)s
"""),

16: _(u"""
 groupe de maille GROUP_MA_2= %(k1)s  inexistant dans le maillage  %(k2)s
"""),

17: _(u"""
 les groupes de mailles GROUP_MA_1= %(k1)s  et GROUP_MA_2= %(k2)s  ont des cardinaux diff�rents
"""),

18: _(u"""
 nombre de noeuds incoh�rent sous les 2 GROUP_MA a coller
"""),

19: _(u"""
 un noeud de GROUP_MA_2 n'est g�om�triquement appariable avec aucun de GROUP_MA_1
"""),



21: _(u"""
  -> Le GROUP_MA %(k1)s est pr�sent dans les 2 maillages que l'on assemble.
     Il y a conflit de noms. Le GROUP_MA du 2�me maillage est renomm�.
  -> Risque & Conseil :
     V�rifiez que le nom du GROUP_MA retenu est bien celui souhait�.
"""),

22: _(u"""
  -> Le GROUP_NO %(k1)s est pr�sent dans les 2 maillages que l'on assemble.
     Il y a conflit de noms. Le GROUP_NO du 2�me maillage est renomm�.
  -> Risque & Conseil :
     V�rifiez que le nom du GROUP_NO retenu est bien celui souhait�.
"""),

23: _(u"""
 traitement non pr�vu pour un mod�le avec mailles tardives.
"""),

24: _(u"""
 absence de carte d'orientation des �l�ments. la structure �tudi�e n'est pas une poutre.
"""),

25: _(u"""
 probl�me pour d�terminer les rangs des composantes <ALPHA> , <BETA> , <GAMMA> de la grandeur <CAORIE>
 """),

26: _(u"""
 erreur a l'appel de la routine ETENCA pour extension de la carte  %(k1)s .
"""),

27: _(u"""
 D�tection d'un �l�ment d'un type non admissible. La structure �tudi�e n'est pas une poutre droite.
"""),

28: _(u"""
 l'�l�ment support� par la maille num�ro %(i1)d n'a pas �t� orient�.
"""),

29: _(u"""
 carte d'orientation incompl�te pour l'�l�ment support� par la maille num�ro %(i1)d.
"""),

30: _(u"""
 les �l�ments de la structure ne sont pas d'un type attendu. la structure �tudi�e n'est pas une poutre droite.
"""),

31: _(u"""
 l'axe directeur de la poutre doit �tre parall�le avec l'un des axes du rep�re global.
"""),

32: _(u"""
 la structure �tudi�e n'est pas une poutre droite.
"""),


37: _(u"""
 valeur inattendue:  %(k1)s
"""),

38: _(u"""
 les courbures KY et KZ ne sont pas prises en compte pour les poutres courbes
"""),

42: _(u"""
Erreur Utilisateur :
 Le param�tre ALPHA (dilatation) du mat�riau est une fonction de la temp�rature.
 Cette fonction (%(k1)s) n'est d�finie que par un point.
 TEMP_DEF_ALPHA et TEMP_REF ne sont pas identiques.
 On ne peut pas faire le changement de variable TEMP_DEF_ALPHA -> TEMP_REF.
 On s'arr�te donc.

Risque & Conseil:
 Il faut d�finir la fonction ALPHA avec plus d'un point.
"""),



43: _(u"""
 deux mailles POI1 interdit
"""),

45: _(u"""
 aucun noeud ne conna�t le DDL:  %(k1)s
"""),

46: _(u"""
 le descripteur_grandeur associ� au mod�le ne tient pas sur dix entiers cod�s
"""),

47: _(u"""
 FONREE non traite  %(k1)s
"""),

48: _(u"""
 r�cup�ration des caract�ristiques �l�mentaires du c�ble no %(k1)s  : d�tection d un �l�ment diff�rent du type <MECA_barre>
"""),

49: _(u"""
 les caract�ristiques mat�rielles n'ont pas �t� affect�es � la maille no %(k1)s  appartenant au c�ble no %(k2)s
 """),

50: _(u"""
 des mat�riaux diff�rents ont �t� affect�s aux mailles appartenant au c�ble no %(k1)s
"""),

51: _(u"""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au c�ble no %(k1)s  : absence de relation de comportement de type <ELAS>
"""),

52: _(u"""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au c�ble no %(k1)s , relation de comportement <ELAS> : module de Young ind�fini
"""),

53: _(u"""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au c�ble no %(k1)s , relation de comportement <ELAS> : valeur invalide pour le module de Young
"""),

54: _(u"""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au c�ble no %(k1)s  : absence de relation de comportement de type <BPEL_ACIER> ou <ETCC_ACIER>
"""),

55: _(u"""
 r�cup�ration des caract�ristiques du mat�riau ACIER associ� au c�ble no %(k1)s , relation de comportement <BPEL_ACIER> : Le param�tre F_PRG doit �tre positif et non nul
 """),
56 : _(u"""
 Pour faire un calcul de relaxation type ETCC_REPRISE, vous devez  renseigner le mot-cl� TENSION_CT de DEFI_CABLE pour chaque c�ble de pr�contrainte, 
"""),

57: _(u"""
 les caract�ristiques g�om�triques n'ont pas �t� affect�es � la maille no %(k1)s  appartenant au c�ble no %(k2)s
 """),

58: _(u"""
 l'aire de la section droite n a pas �t� affect�e � la maille no %(k1)s  appartenant au c�ble no %(k2)s
"""),

59: _(u"""
 valeur invalide pour l'aire de la section droite affect�e � la maille num�ro %(k1)s  appartenant au c�ble num�ro %(k2)s
"""),

60: _(u"""
 des aires de section droite diff�rentes ont �t� affect�es aux mailles appartenant au c�ble no %(k1)s
"""),

62: _(u"""
  num�ro d'occurrence n�gatif
"""),

63: _(u"""
 pas de blocage de d�placement tangent sur des faces d'�l�ments 3D.
 rentrer la condition aux limites par DDL_IMPO ou LIAISON_DDL
"""),

64: _(u"""
 il faut choisir entre : FLUX_X ,  FLUX_Y , FLUX_Z et FLUN , FLUN_INF , FLUN_SUP.
"""),

65: _(u"""
 le descripteur_grandeur des forces ne tient pas sur dix entiers cod�s
"""),

66: _(u"""
 trop de valeurs d'angles, on ne garde que les 3 premiers.
"""),

67 : _(u"""
La table fournie dans DEFI_CABLE doit contenir l'abscisse curviligne et la tension du c�ble.
"""),

68 : _(u"""
La table fournie n'a pas la bonne dimension : v�rifiez qu'il s'agit du bon c�ble ou que plusieurs 
instants ne sont pas contenus dans la table.
"""),

69 : _(u"""
Les abscisses curvilignes de la table fournie ne correspondent pas � celles du c�ble �tudi�
"""),

70 : _(u""" Attention, vous voulez calculer les pertes par relaxation de l'acier, mais 
      le coefficient RELAX_1000 est nul. Les pertes associ�es sont donc nulles. 
 """),
82: _(u"""
 pour LIAISON_UNIF, entrer plus d'un seul noeud
"""),

83: _(u"""
 on doit utiliser le mot cl� CHAM_NO pour donner le CHAM_NO dont les composantes seront les seconds membres de la relation lin�aire.

 """),

84: _(u"""
 il faut que le CHAM_NO dont les termes servent de seconds membres � la relation lin�aire � �crire ait �t� d�fini.
 """),

85: _(u"""
 on doit donner un CHAM_NO apr�s le mot cl� CHAM_NO derri�re le mot facteur CHAMNO_IMPO .
"""),

86: _(u"""
 il faut d�finir la valeur du coefficient de la relation lin�aire apr�s le mot cl� COEF_MULT derri�re le mot facteur CHAMNO_IMPO
"""),

87: _(u"""
 le descripteur_grandeur de la grandeur de nom  %(k1)s  ne tient pas sur dix entiers cod�s
"""),

89: _(u"""
 Le contenu de la table n'est pas celui attendu !
"""),

90: _(u"""
 Le calcul par l'op�rateur <CALC_FLUI_STRU> des param�tres du mode no %(i1)d
 n'a pas converg� pour la vitesse no %(i2)d. On ne calcule donc pas
 d'interspectre de r�ponse modale pour cette vitesse.
"""),

91: _(u"""
La fonction n'a pas �t� trouv�e dans la colonne %(k1)s de la table %(k2)s
(ou bien le param�tre %(k1)s n'existe pas dans la table).
"""),

92: _(u"""
Les mots-cl�s admissibles pour d�finir la premi�re liste de noeuds sous le mot-cl� facteur  %(k1)s sont :
"GROUP_NO_1" ou "NOEUD_1" ou "GROUP_MA_1" ou "MAILLE_1".
"""),

93: _(u"""
Les mots-cl�s admissibles pour d�finir la seconde liste de noeuds sous le mot-cl� facteur  %(k1)s  sont :
"GROUP_NO_2" ou "NOEUD_2" ou "GROUP_MA_2" ou "MAILLE_2".
"""),

94: _(u"""
  LIAISON_GROUP : on ne sait pas calculer la normale � un noeud. Il faut passer par les mailles
"""),

95: _(u"""
 le groupe  %(k1)s ne fait pas partie du maillage :  %(k2)s
"""),

96: _(u"""
  %(k1)s   %(k2)s ne fait pas partie du maillage :  %(k3)s
"""),

97: _(u"""
  Assemblage de maillages : Pr�sence de noeuds confondus dans la zone � coller GROUP_MA_1.
"""),

98: _(u"""
 on doit utiliser le mot cl� CHAM_NO pour donner le CHAM_NO dont les composantes seront les coefficients de la relation lin�aire.
"""),

99: _(u"""
 il faut que le CHAM_NO dont les termes servent de coefficients � la relation lin�aire � �crire ait �t� d�fini.
"""),
}

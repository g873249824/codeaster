#@ MODIF soustruc Messages  DATE 12/02/2013   AUTEUR PELLET J.PELLET 
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
 les 2 maillages ne sont pas du m�me type : 2D (ou 3D).
"""),

2: _(u"""
 la (super)maille :  %(k1)s  est en double.
"""),

3: _(u"""
 la maille :  %(k1)s  est en double.
"""),

4: _(u"""
 le GROUP_MA :  %(k1)s  est en double. on ignore le second.
"""),

5: _(u"""
 le GROUP_NO :  %(k1)s  est en double. on ignore le second.
"""),

6: _(u"""
 le noeud: %(k1)s  n'a pas les m�mes coordonn�es dans les maillages:  %(k2)s  et  %(k3)s
"""),

7: _(u"""
 matrice de rigidit� non inversible (modes rigides ???)
 - attention : crit�res de choc non calcul�s
"""),

8: _(u"""
 matrice de rigidit� : pivot quasi nul (modes rigides ???)
 - attention : crit�res de choc non calcul�s
"""),

9: _(u"""
 mot-clef "DEFINITION" interdit :
 le MACR_ELEM :  %(k1)s  est d�j� d�fini.
"""),

10: _(u"""
 mot-clef "RIGI_MECA" interdit :
 il est d�j� calcul�.
"""),

11: _(u"""
 mot-clef "RIGI_MECA" interdit :
 le r�sultat :  %(k1)s  existe d�j�.
"""),

12: _(u"""
 mot-clef "MASS_MECA" interdit :
 il faut avoir fait "DEFINITION" et "RIGI_MECA".
"""),

13: _(u"""
 mot-clef "MASS_MECA" interdit :
 il est d�j� calcul�.
"""),

14: _(u"""
 mot-clef "CAS_CHARGE" interdit :
 il faut avoir fait "DEFINITION" et "RIGI_MECA".
"""),

15: _(u"""
 cet op�rateur modifie un maillage existant
 le r�sultat doit �tre identique au concept donn� dans l'argument MAILLAGE.
"""),

16: _(u"""
 maillages avec super mailles :
 utiliser OPERATION = SOUS_STRUC
"""),

17: _(u"""
 groupe de noeuds inexistant
"""),

18: _(u"""
 groupes incompatibles
"""),

19: _(u"""
 il ne faut que des points
"""),

20: _(u"""
 vecteur nul pour l'orientation
"""),

21: _(u"""
 crit�re inconnu
"""),

22: _(u"""
 noeud %(k1)s trop �loign� de la normale au segment
 distance = %(r1)f
"""),

23: _(u"""
  On cherche � classer une liste de noeuds par abscisses croissantes
  de leur projection sur un segment de droite.
  2 noeuds ont la m�me projection sur la droite.
  Le classement est donc arbitraire.

  -> Risque & Conseil :
     V�rifiez votre maillage.
"""),

24: _(u"""
 mot clef "SOUS_STRUC" interdit pour ce mod�le sans sous-structures.
"""),

25: _(u"""
 liste de mailles plus longue que la liste des sous-structures du mod�le.
"""),

26: _(u"""
 la maille :  %(k1)s  n existe pas dans le maillage :  %(k2)s
"""),

27: _(u"""
 la maille :  %(k1)s  n'est pas active dans le mod�le
"""),

28: _(u"""
 la maille :  %(k1)s  ne conna�t pas le chargement :  %(k2)s
"""),

29: _(u"""
 arr�t suite aux erreurs d�tect�es.
"""),

30: _(u"""
 mot clef "AFFE_SOUS_STRUC" interdit pour ce maillage sans (super)mailles.
"""),

31: _(u"""
 la maille :  %(k1)s  n'appartient pas au maillage
"""),

32: _(u"""
 maille en double :  %(k1)s  dans le GROUP_MA:  %(k2)s
"""),

33: _(u"""
 l'indice final est inf�rieur a l'indice initial
"""),

34: _(u"""
 l'indice final est sup�rieur a la taille du groupe
"""),

35: _(u"""
 le GROUP_MA :  %(k1)s  n'appartient pas au maillage
"""),

36: _(u"""
 le GROUP_MA : %(k1)s est vide. on ne le cr�e pas.
"""),

37: _(u"""
 Le groupe de noeuds '%(k1)s' existe d�j�.

 Conseil :
    Si vous souhaitez utiliser un nom de groupe existant, il suffit
    de le d�truire avec DEFI_GROUP / DETR_GROUP_NO.
"""),


38: _(u"""
 le GROUP_NO : %(k1)s  est vide, on ne le cr�e pas.
"""),

39: _(u"""
 noeud en double :  %(k1)s  dans le GROUP_NO:  %(k2)s
"""),

40: _(u"""
 liste de charges trop longue
"""),

41: _(u"""
 l'ext�rieur du MACR_ELEM_STAT contient des noeuds qui ne portent aucun ddl, ces noeuds sont �limin�s.
"""),

42: _(u"""
 l'ext�rieur du MACR_ELEM_STAT contient des noeuds en double. ils sont �limin�s.
"""),

43: _(u"""
 grandeur:  %(k1)s  interdite. (seule autoris�e: DEPL_R)
"""),

44: _(u"""
 la maille :  %(k1)s  n existe pas dans le maillage : %(k2)s
"""),

45: _(u"""
 num�ro. �quation incorrect
"""),

46: _(u"""
 cas de charge :  %(k1)s  inexistant sur le MACR_ELEM_STAT :  %(k2)s
"""),

47: _(u"""
 erreur programmeur 1
"""),

48: _(u"""
 noeud :  %(k1)s  inexistant dans le maillage :  %(k2)s
"""),

49: _(u"""
 GROUP_NO :  %(k1)s  inexistant dans le maillage :  %(k2)s
"""),

50: _(u"""
 liste de mailles trop longue.
"""),

51: _(u"""
 la liste des mailles est plus longue que la liste des MACR_ELEM_STAT.
"""),

52: _(u"""
 trop de r�els pour le mot clef "TRAN"
"""),

53: _(u"""
 trop de r�els pour le mot clef "ANGL_NAUT"
"""),

54: _(u"""
 trop de r�els pour le mot clef "centre"
"""),

55: _(u"""
 m�lange de maillages 2d et 3d
"""),

56: _(u"""
  le MACR_ELEM_STAT : %(k1)s  n'existe pas.
"""),

57: _(u"""
 les arguments "pr�fixe" et "index" conduisent a des noms de noeuds trop longs (8 caract�res max).
"""),

58: _(u"""
 il faut : "tout" ou "maille" pour "DEFI_NOEUD".
"""),

59: _(u"""
  le noeud :  %(k1)s  n'appartient pas a la maille : %(k2)s
"""),

60: _(u"""
  le noeud :  %(k1)s  de la maille :  %(k2)s  a �t� �limin� (recollement). on ne peut donc le renommer.
"""),

61: _(u"""
 les arguments "pr�fixe" et "index" conduisent a des noms de GROUP_NO trop longs (8 caract�res max).
"""),

62: _(u"""
 le GROUP_NO :  %(k1)s  est vide. on ne le cr�e pas.
"""),

63: _(u"""
 liste trop longue
"""),

64: _(u"""
 la liste de mailles est plus longue que le nombre total de mailles.
"""),

65: _(u"""
 la liste de mailles  n'a pas la m�me longueur que la liste de GROUP_NO.
"""),

66: _(u"""
 la liste de mailles  doit �tre de dimension au moins 2 pour le recollement
"""),

67: _(u"""
 les GROUP_NO a recoller :  %(k1)s  et  %(k2)s  n'ont pas le m�me nombre de noeuds.
"""),

68: _(u"""
 pour le recollement g�om�trique des GROUP_NO :  %(k1)s  et  %(k2)s  certains noeuds ne sont pas apparies
"""),

69: _(u"""
 AMOR_MECA non implante.
"""),

70: _(u"""
 la sous-structuration n'est possible qu'en m�canique
"""),

71: _(u"""
 nombre de noeuds internes : 0
"""),

73: _(u"""
 la grandeur "DEPL_R" doit avoir les composantes (1 a 6) : DX,DY, ..., DRZ
"""),

74: _(u"""
 la grandeur "DEPL_R" doit avoir la composante "LAGR".
"""),

75: _(u"""
 autorise : "LAG" ou "GL" pas: %(k1)s
"""),

76: _(u"""
 ddl non pr�vu. on attend: DX
"""),

77: _(u"""
 ddls non pr�vus
"""),

79: _(u"""
 le calcul de r�ponse pour ce type de r�sultat n'est disponible que sur les MACR_ELEM_STAT obtenus a partir de la mesure
"""),

80: _(u"""
 la matrice de rigidit� condens�e n'a pas �t� calcul�e
"""),

81: _(u"""
 la matrice de masse condens�e n'a pas �t� calcul�e
"""),

82: _(u"""
 nombre de ddl capteur insuffisant ou nombre vecteurs de base trop �lev�, nombre ddl capteur : %(i1)d ,nombre vecteurs de base : %(i2)d
"""),

83: _(u"""
 nombre ddl interface insuffisant ou nombre modes identifies trop �lev�, nombre ddl interface : %(i1)d ,nombre modes identifies : %(i2)d
"""),





85: _(u"""
  au noeud de choc:  %(k1)s
"""),

86: _(u"""
 noeud   %(k1)s   en dehors du segment %(k2)s   abscisse curviligne %(r1)f
"""),

87: _(u"""
 trop de noeuds dans le GROUP_NO  noeud utilise:  %(k1)s
"""),

88: _(u"""
 Erreur dans le maillage :
"""),

89: _(u"""
  Pour le noeud %(k1)s de la maille %(k2)s, la coordonn�e X est n�gative (x=%(r1)G).
"""),

90: _(u"""
 Or, pour une mod�lisation axisym�trique, la coordonn�e X doit �tre positive, nulle ou
 tr�s faiblement n�gative ( > -1.d-6 * X_MAX)

 Conseils :
  * V�rifiez votre maillage.
  * Vous pouvez utiliser MODI_MAILLAGE / DEFORME pour repositionner votre maillage
    dans le demi espace  X >= 0
"""),

93: _(u"""
    pour le mode no : %(i1)d taux de flexibilit� locale   :  %(r1)f
 souplesse locale             :  %(r2)f
 taux effort tranchant local  :  %(r3)f

"""),

94: _(u"""
   -- bilan noeud de choc : %(k1)s  taux de restitution flexibilit�      :  %(r1)f
  taux de restitution effort tranchant :  %(r2)f
"""),

95: _(u"""
  ( souplesse statique - souplesse locale )/ souplesse choc :  %(r1)f
"""),

96: _(u"""
  souplesse locale / souplesse choc :  %(r1)f
"""),

98: _(u"""
 !! attention plus petite val singuli�re d�formation statique :  %(r1)f !! nous la for�ons a :  %(r2)f
"""),

99: _(u"""
 ---- conditionnement d�formation statique :  %(r1)f
"""),

}

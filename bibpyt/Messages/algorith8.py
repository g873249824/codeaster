#@ MODIF algorith8 Messages  DATE 02/10/2007   AUTEUR MACOCCO K.MACOCCO 
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
 contraintes planes en grandes d�formations non implant�es
"""),

2: _("""
 caract�ristique fluage incomplet
"""),

6: _("""
 message d'erreur inconnu (dvlp)
"""),

7: _("""
 incoherence de taille (dvlp)
"""),

8: _("""
 format de colonne inconnu (dvlp)
"""),

12: _("""
 F reste toujours n�gative
"""),

13: _("""
 F  reste toujours positive
"""),

14: _("""
 signe de SIGMA indetermin�
"""),

15: _("""
 changement de signe de SIGMA
"""),

16: _("""
 F=0 : pas converge
"""),

17: _("""
 dvp : non coh�rent
"""),

18: _("""
 phase inconnue (dvlp)
"""),

19: _("""
 trop d'amortissements modaux
"""),

20: _("""
 La d�finition du rep�re d'orthotropie a �t� mal faite.
 Utilisez soit ANGL_REP  soit ANGL_AXE de la commande AFFE_CARA_ELEM mot cl� facteur MASSIF
"""),

22: _("""
 type d'�l�ment incompatible avec une loi �lastique anisotrope
"""),

23: _("""
 d�nominateur nul dans le calcul de ETA_PILOTAGE
"""),

24: _("""
 cisaillement suiveur non implant�
"""),

25: _("""
 pression impos�e sur l'axe des coordonn�es cylindriques
"""),

26: _("""
 mode non defini
"""),

27: _("""
 lecture du champ DEPL_CALCULE impossible
"""),

28: _("""
 pr�diction par extrapolation impossible : pas de temps nul
"""),

29: _("""
 ITER_LINE_MAXI doit etre inf�rieur � 1000
"""),

30: _("""
 mauvaise estimation de f
"""),

31: _("""
 borne superieure PMAX incorrecte
"""),

32: _("""
 viscosit� N �gale � z�ro
"""),

33: _("""
 viscosit� UN_SUR_K �gale � z�ro
"""),

34: _("""
 g=0 : pas converg�
"""),

35: _("""
 incompatibilit� entre la loi de couplage  %(k1)s  et la mod�lisation choisie  %(k2)s
"""),

36: _("""
 il y a deja une loi de couplage
"""),

37: _("""
 il y a deja une loi hydraulique
"""),

38: _("""
 il y a deja une loi de m�canique
"""),

39: _("""
 il n y a pas de loi de couplage
"""),

40: _("""
 il n y a pas de loi hydraulique
"""),

41: _("""
 il n y a pas de loi de m�canique
"""),

42: _("""
 la loi de couplage est incorrecte pour une mod�lisation HM
"""),

43: _("""
 incompatibilite des comportements m�canique et hydraulique
"""),

44: _("""
 loi de m�canique incompatible avec une modelisation HM
"""),

45: _("""
 la loi de couplage est incorrecte pour une mod�lisation HHM
"""),

46: _("""
 loi de m�canique incompatible avec une loi HHM
"""),

47: _("""
 loi de m�canique incompatible avec une mod�lisation HHM
"""),

48: _("""
 il y a une loi de m�canique dans la relation THH
"""),

49: _("""
 la loi de couplage est incorrecte pour une mod�lisation THH
"""),

50: _("""
 loi de m�canique incompatible avec une loi THH
"""),

51: _("""
 il y a une loi de mecanique dans la relation THV
"""),

52: _("""
 la loi de couplage est incorrecte pour une mod�lisation THV
"""),

53: _("""
 loi de m�canique incompatible avec une loi THV
"""),

54: _("""
 la loi de couplage est incorrecte pour une mod�lisation THM
"""),

55: _("""
 loi de m�canique incompatible avec une mod�lisation THM
"""),

56: _("""
 la loi de couplage est incorrecte pour une mod�lisation THHM
"""),

57: _("""
 Loi de m�canique incompatible avec une mod�lisation THHM
"""),

58: _("""
 M�thode non implant�e
"""),

59: _("""
 Champ 'IN' inexistant
"""),

61: _("""
 Il manque le s�chage de r�f�rence (AFFE_MATERIAU/AFFE_VARC/VALE_REF)
"""),

65: _("""
 echec loi de comportement dans ZEROFO
"""),

66: _("""
  convergence atteinte sur approximation lin�aire tangente de l'�volution plastique
  risque d'imprecision
"""),

67: _("""
  endommagement maximal atteint au cours des resolutions internes
"""),

68: _("""
  erreur r�cup�ration param�tres mat�riau
"""),

69: _("""
  type de matrice demand� non disponible
"""),

70: _("""
  erreur dans nmvecd
"""),

71: _("""
 valo >0
"""),

72: _("""
 dr negatif
"""),

73: _("""
 pb2 seq
"""),

74: _("""
 pb4 seq
"""),

75: _("""
 pb1 seq
"""),

76: _("""
 pb3 seq
"""),

77: _("""
 le nombre de composantes dans le champ de vent est incorrect. on doit avoir : DX, DY, DZ
"""),

78: _("""
 F(0)=0
"""),

80: _("""
 SY >= SU. impossible.
"""),

81: _("""
 EP >= E. impossible.
"""),

82: _("""
 incoh�rence dans les donn�es mat�riau : MEY > MPY impossible.
"""),

83: _("""
 incoh�rence dans les donn�es mat�riau : MEZ > MPZ impossible.
"""),

84: _("""
 comportement de fluage sous irradiation inconnu
"""),

85: _("""
 definition multiple du comportement pour un �l�ment de poutre
"""),

86: _("""
 porosit� strictement nulle( cas non trait�)
"""),

87: _("""
 l'incr�ment de temps vaut z�ro, v�rifiez votre d�coupage
"""),

88: _("""
 fluence d�croissante (flux<0)
"""),

89: _("""
 le parametre A doit etre >=0
"""),

90: _("""
 la loi LMARC_IRRA n'est compatible qu'avec une mod�lisation poutre
"""),

91: _("""
 stop, RIGI_MECA_TANG non disponible
"""),

92: _("""
 la maille doit etre de type TETRA10,PENTA15,HEXA20,QUAD8 ou TRIA6.
 or la maille est de type :  %(k1)s .
"""),

93: _("""
 une maille maitre est de longueur nulle
"""),

94: _("""
 le champ issu du concept %(k1)s n'est pas calcul� � l'instant %(i3)i
"""),

96: _("""
 le s�chage ne peut pas etre m�lang� � un autre comportement
"""),

97: _("""
 EVOL_THER_SECH est un mot-cl� obligatoire pour le s�chage de type SECH_GRANGER et SECH_NAPPE
"""),

98: _("""
  le concept :  %(k1)s  n'est pas un champ de temp�rature
"""),

99: _("""
  le concept EVOL_THER :  %(k1)s  ne contient aucun champ de temp�rature
"""),
}

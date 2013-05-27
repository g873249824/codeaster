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

cata_msg = {

10 : _("""
Pas de couplage possible avec UMLV et le comportement %(k1)s.
"""),

35 : _(u"""
 rang sup�rieur a dimension vecteur
"""),

36 : _(u"""
 <LCDPPA> il faut red�couper
"""),

45 : _(u"""
 la mod�lisation 1d n'est pas autoris�e
"""),

48 : _(u"""
 �l�ment � discontinuit� avec une loi CZM_EXP : la matrice H est non inversible
"""),


50 : _(u"""
  comportement inattendu :  %(k1)s
"""),

51 : _(u"""
  SYT et D_SIGM_EPSI doivent �tre sp�cifi�s sous l'op�rande BETON_ECRO_LINE dans DEFI_MATERIAU pour utiliser la loi ENDO_ISOT_BETON
"""),

52 : _(u"""
  SYC ne doit pas �tre valoris� pour NU nul dans DEFI_MATERIAU
"""),

53 : _(u"""
  SYC doit �tre sup�rieur � SQRT((1+NU-2*NU*NU)/(2.D0*NU*NU))*SYT
  dans DEFI_MATERIAU pour prendre en compte le confinement
"""),

54 : _(u"""
 loi ENDO_ORTH_BETON : le param�tre KSI n'est pas inversible
"""),

57 : _(u"""
 Probl�me de convergence (l'accroissement de d�formation plastique est n�gatif).
 On active le red�coupage du pas de temps.
"""),

58 : _(u"""
 pas de solution
"""),

59 : _(u"""
 erreur: Probl�me de convergence. Le nombre d'it�ration maximal est atteint. On active le red�coupage du pas de temps.
"""),

60 : _(u"""
 Probl�me de convergence (l'accroissement de d�formation plastique est n�gatif).
 Pensez � activer le red�coupage du pas de temps.
"""),

61 : _(u"""
 erreur: Probl�me de convergence. Le nombre d'it�ration maximal est atteint. Pensez � activer le red�coupage du pas de temps.
"""),

62 : _(u"""
 loi BETON_REGLE_PR utilisable uniquement en mod�lisation C_PLAN ou D_PLAN
"""),

63 : _(u"""
 la m�thode de localisation  %(k1)s  est indisponible actuellement
"""),

65 : _(u"""
  %(k1)s  impossible actuellement
"""),


72 : _(u"""
  jacobien du syst�me non lin�aire � r�soudre nul
  lors de la projection au sommet du c�ne de traction
  les param�tres mat�riaux sont sans doute mal d�finis
"""),

73 : _(u"""
  non convergence � it�ration max  %(k1)s
  - erreur calcul�e  %(k2)s  >  %(k3)s
  mais tr�s faibles incr�ments de Newton pour la loi BETON_DOUBLE_DP
  - on accepte la convergence.
"""),

74 : _(u"""
  non convergence � it�ration max  %(k1)s
  - erreur calcul�e  %(k2)s  >  %(k3)s
  - pour la loi BETON_DOUBLE_DP
  - red�coupage du pas de temps
"""),

75 : _(u"""
 �tat converge non conforme
 lors de la projection au sommet du c�ne de traction
"""),

76 : _(u"""
 �tat converge non conforme en compression
 lors de la projection au sommet du c�ne de traction
"""),

77 : _(u"""
 jacobien du syst�me non lin�aire � r�soudre nul
 lors de la projection au sommet des c�nes de compression et traction
 - les param�tres mat�riaux sont sans doute mal d�finis.
"""),

78 : _(u"""
 �tat converg� non conforme en traction
 lors de la projection au sommet des deux c�nes
"""),

79 : _(u"""
 �tat converg� non conforme en compression
 lors de la projection au sommet des deux c�nes
"""),

80 : _(u"""
  jacobien du syst�me non lin�aire � r�soudre nul
  lors de la projection au sommet du c�ne de compression
  - les param�tres mat�riaux sont sans doute mal d�finis.
"""),

81 : _(u"""
 �tat converg� non conforme
 lors de la projection au sommet du c�ne de compression
"""),

82 : _(u"""
 �tat converg� non conforme en traction
 lors de la projection au sommet du c�ne de compression
"""),

83 : _(u"""
  jacobien du syst�me non lin�aire a r�soudre nul
  - les param�tres mat�riaux sont sans doute mal d�finis.
"""),

84 : _(u"""
 int�gration �lastoplastique de loi multicrit�re : erreur de programmation
"""),

85 : _(u"""
  erreur de programmation : valeur de NSEUIL incorrecte.
"""),

86 : _(u"""
  �tat converg� non conforme en traction et en compression
  pour la loi de comportement BETON_DOUBLE_DP
  pour les deux crit�res en m�me temps.
  il faut un saut �lastique plus petit, ou red�couper le pas de temps
"""),

87 : _(u"""
  �tat converge non conforme en compression
  pour la loi de comportement BETON_DOUBLE_DP
  pour les deux crit�res en m�me temps.
  il faut un saut �lastique plus petit, ou red�couper le pas de temps
"""),

88 : _(u"""
  �tat converg� non conforme en traction
  pour la loi de comportement BETON_DOUBLE_DP
  pour les deux crit�res en m�me temps.
  il faut un saut �lastique plus petit, ou red�couper le pas de temps
"""),

89 : _(u"""
 �tat converg� non conforme en traction
"""),

90 : _(u"""
 �tat converg� non conforme en compression
"""),

94 : _(u"""
 il faut d�clarer FONC_DESORP sous ELAS_FO pour le fluage propre                                avec SECH comme param�tre
"""),

98 : _(u"""
 nombre de valeurs dans le fichier UNV DATASET 58 non identique
"""),

99 : _(u"""
 nature du champ dans le fichier UNV DATASET 58 non identique
"""),

}

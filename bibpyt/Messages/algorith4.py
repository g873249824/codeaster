#@ MODIF algorith4 Messages  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

def _(x) : return x

cata_msg = {

35 : _("""
 rang superieur a dimension vecteur
"""),

36 : _("""
 <LCDPPA> il faut redecouper
"""),

45 : _("""
 la modelisation 1d n'est pas autoris�e
"""),

48 : _("""
 �l�ment � discontinuit� avec une loi CZM_EXP : la matrice H est non inversible
"""),


50 : _("""
  comportement inattendu :  %(k1)s
"""),

51 : _("""
  SYT et D_SIGM_EPSI doivent �tre specifi�s sous l'operande BETON_ECRO_LINE dans DEFI_MATERIAU pour utiliser la loi ENDO_ISOT_BETON
"""),

52 : _("""
  SYC ne doit pas �tre valoris� pour NU nul dans DEFI_MATERIAU
"""),

53 : _("""
  SYC doit etre sup�rieur � SQRT((1+NU-2*NU*NU)/(2.D0*NU*NU))*SYT
  dans DEFI_MATERIAU pour prendre en compte le confinement
"""),

54 : _("""
 loi ENDO_ORTH_BETON : le param�tre KSI n'est pas inversible
"""),

57 : _("""
 pb de convergence (dgp neg)
"""),

58 : _("""
 pas de solution
"""),

59 : _("""
 erreur: pb de convergence
"""),

60 : _("""
 pb de convergence 2 (dgp neg)
"""),

61 : _("""
 erreur: pb de conv 2
"""),

62 : _("""
 loi BETON_REGLEMENT utilisable uniquement en mod�lisation C_PLAN ou D_PLAN
"""),

63 : _("""
 la m�thode de localisation  %(k1)s  est indisponible actuellement
"""),

65 : _("""
  %(k1)s  impossible actuellement
"""),

68 : _("""
 PYRAMIDAL1 pas encore disponible
"""),

69 : _("""
 PYRAMIDAL2 pas encore disponible
"""),

70 : _("""
 JOINT_GRAIN pas encore disponible
"""),

71 : _("""
 RL pas encore disponible
"""),

72 : _("""
  jacobien du systeme non lineaire � r�soudre nul
  lors de la projection au sommet du cone de traction
  les parametres mat�riaux sont sans doute mal d�finis
"""),

73 : _("""
  non convergence � it�ration maxi  %(k1)s
  - erreur calculee  %(k2)s  >  %(k3)s
  mais tres faibles incr�ments de newton pour la loi BETON_DOUBLE_DP
  - on accepte la convergence.
"""),

74 : _("""
  non convergence � it�ration maxi  %(k1)s
  - erreur calcul�e  %(k2)s  >  %(k3)s
  - pour la loi BETON_DOUBLE_DP
  - red�coupage du pas de temps
"""),

75 : _("""
 etat converge non conforme
 lors de la projection au sommet du cone de traction
"""),

76 : _("""
 etat converge non conforme en compression
 lors de la projection au sommet du cone de traction
"""),

77 : _("""
 jacobien du systeme non lin�aire � r�soudre nul
 lors de la projection au sommet des cones de compression et traction
 - les parametres mat�riaux sont sans doute mal d�finis.
"""),

78 : _("""
 �tat converg� non conforme en traction
 lors de la projection au sommet des deux cones
"""),

79 : _("""
 �tat converg� non conforme en compression
 lors de la projection au sommet des deux cones
"""),

80 : _("""
  jacobien du systeme non lin�aire � r�soudre nul
  lors de la projection au sommet du cone de compression
  - les parametres mat�riaux sont sans doute mal d�finis.
"""),

81 : _("""
 �tat converg� non conforme
 lors de la projection au sommet du cone de compression
"""),

82 : _("""
 �tat converg� non conforme en traction
 lors de la projection au sommet du cone de compression
"""),

83 : _("""
  jacobien du syst�me non lin�aire a resoudre nul
  - les parametres mat�riaux sont sans doute mal d�finis.
"""),

84 : _("""
 int�gration �lastoplastique de loi multi-critere : erreur de programmation
"""),

85 : _("""
  erreur de programmation : valeur de NSEUIL incorrecte.
"""),

86 : _("""
  �tat converg� non conforme en traction et en compression
  pour la loi de comportement BETON_DOUBLE_DP
  pour les deux crit�res en meme temps.
  il faut un saut �lastique plus petit, ou red�couper le pas de temps
"""),

87 : _("""
  �tat converge non conforme en compression
  pour la loi de comportement BETON_DOUBLE_DP
  pour les deux crit�res en meme temps.
  il faut un saut �lastique plus petit, ou red�couper le pas de temps
"""),

88 : _("""
  �tat converg� non conforme en traction
  pour la loi de comportement BETON_DOUBLE_DP
  pour les deux crit�res en meme temps.
  il faut un saut �lastique plus petit, ou red�couper le pas de temps
"""),

89 : _("""
 �tat converg� non conforme en traction
"""),

90 : _("""
 �tat converg� non conforme en compression
"""),

94 : _("""
 il faut d�clarer FONC_DESORP sous ELAS_FO pour le fluage propre                                avec sech comme parametre
"""),

98 : _("""
 nombre de valeurs dans le fichier UNV DATASET 58 non identique
"""),

99 : _("""
 nature du champ dans le fichier UNV DATASET 58 non identique
"""),

}

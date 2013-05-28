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
 couplage fluage/fissuration :
 il faut d�finir deux lois de comportement exactement.
"""),

2 : _(u"""
 GRANGER et ENDO_ISOT_BETON ou MAZARS non encore d�velopp�
"""),

3 : _(u"""
 loi de comportement non autoris�e dans le couplage fluage/fissuration
"""),

4 : _(u"""
 DEBORST non compatible avec couplage UMLV/Mazars.
 Mais le traitement analytique est r�alis�, il suffit de supprimer le
 mot-cl� DEBORST),

"""),
5 : _(u"""
 pas de C_PLAN pour ENDO_ISOT_BETON
 utiliser C_PLAN_DEBORST
"""),

6 : _(u"""
 loi de fluage non autoris�e dans le couplage fluage/fissuration
"""),

7 : _(u"""
 pas d'orthotropie non lin�aire
"""),

8 : _(u"""
 loi de comportement hyper-�lastique non pr�vue
"""),

9 : _(u"""
 C_PLAN m�thode DEBORST et grandes d�formations sont incompatibles
"""),

10 : _(u"""
 COMP1D et SIMO_MIEHE incompatibles
"""),

11 : _(u"""
 couplage fluage/fissuration :
 la premi�re loi doit �tre une loi de fluage de type GRANGER_FP ou GRANGER_FP_V.
"""),

12 : _(u"""
 couplage fluage/fissuration :
 nombre total de variables internes incoh�rent <--> erreur de programmation.
"""),

15 : _(u"""
  le concept EVOL_CHAR :  %(k1)s  n'en est pas un !
"""),

16 : _(u"""
  le concept EVOL_CHAR :  %(k1)s  ne contient aucun champ de type EVOL_CHAR.
"""),

20 : _(u"""
 le champ de d�placement DIDI n'est pas trouv� dans le concept  %(k1)s
"""),

60 : _(u"""
  -> Le crit�re de convergence pour int�grer le comportement 'RESI_INTE_RELA'
     est l�che (tr�s sup�rieur � la valeur par d�faut).
  -> Risque & Conseil :
     Cela peut nuire � la qualit� de la solution et � la convergence.
"""),

61 : _(u"""
 option  %(k1)s  non trait�e
"""),

63 : _(u"""
 pas existence de solution pour le saut
"""),

64 : _(u"""
 existence d'un �l�ment � discontinuit� trop grand
 non unicit� du saut
"""),

65 : _(u"""
 non convergence du NEWTON pour le calcul du saut num�ro 1
"""),

66 : _(u"""
 non convergence du NEWTON pour le calcul du saut num�ro 2
"""),

67 : _(u"""
 non convergence du NEWTON pour le calcul du saut num�ro 3
"""),

68 : _(u"""
 erreur dans le calcul du saut
"""),

69 : _(u"""
 loi %(k1)s  non implant�e pour les �l�ments discrets
"""),





74 : _(u"""
  valeur de D_SIGM_EPSI non trouv�e
"""),

75 : _(u"""
  valeur de SY non trouv�e
"""),

76 : _(u"""
 d�veloppement non implant�
"""),

79 : _(u"""
 loi de comportement avec irradiation, le param�tre N doit �tre sup�rieur � 0
"""),

80 : _(u"""
 loi de comportement avec irradiation, le param�tre PHI_ZERO doit �tre sup�rieur � 0
"""),

81 : _(u"""
 loi de comportement avec irradiation, le param�tre phi/K.PHI_ZERO+L doit �tre sup�rieur ou �gal � 0
"""),

82 : _(u"""
 loi de comportement avec irradiation, le param�tre phi/K.PHI_ZERO+L vaut 0. Dans ces conditions le param�tre BETA doit �tre positif ou nul
"""),

83 : _(u"""
 Vous utilisez le mod�le BETON_UMLV_FP avec un mod�le d'endommagement.
 Attention, la mise � jour des contraintes sera faite suivant les d�formations totales et non pas suivant un sch�ma incr�mental.
"""),

96 : _(u"""
 comportement ZMAT obligatoire
"""),

98 : _(u"""
 il faut d�clarer FONC_DESORP sous ELAS_FO pour le fluage de dessiccation
 intrins�que avec SECH comme param�tre
"""),

}

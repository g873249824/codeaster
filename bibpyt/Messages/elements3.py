#@ MODIF elements3 Messages  DATE 31/10/2011   AUTEUR COURTOIS M.COURTOIS 
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

cata_msg = {

10 : _(u"""
 on ne peut pas affecter la mod�lisation "AXIS_DIAG" aux �l�ments de l'axe
"""),

11 : _(u"""
  -> Attention vous avez une loi de comportement in�lastique et vous �tes
     en contraintes planes, la composante du tenseur de d�formations EPZZ que
     vous allez calculer n'est valable que tant que vous restez dans le
     domaine �lastique. Les autres composantes EPXX, EPYY, EPXY sont correctes.
  -> Risque & Conseil :
     Si le comportement est effectivement non lin�aire, il ne faut pas utiliser
     la valeur de EPZZ calcul�e par cette option.
"""),

12 : _(u"""
 Calcul de G bilin�aire
 E, NU, ALPHA d�pendent de la temp�rature
 Les champs de temp�rature (TGU et TGV) sont diff�rents
"""),

16 : _(u"""
 Comportement: %(k1)s non implant�
"""),

17 : _(u"""
 Le mat�riau  %(k1)s  n'est pas connu
 Seuls sont admis les mat�riaux  'THER' et 'THER_COQUE' pour les coques thermiques
"""),

18 : _(u"""
 Le mat�riau  %(k1)s  n'est pas connu
 Seuls sont admis les mat�riaux  'THER' et 'THER_COQUE' pour le calcul des flux pour les coques thermiques
"""),

19 : _(u"""
 L'option  %(k1)s  n'est disponible qu'avec des �l�ments TETRA ou HEXA en 3D et
 des �l�ments TRIA ou QUAD en 2D.
 Or, la maille  %(k2)s  est de type  %(k3)s .
"""),

20 : _(u"""
 La maille  %(k1)s  ne r�pond pas au crit�re g�om�trique sur les mailles HEXA :
 Les cot�s oppos�s doivent �tre parall�les
"""),

25 : _(u"""
 Calcul de sensibilit� :
 Actuellement, on ne d�rive que les POU_D_E
"""),

26 : _(u"""
 Mauvaise d�finition des caract�ristiques de la section
"""),

28 : _(u"""
 Rigidit� g�om�trique non d�finie pour les �l�ments courbes
"""),

29 : _(u"""
 Force �l�mentaire �lectrique non d�finie pour les �l�ments courbes
"""),

30 : _(u"""
 Section non tubulaire pour MASS_FLUI_STRU
"""),

31 : _(u"""
 Pas de valeur utilisateur pour RHO
"""),

34 : _(u"""
 Seules les forces suiveuses de type vent d�finies par un EVOL_char sont autoris�es
"""),

35 : _(u"""
 Un champ de vitesse de vent est impos� sans donner un Cx d�pendant de la vitesse sur une des barres
"""),

36 : _(u"""
 COMP_INCR non valide
"""),

37 : _(u"""
  Relation :  %(k1)s  non implant�e sur les c�bles
"""),

38 : _(u"""
  D�formation :  %(k1)s  non implant�e sur les c�bles
"""),

39 : _(u"""
 un champ de vitesse de vent est impose sans donner un Cx d�pendant de la vitesse sur un des c�bles.
"""),

46 : _(u"""
 le param�tre "pnosym" n'existe pas dans le catalogue de l'�l�ment  %(k1)s  .
"""),

47 : _(u"""
 la taille de la matrice non-sym�trique en entr�e est fausse.
"""),

48 : _(u"""
 la taille de la matrice sym�trique en sortie est fausse.
"""),

49 : _(u"""
 anisotropie non pr�vue pour coque1d
"""),

50 : _(u"""
 nombre de couches limite a 30 pour les coques 1d
"""),

51 : _(u"""
 Le nombre de couches d�fini dans DEFI_COQU_MULT et dans AFFE_CARA_ELEM dans n'est pas coh�rent.
 Nombre de couches dans DEFI_COQU_MULT: %(i1)d
 Nombre de couches dans AFFE_CARA_ELEM: %(i2)d
"""),

52 : _(u"""
 L'�paisseur totale des couches d�finie dans DEFI_COQU_MULT et celle d�finie dans AFFE_CARA_ELEM ne sont pas coh�rentes.
 �paisseur totale des couches dans DEFI_COQU_MULT: %(r1)f
 �paisseur dans AFFE_CARA_ELEM: %(r2)f
"""),

54 : _(u"""
  la r�actualisation de la g�om�trie (d�formation : PETIT_REAC sous le mot cl� COMP_INCR) est d�conseill�e pour les �l�ments de coque_1d.
"""),

55 : _(u"""
 nombre de couches limite a 10 pour les coques 1d
"""),

56 : _(u"""
 valeurs utilisateurs de RHO ou de rof nulles
"""),

58 : _(u"""
  -> La r�actualisation de la g�om�trie (DEFORMATION='PETIT_REAC' sous
     le mot cl� COMP_INCR) est d�conseill�e pour les �l�ments POU_D_T et POU_D_E.
  -> Risque & Conseil :
     En pr�sence de grands d�placements et grandes rotations, avec une loi de comportement
     non lin�aire, il est pr�f�rable  d'utiliser la mod�lisation POU_D_TGM
     (poutre multi-fibres) avec DEFORMATION=GROT_GDEP. Si le comportement reste
     �lastique, il est �galement possible d'utiliser la mod�lisation POU_D_T_GD avec
     DEFORMATION='GROT_GDEP'.
"""),

59 : _(u"""
  le coefficient de poisson est non constant. la programmation actuelle n en tient pas compte.
"""),

60 : _(u"""
 Noeuds confondus pour un �l�ment de poutre
"""),

61 : _(u"""
 loi  %(k1)s  indisponible pour les pou_d_e/d_t
"""),

62 : _(u"""
 Noeuds confondus pour un �l�ment de barre
"""),

63 : _(u"""
 ne pas utiliser THER_LINEAIRE avec des �l�ments de Fourier mais les commandes d�velopp�es
"""),

67 : _(u"""
 �l�ment d�g�n�r� :
 revoir le maillage
"""),

74 : _(u"""
 pour l'option "RICE_TRACEY", la relation " %(k1)s " n'est pas admise
"""),

75 : _(u"""
 le mat�riau %(k1)s  n'est pas autoris� pour calculer les d�formations plastiques :
 seuls les mat�riaux isotropes sont trait�s en plasticit�
"""),

76 : _(u"""
 couplage fluage/fissuration :
 la loi BETON_DOUBLE_DP ne peut �tre coupl�e qu'avec une loi de fluage de GRANGER
"""),

77 : _(u"""
  -> Attention vous �tes en contraintes planes, et vous utilisez la loi
     de comportement %(k1)s. La composante du tenseur des d�formations
     plastiques EPZZ est calcul�e en supposant l'incompr�hensibilit� des
     d�formations plastiques : EPZZ = -(EPXX + EPYY).
  -> Risque & Conseil :
     V�rifiez que cette expression est valide avec votre loi de comportement.

"""),

78 : _(u"""
  la r�actualisation de la g�om�trie (d�formation : PETIT_REAC sous le mot cl� COMP_INCR) est d�conseill�e pour les �l�ments POU_D_TG
"""),

80 : _(u"""
 situation de contact impossible
"""),

85 : _(u"""
  relation :  %(k1)s  non implant�e sur les �l�ments "pou_d_t_gd"
"""),

86 : _(u"""
  d�formation :  %(k1)s  non implant�e sur les �l�ments "pou_d_t_gd"
"""),

87 : _(u"""
 RCVALA ne trouve pas RHO, qui est n�cessaire en dynamique
"""),

91 : _(u"""
  calcul de la masse non implant� pour les �l�ments COQUE_3D en grandes rotations, d�formation : GROT_GDEP
"""),

92 : _(u"""
 les comportements �lastiques de type COMP_ELAS ne sont pas disponibles pour la mod�lisation DKTG.
"""),

93 : _(u"""
  d�formation :  %(k1)s  non implant�e sur les �l�ments COQUE_3D en grandes rotations
  d�formation : GROT_GDEP obligatoirement
"""),

94 : _(u"""
  -> La r�actualisation de la g�om�trie (DEFORMATION='PETIT_REAC' sous
     le mot cl� COMP_INCR) est d�conseill�e pour les �l�ments COQUE_3D.
  -> Risque & Conseil :
     Le calcul des d�formations � l'aide de PETIT_REAC n'est qu'une
     approximation des hypoth�ses des grands d�placements. Elle n�cessite
     d'effectuer de tr�s petits incr�ments de chargement. Pour prendre en
     compte correctement les grands d�placements et surtout les grandes
     rotations, il est recommand� d'utiliser DEFORMATION='GROT_GDEP'.

"""),

95 : _(u"""
  Num�ro de couche incorrect
"""),

98 : _(u"""
 comportement coeur homog�n�ise inexistant
"""),

99 : _(u"""
  : seule les poutres � sections constantes sont admises !
"""),

}

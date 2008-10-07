#@ MODIF elements3 Messages  DATE 07/10/2008   AUTEUR PELLET J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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

cata_msg = {

10 : _("""
 on ne peut pas affecter la modelisation "axis_diag" aux elements de l'axe
"""),

11 : _("""
  -> Attention vous avez une loi de comportement in�lastique et vous etes
     en contraintes planes, la composante du tenseur de d�formations EPZZ que
     vous allez calculer n'est valable que tant que vous restez dans le
     domaine �lastique. Les autres composantes EPXX, EPYY, EPXY sont correctes.
  -> Risque & Conseil :
     Si le comportement est effectivement non lin�aire, il ne faut pas utiliser
     la valeur de EPZZ calcul�e par cette option.
"""),

12 : _("""
 Calcul de G bilin�aire
 E, NU, ALPHA d�pendent de la temperature
 Les champs de temp�rature (TGU et TGV) sont diff�rents
"""),

16 : _("""
 Comportement: %(k1)s non implant�
"""),

17 : _("""
 Le mat�riau  %(k1)s  n'est pas connu
 Seuls sont admis les mat�riaux  'THER' et 'THER_COQUE' pour les coques thermiques
"""),

18 : _("""
 Le mat�riau  %(k1)s  n'est pas connu
 Seuls sont admis les materiaux  'THER' et 'THER_COQUE' pour le calcul des flux pour les coques thermiques
"""),

19 : _("""
 L'option  %(k1)s  n'est disponible qu'avec des �l�ments TETRA ou HEXA
 Or, la maille  %(k2)s  est de type  %(k3)s .
"""),

20 : _("""
 La maille  %(k1)s  ne r�pond pas au crit�re g�ometrique sur les mailles HEXA :
 Les cot�s oppos�s doivent �tre parall�les
"""),

25 : _("""
 Calcul de sensibilit� :
 Actuellement, on ne d�rive que les POU_D_E
"""),

26 : _("""
 Mauvaise d�finition des caract�ristiques de la section
"""),

28 : _("""
 Rigidit� g�om�trique non d�finie pour les �l�ments courbes
"""),

29 : _("""
 Force �l�mentaire �lectrique non d�finie pour les �l�ments courbes
"""),

30 : _("""
 Section non tubulaire pour MASS_FLUI_STRU
"""),

31 : _("""
 Pas de valeur utilisateur pour RHO
"""),

34 : _("""
 Seules les forces suiveuses de type vent d�finies par un evol_char sont autoris�es
"""),

35 : _("""
 Un champ de vitesse de vent est impos� sans donner un CX d�pendant de la vitesse sur une des barres
"""),

36 : _("""
 comp_incr non valide
"""),

37 : _("""
  Relation :  %(k1)s  non implant�e sur les cables
"""),

38 : _("""
  D�formation :  %(k1)s  non implant�e sur les cables
"""),

39 : _("""
 un champ de vitesse de vent est impose sans donner un cx dependant de la vitesse sur un des cables.
"""),

46 : _("""
 le parametre "pnosym" n'existe pas dans le catalogue de l'element  %(k1)s  .
"""),

47 : _("""
 la taille de la matrice non-symetrique en entree est fausse.
"""),

48 : _("""
 la taille de la matrice symetrique en sortie est fausse.
"""),

49 : _("""
 anisotropie non prevue pour coque1d
"""),

50 : _("""
 nombre de couches limite a 30 pour les coques 1d
"""),

51 : _("""
 Le nombre de couches d�fini dans DEFI_COQU_MULT et dans AFFE_CARA_ELEM dans n'est pas coh�rent.
 Nombre de couches dans DEFI_COQU_MULT: %(i1)d
 Nombre de couches dans AFFE_CARA_ELEM: %(i2)d
"""),

52 : _("""
 L'�paisseur totale des couches definie dans DEFI_COQU_MULT et celle d�finie dans AFFE_CARA_ELEM ne sont pas coh�rentes.
 Epaisseur totale des couches dans DEFI_COQU_MULT: %(r1)f
 Epaisseur dans AFFE_CARA_ELEM: %(r2)f
"""),

54 : _("""
  la reactualisation de la geometrie (deformation : petit_reac sous le mot cle comp_incr) est deconseillee pour les elements de coque_1d.
"""),

55 : _("""
 nombre de couches limite a 10 pour les coques 1d
"""),

56 : _("""
 valeurs utilisateurs de rho ou de rof nulles
"""),

57 : _("""
 pas d elements lumpes pourhydratation 
"""),

58 : _("""
  -> La r�actualisation de la g�om�trie (DEFORMATION='PETIT_REAC' sous
     le mot cl� COMP_INCR) est d�conseill�e pour les �l�ments POU_D_T et POU_D_E.
  -> Risque & Conseil :
     En pr�sence de grands d�placements et grandes rotations, avec une loi de comportement
     non lin�aire, il est pr�f�rable  d'utiliser la mod�lisation POU_D_TGM
     (poutre multi-fibres) avec DEFORMATION=REAC_GEOM. Si le comportement reste
     �lastique, il est �galement possible d'utiliser la mod�lisation POU_D_T_GD avec
     DEFORMATION='GREEN_GR'.
"""),

59 : _("""
  le coefficient de poisson est non constant. la programmation actuelle n en tient pas compte.
"""),

60 : _("""
 Noeuds confondus pour un �l�ment de poutre
"""),

61 : _("""
 loi  %(k1)s  indisponible pour les pou_d_e/d_t
"""),

62 : _("""
 Noeuds confondus pour un �l�ment de barre
"""),

63 : _("""
 ne pas utiliser THER_LINEAIRE avec des �l�ments de fourier mais les cmdes developpees
"""),

67 : _("""
 El�ment d�g�n�r� : 
 revoir le maillage
"""),

74 : _("""
 pour l'option "RICE_TRACEY", la relation " %(k1)s " n'est pas admise
"""),

75 : _("""
 le mat�riau %(k1)s  n'est pas autoris� pour calculer les deformations plastiques :
 seuls les mat�riaux isotropes sont trait�s en plasticit�
"""),

76 : _("""
 couplage fluage/fissuration :
 la loi BETON_DOUBLE_DP ne peut etre coupl�e qu'avec une loi de fluage de GRANGER
"""),

77 : _("""
  -> Attention vous etes en contraintes planes, et vous utilisez la loi
     de comportement %(k1)s. La composante du tenseur des d�formations
     plastiques EPZZ est calcul�e en supposant l'incompressibilit� des
     d�formations plastiques : EPZZ = -(EPXX + EPYY).
  -> Risque & Conseil :
     V�rifiez que cette expression est valide avec votre loi de comportement.

"""),

78 : _("""
  la r�actualisation de la g�ometrie (d�formation : PETIT_REAC sous le mot cle COMP_INCR) est deconseill�e pour les �l�ments POU_D_TG
"""),

80 : _("""
 situation de contact impossible
"""),

84 : _("""
 type de maille inconnu
"""),

85 : _("""
  relation :  %(k1)s  non implantee sur les elements "pou_d_t_gd"
"""),

86 : _("""
  deformation :  %(k1)s  non implantee sur les elements "pou_d_t_gd"
"""),

87 : _("""
 RCVALA ne trouve pas RHO, qui est n�cessaire en dynamique
"""),

91 : _("""
  calcul de la masse non implant� pour les �l�ments COQUE_3D en grandes rotations, deformation : GREEN_GR
"""),

92 : _("""
 les comportements elastiques de type comp_elas ne sont pas disponibles pour la modelisation dktg.
"""),

93 : _("""
  d�formation :  %(k1)s  non implant�e sur les �l�ments COQUE_3D en grandes rotations
  d�formation : GREEN_GR obligatoirement 
"""),

94 : _("""
  -> La r�actualisation de la g�om�trie (DEFORMATION='PETIT_REAC' sous
     le mot cl� COMP_INCR) est d�conseill�e pour les �l�ments COQUE_3D.
  -> Risque & Conseil :
     Le calcul des d�formations � l'aide de PETIT_REAC n'est qu'une
     approximation des hypoth�ses des grands d�placements. Elle n�cessite
     d'effectuer de tr�s petits incr�ments de chargement. Pour prendre en
     compte correctement les grands d�placements et surtout les grandes
     rotations, il est recommand� d'utiliser DEFORMATION='GREEN_GR'.

"""),

95 : _("""
  nume_couche incorrect
"""),

98 : _("""
 comportement coeur homog�n�ise inexistant
"""),

99 : _("""
  : seule les poutres � sections constantes sont admises !
"""),

}

#@ MODIF elements4 Messages  DATE 04/10/2010   AUTEUR PROIX J-M.PROIX 
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
# RESPONSABLE DELMAS J.DELMAS

def _(x) : return x

cata_msg = {

1 : _("""
  erreur dans le calcul de pres_f
"""),

2 : _("""
 pour l'option INDIC_ENER, les seules relations admises sont "vmis_isot_line" et "vmis_isot_trac" .
"""),

3 : _("""
 pour l'option INDIC_SEUIL, les seules relations admises sont "vmis_isot_line", "vmis_isot_trac"  et "vmis_cine_line" .
"""),

6 : _("""
 le type du champ de contraintes est incompatible avec l'option :  %(k1)s
"""),

7 : _("""
 pas de contraintes dans PCONTGP
"""),

8 : _("""
 pas de champ endo_elga dans ptriagp
"""),

9 : _("""
 pas de champ vari_elga dans pvarimr
"""),

10 : _("""
 pas de champ vari_elga dans pvaripr
"""),

11 : _("""
 option non trait�e  %(k1)s
 """),

15 : _("""
  deformation :  %(k1)s non implant�e sur les �l�ments "pou_d_tgm" : utiliser PETIT ou GROT_GDEP
"""),

16 : _("""
 option "vari_elno_elga" impossible actuellement
"""),

31 : _("""
 dfdi mal dimensionn�e
"""),

32 : _("""
 vous utilisez le mot cl� liaison_elem avec l'option coq_pou: l'�paisseur des �l�ments de bord de coque n'a pas �t� affect�e.
"""),

33 : _("""
 l'epaisseur des �l�ments de bord de coque est negative ou nulle.
"""),

34 : _("""
 le jacobien est nul.
"""),

35 : _("""
 matns() sous-dimensionn�
"""),

36 : _("""
 pr() sous-dimensionne
"""),

38 : _("""
 option  %(k1)s  non active pour un �l�ment de type  %(k2)s
"""),

39 : _("""
 option  %(k1)s  : incompatibilit� des deux champs d entr�e
"""),

40 : _("""
 le nombre de ddl est trop grand
"""),

41 : _("""
 le nombre de ddl est faux
"""),

42 : _("""
 nom de type �l�ment inattendu
"""),

43 : _("""
 comp. elastique inexistant
"""),

44 : _("""
 l'option " %(k1)s " est interdite pour les tuyaux
"""),

45 : _("""
 l'option " %(k1)s " en rep�re local est interdite pour les tuyaux : utiliser le rep�re global
"""),

46 : _("""
 le nombre de couches et de secteurs doivent etre sup�rieurs a 0
"""),

47 : _("""
 composante  %(k1)s  non trait�e, on abandonne
"""),

48 : _("""
 champ  %(k1)s  non trait�, on abandonne
"""),

49 : _("""
 l'option " %(k1)s " est non pr�vue
"""),

51 : _("""
  nume_sect incorrect
"""),

52 : _("""
 mauvaise option
"""),

53 : _("""
 ep/r > 0.2 modi_metrique pas adapt�
"""),

54 : _("""
 ep/r > 0.2 modi_metrique=non pas adapt�
"""),

56 : _("""
 famille inexistante  %(k1)s
"""),

57 : _("""
 indn = 1 (int�gration normale) ou indn = 0 (integration r�duite) obligatoirement.
"""),

58 : _("""
  le code " %(k1)s " est non pr�vu. code doit etre = "gl" ou "lg"
"""),

61 : _("""
 pr�conditions non remplies
"""),

62 : _("""
  erreur: �l�ment non 2d
"""),

63 : _("""
  l'option %(k1)s n'est pas disponible pour le comportement %(k2)s
"""),

65 : _("""
  Comportement inattendu : %(k1)s.
"""),

67: _("""
Le module d'Young est nul.
"""),

69 : _("""
 pb r�cuperation donn�e mat�riau dans thm_liqu %(k1)s
"""),

70 : _("""
 pb r�cup�ration donn�e mat�riau dans thm_init %(k1)s
"""),

71 : _("""
 pb r�cup�ration donn�es mat�riau dans elas %(k1)s
"""),

72 : _("""
   rcvala ne trouve pas nu, qui est n�cessaire pour l'�l�ment MECA_HEXS8
"""),

73 : _("""
   �l�ment MECA_HEXS8:COMP_ELAS non implant�, utiliser COMP_INCR RELATION='ELAS'
"""),

74 : _("""
  Attention l'�l�ment MECA_HEXS8 ne fonctionne correctement que sur les parall�l�pip�des.
  Sur les elements quelconques on peut obtenir des r�sultats faux.
"""),

76 : _("""
 la maille du mod�le de num�ro:  %(i1)d n appartient � aucun sous-domaine !
"""),

77 : _("""
 numero de couche  %(i1)d
 trop grand par rapport au nombre de couches autoris� pour la maille  %(k1)s
"""),

78 : _("""
 pb recuperation donn�e mat�riau dans thm_diffu %(k1)s
"""),

79 : _("""
 la loi de comportement n'existe pas pour la mod�lisation dktg :  %(k1)s
"""),

80 : _("""
  L'�l�ment de plaque QUAD4 d�fini sur la maille : %(k1)s
  n'est pas plan et peut conduire a des r�sultats faux
  Distance au plan :  %(r1)f
"""),

81 : _("""
 Il manque le param�tre  %(k1)s pour la maille  %(k2)s
"""),

84 : _("""
 famille non disponible �l�ment de r�f�rence  %(k1)s
 famille  %(k2)s
"""),

88 : _("""
 ELREFE non disponible �l�ment de r�f�rence  %(k1)s
"""),

90 : _("""
 ELREFE mal programme maille  %(k1)s  type  %(k2)s  nb noeuds  %(i1)d
 nb noeuds pour le gano  %(i2)d
"""),

91 : _("""
 Le calcul de cet estimateur ne tient pas compte d'�ventuelles
 conditions limites non lin�aires
"""),

92 : _("""
Erreur utilisateur :
 Vous essayez d'appliquer une pression (comme fonction) non nulle sur un �l�ment de coque.
 (AFFE_CHAR_MECA_F/PRES_REP/PRES) pour la maille  %(k1)s
 La programmation ne le permet pas.

Conseil :
 Pour appliquer une telle presssion, il faut utiliser AFFE_CHAR_MECA_F/FORCE_COQUE/PRES
"""),

98 : _("""
 la contrainte �quivalente est nulle pour la maille  %(k1)s
"""),

}

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

1 : _(u"""
  erreur dans le calcul de PRES_F
"""),

2 : _(u"""
 pour l'option INDIC_ENER, les seules relations admises sont "VMIS_ISOT_LINE" et "VMIS_ISOT_TRAC" .
"""),

3 : _(u"""
 pour l'option INDIC_SEUIL, les seules relations admises sont "VMIS_ISOT_LINE", "VMIS_ISOT_TRAC"  et "VMIS_CINE_LINE" .
"""),

14 : _(u"""
  Vous utilisez un �l�ment de type multifibre <%(k1)s>.
  Il faut que sous COMP_INCR le mot clef RELATION='MULTIFIBRE'.
"""),

31 : _(u"""
 dfdi mal dimensionn�e
"""),

32 : _(u"""
 vous utilisez le mot cl� LIAISON_ELEM avec l'option COQ_POU: l'�paisseur des �l�ments de bord de coque n'a pas �t� affect�e.
"""),

33 : _(u"""
 l'�paisseur des �l�ments de bord de coque est n�gative ou nulle.
"""),

34 : _(u"""
 le jacobien est nul.
"""),

38 : _(u"""
 option  %(k1)s  non active pour un �l�ment de type  %(k2)s
"""),

39 : _(u"""
 option  %(k1)s  : incompatibilit� des deux champs d entr�e
"""),

40 : _(u"""
 le nombre de ddl est trop grand
"""),

41 : _(u"""
 le nombre de ddl est faux
"""),

42 : _(u"""
 nom de type �l�ment inattendu
"""),

43 : _(u"""
 comportement. �lastique inexistant
"""),

44 : _(u"""
 l'option " %(k1)s " est interdite pour les tuyaux
"""),

45 : _(u"""
 l'option " %(k1)s " en rep�re local est interdite pour les tuyaux : utiliser le rep�re global
"""),

46 : _(u"""
 le nombre de couches et de secteurs doivent �tre sup�rieurs a 0
"""),

48 : _(u"""
 champ  %(k1)s  non trait�, on abandonne
"""),

49 : _(u"""
 l'option " %(k1)s " est non pr�vue
"""),

51 : _(u"""
  NUME_SECT incorrect
"""),

53 : _(u"""
 ep/r > 0.2 MODI_METRIQUE pas adapt�
"""),

54 : _(u"""
 ep/r > 0.2 MODI_METRIQUE=non pas adapt�
"""),

56 : _(u"""
 famille inexistante  %(k1)s
"""),

57 : _(u"""
 indn = 1 (int�gration normale) ou indn = 0 (int�gration r�duite) obligatoirement.
"""),

58 : _(u"""
  le code " %(k1)s " est non pr�vu. code doit �tre = "gl" ou "lg"
"""),

59 : _(u"""
Pour l'option %(k1)s, vous ne pouvez affecter qu'un seul mat�riau qui ne doit avoir
qu'un seul comportement : ELAS. Commande DEFI_MATERIAU / ELAS.
Conseil :
   D�finir un seul mat�riau avec un seul comportement : ELAS.
"""),

61 : _(u"""
 pr�conditions non remplies
"""),

62 : _(u"""
  erreur: �l�ment non 2d
"""),

63 : _(u"""
  l'option %(k1)s n'est pas disponible pour le comportement %(k2)s
"""),

64 : _(u"""
Pour l'option %(k1)s votre mat�riau doit avoir un seul comportement : ELAS.
Commande DEFI_MATERIAU / ELAS.
Votre mat�riau a %(k2)s comme comportement possible.
Conseil :
   D�finir un mat�riau avec un seul comportement : ELAS.
"""),

65 : _(u"""
  Comportement inattendu : %(k1)s.
"""),

67: _(u"""
Le module de Young est nul.
"""),

69 : _(u"""
 Probl�me r�cup�ration donn�e mat�riau dans THM_LIQU %(k1)s
"""),

70 : _(u"""
 Probl�me r�cup�ration donn�e mat�riau dans THM_INIT %(k1)s
"""),

71 : _(u"""
 Probl�me r�cup�ration donn�es mat�riau dans ELAS %(k1)s
"""),

72 : _(u"""
   RCVALA ne trouve pas nu, qui est n�cessaire pour l'�l�ment MECA_HEXS8
"""),

73 : _(u"""
   �l�ment MECA_HEXS8:COMP_ELAS non implant�, utiliser COMP_INCR RELATION='ELAS'
"""),

74 : _(u"""
  Attention l'�l�ment MECA_HEXS8 ne fonctionne correctement que sur les parall�l�pip�des.
  Sur les �l�ments quelconques on peut obtenir des r�sultats faux.
"""),

76 : _(u"""
 la maille du mod�le de num�ro:  %(i1)d n appartient � aucun sous-domaine !
"""),

78 : _(u"""
 Probl�me r�cup�ration donn�e mat�riau dans THM_DIFFU %(k1)s
"""),

79 : _(u"""
 la loi de comportement n'existe pas pour la mod�lisation DKTG :  %(k1)s
"""),

80 : _(u"""
  L'�l�ment de plaque QUAD4 d�fini sur la maille : %(k1)s
  n'est pas plan et peut conduire a des r�sultats faux
"""),

81 : _(u"""
 Il manque le param�tre  %(k1)s pour la maille  %(k2)s
"""),

82 : _(u"""
  Distance au plan :  %(r1)f
"""),

84 : _(u"""
 famille non disponible �l�ment de r�f�rence  %(k1)s
 famille  %(k2)s
"""),

88 : _(u"""
 ELREFE non disponible �l�ment de r�f�rence  %(k1)s
"""),

90 : _(u"""
 ELREFE mal programme maille  %(k1)s  type  %(k2)s  nombre noeuds  %(i1)d
 nombre noeuds pour le passage Gauss noeuds  %(i2)d
"""),

91 : _(u"""
 Le calcul de cet estimateur ne tient pas compte d'�ventuelles
 conditions limites non lin�aires
"""),

92 : _(u"""
Erreur utilisateur :
 Vous essayez d'appliquer une pression (comme fonction) non nulle sur un �l�ment de coque.
 (AFFE_CHAR_MECA_F/PRES_REP/PRES) pour la maille  %(k1)s
 La programmation ne le permet pas.

Conseil :
 Pour appliquer une telle pression, il faut utiliser AFFE_CHAR_MECA_F/FORCE_COQUE/PRES
"""),

}

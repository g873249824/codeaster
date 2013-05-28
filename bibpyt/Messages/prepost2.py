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
  Il faut autant de nom pour NOM_CHAM_MED que pour NOM_CHAM.
"""),

2 : _(u"""
Mod�le inconnu, pas d'impression du champ  %(k1)s
"""),

3 : _(u"""
On ne sait pas �crire des champs par �l�ment aux points de gauss au format CASTEM
"""),

4 : _(u"""
 erreur programmation
"""),

5 : _(u"""
 Le mot-cl� RESTREINT n'est pas autoris� dans EXTR_RESU en reuse.
"""),

35 : _(u"""
   d�sol� on ne sait pas �crire les champs aux noeuds de repr�sentation constante et a valeurs complexes au format  %(k1)s
"""),

36 : _(u"""
   d�sole on ne sait pas �crire le champ aux noeuds  %(k1)s  au format  %(k2)s
"""),

40 : _(u"""
 aucune des composantes demand�es sous le mot-cl� NOM_CMP pour l'impression du CHAM_GD  %(k1)s  n'est pr�sente dans la grandeur  %(k2)s
"""),

41 : _(u"""
 aucune des composantes demand�es sous le mot-cl� NOM_CMP pour l'impression du champ  %(k1)s  du concept  %(k2)s  n'est pr�sente dans la grandeur  %(k3)s
"""),

46 : _(u"""
  num�ro d'ordre  %(k1)s  non licite
"""),

51 : _(u"""
 type de structure non traite:  %(k1)s
"""),

52 : _(u"""
 on imprime que des champs ELNO
"""),

53 : _(u"""
 nombre de composantes diff�rent
"""),

54 : _(u"""
 composante inconnue %(k1)s
"""),

55 : _(u"""
 L'ordre des composantes �tabli lorsque que vous avez renseign� le mot-cl�
 NOM_CMP est diff�rent de celui du catalogue Aster:
    - ordre des composantes fournies     : %(k1)s %(k2)s %(k3)s %(k4)s %(k5)s %(k6)s
    - ordre des composantes du catalogue : %(k7)s %(k8)s %(k9)s %(k10)s %(k11)s %(k12)s
"""),

56 : _(u"""
 on imprime que des champs "ELGA" ou "ELEM"
"""),

57 : _(u"""
 nombre de sous-points diff�rent de 1
"""),

58 : _(u"""
 pas de correspondance
"""),

59 : _(u"""
 aucun champ trouve, pas d'impression au format "GMSH"
"""),

60 : _(u"""
 On ne sait pas imprimer au format "GMSH" le champ %(k1)s
 car il est de type %(k2)s.
"""),

61 : _(u"""
 erreur de programmation : nombre de composantes diff�rent de 1 ou 3.
"""),

62 : _(u"""
 on ne peut pas traiter des �l�ments a plus de 99 noeuds !
"""),

63 : _(u"""
 erreur de programmation
"""),

64 : _(u"""
 SEG4 �l�ment inexistant dans CASTEM, converti en SEG2
"""),

65 : _(u"""
 tria7 �l�ment inexistant dans CASTEM, converti en tria6
"""),

66 : _(u"""
 QUAD9 �l�ment inexistant dans CASTEM, converti en QUAD8
"""),

67 : _(u"""
 les champs n'ont pas la m�me grandeur
"""),

68 : _(u"""
 les champs n'ont pas la m�me num�rotation
"""),

69 : _(u"""
 les champs n'ont pas le m�me type de valeurs
"""),

70 : _(u"""
   d�sol� on ne sait pas �crire les champs aux noeuds de repr�sentation constante au format IDEAS
"""),




77 : _(u"""
 la dimension du probl�me est invalide : il faut : 1d, 2d, 3d.
"""),

78 : _(u"""
 HEXA27 �l�ment inexistant dans IDEAS, converti en HEXA20
"""),

79 : _(u"""
 tria7 �l�ment inexistant dans IDEAS, converti en tria6
"""),

80 : _(u"""
 QUAD9 �l�ment inexistant dans IDEAS, converti en QUAD8
"""),

81 : _(u"""
 SEG4 �l�ment inexistant dans IDEAS, converti en SEG2
"""),

82 : _(u"""
 �l�ment PYRAM5 non disponible dans IDEAS
"""),

83 : _(u"""
 �l�ment PYRAM13 non disponible dans IDEAS
"""),

84 : _(u"""
 Le champ %(k1)s est un champ aux noeuds par �l�ments
 contenant des %(k2)s
 Or l'impression de ce type de champ n'est pas encore possible au format MED
 On n'imprimera donc pas ce champ dans le fichier MED
"""),

85 : _(u"""
 L'�l�ment PENTA18 est inexistant dans IDEAS, il est converti en PENTA15.
"""),

86 : _(u"""
 L'�l�ment PENTA18 est inexistant dans CASTEM, il est converti en PENTA15.
"""),

93 : _(u"""
 on ne sait pas �crire les mailles de type  %(k1)s
"""),

}

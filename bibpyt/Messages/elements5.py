# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    2 : _("""
 tuyau : le nombre de couches est limite a  %(i1)d
"""),

    3 : _("""
 tuyau : le nombre de secteurs est limite a  %(i1)d
"""),

    4 : _("""
 Le nombre de sous-points est limité à %(i1)d, or vous en avez définis %(i2)d !
 Veuillez contacter votre assistance technique.
"""),

    15 : _("""
A l'occurrence %(i1)d, les objets précédemment évoqués sont inexistants ou de type incompatible.
"""),

    16 : _("""
Les mailles fournies sont non consécutives dans la numérotation des noeuds.
En effet, les mailles segment doivent être ordonnées de telle sorte que pour deux segments
consécutifs, le deuxième noeud sommet du premier segment soit le même que le premier noeud
sommet du deuxième segment.

Conseil : Pour ordonner les mailles du fond de fissure, veuillez
utiliser NOEUD_ORIG (ou GROUP_NO_ORIG) et NOEUD_EXTR (ou GROUP_NO_EXTR).
"""),

    17 : _("""
Un seul noeud doit constituer le groupe de noeuds %(k1)s. On n'utilisera que le noeud %(k2)s.
"""),

    19 : _("""
 A l'occurrence %(i1)d, la maille %(k1)s est inexistante.
"""),

    20 : _("""
 A l'occurrence %(i1)d, la maille %(k1)s n'est pas linéique.
"""),

    21 : _("""
 A l'occurrence %(i1)d, le mélange de SEG2 et de SEG3 (maille %(k1)s) n'est possible.
"""),

    22 : _("""
   Erreur, le nombre de noeuds d'un élément de joint 3D n'est pas correct
"""),

    23 : _("""
   Erreur, le nombre de points de Gauss d'un élément de joint 3D n'est pas correct
"""),

    24 : _("""
  le nombre de mailles du modèle %(i1)d est différent de la somme des mailles des
  sous-domaines %(i2)d
"""),





    28 : _("""
  le modèle comporte %(i1)d mailles de plus que l'ensemble des sous-domaines
"""),

    29 : _("""
  le modèle comporte %(i1)d mailles de moins que l'ensemble des sous-domaines
"""),

    30 : _("""
 jacobien négatif ou nul : jacobien =  %(r1)f
"""),







    39 : _("""
 Échec de la recherche de zéro a l'itération :  %(i1)d
  fonction décroissante - pour x=a:  %(r1)f
  / fonction(a):  %(r2)f
                          et   x=b:  %(r3)f
  / fonction(b):  %(r4)f

  fonction x=:  %(r5)f  %(r6)f  %(r7)f  %(r8)f  %(r9)f  %(r10)f %(r11)f %(r12)f %(r13)f %(r14)f
                %(r15)f %(r16)f %(r17)f %(r18)f %(r19)f %(r20)f %(r21)f %(r22)f %(r23)f %(r24)f

  fonction f=:  %(r25)f  %(r26)f  %(r27)f  %(r28)f  %(r29)f  %(r30)f %(r31)f %(r32)f %(r33)f %(r34)f
                %(r35)f  %(r36)f  %(r37)f  %(r38)f  %(r39)f  %(r40)f %(r41)f %(r42)f %(r43)f %(r44)f

"""),

    40 : _("""
 Échec de la recherche de zéro a l'itération :  %(i1)d
  fonction constante    - pour x=a:  %(r1)f
  / fonction(a):  %(r2)f
                          et   x=b:  %(r3)f
  / fonction(b):  %(r4)f

  fonction x=:  %(r5)f  %(r6)f  %(r7)f  %(r8)f  %(r9)f  %(r10)f %(r11)f %(r12)f %(r13)f %(r14)f
                %(r15)f %(r16)f %(r17)f %(r18)f %(r19)f %(r20)f %(r21)f %(r22)f %(r23)f %(r24)f

  fonction f=:  %(r25)f  %(r26)f  %(r27)f  %(r28)f  %(r29)f  %(r30)f %(r31)f %(r32)f %(r33)f %(r34)f
                %(r35)f  %(r36)f  %(r37)f  %(r38)f  %(r39)f  %(r40)f %(r41)f %(r42)f %(r43)f %(r44)f

"""),

    42 : _("""
 L'épaisseur définie dans DEFI_GLRC et celle définie dans AFFE_CARA_ELEM ne sont pas cohérentes.
 Épaisseur dans DEFI_GLRC: %(r1)f
 Épaisseur dans AFFE_CARA_ELEM: %(r2)f
"""),

    45 : _("""
OPTION MASS_INER : la masse volumique RHO doit être non nulle
"""),

    46 : _("""
  relation :  %(k1)s  non implantée pour les éléments COQUE_3D
  relation : ELAS obligatoirement
"""),

    47 : _("""
    Il n'est pas possible d'utiliser ANGL_AXE et ORIG_AXE de AFFE_CARA_ELEM pour les modélisations XXX_INTERFACE
"""),

    48 : _("""
    Il n'est pas possible d'utiliser ANGL_AXE et ORIG_AXE de AFFE_CARA_ELEM pour les modélisations XXX_JHMS
"""),
    49 : _("""
   La méthode IMPLEX ne peut pas être utilisée avec la loi de comportement que vous
   avez choisi ; sur les éléments BARRE elle n'est utilisable qu'avec VMIS_ISOT_LINE et ELAS
"""),

    50 : _("""
   La méthode IMPLEX ne peut pas être utilisée avec la loi de comportement que vous
   avez choisi ; sur les éléments 2D et 3D elle n'est utilisable qu'avec VMIS_ISOT_LINE,
   et ENDO_ISOT_BETON
"""),

    51 : _("""
  CHAMP :  %(k1)s  non traité sous le type COQUE_GENE. Les champs traités sont
  EFGE et DEGE (ELGA ou ELNO)
"""),

    52 : _("""
  CHAMP :  %(k1)s  non traité sous le type TENS_3D. Les champs traités sont
  SIGM et EPSI (ELGA ou ELNO)
"""),

    53 : _("""
  TYPE :  %(k1)s  non traité pour les coques. Les types traités sont
  TENS_3D et COQUE_GENE.
"""),

    54 : _("""
  Le nombre de sous-points est : %(i1)d. Il doit soit valoir 1 (si on a déjà extrait le champ) soit un
  multiple de 3 (si le champ est complet).
"""),

    55 : _("""
  Le changement de repère : %(k1)s sur les coques n'est pas traité pour les champs de type : %(k2)s.
"""),

}

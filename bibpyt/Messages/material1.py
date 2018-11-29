# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

    1: _("""
Erreur utilisateur :
 Pour définir le coefficient de dilatation thermique ALPHA, vous devez utiliser uniquement une fonction. Les formules et les nappes sont interdites
 Utilisez CALC_FONC_INTERP si nécessaire.
"""),

    2: _("""
Erreur utilisateur :
  Dans le CHAM_MATER %(k1)s, vous avez affecté le matériau %(k2)s.
  Dans ce matériau, il existe un coefficient de dilatation thermique ALPHA
  qui est une fonction de la température.
  Pour pouvoir utiliser cette fonction, il est nécessaire de transformer
  cette fonction (changement de repère : "TEMP_DEF_ALPHA" -> "TEMP_REF").
  Pour cela, l'utilisateur doit fournir une température de référence.

Solution :
  Vérifier que les mailles affectées par le matériau %(k2)s sont bien
  toutes affectées par une température de référence
  (mot clé AFFE_VARC/NOM_VARC='TEMP',VALE_REF=...).
"""),

    3: _("""
Erreur utilisateur :
 Problème lors de l'interpolation de la fonction définissant le coefficient de dilatation thermique ALPHA.
 Il faut resserrer le mot clé PRECISION pour le matériau ELAS_FO.
"""),

    4: _("""
Erreur utilisateur :
 Le paramètre ALPHA ne peut pas être une fonction en THM.
"""),

    42: _("""
Erreur utilisateur :
 Le coefficient de dilatation thermique ALPHA du matériau est une fonction de la température.
 Cette fonction (%(k1)s) n'est définie que par un point.
 TEMP_DEF_ALPHA et TEMP_REF ne sont pas identiques.
 On ne peut pas faire le changement de variable TEMP_DEF_ALPHA -> TEMP_REF.
 On s'arrête donc.

Risque & Conseil:
 Il faut définir la fonction ALPHA avec plus d'un point.
"""),

    43: _("""
 Le coefficient de dilatation thermique ALPHA du matériau est une fonction de la température.
 Or vous ne fournissez pas de résultats thermiques dans AFFE_MATERIAU / AFFE_VARC.
 Dans ce cas, TEMP_DEF_ALPHA et TEMP_REF doivent être identiques. 
"""),

    56: _("""
Erreur utilisateur :
 Un des matériaux du CHAM_MATER %(k1)s contient un coefficient de dilatation ALPHA fonction de la température.
 Mais la température de référence n'est pas fournie sous AFFE_MATERIAU/AFFE_VARC/VALE_REF
"""),

}

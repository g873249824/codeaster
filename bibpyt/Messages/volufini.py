# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

# person_in_charge: sylvie.granet at edf.fr

cata_msg = {

    2 : _("""
Le sommet de numéro global %(i1)i n'appartient pas à la maille %(i2)i
"""),

    3 : _("""
Une des modélisations utilisée nécessite la création d'un voisinage des mailles.
Or, pour une maille donnée il n'est pas autorisé de dépasser le seuil de 200 voisines.

Avec le maillage fourni, ce seuil est dépassé pour la maille %(k1)s.
"""),

    4 : _("""
Le nombre de sommets communs %(i1)i est trop grand
"""),

    5 : _("""
Le nombre de mailles %(i1)i est inférieur à un.
"""),

    6 : _("""
Le type de voisinage %(k1)s est inconnu.
"""),

    7 : _("""
Le type de voisinage %(k1)s a une longueur %(i1)i trop grande
"""),

    13 : _("""
L'élément %(k1)s et la face  %(i1)i est non plane
"""),

}

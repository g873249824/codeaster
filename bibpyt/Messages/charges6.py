# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

    1 : _("""
 Pour le chargement thermique ECHANGE_PAROI, le type de maille utilisé n'est pas possible.
 Vérifiez que vous avez correctement défini la paroi.
"""),

    2 : _("""
 Pour le chargement thermique ECHANGE_PAROI, le modèle fourni doit être homogène
 en dimension : 3D, 2D ou AXIS.
"""),

    3 : _("""
 Les chargements thermiques de type EVOL_CHAR ne sont pas pris en compte dans cet opérateur.
"""),

    4 : _("""
 Erreur lors de l'opération LIAISON_MAIL.
 L'élément %(k1)s n'est pas du bon type. 
 Si cette maille correspond à un élément affecté d'une modélisation de type coque, il faut utiliser l'option TYPE_RACCORD='MASSIF_COQUE' ou TYPE_RACCORD='COQUE_MASSIF'.
"""),

    5 : _("""
Erreur lors de l'opération LIAISON_CYCLE.
L'élément %(k1)s n'est pas du bon type. 
Si vous êtes en deux dimensions, les éléments doivent être des segments.
Si vous êtes en trois dimensions, les éléments doivent être des triangles ou des quadrangles.
"""),

}

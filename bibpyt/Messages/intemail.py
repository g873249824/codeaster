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






    35: _("""
Utilisation de MODI_MAILLAGE / ABSC_CURV :
  Il existait déjà une carte pour les abscisses curviligne dans le
  maillage. Celle-ci sera écrasée.
 """),

    36: _("""
Utilisation de MODI_MAILLAGE / ABSC_CURV :
  L'ensemble des segments ne forme pas une ligne ouverte.
  Le noeud %(k1)s appartient à plus de deux segments.
 """),

    37: _("""
Utilisation de MODI_MAILLAGE / ABSC_CURV :
  L'ensemble des segments ne forme pas une ligne ouverte.
  Il n'y a pas deux extrémités. Il y en a %(i1)d.
 """),

    38: _("""
Utilisation de MODI_MAILLAGE / ABSC_CURV :
  L'ensemble des segments n'a pas pour extrémité le noeud "origine".
 """),

}

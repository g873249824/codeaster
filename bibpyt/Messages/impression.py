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

    1 : _("""
 Il y a trop de colonnes actives (%(i1)d colonnes).
"""),

    2 : _("""
 Il y a trop de colonnes à afficher dans le tableau de convergence.
 La largeur maximale affichable est de 256 caractères, donc 14 colonnes au maximum.
 Or vous avez <%(i1)d> caractères !
 Si vous avez des colonnes SUIVI_DDL, supprimez en.
 Vous pouvez éventuellement désactiver INFO_RESIDU ou INFO_TEMPS.
"""),

    3 : _("""
 Il y a trop de colonnes de type SUIVI_DDL (%(i1)d colonnes).
"""),


}

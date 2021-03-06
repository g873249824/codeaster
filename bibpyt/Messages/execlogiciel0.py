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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {
    1 : _("""
Format SALOME, l'argument 1 doit être le nom du fichier MED produit
par le script SALOME. Les autres arguments ne sont pas utilisés.
"""),

    2 : _("""
On ne sait pas traiter le format %(k1)s
"""),

    3 : _("""
Code retour incorrect (MAXI %(i1)d) : %(i2)d

"""),

    6 : _("""
Le fichier %(k1)s n'existe pas.
"""),

    8 : _("""
 Commande :
   %(k1)s
"""),

    9 : _("""
----- Sortie standard (stdout) ---------------------------------------------------
%(k1)s
----- fin stdout -----------------------------------------------------------------
"""),

    10 : _("""
----- Sortie erreur standard (stderr) --------------------------------------------
%(k1)s
----- fin stderr -----------------------------------------------------------------
"""),

    11 : _("""
 Code retour = %(i2)d      (maximum toléré : %(i1)d)
"""),


}

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

# person_in_charge: romeo.fernandes at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


PERM_MAC3COEUR = MACRO(nom="PERM_MAC3COEUR",
                       op=OPS("Mac3coeur.perm_mac3coeur_ops.perm_mac3coeur_ops"),
                       sd_prod=evol_noli,

         TYPE_COEUR_N   = SIMP(statut='o',typ='TXM',into=("MONO","MONO_FROID","TEST","900","1300","N4","LIGNE900","LIGNE1300","LIGNEN4")),
         TYPE_COEUR_NP1 = SIMP(statut='o',typ='TXM',into=("MONO","MONO_FROID","TEST","900","1300","N4","LIGNE900","LIGNE1300","LIGNEN4")),
         TABLE_N      = SIMP(statut='o',typ=table_sdaster,max='**'),         # TABLE INITIALE DES DAMAC A L INSTANT N
         RESU_N       = SIMP(statut='o',typ=evol_noli,max='**'),             # RESULTAT A L INSTANT N A PERMUTER
         TABLE_NP1    = SIMP(statut='o',typ=table_sdaster),         # TABLE INITIALE DES DAMAC A L INSTANT N+1
         MAILLAGE_NP1 = SIMP(statut='o',typ=maillage_sdaster),);    # MAILLAGE A L INSTANT N+1

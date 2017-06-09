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

# person_in_charge: mathieu.courtois at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def formule_prod(self, VALE, VALE_C, **args):
    if VALE != None:
        return formule
    elif VALE_C != None:
        return formule_c

FORMULE=FORM(nom="FORMULE",
             op_init=ops.build_formule,
             op=-5,
             sd_prod=formule_prod,
             fr=tr("Définit une formule réelle ou complexe à partir de son expression mathématique"),
    regles = (UN_PARMI('VALE', 'VALE_C',),),
    VALE     = SIMP(statut='f', typ='TXM'),
    VALE_C   = SIMP(statut='f', typ='TXM'),
    NOM_PARA = SIMP(statut='o', typ='TXM', max='**'),
)

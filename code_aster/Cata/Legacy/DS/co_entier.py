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

import aster
from code_aster.Cata.Syntax import ASSD


class entier(ASSD):
    cata_sdj = "SD.AsBase"

    def __init__(self, valeur=None, **args):
        ASSD.__init__(self, **args)
        self.valeur = valeur

    def __adapt__(self, validator):
        if validator.name == "list":
            # validateur liste,cardinalité
            return (self, )
        elif validator.name == "type":
            # validateur type
            return validator.adapt(self.valeur or 0)
        else:
            # validateur into et valid
            return self

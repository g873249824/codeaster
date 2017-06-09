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


from Noyau import N_JDC
from Validation import V_JDC
from Build import B_JDC
from Execution import E_JDC


class JDC(E_JDC.JDC, B_JDC.JDC, V_JDC.JDC, N_JDC.JDC):

    def __init__(self, *pos, **args):
        N_JDC.JDC.__init__(self, *pos, **args)
        V_JDC.JDC.__init__(self)
        B_JDC.JDC.__init__(self)
        E_JDC.JDC.__init__(self)

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

# person_in_charge: mickael.abbas at edf.fr
from code_aster.Cata.Syntax import FACT, SIMP, EXCLUS
from code_aster.Cata.DataStructure import listr8_sdaster, list_inst


def C_INCREMENT(TYPE_CMD) :   #COMMUN#
#
    assert TYPE_CMD in ('THERMIQUE','MECANIQUE',)
    kwargs = {}
    statut_liste_inst = ' '

# La liste d'instants est facultative en thermique et obligatoire en mecanique

    if TYPE_CMD in ('THERMIQUE'):
      statut_liste_inst = 'f'
    elif TYPE_CMD in ('MECANIQUE'):
      statut_liste_inst = 'o'

    kwargs['LIST_INST']         =SIMP(statut=statut_liste_inst,typ=(listr8_sdaster,list_inst))
    kwargs['NUME_INST_INIT']    =SIMP(statut='f',typ='I')
    kwargs['INST_INIT']         =SIMP(statut='f',typ='R')
    kwargs['NUME_INST_FIN']     =SIMP(statut='f',typ='I')
    kwargs['INST_FIN']          =SIMP(statut='f',typ='R')
    kwargs['PRECISION']         =SIMP(statut='f',typ='R',defaut=1.0E-6 )

    mcfact = FACT(statut=statut_liste_inst,
                  regles=(EXCLUS('NUME_INST_INIT','INST_INIT'),
                            EXCLUS('NUME_INST_FIN','INST_FIN'),),
                  **kwargs)

    return mcfact

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

# person_in_charge: jacques.pellet at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


ASSE_VECTEUR=OPER(nom="ASSE_VECTEUR",op=13,sd_prod=cham_no_sdaster,
                  fr=tr("Construire un champ aux noeuds par assemblage de vecteurs élémentaires"),reentrant='n',
         VECT_ELEM       =SIMP(statut='o',typ=vect_elem,max='**'),
         NUME_DDL        =SIMP(statut='o',typ=nume_ddl_sdaster ),
         INFO            =SIMP(statut='f',typ='I',into=(1,2,) ),
)  ;

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


def asse_matrice_prod(MATR_ELEM,**args):
  if AsType(MATR_ELEM) == matr_elem_depl_r : return matr_asse_depl_r
  if AsType(MATR_ELEM) == matr_elem_depl_c : return matr_asse_depl_c
  if AsType(MATR_ELEM) == matr_elem_temp_r : return matr_asse_temp_r
  if AsType(MATR_ELEM) == matr_elem_pres_c : return matr_asse_pres_c
  raise AsException("type de concept resultat non prevu")

ASSE_MATRICE=OPER(nom="ASSE_MATRICE",op=12,sd_prod=asse_matrice_prod,
                  fr=tr("Construction d'une matrice assemblée"),reentrant='n',
         MATR_ELEM       =SIMP(statut='o',
                               typ=(matr_elem_depl_r,matr_elem_depl_c,matr_elem_temp_r,matr_elem_pres_c) ),
         NUME_DDL        =SIMP(statut='o',typ=nume_ddl_sdaster),
         SYME            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
         CHAR_CINE       =SIMP(statut='f',typ=(char_cine_meca,char_cine_ther,char_cine_acou) ),
         INFO            =SIMP(statut='f',typ='I',into=(1,2) ),
)  ;

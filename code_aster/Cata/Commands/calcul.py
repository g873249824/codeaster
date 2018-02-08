# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


CALCUL=OPER(nom="CALCUL",op=26,sd_prod=table_container,
            reentrant='f:TABLE',
            fr=tr("Calculer des objets élémentaires comme une matrice tangente, intégrer une loi de comportement, etc..."),
     reuse=SIMP(statut='c', typ=CO),
     OPTION          =SIMP(statut='o',typ='TXM',validators=NoRepeat(),max='**',defaut="COMPORTEMENT",
                           into=( "COMPORTEMENT","MATR_TANG_ELEM","FORC_INTE_ELEM","FORC_NODA_ELEM","FORC_VARC_ELEM_M","FORC_VARC_ELEM_P"),),
     MODELE          =SIMP(statut='o',typ=modele_sdaster),
     CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
     CHAM_MATER      =SIMP(statut='o',typ=cham_mater),
     TABLE           =SIMP(statut='f',typ=table_container),
     EXCIT           =FACT(statut='f',max='**',
       CHARGE          =SIMP(statut='o',typ=(char_meca,char_cine_meca)),
       FONC_MULT       =SIMP(statut='f',typ=(fonction_sdaster,nappe_sdaster,formule)),
       TYPE_CHARGE     =SIMP(statut='f',typ='TXM',defaut="FIXE_CSTE",
                                 into=("FIXE_CSTE",)),

     ),
     DEPL            =SIMP(statut='f',typ=cham_no_sdaster ),
     INCR_DEPL       =SIMP(statut='f',typ=cham_no_sdaster ),
     SIGM            =SIMP(statut='f',typ=cham_elem),
     VARI            =SIMP(statut='f',typ=cham_elem),
     INCREMENT       =FACT(statut='o',
          LIST_INST       =SIMP(statut='o',typ=listr8_sdaster),
          NUME_ORDRE      =SIMP(statut='o',typ='I'),),
     COMPORTEMENT       =C_COMPORTEMENT('CALCUL'),
     MODE_FOURIER    =SIMP(statut='f',typ='I' ),
     INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
) ;

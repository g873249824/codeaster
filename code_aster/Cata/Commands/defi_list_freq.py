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

# person_in_charge: harinaivo.andriambololona at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


DEFI_LIST_FREQ=MACRO(nom="DEFI_LIST_FREQ",
                    op=OPS('Macro.defi_list_freq_ops.defi_list_freq_ops'),
                    sd_prod=listr8_sdaster,
                    fr=tr("Définir une liste de fréquences strictement croissante"),
                    reentrant='n',
         regles=(UN_PARMI('VALE','DEBUT',),
                 EXCLUS('VALE','INTERVALLE'),
                 ENSEMBLE('DEBUT','INTERVALLE')),
         VALE            =SIMP(statut='f',typ='R',max='**'),
         DEBUT           =SIMP(statut='f',typ='R'),
         INTERVALLE      =FACT(statut='f',max='**',
           regles=(UN_PARMI('NOMBRE','PAS'),),
           JUSQU_A         =SIMP(statut='o',typ='R'),
           NOMBRE          =SIMP(statut='f',typ='I'),
           PAS             =SIMP(statut='f',typ='R'),
         ),
         RAFFINEMENT      =FACT(statut='f',
           LIST_RAFFINE    =SIMP(statut='o',typ='R',max='**'),
           NB_POINTS       =SIMP(statut='f',typ='I',defaut=5),
           PAS_MINI        =SIMP(statut='f',typ='R',defaut=0.001),
           CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU","LARGEUR_3DB")),
              b_crit_rela_abs=BLOC(condition="""(equal_to("CRITERE", 'RELATIF') or equal_to("CRITERE", 'ABSOLU'))""",
                 DISPERSION      =SIMP(statut='f',typ='R',defaut=0.01),),
              b_crit_larg=BLOC(condition="""(equal_to("CRITERE", 'LARGEUR_3DB'))""",
                    regles = UN_PARMI('AMOR_REDUIT','LIST_AMOR'),
                    AMOR_REDUIT     =SIMP(statut='f',typ='R',max='**'),
                    LIST_AMOR       =SIMP(statut='f',typ=listr8_sdaster ),),
             ),
         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2)),
         TITRE           =SIMP(statut='f',typ='TXM'),
)  ;

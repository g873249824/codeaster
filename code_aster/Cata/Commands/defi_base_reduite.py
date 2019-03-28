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

# person_in_charge: mickael.abbas at edf.fr
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


DEFI_BASE_REDUITE=OPER(
    nom="DEFI_BASE_REDUITE",op=53,
    sd_prod=mode_empi,
    reentrant='f:BASE',
    reuse=SIMP(statut='c', typ=CO),
    BASE = SIMP(statut='f',typ=mode_empi,
                fr=tr("Objet qui sera enrichi des nouveaux instants calculés")),

    OPERATION = SIMP(statut='f',typ='TXM',defaut="POD",into=("POD","POD_INCR",'GLOUTON','TRONCATURE',)),

    b_pod  = BLOC(condition ="""(equal_to("OPERATION", 'POD'))""",
        RESULTAT         =SIMP(statut='o',typ=resultat_sdaster),
        b_thermique      =BLOC(condition = """is_type("RESULTAT") == evol_ther""",
                               NOM_CHAM  = SIMP(statut='o',typ='TXM',max=1,into=('TEMP','FLUX_NOEU')),
                          ),
        b_mecanique      =BLOC(condition = """is_type("RESULTAT") == evol_noli""",
                               NOM_CHAM  = SIMP(statut='o',typ='TXM',max=1,into=('DEPL','SIEF_NOEU')),
                          ),
        TYPE_BASE        =SIMP(statut='f',typ='TXM',defaut="3D",into=("3D","LINEIQUE")),
        b_lineique       =BLOC(condition ="""(equal_to("TYPE_BASE", 'LINEIQUE'))""",
                               AXE       = SIMP(statut='o',typ='TXM',max=1,into=('OX','OY','OZ')),
                               SECTION   = SIMP(statut='o',typ=grno ,max=1)),
        TOLE_SVD         =SIMP(statut='f',typ='R',defaut=1.E-6),
        NB_MODE          =SIMP(statut='f',typ='I'),
        MODELE           =SIMP(statut='f',typ=modele_sdaster),
    ),

    b_incr = BLOC(condition ="""(equal_to("OPERATION", 'POD_INCR'))""",
        RESULTAT         =SIMP(statut='o',typ=resultat_sdaster),
        b_thermique      =BLOC(condition = """is_type("RESULTAT") == evol_ther""",
                               NOM_CHAM  = SIMP(statut='o',typ='TXM',max=1,into=('TEMP','FLUX_NOEU')),
                          ),
        b_mecanique      =BLOC(condition = """is_type("RESULTAT") == evol_noli""",
                               NOM_CHAM  = SIMP(statut='o',typ='TXM',max=1,into=('DEPL','SIEF_NOEU')),
                          ),
        TYPE_BASE        =SIMP(statut='f',typ='TXM',defaut="3D",into=("3D","LINEIQUE")),
        b_lineique       =BLOC(condition ="""(equal_to("TYPE_BASE", 'LINEIQUE'))""",
                               AXE       = SIMP(statut='o',typ='TXM',max=1,into=('OX','OY','OZ')),
                               SECTION   = SIMP(statut='o',typ=grno ,max=1)),
        TOLE             =SIMP(statut='f',typ='R',defaut=1.E-10),
        TOLE_SVD         =SIMP(statut='f',typ='R',defaut=1.E-6),
        NB_MODE          =SIMP(statut='f',typ='I'),
        MODELE           =SIMP(statut='f',typ=modele_sdaster),
        TABL_COOR_REDUIT =SIMP(statut='f',typ=table_sdaster),
    ),

    b_type_rb       =BLOC(condition ="""(equal_to("OPERATION", 'GLOUTON'))""",
        NB_VARI_COEF    =SIMP(statut='o',typ='I', max = 1, val_min = 1),
        TYPE_VARI_COEF  =SIMP(statut='f',typ='TXM',defaut="DIRECT",into=("DIRECT",)),
        TYPE_BASE       =SIMP(statut='f',typ='TXM',defaut="STANDARD",into=("IFS_STAB","STANDARD")),
        b_direct       =BLOC(condition = """(equal_to("TYPE_VARI_COEF", 'DIRECT'))""",
            VARI_PARA   = FACT( statut='f', min= 1, max=5,
                NOM_PARA        =SIMP(statut='o',typ='TXM',into=C_PARA_FONCTION(), max=1 ),
                VALE_PARA       =SIMP(statut='o',typ='R', max = '**'),
                VALE_INIT       =SIMP(statut='o',typ='R', max = 1),
                              ),
        ),
        MATR_ASSE   = FACT( statut='f', min= 1, max=8,
            regles=(UN_PARMI('COEF_R','COEF_C','FONC_R','FONC_C' ),),
            MATRICE         =SIMP(statut='o',typ=(matr_asse_depl_r,matr_asse_depl_c,
                               matr_asse_temp_r,matr_asse_temp_c,
                               matr_asse_pres_r,matr_asse_pres_c, ) ),
            COEF_R          =SIMP(statut='f',typ='R', max = 1),
            COEF_C          =SIMP(statut='f',typ='C', max = 1),
            FONC_R          =SIMP(statut='f',typ=(fonction_sdaster, formule), max = 1),
            FONC_C          =SIMP(statut='f',typ=(fonction_c, formule_c), max = 1),
                          ),
        regles=(UN_PARMI('COEF_R','COEF_C',),),
        VECTEUR         =SIMP(statut='f',typ=cham_no_sdaster),
        COEF_C          =SIMP(statut='f',typ='C', max = 1),
        COEF_R          =SIMP(statut='f',typ='R', max = 1),
        SOLVEUR         =C_SOLVEUR('DYNA_LINE_HARM'),
        NB_MODE         =SIMP(statut='o',typ='I', max = 1, val_min = 1),
        TOLE_GLOUTON    =SIMP(statut='f',typ='R', defaut=1.E-10),
    ),

    b_tronca       =BLOC(condition ="""(equal_to("OPERATION", 'TRONCATURE'))""",
        MODELE_REDUIT = SIMP(statut='o',typ=modele_sdaster),
    ),

    INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
    TITRE           =SIMP(statut='f',typ='TXM'),
) ;

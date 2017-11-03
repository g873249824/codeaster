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
# person_in_charge: hassan.berro at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *


def C_COMPORTEMENT_DYNA(COMMAND=None) : #COMMUN#
    
    assert COMMAND in ('DYNA_VIBRA', 'DYNA_LINE', None)
    
    mcfact = FACT(statut='f',max='**',
            RELATION    =     SIMP(statut='o', typ='TXM', into=('DIS_CHOC', 'ROTOR_FISS', 'PALIER_EDYOS', 'FLAMBAGE', 'ANTI_SISM',
                                                                'DIS_VISC', 'DIS_ECRO_TRAC', 'RELA_EFFO_DEPL', 'RELA_EFFO_VITE',
                                                                'YACS')),
#           C.2.1 Chocs
            b_choc      =     BLOC(condition="""equal_to("RELATION", 'DIS_CHOC')""",
                                   regles=(UN_PARMI('MAILLE','GROUP_MA','NOEUD_1','GROUP_NO_1'),
                                           EXCLUS('NOEUD_2','GROUP_NO_2'),
                                           PRESENT_ABSENT('GROUP_MA','NOEUD_2','GROUP_NO_2'),
                                           PRESENT_ABSENT('MAILLE','NOEUD_2','GROUP_NO_2'),),
            INTITULE    =         SIMP(statut='f',typ='TXM'),
            GROUP_MA    =         SIMP(statut='f',typ=grma,max='**'),
            MAILLE      =         SIMP(statut='c',typ=ma,max='**'),
            NOEUD_1     =         SIMP(statut='c',typ=no),
            NOEUD_2     =         SIMP(statut='c',typ=no),
            GROUP_NO_1  =         SIMP(statut='f',typ=grno),
            GROUP_NO_2  =         SIMP(statut='f',typ=grno),
            OBSTACLE    =         SIMP(statut='o',typ=table_fonction),
            ORIG_OBST   =         SIMP(statut='f',typ='R',min=3,max=3),
            NORM_OBST   =         SIMP(statut='o',typ='R',min=3,max=3),
            ANGL_VRIL   =         SIMP(statut='f',typ='R'),
            JEU         =         SIMP(statut='f',typ='R',defaut= 1.),
            DIST_1      =         SIMP(statut='f',typ='R',val_min=0.E+0),
            DIST_2      =         SIMP(statut='f',typ='R',val_min=0.E+0),
            SOUS_STRUC_1=         SIMP(statut='f',typ='TXM'),
            SOUS_STRUC_2=         SIMP(statut='f',typ='TXM'),
            REPERE      =         SIMP(statut='f',typ='TXM',defaut="GLOBAL"),
            RIGI_NOR    =         SIMP(statut='o',typ='R'),
            AMOR_NOR    =         SIMP(statut='f',typ='R',defaut= 0.E+0),
            RIGI_TAN    =         SIMP(statut='f',typ='R',defaut= 0.E+0),
            AMOR_TAN    =         SIMP(statut='f',typ='R'),
            FROTTEMENT  =         SIMP(statut='f',typ='TXM',defaut="NON",into=("NON","COULOMB","COULOMB_STAT_DYNA"),),
            b_coulomb   =         BLOC(condition="""equal_to("FROTTEMENT", 'COULOMB')""",
            COULOMB     =             SIMP(statut='o',typ='R'),
            UNIDIRECTIONNEL =         SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON"),),),
            b_c_st_dyna =         BLOC(condition="""equal_to("FROTTEMENT", 'COULOMB_STAT_DYNA')""",
            COULOMB_STAT=             SIMP(statut='o',typ='R'),
            COULOMB_DYNA=             SIMP(statut='o',typ='R'),
            UNIDIRECTIONNEL =         SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON"),),),
        ), # end b_choc
#       C.2.2 Cracked rotor
        b_rotor         = BLOC(condition="""equal_to("RELATION", 'ROTOR_FISS')""",
                               regles=(UN_PARMI('NOEUD_D','GROUP_NO_D'),
                                       EXCLUS('NOEUD_G','GROUP_NO_G'),
                                       PRESENT_PRESENT('NOEUD_D','NOEUD_G'),
                                       PRESENT_PRESENT('GROUP_NO_D','GROUP_NO_G',),),
            ANGL_INIT   =     SIMP(statut='o',typ='R',defaut=0.E0),
            ANGL_ROTA   =     SIMP(statut='f',typ=(fonction_sdaster,formule),),
            NOEUD_G     =     SIMP(statut='c',typ=no),
            NOEUD_D     =     SIMP(statut='c',typ=no),
            GROUP_NO_G  =     SIMP(statut='f',typ=grno),
            GROUP_NO_D  =     SIMP(statut='f',typ=grno),
            K_PHI       =     SIMP(statut='o',typ=(fonction_sdaster,formule),),
            DK_DPHI     =     SIMP(statut='o',typ=(fonction_sdaster,formule),),
        ), # end b_rotor
#       C.2.3 Code coupling with EDYOS
        b_lubrication   = BLOC(condition="""equal_to("RELATION", 'PALIER_EDYOS')""",
                               regles=(PRESENT_ABSENT('UNITE','GROUP_NO'),
                                       PRESENT_ABSENT('UNITE','TYPE_EDYOS'),
                                       EXCLUS('GROUP_NO','NOEUD'),),
            UNITE       =     SIMP(statut='f',typ=UnitType(), inout='in'),
            GROUP_NO    =     SIMP(statut='f',typ=grno,validators=NoRepeat(),max='**'),
            NOEUD       =     SIMP(statut='c',typ=no),
            PAS_STOC_ED =     SIMP(statut='f',typ='R'),
            TYPE_EDYOS  =     SIMP(statut='f',typ='TXM', into=("PAPANL", "PAFINL","PACONL", "PAHYNL"),),
            ),

#       C.2.3.2 Code coupling (Generic)
        b_yacs_coupling = BLOC(condition="""equal_to("RELATION", 'YACS')""",
                               regles=(
                                        UN_PARMI('NOEUD','GROUP_NO'),
                                      ),
            NOEUD       =     SIMP(statut='c',typ=no),
            GROUP_NO    =     SIMP(statut='f',typ=grno),
            TYPE_CHAM   =     SIMP(statut='f',typ='TXM', into=("DEPL","VITE","FORCE"),),
            NOM_CMP     =     SIMP(statut='f',typ='TXM', max='**' ),
            PORT_YACS   =     SIMP(statut='f',typ='TXM', validators=NoRepeat()),
            ),


#       C.2.4 Buckling
        b_buckling      = BLOC(condition="""equal_to("RELATION", 'FLAMBAGE')""",
                               regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'),
                                       EXCLUS('NOEUD_2','GROUP_NO_2'),),
            INTITULE    =         SIMP(statut='f',typ='TXM'),
            NOEUD_1     =     SIMP(statut='c',typ=no),
            NOEUD_2     =     SIMP(statut='c',typ=no),
            GROUP_NO_1  =     SIMP(statut='f',typ=grno),
            GROUP_NO_2  =     SIMP(statut='f',typ=grno),
            OBSTACLE    =     SIMP(statut='o',typ=table_fonction),
            ORIG_OBST   =     SIMP(statut='f',typ='R',max='**'),
            NORM_OBST   =     SIMP(statut='o',typ='R',max='**'),
            ANGL_VRIL   =     SIMP(statut='f',typ='R'),
            JEU         =     SIMP(statut='f',typ='R',defaut= 1.),
            DIST_1      =     SIMP(statut='f',typ='R'),
            DIST_2      =     SIMP(statut='f',typ='R'),
            REPERE      =     SIMP(statut='f',typ='TXM',defaut="GLOBAL"),
            RIGI_NOR    =     SIMP(statut='o',typ='R'),
            FNOR_CRIT   =     SIMP(statut='f',typ='R'),
            FNOR_POST_FL=     SIMP(statut='f',typ='R'),
            RIGI_NOR_POST_FL= SIMP(statut='f',typ='R'),
        ), # end b_buckling

#       C.2.5 Anti-sismic disposition non linearity
        b_antisism      = BLOC(condition="""equal_to("RELATION", 'ANTI_SISM')""",
                               regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'),
                                       UN_PARMI('NOEUD_2','GROUP_NO_2'),),
            NOEUD_1     =     SIMP(statut='c',typ=no),
            NOEUD_2     =     SIMP(statut='c',typ=no),
            GROUP_NO_1  =     SIMP(statut='f',typ=grno),
            GROUP_NO_2  =     SIMP(statut='f',typ=grno),
            RIGI_K1     =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            RIGI_K2     =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            SEUIL_FX    =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            C           =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            PUIS_ALPHA  =     SIMP(statut='f',typ='R',defaut= 0.E+0),
            DX_MAX      =     SIMP(statut='f',typ='R',defaut= 1.),
        ), # end b_antisism
#       C.2.6.1 Discrete viscous coupling, generalized Zener
        b_disvisc       = BLOC(condition="""equal_to("RELATION", 'DIS_VISC')""",
                               regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'),
                                       UN_PARMI('NOEUD_2','GROUP_NO_2'),
                                       UN_PARMI('K1','UNSUR_K1'), UN_PARMI('K2','UNSUR_K2'), UN_PARMI('K3','UNSUR_K3'),),
            NOEUD_1     =     SIMP(statut='c',typ=no),
            NOEUD_2     =     SIMP(statut='c',typ=no),
            GROUP_NO_1  =     SIMP(statut='f',typ=grno),
            GROUP_NO_2  =     SIMP(statut='f',typ=grno),
            K1          =     SIMP(statut='f',typ='R',val_min = 1.0E-08, fr=tr("Raideur en série avec les 2 autres branches."),),
            K2          =     SIMP(statut='f',typ='R',val_min = 0.0,     fr=tr("Raideur en parallèle de la branche visqueuse."),),
            K3          =     SIMP(statut='f',typ='R',val_min = 1.0E-08, fr=tr("Raideur dans la branche visqueuse."),),
            UNSUR_K1    =     SIMP(statut='f',typ='R',val_min = 0.0,     fr=tr("Souplesse en série avec les 2 autres branches."),),
            UNSUR_K2    =     SIMP(statut='f',typ='R',val_min = 1.0E-08, fr=tr("Souplesse en parallèle de la branche visqueuse."),),
            UNSUR_K3    =     SIMP(statut='f',typ='R',val_min = 0.0,     fr=tr("Souplesse dans la branche visqueuse."),),
            C           =     SIMP(statut='o',typ='R',val_min = 1.0E-08, fr=tr("'Raideur' de la partie visqueuse."),),
            PUIS_ALPHA  =     SIMP(statut='o',typ='R',val_min = 1.0E-08, fr=tr("Puissance de la loi visqueuse ]0.0, 1.0]."),
                                   val_max=1.0, defaut=0.5,),
            ITER_INTE_MAXI=   SIMP(statut='o',typ='I',defaut= 20),
            RESI_INTE_RELA=   SIMP(statut='o',typ='R',defaut= 1.0E-6),
        ), # end b_disvisc
#       C.2.6.2 Discrete nonlinear behavior
        b_disecro       = BLOC(condition="""equal_to("RELATION", 'DIS_ECRO_TRAC')""",
                               regles=(UN_PARMI('NOEUD_1','GROUP_NO_1'),
                                       UN_PARMI('NOEUD_2','GROUP_NO_2'),),
            NOEUD_1     =   SIMP(statut='c',typ=no),
            NOEUD_2     =   SIMP(statut='c',typ=no),
            GROUP_NO_1  =   SIMP(statut='f',typ=grno),
            GROUP_NO_2  =   SIMP(statut='f',typ=grno),
            FX          =   SIMP(statut='o',typ=(fonction_sdaster), fr=tr("Comportement en fonction du déplacement relatif."),),
            ITER_INTE_MAXI = SIMP(statut='o',typ='I',defaut= 20),
            RESI_INTE_RELA = SIMP(statut='o',typ='R',defaut= 1.0E-6),
        ), # end b_disecro
#       C.2.7 Force displacement relationship non linearity
        b_refx          = BLOC(condition="""equal_to("RELATION", 'RELA_EFFO_DEPL')""",
                               regles=(UN_PARMI('NOEUD','GROUP_NO'),),
            NOEUD       =     SIMP(statut='c',typ=no, max=1),
            GROUP_NO    =     SIMP(statut='f',typ=grno, max=1),
            SOUS_STRUC  =     SIMP(statut='f',typ='TXM'),
            NOM_CMP     =     SIMP(statut='f',typ='TXM'),
            FONCTION    =     SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule),),
        ), # end b_refx
#       C.2.8 Force velocity relationship non linearity
        b_refv          = BLOC(condition="""equal_to("RELATION", 'RELA_EFFO_VITE')""",
                               regles=(UN_PARMI('NOEUD','GROUP_NO'),),
            NOEUD       =     SIMP(statut='c',typ=no, max=1),
            GROUP_NO    =     SIMP(statut='f',typ=grno, max=1),
            SOUS_STRUC  =     SIMP(statut='f',typ='TXM'),
            NOM_CMP     =     SIMP(statut='f',typ='TXM'),
            FONCTION    =     SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster,formule),),
        ), # end b_refv
    ) # end fkw_comportement
    
    return mcfact

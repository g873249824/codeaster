! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

! sd_nl data structure : Parameters <-> integer definitions
! -------------------------------------------------------------------------
!
#define _NL_NBPAR 79

#define _ANG_INIT 1
#define _ANG_ROTA 2
#define _ANTISISMIC_C 3
#define _ANTISISMIC_DX_MAX 4
#define _ANTISISMIC_K1 5
#define _ANTISISMIC_K2 6
#define _ANTISISMIC_PUIS_ALPHA 7
#define _ANTISISMIC_SEUIL_FX 8
#define _BUCKLING_LIMIT_FORCE 9
#define _BUCKLING_POST_PALIER_FORCE 10
#define _BUCKLING_DEF 11
#define _CMP_NAME 12
#define _COOR_NO1 13
#define _COOR_NO2 14
#define _COOR_ORIGIN_OBSTACLE 15
#define _DAMP_NORMAL 16
#define _DAMP_TANGENTIAL 17
#define _DISC_ISOT_FX0DX0 18

#define _DIST_NO1 20
#define _DIST_NO2 21
#define _DISVISC_A 22
#define _DISVISC_C 23
#define _DISVISC_K1 24
#define _DISVISC_K2 25
#define _DISVISC_K3 26
#define _FRIC_DYNAMIC 27
#define _FRIC_STATIC 28
#define _FRIC_UNIDIR 29
#define _FV_FONCT 30
#define _FX_FONCT 31
#define _F_TAN_WK 32
#define _F_TOT_WK 33
#define _GAP 34
#define _INTERNAL_VARS 35
#define _INTERNAL_VARS_INDEX 36
#define _MAX_INTE 37
#define _MAX_LEVEL 38
#define _MESH_1 39
#define _MESH_2 40
#define _MODAL_DEPL_NO1 41
#define _MODAL_DEPL_NO2 42
#define _NB_ANTSI 43
#define _NB_CHOC 44
#define _NB_DIS_ECRO_TRAC 45
#define _NB_DIS_VISC 46
#define _NB_FLAMB 47
#define _NB_PALIE 48
#define _NB_REL_FV 49
#define _NB_REL_FX 50
#define _NB_R_FIS 51
#define _NL_FUNC_DEF 52
#define _NL_TITLE 53
#define _NL_TYPE 54
#define _NO1_NAME 55
#define _NO2_NAME 56
#define _NORMAL_VECTOR 57
#define _NUMDDL_1 58
#define _NUMDDL_2 59
#define _OBST_TYP 60
#define _PSI_DELT_NO1 61
#define _PSI_DELT_NO2 62
#define _RES_INTE 63
#define _RIGI_TANGENTIAL 64
#define _ROTR_DFK 65
#define _ROTR_FK 66
#define _SIGN_DYZ 67
#define _SINCOS_ANGLE_A 68
#define _SINCOS_ANGLE_B 69
#define _SINCOS_ANGLE_G 70
#define _SS1_NAME 71
#define _SS2_NAME 72
#define _STIF_NORMAL 73
#define _FEXT_MPI 74
#define _BUCKLING_DEF_TOT_0 75
#define _BUCKLING_DEF_PLA 76
#define _BUCKLING_RIGI_NOR 77
#define _BUCKLING_DEF_TOT 78
#define _BUCKLING_AMOR 79



#define _YACS_NOEUD 89
#define _YACS_CHAM 90
#define _YACS_CMP 91
#define _YACS_DIR 92
#define _YACS_ID 93
#define _YACS_IDDL 94
#define _YACS_N_DEPL 95
#define _YACS_N_VIT 96
#define _YACS_N_FORCE 97
#define _YACS_VEC_DEPL 98
#define _YACS_VEC_VIT 99
#define _YACS_VEC_FORCE 100
#define _YACS_INITIALIZED 101
#define _YACS_PORT_NAME 102
#define _NUM_PALIER 103





#define _NL_NB_TYPES     10

#define NL_CHOC            1
#define NL_BUCKLING        2
#define NL_ANTI_SISMIC     3
#define NL_DIS_VISC        4
#define NL_DIS_ECRO_TRAC   5
#define NL_CRACKED_ROTOR   6
#define NL_LUBRICATION     7
#define NL_FX_RELATIONSHIP 8
#define NL_FV_RELATIONSHIP 9
#define NL_YACS            10


#define NBVARINT_CHOC 20
#define NBVARINT_FLAM 12
#define NBVARINT_ANTS 8
#define NBVARINT_DVIS 11
#define NBVARINT_DECR 20
#define NBVARINT_ROTF 3
#define NBVARINT_YACS 1
#define NBVARINT_FXRL 3
#define NBVARINT_FVRL 3
#define NBVARINT_LUB  1

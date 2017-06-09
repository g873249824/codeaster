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

# person_in_charge: etienne.grimal at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'ENDO_PORO_BETON',
    doc            =   """Loi RAG pour le beton"""      ,
    num_lc         = 166,
    nb_vari        = 116,
    nom_vari       = ('HYD0','SSG1','SSG2','SSG3','SSG4',
        'SSG5','SSG6','EPG1','EPG2','EPG3',
        'EPG4','EPG5','EPG6','DG1','DG2',
        'DG3','PWAT','PGEL','SSW1','SSW2',
        'SSW3','SSW4','SSW5','SSW6','DW1',
        'DW2','DW3','DTH','PAS0','SES1',
        'SES2','SES3','SES4','SES5','SES6',
        'SSP1','SSP2','SSP3','SSP4','SSP5',
        'SSP6','DTP1','DTP2','DTP3','SSL1',
        'SSL2','SSL3','SSL4','SSL5','SSL6',
        'DTL1','DTL2','DTL3','SPL1','SPL2',
        'SPL3','SPL4','SPL5','SPL6','WLM1',
        'WLM2','WLM3','WLM4','WLM5','WLM6',
        'WL1','WL2','WL3','SSC','DC',
        'DV','XNL','MSRD','EVE1','EVE2',
        'EVE3','EVE4','EVE5','EVE6','SVE1',
        'SVE2','SVE3','SVE4','SVE5','SVE6',
        'XRTW','TAUW','VVE1','VVE2','VVE3',
        'VVE4','VVE5','VVE6','VMA1','VMA2',
        'VMA3','VMA4','VMA5','VMA6','ERRM',
        'XGFW','TOEQ','IRTW','TEQU','TORF',
        'XRTT','VT00','VT11','VT21','VT31',
        'VT12','VT22','VT32','VT13','VT23',
        'VT33',),
    mc_mater       = ('ELAS','ENDO3D',),
    modelisation   = ('3D',),
    deformation    = ('PETIT','PETIT_REAC',),
    algo_inte      = ('SPECIFIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)

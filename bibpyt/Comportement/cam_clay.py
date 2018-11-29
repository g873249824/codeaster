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

# person_in_charge: sarah.plessis at edf.fr

from .cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'CAM_CLAY',
    lc_type        = ('MECANIQUE',),
    doc            =   """Comportement élastoplastique des sols normalement consolidés (argiles par exemple). cf. R7.01.14
   La partie élastique est non-linéaire. La partie plastique peut être durcissante ou adoucissante.
   Si le modèle CAM_CLAY est utilisé avec la modélisation THM, le mot clé PORO renseigné sous CAM_CLAY et
   sous THM_INIT doit être le même."""              ,
    num_lc         = 22,
    nb_vari        = 7,
    nom_vari       = ('PCR','INDIPLAS','SIGP','SIEQ','EPSPVOL',
        'EPSPEQ','INDIVIDE',),
    mc_mater       = ('ELAS','CAM_CLAY',),
    modelisation   = ('3D','AXIS','D_PLAN','KIT_THM',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON_1D',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)

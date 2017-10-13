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


from cata_comportement import LoiComportementMFront

loi = LoiComportementMFront(
    nom            = 'MonoCrystalDDCC',
    symbol_mfront  = 'astermonocrystalddcc',
    lc_type        = ('MECANIQUE',),
    doc            =   """To complete ..."""          ,
    num_lc         = 58,
    nb_vari        = 0,
    nom_vari       = None,
    mc_mater       = None,
    modelisation   = ('3D',),
    deformation    = ('PETIT',),
    algo_inte      = ('NEWTON',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)

! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
#include "asterf_types.h"
!
interface
    subroutine nonlinLoadCompute(mode       , list_load      ,&
                                 model      , cara_elem      , nume_dof  , list_func_acti,&
                                 ds_material, ds_constitutive, ds_measure,&
                                 time_prev  , time_curr      ,&
                                 hval_incr  , hval_algo      ,&
                                 hval_veelem, hval_veasse    ,&
                                 hhoField_  , prediction_)
!
        use NonLin_Datastructure_type
        use HHO_type
!
        character(len=4), intent(in)            :: mode
        character(len=19), intent(in)           :: list_load
        integer, intent(in)                     :: list_func_acti(*)
        character(len=24), intent(in)           :: model, cara_elem, nume_dof
        type(NL_DS_Material), intent(in)        :: ds_material
        type(NL_DS_Constitutive), intent(in)    :: ds_constitutive
        type(NL_DS_Measure), intent(inout)      :: ds_measure
        real(kind=8), intent(in)                :: time_prev, time_curr
        character(len=19), intent(in)           :: hval_incr(*), hval_algo(*)
        character(len=19), intent(in)           :: hval_veelem(*), hval_veasse(*)
        type(HHO_Field), optional, intent(in)   :: hhoField_
        aster_logical, optional, intent(in)     :: prediction_
    end subroutine nonlinLoadCompute
end interface

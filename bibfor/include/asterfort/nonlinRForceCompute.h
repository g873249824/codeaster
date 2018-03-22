! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
interface
    subroutine nonlinRForceCompute(model      , ds_material , cara_elem, list_load,&
                                   nume_dof   , ds_measure  , vect_lagr,&
                                   hval_veelem, hval_veasse_, cndiri_)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model, cara_elem
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: nume_dof
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19), intent(in) :: vect_lagr
        character(len=19), intent(in) :: hval_veelem(*)
        character(len=19), optional, intent(in) :: hval_veasse_(*)
        character(len=19), optional, intent(in) :: cndiri_
    end subroutine nonlinRForceCompute
end interface

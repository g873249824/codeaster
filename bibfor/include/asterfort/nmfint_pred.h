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
!
interface
    subroutine nmfint_pred(model      , cara_elem      , list_func_acti,&
                           sddyna     , nume_dof       , &
                           ds_material, ds_constitutive, ds_system     , ds_measure,&
                           time_prev  , time_curr      , iter_newt     ,&
                           hval_incr  , hval_algo      , hhoField      ,&
                           ldccvg     , sdnume_)
        use NonLin_Datastructure_type
        use HHO_type 
        character(len=24), intent(in) :: model, cara_elem
        integer, intent(in) :: list_func_acti(*)
        character(len=19), intent(in) :: sddyna
        character(len=24), intent(in) :: nume_dof
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_System), intent(in) :: ds_system
        type(NL_DS_Measure), intent(inout) :: ds_measure
        real(kind=8), intent(in) :: time_prev, time_curr
        integer, intent(in) :: iter_newt
        character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
        type(HHO_Field), intent(in) :: hhoField
        integer, intent(out) :: ldccvg
        character(len=19), optional, intent(in) :: sdnume_
    end subroutine nmfint_pred
end interface

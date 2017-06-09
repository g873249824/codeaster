! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
!
interface
    subroutine diinit(mesh_         , model_     , ds_inout, mate       , cara_elem,&
                      list_func_acti, sddyna     , ds_conv , ds_algopara, solver   ,&
                      ds_contact    , sddisc)
        use NonLin_Datastructure_type
        character(len=*), intent(in) :: mesh_
        character(len=*), intent(in) :: model_
        character(len=19), intent(in) :: sddisc
        character(len=19), intent(in) :: sddyna
        character(len=24), intent(in) :: cara_elem
        character(len=24), intent(in) :: mate
        type(NL_DS_Conv), intent(in) :: ds_conv
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        type(NL_DS_InOut), intent(in) :: ds_inout
        character(len=19), intent(in) :: solver
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer, intent(in) :: list_func_acti(*)
    end subroutine diinit
end interface

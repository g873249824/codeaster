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
interface
    subroutine nmrenu(modelz    , list_func_acti, list_load,&
                      ds_measure, ds_contact    , nume_dof ,&
                      l_renumber)
        use NonLin_Datastructure_type
        character(len=*), intent(in) :: modelz
        integer, intent(in) :: list_func_acti(*)
        character(len=19), intent(in) :: list_load
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=24), intent(inout) :: nume_dof
        aster_logical, intent(out) :: l_renumber
    end subroutine nmrenu
end interface

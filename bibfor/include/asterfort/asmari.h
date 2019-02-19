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
    subroutine asmari(list_func_acti, hval_meelem, ds_system, nume_dof, list_load, ds_algopara,&
                      matr_rigi)
        use NonLin_Datastructure_type        
        integer, intent(in) :: list_func_acti(*)
        character(len=19), intent(in) :: hval_meelem(*)
        type(NL_DS_System), intent(in) :: ds_system
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: list_load
        character(len=19), intent(in) :: matr_rigi
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
    end subroutine asmari
end interface

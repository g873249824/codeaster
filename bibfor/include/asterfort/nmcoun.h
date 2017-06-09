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
    subroutine nmcoun(mesh          , list_func_acti, solver   , nume_dof_ , matr_asse  ,&
                      iter_newt     , time_curr     , hval_incr, hval_algo , hval_veasse,&
                      resi_glob_rela, ds_measure    , ds_contact, ctccvg)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: list_func_acti(*)
        character(len=19), intent(in) :: solver
        character(len=*), intent(in) :: nume_dof_
        character(len=19), intent(in) :: matr_asse
        integer, intent(in) :: iter_newt
        real(kind=8), intent(in) :: time_curr
        character(len=19), intent(in) :: hval_incr(*)
        character(len=19), intent(in) :: hval_algo(*)
        character(len=19), intent(in) :: hval_veasse(*)
        real(kind=8), intent(in) :: resi_glob_rela
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_Contact), intent(inout) :: ds_contact 
        integer, intent(out) :: ctccvg
    end subroutine nmcoun
end interface

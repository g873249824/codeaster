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
    subroutine nmrede(list_func_acti, sddyna     ,&
                      sdnume        , nb_equa    , matass,&
                      ds_material   , ds_contact ,&
                      cnfext        , cnfint     , cndiri, cnsstr,&
                      hval_measse   , hval_incr  ,&
                      r_char_vale   , r_char_indx)
        use NonLin_Datastructure_type
        integer, intent(in) :: list_func_acti(*)
        character(len=19), intent(in) :: sddyna, sdnume
        integer, intent(in) :: nb_equa
        character(len=19), intent(in) :: matass
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19), intent(in) :: cnfext, cnfint, cndiri, cnsstr
        character(len=19), intent(in) :: hval_measse(*)
        character(len=19), intent(in) :: hval_incr(*)
        real(kind=8), intent(out) :: r_char_vale
        integer, intent(out) :: r_char_indx
    end subroutine nmrede
end interface

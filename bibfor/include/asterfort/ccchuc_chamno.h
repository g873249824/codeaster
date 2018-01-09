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
!
interface
    subroutine ccchuc_chamno(field_in_s, field_out_s, nb_node, list_node, nb_cmp, type_comp, &
                             crit, nb_form, name_form, name_gd, nb_cmp_resu, work_out_val,&
                             nb_node_out, ichk)
        character(len=19), intent(in) :: field_in_s
        character(len=19), intent(in) :: field_out_s
        integer, intent(in) :: nb_node
        character(len=24), intent(in) :: list_node
        integer, intent(in) :: nb_cmp
        character(len=16), intent(in) :: type_comp
        character(len=16), intent(in) :: crit
        integer, intent(in) :: nb_form
        character(len=8), intent(in) :: name_form(nb_form)
        character(len=8), intent(in) :: name_gd
        integer, intent(in) :: nb_cmp_resu
        character(len=24), intent(in) :: work_out_val
        integer, intent(out) :: ichk
        integer, intent(out) :: nb_node_out
    end subroutine ccchuc_chamno
end interface

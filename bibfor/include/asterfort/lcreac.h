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
    subroutine lcreac(nb_lagr       , indi_lagc     , elem_dime,&
                      nb_node_slav  , nb_node_mast  ,&
                      jv_disp       , jv_disp_incr  ,&
                      elem_slav_init, elem_mast_init,&
                      elem_slav_coor, elem_mast_coor,&
                      jv_ddisp)
        integer, intent(in) :: elem_dime
        integer, intent(in) :: nb_lagr
        integer, intent(in) :: indi_lagc(10)
        integer, intent(in) :: nb_node_slav, nb_node_mast
        integer, intent(in) :: jv_disp, jv_disp_incr
        integer, intent(in), optional :: jv_ddisp
        real(kind=8), intent(in) :: elem_slav_init(nb_node_slav, elem_dime)
        real(kind=8), intent(in) :: elem_mast_init(nb_node_mast, elem_dime)
        real(kind=8), intent(inout) :: elem_slav_coor(nb_node_slav, elem_dime)
        real(kind=8), intent(inout) :: elem_mast_coor(nb_node_mast, elem_dime)
    end subroutine lcreac
end interface

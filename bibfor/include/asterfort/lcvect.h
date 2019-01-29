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
#include "asterf_types.h"
!
interface
    subroutine lcvect(elem_dime   , l_axis        , l_upda_jaco   , l_norm_smooth ,&
                      nb_lagr     , indi_lagc     , lagrc         , elga_fami     ,&
                      nb_node_slav, elem_slav_code, elem_slav_init, elem_slav_coor,&
                      nb_node_mast, elem_mast_code, elem_mast_init, elem_mast_coor,&
                      nb_poin_inte, poin_inte_sl  , poin_inte_ma  ,&
                      vect, gapi, nmcp)
        integer, intent(in) :: elem_dime
        aster_logical, intent(in) :: l_axis
        aster_logical, intent(in) :: l_upda_jaco
        aster_logical, intent(in) :: l_norm_smooth
        integer, intent(in) :: nb_lagr
        integer, intent(in) :: indi_lagc(10)
        real(kind=8), intent(in) :: lagrc, gapi
        character(len=8), intent(in) :: elem_slav_code, elem_mast_code
        integer, intent(in) :: nb_node_slav, nb_node_mast
        integer, intent(in) :: nmcp
        integer, intent(in) :: nb_poin_inte
        real(kind=8), intent(in):: poin_inte_sl(16)
        real(kind=8), intent(in):: poin_inte_ma(16)
        character(len=8), intent(in) :: elga_fami
        real(kind=8), intent(in) :: elem_mast_init(nb_node_mast, elem_dime)
        real(kind=8), intent(in) :: elem_slav_init(nb_node_slav, elem_dime)
        real(kind=8), intent(in) :: elem_mast_coor(nb_node_mast, elem_dime)
        real(kind=8), intent(in) :: elem_slav_coor(nb_node_slav, elem_dime)
        real(kind=8), intent(inout) :: vect(55)
    end subroutine lcvect
end interface

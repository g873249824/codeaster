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
#include "asterf_types.h"
!
interface
    subroutine lctppe(side      , elem_dime , l_axis     ,&
                      nb_node   , elem_coor , elem_code  ,&
                      gauss_coor, shape_func, shape_dfunc,&
                      jacobian , l_jaco_upda , norm, jv_geom,&
                      shift_)
        character(len=*), intent(in) :: side
        integer, intent(in) :: elem_dime
        aster_logical, intent(in) :: l_axis
        integer, intent(in) :: nb_node
        real(kind=8), intent(in) :: elem_coor(elem_dime,nb_node)
        character(len=8), intent(in) :: elem_code   
        real(kind=8), intent(in) :: gauss_coor(2)
        real(kind=8), intent(out) :: shape_func(9)
        real(kind=8), intent(out) :: shape_dfunc(2, 9)
        real(kind=8), intent(out) :: jacobian 
        aster_logical, intent(in) :: l_jaco_upda
        real(kind=8), intent(out) :: norm(3)
        integer, intent(in) :: jv_geom
        integer, intent(in), optional :: shift_
    end subroutine lctppe
end interface

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
    subroutine apelem_getvertex(elem_dime, elem_code,&
                                para_coor, nb_vertex, para_code,&
                                elem_coor, proj_tole)
        integer, intent(in) :: elem_dime
        character(len=8), intent(in) :: elem_code
        real(kind=8), intent(out) :: para_coor(elem_dime-1,4)
        integer, intent(out) :: nb_vertex
        character(len=8), intent(out) :: para_code
        real(kind=8), intent(in) :: elem_coor(3,9)
        real(kind=8), intent(in) :: proj_tole
    end subroutine apelem_getvertex
end interface

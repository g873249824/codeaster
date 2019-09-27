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
!
#include "asterf_types.h"
!
interface
    subroutine porea3(nno, nc, deplm, deplp, geom,&
                      gamma, vecteu, pgl, xl1, angp)
        integer :: nc
        integer :: nno
        real(kind=8) :: deplm(nno*nc)
        real(kind=8) :: deplp(nno*nc)
        real(kind=8) :: geom(3, nno)
        real(kind=8) :: gamma
        aster_logical :: vecteu
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: xl1
        real(kind=8) :: angp(3)
    end subroutine porea3
end interface

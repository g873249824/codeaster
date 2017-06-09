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
    subroutine nmgrib(nno, geom, dff, dir11, lexc,&
                      vecn, b, jac, p)
        integer :: nno
        real(kind=8) :: geom(3, nno)
        real(kind=8) :: dff(2, nno)
        real(kind=8) :: dir11(3)
        aster_logical :: lexc
        real(kind=8) :: vecn(3)
        real(kind=8) :: b(6, nno)
        real(kind=8) :: jac
        real(kind=8) :: p(3, 6)
    end subroutine nmgrib
end interface

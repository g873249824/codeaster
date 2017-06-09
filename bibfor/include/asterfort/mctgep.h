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
interface
    subroutine mctgep(deigy, dydx, eigx, eigy, vecx,&
                      direig, edge, apex)
        real(kind=8) :: deigy(3,3)
        real(kind=8) :: dydx(6,6)
        real(kind=8) :: eigx(3)
        real(kind=8) :: eigy(3)
        real(kind=8) :: vecx(6)
        real(kind=8) :: direig(3,3)
        real(kind=8) :: edge
        real(kind=8) :: apex
    end subroutine mctgep
end interface

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
    subroutine ptkg00(sf, a1, a2, xiz, xiz2,&
                      xiy, xiy2, xl, ey, ez,&
                      dsm)
        real(kind=8) :: sf(*)
        real(kind=8) :: a1
        real(kind=8) :: a2
        real(kind=8) :: xiz
        real(kind=8) :: xiz2
        real(kind=8) :: xiy
        real(kind=8) :: xiy2
        real(kind=8) :: xl
        real(kind=8) :: ey
        real(kind=8) :: ez
        real(kind=8) :: dsm(*)
    end subroutine ptkg00
end interface

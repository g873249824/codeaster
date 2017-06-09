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
    subroutine hsj1f(intsn, xr, epais, vectg, vectt,&
                     hsf, kwgt, hsj1fx, wgt)
        integer :: intsn
        real(kind=8) :: xr(*)
        real(kind=8) :: epais
        real(kind=8) :: vectg(2, 3)
        real(kind=8) :: vectt(3, 3)
        real(kind=8) :: hsf(3, 9)
        integer :: kwgt
        real(kind=8) :: hsj1fx(3, 9)
        real(kind=8) :: wgt
    end subroutine hsj1f
end interface

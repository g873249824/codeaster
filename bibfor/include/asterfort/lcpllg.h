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
    subroutine lcpllg(toler, itmax, mod, nbmat, mater,&
                      nr, nvi, deps, sigd, vind,&
                      seuil, icomp, sigf, vinf, devg,&
                      devgii, irtet)
        integer :: nbmat
        real(kind=8) :: toler
        integer :: itmax
        character(len=8) :: mod
        real(kind=8) :: mater(nbmat, 2)
        integer :: nr
        integer :: nvi
        real(kind=8) :: deps(6)
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(*)
        real(kind=8) :: seuil
        integer :: icomp
        real(kind=8) :: sigf(6)
        real(kind=8) :: vinf(*)
        real(kind=8) :: devg(6)
        real(kind=8) :: devgii
        integer :: irtet
    end subroutine lcpllg
end interface

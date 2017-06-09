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
    subroutine lcjacp(fami, kpg, ksp, rela_comp, toler,&
                      itmax, mod, imat, nmat, materd,&
                      materf, nr, nvi, timed, timef,&
                      deps, epsd, vind, vinf, yd,&
                      nbcomm, cpmono, pgl, nfs,&
                      nsg, toutms, hsr, dy, r,&
                      drdy, verjac, drdyb, iret, crit,&
                      indi)
        integer :: nsg
        integer :: nfs
        integer :: nvi
        integer :: nr
        integer :: nmat
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=16) :: rela_comp
        real(kind=8) :: toler
        integer :: itmax
        character(len=8) :: mod
        integer :: imat
        real(kind=8) :: materd(nmat, 2)
        real(kind=8) :: materf(nmat, 2)
        real(kind=8) :: timed
        real(kind=8) :: timef
        real(kind=8) :: deps(6)
        real(kind=8) :: epsd(6)
        real(kind=8) :: vind(nvi)
        real(kind=8) :: vinf(nvi)
        real(kind=8) :: yd(nr)
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: toutms(nfs, nsg, 6)
        real(kind=8) :: hsr(nsg, nsg)
        real(kind=8) :: dy(nr)
        real(kind=8) :: r(nr)
        real(kind=8) :: drdy(nr, nr)
        integer :: verjac
        real(kind=8) :: drdyb(nr, nr)
        integer :: iret
        real(kind=8) :: crit(*)
        integer :: indi(7)
    end subroutine lcjacp
end interface

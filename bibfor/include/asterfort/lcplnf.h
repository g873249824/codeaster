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
interface
    subroutine lcplnf(BEHinteg, &
                      rela_comp, vind, nbcomm, nmat, cpmono,&
                      materf, iter, nvi, itmax,&
                      toler, pgl, nfs, nsg, toutms,&
                      hsr, dt, dy, yd, yf,&
                      vinf, sigd, sigf,&
                      deps, nr, mod, timef,&
                      indi, vins, codret)
        use Behaviour_type
        type(Behaviour_Integ), intent(in) :: BEHinteg
        integer :: nsg
        integer :: nfs
        integer :: nvi
        integer :: nmat
        character(len=16) :: rela_comp
        real(kind=8) :: vind(*)
        integer :: nbcomm(nmat, 3)
        character(len=24) :: cpmono(5*nmat+1)
        real(kind=8) :: materf(nmat, 2)
        integer :: iter
        integer :: itmax
        real(kind=8) :: toler
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: toutms(nfs, nsg, 6)
        real(kind=8) :: hsr(nsg, nsg)
        real(kind=8) :: dt
        real(kind=8) :: dy(*)
        real(kind=8) :: yd(*)
        real(kind=8) :: yf(*)
        real(kind=8) :: vinf(*)
        real(kind=8) :: sigd(6)
        real(kind=8) :: sigf(6)
        real(kind=8) :: deps(*)
        integer :: nr
        character(len=8) :: mod
        real(kind=8) :: timef
        integer :: indi(7)
        real(kind=8) :: vins(nvi)
        integer :: codret
    end subroutine lcplnf
end interface

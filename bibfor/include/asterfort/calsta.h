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
    subroutine calsta(proj, gamma, dh, def, nno,&
                      kpg, sig, tmp, kk, kkd,&
                      matuu, dsidep, jac)
        integer :: proj
        real(kind=8) :: gamma(4)
        real(kind=8) :: dh(8)
        real(kind=8) :: def(4, 4, 2)
        integer :: nno
        integer :: kpg
        real(kind=8) :: sig(6)
        real(kind=8) :: tmp
        integer :: kk
        integer :: kkd
        real(kind=8) :: matuu(*)
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: jac
    end subroutine calsta
end interface

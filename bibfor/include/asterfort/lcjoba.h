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
    subroutine lcjoba(ndim, typmod, imate, crit, sum,&
                      dsu, vim, option, sig, vip,&
                      dsidep, iret)
        integer :: ndim
        character(len=8) :: typmod(2)
        integer :: imate
        real(kind=8) :: crit(3)
        real(kind=8) :: sum(2)
        real(kind=8) :: dsu(2)
        real(kind=8) :: vim(6)
        character(len=16) :: option
        real(kind=8) :: sig(6)
        real(kind=8) :: vip(6)
        real(kind=8) :: dsidep(6, 6)
        integer :: iret
    end subroutine lcjoba
end interface

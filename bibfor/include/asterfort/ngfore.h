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
    subroutine ngfore(nddl, neps, npg, w, b,&
                      ni2ldc, sigref, fref)
        integer :: npg
        integer :: neps
        integer :: nddl
        real(kind=8) :: w(0:npg-1)
        real(kind=8) :: b(0:neps*npg-1, nddl)
        real(kind=8) :: ni2ldc(0:neps-1)
        real(kind=8) :: sigref(0:neps-1)
        real(kind=8) :: fref(nddl)
    end subroutine ngfore
end interface
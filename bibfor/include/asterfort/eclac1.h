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
    subroutine eclac1(ipoini, mxnbpi, csomm1, nterm1, i1,&
                      i2, i3, i4, i5, i6,&
                      i7, i8)
        integer :: mxnbpi
        integer :: ipoini
        real(kind=8) :: csomm1(mxnbpi, *)
        integer :: nterm1(mxnbpi)
        integer :: i1
        integer :: i2
        integer :: i3
        integer :: i4
        integer :: i5
        integer :: i6
        integer :: i7
        integer :: i8
    end subroutine eclac1
end interface

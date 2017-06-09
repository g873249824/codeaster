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
    subroutine caldfe(df, nr, nvi, vind, dfpds,&
                      fe, dfpdbs, msdgdt, drdy)
        integer :: nr
        real(kind=8) :: df(3, 3)
        integer :: nvi
        real(kind=8) :: vind(*)
        real(kind=8) :: dfpds(3, 3, 3, 3)
        real(kind=8) :: fe(3, 3)
        real(kind=8) :: dfpdbs(3, 3, 30)
        real(kind=8) :: msdgdt(6, 6)
        real(kind=8) :: drdy(nr, nr)
    end subroutine caldfe
end interface

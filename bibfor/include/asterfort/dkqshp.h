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
    subroutine dkqshp(qsi, eta, caraq4, jacob, shpN, shpr1, shpr2)
        real(kind=8) :: qsi
        real(kind=8) :: eta
        real(kind=8) :: caraq4(*)
        real(kind=8) :: jacob(*)
        real(kind=8) :: shpN(3,4)
        real(kind=8) :: shpr1(3, 4)
        real(kind=8) ::  shpr2(3,4)
    end subroutine dkqshp
end interface

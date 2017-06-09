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
    subroutine matrn(nb1, nb2, xr, ksi3s2, epais,&
                     intsn, vectn, matn)
        integer :: nb1
        integer :: nb2
        real(kind=8) :: xr(*)
        real(kind=8) :: ksi3s2
        real(kind=8) :: epais
        integer :: intsn
        real(kind=8) :: vectn(9, 3)
        real(kind=8) :: matn(3, 51)
    end subroutine matrn
end interface

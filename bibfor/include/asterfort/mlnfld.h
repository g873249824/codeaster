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
    subroutine mlnfld(n, frontl, frontu, adper, t1,&
                      t2, ad, eps, ier)
        integer :: n
        real(kind=8) :: frontl(*)
        real(kind=8) :: frontu(*)
        integer :: adper(*)
        real(kind=8) :: t1(*)
        real(kind=8) :: t2(*)
        integer :: ad(*)
        real(kind=8) :: eps
        integer :: ier
    end subroutine mlnfld
end interface

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
    subroutine pacou1(x, fvec, df, work, eps,&
                      vecr1, vecr2, typflu, vecr3, amor,&
                      masg, vecr4, vecr5, veci1, vg,&
                      indic, nbm, nmode, n)
        integer :: n
        real(kind=8) :: x(*)
        real(kind=8) :: fvec(*)
        real(kind=8) :: df(n, *)
        real(kind=8) :: work(*)
        real(kind=8) :: eps
        real(kind=8) :: vecr1(*)
        real(kind=8) :: vecr2(*)
        character(len=8) :: typflu
        real(kind=8) :: vecr3(*)
        real(kind=8) :: amor(*)
        real(kind=8) :: masg(*)
        real(kind=8) :: vecr4(*)
        real(kind=8) :: vecr5(*)
        integer :: veci1(*)
        real(kind=8) :: vg
        integer :: indic
        integer :: nbm
        integer :: nmode
    end subroutine pacou1
end interface

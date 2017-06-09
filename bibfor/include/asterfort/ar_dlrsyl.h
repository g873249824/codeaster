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
    subroutine ar_dlrsyl(trana, tranb, isgn, m, n,&
                      a, lda, b, ldb, c,&
                      ldc, scale, info)
        integer :: ldc
        integer :: ldb
        integer :: lda
        character(len=1) :: trana
        character(len=1) :: tranb
        integer :: isgn
        integer :: m
        integer :: n
        real(kind=8) :: a(lda, *)
        real(kind=8) :: b(ldb, *)
        real(kind=8) :: c(ldc, *)
        real(kind=8) :: scale
        integer :: info
    end subroutine ar_dlrsyl
end interface

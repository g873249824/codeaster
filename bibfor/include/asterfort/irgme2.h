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
    subroutine irgme2(numold, ima, connex, nbord2, tabd,&
                      tabl, tabv, partie, jtype, nbno,&
                      listno, nbcmp, ifi, iadmax)
        integer :: numold(*)
        integer :: ima
        character(len=24) :: connex
        integer :: nbord2
        integer :: tabd(*)
        integer :: tabl(*)
        integer :: tabv(*)
        character(len=*) :: partie
        integer :: jtype
        integer :: nbno
        integer :: listno(*)
        integer :: nbcmp
        integer :: ifi
        integer :: iadmax
    end subroutine irgme2
end interface

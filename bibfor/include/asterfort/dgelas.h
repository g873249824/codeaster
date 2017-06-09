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
    subroutine dgelas(eb, nub, h, b, a,&
                      em, num, ef, nuf, icisai)
        real(kind=8) :: eb
        real(kind=8) :: nub
        real(kind=8) :: h
        real(kind=8) :: b
        real(kind=8) :: a
        real(kind=8) :: em
        real(kind=8) :: num
        real(kind=8) :: ef
        real(kind=8) :: nuf
        integer :: icisai
    end subroutine dgelas
end interface

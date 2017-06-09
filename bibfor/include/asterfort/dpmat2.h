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
    subroutine dpmat2(mod, mater, alpha, beta, dp,&
                      dpdeno, pplus, se, seq, plas,&
                      dsde)
        character(len=8) :: mod
        real(kind=8) :: mater(5, 2)
        real(kind=8) :: alpha
        real(kind=8) :: beta
        real(kind=8) :: dp
        real(kind=8) :: dpdeno
        real(kind=8) :: pplus
        real(kind=8) :: se(6)
        real(kind=8) :: seq
        real(kind=8) :: plas
        real(kind=8) :: dsde(6, 6)
    end subroutine dpmat2
end interface

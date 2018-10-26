! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
interface
    subroutine mmmtfu(phase ,&
                      ndim  , nnl   , nne   , nnm   , nbcps,&
                      wpg   , jacobi, ffl   , ffe   , ffm  ,&
                      tau1  , tau2  , mprojt,&
                      rese  , nrese , lambda, coefff,&
                      matrfe, matrfm)
        character(len=4), intent(in) :: phase
        integer, intent(in) :: ndim, nne, nnm, nnl, nbcps
        real(kind=8), intent(in) :: tau1(3), tau2(3), mprojt(3, 3)
        real(kind=8), intent(in) :: wpg, ffl(9), ffe(9), ffm(9), jacobi
        real(kind=8), intent(in) :: rese(3), nrese, lambda, coefff
        real(kind=8), intent(out) :: matrfe(18, 27), matrfm(18, 27)
    end subroutine mmmtfu
end interface

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
    subroutine mmmtas(nbdm   , ndim   , nnl    , nne    , nnm    , nbcps,&
                      matrcc , matree , matrmm , matrem ,&
                      matrme , matrce , matrcm , matrmc , matrec ,&
                      matr   ,&
                      matrff_, matrfe_, matrfm_, matrmf_, matref_)
        integer, intent(in) :: nbdm, ndim, nnl, nne, nnm, nbcps
        real(kind=8), intent(in) :: matrcc(9, 9), matree(27, 27), matrmm(27, 27)
        real(kind=8), intent(in) :: matrem(27, 27), matrme(27, 27), matrce(9, 27), matrcm(9, 27)
        real(kind=8), intent(in) :: matrec(27, 9), matrmc(27, 9)
        real(kind=8), intent(inout) :: matr(81, 81)
        real(kind=8), optional, intent(in) :: matrff_(18, 18)
        real(kind=8), optional, intent(in) :: matrfe_(18, 27), matrfm_(18, 27)
        real(kind=8), optional, intent(in) :: matrmf_(27, 18), matref_(27, 18)
    end subroutine mmmtas
end interface

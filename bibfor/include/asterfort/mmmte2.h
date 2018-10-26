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
    subroutine mmmte2(ndim, nnl, nne, nnm, nbcpf, ndexcl,&
                      matrff, matrfe, matrfm, matref, matrmf)
        integer, intent(in) :: ndim, nne, nnl, nnm, nbcpf, ndexcl(10)
        real(kind=8), intent(inout) :: matrff(18, 18), matref(27, 18), matrfe(18, 27)
        real(kind=8), intent(inout) :: matrmf(27, 18), matrfm(18, 27)
    end subroutine mmmte2
end interface

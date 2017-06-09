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
    subroutine matcox(ndim, pp, ddt1, ddt2, ddt3,&
                      ddt4, p, nno, ddlh, ddls,&
                      jac, ffp, singu, fk, mmat)
        integer :: ndim
        real(kind=8) :: pp(3, 3)
        real(kind=8) :: ddt1(3, 3)
        real(kind=8) :: ddt2(3, 3)
        real(kind=8) :: ddt3(3, 3)
        real(kind=8) :: ddt4(3, 3)
        real(kind=8) :: p(3, 3)
        integer :: nno
        integer :: ddlh
        integer :: ddls
        real(kind=8) :: jac
        real(kind=8) :: ffp(27)
        integer :: singu
        real(kind=8) :: fk(27,3,3)
        real(kind=8) :: mmat(216, 216)
    end subroutine matcox
end interface

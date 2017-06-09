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
    subroutine xmmab3(ndim, nno, nnos, nnol, pla,&
                      ffc, ffp, jac, knp, nfh,&
                      seuil, tau1, tau2, mu, singu,&
                      fk, lact, ddls, ddlm, mmat)
        integer :: ndim
        integer :: nno
        integer :: nnos
        integer :: nnol
        integer :: pla(27)
        real(kind=8) :: ffc(8)
        real(kind=8) :: ffp(27)
        real(kind=8) :: jac
        real(kind=8) :: knp(3, 3)
        integer :: nfh
        real(kind=8) :: seuil
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: mu
        integer :: singu
        integer :: lact(8)
        integer :: ddls
        integer :: ddlm
        real(kind=8) :: fk(27,3,3)
        real(kind=8) :: mmat(216, 216)
    end subroutine xmmab3
end interface

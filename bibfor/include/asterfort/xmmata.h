! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine xmmata(ds_thm, ndim, nnops, nnop, ddls, ddlm, saut,&
                      nd, pla, ffc, dffc, mmat, rho11,&
                      gradpf, ffp, dt, ta, jac,&
                      jheavn, ncompn, ifiss,&
                      nfiss, nfh, ifa, jheafa, ncomph)
        use THM_type
        type(THM_DS), intent(inout) :: ds_thm
        integer :: nnops
        integer :: nnop
        integer :: ndim
        integer :: ddls
        integer :: ddlm
        real(kind=8) :: saut(3)
        real(kind=8) :: nd(3)
        real(kind=8) :: ffc(16)
        integer :: pla(27)
        real(kind=8) :: dffc(16,3)
        real(kind=8) :: ffp(27)
        real(kind=8) :: jac
        real(kind=8) :: rho11
        real(kind=8) :: gradpf(3)
        real(kind=8) :: dt
        real(kind=8) :: ta
        real(kind=8) :: mmat(560,560)
        integer :: jheavn
        integer :: ncompn
        integer :: ifiss
        integer :: nfiss
        integer :: nfh
        integer :: ifa
        integer :: jheafa
        integer :: ncomph
    end subroutine xmmata
end interface

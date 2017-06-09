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
    subroutine xdecou(ndim, elp, nnop, nnose, it,&
                      pintt, cnset, lsn, fisco, igeom,&
                      nfiss, ifiss, pinter, ninter, npts,&
                      ainter, lonref, nfisc)
        integer :: nfisc
        integer :: nnop
        integer :: ndim
        character(len=8) :: elp
        integer :: nnose
        integer :: it
        real(kind=8) :: pintt(*)
        integer :: cnset(*)
        real(kind=8) :: lsn(*)
        integer :: fisco(*)
        integer :: igeom
        integer :: nfiss
        integer :: ifiss
        real(kind=8) :: pinter(*)
        integer :: ninter
        integer :: npts
        real(kind=8) :: ainter(*)
        real(kind=8) :: lonref
    end subroutine xdecou
end interface

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
    subroutine xrigel(nnop, ddlh, nfe, ddlc,&
                      igeom, jpintt, cnset, heavt, lonch,&
                      basloc, lsn, lst, sig, matuu,&
                      jpmilt, heavn, jstno, imate)
        integer :: nnop
        integer :: ddlh
        integer :: nfe
        integer :: ddlc
        integer :: igeom
        integer :: jpintt
        integer :: cnset(128)
        integer :: heavt(36)
        integer :: lonch(10)
        integer :: heavn(27,5)
        integer :: jstno
        integer :: imate
        real(kind=8) :: basloc(*)
        real(kind=8) :: lsn(nnop)
        real(kind=8) :: lst(nnop)
        real(kind=8) :: sig(*)
        real(kind=8) :: matuu(*)
        integer :: jpmilt
    end subroutine xrigel
end interface

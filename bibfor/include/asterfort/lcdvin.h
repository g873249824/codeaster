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
    subroutine lcdvin(fami, kpg, ksp, rela_comp, mod,&
                      imat, matcst, nvi, nmat, vini,&
                      coeft, x, dtime, sigi, dvin,&
                      iret)
        integer :: nmat
        integer :: nvi
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=16) :: rela_comp
        character(len=8) :: mod
        integer :: imat
        character(len=3) :: matcst
        real(kind=8) :: vini(nvi)
        real(kind=8) :: coeft(nmat)
        real(kind=8) :: x
        real(kind=8) :: dtime
        real(kind=8) :: sigi(6)
        real(kind=8) :: dvin(nvi)
        integer :: iret
    end subroutine lcdvin
end interface

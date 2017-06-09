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
    subroutine xxlagm(ffc, idepl, idepm, lact, ndim,&
                      nnol, pla, reac, reac12, tau1,&
                      tau2, nvec)
        real(kind=8) :: ffc(8)
        integer :: idepl
        integer :: idepm
        integer :: lact(8)
        integer :: ndim
        integer :: nnol
        integer :: pla(27)
        real(kind=8) :: reac
        real(kind=8) :: reac12(3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        integer :: nvec
    end subroutine xxlagm
end interface

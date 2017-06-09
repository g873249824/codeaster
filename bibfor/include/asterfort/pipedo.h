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
    subroutine pipedo(ndim, typmod, tau, mate, vim,&
                      epsm, epspc, epsdc, etamin, etamax,&
                      a0, a1, a2, a3, etas)
        integer :: ndim
        character(len=8) :: typmod(*)
        real(kind=8) :: tau
        integer :: mate
        real(kind=8) :: vim(7)
        real(kind=8) :: epsm(6)
        real(kind=8) :: epspc(6)
        real(kind=8) :: epsdc(6)
        real(kind=8) :: etamin
        real(kind=8) :: etamax
        real(kind=8) :: a0
        real(kind=8) :: a1
        real(kind=8) :: a2
        real(kind=8) :: a3
        real(kind=8) :: etas
    end subroutine pipedo
end interface

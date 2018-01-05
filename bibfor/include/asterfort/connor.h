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
!
interface
    subroutine connor(melflu, typflu, freq, base, nuor,&
                      amoc, carac, lnoe, nbm, vite, &
                      rho, abscur, mailla)
        integer :: nbm
        integer :: lnoe
        character(len=19) :: melflu
        character(len=8) :: typflu
        real(kind=8) :: freq(nbm)
        character(len=8) :: base
        integer :: nuor(nbm)
        real(kind=8) :: amoc(nbm)
        real(kind=8) :: carac(2)
        real(kind=8) :: vite(lnoe)
        real(kind=8) :: rho(2*lnoe)
        real(kind=8) :: abscur(lnoe)
        character(len=8) :: mailla
    end subroutine connor
end interface

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
interface
    subroutine viemma(nbvari, vintm , vintp,&
                      advico, vicphi,&
                      phi0  , dp1   , dp2  , signe, satur,&
                      em    , phi   , phim)
        integer, intent(in) :: nbvari
        real(kind=8), intent(in) :: vintm(nbvari)
        real(kind=8), intent(inout) :: vintp(nbvari)
        integer, intent(in) :: advico
        integer, intent(in) :: vicphi
        real(kind=8), intent(in) :: phi0
        real(kind=8), intent(in) :: dp1
        real(kind=8), intent(in) :: dp2
        real(kind=8), intent(in) :: signe
        real(kind=8), intent(in) :: satur
        real(kind=8), intent(in) :: em
        real(kind=8), intent(out) :: phi
        real(kind=8), intent(out) :: phim
    end subroutine viemma
end interface

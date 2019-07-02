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
    subroutine lc0166(fami  , kpg   , ksp   , ndim  , imate,&
                      compor, instam, instap, epsm  ,&
                      deps  , sigm  , vim   , option,&
                      sigp  , vip   , typmod,&
                      dsidep, codret)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: imate, ndim, kpg, ksp
        real(kind=8), intent(in)  :: instam, instap
        real(kind=8), intent(in)  :: epsm(6), deps(6)
        real(kind=8), intent(in)  :: sigm(6), vim(*)
        real(kind=8), intent(out) :: vip(*), sigp(6), dsidep(6, 6)
        character(len=16), intent(in) :: compor(*), option
        character(len=8), intent(in) :: typmod(*)
        integer, intent(out) :: codret
    end subroutine lc0166
end interface

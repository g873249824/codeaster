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
    subroutine pmfasseinfo(tygrfi, nbfibr, nbcarm, cara, mxfiass,nbfiass,gxjxpou)
        integer, intent(in) :: nbfibr
        integer, intent(in) :: tygrfi
        integer, intent(in) :: nbcarm
        real(kind=8), intent(in) :: cara(nbcarm,nbfibr)
        integer, intent(out) :: mxfiass
        integer, pointer :: nbfiass(:)
        real(kind=8), pointer :: gxjxpou(:)
    end subroutine pmfasseinfo
end interface

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
!
interface
    subroutine elrfd2(elrefz, x, dimd, dff2, nno, ndim)
        character(len=*), intent(in) :: elrefz
        integer, intent(in)          :: dimd
        real(kind=8), intent(in)     :: x(*)
        integer, intent(out)         :: nno, ndim
        real(kind=8), intent(out)    :: dff2(3, 3, *)
    end subroutine elrfd2
end interface

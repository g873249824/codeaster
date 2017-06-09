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
#include "asterf_types.h"
!
interface
    subroutine nmfdff(ndim, nno, axi, g, r,&
                      rigi, matsym, fr, vff, dff,&
                      def, pff)
        integer :: nno
        integer :: ndim
        aster_logical :: axi
        integer :: g
        real(kind=8) :: r
        aster_logical :: rigi
        aster_logical :: matsym
        real(kind=8) :: fr(3, 3)
        real(kind=8) :: vff(nno, *)
        real(kind=8) :: dff(nno, *)
        real(kind=8) :: def(2*ndim, nno, ndim)
        real(kind=8) :: pff(2*ndim, nno, nno)
    end subroutine nmfdff
end interface

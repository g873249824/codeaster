! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
interface
    subroutine asmpi_isend_i4(buf, count, dest, tag, comm,&
                              request)
        integer(kind=4), intent(inout) :: buf(*)
        mpi_int, intent(in) :: count
        mpi_int, intent(in) :: dest
        mpi_int, intent(in) :: tag
        mpi_int, intent(in) :: comm
        mpi_int, intent(out) :: request
    end subroutine asmpi_isend_i4
end interface

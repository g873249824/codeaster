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
    subroutine ar_dtrsen(job, compq, select, n, t,&
                      ldt, q, ldq, wr, wi,&
                      m, s, sep, work, lwork,&
                      iwork, liwork, info)
        integer :: ldq
        integer :: ldt
        character(len=1) :: job
        character(len=1) :: compq
        aster_logical :: select(*)
        integer :: n
        real(kind=8) :: t(ldt, *)
        real(kind=8) :: q(ldq, *)
        real(kind=8) :: wr(*)
        real(kind=8) :: wi(*)
        integer :: m
        real(kind=8) :: s
        real(kind=8) :: sep
        real(kind=8) :: work(*)
        integer :: lwork
        integer :: iwork(*)
        integer :: liwork
        integer :: info
    end subroutine ar_dtrsen
end interface

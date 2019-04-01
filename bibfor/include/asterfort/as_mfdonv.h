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
#include "asterf_types.h"
interface
    subroutine as_mfdonv(fid, cha, typent, typgeo, noma,&
                      numdt, numo, pit, nompro, stm,&
                      npr, nomloc, nip, n, cret)
        med_idt :: fid
        character(len=*) :: cha
        aster_int :: typent
        aster_int :: typgeo
        character(len=*) :: noma
        aster_int :: numdt
        aster_int :: numo
        aster_int :: pit
        character(len=*) :: nompro
        aster_int :: stm
        aster_int :: npr
        character(len=*) :: nomloc
        aster_int :: nip
        aster_int :: n
        aster_int :: cret
    end subroutine as_mfdonv
end interface

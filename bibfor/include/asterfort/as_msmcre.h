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
    subroutine as_msmcre(fid, nom, dim, desc, typrep,&
                      nocomp, unit, cret)
        med_idt :: fid
        character(len=*) :: nom
        aster_int :: dim
        character(len=*) :: desc
        aster_int :: typrep
        character(len=16) :: nocomp(3)
        character(len=16) :: unit(3)
        aster_int :: cret
    end subroutine as_msmcre
end interface

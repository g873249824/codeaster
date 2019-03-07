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
#include "asterf_types.h"
    subroutine mmhraw(fid, name, numdt, numit, geotype,&
                      aname, n, val, cret)
        med_idt :: fid
        character(len=*) :: name
        med_int :: numdt
        med_int :: numit
        med_int :: geotype
        character(len=*) :: aname
        med_int :: n
        real(kind=8) :: val(*)
        med_int :: cret
    end subroutine mmhraw
end interface

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
    subroutine memam2(option, modele, nchar, lchar, mate,&
                      cara, compor, exitim, time, chacce,&
                      vecel, basez, ligrez)
        character(len=*) :: option
        character(len=*) :: modele
        integer :: nchar
        character(len=8) :: lchar(*)
        character(len=*) :: mate
        character(len=*) :: cara
        character(len=24) :: compor
        aster_logical :: exitim
        real(kind=8) :: time
        character(len=*) :: chacce
        character(len=*) :: vecel
        character(len=*) :: basez
        character(len=*) :: ligrez
    end subroutine memam2
end interface

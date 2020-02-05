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
!
interface
    subroutine meamme(optioz, modele, nchar, lchar, mate,&
                      cara, time, base, merigi,&
                      memass, meamor, varplu, compor_)
        character(len=*) :: optioz
        character(len=*) :: modele
        integer :: nchar
        character(len=8) :: lchar(*)
        character(len=*) :: mate
        character(len=*) :: cara
        real(kind=8) :: time
        character(len=1) :: base
        character(len=*) :: merigi
        character(len=*) :: memass
        character(len=*) :: meamor
        character(len=*) :: varplu
        character(len=*), optional  :: compor_
    end subroutine meamme
end interface

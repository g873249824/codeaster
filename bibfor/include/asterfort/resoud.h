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
#include "asterf_types.h"
!
interface
    subroutine resoud(matass, matpre, solveu, chcine, nsecm,&
                      chsecm, chsolu, base, rsolu, csolu,&
                      criter, prepos, istop, iret)
        character(len=*) :: matass
        character(len=*) :: matpre
        character(len=*) :: solveu
        character(len=*) :: chcine
        integer :: nsecm
        character(len=*) :: chsecm
        character(len=*) :: chsolu
        character(len=*) :: base
        real(kind=8) :: rsolu(*)
        complex(kind=8) :: csolu(*)
        character(len=*) :: criter
        aster_logical :: prepos
        integer :: istop
        integer :: iret
    end subroutine resoud
end interface

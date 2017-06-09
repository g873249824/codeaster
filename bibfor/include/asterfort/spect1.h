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
    subroutine spect1(casint, nomu, spectr, ispect, base,&
                      vite, nuor, imodi, imodf, nbm,&
                      nbpf, nomzon, vmoyzi, vmoyto)
        integer :: nbm
        aster_logical :: casint
        character(len=8) :: nomu
        character(len=19) :: spectr
        integer :: ispect
        character(len=19) :: base
        real(kind=8) :: vite
        integer :: nuor(nbm)
        integer :: imodi
        integer :: imodf
        integer :: nbpf
        character(len=8) :: nomzon
        real(kind=8) :: vmoyzi
        real(kind=8) :: vmoyto
    end subroutine spect1
end interface

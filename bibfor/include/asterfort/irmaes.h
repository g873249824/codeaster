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
#include "MeshTypes_type.h"
!
interface
    subroutine irmaes(idfimd, nomaas, nomamd, nbimpr, caimpi,&
                      modnum, nuanom, nomtyp, nnotyp, sdcarm,&
                      carael)
        integer :: nbimpr
        med_idt :: idfimd
        character(len=8) :: nomaas
        character(len=64) :: nomamd
        integer :: caimpi(10, nbimpr)
        integer :: modnum(MT_NTYMAX)
        integer :: nuanom(MT_NTYMAX, *)
        character(len=8) :: nomtyp(*)
        integer :: nnotyp(*)
        character(len=8) :: sdcarm, carael
    end subroutine irmaes
end interface

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
    subroutine lrmmma(fid, nomamd, nbmail, nbnoma, nbtyp,&
                      typgeo, nomtyp, nnotyp, renumd, nmatyp,&
                      nommai, connex, typmai, prefix, infmed,&
                      modnum, numnoa)
        med_idt :: fid
        character(len=*) :: nomamd
        integer :: nbmail
        integer :: nbnoma
        integer :: nbtyp
        integer :: typgeo(MT_NTYMAX)
        character(len=8) :: nomtyp(*)
        integer :: nnotyp(MT_NTYMAX)
        integer :: renumd(*)
        integer :: nmatyp(MT_NTYMAX)
        character(len=24) :: nommai
        character(len=24) :: connex
        character(len=24) :: typmai
        character(len=6) :: prefix
        integer :: infmed
        integer :: modnum(MT_NTYMAX)
        integer :: numnoa(MT_NTYMAX, *)
    end subroutine lrmmma
end interface

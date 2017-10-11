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
    subroutine vppost(vecrer, vecrei, vecrek, vecvp, nbpark, nbpari, nbparr, mxresf,&
                      nconv, nblagr, nfreqg, modes, typcon, compex, eigsol, matopa, matpsc, solveu,&
                      vecblo, veclag, flage,&
                      icom1, icom2, mpicou, mpicow, omemax, omemin, vpinf, vpmax, lcomod, mod45b)
        character(len=24) , intent(in)    :: vecrer
        character(len=24) , intent(in)    :: vecrei
        character(len=24) , intent(in)    :: vecrek
        character(len=24) , intent(in)    :: vecvp
        integer           , intent(in)    :: nbpark
        integer           , intent(in)    :: nbpari
        integer           , intent(in)    :: nbparr
        integer           , intent(in)    :: mxresf
        integer           , intent(in)    :: nconv
        integer           , intent(in)    :: nblagr
        integer           , intent(in)    :: nfreqg
        character(len=8)  , intent(in)    :: modes
        character(len=16) , intent(in)    :: typcon
        character(len=16) , intent(in)    :: compex
        character(len=19) , intent(in)    :: eigsol
        character(len=19) , intent(in)    :: matopa
        character(len=19) , intent(in)    :: matpsc
        character(len=19) , intent(in)    :: solveu
        character(len=24) , intent(in)    :: vecblo
        character(len=24) , intent(in)    :: veclag
        aster_logical     , intent(in)    :: flage
!!
        integer           , intent(inout) :: icom1
        integer           , intent(inout) :: icom2
        mpi_int           , intent(inout) :: mpicou
        mpi_int           , intent(inout) :: mpicow
        real(kind=8)      , intent(inout) :: omemax
        real(kind=8)      , intent(inout) :: omemin
        real(kind=8)      , intent(inout) :: vpinf
        real(kind=8)      , intent(inout) :: vpmax
        aster_logical     , intent(inout) :: lcomod
        character(len=4)  , intent(in)    :: mod45b
    end subroutine vppost
end interface

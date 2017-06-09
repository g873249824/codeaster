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
    subroutine vpcalq(eigsol, vecrer, vecrei, vecrek, vecvp, mxresf, neqact,&
                      nblagr, omemax, omemin, omeshi, vecblo, sigma,&
                      npivot, flage, nconv, vpinf, vpmax)
        character(len=19) , intent(in)    :: eigsol
        character(len=24) , intent(in)    :: vecrer
        character(len=24) , intent(in)    :: vecrei
        character(len=24) , intent(in)    :: vecrek
        character(len=24) , intent(in)    :: vecvp
        integer           , intent(in)    :: mxresf
        integer           , intent(in)    :: neqact
        integer           , intent(in)    :: nblagr
        real(kind=8)      , intent(in)    :: omemax
        real(kind=8)      , intent(in)    :: omemin
        real(kind=8)      , intent(in)    :: omeshi
        character(len=24) , intent(in)    :: vecblo
        complex(kind=8)   , intent(in)    :: sigma
!!
        integer           , intent(inout) :: npivot
        aster_logical   , intent(out)   :: flage
        integer           , intent(out)   :: nconv
        real(kind=8)      , intent(out)   :: vpinf
        real(kind=8)      , intent(out)   :: vpmax
    end subroutine vpcalq
end interface

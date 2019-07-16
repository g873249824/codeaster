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
#include "asterf_types.h"
!
interface
    subroutine redece(BEHinteg,&
                      fami, kpg, ksp, ndim, typmod, l_epsi_varc,&
                      imate, compor, mult_comp, carcri, instam, instap,&
                      neps, epsdt, depst, nsig, sigd,&
                      vind, option, angmas, cp, numlc, &
                      sigf, vinf, ndsde, dsde, codret)
        use Behaviour_type
        type(Behaviour_Integ) :: BEHinteg
        aster_logical, intent(in) :: l_epsi_varc
        integer :: ndsde
        integer :: nsig
        integer :: neps
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: ndim
        character(len=8) :: typmod(*)
        integer :: imate
        character(len=16) :: compor(*)
        character(len=16), intent(in) :: mult_comp
        real(kind=8) :: carcri(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        real(kind=8) :: epsdt(neps)
        real(kind=8) :: depst(neps)
        real(kind=8) :: sigd(nsig)
        real(kind=8) :: vind(*)
        character(len=16) :: option
        real(kind=8) :: angmas(*)
        aster_logical :: cp
        integer :: numlc
        real(kind=8) :: sigf(nsig)
        real(kind=8) :: vinf(*)
        real(kind=8) :: dsde(ndsde)
        integer :: codret
    end subroutine redece
end interface

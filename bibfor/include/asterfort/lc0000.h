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
    subroutine lc0000(BEHinteg,&
                      fami, kpg, ksp, ndim, typmod, l_epsi_varc,&
                      imate, compor, mult_comp, carcri, instam, instap,&
                      neps, epsm, deps, nsig, sigm,&
                      vim, option, angmas, cp, numlc,&
                      sigp, vip, ndsde, dsidep, icomp,&
                      nvi, codret)
        use Behaviour_type
        type(Behaviour_Integ), intent(inout) :: BEHinteg
        aster_logical, intent(in) :: l_epsi_varc
        integer :: nvi
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
        real(kind=8) :: epsm(neps)
        real(kind=8) :: deps(neps)
        real(kind=8) :: sigm(nsig)
        real(kind=8) :: vim(nvi)
        character(len=16) :: option
        real(kind=8) :: angmas(3)
        aster_logical :: cp
        integer :: numlc
        real(kind=8) :: sigp(nsig)
        real(kind=8) :: vip(nvi)
        real(kind=8) :: dsidep(ndsde)
        integer :: icomp
        integer :: codret
    end subroutine lc0000
end interface

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
    subroutine plasbe(BEHinteg,&
                      fami, kpg, ksp, typmod, imat, l_epsi_varc,&
                      crit, epsdt, depst, sigd, vind,&
                      opt, sigf, vinf, dsde,&
                      icomp, nvi, irteti)
        use Behaviour_type
        type(Behaviour_Integ), intent(in) :: BEHinteg
        aster_logical, intent(in) :: l_epsi_varc
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=8) :: typmod(*)
        integer :: imat
        real(kind=8) :: crit(*)
        real(kind=8) :: epsdt(6)
        real(kind=8) :: depst(6)
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(*)
        character(len=16) :: opt
        real(kind=8) :: sigf(6)
        real(kind=8) :: vinf(*)
        real(kind=8) :: dsde(6, 6)
        integer :: icomp
        integer :: nvi
        integer :: irteti
    end subroutine plasbe
end interface

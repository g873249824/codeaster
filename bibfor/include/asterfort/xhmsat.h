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
    subroutine xhmsat(ds_thm, option,&
                      ndim, dimenr,&
                      dimcon, nbvari, addeme,&
                      adcome,&
                      addep1, adcp11, congem, congep, vintm,&
                      vintp, dsde, epsv, depsv,&
                      dp1, phi, rho11,&
                      satur, retcom, tbiot,&
                      angl_naut, yaenrh, adenhy, nfh)
        use THM_type
        type(THM_DS), intent(in) :: ds_thm
        integer :: nbvari
        integer :: dimcon
        integer :: dimenr
        character(len=16) :: option
        integer :: ndim
        integer :: addeme
        integer :: adcome
        integer :: addep1
        integer :: adcp11
        real(kind=8) :: congem(dimcon)
        real(kind=8) :: congep(dimcon)
        real(kind=8) :: vintm(nbvari)
        real(kind=8) :: vintp(nbvari)
        real(kind=8) :: dsde(dimcon, dimenr)
        real(kind=8) :: epsv
        real(kind=8) :: depsv
        real(kind=8) :: dp1
        real(kind=8) :: phi
        real(kind=8) :: rho11
        real(kind=8) :: satur
        integer :: retcom
        real(kind=8) :: tbiot(6)
        real(kind=8) :: angl_naut(3)
        integer :: yaenrh
        integer :: adenhy
        integer :: nfh
    end subroutine xhmsat
end interface 

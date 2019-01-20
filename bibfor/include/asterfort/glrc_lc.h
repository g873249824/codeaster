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

!
!
interface
    subroutine glrc_lc(epsm, deps, vim, option, sig,&
                       vip, dsidep, lambda, deuxmu, lamf,&
                       deumuf, gmt, gmc, gf, seuil,&
                       alf, alfmc, crit,&
                       epsic, epsiels, epsilim, codret,&
                       ep, is_param_opt, val_param_opt, t2iu)
        real(kind=8) :: epsm(6)
        real(kind=8) :: deps(6)
        real(kind=8) :: vim(*)
        character(len=16) :: option
        real(kind=8) :: sig(6)
        real(kind=8) :: vip(*)
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: lambda
        real(kind=8) :: deuxmu
        real(kind=8) :: lamf
        real(kind=8) :: deumuf
        real(kind=8) :: gmt
        real(kind=8) :: gmc
        real(kind=8) :: gf
        real(kind=8) :: seuil
        real(kind=8) :: alf
        real(kind=8) :: alfmc
        real(kind=8) :: crit(*)
        real(kind=8) :: epsic
        real(kind=8) :: epsiels
        real(kind=8) :: epsilim
        integer :: codret
        real(kind=8) :: ep
        aster_logical :: is_param_opt(*)
        real(kind=8) :: val_param_opt(*)
        real(kind=8) :: t2iu(4)
    end subroutine glrc_lc
end interface

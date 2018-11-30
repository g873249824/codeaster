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
subroutine cftelu(typco, effrts, effn, effm, efft,  ht, enrobs, enrobi, facier,&
                  fbeton, alphacc, gammac, gammas, uc, compress, dnstra, ierr)
        integer :: typco
        real(kind=8) :: effrts(8)
        real(kind=8) :: effn
        real(kind=8) :: effm
        real(kind=8) :: efft
        real(kind=8) :: ht
        real(kind=8) :: enrobs
        real(kind=8) :: enrobi
        real(kind=8) :: facier
        real(kind=8) :: fbeton
        real(kind=8) :: alphacc
        real(kind=8) :: gammac
        real(kind=8) :: gammas
        integer :: uc
        integer :: compress
        real(kind=8) :: dnstra
        integer :: ierr
    end subroutine cftelu
end interface

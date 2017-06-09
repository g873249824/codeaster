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
interface
    subroutine tbliva(nomta, npacri, lipacr, vi, vr,&
                      vc, vk, crit, prec, para,&
                      ctype, vali, valr, valc, valk,&
                      ier)
        character(len=*) :: nomta
        integer :: npacri
        character(len=*) :: lipacr(*)
        integer :: vi(*)
        real(kind=8) :: vr(*)
        complex(kind=8) :: vc(*)
        character(len=*) :: vk(*)
        character(len=*) :: crit(*)
        real(kind=8) :: prec(*)
        character(len=*) :: para
        character(len=*) :: ctype
        integer :: vali
        real(kind=8) :: valr
        complex(kind=8) :: valc
        character(len=*) :: valk
        integer :: ier
    end subroutine tbliva
end interface

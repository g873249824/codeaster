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
    subroutine utch19(cham19, nomma, nomail, nonoeu, nupo,&
                      nusp, ivari, nocmp, typres, valr,&
                      valc, vali, ier)
        character(len=*) :: cham19
        character(len=*) :: nomma
        character(len=*) :: nomail
        character(len=*) :: nonoeu
        integer :: nupo
        integer :: nusp
        integer :: ivari
        character(len=*) :: nocmp
        character(len=*) :: typres
        real(kind=8) :: valr
        complex(kind=8) :: valc
        integer :: vali
        integer :: ier
    end subroutine utch19
end interface

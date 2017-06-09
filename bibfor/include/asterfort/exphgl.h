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
    subroutine exphgl(nomres, typsd, modcyc, profno, indirf,&
                      mailsk, nbsec, numdia, nbmode)
        character(len=8) :: nomres
        character(len=16) :: typsd
        character(len=8) :: modcyc
        character(len=19) :: profno
        character(len=24) :: indirf
        character(len=8) :: mailsk
        integer :: nbsec
        integer :: numdia
        integer :: nbmode
    end subroutine exphgl
end interface

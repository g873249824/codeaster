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
    subroutine ircmpn(nofimd, ncmprf, ncmpve, numcmp, exicmp,&
                      nbvato, nbnoec, linoec, adsl, caimpi,&
                      caimpk, profas, innoce)
        integer :: nbvato
        integer :: ncmprf
        character(len=*) :: nofimd
        integer :: ncmpve
        integer :: numcmp(ncmprf)
        aster_logical :: exicmp(nbvato)
        integer :: nbnoec
        integer :: linoec(*)
        integer :: adsl
        integer :: caimpi(10)
        character(len=80) :: caimpk(3)
        integer :: profas(nbvato)
        integer :: innoce(nbvato)
    end subroutine ircmpn
end interface

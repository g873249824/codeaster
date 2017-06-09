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
    subroutine xmrema(jcesd, jcesv, jcesl, noma, ndim,&
                      ifise, ds_contact, izone, alias, mmait,&
                      amait, nmait, statue, geom, nummin,&
                      nummae, ifamin, ifacee, jeumin, t1min,&
                      t2min, ximin, yimin, projin, stamin,&
                      ifism)
        use NonLin_Datastructure_type
        integer :: jcesd(10)
        integer :: jcesv(10)
        integer :: jcesl(10)
        character(len=8) :: noma
        integer :: ndim
        integer :: ifise
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer :: izone
        character(len=8) :: alias
        integer :: mmait
        integer :: amait
        integer :: nmait
        integer :: statue
        real(kind=8) :: geom(3)
        integer :: nummin
        integer :: nummae
        integer :: ifamin
        integer :: ifacee
        real(kind=8) :: jeumin
        real(kind=8) :: t1min(3)
        real(kind=8) :: t2min(3)
        real(kind=8) :: ximin
        real(kind=8) :: yimin
        aster_logical :: projin
        integer :: stamin
        integer :: ifism
    end subroutine xmrema
end interface

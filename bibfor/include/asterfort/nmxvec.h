! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1504
!
#include "asterf_types.h"
!
interface
    subroutine nmxvec(modelz, mate  , carele, ds_constitutive, ds_measure,&
                      sddisc, sddyna, numins, valinc         , solalg    ,&
                      lischa, numedd, ds_inout       , veelem    ,&
                      veasse, measse, nbvect, ltypve         , lcalve    ,&
                      loptve, lassve)
        use NonLin_Datastructure_type
        character(len=*) :: modelz
        character(len=24) :: mate
        character(len=24) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: sddisc
        character(len=19) :: sddyna
        integer :: numins
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: lischa
        character(len=24) :: numedd
        type(NL_DS_InOut), intent(in) :: ds_inout
        character(len=19) :: veelem(*)
        character(len=19) :: veasse(*)
        character(len=19) :: measse(*)
        integer :: nbvect
        character(len=6) :: ltypve(20)
        aster_logical :: lcalve(20)
        character(len=16) :: loptve(20)
        aster_logical :: lassve(20)
    end subroutine nmxvec
end interface

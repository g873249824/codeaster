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
    subroutine nmcalv(typvec         , modelz, lischa, mate      , carele,&
                      ds_constitutive, numedd, comref, ds_measure, instam,&
                      instap         , valinc, solalg, sddyna    , option,&
                      vecele)
        use NonLin_Datastructure_type        
        character(len=6) :: typvec
        character(len=*) :: modelz
        character(len=19) :: lischa
        character(len=24) :: mate
        character(len=24) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=24) :: numedd
        character(len=24) :: comref
        type(NL_DS_Measure), intent(inout) :: ds_measure
        real(kind=8) :: instam
        real(kind=8) :: instap
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: sddyna
        character(len=16) :: option
        character(len=19) :: vecele
    end subroutine nmcalv
end interface
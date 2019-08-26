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
interface
    subroutine nmnoli(sddisc       , sderro, ds_print  , sdcrit     ,&
                      fonact       , sddyna, modele    , ds_material,&
                      carele       , sdpilo, ds_measure, ds_energy  , ds_inout,&
                      ds_errorindic)
        use NonLin_Datastructure_type
        character(len=19) :: sddisc
        character(len=24) :: sderro
        type(NL_DS_Print), intent(in) :: ds_print
        character(len=19) :: sdcrit
        integer :: fonact(*)
        character(len=19) :: sddyna
        character(len=24) :: modele
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        character(len=19) :: sdpilo
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_Energy), intent(in) :: ds_energy
        type(NL_DS_InOut), intent(inout) :: ds_inout
        type(NL_DS_ErrorIndic), intent(in) :: ds_errorindic
    end subroutine nmnoli
end interface

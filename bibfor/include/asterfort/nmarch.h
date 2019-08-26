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
    subroutine nmarch(numins    , modele       , ds_material, carele, fonact   ,&
                      ds_print  , sddisc       , sdcrit     ,&
                      ds_measure, sderro       , sddyna     , sdpilo, ds_energy,&
                      ds_inout  , ds_errorindic, ds_algorom_)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        integer :: numins
        character(len=24) :: modele
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        integer :: fonact(*)
        type(NL_DS_Print), intent(in) :: ds_print
        character(len=19) :: sddisc
        character(len=19) :: sdcrit
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=24) :: sderro
        character(len=19) :: sddyna
        character(len=19) :: sdpilo
        type(NL_DS_Energy), intent(in) :: ds_energy
        type(NL_DS_InOut), intent(in) :: ds_inout
        type(NL_DS_ErrorIndic), intent(in) :: ds_errorindic
        type(ROM_DS_AlgoPara), optional, intent(in) :: ds_algorom_
    end subroutine nmarch
end interface

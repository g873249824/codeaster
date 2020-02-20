! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine nmprma(mesh       , modelz  , ds_material, carele    , ds_constitutive,&
                      ds_algopara, lischa  , numedd     , numfix    , solveu,&
                      ds_system  , ds_print, ds_measure , ds_algorom, sddisc,&
                      sddyna     , numins  , fonact     , ds_contact, valinc,&
                      solalg     , hhoField, meelem  , measse      ,maprec    , matass,&
                      faccvg     , ldccvg, condcvg)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        use HHO_type

        character(len=8), intent(in) :: mesh
        character(len=*) :: modelz
        character(len=24) :: carele
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=19) :: lischa
        character(len=24) :: numedd
        character(len=24) :: numfix
        character(len=19) :: solveu
        type(NL_DS_Print), intent(inout) :: ds_print
        type(HHO_Field), intent(in) :: hhoField
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
        type(NL_DS_System), intent(in) :: ds_system
        character(len=19) :: sddisc
        character(len=19) :: sddyna
        integer :: numins
        integer :: fonact(*)
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: maprec
        character(len=19) :: matass
        integer :: faccvg, condcvg
        integer :: ldccvg
    end subroutine nmprma
end interface

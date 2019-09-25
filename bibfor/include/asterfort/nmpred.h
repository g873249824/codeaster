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
#include "asterf_types.h"
!
interface
    subroutine nmpred(mesh, modele, numedd         , numfix    , ds_material, carele  ,&
                      ds_constitutive, lischa    , ds_algopara, solveu  , ds_system,&
                      fonact, ds_print       , ds_measure, ds_algorom , sddisc  ,&
                      sdnume, sderro         , numins    , valinc     , solalg  , hhoField,&
                      matass, maprec         , ds_contact, sddyna     , &
                      meelem, measse         , veelem    , veasse     , lerrit)
        use NonLin_Datastructure_type
        use ROM_Datastructure_type
        use HHO_type

        character(len=8), intent(in) :: mesh
        character(len=24) :: modele
        character(len=24) :: numedd
        character(len=24) :: numfix
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19) :: lischa
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=19) :: solveu
        type(NL_DS_System), intent(in) :: ds_system
        integer :: fonact(*)
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
        type(HHO_Field), intent(in) :: hhoField
        character(len=19) :: sddisc
        character(len=19) :: sdnume
        character(len=24) :: sderro
        integer :: numins
        character(len=19) :: valinc(*), solalg(*)
        character(len=19) :: matass, maprec
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=19) :: sddyna
        character(len=19) :: meelem(*), measse(*)
        character(len=19) :: veelem(*), veasse(*)
        aster_logical :: lerrit
    end subroutine nmpred
end interface

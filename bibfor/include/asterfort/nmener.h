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
    subroutine nmener(valinc, veasse, measse, sddyna, eta        ,&
                      ds_energy, fonact, numedd, numfix, &
                      meelem, numins, modele, ds_material, carele     ,&
                      ds_constitutive, ds_measure, sddisc, solalg,&
                      ds_contact, ds_system)
        use NonLin_Datastructure_type
        character(len=19) :: valinc(*)
        character(len=19) :: veasse(*)
        character(len=19) :: measse(*)
        character(len=19) :: sddyna
        real(kind=8) :: eta
        type(NL_DS_Energy), intent(inout) :: ds_energy
        integer :: fonact(*)
        character(len=24) :: numedd
        character(len=24) :: numfix
        character(len=19) :: meelem(*)
        integer :: numins
        character(len=24) :: modele
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_System), intent(in) :: ds_system
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: sddisc
        character(len=19) :: solalg(*)
        type(NL_DS_Contact), intent(in) :: ds_contact
    end subroutine nmener
end interface

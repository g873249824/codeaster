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
    subroutine ndxprm(modelz, ds_material, carele    , ds_constitutive, ds_algopara,&
                      lischa, numedd, numfix    , solveu         , ds_system,&
                      sddisc, sddyna, ds_measure, numins         , fonact     ,&
                      valinc, solalg, meelem    , measse     ,&
                      maprec, matass, faccvg    , ldccvg)
        use NonLin_Datastructure_type
        character(len=*) :: modelz
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        type(NL_DS_System), intent(in) :: ds_system
        character(len=19) :: lischa
        character(len=24) :: numedd
        character(len=24) :: numfix
        character(len=19) :: solveu
        character(len=19) :: sddisc
        character(len=19) :: sddyna
        type(NL_DS_Measure), intent(inout) :: ds_measure
        integer :: numins
        integer :: fonact(*)
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: maprec
        character(len=19) :: matass
        integer :: faccvg
        integer :: ldccvg
    end subroutine ndxprm
end interface

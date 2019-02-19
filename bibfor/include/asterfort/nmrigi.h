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
    subroutine nmrigi(modelz         , carele     , sddyna,&
                      fonact         , iterat     ,&
                      ds_constitutive, ds_material,&
                      ds_measure     , valinc     , solalg,&
                      ds_system      , optioz     ,&
                      ldccvg)
        use NonLin_Datastructure_type
        character(len=*) :: optioz
        character(len=*) :: modelz
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=24) :: carele
        integer :: iterat, ldccvg
        character(len=19) :: sddyna
        type(NL_DS_System), intent(in) :: ds_system
        character(len=19) :: solalg(*), valinc(*)
        integer :: fonact(*)
    end subroutine nmrigi
end interface

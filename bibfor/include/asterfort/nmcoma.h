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
    subroutine nmcoma(mesh          , modelz         , ds_material,&
                      cara_elem     , ds_constitutive, ds_algopara,&
                      lischa        , numedd         , numfix     ,&
                      solveu        , ds_system      , sddisc     ,&
                      sddyna        , ds_print       , ds_measure ,&
                      ds_algorom    , numins         , iter_newt  ,&
                      list_func_acti, ds_contact     , hval_incr  ,&
                      hval_algo     , hhoField       , meelem     , measse,&
                      maprec        , matass         , faccvg     ,&
                      ldccvg        , sdnume)
        use NonLin_Datastructure_type
        use Rom_Datastructure_type
        use HHO_type

        character(len=8), intent(in) :: mesh
        character(len=*) :: modelz
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: cara_elem
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=19) :: lischa
        character(len=24) :: numedd, numfix
        character(len=19) :: solveu
        character(len=19) :: sddisc
        character(len=19) :: sddyna
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
        type(NL_DS_System), intent(in) :: ds_system
        integer :: numins
        integer :: iter_newt
        integer :: list_func_acti(*)
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=19) :: hval_incr(*)
        character(len=19) :: hval_algo(*)
        type(HHO_Field), intent(in) :: hhoField
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: maprec
        character(len=19) :: matass
        integer :: faccvg
        integer :: ldccvg
        character(len=19) :: sdnume
    end subroutine nmcoma
end interface

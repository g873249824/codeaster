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
#include "asterf_types.h"
!
interface
    subroutine nmfcor(model          , nume_dof   , ds_material   , cara_elem  , ds_system,&
                      ds_constitutive, list_load  , list_func_acti, ds_algopara, nume_inst,&
                      iter_newt      , ds_measure , sddisc        , sddyna     , sdnume   ,&
                      sderro         , ds_contact , hval_incr     , hval_algo, hhoField,&
                      hval_meelem    , hval_veelem , hval_veasse, hval_measse   , matass   ,&
                      lerrit)
        use NonLin_Datastructure_type
        use HHO_type
        integer :: list_func_acti(*)
        integer :: iter_newt, nume_inst
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: sddisc, sddyna, sdnume
        character(len=19) :: list_load, matass
        character(len=24) :: model, nume_dof, cara_elem
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_System), intent(in) :: ds_system
        character(len=24) :: sderro
        character(len=19) :: hval_veelem(*), hval_meelem(*)
        character(len=19) :: hval_measse(*), hval_veasse(*)
        character(len=19) :: hval_algo(*), hval_incr(*)
        type(HHO_Field), intent(in) :: hhoField
        type(NL_DS_Contact), intent(in) :: ds_contact
        aster_logical :: lerrit
    end subroutine nmfcor
end interface

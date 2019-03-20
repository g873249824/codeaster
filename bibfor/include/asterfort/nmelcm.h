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
    subroutine nmelcm(mesh           , model     ,&
                      ds_material    , ds_contact,&
                      ds_constitutive, ds_measure,&
                      hval_incr      , hval_algo ,&
                      matr_elem)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: mesh
        character(len=24), intent(in) :: model
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Contact), intent(in) :: ds_contact
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
        character(len=19), intent(out) :: matr_elem
    end subroutine nmelcm
end interface

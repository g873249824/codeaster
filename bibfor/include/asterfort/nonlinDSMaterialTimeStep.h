! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine nonlinDSMaterialTimeStep(model          , ds_material, cara_elem,&
                                        ds_constitutive, hval_incr  ,&
                                        nume_dof       , sddisc     , nume_inst)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model, cara_elem
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19), intent(in) :: hval_incr(*)
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: sddisc
        integer, intent(in) :: nume_inst
    end subroutine nonlinDSMaterialTimeStep
end interface

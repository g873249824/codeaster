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
    subroutine nonlinDSMaterialInit(model      , mate     , cara_elem,&
                                    compor     , hval_incr,&
                                    nume_dof   , time_init,&
                                    ds_material)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model, mate, cara_elem
        character(len=24), intent(in) :: compor
        character(len=19), intent(in) :: hval_incr(*)
        character(len=24), intent(in) :: nume_dof
        real(kind=8), intent(in) :: time_init
        type(NL_DS_Material), intent(inout) :: ds_material
    end subroutine nonlinDSMaterialInit
end interface

! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
!
interface
    subroutine cfmmco(ds_contact, i_zone, coef_type_, action, valr)
        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=*), intent(in) :: coef_type_
        character(len=1), intent(in) :: action
        integer, intent(in) :: i_zone
        real(kind=8), intent(inout) :: valr
    end subroutine cfmmco
end interface

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
    subroutine nmevcc(sddisc, nume_inst, ds_contact, i_echec, i_echec_acti)
        use NonLin_Datastructure_type
        character(len=19), intent(in) :: sddisc
        integer, intent(in) :: nume_inst
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer, intent(in) :: i_echec
        integer, intent(out) :: i_echec_acti
    end subroutine nmevcc
end interface

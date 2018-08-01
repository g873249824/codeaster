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
    subroutine dbr_calcpod_savel(ds_empi, nb_mode, nb_snap_redu, field_iden, nb_equa, s, v)
        use Rom_Datastructure_type
        type(ROM_DS_Empi), intent(in) :: ds_empi
        integer, intent(in) :: nb_mode
        integer, intent(in) :: nb_snap_redu
        character(len=24), intent(in) :: field_iden
        integer, intent(in) :: nb_equa
        real(kind=8), pointer :: v(:)
        real(kind=8), pointer :: s(:)
    end subroutine dbr_calcpod_savel
end interface

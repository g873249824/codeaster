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
    subroutine carc_save(mesh, carcri, nb_cmp, ds_compor_para)
        use Behaviour_type
        character(len=8), intent(in) :: mesh
        character(len=19), intent(in) :: carcri
        integer, intent(in) :: nb_cmp
        type(Behaviour_PrepCrit), intent(in) :: ds_compor_para
    end subroutine carc_save
end interface

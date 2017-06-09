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
    subroutine dimeco(sdcont      , model_ndim, nb_cont_zone, nb_cont_surf, nb_cont_elem,&
                      nb_cont_node)
        character(len=8), intent(in) :: sdcont
        integer, intent(in) :: model_ndim
        integer, intent(in) :: nb_cont_zone
        integer, intent(in) :: nb_cont_surf
        integer, intent(in) :: nb_cont_elem
        integer, intent(in) :: nb_cont_node
    end subroutine dimeco
end interface

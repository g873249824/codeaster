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
    subroutine romLineicIndexList(tole         ,&
                                  nb_node      , coor_node ,&
                                  nb_slice     , coor_slice,&
                                  node_to_slice)
        real(kind=8), intent(in) :: tole 
        integer, intent(in) :: nb_node
        real(kind=8), intent(in) :: coor_node(nb_node)
        integer, intent(in) :: nb_slice
        real(kind=8), intent(in) :: coor_slice(nb_slice)
        integer, intent(out) :: node_to_slice(nb_node)
    end subroutine romLineicIndexList
end interface

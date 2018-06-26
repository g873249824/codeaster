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
!
interface
    subroutine sele_node_elem(modelz       , nb_elem_type, list_elem_type, list_node,nb_node_found,&
                              pre_select_elem)
        character(len=*), intent(in) :: modelz
        integer, intent(in) :: nb_elem_type
        character(len=16), pointer :: list_elem_type(:)
        integer, pointer :: list_node(:)
        integer, intent(out) :: nb_node_found
        integer, pointer, optional :: pre_select_elem(:)
    end subroutine sele_node_elem
end interface

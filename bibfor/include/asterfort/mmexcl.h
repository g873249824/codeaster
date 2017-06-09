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
#include "asterf_types.h"
!
interface
    subroutine mmexcl(type_inte  , pair_type  , i_poin_elem, ndexfr,&
                      l_node_excl, l_excl_frot)
        integer, intent(in) :: type_inte
        integer, intent(in) :: pair_type
        integer, intent(in) :: i_poin_elem
        integer, intent(in) :: ndexfr
        aster_logical, intent(out) :: l_node_excl
        aster_logical, intent(out) :: l_excl_frot
    end subroutine mmexcl
end interface

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
#include "asterf_types.h"
!
interface
    subroutine romFieldGetInfo(model, field_name, field_refe, ds_field, l_chck_)
        use Rom_Datastructure_type
        character(len=8), intent(in)        :: model
        character(len=24), intent(in)       :: field_refe, field_name
        type(ROM_DS_Field), intent(inout)   :: ds_field
        aster_logical, optional, intent(in) :: l_chck_
    end subroutine romFieldGetInfo
end interface

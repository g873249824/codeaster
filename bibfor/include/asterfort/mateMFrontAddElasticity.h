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
#include "asterf_types.h"
!
interface
    subroutine mateMFrontAddElasticity(l_mfront_func, l_mfront_anis,&
                                       mate         , i_mate_add   ,&
                                       mfront_nbvale, mfront_prop  ,&
                                       mfront_valr  , mfront_valk)
        aster_logical, intent(in) :: l_mfront_func, l_mfront_anis
        character(len=8), intent(in) :: mate
        integer, intent(in) :: i_mate_add
        integer, intent(in) :: mfront_nbvale
        character(len=16), intent(in) :: mfront_prop(16)
        real(kind=8), intent(in) :: mfront_valr(16)
        character(len=16), intent(in) :: mfront_valk(16)
    end subroutine mateMFrontAddElasticity
end interface

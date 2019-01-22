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
    subroutine gapint(elem_dime     , l_axis          ,&
                      elem_slav_code, elem_slav_nbnode, elem_slav_coorO, elem_slav_coorN,&
                      elem_mast_code, elem_mast_nbnode, elem_mast_coorN,&
                      nb_poin_inte  , poin_inte       , poin_gaus_ma  ,&
                      gap_moy       , inte_weight)
        integer, intent(in) :: elem_dime
        aster_logical, intent(in) :: l_axis
        character(len=8), intent(in) :: elem_slav_code
        integer, intent(in) :: elem_slav_nbnode
        real(kind=8), intent(in) :: elem_slav_coorO(3,elem_slav_nbnode)
        real(kind=8), intent(in) :: elem_slav_coorN(3,elem_slav_nbnode)
        character(len=8), intent(in) :: elem_mast_code
        integer, intent(in) :: elem_mast_nbnode
        real(kind=8), intent(in) :: elem_mast_coorN(3,elem_mast_nbnode)
        integer, intent(in) :: nb_poin_inte
        real(kind=8), intent(in) :: poin_inte(elem_dime-1,nb_poin_inte)
        real(kind=8), intent(in) :: poin_gaus_ma(elem_dime-1,36)
        real(kind=8), intent(out) :: gap_moy
        real(kind=8), intent(out) :: inte_weight
    end subroutine gapint
end interface

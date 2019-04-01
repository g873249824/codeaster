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
    subroutine romGreedyAlgoInit(nb_mode, nb_vari_coef, vect_refe, ds_algoGreedy)
        use Rom_Datastructure_type
        integer, intent(in) :: nb_mode
        integer, intent(in) :: nb_vari_coef
        character(len=19), intent(in) :: vect_refe
        type(ROM_DS_AlgoGreedy), intent(in) :: ds_algoGreedy
    end subroutine romGreedyAlgoInit
end interface

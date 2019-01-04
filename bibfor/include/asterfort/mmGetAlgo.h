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
    subroutine mmGetAlgo(l_large_slip, ndexfr     , jeusup     , lambds,&
                         ialgoc      , ialgof     , i_reso_fric, i_reso_geom,&
                         l_pena_cont , l_pena_fric,&
                         lambds_prev_, jeu_prev_)
        aster_logical, intent(out) :: l_large_slip
        integer, intent(out) :: ndexfr
        real(kind=8), intent(out) :: jeusup
        real(kind=8), intent(out) :: lambds
        integer, intent(out) :: ialgoc, ialgof, i_reso_fric, i_reso_geom
        aster_logical, intent(out) :: l_pena_cont, l_pena_fric
        real(kind=8), optional, intent(out) :: lambds_prev_, jeu_prev_
    end subroutine mmGetAlgo
end interface

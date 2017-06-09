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
    subroutine dbr_pod_incr(l_reuse, nb_mode_maxi, ds_empi, ds_para_pod,&
                            q, s, v, nb_mode, nb_snap_redu)
        use Rom_Datastructure_type
        aster_logical, intent(in) :: l_reuse
        integer, intent(in) :: nb_mode_maxi
        type(ROM_DS_Empi), intent(inout) :: ds_empi
        type(ROM_DS_ParaDBR_POD) , intent(in) :: ds_para_pod
        real(kind=8), pointer, intent(inout) :: q(:)
        real(kind=8), pointer, intent(out)   :: s(:)
        real(kind=8), pointer, intent(out)   :: v(:)
        integer, intent(out) :: nb_mode
        integer, intent(out) :: nb_snap_redu
    end subroutine dbr_pod_incr
end interface

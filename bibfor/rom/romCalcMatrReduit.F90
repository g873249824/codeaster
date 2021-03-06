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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romCalcMatrReduit(i_mode, ds_empi, nb_matr, prod_matr_mode, matr_redu,&
                             mode_type)

use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mcmult.h"
#include "asterfort/mrmult.h"
#include "asterfort/romModeSave.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "blas/zdotc.h"
#include "blas/ddot.h"
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
integer, intent(in) :: nb_matr, i_mode
type(ROM_DS_Empi), intent(in) :: ds_empi
character(len=24), intent(in) :: matr_redu(:)
character(len=24), intent(in) :: prod_matr_mode(:)
character(len=1), intent(in) :: mode_type
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Compute reduced matrix
!
! --------------------------------------------------------------------------------------------------
!
! In  i_mode           : mode nomber
! In  nb_matr          : number of elementary matrix
! In  mode_type        : type of mode  (R or C) 
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_mode_curr
    integer :: nb_mode_maxi, nb_equa, i_equa
    integer :: i_matr, j_mode, iret
    character(len=24) :: field_iden
    character(len=8) :: base
    complex(kind=8) :: termc
    real(kind=8) :: termr
    character(len=19) :: mode
    complex(kind=8), pointer :: vc_mode(:) => null()
    real(kind=8), pointer :: vr_mode(:) => null()
    complex(kind=8), pointer :: vc_matr_red(:) => null()
    real(kind=8), pointer :: vr_matr_red(:) => null()
    complex(kind=8), pointer :: vc_matr_mode(:) => null()
    complex(kind=8), pointer :: vc_matr_jmode(:) => null()
    real(kind=8), pointer :: vr_matr_mode(:) => null()
    real(kind=8), pointer :: vr_matr_jmode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    base           = ds_empi%base
    nb_mode_maxi   = ds_empi%nb_mode_maxi
    nb_equa        = ds_empi%ds_mode%nb_equa
    i_mode_curr    = i_mode
!
! - Get acess to mode_current
!
    field_iden = 'DEPL'
    call rsexch(' ', base, field_iden, i_mode_curr, mode, iret)
    
    if (mode_type .eq. 'R') then 
        call jeveuo(mode(1:19)//'.VALE', 'L', vr = vr_mode)
    else if (mode_type .eq. 'C') then 
        call jeveuo(mode(1:19)//'.VALE', 'L', vc = vc_mode)
    else 
        ASSERT(ASTER_FALSE)
    end if
!
! - Get acess to product Matrix x Mode and Compute reduced matrix
!
    if (mode_type .eq. 'R') then
        do i_matr = 1, nb_matr
           call jeveuo(matr_redu(i_matr), 'E', vr = vr_matr_red)
           call jeveuo(prod_matr_mode(i_matr), 'L', vr = vr_matr_mode)
           do j_mode = 1, i_mode_curr
              AS_ALLOCATE(vr = vr_matr_jmode, size=nb_equa)
              do i_equa = 1, nb_equa
                 vr_matr_jmode(i_equa) = vr_matr_mode(i_equa+nb_equa*(j_mode-1))
              end do
              termr = ddot(nb_equa, vr_mode, 1, vr_matr_jmode, 1)
              vr_matr_red(nb_mode_maxi*(i_mode_curr-1)+j_mode) = termr
              vr_matr_red(nb_mode_maxi*(j_mode-1)+i_mode_curr) = termr
              AS_DEALLOCATE(vr = vr_matr_jmode)
           end do
        end do 
    else if (mode_type .eq. 'C') then
        do i_matr = 1, nb_matr
           call jeveuo(matr_redu(i_matr), 'E', vc = vc_matr_red)
           call jeveuo(prod_matr_mode(i_matr), 'L', vc = vc_matr_mode)
           do j_mode = 1, i_mode_curr
              AS_ALLOCATE(vc = vc_matr_jmode, size=nb_equa)
              do i_equa = 1, nb_equa
                 vc_matr_jmode(i_equa) = vc_matr_mode(i_equa+nb_equa*(j_mode-1))
              end do
              termc = zdotc(nb_equa, vc_mode, 1, vc_matr_jmode, 1)
              vc_matr_red(nb_mode_maxi*(i_mode_curr-1)+j_mode) = termc
              vc_matr_red(nb_mode_maxi*(j_mode-1)+i_mode_curr) = dconjg(termc)
              AS_DEALLOCATE(vc = vc_matr_jmode)
           end do
        end do 
    else
        ASSERT(ASTER_FALSE)
    end if
!
end subroutine

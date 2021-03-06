! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine dbr_pod_incr(l_reuse, ds_empi, ds_para_pod,&
                        q, s, v, nb_mode, nb_snap_redu)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/norm_frobenius.h"
#include "asterfort/dbr_calcpod_svd2.h"
#include "asterfort/dbr_calcpod_sele.h"
#include "asterfort/romTableSave.h"
#include "asterfort/romTableCreate.h"
#include "asterfort/romBaseGetInfo.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbexve.h"
#include "asterfort/jeveuo.h"
#include "asterfort/tbSuppressAllLines.h"
#include "asterfort/rsexch.h"
#include "blas/dgemm.h"
#include "blas/dgesv.h"
#include "blas/dgesvd.h"
#include "asterc/r8prem.h"
!
aster_logical, intent(in) :: l_reuse
type(ROM_DS_Empi), intent(inout) :: ds_empi
type(ROM_DS_ParaDBR_POD) , intent(in) :: ds_para_pod
real(kind=8), pointer :: q(:)
real(kind=8), pointer :: s(:)
real(kind=8), pointer :: v(:)
integer, intent(out) :: nb_mode
integer, intent(out) :: nb_snap_redu
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Incremental POD method
!
! --------------------------------------------------------------------------------------------------
!
! In  l_reuse          : .true. if reuse
! IO  ds_empi          : datastructure for empiric modes
! In  ds_para_pod      : datastructure for parameters (POD)
! IO  q                : pointer to snapshots matrix (be modified after SVD)
! Out s                : singular values
! Out v                : singular vectors
! Out nb_mode          : number of modes selected
! Out nb_snap_redu     : number of snapshots used in incremental algorithm
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: incr_ini, incr_end, i_equa, i_snap, p, i_incr, k, i_mode
    integer :: nb_equa, nb_snap, nb_sing, nb_mode_maxi
    real(kind=8) :: tole_incr, tole_svd
    character(len=8)  :: base_type, base
    real(kind=8) :: norm_q, norm_r
    integer(kind=4) :: info
    real(kind=8), pointer :: qi(:)   => null()
    real(kind=8), pointer :: ri(:)   => null()
    real(kind=8), pointer :: rt(:)   => null()
    real(kind=8), pointer :: vt(:)   => null()
    real(kind=8), pointer :: g(:)    => null()
    real(kind=8), pointer :: gt(:)   => null()
    real(kind=8), pointer :: kv(:)   => null()
    real(kind=8), pointer :: kt(:)   => null()
    integer(kind=4), pointer :: IPIV(:) => null()
    real(kind=8), pointer :: b(:)    => null()
    real(kind=8), pointer :: v_gamma(:)    => null()
    aster_logical :: l_tabl_user
    character(len=19) :: tabl_user, tabl_coor
    character(len=24) :: typval
    integer :: nbval, iret
    real(kind=8), pointer :: v_gm(:) => null()
    character(len=24) :: mode
    real(kind=8), pointer :: v_mode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters
!
    mode         = '&&IPOD_MODE'
    nb_equa      = ds_empi%ds_mode%nb_equa
    nb_mode_maxi = ds_para_pod%nb_mode_maxi
    base         = ds_empi%base
    tabl_coor    = ds_empi%tabl_coor
    base_type    = ds_para_pod%base_type
    nb_snap      = ds_para_pod%ds_snap%nb_snap
    tole_incr    = ds_para_pod%tole_incr
    tole_svd     = ds_para_pod%tole_svd
    tabl_user    = ds_para_pod%tabl_user
    l_tabl_user  = ds_para_pod%l_tabl_user
    ASSERT(base_type .eq. '3D')
!
! - Allocate objects
!
    AS_ALLOCATE(vr = qi, size = nb_equa)
    AS_ALLOCATE(vr = ri, size = nb_equa)
    AS_ALLOCATE(vr = rt, size = nb_equa)
    if (l_reuse) then
        if (l_tabl_user) then
            call tbexve(tabl_user, 'COOR_REDUIT', '&&COORHR', 'V', nbval, typval)
        else
            call tbexve(tabl_coor, 'COOR_REDUIT', '&&COORHR', 'V', nbval, typval)
        endif
        call jeveuo('&&COORHR', 'E', vr = v_gm)
        call tbSuppressAllLines(tabl_coor)
        AS_ALLOCATE(vr = vt, size = nb_equa*(nb_snap+ds_empi%nb_mode))
        AS_ALLOCATE(vr = gt, size = (nb_snap+ds_empi%nb_mode)*(nb_snap+ds_empi%nb_snap))
        AS_ALLOCATE(vr = g , size = (nb_snap+ds_empi%nb_mode)*(nb_snap+ds_empi%nb_snap))
    else
        AS_ALLOCATE(vr = vt, size = nb_equa*nb_snap)
        AS_ALLOCATE(vr = gt, size = nb_snap*nb_snap)
        AS_ALLOCATE(vr = g , size = nb_snap*nb_snap)
    endif
!
! - Initialize algorithm
!
    if (l_reuse) then
        do i_mode = 1, ds_empi%nb_mode
            call rsexch(' ', ds_empi%base, ds_empi%ds_mode%field_name, i_mode, mode, iret)
            call jeveuo(mode(1:19)//'.VALE', 'E', vr = v_mode)
            do i_equa = 1, nb_equa
                vt(i_equa+nb_equa*(i_mode-1)) = v_mode(i_equa)
            end do
        enddo
        do i_equa = 1, ds_empi%nb_mode*ds_empi%nb_snap
            gt(i_equa) = v_gm(i_equa)
        enddo
    else
        qi(1:nb_equa) = q(1:nb_equa)
        call norm_frobenius(nb_equa, qi, norm_q)
        if (norm_q .le. r8prem()) then
            norm_q = 1.d-16*sqrt(nb_equa*1.d0)
            vt(1:nb_equa) = 1.d0/sqrt(nb_equa*1.d0)
        else
            vt(1:nb_equa) = qi(1:nb_equa)/norm_q
        endif
        vt(1:nb_equa) = qi(1:nb_equa)/norm_q
        gt(1)         = norm_q
    endif
!
    if (l_reuse) then
        p        = ds_empi%nb_mode
        incr_ini = ds_empi%nb_snap+1
        incr_end = nb_snap+ds_empi%nb_snap
    else
        p        = 1
        incr_ini = 2
        incr_end = nb_snap
    endif
!
! - Main algorithm
!
    do i_incr = incr_ini, incr_end
! ----- Get current snapshot for matrix of snapshots
        if (l_reuse) then
            do i_equa = 1, nb_equa
                qi(i_equa) = q(i_equa+nb_equa*(i_incr-ds_empi%nb_snap-1))
            enddo
        else
            do i_equa = 1, nb_equa
                qi(i_equa) = q(i_equa+nb_equa*(i_incr-1))
            enddo
        endif
! ----- Compute norm of current snapshot
        call norm_frobenius(nb_equa, qi, norm_q)
        if (norm_q .le. r8prem()) then
            cycle
        endif
! ----- Compute kt = v^T q (projection of current snaphot on empiric base)
        AS_ALLOCATE(vr  = kt  , size = p)
        call dgemm('T', 'N', p, 1, nb_equa, 1.d0,&
                   vt, nb_equa,&
                   qi, nb_equa,&
                   0.d0, kt, p)
! ----- Compute kv = v^T v
        AS_ALLOCATE(vr  = kv  , size = p*p)
        call dgemm('T', 'N', p, p, nb_equa, 1.d0,&
                   vt, nb_equa,&
                   vt, nb_equa,&
                   0.d0, kv, p)
! ----- Make SVD on kv x singu = kt
        AS_ALLOCATE(vi4 = IPIV, size = p)
        call dgesv(p, 1, kv, p, IPIV, kt, p, info)
! ----- Compute residu r = v kt
        call dgemm('N', 'N', nb_equa, 1, p, 1.d0,&
                   vt, nb_equa,&
                   kt, p,&
                   0.d0, rt, nb_equa)
        ri = qi - rt
! ----- Compute norm of residu
        call norm_frobenius(nb_equa, ri, norm_r)
! ----- Select vector or not ?
        if (norm_r/norm_q .ge. tole_incr) then
            do i_equa = 1, nb_equa
                vt(i_equa+nb_equa*p) = ri(i_equa)/norm_r
            enddo
            do i_snap = 1, p
                g(i_snap+(p+1)*(i_incr-1)) = kt(i_snap)
                do k = 1, i_incr-1
                    g(i_snap+(p+1)*(k-1))= gt(i_snap+p*(k-1))
                enddo
            enddo
            do k = 1, i_incr-1
                g((p+1)*k)= 0.d0
            enddo
            p = p +1
            g(p*i_incr)=norm_r
            do k = 1, p*i_incr
                gt(k) = g(k)
            enddo
        else
            do i_snap = 1, p
                gt(i_snap+p*(i_incr-1)) = kt(i_snap)
            enddo
        endif
        AS_DEALLOCATE(vr = kt)
        AS_DEALLOCATE(vr = kv)
        AS_DEALLOCATE(vi4 = IPIV)
    enddo
!
! - Deallocate objects
!
    AS_DEALLOCATE(vr = qi)
    AS_DEALLOCATE(vr = ri)
    AS_DEALLOCATE(vr = rt)
!
! - Prepare matrix
!
    do i_equa = 1, p*incr_end
        g(i_equa) = gt(i_equa)
    end do
!
! - Compute SVD: Q = V S Wt
!
    call dbr_calcpod_svd2(p, incr_end, g, s, b, nb_sing)
!
! - Select empiric modes
!
    call dbr_calcpod_sele(nb_mode_maxi, tole_svd, s, nb_sing, nb_mode)
!
! - Compute matrix V
!
    AS_ALLOCATE(vr = v, size = nb_equa*nb_mode)
    call dgemm('N', 'N', nb_equa, nb_mode, p, 1.d0,&
               vt, nb_equa,&
               b, p,&
               0.d0, v, nb_equa)
!
! - Compute reduced coordinates
!
    AS_ALLOCATE(vr = v_gamma, size = nb_mode*incr_end)
    call dgemm('T', 'N', nb_mode, incr_end, p, 1.d0,&
               b, p,&
               gt, p,&
               0.d0, v_gamma, nb_mode)
!
! - Save the reduced coordinates in a table
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_39', ni = 2, vali = [incr_end, nb_mode])
    endif
    do i_snap = 1, incr_end
        call romTableSave(tabl_coor, nb_mode, v_gamma   ,&
                          nume_snap_ = i_snap)
    end do
!
! - Number of snapshots in empiric base
!
    nb_snap_redu = incr_end
    call utmess('I', 'ROM7_14', si = nb_snap_redu)
!
! - Clean
!
    AS_DEALLOCATE(vr = v_gamma)
    AS_DEALLOCATE(vr = vt)
    AS_DEALLOCATE(vr = gt)
    AS_DEALLOCATE(vr = g)
    AS_DEALLOCATE(vr = b)
!
end subroutine

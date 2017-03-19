!
! COPYRIGHT (C) 1991 - 2017  EDF R&D                WWW.CODE-ASTER.ORG
!
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
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

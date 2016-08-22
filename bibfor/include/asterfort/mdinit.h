! COPYRIGHT (C) 1991 - 2016  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine mdinit(basemo, nbmode, nbnoli, depgen, vitgen,&
                      vint, ier, tinit, reprise, accgen,&
                      index)
        character(len=8) :: basemo
        integer :: nbmode
        integer :: nbnoli
        real(kind=8) :: depgen(*)
        real(kind=8) :: vitgen(*)
        real(kind=8), pointer :: vint(:)
        integer :: ier
        real(kind=8) :: tinit
        aster_logical, optional, intent(out) :: reprise
        real(kind=8), optional, intent(out) :: accgen(*)
        integer, optional, intent(out) :: index
    end subroutine mdinit
end interface

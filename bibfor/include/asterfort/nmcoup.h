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
! aslint: disable=W1504
!
interface
    subroutine nmcoup(fami, kpg, ksp, ndim, typmod,&
                      imat, compor, mult_comp, lcpdb, carcri, timed,&
                      timef, neps, epsdt, depst, nsig,&
                      sigd, vind, option, angmas, nwkin,&
                      wkin, sigf, vinf, ndsde, dsde,&
                      nwkout, wkout, iret)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        integer :: ndim
        character(len=8) :: typmod(*)
        integer :: imat
        character(len=16), intent(in) :: compor(*)
        character(len=16), intent(in) :: mult_comp
        real(kind=8), intent(in) :: carcri(*)
        aster_logical :: lcpdb
        real(kind=8) :: timed
        real(kind=8) :: timef
        integer :: neps
        real(kind=8) :: epsdt(*)
        real(kind=8) :: depst(*)
        integer :: nsig
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(*)
        character(len=16) :: option
        real(kind=8) :: angmas(*)
        integer :: nwkin
        real(kind=8) :: wkin(*)
        real(kind=8) :: sigf(6)
        real(kind=8) :: vinf(*)
        integer :: ndsde
        real(kind=8) :: dsde(*)
        integer :: nwkout
        real(kind=8) :: wkout(*)
        integer :: iret
    end subroutine nmcoup
end interface

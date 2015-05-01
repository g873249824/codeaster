!
! COPYRIGHT (C) 1991 - 2015  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine cfapma(noma, newgeo, defico, resoco, lctfd,&
                      lctf3d, ndimg, izone, posnoe, numnoe,&
                      coorne, posmam, ksipr1, ksipr2, tau1m,&
                      tau2m, iliai)
        character(len=8) :: noma
        character(len=19) :: newgeo
        character(len=24) :: defico
        character(len=24) :: resoco
        aster_logical :: lctfd
        aster_logical :: lctf3d
        integer :: ndimg
        integer :: izone
        integer :: posnoe
        integer :: numnoe
        real(kind=8) :: coorne(3)
        integer :: posmam
        real(kind=8) :: ksipr1
        real(kind=8) :: ksipr2
        real(kind=8) :: tau1m(3)
        real(kind=8) :: tau2m(3)
        integer :: iliai
    end subroutine cfapma
end interface

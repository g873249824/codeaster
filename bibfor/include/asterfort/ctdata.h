!
! COPYRIGHT (C) 1991 - 2013  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine ctdata(mesnoe, mesmai, nkcha, tych, toucmp,&
                      nkcmp, nbcmp, ndim, chpgs, noma,&
                      nbno, nbma, nbval, tsca)
        character(len=24) :: mesnoe
        character(len=24) :: mesmai
        character(len=24) :: nkcha
        character(len=4) :: tych
        aster_logical :: toucmp
        character(len=24) :: nkcmp
        integer :: nbcmp
        integer :: ndim
        character(len=19) :: chpgs
        character(len=8) :: noma
        integer :: nbno
        integer :: nbma
        integer :: nbval
        character(len=1) :: tsca
    end subroutine ctdata
end interface

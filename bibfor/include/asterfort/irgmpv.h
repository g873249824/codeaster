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
    subroutine irgmpv(ifi, lresu, nomcon, chamsy, nbordr,&
                      para, nocmp, nbel, scal, vect,&
                      tens, versio)
        integer :: ifi
        aster_logical :: lresu
        character(len=*) :: nomcon
        character(len=*) :: chamsy
        integer :: nbordr
        real(kind=8) :: para(*)
        character(len=8) :: nocmp
        integer :: nbel(*)
        aster_logical :: scal
        aster_logical :: vect
        aster_logical :: tens
        integer :: versio
    end subroutine irgmpv
end interface

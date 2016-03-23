!
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
    subroutine rc3201(lpmpb, lsn, lsnet, lfatig, lrocht,&
                      lieu, ig, iocs, seisme, yapass,&
                      mater, utot, utotenv,&
                      resuas, resuss, resuca, resucs,&
                      factus, fatiguenv, resufin)
        aster_logical :: lpmpb
        aster_logical :: lsn
        aster_logical :: lsnet
        aster_logical :: lfatig
        aster_logical :: lrocht
        character(len=4) :: lieu
        integer :: ig
        integer :: iocs
        aster_logical :: seisme
        aster_logical :: yapass
        character(len=8) :: mater
        real(kind=8) :: utot
        real(kind=8) :: utotenv
        real(kind=8) :: resuas(*)
        real(kind=8) :: resuss(*)
        real(kind=8) :: resuca(*)
        real(kind=8) :: resucs(*)
        real(kind=8) :: factus(*)
        aster_logical :: fatiguenv
        real(kind=8) :: resufin(*)
    end subroutine rc3201
end interface

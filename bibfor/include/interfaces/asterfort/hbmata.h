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
interface
    subroutine hbmata(se, dg, etap, i1e, sigeqe,&
                      vp, vecp, parame, derive, sig3,&
                      detadg, dgdl, nbmat, materf, dsidep)
        integer :: nbmat
        real(kind=8) :: se(6)
        real(kind=8) :: dg
        real(kind=8) :: etap
        real(kind=8) :: i1e
        real(kind=8) :: sigeqe
        real(kind=8) :: vp(3)
        real(kind=8) :: vecp(3, 3)
        real(kind=8) :: parame(4)
        real(kind=8) :: derive(5)
        real(kind=8) :: sig3
        real(kind=8) :: detadg
        real(kind=8) :: dgdl
        real(kind=8) :: materf(nbmat, 2)
        real(kind=8) :: dsidep(6, 6)
    end subroutine hbmata
end interface

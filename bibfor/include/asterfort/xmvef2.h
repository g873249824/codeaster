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
interface
    subroutine xmvef2(ndim, nno, nnos, ffp, jac,&
                      seuil, reac12, singu, fk, nfh,&
                      coeffp, coeffr, mu, algofr, nd,&
                      ddls, ddlm, idepl, pb, vtmp)
        integer :: ndim
        integer :: nno
        integer :: nnos
        real(kind=8) :: ffp(27)
        real(kind=8) :: jac
        real(kind=8) :: seuil
        real(kind=8) :: reac12(3)
        integer :: singu
        integer :: nfh
        real(kind=8) :: coeffp
        real(kind=8) :: coeffr
        real(kind=8) :: mu
        integer :: algofr
        real(kind=8) :: nd(3)
        integer :: ddls
        integer :: ddlm
        integer :: idepl
        real(kind=8) :: pb(3)
        real(kind=8) :: vtmp(400)
        real(kind=8) :: fk(27,3,3)
    end subroutine xmvef2
end interface

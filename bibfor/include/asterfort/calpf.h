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
    subroutine calpf(ndim, nno, axi, npg, geomm,&
                     g, iw, vff, idff, depld,&
                     grand, alpha, r, dff, fd,&
                     deplda, fda)
        integer :: npg
        integer :: nno
        integer :: ndim
        logical(kind=1) :: axi
        real(kind=8) :: geomm(ndim, nno)
        integer :: g
        integer :: iw
        real(kind=8) :: vff(nno, npg)
        integer :: idff
        real(kind=8) :: depld(3*27)
        logical(kind=1) :: grand
        real(kind=8) :: alpha
        real(kind=8) :: r
        real(kind=8) :: dff(nno, ndim)
        real(kind=8) :: fd(3, 3)
        real(kind=8) :: deplda(3*27)
        real(kind=8) :: fda(3, 3)
    end subroutine calpf
end interface

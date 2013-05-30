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
    subroutine optimw(method, nrupt, x, y, prob,&
                      sigw, nt, nur, nbres, calm,&
                      cals, mk, sk, mkp, skp,&
                      impr, ifm, dept, indtp, nbtp)
        character(len=16) :: method
        integer :: nrupt
        real(kind=8) :: x(*)
        real(kind=8) :: y(*)
        real(kind=8) :: prob(*)
        real(kind=8) :: sigw(*)
        integer :: nt(*)
        integer :: nur(*)
        integer :: nbres
        logical :: calm
        logical :: cals
        real(kind=8) :: mk
        real(kind=8) :: sk(*)
        real(kind=8) :: mkp
        real(kind=8) :: skp(*)
        logical :: impr
        integer :: ifm
        logical :: dept
        integer :: indtp(*)
        integer :: nbtp
    end subroutine optimw
end interface

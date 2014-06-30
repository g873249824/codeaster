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
    subroutine xmmab0(ndim, nnc, jnne, nfaes, jpcai,&
                      hpg, ffc, jacobi, coefcr, lpenac,&
                      typmai, cface, tau1, tau2, jddle,&
                      nconta, nfhe, lmulti, heavno, mmat)
        integer :: ndim
        integer :: nnc
        integer :: jnne(3)
        integer :: nfaes
        integer :: jpcai
        real(kind=8) :: hpg
        real(kind=8) :: ffc(8)
        real(kind=8) :: jacobi
        real(kind=8) :: coefcr
        logical(kind=1) :: lpenac
        character(len=8) :: typmai
        integer :: cface(5, 3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        integer :: jddle(2)
        integer :: nconta
        integer :: nfhe
        logical(kind=1) :: lmulti
        integer :: heavno(8)
        real(kind=8) :: mmat(336, 336)
    end subroutine xmmab0
end interface

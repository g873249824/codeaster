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
    subroutine mmmtuu(phasep, lnewtg, ndim, nne, nnm,&
                      mprojn, mprojt, wpg, ffe, ffm,&
                      dffm, jacobi, coefac, coefaf, coefff,&
                      rese, nrese, lambda, jeu, dlagrc,&
                      h11t1n, h12t2n, h21t1n, h22t2n, matree,&
                      matrmm, matrem, matrme)
        character(len=9) :: phasep
        logical :: lnewtg
        integer :: ndim
        integer :: nne
        integer :: nnm
        real(kind=8) :: mprojn(3, 3)
        real(kind=8) :: mprojt(3, 3)
        real(kind=8) :: wpg
        real(kind=8) :: ffe(9)
        real(kind=8) :: ffm(9)
        real(kind=8) :: dffm(2, 9)
        real(kind=8) :: jacobi
        real(kind=8) :: coefac
        real(kind=8) :: coefaf
        real(kind=8) :: coefff
        real(kind=8) :: rese(3)
        real(kind=8) :: nrese
        real(kind=8) :: lambda
        real(kind=8) :: jeu
        real(kind=8) :: dlagrc
        real(kind=8) :: h11t1n(3, 3)
        real(kind=8) :: h12t2n(3, 3)
        real(kind=8) :: h21t1n(3, 3)
        real(kind=8) :: h22t2n(3, 3)
        real(kind=8) :: matree(27, 27)
        real(kind=8) :: matrmm(27, 27)
        real(kind=8) :: matrem(27, 27)
        real(kind=8) :: matrme(27, 27)
    end subroutine mmmtuu
end interface

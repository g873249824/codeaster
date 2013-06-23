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
    subroutine lceob3(intmax, tole, eps, bm, dm,&
                      lambda, mu, alpha, ecrob, ecrod,&
                      seuil, bdim, b, d, mult,&
                      elas, dbloq, iret)
        integer :: intmax
        real(kind=8) :: tole
        real(kind=8) :: eps(6)
        real(kind=8) :: bm(6)
        real(kind=8) :: dm
        real(kind=8) :: lambda
        real(kind=8) :: mu
        real(kind=8) :: alpha
        real(kind=8) :: ecrob
        real(kind=8) :: ecrod
        real(kind=8) :: seuil
        integer :: bdim
        real(kind=8) :: b(6)
        real(kind=8) :: d
        real(kind=8) :: mult
        logical :: elas
        logical :: dbloq
        integer :: iret
    end subroutine lceob3
end interface

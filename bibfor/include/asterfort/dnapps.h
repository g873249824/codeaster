!
! COPYRIGHT (C) 1991 - 2015  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine dnapps(n, kev, np, shiftr, shifti,&
                      v, ldv, h, ldh, resid,&
                      q, ldq, workl, workd)
        integer :: ldq
        integer :: ldh
        integer :: ldv
        integer :: np
        integer :: kev
        integer :: n
        real(kind=8) :: shiftr(np)
        real(kind=8) :: shifti(np)
        real(kind=8) :: v(ldv, kev+np)
        real(kind=8) :: h(ldh, kev+np)
        real(kind=8) :: resid(n)
        real(kind=8) :: q(ldq, kev+np)
        real(kind=8) :: workl(kev+np)
        real(kind=8) :: workd(2*n)
    end subroutine dnapps
end interface

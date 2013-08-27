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
    function calor(mdal, t, dt, deps, dp1,&
                   dp2, signe, alp11, alp12, coeps,&
                   ndim)
        integer :: ndim
        real(kind=8) :: mdal(2*ndim)
        real(kind=8) :: t
        real(kind=8) :: dt
        real(kind=8) :: deps(6)
        real(kind=8) :: dp1
        real(kind=8) :: dp2
        real(kind=8) :: signe
        real(kind=8) :: alp11
        real(kind=8) :: alp12
        real(kind=8) :: coeps
        real(kind=8) :: calor_0
    end function calor
end interface 

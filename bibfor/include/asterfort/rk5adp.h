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
    subroutine rk5adp(nbeq, param, t0, dt0, nbmax,&
                      errmax, y0, dy0, rkfct, resu,&
                      iret)
        integer :: nbeq
        real(kind=8) :: param(*)
        real(kind=8) :: t0
        real(kind=8) :: dt0
        integer :: nbmax
        real(kind=8) :: errmax
        real(kind=8) :: y0(nbeq)
        real(kind=8) :: dy0(nbeq)
        real(kind=8) :: resu(2*nbeq)
        integer :: iret
        interface
            subroutine rkfct(pp, nbeq, yy0, dy0, dyy,&
                             decoup)
                integer :: nbeq
                real(kind=8) :: pp(*)
                real(kind=8) :: yy0(nbeq)
                real(kind=8) :: dy0(nbeq)
                real(kind=8) :: dyy(nbeq)
                logical(kind=1) :: decoup
            end subroutine rkfct
        end interface
    end subroutine rk5adp
end interface

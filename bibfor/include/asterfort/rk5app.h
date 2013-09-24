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
    subroutine rk5app(nbeq, vparam, dtemps, yinit, dyinit,&
                rkfct, solu, decoup)
        integer :: nbeq
        real(kind=8) :: vparam(*)
        real(kind=8) :: dtemps
        real(kind=8) :: yinit(nbeq)
        real(kind=8) :: dyinit(nbeq)
        real(kind=8) :: solu(3*nbeq)
        logical :: decoup
        interface
            subroutine rkfct(pp, nbeq, yy0, dy0, dyy,&
                             decoup)
                integer :: nbeq
                real(kind=8) :: pp(*)
                real(kind=8) :: yy0(nbeq)
                real(kind=8) :: dy0(nbeq)
                real(kind=8) :: dyy(nbeq)
                logical :: decoup
            end subroutine rkfct
        end interface
    end subroutine rk5app
end interface


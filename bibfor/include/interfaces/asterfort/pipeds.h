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
    subroutine pipeds(ndim, typmod, tau, mate, vim,&
                      epsm, epspc, epsdc, etamin, etamax,&
                      a0, a1, a2, a3, etas)
        integer :: ndim
        character(len=8) :: typmod(*)
        real(kind=8) :: tau
        integer :: mate
        real(kind=8) :: vim(2)
        real(kind=8) :: epsm(6)
        real(kind=8) :: epspc(6)
        real(kind=8) :: epsdc(6)
        real(kind=8) :: etamin
        real(kind=8) :: etamax
        real(kind=8) :: a0
        real(kind=8) :: a1
        real(kind=8) :: a2
        real(kind=8) :: a3
        real(kind=8) :: etas
    end subroutine pipeds
end interface

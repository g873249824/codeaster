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
    subroutine nmiclb(fami, kpg, ksp, option, compor,&
                      imate, xlong0, a, tmoins, tplus,&
                      dlong0, effnom, vim, effnop, vip,&
                      klv, fono, epsm, crildc, codret)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=16) :: option
        character(len=16) :: compor(*)
        integer :: imate
        real(kind=8) :: xlong0
        real(kind=8) :: a
        real(kind=8) :: tmoins
        real(kind=8) :: tplus
        real(kind=8) :: dlong0
        real(kind=8) :: effnom
        real(kind=8) :: vim(*)
        real(kind=8) :: effnop
        real(kind=8) :: vip(*)
        real(kind=8) :: klv(21)
        real(kind=8) :: fono(6)
        real(kind=8) :: epsm
        real(kind=8) :: crildc(3)
        integer :: codret
    end subroutine nmiclb
end interface

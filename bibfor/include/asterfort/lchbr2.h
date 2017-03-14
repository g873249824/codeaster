!
! COPYRIGHT (C) 1991 - 2017  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine lchbr2(typmod, option, imate, carcri, sigm,&
                      epsm, depsm,&
                      vim, vip, dspdp1, dspdp2, sipp,&
                      sigp, dsidep, dsidp1, dsidp2, iret)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        integer :: imate
        real(kind=8) :: carcri(*)
        real(kind=8) :: sigm(6)
        real(kind=8) :: epsm(6)
        real(kind=8) :: depsm(6)
        real(kind=8) :: vim(*)
        real(kind=8) :: vip(*)
        real(kind=8) :: dspdp1
        real(kind=8) :: dspdp2
        real(kind=8) :: sipp
        real(kind=8) :: sigp(6)
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: dsidp1(6)
        real(kind=8) :: dsidp2(6)
        integer :: iret
    end subroutine lchbr2
end interface

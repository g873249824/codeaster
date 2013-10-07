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
    subroutine tbextb(tabin, basout, tabout, npacri, lipacr,&
                      lcrpa, vi, vr, vc, vk,&
                      lprec, lcrit, iret)
        character(len=*) :: tabin
        character(len=*) :: basout
        character(len=*) :: tabout
        integer :: npacri
        character(len=*) :: lipacr(*)
        character(len=*) :: lcrpa(*)
        integer :: vi(*)
        real(kind=8) :: vr(*)
        complex(kind=8) :: vc(*)
        character(len=*) :: vk(*)
        real(kind=8) :: lprec(*)
        character(len=*) :: lcrit(*)
        integer :: iret
    end subroutine tbextb
end interface

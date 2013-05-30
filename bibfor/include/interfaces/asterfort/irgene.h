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
    subroutine irgene(iocc, resu, form, ifi, nbnosy,&
                      nosy, nbcmpg, cmpg, nbpara, para,&
                      nbordr, ordr, nbdisc, disc, nume,&
                      lhist)
        integer :: iocc
        character(*) :: resu
        character(*) :: form
        integer :: ifi
        integer :: nbnosy
        character(*) :: nosy(*)
        integer :: nbcmpg
        integer :: cmpg(*)
        integer :: nbpara
        character(*) :: para(*)
        integer :: nbordr
        integer :: ordr(*)
        integer :: nbdisc
        real(kind=8) :: disc(*)
        integer :: nume(*)
        logical :: lhist
    end subroutine irgene
end interface

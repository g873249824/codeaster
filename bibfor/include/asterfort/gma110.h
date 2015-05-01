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
    subroutine gma110(nbgr, exclu, nbgrut, mailla, nomsst,&
                      nbtgrm, nomres, nbincr, tabsgr, tabsst,&
                      tabgma, tabnom)
        integer :: nbgr
        character(len=8) :: exclu
        integer :: nbgrut
        character(len=8) :: mailla
        character(len=8) :: nomsst
        integer :: nbtgrm
        character(len=8) :: nomres
        integer :: nbincr
        character(len=24) :: tabsgr(*)
        character(len=8) :: tabsst(*)
        character(len=24) :: tabgma(*)
        character(len=24) :: tabnom(*)
    end subroutine gma110
end interface

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
    subroutine modint(ssami, raiint, nddlin, nbmod, shift,&
                      matmod, masse, raide, neq, coint,&
                      noddli, nnoint, vefreq, switch)
        character(len=19) :: ssami
        character(len=19) :: raiint
        integer :: nddlin
        integer :: nbmod
        real(kind=8) :: shift
        character(len=24) :: matmod
        character(len=19) :: masse
        character(len=19) :: raide
        integer :: neq
        character(len=24) :: coint
        character(len=24) :: noddli
        integer :: nnoint
        character(len=24) :: vefreq
        integer :: switch
    end subroutine modint
end interface

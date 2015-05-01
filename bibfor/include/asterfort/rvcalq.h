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
    subroutine rvcalq(iocc, sdeval, vec1, vec2, repere,&
                      nomcp, nbcpnc, nbcpcd, option, quant,&
                      sdlieu, codir, valdir, sdcalq, courbe)
        integer :: iocc
        character(len=24) :: sdeval
        real(kind=8) :: vec1(*)
        real(kind=8) :: vec2(*)
        character(len=8) :: repere
        character(len=8) :: nomcp(*)
        integer :: nbcpnc
        integer :: nbcpcd
        character(len=16) :: option
        character(len=24) :: quant
        character(len=24) :: sdlieu
        integer :: codir
        real(kind=8) :: valdir(*)
        character(len=19) :: sdcalq
        character(len=8) :: courbe
    end subroutine rvcalq
end interface

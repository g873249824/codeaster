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
    subroutine nmext3(noma, champ, nomcha, nomchs, nbcmp,&
                      nbma, nbpi, nbspi, extrga, extrch,&
                      extrcp, listma, listpi, listsp, listcp,&
                      chgaus, chelga)
        character(len=8) :: noma
        character(len=19) :: champ
        character(len=24) :: nomcha
        character(len=24) :: nomchs
        integer :: nbcmp
        integer :: nbma
        integer :: nbpi
        integer :: nbspi
        character(len=8) :: extrga
        character(len=8) :: extrch
        character(len=8) :: extrcp
        character(len=24) :: listma
        character(len=24) :: listpi
        character(len=24) :: listsp
        character(len=24) :: listcp
        character(len=19) :: chgaus
        character(len=19) :: chelga
    end subroutine nmext3
end interface

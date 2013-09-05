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
    subroutine nmobsz(sdobse, nomtab, titobs, nomcha, typcha,&
                      extrch, extrcp, extrga, nomcmp, nomnoe,&
                      nommai, num, snum, instan, valr)
        character(len=19) :: sdobse
        character(len=19) :: nomtab
        character(len=80) :: titobs
        character(len=24) :: nomcha
        character(len=4) :: typcha
        character(len=8) :: extrch
        character(len=8) :: extrcp
        character(len=8) :: extrga
        character(len=8) :: nomcmp
        character(len=8) :: nomnoe
        character(len=8) :: nommai
        integer :: num
        integer :: snum
        real(kind=8) :: instan
        real(kind=8) :: valr
    end subroutine nmobsz
end interface

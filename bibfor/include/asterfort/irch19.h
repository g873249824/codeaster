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
    subroutine irch19(cham19, partie, form, ifi, titre,&
                      nomsd, nomsym, numord, lcor, nbnot,&
                      numnoe, nbmat, nummai, nbcmp, nomcmp,&
                      lsup, borsup, linf, borinf, lmax,&
                      lmin, lresu, formr, nive)
        integer :: nbcmp
        character(len=*) :: cham19
        character(len=*) :: partie
        character(len=*) :: form
        integer :: ifi
        character(len=*) :: titre
        character(len=*) :: nomsd
        character(len=*) :: nomsym
        integer :: numord
        logical(kind=1) :: lcor
        integer :: nbnot
        integer :: numnoe(*)
        integer :: nbmat
        integer :: nummai(*)
        character(len=*) :: nomcmp(*)
        logical(kind=1) :: lsup
        real(kind=8) :: borsup
        logical(kind=1) :: linf
        real(kind=8) :: borinf
        logical(kind=1) :: lmax
        logical(kind=1) :: lmin
        logical(kind=1) :: lresu
        character(len=*) :: formr
        integer :: nive
    end subroutine irch19
end interface

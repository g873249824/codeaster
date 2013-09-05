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
    subroutine ircecs(ifi, ligrel, nbgrel, longr, ncmpmx,&
                      vale, nomcmp, titr, nomel, loc,&
                      celd, nbnoma, permut, maxnod, typma,&
                      nomsd, nomsym, ir, nbmat, nummai,&
                      lmasu, ncmpu, nucmp)
        integer :: maxnod
        integer :: ifi
        integer :: ligrel(*)
        integer :: nbgrel
        integer :: longr(*)
        integer :: ncmpmx
        complex(kind=8) :: vale(*)
        character(*) :: nomcmp(*)
        character(*) :: titr
        character(*) :: nomel(*)
        character(*) :: loc
        integer :: celd(*)
        integer :: nbnoma(*)
        integer :: permut(maxnod, *)
        integer :: typma(*)
        character(*) :: nomsd
        character(*) :: nomsym
        integer :: ir
        integer :: nbmat
        integer :: nummai(*)
        logical :: lmasu
        integer :: ncmpu
        integer :: nucmp(*)
    end subroutine ircecs
end interface

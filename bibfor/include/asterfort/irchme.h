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
#include "asterf_types.h"
!
interface
    subroutine irchme(ifichi, chanom, partie, nochmd, noresu,&
                      nomsym, typech, numord, nbrcmp, nomcmp,&
                      nbnoec, linoec, nbmaec, limaec, lvarie,&
                      sdcarm, linopa, codret)
        integer :: ifichi
        character(len=19) :: chanom
        character(len=*) :: partie
        character(len=64) :: nochmd
        character(len=8) :: noresu
        character(len=16) :: nomsym
        character(len=8) :: typech
        integer :: numord
        integer :: nbrcmp
        character(len=*) :: nomcmp(*)
        integer :: nbnoec
        integer :: linoec(*)
        integer :: nbmaec
        integer :: limaec(*)
        aster_logical :: lvarie
        character(len=8) :: sdcarm
        character(len=19) :: linopa
        integer :: codret
    end subroutine irchme
end interface

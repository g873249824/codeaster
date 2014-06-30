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
    subroutine xpomax(mo, malini, mailx, nbnoc, nbmac,&
                      prefno, nogrfi, maxfem, cns1, cns2,&
                      ces1, ces2, cesvi1, cesvi2, listgr,&
                      dirgrm, nivgrm, resuco, ngfon, comps1,&
                      comps2, pre1)
        character(len=8) :: mo
        character(len=8) :: malini
        character(len=24) :: mailx
        integer :: nbnoc
        integer :: nbmac
        character(len=2) :: prefno(4)
        character(len=24) :: nogrfi
        character(len=8) :: maxfem
        character(len=19) :: cns1
        character(len=19) :: cns2
        character(len=19) :: ces1
        character(len=19) :: ces2
        character(len=19) :: cesvi1
        character(len=19) :: cesvi2
        character(len=24) :: listgr
        character(len=24) :: dirgrm
        character(len=24) :: nivgrm
        character(len=8) :: resuco
        integer :: ngfon
        character(len=19) :: comps1
        character(len=19) :: comps2
        logical(kind=1) :: pre1
    end subroutine xpomax
end interface 

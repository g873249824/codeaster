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
    subroutine fetinl(nbi, vlagi, matas, chsecm, lrigid,&
                      dimgi, nbsd, vsdf, vddl, nomggt,&
                      ipiv, nomgi, lstogi, infofe, irex,&
                      ifm, sdfeti, nbproc, rang, k24lai,&
                      itps)
        integer :: nbsd
        integer :: nbi
        real(kind=8) :: vlagi(nbi)
        character(len=19) :: matas
        character(len=19) :: chsecm
        logical :: lrigid
        integer :: dimgi
        integer :: vsdf(nbsd)
        integer :: vddl(nbsd)
        character(len=24) :: nomggt
        integer :: ipiv
        character(len=24) :: nomgi
        logical :: lstogi
        character(len=24) :: infofe
        integer :: irex
        integer :: ifm
        character(len=19) :: sdfeti
        integer :: nbproc
        integer :: rang
        character(len=24) :: k24lai
        integer :: itps
    end subroutine fetinl
end interface

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
    subroutine irgnal(ifi, nbordr, coord, connex, point,&
                      nocmp, nbcmp, numel, nobj, nbel,&
                      cnsc, cnsl, cnsv, partie, jtype,&
                      cnsd)
        integer :: nbcmp
        integer :: ifi
        integer :: nbordr
        real(kind=8) :: coord(*)
        integer :: connex(*)
        integer :: point(*)
        character(len=8) :: nocmp(nbcmp)
        integer :: numel
        character(*) :: nobj
        integer :: nbel
        integer :: cnsc(*)
        integer :: cnsl(*)
        integer :: cnsv(*)
        character(*) :: partie
        integer :: jtype
        integer :: cnsd(*)
    end subroutine irgnal
end interface

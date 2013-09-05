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
    subroutine xpolsn(elrefp, ino, n, jlsn, jlst,&
                      ima, iad, igeom, nfiss, ndime,&
                      ndim, jconx1, jconx2, co, lsn,&
                      lst)
        integer :: nfiss
        integer :: n
        character(len=8) :: elrefp
        integer :: ino
        integer :: jlsn
        integer :: jlst
        integer :: ima
        integer :: iad
        integer :: igeom
        integer :: ndime
        integer :: ndim
        integer :: jconx1
        integer :: jconx2
        real(kind=8) :: co(3)
        real(kind=8) :: lsn(nfiss)
        real(kind=8) :: lst(nfiss)
    end subroutine xpolsn
end interface

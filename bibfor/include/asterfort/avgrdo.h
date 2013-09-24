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
    subroutine avgrdo(nbvec, nbordr, vectn, vwork, tdisp,&
                      kwork, sommw, tspaq, i, nommat,&
                      nomcri, nomfor, grdvie, forvie, vala,&
                      coefpa, ncycl, jvmin, jvmax, jomin,&
                      jomax, post, cudomx, vnormx, nbplan)
        integer :: tdisp
        integer :: nbordr
        integer :: nbvec
        real(kind=8) :: vectn(3*nbvec)
        real(kind=8) :: vwork(tdisp)
        integer :: kwork
        integer :: sommw
        integer :: tspaq
        integer :: i
        character(len=8) :: nommat
        character(len=16) :: nomcri
        character(len=16) :: nomfor
        character(len=8) :: grdvie
        character(len=16) :: forvie
        real(kind=8) :: vala
        real(kind=8) :: coefpa
        integer :: ncycl(nbvec)
        integer :: jvmin
        integer :: jvmax
        integer :: jomin
        integer :: jomax
        logical :: post
        real(kind=8) :: cudomx
        integer :: vnormx(2)
        integer :: nbplan
    end subroutine avgrdo
end interface

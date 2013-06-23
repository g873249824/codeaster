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
    subroutine fetreo(reorth, alphan, nbi, irg, iter,&
                      nbreor, irp, k24fir, k24ddr, k24psr,&
                      gs, igsmkp, rmin, irh, infofe,&
                      ifm, nbproc, rang, k24irp, itps,&
                      nbreoi, option, lacsm)
        logical :: reorth
        real(kind=8) :: alphan
        integer :: nbi
        integer :: irg
        integer :: iter
        integer :: nbreor
        integer :: irp
        character(len=24) :: k24fir
        character(len=24) :: k24ddr
        character(len=24) :: k24psr
        logical :: gs
        logical :: igsmkp
        real(kind=8) :: rmin
        integer :: irh
        character(len=24) :: infofe
        integer :: ifm
        integer :: nbproc
        integer :: rang
        character(len=24) :: k24irp
        integer :: itps
        integer :: nbreoi
        integer :: option
        logical :: lacsm
    end subroutine fetreo
end interface

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
    subroutine gcpc(m, in, ip, ac, inpc,&
                    ippc, acpc, bf, xp, r,&
                    rr, p, irep, niter, epsi,&
                    criter, solveu, matas, smbr, istop,&
                    iret)
        integer :: m
        integer :: in(m)
        integer(kind=4) :: ip(*)
        real(kind=8) :: ac(m)
        integer :: inpc(m)
        integer(kind=4) :: ippc(*)
        real(kind=8) :: acpc(m)
        real(kind=8) :: bf(m)
        real(kind=8) :: xp(m)
        real(kind=8) :: r(m)
        real(kind=8) :: rr(m)
        real(kind=8) :: p(m)
        integer :: irep
        integer :: niter
        real(kind=8) :: epsi
        character(len=19) :: criter
        character(len=19) :: solveu
        character(len=19) :: matas
        character(len=19) :: smbr
        integer :: istop
        integer :: iret
    end subroutine gcpc
end interface

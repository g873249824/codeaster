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
    subroutine tensca(tablca, icabl, nbnoca, nbf0, f0,&
                      delta, typrel, trelax, xflu, xret,&
                      ea, rh1000, mu0, fprg, frco,&
                      frli, sa, regl)
        character(len=19) :: tablca
        integer :: icabl
        integer :: nbnoca
        integer :: nbf0
        real(kind=8) :: f0
        real(kind=8) :: delta
        character(len=24) :: typrel
        real(kind=8) :: trelax
        real(kind=8) :: xflu
        real(kind=8) :: xret
        real(kind=8) :: ea
        real(kind=8) :: rh1000
        real(kind=8) :: mu0
        real(kind=8) :: fprg
        real(kind=8) :: frco
        real(kind=8) :: frli
        real(kind=8) :: sa
        character(len=4) :: regl
    end subroutine tensca
end interface

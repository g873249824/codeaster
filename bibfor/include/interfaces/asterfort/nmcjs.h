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
    subroutine nmcjs(typmod, imat, comp, crit, instam,&
                     instap, tempm, tempf, tref, epsd,&
                     deps, sigd, vind, opt, sigf,&
                     vinf, dsde, iret)
        character(len=8) :: typmod(*)
        integer :: imat
        character(len=16) :: comp(*)
        real(kind=8) :: crit(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        real(kind=8) :: tempm
        real(kind=8) :: tempf
        real(kind=8) :: tref
        real(kind=8) :: epsd(6)
        real(kind=8) :: deps(6)
        real(kind=8) :: sigd(6)
        real(kind=8) :: vind(*)
        character(len=16) :: opt
        real(kind=8) :: sigf(6)
        real(kind=8) :: vinf(*)
        real(kind=8) :: dsde(6, 6)
        integer :: iret
    end subroutine nmcjs
end interface

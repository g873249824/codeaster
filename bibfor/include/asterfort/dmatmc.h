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
    subroutine dmatmc(fami, mater , time, poum ,ipg,&
                      ispg, repere, xyzgau, nbsig,d,&
                      l_modi_cp)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: mater
        real(kind=8), intent(in) :: time
        character(len=*), intent(in) :: poum
        integer, intent(in) :: ipg
        integer, intent(in) :: ispg
        real(kind=8), intent(in) :: repere(7)
        real(kind=8), intent(in) :: xyzgau(3)
        integer, intent(in) :: nbsig
        real(kind=8), intent(out) :: d(nbsig, nbsig)
        logical, optional, intent(in) :: l_modi_cp
    end subroutine dmatmc
end interface

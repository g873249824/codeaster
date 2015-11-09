!
! COPYRIGHT (C) 1991 - 2015  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine dhrc_mat_tan(a, ap1, ap2, b,&
                      bp1, bp2, bocaj, neta1, neta2,&
                      indip, cstseu, eps, vint, dsidep)
        real(kind=8), intent(in) :: a(6, 6)
        real(kind=8), intent(in) :: ap1(6, 6)
        real(kind=8), intent(in) :: ap2(6, 6)
        real(kind=8), intent(in) :: b(6, 2, 2)
        real(kind=8), intent(in) :: bp1(6, 2)
        real(kind=8), intent(in) :: bp2(6, 2)
        real(kind=8), intent(in) :: bocaj(6, 6)
        real(kind=8), intent(in) :: neta1(2)
        real(kind=8), intent(in) :: neta2(2)
        integer, intent(in) :: indip(6)
        real(kind=8), intent(in) :: cstseu(6)
        real(kind=8), intent(in) :: eps(8)
        real(kind=8), intent(in) :: vint(*)
        real(kind=8), intent(out) :: dsidep(6, 6)
    end subroutine dhrc_mat_tan
end interface 

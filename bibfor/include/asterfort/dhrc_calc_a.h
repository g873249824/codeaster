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
    subroutine dhrc_calc_a(a0, aa_t, ga_t, aa_c,&
                      ga_c, eps, vint, a, ap1,&
                      ap2, as1, as2)
        real(kind=8) :: a0(6, 6)
        real(kind=8) :: aa_t(6, 6, 2)
        real(kind=8) :: ga_t(6, 6, 2)
        real(kind=8) :: aa_c(6, 6, 2)
        real(kind=8) :: ga_c(6, 6, 2)
        real(kind=8) :: eps(8)
        real(kind=8) :: vint(*)
        real(kind=8) :: a(6, 6)
        real(kind=8) :: ap1(6, 6)
        real(kind=8) :: ap2(6, 6)
        real(kind=8) :: as1(6, 6)
        real(kind=8) :: as2(6, 6)
    end subroutine dhrc_calc_a
end interface 

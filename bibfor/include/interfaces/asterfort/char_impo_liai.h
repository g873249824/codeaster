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
    subroutine char_impo_liai(nomg, type_liai, cmp_nb, cmp_name, cmp_index,  &
                              vale_real, vale_cplx, vale_fonc)
        character(len=8), intent(in) :: nomg
        character(len=16), intent(in) :: type_liai
        character(len=8), intent(out) :: cmp_name(6)
        integer, intent(out) :: cmp_index(6)
        integer, intent(out) :: cmp_nb
        real(kind=8), intent(out) :: vale_real
        character(len=8), intent(out) :: vale_fonc
        complex(kind=8), intent(out):: vale_cplx
    end subroutine char_impo_liai
end interface

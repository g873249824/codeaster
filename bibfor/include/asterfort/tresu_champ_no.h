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
#include "asterf_types.h"
!
interface
    subroutine tresu_champ_no(cham19, nonoeu, nocmp, nbref, tbtxt,&
                      refi, refr, refc, typres, epsi,&
                      crit,  llab, ssigne, ignore, compare)
        character(len=19), intent(in) :: cham19
        character(len=33), intent(in) :: nonoeu
        character(len=8), intent(in) :: nocmp
        integer, intent(in) :: nbref
        character(len=16), intent(in) :: tbtxt(2)
        integer, intent(in) :: refi(nbref)
        real(kind=8), intent(in) :: refr(nbref)
        complex(kind=8), intent(in) :: refc(nbref)
        character(len=1), intent(in) :: typres
        real(kind=8), intent(in) :: epsi
        character(len=*), intent(in) :: crit
        aster_logical, intent(in) :: llab
        character(len=*), intent(in) :: ssigne
        aster_logical, intent(in), optional :: ignore
        real(kind=8), intent(in), optional :: compare
    end subroutine tresu_champ_no
end interface

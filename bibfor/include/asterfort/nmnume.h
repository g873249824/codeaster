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
    subroutine nmnume(model , result, list_load, l_cont, sdcont_defi ,&
                      compor, solver, nume_ddl , sdnume, sd_iden_relaz)
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: compor
        character(len=24), intent(in) :: sdcont_defi
        character(len=24), intent(out) :: nume_ddl
        character(len=8), intent(in) :: result
        character(len=19), intent(in) :: list_load
        character(len=19), intent(in) :: solver
        character(len=19), intent(in) :: sdnume
        aster_logical, intent(in) :: l_cont
        character(len=*), optional, intent(in) :: sd_iden_relaz
    end subroutine nmnume
end interface

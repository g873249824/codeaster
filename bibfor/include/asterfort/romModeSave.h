!
! COPYRIGHT (C) 1991 - 2017  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine romModeSave(base        , i_mode     , model  ,&
                           field_type  , field_refe , nb_equa,&
                           mode_vectr_ ,&
                           mode_vectc_ ,&
                           mode_freq_  ,&
                           nume_slice_ ,&
                           nb_snap_)
        character(len=8), intent(in) :: base
        integer, intent(in) :: i_mode
        character(len=8), intent(in) :: model
        character(len=24), intent(in) :: field_type
        character(len=24), intent(in) :: field_refe
        integer, intent(in) :: nb_equa
        real(kind=8), optional, intent(in) :: mode_vectr_(nb_equa)
        complex(kind=8), optional, intent(in) :: mode_vectc_(nb_equa)
        integer, optional, intent(in)     :: nume_slice_
        real(kind=8), optional, intent(in) :: mode_freq_
        integer, optional, intent(in)     :: nb_snap_
    end subroutine romModeSave
end interface

! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

!
!
#include "asterf_types.h"
!
interface
    subroutine mm_cycl_detect(ds_contact    , &
                              l_frot_zone   , i_cont_poin   ,&
                              coef_cont, coef_frot ,& 
                              pres_cont_prev, dist_cont_prev,&
                              pres_frot_curr,pres_frot_prev ,&
                              indi_frot_prev, dist_frot_prev,&
                              indi_cont_eval, indi_frot_eval,&
                              indi_cont_prev, &
                              dist_cont_curr, pres_cont_curr, dist_frot_curr,&
                              alpha_cont_matr, alpha_cont_vect,&
                              alpha_frot_matr, alpha_frot_vect)
        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(inout) :: ds_contact
        aster_logical, intent(in) :: l_frot_zone
        integer, intent(in) :: i_cont_poin
        real(kind=8), intent(in) :: coef_cont
        real(kind=8), intent(in) :: coef_frot
        real(kind=8), intent(in) :: pres_cont_prev
        real(kind=8), intent(in) :: dist_cont_prev
        real(kind=8), intent(in) :: pres_frot_prev(3)
        real(kind=8), intent(in) :: pres_frot_curr(3)
        integer, intent(in) :: indi_frot_prev
        real(kind=8), intent(in) :: dist_frot_prev(3)
        integer, intent(in) :: indi_cont_eval
        integer, intent(in) :: indi_cont_prev
        integer, intent(in) :: indi_frot_eval
        real(kind=8), intent(in) :: dist_cont_curr
        real(kind=8), intent(in) :: pres_cont_curr
        real(kind=8), intent(in) :: dist_frot_curr(3)
        real(kind=8), intent(out) :: alpha_cont_matr
        real(kind=8), intent(out) :: alpha_cont_vect
        real(kind=8), intent(out) :: alpha_frot_matr
        real(kind=8), intent(out) :: alpha_frot_vect
    end subroutine mm_cycl_detect
end interface

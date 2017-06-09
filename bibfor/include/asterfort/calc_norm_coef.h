! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
interface
    subroutine calc_norm_coef(model       , name_gd     , nb_cmp_max  , nb_cmp_in, norm  , &
                              calc_elem   , list_cmp    , nb_coef_user, coef_user, chcoef, &
                              chcalc      , nb_cmp_act)
        character(len=8), intent(in) :: name_gd
        character(len=8), intent(in) :: model
        integer, intent(in) :: nb_cmp_max
        integer, intent(in) :: nb_cmp_in
        character(len=16) , intent(in) :: norm
        character(len=4) , intent(in) :: calc_elem
        integer, intent(in) :: nb_coef_user
        real(kind=8), intent(in) :: coef_user(*)
        character(len=24), intent(in) :: list_cmp
        character(len=19), intent(in) :: chcoef
        character(len=19), intent(in) :: chcalc
        integer, intent(out) :: nb_cmp_act
    end subroutine calc_norm_coef
end interface

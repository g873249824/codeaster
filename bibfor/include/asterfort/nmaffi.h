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
    subroutine nmaffi(list_func_acti, ds_conv, ds_print, sderro, sddisc,&
                      loop_name     )
        use NonLin_Datastructure_type
        integer, intent(in) :: list_func_acti(*)
        type(NL_DS_Conv), intent(in) :: ds_conv
        type(NL_DS_Print), intent(inout) :: ds_print
        character(len=24), intent(in) :: sderro
        character(len=19), intent(in) :: sddisc
        character(len=4), intent(in) :: loop_name
    end subroutine nmaffi
end interface

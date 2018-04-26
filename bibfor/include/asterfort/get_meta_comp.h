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
interface
    subroutine get_meta_comp(rela_comp,&
                             l_plas, l_visc,&
                             l_hard_isot, l_hard_kine, l_hard_line, l_hard_rest,&
                             l_plas_tran)
        character(len=16), intent(in) :: rela_comp
        logical, optional, intent(out) :: l_plas
        logical, optional, intent(out) :: l_visc
        logical, optional, intent(out) :: l_hard_isot
        logical, optional, intent(out) :: l_hard_kine
        logical, optional, intent(out) :: l_hard_line
        logical, optional, intent(out) :: l_hard_rest
        logical, optional, intent(out) :: l_plas_tran
    end subroutine get_meta_comp
end interface
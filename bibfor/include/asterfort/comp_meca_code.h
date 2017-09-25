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
#include "asterf_types.h"
!
interface
    subroutine comp_meca_code(rela_comp_   , defo_comp_   , type_cpla_   , kit_comp_    ,&
                              meca_comp_   , post_iter_   , l_implex_    , &
                              comp_code_py_, rela_code_py_, defo_code_py_, meta_code_py_,&
                              meca_code_py_)
        character(len=16), optional, intent(in) :: rela_comp_
        character(len=16), optional, intent(in) :: defo_comp_
        character(len=16), optional, intent(in) :: type_cpla_
        character(len=16), optional, intent(in) :: kit_comp_(4)
        character(len=16), optional, intent(in) :: meca_comp_
        character(len=16), optional, intent(in) :: post_iter_
        aster_logical, optional, intent(in) :: l_implex_
        character(len=16), optional, intent(out) :: comp_code_py_
        character(len=16), optional, intent(out) :: rela_code_py_
        character(len=16), optional, intent(out) :: defo_code_py_
        character(len=16), optional, intent(out) :: meta_code_py_
        character(len=16), optional, intent(out) :: meca_code_py_
    end subroutine comp_meca_code
end interface

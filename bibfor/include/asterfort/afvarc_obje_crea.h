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
    subroutine afvarc_obje_crea(jv_base, chmate, mesh, varc_cata, varc_affe)
        use Material_Datastructure_type
        character(len=1), intent(in) :: jv_base
        character(len=8), intent(in) :: chmate
        character(len=8), intent(in) :: mesh
        type(Mat_DS_VarcListCata), intent(in) :: varc_cata
        type(Mat_DS_VarcListAffe), intent(in) :: varc_affe
    end subroutine afvarc_obje_crea
end interface

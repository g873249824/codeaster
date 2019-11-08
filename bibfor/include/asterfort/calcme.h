! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine calcme(option, j_mater, ndim  , typmod, angl_naut,&
                      compor, carcri , instam, instap,&
                      addeme, adcome , dimdef, dimcon,&
                      defgem, deps   ,&
                      congem, vintm  ,&
                      congep, vintp  ,&
                      dsdeme, retcom )
        character(len=16), intent(in) :: option, compor(*)
        integer, intent(in) :: j_mater
        character(len=8), intent(in) :: typmod(2)
        real(kind=8), intent(in) :: carcri(*)
        real(kind=8), intent(in) :: instam, instap
        integer, intent(in) :: ndim, dimdef, dimcon, addeme, adcome
        real(kind=8), intent(in) :: vintm(*)
        real(kind=8), intent(in) :: angl_naut(3)
        real(kind=8), intent(in) :: defgem(dimdef), deps(6), congem(dimcon)
        real(kind=8), intent(inout) :: congep(dimcon)
        real(kind=8), intent(inout) :: vintp(*)
        real(kind=8), intent(out) :: dsdeme(6, 6)
        integer, intent(out) :: retcom
    end subroutine calcme
end interface

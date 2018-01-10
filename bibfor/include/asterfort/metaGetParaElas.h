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
interface
    subroutine metaGetParaElas(poum, fami    , kpg , ksp, j_mater,&
                               e_  , deuxmu_ , mu_ , troisk_ ,&
                               em_ , deuxmum_, mum_, troiskm_)
        character(len=1), intent(in) :: poum
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg, ksp
        integer, intent(in) :: j_mater
        real(kind=8), optional, intent(out) :: e_, deuxmu_, mu_, troisk_
        real(kind=8), optional, intent(out) :: em_, deuxmum_, mum_, troiskm_
    end subroutine metaGetParaElas
end interface

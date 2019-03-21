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
!
interface
    subroutine nueffe_lag2(nb_ligr, list_ligr, base, nume_ddlz, renumz,&
                           modelocz, sd_iden_relaz)
        integer, intent(in) :: nb_ligr
        character(len=24), pointer :: list_ligr(:)
        character(len=2), intent(in) :: base
        character(len=*), intent(in) :: nume_ddlz
        character(len=*), intent(in) :: renumz
        character(len=*), optional, intent(in) :: modelocz
        character(len=*), optional, intent(in) :: sd_iden_relaz
    end subroutine nueffe_lag2
end interface

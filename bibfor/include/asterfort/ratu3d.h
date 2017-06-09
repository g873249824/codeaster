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
    subroutine ratu3d(iprno, lonlis, klisno, noepou, noma,&
                      ligrel, mod, cara, numddl, typlag,&
                      lisrel, coorig, sectio)
        integer :: lonlis
        integer :: iprno(*)
        character(len=8) :: klisno(lonlis)
        character(len=8) :: noepou
        character(len=8) :: noma
        character(len=19) :: ligrel
        character(len=8) :: mod
        character(len=8) :: cara
        character(len=14) :: numddl
        character(len=2) :: typlag
        character(len=19) :: lisrel
        real(kind=8) :: coorig(3)
        real(kind=8) :: sectio
    end subroutine ratu3d
end interface

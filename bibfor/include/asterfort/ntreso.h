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
#include "asterf_types.h"
!
interface
    subroutine ntreso(model , mate  , cara_elem, list_load, nume_dof,&
                      solver, l_stat, time     , tpsthe   , reasrg  ,&
                      reasms, cn2mbr, matass   , maprec   , cndiri  ,&
                      cncine, mediri)
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: solver
        aster_logical, intent(in) :: l_stat
        character(len=24), intent(in) :: time
        real(kind=8), intent(in) :: tpsthe(6)
        aster_logical, intent(in) :: reasrg
        aster_logical, intent(in) :: reasms
        character(len=24), intent(in) :: cn2mbr
        character(len=24), intent(in) :: matass
        character(len=19), intent(in) :: maprec
        character(len=24), intent(in) :: cndiri
        character(len=24), intent(out) :: cncine
        character(len=24), intent(in) :: mediri
    end subroutine ntreso
end interface

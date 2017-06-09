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
! person_in_charge: jean-luc.flejou at edf.fr
!
interface
    subroutine ace_masse_repartie(nbocc, infdonn, grplmax, lmax, infcarte, nbdisc, zjdlm)
        use cara_elem_info_type
        use cara_elem_carte_type
        integer :: nbocc
        type (cara_elem_info) :: infdonn
        character(len=24) :: grplmax(*)
        integer :: lmax
        type (cara_elem_carte) :: infcarte(*)
        integer :: nbdisc
        integer :: zjdlm(*)
    end subroutine ace_masse_repartie
end interface

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
    subroutine calcul_cara_maille( coord, noeuds, topologie, surface, centre, normale )
        real(kind=8),intent(in)    :: coord(*)
        integer,intent(in)         :: noeuds(:)
        integer,intent(in)         :: topologie
        real(kind=8),optional,intent(out)   :: surface(*)
        real(kind=8),optional,intent(out)   :: centre(*)
        real(kind=8),optional,intent(out)   :: normale(*)
    end subroutine calcul_cara_maille
end interface

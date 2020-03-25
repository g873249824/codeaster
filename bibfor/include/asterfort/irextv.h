! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine irextv(fileFormat,&
                      keywf     , keywfIocc,&
                      lResu     , lField   ,&
                      lmax      , lmin     ,&
                      lsup      , borsup   ,&
                      linf      , borinf)
        character(len=16), intent(in) :: keywf
        integer, intent(in) :: keywfIocc
        aster_logical, intent(in) :: lField, lResu
        character(len=8), intent(in) :: fileFormat
        aster_logical, intent(out) :: lsup, linf, lmax, lmin
        real(kind=8), intent(out) :: borsup, borinf
    end subroutine irextv
end interface

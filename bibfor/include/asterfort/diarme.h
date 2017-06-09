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
    subroutine diarme(nbt, neq, icodma, ul, dul,&
                      utl, sim, varim, klv, varip,&
                      kty2, duly)
        integer :: neq
        integer :: nbt
        integer :: icodma
        real(kind=8) :: ul(neq)
        real(kind=8) :: dul(neq)
        real(kind=8) :: utl(neq)
        real(kind=8) :: sim(neq)
        real(kind=8) :: varim
        real(kind=8) :: klv(nbt)
        real(kind=8) :: varip
        real(kind=8) :: kty2
        real(kind=8) :: duly
    end subroutine diarme
end interface

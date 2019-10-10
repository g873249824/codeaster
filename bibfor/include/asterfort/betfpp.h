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
    subroutine betfpp(BEHinteg,&
                      materf, nmat, pc, pt,&
                      nseuil, fc, ft, dfcdlc, dftdlt,&
                      kuc, kut, ke)
        use Behaviour_type
        type(Behaviour_Integ), intent(in) :: BEHinteg
        integer :: nmat
        real(kind=8) :: materf(nmat, 2)
        real(kind=8) :: pc
        real(kind=8) :: pt
        integer :: nseuil
        real(kind=8) :: fc
        real(kind=8) :: ft
        real(kind=8) :: dfcdlc
        real(kind=8) :: dftdlt
        real(kind=8) :: kuc
        real(kind=8) :: kut
        real(kind=8) :: ke
    end subroutine betfpp
end interface

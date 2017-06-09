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
    subroutine usuvu2(puusur, vusur, nbinst, temps, isupp,&
                      nbpt, nbpair, coef, ang, fn,&
                      vg, iret, vustub, vusob, pus,&
                      pmoye, pourpu, poupre)
        integer :: nbpair
        integer :: nbinst
        real(kind=8) :: puusur
        real(kind=8) :: vusur(*)
        real(kind=8) :: temps(*)
        integer :: isupp
        integer :: nbpt
        real(kind=8) :: coef(*)
        real(kind=8) :: ang(*)
        real(kind=8) :: fn(*)
        real(kind=8) :: vg(*)
        integer :: iret
        real(kind=8) :: vustub(nbpair, nbinst)
        real(kind=8) :: vusob(nbpair, nbinst)
        real(kind=8) :: pus(*)
        real(kind=8) :: pmoye
        real(kind=8) :: pourpu(*)
        real(kind=8) :: poupre(*)
    end subroutine usuvu2
end interface

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
    subroutine xmilar(ndim, ndime, elrefp, geom,  pinref,&
                    ia, ib, im, ip, ksia, ksib, milara, milarb,&
                    pintt, pmitt)
        character(len=8) :: elrefp
        integer :: ndim
        integer :: ndime
        real(kind=8) :: geom(*)
        real(kind=8) :: pinref(*)
        integer :: ia
        integer :: ib
        integer :: im
        integer :: ip
        real(kind=8) :: ksia(ndime)
        real(kind=8) :: ksib(ndime)
        real(kind=8) :: milara(3)
        real(kind=8) :: milarb(3)
        real(kind=8) :: pintt(*)
        real(kind=8) :: pmitt(*)
    end subroutine xmilar
end interface

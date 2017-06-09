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
    function lkcrit(amat, mmat, smat, gamcjs, sigc,&
                    h0ext, rcos3t, invar, sii)
        real(kind=8) :: amat
        real(kind=8) :: mmat
        real(kind=8) :: smat
        real(kind=8) :: gamcjs
        real(kind=8) :: sigc
        real(kind=8) :: h0ext
        real(kind=8) :: rcos3t
        real(kind=8) :: invar
        real(kind=8) :: sii
        real(kind=8) :: lkcrit
    end function lkcrit
end interface

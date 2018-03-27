! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
            subroutine pj3dtr(cortr3,corres,nutm3d,elrf3d,geom1,geom2,  &
     &dala, listInterc, nbInterc)
              character(len=16), intent(in) :: cortr3
              character(len=16), intent(in) :: corres
              integer, intent(in) :: nutm3d(10)
              character(len=8), intent(in) :: elrf3d(10)
              real(kind=8), intent(in) :: geom1(*)
              real(kind=8), intent(in) :: geom2(*)
              real(kind=8), intent(in) :: dala
              character(len=16), intent(in) :: listInterc
              integer, intent(in) :: nbInterc
            end subroutine pj3dtr
          end interface 

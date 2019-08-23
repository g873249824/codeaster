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
    subroutine vipvpt(ds_thm,&
                      ndim  , nbvari, dimcon,&
                      adcp11, adcp12,&
                      advico, vicpvp,&
                      congem,&
                      cp11  , cp12  , kh    ,&
                      mamolv, rgaz  , rho11 , signe ,&    
                      temp  , p2    ,&
                      dtemp , dp1   , dp2   ,&
                      pvp0  , pvp1  ,&
                      vintm , vintp ,&
                      retcom)
        use THM_type
        type(THM_DS), intent(in) :: ds_thm
        integer, intent(in) :: ndim, nbvari, dimcon
        integer, intent(in) :: adcp11, adcp12
        integer, intent(in) :: advico, vicpvp
        real(kind=8), intent(in) :: congem(dimcon)
        real(kind=8), intent(in) :: mamolv, rgaz, rho11, kh
        real(kind=8), intent(in) :: signe , cp11, cp12
        real(kind=8), intent(in) :: temp, p2
        real(kind=8), intent(in) :: dtemp, dp1, dp2
        real(kind=8), intent(in) :: vintm(nbvari)
        real(kind=8), intent(in) :: pvp0
        real(kind=8), intent(out) :: pvp1
        real(kind=8), intent(out) :: vintp(nbvari)
        integer, intent(out)  :: retcom
    end subroutine vipvpt
end interface

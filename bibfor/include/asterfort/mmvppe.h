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
#include "asterf_types.h"
!
interface
    subroutine mmvppe(ndim       , nne         , nnm     , nnl   , nbdm  ,&
                      i_reso_geom, l_large_slip,&
                      jeusup  ,&
                      tau1     , tau2     ,&
                      ffe      , ffm      , ffl     , dffm  , ddffm,&
                      jeu      , djeu    , djeut , &
                      dlagrc   , dlagrf   , &
                      norm     , mprojt   ,&
                      mprt1n   , mprt2n   , &
                      mprt11  , mprt12  ,mprt21, mprt22,&
                      kappa    ,&
                      taujeu1  , taujeu2  ,&
                      dnepmait1, dnepmait2)
        integer, intent(in) :: ndim, nne, nnm, nnl, nbdm
        integer, intent(in) :: i_reso_geom
        aster_logical, intent(in) :: l_large_slip
        real(kind=8), intent(in) :: jeusup
        real(kind=8), intent(in) :: tau1(3), tau2(3)
        real(kind=8), intent(in) :: ffe(9), ffm(9), ffl(9), dffm(2,9), ddffm(3,9)
        real(kind=8), intent(out) :: jeu, djeu(3)
        real(kind=8), intent(out) :: djeut(3), dlagrc, dlagrf(2)
        real(kind=8), intent(out) :: norm(3), mprojt(3, 3)
        real(kind=8), intent(out) :: mprt1n(3, 3), mprt2n(3, 3)
        real(kind=8), intent(out) :: mprt11(3, 3), mprt12(3, 3), mprt21(3, 3), mprt22(3, 3)
        real(kind=8), intent(out) :: kappa(2, 2)
        real(kind=8), intent(out) :: dnepmait1, dnepmait2, taujeu1, taujeu2
    end subroutine mmvppe
end interface

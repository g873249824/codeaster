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
    subroutine mmtfpe(phase , i_reso_fric, l_pena_cont, l_pena_fric,&
                      ndim  , nne   , nnm        ,  nnl       , nbcps ,&
                      wpg   , jacobi,&
                      ffl   , ffe   , ffm        ,&
                      norm  , tau1  , tau2       , mprojn     , mprojt,&
                      rese  , nrese , &
                      lambda, coefff, coefaf     , coefac, &
                      dlagrf, djeut ,&
                      matree, matrmm,&
                      matrem, matrme,&
                      matrec, matrmc,&
                      matref, matrmf)
        character(len=4), intent(in) :: phase
        aster_logical, intent(in) :: l_pena_cont, l_pena_fric
        integer, intent(in) :: i_reso_fric, ndim, nne, nnm, nnl, nbcps
        real(kind=8), intent(in) :: norm(3), tau1(3), tau2(3), mprojn(3, 3), mprojt(3, 3)
        real(kind=8), intent(in) :: ffe(9), ffm(9), ffl(9)
        real(kind=8), intent(in) :: wpg, jacobi
        real(kind=8), intent(in) :: rese(3), nrese
        real(kind=8), intent(in) :: coefac, coefaf, lambda, coefff
        real(kind=8), intent(in) :: dlagrf(2), djeut(3)
        real(kind=8), intent(out) :: matrem(27, 27), matrme(27, 27)
        real(kind=8), intent(out) :: matree(27, 27), matrmm(27, 27)
        real(kind=8), intent(out) :: matrec(27, 9), matrmc(27, 9)
        real(kind=8), intent(out) :: matrmf(27, 18), matref(27, 18)
    end subroutine mmtfpe
end interface

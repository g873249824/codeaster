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
    subroutine thmGetElemPara(ds_thm   , l_axi    , l_steady ,&
                              type_elem, inte_type, ndim     ,&
                              mecani   , press1   , press2   , tempe  ,&
                              dimdep   , dimdef   , dimcon   , dimuel ,&
                              nddls    , nddlm    , nddl_meca, nddl_p1, nddl_p2,&
                              nno      , nnos     , &
                              npi      , npg      ,&
                              jv_poids , jv_func  , jv_dfunc ,&
                              jv_poids2, jv_func2 , jv_dfunc2,&
                              jv_gano)
        use THM_type
        type(THM_DS), intent(inout) :: ds_thm
        aster_logical, intent(out) :: l_axi, l_steady
        character(len=8), intent(out) :: type_elem(2)
        character(len=3), intent(out) :: inte_type
        integer, intent(out) :: ndim
        integer, intent(out) :: mecani(5), press1(7), press2(7), tempe(5)
        integer, intent(out) :: dimdep, dimdef, dimcon, dimuel
        integer, intent(out) :: nddls, nddlm, nddl_meca, nddl_p1, nddl_p2
        integer, intent(out) :: nno, nnos
        integer, intent(out) :: npi, npg
        integer, intent(out) :: jv_func, jv_dfunc, jv_poids
        integer, intent(out) :: jv_func2, jv_dfunc2, jv_poids2
        integer, intent(out) :: jv_gano     
    end subroutine thmGetElemPara
end interface

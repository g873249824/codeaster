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
    subroutine nmxmat(modelz         , ds_material, carele    ,&
                      ds_constitutive, sddisc     , numins    ,&
                      valinc         , solalg     , lischa    ,&
                      numedd         , numfix     , ds_measure,&
                      nbmatr         , ltypma     , loptme    ,&
                      loptma         , lcalme     , lassme    ,&
                      meelem         , measse     , ds_system)
        use NonLin_Datastructure_type
        character(len=*) :: modelz
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19) :: sddisc
        integer :: numins
        character(len=19) :: solalg(*), valinc(*), lischa
        character(len=24) :: numedd, numfix
        type(NL_DS_Measure), intent(inout) :: ds_measure
        integer :: nbmatr
        character(len=6) :: ltypma(20)
        character(len=16) :: loptme(20), loptma(20)
        aster_logical :: lcalme(20), lassme(20)
        character(len=19) :: meelem(*), measse(*)
        type(NL_DS_System), intent(in) :: ds_system
    end subroutine nmxmat
end interface

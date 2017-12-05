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
    subroutine romMultiParaDSInit(ds_multicoef_v, ds_multicoef_m, ds_varipara, ds_evalcoef,&
                                  ds_multipara)
        use Rom_Datastructure_type
        type(ROM_DS_MultiCoef), intent(in)  :: ds_multicoef_v
        type(ROM_DS_MultiCoef), intent(in)  :: ds_multicoef_m
        type(ROM_DS_VariPara), intent(in)   :: ds_varipara
        type(ROM_DS_EvalCoef), intent(in)   :: ds_evalcoef
        type(ROM_DS_MultiPara), intent(out) :: ds_multipara
    end subroutine romMultiParaDSInit
end interface
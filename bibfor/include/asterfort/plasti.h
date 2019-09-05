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
    subroutine plasti(BEHinteg    ,&
                      fami        , kpg   , ksp   , typmod, imate,&
                      compor      , carcri, instam, instap, &
                      epsdt       , depst , sigm  ,&
                      vim         , option, angmas, sigp  , vip,&
                      dsidep      , icomp , nvi   , codret,&
                      mult_compor_)
        use Behaviour_type
        type(Behaviour_Integ), intent(in) :: BEHinteg
        character(len=*), intent(in) :: fami
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        integer, intent(in) :: imate
        character(len=16), intent(in) :: compor(*)
        real(kind=8), intent(in) :: carcri(*)
        real(kind=8), intent(in) :: instam
        real(kind=8), intent(in) :: instap
        real(kind=8), intent(in) :: epsdt(9)
        real(kind=8), intent(in) :: depst(9)
        real(kind=8), intent(in) :: sigm(6)
        real(kind=8), intent(in) :: vim(*)
        character(len=16), intent(in) :: option
        real(kind=8), intent(in) :: angmas(3)
        real(kind=8), intent(out) :: sigp(6)
        real(kind=8), intent(out) :: vip(*)
        character(len=8), intent(in) :: typmod(*)
        integer, intent(in) :: icomp
        integer, intent(in) :: nvi
        real(kind=8), intent(out) :: dsidep(6, *)
        integer, intent(out) :: codret
        character(len=16), optional, intent(in) :: mult_compor_
    end subroutine plasti
end interface

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

subroutine vrcomp_chck_rela(mesh, nb_elem, compor_curr_r, compor_prev_r, ligrel_curr,&
                            ligrel_prev, comp_comb_1, comp_comb_2, no_same_pg, no_same_rela,&
                            l_modif_vari)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cesexi.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
!
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: nb_elem
    character(len=19), intent(in) :: compor_curr_r
    character(len=19), intent(in) :: compor_prev_r
    character(len=19), intent(in) :: ligrel_curr
    character(len=19), intent(in) :: ligrel_prev
    character(len=48), intent(in) :: comp_comb_1
    character(len=48), intent(in) :: comp_comb_2
    aster_logical, intent(out) :: no_same_pg
    aster_logical, intent(out) :: no_same_rela
    aster_logical, intent(out) :: l_modif_vari
!
! --------------------------------------------------------------------------------------------------
!
! Check compatibility of comportments
!
! Check if comportments are the same (or compatible)
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh          : name of mesh
! In  nb_elem       : number of elements for current comportment
! In  compor_curr_r : reduced field for current comportment
! In  compor_prev_r : reduced field for previous comportment
! In  ligrel_curr   : current LIGREL
! In  ligrel_prev   : previous LIGREL
! In  comp_comb_1   : list of comportments can been mixed with each other
! In  comp_comb_2   : list of comportments can been mixed with all other ones
! Out no_same_pg    : .true. if not the same number of Gauss points
! Out no_same_rela  : .true. if not the same relation
! Out l_modif_vari  : .true. to change the structure of internal variables field
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_elem, k_elem
    aster_logical :: elem_in_curr, elem_in_prev
    integer :: iadp, iadm
    integer :: idx_comb_prev, idx_comb_curr
    character(len=16) :: rela_comp_prev, rela_comp_curr, valk(3)
    character(len=8) :: name_elem
    integer, pointer :: repm(:) => null()
    integer, pointer :: repp(:) => null()
    integer :: jcopml, jcopmd
    character(len=16), pointer :: copmv(:) => null()
    integer :: jcoppl, jcoppd
    character(len=16), pointer :: coppv(:) => null()
    character(len=8), pointer :: coppk(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    l_modif_vari = .false.
    k_elem = 0
    no_same_pg = .false.
    no_same_rela = .false.
!
! - Access to LIGREL
!
    call jeveuo(ligrel_curr//'.REPE', 'L', vi=repp)
    call jeveuo(ligrel_prev//'.REPE', 'L', vi=repm)
!
! - Acces to reduced CARTE on current comportement
!
    call jeveuo(compor_curr_r//'.CESD', 'L', jcoppd)
    call jeveuo(compor_curr_r//'.CESV', 'L', vk16=coppv)
    call jeveuo(compor_curr_r//'.CESL', 'L', jcoppl)
    call jeveuo(compor_curr_r//'.CESK', 'L', vk8=coppk)
!
! - Acces to reduced CARTE on previous comportement
!
    call jeveuo(compor_prev_r//'.CESD', 'L', jcopmd)
    call jeveuo(compor_prev_r//'.CESV', 'L', vk16=copmv)
    call jeveuo(compor_prev_r//'.CESL', 'L', jcopml)
!
! - Check on mesh
!
    do i_elem = 1, nb_elem
        elem_in_prev = repm(2*(i_elem-1)+1).gt.0
        elem_in_curr = repp(2*(i_elem-1)+1).gt.0
        k_elem = k_elem+1
        call cesexi('C', jcopmd, jcopml, i_elem, 1,&
                    1, 1, iadm)
        call cesexi('C', jcoppd, jcoppl, i_elem, 1,&
                    1, 1, iadp)
        if (iadp .gt. 0) then
            rela_comp_curr = coppv(iadp)
            if (iadm .le. 0) then
                call jenuno(jexnum(mesh//'.NOMMAI', i_elem), name_elem)
                call utmess('I', 'COMPOR2_50', sk=name_elem)
                no_same_pg = .true.
            else
                rela_comp_prev = copmv(iadm)
!
! ------------- Same comportement
!
                if (rela_comp_prev .eq. rela_comp_curr) then
                    goto 10
                else
!
! ----------------- Comportements can been mixed
!
                    idx_comb_prev = index(comp_comb_1, rela_comp_prev)
                    idx_comb_curr = index(comp_comb_1, rela_comp_curr)
                    if ((idx_comb_prev.gt.0) .and. (idx_comb_curr.gt.0)) then
                        goto 10
                    endif
!
! ----------------- Comportements can been always mixed
!
                    idx_comb_prev = index(comp_comb_2, rela_comp_prev)
                    idx_comb_curr = index(comp_comb_2, rela_comp_curr)
                    if ((idx_comb_prev.gt.0) .or. (idx_comb_curr.gt.0)) then
                        l_modif_vari = .true.
                        goto 10
                    endif
!
! ----------------- Comportements cannot been mixed
!
                    if (elem_in_curr .and. elem_in_prev) then
                        call jenuno(jexnum(mesh//'.NOMMAI', i_elem), name_elem)
                        valk(1) = name_elem
                        valk(2) = rela_comp_prev
                        valk(3) = rela_comp_curr
                        call utmess('I', 'COMPOR2_51', nk=3, valk=valk)
                        no_same_rela = .true.
                    endif
                endif
            endif
 10         continue
        endif
    end do
!
end subroutine

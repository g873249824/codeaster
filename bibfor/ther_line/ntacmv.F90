! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine ntacmv(model , mate  , cara_elem, list_load, nume_dof,&
                  l_stat, time  , tpsthe   , reasrg   , reasms  ,&
                  vtemp , varc_curr, &
                  cn2mbr, matass, cndiri   , cncine   , mediri)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
#include "asterfort/asasve.h"
#include "asterfort/ascavc.h"
#include "asterfort/ascova.h"
#include "asterfort/asmatr.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mecact.h"
#include "asterfort/memsth.h"
#include "asterfort/mergth.h"
#include "asterfort/merxth.h"
#include "asterfort/vechnl.h"
#include "asterfort/vechth.h"
#include "asterfort/vedith.h"
#include "asterfort/vetnth.h"
#include "asterfort/vrcins.h"
!
character(len=24), intent(in) :: model
character(len=24), intent(in) :: mate
character(len=24), intent(in) :: cara_elem
character(len=19), intent(in) :: list_load
character(len=24), intent(in) :: nume_dof
aster_logical, intent(in) :: l_stat
character(len=24), intent(in) :: time
real(kind=8), intent(in) :: tpsthe(6)
aster_logical, intent(in) :: reasrg
aster_logical, intent(in) :: reasms
character(len=24), intent(in) :: vtemp
character(len=19), intent(in) :: varc_curr
character(len=24), intent(in) :: cn2mbr
character(len=24), intent(in) :: matass
character(len=24), intent(in) :: cndiri
character(len=24), intent(out) :: cncine
character(len=24), intent(in) :: mediri
!
! --------------------------------------------------------------------------------------------------
!
! THER_LINEAIRE - Algorithm
!
! Compute second member
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  mate             : name of material characteristics (field)
! In  cara_elem        : name of elementary characteristics (field)
! In  list_load        : name of datastructure for list of loads
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jtn, iret, i_vect
    character(len=2) :: codret
    real(kind=8) :: time_curr
    character(len=8), parameter :: nomcmp(6) = (/'INST    ','DELTAT  ',&
                                                 'THETA   ','KHI     ',&
                                                 'R       ','RHO     '/)
    character(len=24) :: ligrmo
    character(len=24) :: vadiri, vachtp, vatntp
    character(len=24), parameter  :: merigi = '&&METRIG           .RELR'
    character(len=24), parameter  :: memass = '&&METMAS           .RELR'
    character(len=24) :: vediri
    character(len=24) :: vechtp
    character(len=24), parameter  :: vetntp = '&&VETNTP           .RELR'
    character(len=24) :: cntntp
    character(len=24) :: cnchtp
    character(len=24) :: lload_name, lload_info, lload_func
    character(len=24), pointer :: v_resu_elem(:) => null()
    integer, parameter :: nb_max = 9
    integer :: nb_vect, nb_matr
    real(kind=8) :: vect_coef(nb_max)
    character(len=19) :: vect_name(nb_max), matr_name(nb_max)
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    vect_coef(:) = 0.d0
    vect_name(:) = ' '
    matr_name(:) = ' '
    cntntp       = ' '
    cnchtp       = ' '
    ligrmo       = model(1:8)//'.MODELE'
    vediri       = '&&VEDIRI           .RELR'
    vechtp       = '&&VECHTP           .RELR'
    vadiri       = '&&NTACMV.VADIRI'
    vachtp       = '&&NTACMV.VACHTP'
    vatntp       = '&&NTACMV.VATNTP'
    time_curr    = tpsthe(1)
    lload_name   = list_load(1:19)//'.LCHA'
    lload_info   = list_load(1:19)//'.INFC'
    lload_func   = list_load(1:19)//'.FCHA'
!
! - Construct command variables fields
!
    call vrcins(model , mate, cara_elem, tpsthe(1), varc_curr,&
                codret)
!
! - Update <CARTE> for time
!
    call mecact('V', time, 'MODELE', ligrmo, 'INST_R',&
                ncmp=6, lnomcmp=nomcmp, vr=tpsthe)
!
! - Compute Dirichlet loads (AFFE_CHAR_THER)
!
    call vedith(model, list_load, time, vediri)
    call asasve(vediri, nume_dof, 'R', vadiri)
    call ascova('D', vadiri, lload_func, 'INST', tpsthe(1),&
                'R', cndiri)
!
! - Compute Dirichlet loads (AFFE_CHAR_CINE)
!
    cncine = ' '
    call ascavc(lload_name, lload_info, lload_func, nume_dof, tpsthe(1),&
                cncine)
!
! - Compute CHAR_THER_EVOL
!
    if (.not.l_stat) then
        call vetnth(model    , cara_elem, mate  , time,&
                    vtemp    , varc_curr, vetntp, 'V')
        call asasve(vetntp, nume_dof, 'R', vatntp)
        call jeveuo(vatntp, 'L', jtn)
        cntntp = zk24(jtn)
    endif
!
! - Compute Neumann loads (second member)
!
    call vechth('STAT', model    , lload_name, lload_info, cara_elem,&
                mate  , time_curr, time      , vtemp     , vechtp,&
                varc_curr_ = varc_curr)
    call asasve(vechtp, nume_dof, 'R', vachtp)
    call ascova('D', vachtp, lload_func, 'INST', tpsthe(1),&
                'R', cnchtp)
    if (l_stat) then
        call jedetr(vechtp)
    endif
!
! - Compute second member
!
    call vtzero(cn2mbr)
    if (l_stat) then
        nb_vect      = 2
        vect_coef(1) = 1.d0
        vect_coef(2) = 1.d0
        vect_name(1) = cnchtp(1:19)
        vect_name(2) = cndiri(1:19)
    else
        nb_vect      = 3
        vect_coef(1) = 1.d0
        vect_coef(2) = 1.d0
        vect_coef(3) = 1.d0
        vect_name(1) = cnchtp(1:19)
        vect_name(2) = cndiri(1:19)
        vect_name(3) = cntntp(1:19)
    endif
    do i_vect = 1, nb_vect
        call vtaxpy(vect_coef(i_vect), vect_name(i_vect), cn2mbr)
    end do
!
! - Compute matrix
!
    if (reasrg .or. reasms) then
        if (reasms) then
            call memsth(model    , cara_elem, mate, time, memass, 'V',&
                        varc_curr)
        endif

        if (reasrg) then
            call mergth(model    , list_load, cara_elem, mate, time,&
                        merigi   , 'V',&
                        time_curr, varc_curr)
        endif

        nb_matr = 0
        call jeexin(merigi(1:8)//'           .RELR', iret)
        if (iret .gt. 0) then
            call jeveuo(merigi(1:8)//'           .RELR', 'L', vk24 = v_resu_elem)
            if (v_resu_elem(1) .ne. ' ') then
                nb_matr = nb_matr + 1
                matr_name(nb_matr) = merigi(1:19)
            endif
        endif
        call jeexin(mediri(1:8)//'           .RELR', iret)
        if (iret .gt. 0) then
            call jeveuo(mediri(1:8)//'           .RELR', 'L', vk24 = v_resu_elem)
            if (v_resu_elem(1) .ne. ' ') then
                nb_matr = nb_matr + 1
                matr_name(nb_matr) = mediri(1:19)
            endif
        endif
        call jeexin(memass(1:8)//'           .RELR', iret)
        if (iret .gt. 0) then
            call jeveuo(memass(1:8)//'           .RELR', 'L', vk24 = v_resu_elem)
            if (v_resu_elem(1) .ne. ' ') then
                nb_matr = nb_matr + 1
                matr_name(nb_matr) = memass(1:19)
            endif
        endif
        call asmatr(nb_matr, matr_name, ' ', nume_dof, &
                    lload_info, 'ZERO', 'V', 1, matass)
    endif
!
    call jedema()
end subroutine

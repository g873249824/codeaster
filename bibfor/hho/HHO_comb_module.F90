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
module HHO_comb_module
!
use NonLin_Datastructure_type
use HHO_type
use HHO_statcond_module
use HHO_utils_module
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/asmari.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/dismoi.h"
#include "asterfort/getResuElem.h"
#include "asterfort/infniv.h"
#include "asterfort/jedetr.h"
#include "asterfort/mecact.h"
#include "asterfort/memare.h"
#include "asterfort/nmtime.h"
#include "asterfort/reajre.h"
#include "asterfort/redetr.h"
#include "asterfort/utmess.h"
#include "jeveux.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Module to combine matrices and vectors
!
! --------------------------------------------------------------------------------------------------
!
    private :: hhoSelectMatrElem, hhoCombMeca
    public  :: hhoPrepMatrix
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoSelectMatrElem(matr_elem, resu_elem_sym, resu_elem_unsym)
!
    implicit none
!
        integer, parameter :: nb_matr = 2
        character(len=19), intent(in)  :: matr_elem(nb_matr)
        character(len=19), intent(out) :: resu_elem_sym(nb_matr), resu_elem_unsym(nb_matr)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   To known if matr_elem are symmetric or not
!   In matr_elem        : name of elem. matrices to combine
!   Out resu_elem_sym   : names of matr_elem which are symmetric
!   Out resu_elem_unsym : names of matr_elem which are unsymmetric
!
! --------------------------------------------------------------------------------------------------
!
        character(len=19) :: resu_elem
        integer :: isym, i_matr, nb_mat_sym, nb_mat_unsym
!
! --------------------------------------------------------------------------------------------------
!
! ----- Initialization
!
        resu_elem_sym(:)   = ' '
        resu_elem_unsym(:) = ' '
!
        nb_mat_sym   = 0
        nb_mat_unsym = 0
!
! ---- Search if matr_elem exists and it is symmetric
!
        do i_matr = 1, nb_matr
            call hhoGetMatrElem(matr_elem(i_matr), resu_elem, isym)
!
            if(isym == 0) then
                nb_mat_unsym = nb_mat_unsym + 1
                resu_elem_unsym(nb_mat_unsym) = resu_elem
            elseif(isym == 1) then
                nb_mat_sym = nb_mat_sym + 1
                resu_elem_sym(nb_mat_sym) = resu_elem
            endif
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoCombMeca(model, mate, matr_elem, vect_elem, hhoField)
!
    implicit none
!
        character(len=24), intent(in) :: model
        character(len=*), intent(in)  :: mate
        character(len=19), intent(in) :: matr_elem(2), vect_elem(4)
        type(HHO_Field), intent(in) :: hhoField
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Combine vectors and matrices for cell quantities
!   In model        : name of model
!   In mate         : name of material characteristics (field)
!   In matr_elem    : name of elem. matrices to combine
!   In vect_elem    : name of vect. matrices to combine
!   In hhoField     : fields for HHO
!
! --------------------------------------------------------------------------------------------------
!
        integer, parameter :: nbin = 11
        integer, parameter :: nbout = 3
        character(len=8)  :: lpain(nbin), lpaout(nbout)
        character(len=19) :: lchin(nbin), lchout(nbout)
        character(len=19) :: ligrel_model, cart_comb
        character(len=16) :: option
        character(len=1)  :: base
        character(len=19) :: resu_elem_sym(2), resu_elem_unsym(2)
        integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
        call infniv(ifm, niv)
        if (niv .ge. 2) then
            call utmess('I', 'HHO2_13')
        endif
!
        base          = 'V'
        option        = 'HHO_COMB'
        ligrel_model  = model(1:8)//'.MODELE'
        cart_comb     = '&&HHO.CART_COMB'
!
! ----- Get RESU_ELEM from MATR_ELEM
!
        call hhoSelectMatrElem(matr_elem, resu_elem_sym, resu_elem_unsym)
!
! ----- Input fields
!
        lpain(1)  = 'PMATERC'
        lchin(1)  = mate
        lpain(2)  = 'PCMBHHO'
        lchin(2)  = cart_comb(1:19)
        lpain(3)  = 'PMAELS1'
        lchin(3)  = resu_elem_sym(1)
        lpain(4)  = 'PMAELS2'
        lchin(4)  = resu_elem_sym(2)
        lpain(5)  = 'PMAELNS1'
        lchin(5)  = resu_elem_unsym(1)
        lpain(6)  = 'PMAELNS2'
        lchin(6)  = resu_elem_unsym(2)
        lpain(8)  = 'PVEELE1'
        lchin(8)  = getResuElem(vect_elem_=vect_elem(1))
        lpain(9)  = 'PVEELE2'
        lchin(9)  = getResuElem(vect_elem_=vect_elem(2))
        lpain(10) = 'PVEELE3'
        lchin(10) = getResuElem(vect_elem_=vect_elem(3))
        lpain(11) = 'PVEELE4'
        lchin(11) = getResuElem(vect_elem_=vect_elem(4))
!
! ----- Prepare RESU_ELEM
!
        call jedetr(hhoField%matrcomb//'.RERR')
        call jedetr(hhoField%matrcomb//'.RELR')
        call jedetr(hhoField%vectcomb//'.RERR')
        call jedetr(hhoField%vectcomb//'.RELR')
        call memare(base, hhoField%matrcomb, model, mate, ' ', ' ')
        call memare(base, hhoField%vectcomb, model, mate, ' ', ' ')
!
! ----- Output fields
!
        lpaout(1) = 'PMATUUR'
        lchout(1) = hhoField%matrcomb(1:15)//'ME01'
        lpaout(2) = 'PMATUNS'
        lchout(2) = hhoField%matrcomb(1:15)//'ME02'
        lpaout(3) = 'PVECTUR'
        lchout(3) = hhoField%vectcomb(1:15)//'VE01'
!
! ----- Compute
!
        call calcul('S'  , option, ligrel_model, nbin  , lchin,&
                    lpain, nbout , lchout      , lpaout, base ,&
                    'OUI')
!
! ----- Set RESU_ELEM
!
        call reajre(hhoField%matrcomb, lchout(1), base)
        call reajre(hhoField%matrcomb, lchout(2), base)
        call redetr(hhoField%matrcomb)
        call reajre(hhoField%vectcomb, lchout(3), base)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoPrepMatrix(model         , mate       , merigi  , vefint   , rigid, hhoField,&
                             list_func_acti, hval_meelem, nume_dof, list_load, ds_algopara,&
                             ds_system, ds_measure, index_success , l_cond        , l_asse)
!
    implicit none
!
        character(len=24), intent(in) :: model
        character(len=*), intent(in)  :: mate
        character(len=19), intent(in) :: merigi, vefint, rigid
        type(HHO_Field), intent(in) :: hhoField
        integer, intent(in) :: list_func_acti(*)
        character(len=19), intent(in) :: hval_meelem(*)
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: list_load
        type(NL_DS_System), intent(in) :: ds_system
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        type(NL_DS_Measure), intent(inout) :: ds_measure
        aster_logical, intent(in) :: l_cond, l_asse
        integer, intent(out)      :: index_success
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Prepare rigidity matrix
!   In model        : name of model
!   In mate         : name of material characteristics (field)
!   In merigi       : name of the resultant rigidity matrix
!   In vefint       : name of the resultant rigidity vector
!   In hhoField     : fields for HHO
!   IO  ds_measure  : datastructure for measure and statistics management
!   Out index_success :  0 if success / 1  if fails
!
! --------------------------------------------------------------------------------------------------
!
        character(len=19) :: matr_elem(2), vect_elem(4)
        integer:: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
        call infniv(ifm, niv)
        if (niv .ge. 2) then
            call utmess('I', 'HHO2_14')
        endif
!
! ----- Initializations
!
        matr_elem(:) = ' '
        vect_elem(:) = ' '
!
        if (l_cond) then
!
! --------- Get names of matrices/vectors
!
            matr_elem(1) = merigi
            vect_elem(1) = vefint
!
! --------- Combine matrices/vectors
!
            call nmtime(ds_measure, 'Init', 'HHO_Comb')
            call nmtime(ds_measure, 'Launch', 'HHO_Comb')
            call hhoCombMeca(model, mate, matr_elem, vect_elem, hhoField)
            call nmtime(ds_measure, 'Stop', 'HHO_Comb')
!
! --------- Condensation
!
            call nmtime(ds_measure, 'Init', 'HHO_Cond')
            call nmtime(ds_measure, 'Launch', 'HHO_Cond')
            call hhoMecaCondOP(model, hhoField, merigi, vefint, index_success)
            call nmtime(ds_measure, 'Stop', 'HHO_Cond')
        endif
!
! ----- Assembly
!
        if (l_asse) then
            call nmtime(ds_measure, 'Init', 'Matr_Asse')
            call nmtime(ds_measure, 'Launch', 'Matr_Asse')
            call asmari(list_func_acti, hval_meelem, ds_system, nume_dof, list_load, ds_algopara, &
                        rigid)
            call nmtime(ds_measure, 'Stop', 'Matr_Asse')
        endif
!
    end subroutine
!
end module

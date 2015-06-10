subroutine nmdomt(algo_meth, algo_para)
!
implicit none
!
#include "asterc/getvid.h"
#include "asterc/getvis.h"
#include "asterc/getvr8.h"
#include "asterc/getvtx.h"
#include "asterc/getfac.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/u2mesg.h"
#include "asterfort/u2mess.h"
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(inout) :: algo_meth(*)
    real(kind=8), intent(inout) :: algo_para(*)
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Read
!
! Parameters of non-linear algorithm
!
! --------------------------------------------------------------------------------------------------
!
! IO  algo_meth        : parameters for algorithm methods
!                 1 : NOM DE LA METHODE NON LINEAIRE (NEWTON OU IMPLEX)
!                     (NEWTON OU NEWTON_KRYLOV OU IMPLEX)
!                 2 : TYPE DE MATRICE (TANGENTE OU ELASTIQUE)
!                 3 : -- INUTILISE --
!                 4 : -- INUTILISE --
!                 5 : METHODE D'INITIALISATION
!                 6 : NOM CONCEPT EVOL_NOLI SI PREDICTION 'DEPL_CALCULE'
!                 7 : METHODE DE RECHERCHE LINEAIRE
! IO  algo_para        : parameters for algorithm criteria
!                 1 : REAC_INCR
!                 2 : REAC_ITER
!                 3 : PAS_MINI_ELAS
!                 4 : REAC_ITER_ELAS
!                 5 : ITER_LINE_MAXI
!                 6 : RESI_LINE_RELA
!                 7 : RHO_MIN
!                 8 : RHO_MAX
!                 9 : RHO_EXCL
!
! --------------------------------------------------------------------------------------------------
!
    integer :: reac_incr, reac_iter, reac_iter_elas, iter_line_maxi
    real(kind=8) :: pas_mini_elas, resi_line_rela
    real(kind=8) :: reli_rho_mini, reli_rho_maxi, reli_rho_excl
    integer :: ifm, niv, ibid
    integer :: iret, nocc, vali(2)
    character(len=16) :: reli_meth, keywf
    character(len=32) :: valk
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... LECTURE DONNEES RESOLUTION'
    endif
!
! - Get method
!
    keywf = 'NEWTON'
    call getvtx(' ', 'METHODE',1, ibid, 1, algo_meth(1), ibid)
    if ((algo_meth(1) .eq. 'NEWTON') .or. (algo_meth(1) .eq. 'NEWTON_KRYLOV')) then
        call getvtx(keywf, 'MATRICE', 1, ibid, 1, algo_meth(2), ibid)
        call getvtx(keywf, 'PREDICTION', 1, ibid, 1, algo_meth(5), iret)

        if (iret .le. 0) then
            algo_meth(5) = algo_meth(2)
        endif
        if (algo_meth(5) .eq. 'DEPL_CALCULE') then
            vali(1) = 13
            vali(2) = 4
            valk    = "PREDICTION='DEPL_CALCULE'"
            call u2mesg('A', 'SUPERVIS_9', 1, valk, 2, vali, 0, 0.d0) 
            call u2mess('A', 'MECANONLINE5_57') 
            call getvid(keywf, 'EVOL_NOLI', 1, ibid, 1, algo_meth(6), iret)

            if (iret .le. 0) then
                call u2mess('F', 'MECANONLINE5_45')
            endif
        endif
    else if (algo_meth(1) .eq. 'IMPLEX') then
        algo_meth(5) = 'TANGENTE'
    else
        call assert(.false.)
    endif
!
! - Get parameters (method)
!
    if ((algo_meth(1) .eq. 'NEWTON') .or. (algo_meth(1) .eq. 'NEWTON_KRYLOV')) then
        call getvis(keywf, 'REAC_INCR', 1, ibid, 1, reac_incr, ibid)
        if (reac_incr .lt. 0) then
            call assert(.false.)
        else
            algo_para(1) = reac_incr
        endif
        call getvis(keywf, 'REAC_ITER', 1, ibid, 1, reac_iter, ibid)
        if (reac_iter .lt. 0) then
            call assert(.false.)
        else
            algo_para(2) = reac_iter
        endif
        call getvr8(keywf, 'PAS_MINI_ELAS', 1, ibid, 1, pas_mini_elas, iret)
        if (iret .le. 0) then
            algo_para(3) = -9999.0d0
        else
            algo_para(3) = pas_mini_elas
        endif
        call getvis(keywf, 'REAC_ITER_ELAS', 1, ibid, 1, reac_iter_elas, ibid)
        if (reac_iter .lt. 0) then
            call assert(.false.)
        else
            algo_para(4) = reac_iter_elas
        endif
    else if (algo_meth(1) .eq. 'IMPLEX') then
        algo_para(1) = 1
    else
        call assert(.false.)
    endif
!
! - Get parameters (line search)
!
    keywf  = 'RECH_LINEAIRE'
    reli_meth = 'CORDE'
    iter_line_maxi = 0
    resi_line_rela = 1.d-3
    reli_rho_mini = 0.d0
    reli_rho_maxi = 1.d0
    reli_rho_excl = 0.d0
!
    call getfac(keywf, nocc)
    if (nocc .ne. 0) then
        call getvtx(keywf, 'METHODE'       , 1, ibid, 1, reli_meth, ibid)
        call getvr8(keywf, 'RESI_LINE_RELA', 1, ibid, 1, resi_line_rela, ibid)
        call getvis(keywf, 'ITER_LINE_MAXI', 1, ibid, 1, iter_line_maxi, ibid)
        call getvr8(keywf, 'RHO_MIN'       , 1, ibid, 1, reli_rho_mini, ibid)
        call getvr8(keywf, 'RHO_MAX'       , 1, ibid, 1, reli_rho_maxi, ibid)
        call getvr8(keywf, 'RHO_EXCL'      , 1, ibid, 1, reli_rho_excl, ibid)
        if (reli_rho_mini .ge. -reli_rho_excl .and. reli_rho_mini .le. reli_rho_excl) then
            call u2mess('A', 'MECANONLINE5_46')
            reli_rho_mini = +reli_rho_excl
        endif
        if (reli_rho_maxi .ge. -reli_rho_excl .and. reli_rho_maxi .le. reli_rho_excl) then
            call u2mess('A', 'MECANONLINE5_47')
            reli_rho_maxi = -reli_rho_excl
        endif
        if (reli_rho_maxi .lt. reli_rho_mini) then
            call u2mess('A', 'MECANONLINE5_44')
            call getvr8(keywf, 'RHO_MIN', 1, ibid, 0, reli_rho_maxi, ibid)
            call getvr8(keywf, 'RHO_MAX', 1, ibid, 0, reli_rho_mini, ibid)
        endif
        if (abs(reli_rho_maxi-reli_rho_mini) .le. r8prem()) then
            call u2mess('F', 'MECANONLINE5_43')
        endif
    endif
!
    algo_meth(7) = reli_meth
    algo_para(5) = iter_line_maxi
    algo_para(6) = resi_line_rela
    algo_para(7) = reli_rho_mini
    algo_para(8) = reli_rho_maxi
    algo_para(9) = reli_rho_excl
!
end subroutine

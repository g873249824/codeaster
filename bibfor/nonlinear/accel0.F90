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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine accel0(modele    , numedd   , fonact, lischa,&
                  ds_contact, maprec   , solveu, valinc, sddyna,&
                  ds_measure, ds_system, meelem, measse,&
                  veelem    , veasse   , solalg)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/copisd.h"
#include "asterfort/detlsp.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/infdbg.h"
#include "asterfort/lspini.h"
#include "asterfort/nmassi.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nmprac.h"
#include "asterfort/nmreso.h"
#include "asterfort/utmess.h"
#include "asterfort/vtzero.h"
#include "asterfort/nonlinLoadDirichletCompute.h"
!
character(len=19) :: solveu, maprec, lischa
character(len=19) :: sddyna
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: numedd, modele
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: meelem(*), measse(*), veasse(*), veelem(*)
character(len=19) :: solalg(*), valinc(*)
integer :: fonact(*)
type(NL_DS_System), intent(in) :: ds_system
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (DYNAMIQUE)
!
! CALCUL DE L'ACCELERATION INITIALE
!
! --------------------------------------------------------------------------------------------------
!
!     ==> ON SUPPOSE QUE LA VITESSE INITIALE EST NULLE
!                    QUE LES DEPLACEMENTS IMPOSES SONT NULS
!     ==> ON NE PREND EN COMPTE QUE LES CHARGES DYNAMIQUES, CAR LES
!         CHARGES STATIQUES SONT EQUILIBREES PAR LES FORCES INTERNES
!
!
! IN  MODELE : NOM DU MODELE
! IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
! IN  LISCHA : LISTE DES CHARGES
! In  ds_contact       : datastructure for contact management
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_system        : datastructure for non-linear system management
! IN  SDDYNA : SD POUR LA DYNAMIQUE
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: neq
    integer :: faccvg, rescvg
    character(len=19) :: matass, depso1, depso2
    character(len=19) :: cncine, cncinx, cndonn, k19bla
    character(len=19) :: disp_prev, acce_prev
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_26')
    endif
    call utmess('I', 'MECANONLINE_24')
!
! - Initializations
!
    k19bla = ' '
    cndonn = '&&CNCHAR.DONN'
    cncinx = '&&CNCHAR.CINE'
    matass = '&&ACCEL0.MATASS'
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
!
! --- DECOMPACTION VARIABLES CHAPEAUX
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(valinc, 'VALINC', 'ACCMOI', acce_prev)
    call nmchex(veasse, 'VEASSE', 'CNCINE', cncine)
    call nmchex(solalg, 'SOLALG', 'DEPSO1', depso1)
    call nmchex(solalg, 'SOLALG', 'DEPSO2', depso2)
!
! --- ASSEMBLAGE ET FACTORISATION DE LA MATRICE
!
    call nmprac(fonact, lischa    , numedd    , solveu     ,&
                sddyna, ds_measure, ds_contact, &
                meelem, measse    , maprec    , matass     , faccvg)
    if (faccvg .eq. 2) then
        call vtzero(acce_prev)
        call utmess('A', 'MECANONLINE_69')
        goto 999
    endif
!
! - Compute values of Dirichlet conditions
!
    call nonlinLoadDirichletCompute(lischa    , modele, numedd,&
                                    ds_measure, matass, disp_prev,&
                                    veelem    , veasse)
!
! - Evaluate second member for initial acceleration
!
    call nmassi(fonact, sddyna, ds_system, veasse, cndonn)
!
! --- POUR LE CALCUL DE DDEPLA, IL FAUT METTRE CNCINE A ZERO
!
    call copisd('CHAMP_GD', 'V', cncine, cncinx)
    call vtzero(cncinx)
!
! --- RESOLUTION DIRECTE
!
    call nmreso(fonact, cndonn, k19bla, cncinx, solveu,&
                maprec, matass, depso1, depso2, rescvg)
    if (rescvg .eq. 1) then
        call vtzero(acce_prev)
        call utmess('A', 'MECANONLINE_70')
        goto 999
    endif
!
! --- DEPENDAMMENT DU SOLVEUR, TRAITEMENT PARTICULIER
!
    call lspini(solveu)
!
! --- RECOPIE SOLUTION
!
    call copisd('CHAMP_GD', 'V', depso1, acce_prev)
!
999 continue
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ...... ACCMOI : '
        call nmdebg('VECT', acce_prev, ifm)
    endif
!
! --- MENAGE
!
! --- EN PREMIER DE L'EVENTUELLE INSTANCE MUMPS (SI PRE_COND 'LDLT_SP')
    call detlsp(matass, solveu)
! --- EN SECOND DE LA MATRICE ASSEMBLEE
    call detrsd('MATR_ASSE', matass)
!
end subroutine

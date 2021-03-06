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
subroutine nminma(lischa, sddyna, numedd,&
                  numfix, meelem, measse)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mtdscr.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
#include "asterfort/utmess.h"
#include "asterfort/asmama.h"
#include "asterfort/asmaam.h"
!
character(len=19) :: lischa, sddyna
character(len=24) :: numedd, numfix
character(len=19) :: meelem(*), measse(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! PRE-CALCUL DES MATRICES ASSEMBLEES CONSTANTES AU COURS DU CALCUL
!
! ----------------------------------------------------------------------
!
! IN  LISCHA : LISTE DES CHARGEMENTS
! IN  SDDYNA : SD DYNAMIQUE
! IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! IN  MEELEM : MATRICES ELEMENTAIRES
! OUT MEASSE : MATRICES ASSEMBLEES
!
! ----------------------------------------------------------------------
!
    aster_logical :: ldyna, lexpl, limpl, lamor, lktan
    integer :: ifm, niv
    character(len=16) :: optass
    character(len=19) :: masse, amort
    character(len=19) :: memass, meamor, mediri
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','MECANONLINE13_22')
    endif
!
! --- INITIALISATIONS
!
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
    lexpl = ndynlo(sddyna,'EXPLICITE')
    limpl = ndynlo(sddyna,'IMPLICITE')
    lamor = ndynlo(sddyna,'MAT_AMORT')
    lktan = ndynlo(sddyna,'RAYLEIGH_KTAN')
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(meelem, 'MEELEM', 'MEMASS', memass)
    call nmchex(meelem, 'MEELEM', 'MEAMOR', meamor)
    call nmchex(meelem, 'MEELEM', 'MEDIRI', mediri)
    call nmchex(measse, 'MEASSE', 'MEMASS', masse)
    call nmchex(measse, 'MEASSE', 'MEAMOR', amort)
!
! --- ASSEMBLAGE DE LA MATRICE MASSE
!
    if (ldyna) then
        if (limpl) then
            optass = ' '
        else if (lexpl) then
            optass = 'AVEC_DIRICHLET'
        else
            ASSERT(.false.)
        endif
        if (niv .ge. 2) then
            call utmess('I','MECANONLINE13_23')
        endif
        if (optass .eq. ' ') then
            call asmama(memass, ' ', numfix, lischa, masse)
        else if (optass.eq.'AVEC_DIRICHLET') then
            call asmama(memass, mediri, numedd, lischa, masse)
        endif
    endif
!
! --- ASSEMBLAGE DE LA MATRICE AMORTISSEMENT
!
    if (lamor .and. .not.lktan) then
        if (niv .ge. 2) then
            call utmess('I','MECANONLINE13_24')
        endif
        call asmaam(meamor, numedd, lischa, amort)
        call mtdscr(amort)
    endif
!
    call jedema()
end subroutine

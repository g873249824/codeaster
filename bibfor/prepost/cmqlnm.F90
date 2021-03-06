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

subroutine cmqlnm(main, nomaqu, nbma, nonomi, nbnm)
! person_in_charge: nicolas.sellenet at edf.fr
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cncinv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    integer :: nbma, nbnm
    character(len=8) :: main
    character(len=24) :: nomaqu, nonomi
! ----------------------------------------------------------------------
!         TRANSFORMATION DES MAILLES QUADRATIQUES -> LINEAIRE
!-----------------------------------------------------------------------
!     -   ON RECUPERE LES NOEUDS MILIEUX
!     -   ON VERIFIE QUE LES NOEUDS MILIEUX COMMUNS A PLUSIEURS MAILLES
!         QUADRATIQUES APPARTIENNENT AUX MAILLES REFERENCEES.
!         SI DEUX MAILLES QUADRATIQUES SE PARTAGENT UN NOEUD MILIEU ET
!         QUE L'UTILISATEUR NE LINEARISE QU'UNE DES 2 MAILLES, ALORS
!         ON EMET UNE ALARME
!-----------------------------------------------------------------------
! IN        MAIN   K8  NOM DU MAILLAGE INITIAL
! IN        NOMAQU K24 NOM DE L'OBJET JEVEUX QUI CONTIENT LE NUMERO
!                      DES MAILLES QUADRATIQUES
! IN        NBMA   I   NOMBRE DE MAILLES QUADRATIQUES TRAITEES
! IN        NONOMI K24 NOM DE L'OBJET JEVEUX A ALLOUER CONTENANT LES
!                      NUMEROS DES NOEUDS A SUPPRIMER
! OUT       NBNM   I   NOMBRE DE NOEUDS MILIEUX A RECUPERER
!-----------------------------------------------------------------------
!
!  ======      ====      =================   ========================
!  MAILLE      TYPE      NB NOEUDS MILIEUX   POSITION DU PREMIER NOEUD
!  ======      ====      =================   MILIEU DANS LA MAILLE
!                                            ========================
!
!  SEG3         4             1                    3
!  TRIA6        9             3                    4
!  QUAD8       14             4                    5
!  QUAD9       16             5                    5
!  TETRA10     19             6                    5
!  PENTA15     21             9                    7
!  PENTA18     22            12                    7
!  PYRAM13     24             8                    6
!  HEXA20      26            12                    9
!  HEXA27      27            19                    9
!
!
    aster_logical :: isasup
!
    integer :: iacnx1, ilcnx1, ii, nbmato, numma
    integer :: ilcnx2, nbtyma, nbnoto, jj, jmaqu, nbnosu, numamo, nbnomi
    integer :: ponomi, jco, nunomi, nbm1, kk, numa2, jnomi
    parameter(nbtyma=27)
    integer :: nbnmtm(nbtyma), ppnm(nbtyma)
    integer, pointer :: tab_ma(:) => null()
    integer, pointer :: tab_no(:) => null()
    integer, pointer :: typmail(:) => null()
    integer, pointer :: coninv(:) => null()
    integer, pointer :: dime(:) => null()
!
!     NBNMTM: NOMBRE DE NOEUDS MILIEU PAR TYPE DE MAILLE
!     PPNM:   POSITION DU PREMIER NOEUD MILIEU PAR TYPE DE MAILLE
!
    data nbnmtm /3*0,1,4*0,3,4*0,4,0,5,2*0, 6,0,9,12,0,8,0,12,19/
    data ppnm   /3*0,3,4*0,4,4*0,5,0,5,2*0, 5,0,7,7, 0,6,0,9, 9/
!
    call jemarq()
!
    ASSERT(nbma.gt.0)
!
    call jeveuo(nomaqu, 'L', jmaqu)
    call jeveuo(main//'.TYPMAIL', 'L', vi=typmail)
    call jeveuo(main//'.CONNEX', 'L', iacnx1)
    call jeveuo(jexatr(main//'.CONNEX', 'LONCUM'), 'L', ilcnx1)
!
    call jeveuo(main//'.DIME', 'L', vi=dime)
    nbmato = dime(3)
    nbnoto = dime(1)
!
    AS_ALLOCATE(vi=tab_ma, size=nbmato)
!
    do ii = 1, nbma
        numma = zi(jmaqu+ii-1)
        tab_ma(numma) = 1
    enddo
!
    AS_ALLOCATE(vi=tab_no, size=nbnoto)
!
!     CREATION DE LA CONNECTIVITE INVERSE
    call cncinv(main, [0], 0, 'V', '&&CMQLNM.CONINV')
    call jeveuo('&&CMQLNM.CONINV', 'L', vi=coninv)
    call jeveuo(jexatr('&&CMQLNM.CONINV', 'LONCUM'), 'L', ilcnx2)
!
!     BOUCLE SUR LES MAILLES A MODIFIER
    nbnosu = 0
    do ii = 1, nbma
        numamo = zi(jmaqu+ii-1)
        nbnomi = nbnmtm(typmail(numamo))
        ponomi = ppnm(typmail(numamo))
!
        jco=iacnx1+ zi(ilcnx1-1+numamo)-1
!       BOUCLE SUR LES NOEUDS MILIEUX DE CES MAILLES
        do jj = 1, nbnomi
            nunomi = zi(jco+ponomi-1+jj-1)
!
!         SI LE NOEUD A DEJA ETE TRAITE ON NE LE TRAITE PAS
            if (tab_no(nunomi) .ne. 0) cycle
!
            nbm1 = zi(ilcnx2+nunomi)-zi(ilcnx2-1+nunomi)
!
!         BOUCLE SUR LES MAILLES AUXQUELLES SONT LIEES CE NOEUD
            isasup = .true.
            do kk = 1, nbm1
                numa2 = coninv(1+zi(ilcnx2-1+nunomi)-1+kk-1)
!           SI UNE DE CES MAILLES N'EST PAS A MODIFIER ALORS ON
!           NE DOIT PAS SUPPRIMER LE NOEUD
                if (tab_ma(numa2) .eq. 0) isasup = .false.
            enddo
            if (isasup) then
                tab_no(nunomi) = 2
                nbnosu = nbnosu + 1
            else
                tab_no(nunomi) = 1
            endif
        enddo
    enddo
!
    AS_DEALLOCATE(vi=tab_ma)
!
    if (nbnosu .eq. 0) then
        call utmess('F', 'MODELISA4_3')
    endif
    call wkvect(nonomi, 'V V I', nbnosu, jnomi)
!
    nbnm = nbnosu
!
    nbnosu = 0
    do ii = 1, nbnoto
        if (tab_no(ii) .eq. 2) then
            nbnosu = nbnosu+1
            zi(jnomi+nbnosu-1) = ii
        endif
    enddo
!
    ASSERT(nbnosu.eq.nbnm)
!
    AS_DEALLOCATE(vi=tab_no)
!
    call jedema()
!
end subroutine

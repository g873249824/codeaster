subroutine pjxxco(typcal, method, lcorre, isole, resuin,&
                  cham1, moa1, moa2, noma1, noma2,&
                  cnref, noca)
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
!   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
! commande:  PROJ_CHAMP
! but : routine "chapeau" concernant la sd lcorresp_2_mailla
!
!  on regarde les types de champs a projeter
!    on emet des messages d'alarme si la methode ne peut les projeter
!    (ex. : 'collocation' ne sait pas traiter les cham_elem elga)
!
!  si tout est coherent, on appelle :
!    pjefco via le 1er argt de la sd lcorresp_2_mailla ('collocation')
!    pjelco via le 2nd argt de la sd lcorresp_2_mailla ('ecla_pg')
!
!  le cas de la methode 'nuage_deg' est plus particulier :
!    on fait donc un test a part
!
    implicit   none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/pjefco.h"
#include "asterfort/pjeftc.h"
#include "asterfort/pjelco.h"
#include "asterfort/pjngco.h"
#include "asterfort/pjspco.h"
#include "asterfort/pjtyco.h"
#include "asterfort/u2mesk.h"
    logical :: isole
    character(len=4) :: typcal
    character(len=8) :: resuin
    character(len=8) :: moa1, moa2, corru
    character(len=8) :: noma1, noma2, cnref, noca
    character(len=16) :: lcorre(2), k16bid, cortmp
    character(len=19) :: cham1, method
!
!
! 0.2. ==> COMMUNS
! ----------------------------------------------------------------------
    character(len=24) :: valk(2)
!
! 0.3. ==> VARIABLES LOCALES
!
!
    logical :: lnoeu, lelno, lelem, lelga, proj1
!
!
! DEB ------------------------------------------------------------------
    call jemarq()
!
!
!
! 1. CAS DE LA METHODE 'NUAGE_DEG'
! --------------------------------
!
    if (method(1:10) .eq. 'NUAGE_DEG_') then
        call assert(typcal.eq.'1ET2')
        call pjngco(lcorre(1), noma1, noma2, method, cnref,&
                    'V')
!
    else
!
! 2. AUTRE METHODE
! --------------------------------
!
!
!       -- SI TYPCAL='1' => 'COLLOCATION' OU 'COUPLAGE' SEULEMENT :
        if (typcal .eq. '1') then
            call assert(resuin.eq.' ' .and. cham1.eq.' ')
            call assert(method.eq.'COLLOCATION'.or.method.eq.'COUPLAGE')
            call getres(corru, k16bid, k16bid)
            cortmp='&&PJXXCO.CORRES'
            if (method .eq. 'COLLOCATION') then
                call pjefco(moa1, moa2, cortmp, 'V')
            else if (method.eq.'COUPLAGE') then
!   METHODE POUR LE COUPLAGE VIA YACS AVEC SATURENE POUR IFS
                call pjeftc(noma1, noma2, cortmp, 'V')
            endif
            call copisd('CORRESP_2_MAILLA', 'G', cortmp, corru)
            call detrsd('CORRESP_2_MAILLA', cortmp)
!
!
        else
            call assert(typcal.eq.'1ET2')
!
!         -- QUELS SONT LES TYPES DE CHAMPS A PROJETER ?
            call pjtyco(isole, resuin, cham1, lnoeu, lelno,&
                        lelem, lelga)
!
!
!         -- VERIFICATION DE LA COHERENCE DE LA DEMANDE
!         -- FORMULEE PAR L'UTILISATEUR
            if ((method.eq.'ECLA_PG') .and. (.not.lelga)) then
                valk(1) = method
                if (lnoeu) then
                    call u2mesk('F', 'CALCULEL5_32', 1, valk)
                else
                    if (lelno) valk(2) = 'ELNO'
                    if (lelem) valk(2) = 'ELEM'
                    call u2mesk('F', 'CALCULEL5_33', 2, valk)
                endif
            endif
!
            if ((method.eq.'COLLOCATION') .and. (.not.lnoeu) .and. ( .not.lelno) .and.&
                (.not.lelem)) then
                call assert(lelga)
                valk(1) = method
                valk(2) = 'ELGA'
                call u2mesk('F', 'CALCULEL5_33', 2, valk)
            endif
!
            if ((method.eq.'SOUS_POINT') .and. (.not.lnoeu) .and. ( .not.lelno)) then
                call assert(lelga .or. lelem)
                valk(1) = method
                valk(2) = 'ELGA ET ELEM'
                call u2mesk('F', 'CALCULEL5_33', 2, valk)
            endif
!
!         -- ON UTILISE LCORRE(1) OU LCORRE(2) SUIVANT LE TYPE DE CHAMP
            proj1=.false.
            if ((lnoeu) .or. (lelno) .or. (lelem)) then
                if (method(1:10).eq.'SOUS_POINT') then
                    call pjspco(moa1, moa2, lcorre(1), 'V', noca)
                else
                    call pjefco(moa1, moa2, lcorre(1), 'V')
                endif
                proj1=.true.
            endif
!
            if (lelga) then
                if (isole) then
                    if ((method.eq.'ECLA_PG') .or. (method.eq.'AUTO')) then
                        call pjelco(moa1, moa2, cham1, lcorre(2), 'V')
                    else
                        valk(1)=method
                        call u2mesk('F','CALCULEL5_62',1,valk)
                    endif
                else
                    if (.not.proj1)  call u2mess('F','CALCULEL5_61')
                endif
            endif
        endif
    endif
!
!
!
    call jedema()
end subroutine

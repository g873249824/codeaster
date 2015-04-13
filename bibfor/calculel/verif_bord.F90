subroutine verif_bord(modele,ligrel)
    implicit none
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
! person_in_charge: jacques.pellet at edf.fr
!
#include "jeveux.h"
#include "asterfort/liglma.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/assert.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/u2mesk.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexatr.h"
#include "asterfort/wkvect.h"
!
    character(len=*), intent(in) :: modele
    character(len=*), intent(in) :: ligrel
!
!-----------------------------------------------------------------------
!   But :
!     Emettre des alarmes si le ligrel ne contient pas toutes les mailles
!     de bord necessaires.
!
!   Entrees:
!     modele     :  sd_modele
!     ligrel     :  sous-ligrel du modele
!
!
!    Algorithme :
!      On parcourt toutes les mailles du modele : ima
!         Si ima n'appartient pas au ligrel
!            Si tous les noeuds de ima sont des noeuds du ligrel => Alarme
!
!-----------------------------------------------------------------------
    character(len=8) :: modele_, noma, k8bid
    character(len=19) :: ligrel_, ligrmo
    character(len=24) :: valk(4)
    integer :: nbmamo, nbmalg, numa, kma, nbmat, jmat, jnot
    integer :: iconx1, iconx2, nno, nuno, kno, nbnot, ibid
    integer :: jmamo, jmalg

    character(len=24) :: linumamo = '&&VERIF_BORD.NUMAMO'
    character(len=24) :: linutemo = '&&VERIF_BORD.NUTEMO'
    character(len=24) :: linumalg = '&&VERIF_BORD.NUMALG'
    character(len=24) :: linutelg = '&&VERIF_BORD.NUTELG'


#define nbno(imail) zi(iconx2+imail) - zi(iconx2+imail-1)
#define connex(imail,j) zi(iconx1-1+zi(iconx2+imail-1)+j-1)


!-----------------------------------------------------------------------
!
    call jemarq()
    modele_=modele
    ligrmo=modele_//'.MODELE'
    ligrel_=ligrel

    call dismoi('C', 'NOM_MAILLA', modele, 'MODELE', ibid, noma, ibid)
    call dismoi('C', 'NB_MA_MAILLA', noma, 'MAILLAGE', nbmat, k8bid, ibid)
    call dismoi('C', 'NB_NO_MAILLA', noma, 'MAILLAGE', nbnot, k8bid, ibid)
    call jeveuo(noma//'.CONNEX', 'L', iconx1)
    call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', iconx2)

    call liglma(ligrmo, nbmamo, linumamo, linutemo)
    call liglma(ligrel_, nbmalg, linumalg, linutelg)
    call jeveuo(linumamo,'L',jmamo)
    call jeveuo(linumalg,'L',jmalg)


!   -- 1. Calcul de eximalg et exinolg :
!      eximalg(numa) = 1 : la maille numa existe dans ligrel
!      exinolg(nuno) = 1 : le noeud numo existe dans ligrel
!   ----------------------------------------------------------
    call wkvect('eximalg', 'V V I', nbmat, jmat)
    call wkvect('exinolg', 'V V I', nbnot, jnot)
    zi(jmat-1+1) = 0
    zi(jnot-1+1) = 0
    do kma=1,nbmalg
        numa=zi(jmalg-1+kma)
        zi(jmat-1+numa)=1
        nno=nbno(numa)
        do kno=1,nno
           nuno=connex(numa,kno)
           call assert(nuno.gt.0 .and. nuno.le.nbnot)
           zi(jnot-1+nuno)=1
        enddo
    enddo

!   -- 2. boucle sur les mailles de modele :
!   ----------------------------------------
B1: do kma=1,nbmamo
        numa=zi(jmamo-1+kma)
        if (zi(jmat-1+numa).eq.1) cycle B1

        nno=nbno(numa)
        do kno=1,nno
           nuno=connex(numa,kno)
           if (zi(jnot-1+nuno).eq.0) cycle B1
        enddo
        valk(1)=modele
        call jenuno(jexnum(noma//'.NOMMAI', numa), valk(2))
        call u2mesk('A','CALCULEL4_74',2,valk)
    enddo  B1


!   -- menage :
!   -----------
    call jedetr(linumamo)
    call jedetr(linutemo)
    call jedetr(linumalg)
    call jedetr(linutelg)
    call jedetr('eximalg')
    call jedetr('exinolg')


    call jedema()
end subroutine

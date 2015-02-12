subroutine vrcins(modelz, chmatz, carelz, inst, chvarc,&
                  codret)
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
!   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
    implicit none
#include "jeveux.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/cescel.h"
#include "asterfort/cesexi.h"
#include "asterfort/dismoi.h"
#include "asterfort/imprsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/u2mesk.h"
#include "asterfort/vrcin1.h"
#include "asterfort/vrcin2.h"
#include "asterfort/detrsd.h"
!
    character(len=2) :: codret
    character(len=19) :: chvarc
    character(len=*) :: chmatz, carelz, modelz
    real(kind=8) :: inst
! ======================================================================
!   BUT : FABRIQUER LE CHAMP DE VARIABLES DE COMMANDE CORRESPONDANT A
!         UN INSTANT DONNE.
!   ARGUMENTS :
!   MODELZ (K8)  IN/JXIN : SD MODELE
!   CHMATZ (K8)  IN/JXIN : SD CHAM_MATER
!   CARELZ (K8)  IN/JXIN : SD CARA_ELEM (SOUS-POINTS)
!   INST   (R)   IN      : VALEUR DE L'INSTANT
!   CHVARC (K19) IN/JXOUT: SD CHAM_ELEM/ELGA CONTENANT LES VARC
!   CODRET (K2)  OUT : POUR CHAQUE RESULTAT, 'OK' SI ON A TROUVE,
!                                            'NO' SINON
!
!
! ----------------------------------------------------------------------
!
!
    integer :: iret, ichs, nbchs, jlissd, jlisch, jcesd, jcesv, jcesl
    integer :: jcvcmp, jcesc, nbcmp, kcmp, kcvrc
    integer :: nbma, ima, nbpt, nbsp, ipt, isp, iad, iad1
    integer :: jcvvar, jce1d, jce1l, jce1v, jcesvi, nncp, n1, k
    real(kind=8) :: valeur, rundef, rbid
    character(len=19) :: chvars, ligrmo, chs
    character(len=8) :: kbid
    character(len=24) :: valk(5)
    character(len=16) :: nomte
    logical :: avrc, dbg
    integer :: ibid, nbcvrc, nute, jmaille, vali(2)
    character(len=8) :: modele, chmat, carele, varc1, varc2, nocmp1, nocmp2, noma, nomail
    logical :: exival
! ----------------------------------------------------------------------
!
    call jemarq()
!
    chmat=chmatz
    carele=carelz
    modele=modelz
    call detrsd('CHAM_ELEM', chvarc)
!
!
    call jeexin(chmat//'.CVRCVARC', iret)
!     AVRC : .TRUE. SI AFFE_MATERIAU/AFFE_VARC EST UTILISE
    avrc=(iret.gt.0)
    if (.not.avrc) goto 9999
!
!
!     1. INTERPOLATION EN TEMPS :
!        FABRICATION D'UNE LISTE DE CHAM_ELEM_S / ELGA
!        CONTENANT LES VRC A L'INSTANT INST
!        CALCUL DE  CHMAT.LISTE_CH(:) ET CHMAT.LISTE_SD(:)
!     -----------------------------------------------------
    call vrcin1(modele, chmat, carele, inst, codret)
!
!     1.1 SI IL N'Y A PAS VRAIMENT DE VARIABLES DE COMMANDE
!         (PAR EXEMPLE IL EXISTE TEMP/VALE_REF MAIS PAS DE TEMP
    call jeexin(chmat//'.LISTE_SD', iret)
    if (iret .eq. 0) goto 9999
!
!
!     2. ALLOCATION DU CHAMP_ELEM_S RESULTAT (CHVARS)
!        CALCUL DE CHMAT.CESVI
!        (CETTE ETAPE EST ECONOMISEE D'UN INSTANT A L'AUTRE)
!     -------------------------------------------------------------
    chvars=chmat//'.CHVARS'
    call jeexin(chmat//'.CESVI', iret)
    if (iret .eq. 0) call vrcin2(modele, chmat, carele, chvars)
!
!
!     3. CONCATENATION DES CHAMPS DE .LISTE_CH  DANS CHVARS :
!     -----------------------------------------------------
    call jeveuo(chmat//'.LISTE_CH', 'L', jlisch)
    call jelira(chmat//'.LISTE_CH', 'LONMAX', nbchs, kbid)
    call jeveuo(chmat//'.LISTE_SD', 'L', jlissd)
    call jeveuo(chmat//'.CVRCVARC', 'L', jcvvar)
    call jeveuo(chmat//'.CVRCCMP', 'L', jcvcmp)
    call jelira(chmat//'.CVRCCMP', 'LONMAX', nbcvrc, kbid)
!
    call jeveuo(chvars//'.CESD', 'L', jce1d)
    call jeveuo(chvars//'.CESL', 'E', jce1l)
    call jeveuo(chmat//'.CESVI', 'L', jcesvi)
!     -- IL FAUT REMETTRE CESV A NAN:
    rundef=r8nnem()
    call jeveuo(chvars//'.CESV', 'E', jce1v)
    call jelira(chvars//'.CESV', 'LONMAX', n1, kbid)
    do 5, k=1,n1
        zr(jce1v-1+k)=rundef
    5 end do
!
    do 1, ichs=1,nbchs
        chs=zk24(jlisch-1+ichs)(1:19)
        varc1=zk16(jlissd-1+7*(ichs-1)+4)(1:8)
        call jeveuo(chs//'.CESD', 'L', jcesd)
        call jeveuo(chs//'.CESL', 'L', jcesl)
        call jeveuo(chs//'.CESV', 'L', jcesv)
        call jeveuo(chs//'.CESC', 'L', jcesc)
        call jelira(chs//'.CESC', 'LONMAX', nbcmp, kbid)
!
        do 2,kcmp=1,nbcmp
            nocmp1=zk8(jcesc-1+kcmp)
!
!         -- CALCUL DE KCVRC :
            do 3,kcvrc=1,nbcvrc
                varc2=zk8(jcvvar-1+kcvrc)
                nocmp2=zk8(jcvcmp-1+kcvrc)
                if ((varc1.eq.varc2) .and. (nocmp1.eq.nocmp2)) goto 4
 3          continue
            goto 2
!
 4          continue
            call assert(kcvrc.ge.1 .and. kcvrc.le.nbcvrc)
!
!         -- BOUCLE SUR LES MAILLES :
            nbma = zi(jcesd-1+1)
            call assert(nbma.eq.zi(jce1d-1+1))
!
            do 70,ima = 1,nbma
                nbpt = zi(jcesd-1+5+4* (ima-1)+1)
                nbsp = zi(jcesd-1+5+4* (ima-1)+2)
                if (nbsp*nbsp .eq. 0) goto 70
                call cesexi('C', jce1d, jce1l, ima, 1, 1, kcvrc, iad1)
!               -- la maille n'est pas concernee par les variables de commande :
                if (iad1 .eq. 0)  goto 70
!
!               -- la maille porte un element fini qui saurait utiliser
!                  les variables de commande mais elle n'est pas affectee.
!                  on espere que les routines te00ij arreteront en <f> si necessaire.
                if (iad1 .lt. 0) goto 70

!               -- controle du nombre de points :
                call assert(nbpt.eq.zi(jce1d-1+5+4* (ima-1)+1))

!               -- On regarde si le champ possede des valeurs sur la maille :
                exival=.false.
                do ipt = 1, nbpt
                    do isp = 1, nbsp
                        call cesexi('C', jcesd, jcesl, ima, ipt,&
                                    isp, kcmp, iad)
                        if (iad .gt. 0) exival=.true.
                    enddo
                enddo

!               -- Controle du nombre de sous-points :
                if (nbsp .ne. zi(jce1d-1+5+4* (ima-1)+2)) then
!                   -- issue23456 : il peut arriver que nbsp=1 mais sans aucune valeur :
                    if (nbsp.eq.1 .and. .not.exival) goto 70

                    call dismoi('F','NOM_MAILLA', modele, 'MODELE', ibid, noma, iret)
                    call jenuno(jexnum(noma//'.NOMMAI',ima), nomail)
                    call jeveuo(modele//'.MAILLE', 'L', jmaille)
                    nute=zi(jmaille-1+ima)
                    call jenuno(jexnum('&CATA.TE.NOMTE', nute), nomte)
                    valk(1) = nocmp1
                    valk(2) = carele
                    valk(3) = chmat
                    valk(4) = nomail
                    valk(5) = nomte
                    vali(1) = zi(jce1d-1+5+4* (ima-1)+2)
                    vali(2) = nbsp
                    call u2mesg('F', 'CALCULEL6_57', 5, valk, 2, vali, 0, rbid)
                endif


                do 60,ipt = 1,nbpt
                    do 50,isp = 1,nbsp
                        call cesexi('C', jcesd, jcesl, ima, ipt,&
                                    isp, kcmp, iad)
                        if (iad .gt. 0) then
                            call cesexi('C', jce1d, jce1l, ima, ipt,&
                                        isp, kcvrc, iad1)
                            call assert(iad1.gt.0)
                            if (zi(jcesvi-1+iad1) .eq. ichs) then
                                valeur=zr(jcesv-1+iad)
                                zl(jce1l-1+iad1)=.true.
                                zr(jce1v-1+iad1)=valeur
                            endif
                        endif
50                  continue
60              continue
70          continue
2       continue
1   end do
!
!
!     4. RECOPIE DU CHAMP SIMPLE DANS LE CHAMP CHVARC
!     -----------------------------------------------------
    ligrmo=modele//'.MODELE'
    call cescel(chvars, ligrmo, 'INIT_VARC', 'PVARCPR', 'NAN',&
                nncp, 'V', chvarc, 'F', ibid)
!
    dbg=.false.
    if (dbg) call imprsd('CHAMP', chvarc, 6, 'VRCINS/CHVARC')
!
9999  continue
    call jedema()
end subroutine

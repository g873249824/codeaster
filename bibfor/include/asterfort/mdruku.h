!
! COPYRIGHT (C) 1991 - 2015  EDF R&D                WWW.CODE-ASTER.ORG
!
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
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
#include "asterf_types.h"
!
interface
    subroutine mdruku(method, tinit, tfin, dt, dtmin,&
                      dtmax, nbsauv, nbobjs, neqgen, pulsat,&
                      pulsa2, masgen, descmm, riggen, descmr,&
                      rgygen, lamor, amogen, descma, gyogen,&
                      foncv, fonca, typbas, basemo, nbchoc,&
                      intitu, logcho, dplmod, parcho, noecho,&
                      nbrede, dplred, fonred, nbrevi, dplrev,&
                      fonrev, coefm, liad, inumor, idescf,&
                      nofdep, nofvit, nofacc, nomfon, psidel,&
                      monmot, nbrfis, fk, dfk, angini,&
                      foncp, nbpal, dtsto, vrotat, prdeff,&
                      nomres, nbexci, nommas, nomrig, nomamo)
        integer :: nbchoc
        integer :: neqgen
        character(len=16) :: method
        real(kind=8) :: tinit
        real(kind=8) :: tfin
        real(kind=8) :: dt
        real(kind=8) :: dtmin
        real(kind=8) :: dtmax
        integer :: nbsauv
        integer :: nbobjs
        real(kind=8) :: pulsat(*)
        real(kind=8) :: pulsa2(*)
        real(kind=8) :: masgen(*)
        integer :: descmm
        real(kind=8) :: riggen(*)
        integer :: descmr
        real(kind=8) :: rgygen(*)
        aster_logical :: lamor
        real(kind=8) :: amogen(*)
        integer :: descma
        real(kind=8) :: gyogen(*)
        character(len=8) :: foncv
        character(len=8) :: fonca
        character(len=16) :: typbas
        character(len=8) :: basemo
        character(len=8) :: intitu
        integer :: logcho(nbchoc, *)
        real(kind=8) :: dplmod(nbchoc, neqgen, *)
        real(kind=8) :: parcho(*)
        character(len=8) :: noecho(nbchoc, *)
        integer :: nbrede
        real(kind=8) :: dplred(*)
        character(len=8) :: fonred(*)
        integer :: nbrevi
        real(kind=8) :: dplrev(*)
        character(len=8) :: fonrev(*)
        real(kind=8) :: coefm(*)
        integer :: liad(*)
        integer :: inumor(*)
        integer :: idescf(*)
        character(len=8) :: nofdep(*)
        character(len=8) :: nofvit(*)
        character(len=8) :: nofacc(*)
        character(len=8) :: nomfon(*)
        real(kind=8) :: psidel(*)
        character(len=8) :: monmot
        integer :: nbrfis
        character(len=8) :: fk(2)
        character(len=8) :: dfk(2)
        real(kind=8) :: angini
        character(len=8) :: foncp
        integer :: nbpal
        real(kind=8) :: dtsto
        real(kind=8) :: vrotat
        aster_logical :: prdeff
        character(len=8) :: nomres
        integer :: nbexci
        character(len=8) :: nommas
        character(len=8) :: nomrig
        character(len=8) :: nomamo
    end subroutine mdruku
end interface

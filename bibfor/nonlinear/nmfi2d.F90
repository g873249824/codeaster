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
! aslint: disable=W1306
!
subroutine nmfi2d(npg, lgpg, mate, option, geom,&
                  deplm, ddepl, sigmo, sigma, fint,&
                  ktan, vim, vip, tm, tp,&
                  crit, compor, typmod, codret)
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/codere.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/gedisc.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmfisa.h"
#include "asterfort/r8inir.h"
#include "asterfort/utmess.h"
    integer :: mate, npg, lgpg, codret
    real(kind=8) :: geom(2, 4), deplm(8), ddepl(8), tm, tp
    real(kind=8) :: fint(8), ktan(8, 8), sigmo(6, npg), sigma(6, npg)
    real(kind=8) :: vim(lgpg, npg), vip(lgpg, npg)
    character(len=8) :: typmod(*)
    character(len=16) :: option, compor(*)
!-----------------------------------------------------------------------
!
! BUT: DEVELOPPEMENT D'UN ELEMENT DE JOINT.
!      CALCUL DU SAUT DANS L'ELEMENT
!             DE LA CONTRAINTE A PARTIR D'UNE LDC
!             DE FINT ET KTAN : EFFORTS INTERIEURS ET MATRICE TANGENTE.
!
!      OPTION : OPTIONS DE CALCUL EN FONCTION DE LA SUBROUTINE LANCEE
!       * RAPH_MECA      : U = U- + DU  ->   SIGMA , FINT
!       * FULL_MECA      : U = U- + DU  ->   SIGMA , FINT , KTAN
!       * RIGI_MECA_TANG : U = U-       ->                  KTAN
!       * FORC_NODA      : TRAITE DANS NMFIFI.F
!
! SUBROUTINE APPELEE DANS LE TE0201
!
! IN  : OPTION,COMPOR,GEOM,DEPLM,DDEPL,VIM,NPG,TYPMOD,MATE
! IN  : TM INSTANT MOINS
! IN  : TP INSTANT PLUS
! OUT : SIGMA,FINT,KTAN,VIP,CODRET
! I/O :
!
!-----------------------------------------------------------------------
!
    aster_logical :: resi, rigi, axi
    integer :: code(9), i, j, q, s, ibid, kpg
    integer :: ndim, nno, nnos, ipoids, ivf, idfde, jgano
!     COORDONNEES POINT DE GAUSS + POIDS : X,Y,W => 1ER INDICE
    real(kind=8) :: coopg(3, npg)
    real(kind=8) :: dsidep(6, 6), b(2, 8)
    real(kind=8) :: sum(2), dsu(2), poids
    real(kind=8) :: crit(*)
    real(kind=8) :: angmas(3)
    type(Behaviour_Integ) :: BEHinteg
!
    axi = typmod(1) .eq. 'AXIS'
    resi = option.eq.'RAPH_MECA' .or. option(1:9).eq.'FULL_MECA'
    rigi = option(1:9).eq.'FULL_MECA'.or.option(1:10).eq.'RIGI_MECA_'
!
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!
! --- ANGLE DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
! --- INITIALISE A R8VIDE (ON NE S'EN SERT PAS)
    call r8inir(3, r8vide(), angmas, 1)
!
    if (.not. resi .and. .not. rigi) then
        call utmess('F', 'ALGORITH7_61', sk=option)
    endif
!
    if (resi) call r8inir(8, 0.d0, fint, 1)
    if (rigi) call r8inir(64, 0.d0, ktan, 1)
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
!     CALCUL DES COORDONNEES DES POINTS DE GAUSS
    call gedisc(2, nno, npg, zr(ivf), geom,&
                coopg)
!
    do kpg = 1, npg
!
! CALCUL DE LA MATRICE B DONNANT LES SAUT PAR ELEMENTS A PARTIR DES
! DEPLACEMENTS AUX NOEUDS , AINSI QUE LE POIDS DES PG :
! LE CHANGEMENT DE REPERE EST INTEGRE DANS LA MATRICE B (VOIR NMFISA)
!
        call nmfisa(axi, geom, kpg, poids, b)
!
! CALCUL DU SAUT DE DEPLACEMENT DANS L'ELEMENT (SU_N,SU_T) = B U
!
        call r8inir(2, 0.d0, sum, 1)
        call r8inir(2, 0.d0, dsu, 1)
        do j = 1, 8
            sum(1) = sum(1) + b(1,j)*deplm(j)
            sum(2) = sum(2) + b(2,j)*deplm(j)
        end do
        if (resi) then
            do j = 1, 8
                dsu(1) = dsu(1) + b(1,j)*ddepl(j)
                dsu(2) = dsu(2) + b(2,j)*ddepl(j)
            end do
        endif
!
! -   APPEL A LA LOI DE COMPORTEMENT
! CALCUL DE LA CONTRAINTE DANS L'ELEMENT AINSI QUE LA DERIVEE
! DE CELLE-CI PAR RAPPORT AU SAUT DE DEPLACEMENT (SIGMA ET DSIDEP)
!
        code(kpg) = 0
!
        BEHinteg%elem%coor_elga(kpg,1:2) = coopg(1:2,kpg)
!
        call nmcomp(BEHinteg,&
                    'RIGI', kpg, 1, 2, typmod,&
                    mate, compor, crit, tm, tp,&
                    2, sum, dsu, 1, sigmo(1, kpg),&
                    vim(1, kpg), option, angmas, &
                    sigma(1, kpg), vip(1, kpg), 36, dsidep, ibid)
!
!
! CALCUL DES FINT (B_T SIGMA )
!
        if (resi) then
!
            do i = 1, 8
                do q = 1, 2
                    fint(i) = fint(i) + poids*b(q,i)*sigma(q,kpg)
                end do
            end do
!
        endif
!
!
! CALCUL DES KTAN = ( B_T  DSIGMA/DSU  B )
!
        if (rigi) then
!
            do i = 1, 8
                do j = 1, 8
                    do q = 1, 2
                        do s = 1, 2
                            ktan(i,j) = ktan(i,j)+ poids*b(q,i)* dsidep(q,s)*b(s,j)
                        end do
                    end do
                end do
            end do
!
        endif
!
    end do
!
    if (resi) call codere(code, npg, codret)
end subroutine

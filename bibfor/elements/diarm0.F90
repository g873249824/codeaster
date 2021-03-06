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

subroutine diarm0(option, nomte, ndim, nbt, nno,&
                  nc, ulm, dul, pgl, iret)
    implicit none
#include "jeveux.h"
#include "asterfort/diarme.h"
#include "asterfort/infdis.h"
#include "asterfort/jevech.h"
#include "asterfort/pmavec.h"
#include "asterfort/ut2vlg.h"
#include "asterfort/utpsgl.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvlg.h"
#include "asterfort/vecma.h"
#include "blas/dcopy.h"
!
    character(len=*) :: option, nomte
    integer :: ndim, nbt, nno, nc, iret
    real(kind=8) :: ulm(12), dul(12), pgl(3, 3)
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!
!  IN
!     option   : option de calcul
!     nomte    : nom terme élémentaire
!     ndim     : dimension du problème
!     nbt      : nombre de terme dans la matrice de raideur
!     nno      : nombre de noeuds de l'élément
!     nc       : nombre de composante par noeud
!     ulm      : déplacement moins
!     dul      : incrément de déplacement
!     pgl      : matrice de passage de global a local
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jdc, irep, imat, ivarim, ifono, icontp, ivarip, icontm, neq, ii
    real(kind=8) :: r8bid, klv(78), force(3), klc(144), fl(12), duly, ulp(12), varip
    character(len=8) :: k8bid
!
!   paramétres en entrée
    call jevech('PCADISK', 'L', jdc)
    call infdis('REPK', irep, r8bid, k8bid)
    call dcopy(nbt, zr(jdc), 1, klv, 1)
    if (irep .eq. 1) then
        call utpsgl(nno, nc, pgl, zr(jdc), klv)
    endif
    call jevech('PMATERC', 'L', imat)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PCONTMR', 'L', icontm)
!   relation de comportement de l'armement
    force(:) = 0.0d0
    ulp(1:12) = ulm(1:12) + dul(1:12)
!
    call diarme(nbt, neq, zi(imat), ulm, dul,&
                ulp, zr(icontm), zr(ivarim), klv, varip,&
                force(1), duly)
!   actualisation de la matrice tangente
    if (option .eq. 'FULL_MECA' .or. option .eq. 'RIGI_MECA_TANG') then
        call jevech('PMATUUR', 'E', imat)
        call utpslg(nno, nc, pgl, klv, zr(imat))
    endif
!   calcul des efforts généralisés, des forces nodales et des variables internes
    if (option .eq. 'FULL_MECA' .or. option .eq. 'RAPH_MECA') then
        call jevech('PVECTUR', 'E', ifono)
        call jevech('PCONTPR', 'E', icontp)
        !
        neq = nno*nc
!       demi-matrice klv transformée en matrice pleine klc
        call vecma(klv, nbt, klc, neq)
!       calcul de fl = klc.dul (incrément d'effort)
        call pmavec('ZERO', neq, klc, dul, fl)
!       efforts généralisés aux noeuds 1 et 2 (repère local)
!       on change le signe des efforts sur le premier noeud pour les MECA_DIS_TR_L et MECA_DIS_T_L
        if (nno .eq. 1) then
            do ii = 1, neq
                zr(icontp-1+ii) = fl(ii) + zr(icontm-1+ii)
                fl(ii) = fl(ii) + zr(icontm-1+ii)
            enddo
        elseif (nno.eq.2) then
            do ii = 1, nc
                zr(icontp-1+ii) = -fl(ii) + zr(icontm-1+ii)
                zr(icontp-1+ii+nc) = fl(ii+nc) + zr(icontm-1+ii+nc)
                fl(ii) = fl(ii) - zr(icontm-1+ii)
                fl(ii+nc) = fl(ii+nc) + zr(icontm-1+ii+nc)
            enddo
        endif
!       modif pour les armements
        zr(icontp-1+2) = zr(icontm-1+2) + force(1)*duly
        zr(icontp-1+8) = zr(icontm-1+8) + force(1)*duly
        fl(2) = -zr(icontm-1+2) - force(1)*duly
        fl(8) = zr(icontm-1+8) + force(1)*duly
!       forces nodales aux noeuds 1 et 2 (repère global)
        if (nc .ne. 2) then
            call utpvlg(nno, nc, pgl, fl, zr(ifono))
        else
            call ut2vlg(nno, nc, pgl, fl, zr(ifono))
        endif
!       mise à jour des variables internes
        call jevech('PVARIPR', 'E', ivarip)
        zr(ivarip) = varip
        zr(ivarip+1) = varip
    endif
end subroutine

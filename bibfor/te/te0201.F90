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

subroutine te0201(option, nomte)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/nmfi2d.h"
#include "asterfort/r8inir.h"
#include "asterfort/tecach.h"
#include "blas/dcopy.h"
!
    character(len=16) :: nomte, option
!
!-----------------------------------------------------------------------
!
!     BUT: CALCUL DES OPTIONS NON LINEAIRES DES ELEMENTS DE
!          FISSURE JOINT
!
!     OPTION : RAPH_MECA, FULL_MECA, RIGI_MECA_TANG, RIGI_MECA_ELAS
!
!-----------------------------------------------------------------------
!
!
    integer :: igeom, imater, icarcr, icomp, idepm, iddep, icoret
    integer :: icontm, icontp, ivect, imatr
    integer :: kk, i, j, ivarim, ivarip, jtab(7), npg, iret, iinstm, iinstp
    integer :: lgpg1, lgpg
    real(kind=8) :: mat(8, 8), fint(8), sigmo(6, 2), sigma(6, 2)
    character(len=8) :: typmod(2)
    aster_logical :: resi, rigi, matsym
!
    resi = option.eq.'RAPH_MECA' .or. option(1:9).eq.'FULL_MECA'
    rigi = option(1:9).eq.'FULL_MECA' .or. option(1:9).eq.'RIGI_MECA'
!
    npg=2
!
    if (lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS'
    else
        typmod(1) = 'PLAN'
    endif
    typmod(2) = 'ELEMJOIN'
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imater)
    call jevech('PCARCRI', 'L', icarcr)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PDEPLMR', 'L', idepm)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PCONTMR', 'L', icontm)
!
! - INSTANTS
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
!
! RECUPERATION DU NOMBRE DE VARIABLES INTERNES PAR POINTS DE GAUSS :
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7,&
                itab=jtab)
    lgpg1 = max(jtab(6),1)*jtab(7)
    lgpg = lgpg1
!
! POINTEURS POUR LA LECTURE DU DEPL ET L'ECRITURE DES VIP
    if (resi) then
        call jevech('PDEPLPR', 'L', iddep)
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PCODRET', 'E', icoret)
    else
        iddep=1
        ivarip=1
        icoret=1
    endif
!
!     CONTRAINTE -, RANGEE DANS UN TABLEAU (6,NPG)
    call r8inir(6*2, 0.d0, sigmo, 1)
    sigmo(1,1) = zr(icontm)
    sigmo(2,1) = zr(icontm+1)
    sigmo(1,2) = zr(icontm+2)
    sigmo(2,2) = zr(icontm+3)
!
! CALCUL DES CONTRAINTES, VIP, FORCES INTERNES ET MATR TANG ELEMENTAIRES
    call nmfi2d(npg, lgpg, zi(imater), option, zr(igeom),&
                zr(idepm), zr(iddep), sigmo, sigma, fint,&
                mat, zr(ivarim), zr(ivarip), zr(iinstm), zr(iinstp),&
                zr(icarcr), zk16(icomp), typmod, zi(icoret))
!
! STOCKAGE DE LA MATRICE
    if (rigi) then
!
        matsym = .true.
        if (zk16(icomp)(1:15) .eq. 'JOINT_MECA_RUPT') matsym = .false.
        if (zk16(icomp)(1:15) .eq. 'JOINT_MECA_FROT') matsym = .false.
!
        if (matsym) then
!
            call jevech('PMATUUR', 'E', imatr)
            kk = 0
            do 10 i = 1, 8
                do 15 j = 1, i
                    zr(imatr+kk) = mat(i,j)
                    kk = kk+1
 15             continue
 10         continue
!
        else
!
            call jevech('PMATUNS', 'E', imatr)
            kk = 0
            do 11 i = 1, 8
                do 16 j = 1, 8
                    zr(imatr+kk) = mat(i,j)
                    kk = kk+1
 16             continue
 11         continue
!
        endif
!
    endif
!
! STOCKAGE DE LA CONTRAINTE ET DES FORCES INTERNES
    if (resi) then
!
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PVECTUR', 'E', ivect)
        zr(icontp) = sigma(1,1)
        zr(icontp+1) = sigma(2,1)
        zr(icontp+2) = sigma(1,2)
        zr(icontp+3) = sigma(2,2)
        call dcopy(8, fint, 1, zr(ivect), 1)
!
    endif
!
end subroutine

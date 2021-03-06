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

subroutine juveca(nom, long)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=*) :: nom
    integer :: long
!     REDIMENSIONNEMENT D'UN OBJET SIMPLE JEVEUX DEJA EXISTANT
!     ------------------------------------------------------------------
! IN  NOM  : K24 : NOM DE L'OBJET A REDIMENSIONNER
! IN  LONG : I   : NOUVELLE LONGUEUR DU VECTEUR
!     ------------------------------------------------------------------
!     REMARQUE: LES VALEURS SONT RECOPIEES
!      SI LA NOUVELLE LONGUEUR EST INFERIEURE A L'ANCIENNE, DES VALEURS
!      SONT PERDUES
!     ------------------------------------------------------------------
!
!
    character(len=8) :: base, type
    character(len=32) :: valk(2)
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ldec, ll, lonma2, lonmax, lonuti
    integer :: ltamp, ltyp
!-----------------------------------------------------------------------
    call jemarq()
    call jeveuo(nom, 'L', ldec)
!
!     --- TYPE, LONGUEUR ET BASE DE L'OBJET A REDIMENSIONNER
    call jelira(nom, 'TYPE  ', cval=type)
    call jelira(nom, 'LONMAX', lonmax)
    call jelira(nom, 'LONUTI', lonuti)
    call jelira(nom, 'CLAS', cval=base)
!
!     -- LONMA2 : LONGUEUR DE RECOPIE :
    ASSERT(lonmax.gt.0)
    ASSERT(long.gt.0)
    lonma2=min(long,lonmax)
!
!     --- ALLOCATION D'UN TAMPON ---
    if (type(1:1) .ne. 'K') then
        call wkvect('&&JUVECA.TAMPON', 'V V '//type, lonma2, ltamp)
    else
        call jelira(nom, 'LTYP', ltyp)
        call codent(ltyp, 'G', type(2:))
        call wkvect('&&JUVECA.TAMPON', 'V V '//type, lonma2, ltamp)
    endif
!
!     --- RECOPIE L'OBJET DANS LE TAMPON ---
    if (type .eq. 'I') then
        do 10 i = 1, lonma2
            zi(ltamp+i-1) = zi(ldec+i-1)
10      continue
    else if (type .eq. 'R') then
        do 20 i = 1, lonma2
            zr(ltamp+i-1) = zr(ldec+i-1)
20      continue
    else if (type .eq. 'C') then
        do 30 i = 1, lonma2
            zc(ltamp+i-1) = zc(ldec+i-1)
30      continue
    else if (type .eq. 'L') then
        do 40 i = 1, lonma2
            zl(ltamp+i-1) = zl(ldec+i-1)
40      continue
    else if (type(1:1) .eq. 'K') then
        if (ltyp .eq. 8) then
            do 50 i = 1, lonma2
                zk8(ltamp+i-1) = zk8(ldec+i-1)
50          continue
        else if (ltyp .eq. 16) then
            do 51 i = 1, lonma2
                zk16(ltamp+i-1) = zk16(ldec+i-1)
51          continue
        else if (ltyp .eq. 24) then
            do 52 i = 1, lonma2
                zk24(ltamp+i-1) = zk24(ldec+i-1)
52          continue
        else if (ltyp .eq. 32) then
            do 53 i = 1, lonma2
                zk32(ltamp+i-1) = zk32(ldec+i-1)
53          continue
        else if (ltyp .eq. 80) then
            do 54 i = 1, lonma2
                zk80(ltamp+i-1) = zk80(ldec+i-1)
54          continue
        else
            valk(1)=nom
            valk(2)=type
            call utmess('F', 'JEVEUX_31', nk=2, valk=valk)
        endif
    else
        valk(1)=nom
        valk(2)=type
        call utmess('F', 'JEVEUX_31', nk=2, valk=valk)
    endif
!
!     --- DESTRUCTION DU VIEUX ET CREATION DU NEUF ---
    call jedetr(nom)
    call wkvect(nom, base//' V '//type, long, ldec)
!
!     --- RECOPIE DU TAMPON DANS L'OBJET DEFINITIF ---
    if (type .eq. 'I') then
        do 110 i = 1, lonma2
            zi(ldec+i-1) = zi(ltamp+i-1)
110      continue
    else if (type .eq. 'R') then
        do 120 i = 1, lonma2
            zr(ldec+i-1) = zr(ltamp+i-1)
120      continue
    else if (type .eq. 'C') then
        do 130 i = 1, lonma2
            zc(ldec+i-1) = zc(ltamp+i-1)
130      continue
    else if (type .eq. 'L') then
        do 140 i = 1, lonma2
            zl(ldec+i-1) = zl(ltamp+i-1)
140      continue
        do 142 i = lonma2+1, long
            zl(ldec+i-1) = .false.
142      continue
    else if (type(1:1) .eq. 'K') then
        if (ltyp .eq. 8) then
            do 150 i = 1, lonma2
                zk8(ldec+i-1) = zk8(ltamp+i-1)
150          continue
        else if (ltyp .eq. 16) then
            do 151 i = 1, lonma2
                zk16(ldec+i-1) = zk16(ltamp+i-1)
151          continue
        else if (ltyp .eq. 24) then
            do 152 i = 1, lonma2
                zk24(ldec+i-1) = zk24(ltamp+i-1)
152          continue
        else if (ltyp .eq. 32) then
            do 153 i = 1, lonma2
                zk32(ldec+i-1) = zk32(ltamp+i-1)
153          continue
        else if (ltyp .eq. 80) then
            do 154 i = 1, lonma2
                zk80(ldec+i-1) = zk80(ltamp+i-1)
154          continue
        endif
    endif
    ll = min(lonuti,long)
    if (lonuti .gt. 0) call jeecra(nom, 'LONUTI', ll)
!
!     --- DESTRUCTION DU TAMPON ---
    call jedetr('&&JUVECA.TAMPON')
    call jedema()
end subroutine

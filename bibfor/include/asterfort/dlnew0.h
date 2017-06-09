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

!
!
#include "asterf_types.h"
!
interface
    subroutine dlnew0(result, force0, force1, iinteg, neq,&
                      istoc, iarchi, nbexci, nondp, nmodam,&
                      lamort, limped, lmodst, imat, masse,&
                      rigid, amort, nchar, nveca, liad,&
                      lifo, modele, mate, carele, charge,&
                      infoch, fomult, numedd, depla, vitea,&
                      accea, dep0, vit0, acc0, fexte,&
                      famor, fliai, depl1, vite1, acce1,&
                      psdel, fammo, fimpe, fonde, vien,&
                      vite, vita1, mltap, a0, a2,&
                      a3, a4, a5, a6, a7,&
                      a8, c0, c1, c2, c3,&
                      c4, c5, nodepl, novite, noacce,&
                      matres, maprec, solveu, criter, chondp,&
                      vitini, vitent, valmod, basmod,&
                      veanec, vaanec, vaonde, veonde, dt,&
                      theta, tempm, temps, iforc2, tabwk1,&
                      tabwk2, archiv, nbtyar, typear, numrep, ds_energy)
        use NonLin_Datastructure_type
        integer :: nbtyar
        integer :: nondp
        integer :: nbexci
        integer :: neq
        character(len=8) :: result
        character(len=19) :: force0
        character(len=19) :: force1
        integer :: iinteg
        integer :: istoc
        integer :: iarchi
        integer :: ifm
        integer :: nmodam
        aster_logical :: lamort
        aster_logical :: limped
        aster_logical :: lmodst
        integer :: imat(3)
        character(len=8) :: masse
        character(len=8) :: rigid
        character(len=8) :: amort
        integer :: nchar
        integer :: nveca
        integer :: liad(*)
        character(len=24) :: lifo(*)
        character(len=24) :: modele
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=24) :: charge
        character(len=24) :: infoch
        character(len=24) :: fomult
        character(len=24) :: numedd
        real(kind=8) :: depla(neq)
        real(kind=8) :: vitea(neq)
        real(kind=8) :: accea(neq)
        real(kind=8) :: dep0(*)
        real(kind=8) :: vit0(*)
        real(kind=8) :: acc0(*)
        real(kind=8) :: fexte(*)
        real(kind=8) :: famor(*)
        real(kind=8) :: fliai(*)
        real(kind=8) :: depl1(neq)
        real(kind=8) :: vite1(neq)
        real(kind=8) :: acce1(neq)
        real(kind=8) :: psdel(neq)
        real(kind=8) :: fammo(neq)
        real(kind=8) :: fimpe(neq)
        real(kind=8) :: fonde(neq)
        real(kind=8) :: vien(neq)
        real(kind=8) :: vite(neq)
        real(kind=8) :: vita1(neq)
        integer :: mltap(nbexci)
        real(kind=8) :: a0
        real(kind=8) :: a2
        real(kind=8) :: a3
        real(kind=8) :: a4
        real(kind=8) :: a5
        real(kind=8) :: a6
        real(kind=8) :: a7
        real(kind=8) :: a8
        real(kind=8) :: c0
        real(kind=8) :: c1
        real(kind=8) :: c2
        real(kind=8) :: c3
        real(kind=8) :: c4
        real(kind=8) :: c5
        character(len=8) :: nodepl(nbexci)
        character(len=8) :: novite(nbexci)
        character(len=8) :: noacce(nbexci)
        character(len=8) :: matres
        character(len=19) :: maprec
        character(len=19) :: solveu
        character(len=24) :: criter
        character(len=8) :: chondp(nondp)
        character(len=24) :: vitini
        character(len=24) :: vitent
        character(len=24) :: valmod
        character(len=24) :: basmod
        character(len=24) :: veanec
        character(len=24) :: vaanec
        character(len=24) :: vaonde
        character(len=24) :: veonde
        real(kind=8) :: dt
        real(kind=8) :: theta
        real(kind=8) :: tempm
        real(kind=8) :: temps
        integer :: iforc2
        real(kind=8) :: tabwk1(neq)
        real(kind=8) :: tabwk2(neq)
        integer :: archiv
        character(len=16) :: typear(nbtyar)
        integer :: numrep
        type(NL_DS_Energy), intent(inout) :: ds_energy
    end subroutine dlnew0
end interface

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
! aslint: disable=W1504
#include "asterf_types.h"
!
interface
    subroutine mbilgl(option, result, modele, depla1, depla2,&
                      thetai, mate, lischa, symech,chfond,&
                      nnoff , ndeg, thlagr, glagr,thlag2,&
                      milieu, ndimte, pair, extim,timeu,&
                      timev , indi, indj, nbprup,noprup,&
                      lmelas, nomcas, fonoeu, connex)
        character(len=16) :: option
        character(len=8) :: result
        character(len=8) :: modele
        character(len=24) :: depla1
        character(len=24) :: depla2
        character(len=8) :: thetai
        character(len=24) :: mate
        character(len=19) :: lischa
        character(len=8) :: symech
        character(len=24) :: chfond
        integer :: nnoff
        integer :: ndeg
        aster_logical :: thlagr
        aster_logical :: glagr
        aster_logical :: thlag2
        aster_logical :: milieu
        integer :: ndimte
        aster_logical :: pair
        aster_logical :: extim
        real(kind=8) :: timeu
        real(kind=8) :: timev
        integer :: indi
        integer :: indj
        integer :: nbprup
        character(len=16) :: noprup(*)
        aster_logical :: lmelas
        character(len=16) :: nomcas
        character(len=24) :: fonoeu
        aster_logical     :: connex
    end subroutine mbilgl
end interface

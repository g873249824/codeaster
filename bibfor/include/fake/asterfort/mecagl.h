!
! COPYRIGHT (C) 1991 - 2013  EDF R&D                WWW.CODE-ASTER.ORG
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
interface
    subroutine mecagl(option, result, modele, depla, thetai,&
                      mate, compor, nchar, lchar, symech,&
                      chfond, nnoff, iord, ndeg, thlagr,&
                      glagr, thlag2, milieu, ndimte, pair,&
                      extim, time, nbprup, noprup, chvite,&
                      chacce, lmelas, nomcas, kcalc, fonoeu)
        character(len=16) :: option
        character(len=8) :: result
        character(len=8) :: modele
        character(len=24) :: depla
        character(len=8) :: thetai
        character(len=24) :: mate
        character(len=24) :: compor
        integer :: nchar
        character(len=8) :: lchar(*)
        character(len=8) :: symech
        character(len=24) :: chfond
        integer :: nnoff
        integer :: iord
        integer :: ndeg
        logical :: thlagr
        logical :: glagr
        logical :: thlag2
        logical :: milieu
        integer :: ndimte
        logical :: pair
        logical :: extim
        real(kind=8) :: time
        integer :: nbprup
        character(len=16) :: noprup(*)
        character(len=24) :: chvite
        character(len=24) :: chacce
        logical :: lmelas
        character(len=16) :: nomcas
        character(len=8) :: kcalc
        character(len=24) :: fonoeu
    end subroutine mecagl
end interface

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
    subroutine alfeti(opt, sdfeti, matas, chsecm, chsol,&
                      niter, epsi, criter, testco, nbreor,&
                      tyreor, preco, scalin, stogi, nbreoi,&
                      acma, acsm, reacre)
        character(len=24) :: opt
        character(len=19) :: sdfeti
        character(len=19) :: matas
        character(len=19) :: chsecm
        character(len=19) :: chsol
        integer :: niter
        real(kind=8) :: epsi
        character(len=*) :: criter
        real(kind=8) :: testco
        integer :: nbreor
        character(len=24) :: tyreor
        character(len=24) :: preco
        character(len=24) :: scalin
        character(len=24) :: stogi
        integer :: nbreoi
        character(len=24) :: acma
        character(len=24) :: acsm
        integer :: reacre
    end subroutine alfeti
end interface

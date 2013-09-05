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
    subroutine caeihm(nomte, axi, perman, mecani, press1,&
                      press2, tempe, dimdef, dimcon, ndim,&
                      nno1, nno2, npi, npg, dimuel,&
                      iw, ivf1, idf1, ivf2, idf2,&
                      jgano1, iu, ip, ipf, iq,&
                      modint)
        character(len=16) :: nomte
        logical :: axi
        logical :: perman
        integer :: mecani(8)
        integer :: press1(9)
        integer :: press2(9)
        integer :: tempe(5)
        integer :: dimdef
        integer :: dimcon
        integer :: ndim
        integer :: nno1
        integer :: nno2
        integer :: npi
        integer :: npg
        integer :: dimuel
        integer :: iw
        integer :: ivf1
        integer :: idf1
        integer :: ivf2
        integer :: idf2
        integer :: jgano1
        integer :: iu(3, 18)
        integer :: ip(2, 9)
        integer :: ipf(2, 2, 9)
        integer :: iq(2, 2, 9)
        character(len=3) :: modint
    end subroutine caeihm
end interface

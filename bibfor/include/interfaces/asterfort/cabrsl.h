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
    subroutine cabrsl(kpi, ipoids, ipoid2, ivf, ivf2,&
                      idfde, idfde2, geom, dimdef, dimuel,&
                      ndim, nddls, nddlm, nno, nnos,&
                      nnom, axi, regula, b, poids,&
                      poids2)
        integer :: nnos
        integer :: nno
        integer :: ndim
        integer :: dimuel
        integer :: dimdef
        integer :: kpi
        integer :: ipoids
        integer :: ipoid2
        integer :: ivf
        integer :: ivf2
        integer :: idfde
        integer :: idfde2
        real(kind=8) :: geom(ndim, *)
        integer :: nddls
        integer :: nddlm
        integer :: nnom
        logical :: axi
        integer :: regula(6)
        real(kind=8) :: b(dimdef, dimuel)
        real(kind=8) :: poids
        real(kind=8) :: poids2
    end subroutine cabrsl
end interface

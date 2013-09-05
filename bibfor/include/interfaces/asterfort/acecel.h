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
interface 
    subroutine acecel(noma, nomo, nbocc, nbepo, nbedi,&
                      nbeco, nbeca, nbeba, nbema, nbegb,&
                      nbemb, nbthm1, nbthm2, ntyele, npoutr,&
                      ndiscr, ncoque, ncable, nbarre, nmassi,&
                      ngrill, ngribt, nmembr, jdlm, jdln,&
                      ier)
        character(len=8) :: noma
        character(len=8) :: nomo
        integer :: nbocc(*)
        integer :: nbepo
        integer :: nbedi
        integer :: nbeco
        integer :: nbeca
        integer :: nbeba
        integer :: nbema
        integer :: nbegb
        integer :: nbemb
        integer :: nbthm1
        integer :: nbthm2
        integer :: ntyele(*)
        integer :: npoutr
        integer :: ndiscr
        integer :: ncoque
        integer :: ncable
        integer :: nbarre
        integer :: nmassi
        integer :: ngrill
        integer :: ngribt
        integer :: nmembr
        integer :: jdlm
        integer :: jdln
        integer :: ier
    end subroutine acecel
end interface 

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
    subroutine qires1(modele, ligrel, chtime, sigmap, sigmad,&
                      lcharp, lchard, ncharp, nchard, chs,&
                      mate, chvois, tabido, chelem)
        character(len=8) :: modele
        character(len=*) :: ligrel
        character(len=24) :: chtime
        character(len=24) :: sigmap
        character(len=24) :: sigmad
        character(len=8) :: lcharp(1)
        character(len=8) :: lchard(1)
        integer :: ncharp
        integer :: nchard
        character(len=24) :: chs
        character(len=*) :: mate
        character(len=24) :: chvois
        integer :: tabido(5)
        character(len=24) :: chelem
    end subroutine qires1
end interface

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
    subroutine rsindi(tysca, iaobj, paobj, jordr, ival,&
                      rval, kval, cval, epsi, crit,&
                      nbordr, nbtrou, nutrou, ndim)
        character(len=4) :: tysca
        integer :: iaobj
        integer :: paobj
        integer :: jordr
        integer :: ival
        real(kind=8) :: rval
        character(len=*) :: kval
        complex(kind=8) :: cval
        real(kind=8) :: epsi
        character(len=*) :: crit
        integer :: nbordr
        integer :: nbtrou
        integer :: nutrou(*)
        integer :: ndim
    end subroutine rsindi
end interface

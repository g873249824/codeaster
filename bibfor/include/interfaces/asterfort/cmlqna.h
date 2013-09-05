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
    subroutine cmlqna(nbma, nbno, lima, connez, typema,&
                      mxar, milieu, nomima, nomipe, mxnomi,&
                      nbtyma, defare)
        integer :: nbtyma
        integer :: mxar
        integer :: nbno
        integer :: nbma
        integer :: lima(*)
        character(*) :: connez
        integer :: typema(*)
        integer :: milieu(2, mxar, nbno)
        integer :: nomima(12, nbma)
        integer :: nomipe(2, *)
        integer :: mxnomi
        integer :: defare(2, 0:12, nbtyma)
    end subroutine cmlqna
end interface

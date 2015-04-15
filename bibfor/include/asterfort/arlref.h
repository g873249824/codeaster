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
    subroutine arlref(elrefe, fami, nomte, ndim, nno,&
                      nnos, npg, jpoids, jcoopg, jvf,&
                      jdfde, jdfd2, jgano)
        character(len=*), intent(in), optional :: elrefe
        character(len=*), intent(in)    :: fami
        character(len=16), intent(in)   :: nomte
        integer, intent(out), optional  :: ndim
        integer, intent(out), optional  :: nno
        integer, intent(out), optional  :: nnos
        integer, intent(out), optional  :: npg
        integer, intent(out), optional  :: jpoids
        integer, intent(out), optional  :: jcoopg
        integer, intent(out), optional  :: jvf
        integer, intent(out), optional  :: jdfde
        integer, intent(out), optional  :: jdfd2
        integer, intent(out), optional  :: jgano
    end subroutine arlref
end interface

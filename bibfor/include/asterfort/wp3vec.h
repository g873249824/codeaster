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
    subroutine wp3vec(appr, opt, nbfreq, nbvect, neq,&
                      shift, vpr, vpi, vecp, mxresf,&
                      resufi, resufr, lagr, vauc, omecor)
        integer :: mxresf
        integer :: neq
        character(len=1) :: appr
        character(*) :: opt
        integer :: nbfreq
        integer :: nbvect
        complex(kind=8) :: shift
        real(kind=8) :: vpr(*)
        real(kind=8) :: vpi(*)
        complex(kind=8) :: vecp(neq, *)
        integer :: resufi(mxresf, *)
        real(kind=8) :: resufr(mxresf, *)
        integer :: lagr(*)
        complex(kind=8) :: vauc(2*neq, *)
        real(kind=8) :: omecor
    end subroutine wp3vec
end interface

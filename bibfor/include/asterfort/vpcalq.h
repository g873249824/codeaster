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
#include "asterf_types.h"
!
interface
    subroutine vpcalq(eigsol, vecrer, vecrei, vecrek, vecvp, mxresf, neqact,&
                      nblagr, omemax, omemin, omeshi, vecblo, sigma,&
                      npivot, flage, nconv, vpinf, vpmax)
        character(len=19) , intent(in)    :: eigsol
        character(len=24) , intent(in)    :: vecrer
        character(len=24) , intent(in)    :: vecrei
        character(len=24) , intent(in)    :: vecrek
        character(len=24) , intent(in)    :: vecvp
        integer           , intent(in)    :: mxresf
        integer           , intent(in)    :: neqact
        integer           , intent(in)    :: nblagr
        real(kind=8)      , intent(in)    :: omemax
        real(kind=8)      , intent(in)    :: omemin
        real(kind=8)      , intent(in)    :: omeshi
        character(len=24) , intent(in)    :: vecblo
        complex(kind=8)   , intent(in)    :: sigma
!!
        integer           , intent(inout) :: npivot
        aster_logical   , intent(out)   :: flage
        integer           , intent(out)   :: nconv
        real(kind=8)      , intent(out)   :: vpinf
        real(kind=8)      , intent(out)   :: vpmax
    end subroutine vpcalq
end interface

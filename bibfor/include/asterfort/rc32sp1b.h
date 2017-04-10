!
! COPYRIGHT (C) 1991 - 2017  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine rc32sp1b(ze200, lieu, numsip, numsiq, seismeb32, seismeunit,&
                        seismeze200, mse, propi, propj, proqi, proqj,&
                        instsp, sp, spme, mat1, mat2)
        aster_logical :: ze200
        character(len=4) :: lieu
        integer :: numsip
        integer :: numsiq
        aster_logical :: seismeb32
        aster_logical :: seismeunit
        aster_logical :: seismeze200
        real(kind=8) :: mse(12)
        real(kind=8) :: propi(20)
        real(kind=8) :: propj(20)
        real(kind=8) :: proqi(20)
        real(kind=8) :: proqj(20)
        real(kind=8) :: instsp(4)
        real(kind=8) :: sp(2)
        real(kind=8) :: spme(2)
        real(kind=8) :: mat1(7)
        real(kind=8) :: mat2(7)
    end subroutine rc32sp1b
end interface

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
    subroutine verift(fami         , kpg          , ksp          , poum  , j_mater,&
                      materiz      , iret         , epsth        , vepsth,&
                      temp_prev_out, temp_curr_out, temp_refe_out)
        character(len=*), intent(in) :: fami
        integer, intent(in) :: j_mater
        character(len=*), intent(in) :: poum
        integer, intent(in) :: kpg
        integer, intent(in) :: ksp
        character(len=8), optional, intent(in) :: materiz
        integer, optional, intent(out) :: iret
        real(kind=8), optional, intent(out) :: epsth
        real(kind=8), optional, intent(out) :: vepsth(*)
        real(kind=8), optional, intent(out) :: temp_prev_out
        real(kind=8), optional, intent(out) :: temp_curr_out
        real(kind=8), optional, intent(out) :: temp_refe_out
    end subroutine verift
end interface

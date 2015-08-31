!
! COPYRIGHT (C) 1991 - 2015  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine SetCol(table     , name_ , flag_acti_,&
                      flag_affe_, valer_, valei_    , valek_, mark_)
        use NonLin_Datastructure_type
        type(NL_DS_Table), intent(inout) :: table
        character(len=*), optional, intent(in) :: name_
        aster_logical, optional, intent(in) :: flag_acti_
        aster_logical, optional, intent(in) :: flag_affe_
        real(kind=8), optional, intent(in) :: valer_
        integer, optional, intent(in) :: valei_
        character(len=*), optional, intent(in) :: valek_
        character(len=1), optional, intent(in) :: mark_
    end subroutine SetCol
end interface

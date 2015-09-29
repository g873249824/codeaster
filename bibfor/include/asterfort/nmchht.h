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
! aslint: disable=W1504
!
interface
    subroutine nmchht(model      , mate       , cara_elem, compor        , comp_para  ,&
                      list_load  , nume_dof   , varc_refe, list_func_acti, sdstat     ,&
                      sddyna     , sdtime     , sddisc   , sdnume        , sdcont_defi,&
                      sdcont_solv, sdunil_solv, hval_incr, hval_algo     , hval_veasse,&
                      hval_measse, ds_inout)
        use NonLin_Datastructure_type
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        character(len=24), intent(in) :: compor
        character(len=24), intent(in) :: comp_para
        character(len=24), intent(in) :: nume_dof
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: varc_refe
        integer, intent(in) :: list_func_acti(*)
        character(len=24), intent(in) :: sdstat
        character(len=19), intent(in) :: sddyna
        character(len=24), intent(in) :: sdtime
        character(len=19), intent(in) :: sddisc
        character(len=19), intent(in) :: sdnume
        character(len=24), intent(in) :: sdcont_defi
        character(len=24), intent(in) :: sdcont_solv
        character(len=24), intent(in) :: sdunil_solv
        character(len=19), intent(in) :: hval_incr(*)
        character(len=19), intent(in) :: hval_algo(*)
        character(len=19), intent(in) :: hval_veasse(*)
        character(len=19), intent(in) :: hval_measse(*)
        type(NL_DS_InOut), intent(in) :: ds_inout
    end subroutine nmchht
end interface

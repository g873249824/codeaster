!
! COPYRIGHT (C) 1991 - 2016  EDF R&D                WWW.CODE-ASTER.ORG
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
    subroutine nmener(valinc, veasse, measse, sddyna, eta        ,&
                      ds_energy, fonact, numedd, numfix, ds_algopara,&
                      meelem, numins, modele, mate  , carele     ,&
                      ds_constitutive, ds_measure, sddisc, solalg, lischa,&
                      comref, veelem, ds_inout)
        use NonLin_Datastructure_type
        character(len=19) :: valinc(*)
        character(len=19) :: veasse(*)
        character(len=19) :: measse(*)
        character(len=19) :: sddyna
        real(kind=8) :: eta
        type(NL_DS_Energy), intent(inout) :: ds_energy
        integer :: fonact(*)
        character(len=24) :: numedd
        character(len=24) :: numfix
        character(len=19) :: meelem(*)
        integer :: numins
        character(len=24) :: modele
        character(len=24) :: mate
        character(len=24) :: carele
        type(NL_DS_InOut), intent(in) :: ds_inout
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: sddisc
        character(len=19) :: solalg(*)
        character(len=19) :: lischa
        character(len=24) :: comref
        character(len=19) :: veelem(*)
    end subroutine nmener
end interface

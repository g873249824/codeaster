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
#include "asterf_types.h"
!
! aslint: disable=W1504
!
interface
    subroutine nmdesc(modele  , numedd         , numfix    , mate      , carele     ,&
                      comref  , ds_constitutive, lischa    , ds_contact, ds_algopara,&
                      solveu  , fonact         , numins    , iterat    , sddisc     ,&
                      ds_print, ds_measure     , ds_algorom, sddyna    , sdnume     ,&
                      sderro  , matass         , maprec    , valinc    , solalg     ,&
                      meelem  , measse         , veasse    , veelem    , lerrit  )
        use NonLin_Datastructure_type
        use ROM_Datastructure_type
        character(len=24) :: modele
        character(len=24) :: numedd
        character(len=24) :: numfix
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=24) :: comref
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19) :: lischa
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=19) :: solveu
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        integer :: fonact(*)
        integer :: numins
        integer :: iterat
        character(len=19) :: sddisc
        type(NL_DS_Print), intent(inout) :: ds_print
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
        character(len=19) :: sddyna
        character(len=19) :: sdnume
        character(len=24) :: sderro
        character(len=19) :: matass
        character(len=19) :: maprec
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: veasse(*)
        character(len=19) :: veelem(*)
        aster_logical :: lerrit
    end subroutine nmdesc
end interface

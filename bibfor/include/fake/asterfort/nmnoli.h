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
    subroutine nmnoli(result, sddisc, sderro, carcri, sdimpr,&
                      sdcrit, fonact, sddyna, sdpost, modele,&
                      mate, carele, lisch2, sdpilo, sdtime,&
                      sdener, sdieto, sdcriq)
        character(len=8) :: result
        character(len=19) :: sddisc
        character(len=24) :: sderro
        character(len=24) :: carcri
        character(len=24) :: sdimpr
        character(len=19) :: sdcrit
        integer :: fonact(*)
        character(len=19) :: sddyna
        character(len=19) :: sdpost
        character(len=24) :: modele
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=19) :: lisch2
        character(len=19) :: sdpilo
        character(len=24) :: sdtime
        character(len=19) :: sdener
        character(len=24) :: sdieto
        character(len=24) :: sdcriq
    end subroutine nmnoli
end interface

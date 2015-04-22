function cgverho(imate)
    implicit none
#include "jeveux.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
#include "asterfort/lteatt.h"
#include "asterfort/tecach.h"
!
    integer :: imate
    logical :: cgverho
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
!   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
!    operateur CALC_G : verification au niveau des te
!    ----------------
!
!    but : verifier que si les champs de : -       pesanteur
!                                          - et/ou rotation 
!                                          - et/ou pulsation
!          sont des donnees d'entrees du calcul elementaire, on dispose
!          bien d'une valeur de rho sur cet élément
!
!    in  : imate (adresse du materiau)
!    out : cgverho = .true. si tout est OK, .false. sinon
!
! ----------------------------------------------------------------------
!
    integer :: icodre, iret, codrho, ipesa(1), irota(1), ipuls(1)
    logical :: rhoabs
    real(kind=8) :: rhobid
    character(len=16) :: phenom
    character(len=4) :: fami
!
! ----------------------------------------------------------------------
!
    call rccoma(zi(imate), 'ELAS', 1, phenom, icodre)
    if (lteatt(' ','LXFEM','OUI')) then
        fami='XFEM'
    else
        fami='RIGI'
    endif
    call rcvalb(fami, 1, 1, '+', zi(imate),' ', phenom, 0, ' ',&
                0.d0, 1, 'RHO', rhobid, codrho, 0)
!
!   rhoabs -> .true. si rho est absent
    rhoabs = codrho.ne.0
!
    call tecach('ONN', 'PPESANR', 'L', 1, ipesa, iret)
    call tecach('ONN', 'PROTATR', 'L', 1, irota, iret)
    call tecach('ONN', 'PPULPRO', 'L', 1, ipuls, iret)
!
!   si le champ est present, et rho absent -> NOOK
    cgverho = .true.
    if ( (ipesa(1).ne.0) .and. rhoabs ) cgverho = .false.
    if ( (irota(1).ne.0) .and. rhoabs ) cgverho = .false.
    if ( (ipuls(1).ne.0) .and. rhoabs ) cgverho = .false.

end function

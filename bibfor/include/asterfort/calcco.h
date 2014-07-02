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
    subroutine calcco(option, yachai, perman, meca, thmc,&
                      ther, hydr, imate, ndim, dimdef,&
                      dimcon, nbvari, yamec, yate, addeme,&
                      adcome, advihy, advico, addep1, adcp11,&
                      adcp12, addep2, adcp21, adcp22, addete,&
                      adcote, congem, congep, vintm, vintp,&
                      dsde, deps, epsv, depsv, p1,&
                      p2, dp1, dp2, t, dt,&
                      phi, pvp, pad, h11, h12,&
                      kh, rho11, phi0, pvp0, sat,&
                      retcom, crit, tbiot, vihrho, vicphi,&
                      vicpvp, vicsat, rinstp, angmas, aniso,&
                      phenom)
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        character(len=16) :: option
        aster_logical :: yachai
        aster_logical :: perman
        character(len=16) :: meca
        character(len=16) :: thmc
        character(len=16) :: ther
        character(len=16) :: hydr
        integer :: imate
        integer :: ndim
        integer :: yamec
        integer :: yate
        integer :: addeme
        integer :: adcome
        integer :: advihy
        integer :: advico
        integer :: addep1
        integer :: adcp11
        integer :: adcp12
        integer :: addep2
        integer :: adcp21
        integer :: adcp22
        integer :: addete
        integer :: adcote
        real(kind=8) :: congem(dimcon)
        real(kind=8) :: congep(dimcon)
        real(kind=8) :: vintm(nbvari)
        real(kind=8) :: vintp(nbvari)
        real(kind=8) :: dsde(dimcon, dimdef)
        real(kind=8) :: deps(6)
        real(kind=8) :: epsv
        real(kind=8) :: depsv
        real(kind=8) :: p1
        real(kind=8) :: p2
        real(kind=8) :: dp1
        real(kind=8) :: dp2
        real(kind=8) :: t
        real(kind=8) :: dt
        real(kind=8) :: phi
        real(kind=8) :: pvp
        real(kind=8) :: pad
        real(kind=8) :: h11
        real(kind=8) :: h12
        real(kind=8) :: kh
        real(kind=8) :: rho11
        real(kind=8) :: phi0
        real(kind=8) :: pvp0
        real(kind=8) :: sat
        integer :: retcom
        real(kind=8) :: crit(*)
        real(kind=8) :: tbiot(6)
        integer :: vihrho
        integer :: vicphi
        integer :: vicpvp
        integer :: vicsat
        real(kind=8) :: rinstp
        real(kind=8) :: angmas(3)
        integer :: aniso
        character(len=16) :: phenom
    end subroutine calcco
end interface 

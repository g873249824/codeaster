        interface
          subroutine comthm(option,perman,vf,ifa,valfac,valcen,imate,&
     &typmod,compor,crit,instam,instap,ndim,dimdef,dimcon,nbvari,yamec,&
     &yap1,yap2,yate,addeme,adcome,addep1,adcp11,adcp12,addep2,adcp21,&
     &adcp22,addete,adcote,defgem,defgep,congem,congep,vintm,vintp,dsde,&
     &pesa,retcom,kpi,npg,p10,p20)
            integer :: nbvari
            integer :: dimcon
            integer :: dimdef
            character(len=16) :: option
            logical :: perman
            logical :: vf
            integer :: ifa
            real(kind=8) :: valfac(6,14,6)
            real(kind=8) :: valcen(14,6)
            integer :: imate
            character(len=8) :: typmod(2)
            character(len=16) :: compor(*)
            real(kind=8) :: crit(*)
            real(kind=8) :: instam
            real(kind=8) :: instap
            integer :: ndim
            integer :: yamec
            integer :: yap1
            integer :: yap2
            integer :: yate
            integer :: addeme
            integer :: adcome
            integer :: addep1
            integer :: adcp11
            integer :: adcp12
            integer :: addep2
            integer :: adcp21
            integer :: adcp22
            integer :: addete
            integer :: adcote
            real(kind=8) :: defgem(1:dimdef)
            real(kind=8) :: defgep(1:dimdef)
            real(kind=8) :: congem(1:dimcon)
            real(kind=8) :: congep(1:dimcon)
            real(kind=8) :: vintm(1:nbvari)
            real(kind=8) :: vintp(1:nbvari)
            real(kind=8) :: dsde(1:dimcon,1:dimdef)
            real(kind=8) :: pesa(3)
            integer :: retcom
            integer :: kpi
            integer :: npg
            real(kind=8) :: p10
            real(kind=8) :: p20
          end subroutine comthm
        end interface

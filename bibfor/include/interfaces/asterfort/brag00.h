        interface
          subroutine brag00(fami,kpg,ksp,ndim,typmod,imate,compor,&
     &instam,instap,tm,tp,tref,epsm,deps,sigm,vim,option,sigp,vip,dsidep&
     &)
            character(*) :: fami
            integer :: kpg
            integer :: ksp
            integer :: ndim
            character(len=8) :: typmod(*)
            integer :: imate
            character(len=16) :: compor(3)
            real(kind=8) :: instam
            real(kind=8) :: instap
            real(kind=8) :: tm
            real(kind=8) :: tp
            real(kind=8) :: tref
            real(kind=8) :: epsm(6)
            real(kind=8) :: deps(6)
            real(kind=8) :: sigm(6)
            real(kind=8) :: vim(65)
            character(len=16) :: option
            real(kind=8) :: sigp(6)
            real(kind=8) :: vip(65)
            real(kind=8) :: dsidep(6,6)
          end subroutine brag00
        end interface

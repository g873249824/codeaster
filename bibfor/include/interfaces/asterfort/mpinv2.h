        interface
          subroutine mpinv2(nbmesu,nbmode,nbabs,phi,rmesu,coef,xabs,&
     &lfonct,reta,retap,reta2p)
            integer :: nbabs
            integer :: nbmode
            integer :: nbmesu
            real(kind=8) :: phi(nbmesu,nbmode)
            real(kind=8) :: rmesu(nbmesu,nbabs)
            real(kind=8) :: coef(*)
            real(kind=8) :: xabs(nbabs)
            logical :: lfonct
            real(kind=8) :: reta(nbmode,nbabs)
            real(kind=8) :: retap(nbmode,nbabs)
            real(kind=8) :: reta2p(nbmode,nbabs)
          end subroutine mpinv2
        end interface

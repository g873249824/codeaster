        interface
          subroutine meobg1(eps,epsg,b,d,deltab,deltad,mult,lambda,mu,&
     &ecrob,ecrod,alpha,k1,k2,bdim,dsidep)
            real(kind=8) :: eps(6)
            real(kind=8) :: epsg(6)
            real(kind=8) :: b(6)
            real(kind=8) :: d
            real(kind=8) :: deltab(6)
            real(kind=8) :: deltad
            real(kind=8) :: mult
            real(kind=8) :: lambda
            real(kind=8) :: mu
            real(kind=8) :: ecrob
            real(kind=8) :: ecrod
            real(kind=8) :: alpha
            real(kind=8) :: k1
            real(kind=8) :: k2
            integer :: bdim
            real(kind=8) :: dsidep(6,6)
          end subroutine meobg1
        end interface

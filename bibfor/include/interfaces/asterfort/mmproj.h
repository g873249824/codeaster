        interface
          subroutine mmproj(alias,nno,ndim,coorma,coorpt,itemax,epsmax&
     &,toleou,dirapp,dir,ksi1,ksi2,tau1,tau2,iproj,niverr)
            character(len=8) :: alias
            integer :: nno
            integer :: ndim
            real(kind=8) :: coorma(27)
            real(kind=8) :: coorpt(3)
            integer :: itemax
            real(kind=8) :: epsmax
            real(kind=8) :: toleou
            logical :: dirapp
            real(kind=8) :: dir(3)
            real(kind=8) :: ksi1
            real(kind=8) :: ksi2
            real(kind=8) :: tau1(3)
            real(kind=8) :: tau2(3)
            integer :: iproj
            integer :: niverr
          end subroutine mmproj
        end interface

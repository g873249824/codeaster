        interface
          subroutine dlarfx(side,m,n,v,tau,c,ldc,work)
            integer :: ldc
            character(len=1) :: side
            integer :: m
            integer :: n
            real(kind=8) :: v(*)
            real(kind=8) :: tau
            real(kind=8) :: c(ldc,*)
            real(kind=8) :: work(*)
          end subroutine dlarfx
        end interface

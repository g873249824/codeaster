        interface
          subroutine mltcmj(nb,n,p,front,frn,adper,trav,c)
            integer :: p
            integer :: nb
            integer :: n
            complex(kind=8) :: front(*)
            complex(kind=8) :: frn(*)
            integer :: adper(*)
            complex(kind=8) :: trav(p,nb,*)
            complex(kind=8) :: c(nb,nb,*)
          end subroutine mltcmj
        end interface

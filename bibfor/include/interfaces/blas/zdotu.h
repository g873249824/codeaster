        interface
          function zdotu(n,zx,incx,zy,incy)
            integer :: n
            complex(kind=8) :: zx(*)
            integer :: incx
            complex(kind=8) :: zy(*)
            integer :: incy
            complex(kind=8) :: zdotu
          end function zdotu
        end interface

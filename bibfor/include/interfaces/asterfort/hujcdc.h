        interface
          subroutine hujcdc(k,mater,sig,vin,seuil)
            integer :: k
            real(kind=8) :: mater(22,2)
            real(kind=8) :: sig(6)
            real(kind=8) :: vin(*)
            real(kind=8) :: seuil
          end subroutine hujcdc
        end interface

        interface
          subroutine fropgd(sdstat,defico,resoco,solveu,numedd,matass,&
     &noma,resigr,depdel,ctccvg,ctcfix)
            character(len=24) :: sdstat
            character(len=24) :: defico
            character(len=24) :: resoco
            character(len=19) :: solveu
            character(len=14) :: numedd
            character(len=19) :: matass
            character(len=8) :: noma
            real(kind=8) :: resigr
            character(len=19) :: depdel
            integer :: ctccvg
            logical :: ctcfix
          end subroutine fropgd
        end interface

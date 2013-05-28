        interface
          subroutine xxnmel(poum,elrefp,elrese,ndim,coorse,igeom,he,&
     &nfh,ddlc,ddlm,nnops,nfe,basloc,nnop,npg,typmod,option,imate,compor&
     &,lgpg,crit,idepl,lsn,lst,idecpg,sig,vi,matuu,ivectu,codret,nfiss,&
     &fisno)
            integer :: nfiss
            integer :: lgpg
            integer :: npg
            integer :: nnop
            integer :: nfe
            integer :: nfh
            integer :: ndim
            character(*) :: poum
            character(len=8) :: elrefp
            character(len=8) :: elrese
            real(kind=8) :: coorse(*)
            integer :: igeom
            real(kind=8) :: he(nfiss)
            integer :: ddlc
            integer :: ddlm
            integer :: nnops
            real(kind=8) :: basloc(3*ndim*nnop)
            character(len=8) :: typmod(*)
            character(len=16) :: option
            integer :: imate
            character(len=16) :: compor(4)
            real(kind=8) :: crit(3)
            integer :: idepl
            real(kind=8) :: lsn(nnop)
            real(kind=8) :: lst(nnop)
            integer :: idecpg
            real(kind=8) :: sig(2*ndim,npg)
            real(kind=8) :: vi(lgpg,npg)
            real(kind=8) :: matuu(*)
            integer :: ivectu
            integer :: codret
            integer :: fisno(nnop,nfiss)
          end subroutine xxnmel
        end interface

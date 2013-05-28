        interface
          subroutine calfnl(np1,np2,np3,np4,nbm,nbmcd,npfts,tc,nbnl,&
     &typch,nbseg,phii,choc,alpha,beta,gamma,orig,rc,theta,masgi,amori,&
     &pulsi,vitg,depg,vitg0,depg0,cmod,kmod,cmodca,kmodca,textts,fextts,&
     &ndef,indt,niter,fexmod,fnlmod,fmres,fmoda,ftmp,mtmp1,mtmp6,old,&
     &oldia,testc,itforn,inewto,toln)
            integer :: np4
            integer :: np3
            integer :: np2
            integer :: np1
            integer :: nbm
            integer :: nbmcd
            integer :: npfts
            real(kind=8) :: tc
            integer :: nbnl
            integer :: typch(*)
            integer :: nbseg(*)
            real(kind=8) :: phii(np2,np1,*)
            real(kind=8) :: choc(6,*)
            real(kind=8) :: alpha(2,*)
            real(kind=8) :: beta(2,*)
            real(kind=8) :: gamma(2,*)
            real(kind=8) :: orig(6,*)
            real(kind=8) :: rc(np3,*)
            real(kind=8) :: theta(np3,*)
            real(kind=8) :: masgi(*)
            real(kind=8) :: amori(*)
            real(kind=8) :: pulsi(*)
            real(kind=8) :: vitg(*)
            real(kind=8) :: depg(*)
            real(kind=8) :: vitg0(*)
            real(kind=8) :: depg0(*)
            real(kind=8) :: cmod(np1,*)
            real(kind=8) :: kmod(np1,*)
            real(kind=8) :: cmodca(np1,*)
            real(kind=8) :: kmodca(np1,*)
            real(kind=8) :: textts(*)
            real(kind=8) :: fextts(np4,*)
            integer :: ndef
            integer :: indt
            integer :: niter
            real(kind=8) :: fexmod(*)
            real(kind=8) :: fnlmod(*)
            real(kind=8) :: fmres(*)
            real(kind=8) :: fmoda(*)
            real(kind=8) :: ftmp(*)
            real(kind=8) :: mtmp1(np1,*)
            real(kind=8) :: mtmp6(3,*)
            real(kind=8) :: old(9,*)
            integer :: oldia(*)
            integer :: testc
            integer :: itforn(*)
            integer :: inewto
            real(kind=8) :: toln
          end subroutine calfnl
        end interface

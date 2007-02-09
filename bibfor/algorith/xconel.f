      SUBROUTINE XCONEL(MOX,CHFIS,BASE,OPT,PARAM,CHGLO)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/02/2007   AUTEUR MARKOVIC D.MARKOVIC 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY  
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY  
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR     
C (AT YOUR OPTION) ANY LATER VERSION.                                   
C                                                                       
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT   
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF            
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU      
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.                              
C                                                                       
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE     
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,         
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================

      IMPLICIT NONE
      CHARACTER*(*) BASE,OPT,PARAM
      CHARACTER*16  CHFIS
      CHARACTER*19  CHGLO
      CHARACTER*8  MOX

C--------------------------------------------------------------------
C  BUT: CONCATENER LES CHAMPS ELEMENTAIRES DES SD FISS_XFEM 
C       DANS UN CHAMP GLOBAL AFFECTE AU MODELE
C
C--------------------------------------------------------------------
C
C     ARGUMENTS/
C  MOX     IN    K19 : MODELE XFEM
C  CHFIS   IN    K19 : SUFFIXE DU NOM DU CHAMP ELEMENTAIRE A CONCATENER
C  CHGLO   OUT   K19 : CHAMP GLOBAL RESULTANT
C  BASE    IN    K1  : BASE DE CREATION POUR CHGLO : G/V/L
C
C--------------------------------------------------------------------
C---- COMMUNS NORMALISES  JEVEUX
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C-----FIN COMMUN NORMALISES  JEVEUX------------------------------------

      INTEGER NFIS,NNCP 
      INTEGER IMA,NBCMP,IPT,ICMP,II,NFISMX
      INTEGER IBID,ISP,IAD1,IAD2,JCESFV,JINDIC,JG,NMAENR,I,NBPT,NBSP
      INTEGER JNFIS,JCE1K,JCE1D,JCE1C,JCE1V,JCE1L,JNBPT,JNBSP,JNBCMP 
      INTEGER NBMAM,NCMP1,IFIS,JCESD,JCESL,JCESV,JMOFIS,JCESFD,JCESFL
      CHARACTER*3  TSCA
      CHARACTER*16  MOTFAC 
      CHARACTER*19  CES, CESF,CFISS
      CHARACTER*24  INDIC,GRP(3) 
      PARAMETER     (NFISMX=100)
      CHARACTER*8  FISS(NFISMX),MA,NOMGD,NOMFIS
C     ------------------------------------------------------------------

      CALL JEMARQ()
      CES  = '&&XCONEL.CES'
      CESF = '&&XCONEL.CESF'
        
C     1.RECUPERATION D'INFORMATIONS DANS MOX

      CALL JEVEUO(MOX//'.NFIS','L',JNFIS)
      NFIS = ZI(JNFIS)

      CALL GETVID(' ', 'FISSURE', 1,1,0,FISS , NFIS )
      NFIS = -NFIS
      
      IF (NFIS .GT. NFISMX) CALL U2MESI ('F', 'XFEM_2', 1, NFISMX)
      
      CALL GETVID(' ', 'FISSURE', 1,1,NFIS,FISS , IBID )

      CALL JEVEUO(MOX//'.FISS','L',JMOFIS) 
      NOMFIS = ZK8(JMOFIS)
        
      CALL CELCES(NOMFIS//CHFIS,'V',CESF)
     
      CALL JEVEUO(CESF//'.CESK','L',JCE1K)
      CALL JEVEUO(CESF//'.CESD','L',JCE1D)
      CALL JEVEUO(CESF//'.CESC','L',JCE1C)
      CALL JEVEUO(CESF//'.CESV','L',JCE1V)
      CALL JEVEUO(CESF//'.CESL','L',JCE1L)

      MA = ZK8(JCE1K-1+1)
      NOMGD = ZK8(JCE1K-1+2)
      NBMAM = ZI(JCE1D-1+1)
      NCMP1 = ZI(JCE1D-1+2)
      
      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR'
     &           ,IBID,TSCA,IBID)
      
C     2- CREATION DE 3 OBJETS CONTENANT LES NOMBRES DE POINTS,
C         SOUS-POINTS ET CMPS POUR CHAQUE MAILLE :
C     -----------------------------------------------------------
      CALL WKVECT('&&XCONEL.NBPT','V V I',NBMAM,JNBPT)
      CALL WKVECT('&&XCONEL.NBSP','V V I',NBMAM,JNBSP)
      CALL WKVECT('&&XCONEL.NBCMP','V V I',NBMAM,JNBCMP)
      DO 10,IMA = 1,NBMAM
        ZI(JNBPT-1+IMA) = ZI(JCE1D-1+5+4* (IMA-1)+1)
        ZI(JNBSP-1+IMA) = ZI(JCE1D-1+5+4* (IMA-1)+2)
        ZI(JNBCMP-1+IMA) = ZI(JCE1D-1+5+4* (IMA-1)+3)
   10 CONTINUE
   
   
      CALL CESCRE('V',CES,'ELEM',MA,NOMGD,NCMP1,ZK8(JCE1C),
     &              ZI(JNBPT),ZI(JNBSP),ZI(JNBCMP))
                
      CALL JEVEUO(CES//'.CESD','L',JCESD)
      CALL JEVEUO(CES//'.CESL','L',JCESL)
      CALL JEVEUO(CES//'.CESV','L',JCESV)

      DO 20 IFIS = 1,NFIS 
                       
        GRP(1)=FISS(IFIS)//'.MAILFISS  .HEAV'
        GRP(2)=FISS(IFIS)//'.MAILFISS  .CTIP'
        GRP(3)=FISS(IFIS)//'.MAILFISS  .HECT'
            
        CALL JEVEUO(MOX//'.FISS','L',JMOFIS) 
        NOMFIS = ZK8(JMOFIS-1 + IFIS)
        CALL CELCES(NOMFIS//CHFIS,'V',CESF)
        
        CALL JEVEUO(CESF//'.CESD','L',JCESFD)
        CALL JEVEUO(CESF//'.CESL','L',JCESFL)
        CALL JEVEUO(CESF//'.CESV','L',JCESFV)
      
      
        INDIC=FISS(IFIS)//'.MAILFISS .INDIC'
        CALL JEVEUO(INDIC,'L',JINDIC) 
        
        DO 1000, II = 1,3 
C-COPIER LE CHAMP 'CHFIS' POUR LES MAILLES '.HEAV','.CTIP' ET '.HECT'
          IF (ZI(JINDIC-1+2*(II-1)+1).EQ.1) THEN
C            GRP=FISS(IFIS)//'.MAILFISS  .HEAV'
            CALL JEVEUO(GRP(II),'L',JG)
            NMAENR=ZI(JINDIC-1+2*II)      
            DO 120 I=1,NMAENR
              IMA=ZI(JG-1+I)
              NBPT  = ZI(JNBPT -1 + IMA)
              NBSP  = ZI(JNBSP -1 + IMA)
              NBCMP = ZI(JNBCMP-1 + IMA)
              DO 1210 IPT = 1,NBPT
                DO 1220 ISP = 1,NBSP
                  DO 1230 ICMP = 1,NBCMP

                    CALL CESEXI('S',JCESFD,JCESFL,IMA,IPT,ISP,ICMP,IAD1)
                    CALL CESEXI('S',JCESD ,JCESL ,IMA,IPT,ISP,ICMP,IAD2)
                    CALL ASSERT(IAD1 .NE. 0)
                    IF (IAD1 .GT. 0) THEN
                      CALL ASSERT(IAD2 .LT. 0) 
                      ZL(JCESL-1 - IAD2) = .TRUE.
                      
                      IF (TSCA.EQ.'R') THEN
                        ZR(JCESV-1-IAD2) = ZR(JCESFV-1+IAD1)
                      ELSE IF (TSCA.EQ.'C') THEN
                        ZC(JCESV-1-IAD2) = ZC(JCESFV-1+IAD1)
                      ELSE IF (TSCA.EQ.'I') THEN
                        ZI(JCESV-1-IAD2) = ZI(JCESFV-1+IAD1)
                      ELSE IF (TSCA.EQ.'L') THEN
                        ZL(JCESV-1-IAD2) = ZL(JCESFV-1+IAD1)
                      ELSE IF (TSCA.EQ.'K8') THEN
                        ZK8(JCESV-1-IAD2) = ZK8(JCESFV-1+IAD1)
                      ELSE IF (TSCA.EQ.'K16') THEN
                        ZK16(JCESV-1-IAD2) = ZK16(JCESFV-1+IAD1)
                      ELSE IF (TSCA.EQ.'K24') THEN
                        ZK24(JCESV-1-IAD2) = ZK24(JCESFV-1+IAD1)
                      ELSE IF (TSCA.EQ.'K32') THEN
                        ZK32(JCESV-1-IAD2) = ZK32(JCESFV-1+IAD1)
                      ELSE IF (TSCA.EQ.'K80') THEN
                        ZK80(JCESV-1-IAD2) = ZK80(JCESFV-1+IAD1)
                      ELSE
                        CALL U2MESS('F','CALCULEL2_66')
                      END IF                  
                    
                    ENDIF                
 1230             CONTINUE
 1220           CONTINUE
 1210         CONTINUE
 120        CONTINUE
          ENDIF
 1000   CONTINUE

        CALL DETRSD('CHAM_ELEM_S',CESF)
      
 20   CONTINUE         

      CALL CESCEL(CES,MOX//'.MODELE',OPT,PARAM,'OUI',NNCP,BASE,CHGLO)
      
      CALL ASSERT(NNCP .EQ. 0)
      
      IF (NNCP .GT. 0) CALL U2MESI ('F', 'XFEM_3', 1, NNCP)
      
      CALL DETRSD('CHAM_ELEM_S',CES)
      
      CALL JEDETR('&&XCONEL.NBPT')
      CALL JEDETR('&&XCONEL.NBSP')
      CALL JEDETR('&&XCONEL.NBCMP')
        
      CALL JEDEMA()
      END

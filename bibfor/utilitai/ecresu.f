      SUBROUTINE ECRESU(RESIN,NPARA,NBVA,GRAND,RESOU,IER)
      IMPLICIT NONE
      INTEGER NPARA,NBVA
      CHARACTER*(*) RESIN,RESOU,GRAND
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 06/10/2008   AUTEUR DEVESA G.DEVESA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     REALISATION N.GREFFET
C     OPERATEUR "ECRIRE RESULTAT"
C     IN:
C       RESIN : SD_RESULTAT INITIALE HARMONIQUE 
C               (VENANT DE DYNA_LINE_HARM)
C       NPARA : POINTEUR DU TABLEAU DE DONNEE VENANT DE LA FFT
C       NBVA  : NOMBRE D'INSTANTS
C       GRAND : GRANDEUR PHYSIQUE (DEPL, VITE, ACCE)
C
C     OUT:
C       RESOU   : SD_RESULTAT FINALE TRANSITOIRE
C
C
C
C
C
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER      NBORDR,LTPS,JORDR,IBID,I,LFREQ,NBNOEU,NBCMP,LBIG,II
      INTEGER      LTPS2,IEQ,IER,NEQ,LVAL,LVALS,JDEP,JREFE,IRET,NBVA2
      INTEGER      IRES
      REAL*8       R8B
      COMPLEX*16   C16B
      CHARACTER*1  K1B
      CHARACTER*4  GRANDE
      CHARACTER*8  K8B,RAIDE
      CHARACTER*16 K16B,TYPOUT
      CHARACTER*19 K19B,CHDEP,CHDEPS,KREFE
      CHARACTER*24 TYPRES,CHDEP2,REFE
C
      DATA  REFE  /'                   .REFD'/
C     ------------------------------------------------------------------
      CALL JEMARQ()
      GRANDE = GRAND
      IER = 0
C   Recuperation type RESU
      CALL GETTCO(RESIN,TYPRES)
      IF (TYPRES(1:10).EQ.'DYNA_HARMO') THEN
         TYPOUT='DYNA_TRANS'
         NBVA2=NBVA
      ELSEIF (TYPRES(1:10).EQ.'HARM_GENE') THEN
         TYPOUT='TRAN_GENE'
         NBVA2=NBVA
       ELSEIF (TYPRES(1:10).EQ.'DYNA_TRANS') THEN
         TYPOUT='DYNA_HARMO'
         NBVA2=2*NBVA
      ELSEIF (TYPRES(1:10).EQ.'TRAN_GENE') THEN
         TYPOUT='HARM_GENE'
         NBVA2=2*NBVA
      ENDIF
C
C  Creation objet de stockage en LTPS pour les valeurs d'instants
C
C  Champs
      CALL RSEXCH(RESIN,GRANDE,1,CHDEP,IRET)  
      CALL JEVEUO(CHDEP//'.VALE','L',LVAL)
C  Nombre d'equations : NEQ
      CHDEP2 = CHDEP(1:19)//'.VALE'
      CALL JELIRA(CHDEP2,'LONMAX',NEQ,K1B)
      CALL WKVECT('&&PARAMACC','V V R',NBVA,LTPS)
C
C  Creation objet resultat en sortie si non existence
C
      NBORDR = NBVA
      CALL JEEXIN ( RESOU(1:8)//'           .DESC', IRES )
      IF ( IRES.EQ.0 ) CALL RSCRSD('G',RESOU,TYPOUT,NBORDR)
C      
      REFE(1:8) = RESIN
      CALL JEVEUO (REFE, 'L', JREFE )
      RAIDE = ZK24(JREFE+2)
      CALL JELIBE( REFE )
C
      IF ( (TYPOUT(1:10).EQ.'DYNA_HARMO').OR.
     &     (TYPOUT(1:9).EQ.'HARM_GENE') ) THEN
         DO  10 I = 1,NBVA
            ZR(LTPS+I-1) =  DBLE(ZC(NPARA+(NEQ*NBVA)+I-1))
 10      CONTINUE
         DO 20 I = 1,NBORDR
C  Temps
            CALL RSADPA(RESOU,'E',1,'FREQ',I,0,LTPS2,K8B)
            ZR(LTPS2) = ZR(LTPS+I-1)                
            CALL RSEXCH (RESOU,GRANDE,I,CHDEPS,IRET)
            CALL VTCREM (CHDEPS, RAIDE, 'G', 'C' )
            CALL JEVEUO(CHDEPS//'.VALE', 'E', LVALS )
            DO 30 IEQ = 1,NEQ
               ZC(LVALS+IEQ-1) = ZC(NPARA+NBVA*(IEQ-1)+I-1)
 30         CONTINUE
            CALL RSNOCH(RESOU,GRANDE,I,' ')
 20      CONTINUE
      ELSEIF ( (TYPOUT(1:10).EQ.'DYNA_TRANS').OR.
     &         (TYPOUT(1:9).EQ.'TRAN_GENE') ) THEN      
         DO  100 I = 1,NBVA
            ZR(LTPS+I-1) =  ZR(NPARA+(NEQ*NBVA2)+I-1)
 100     CONTINUE
         DO 200 I = 1,NBORDR
C  Temps
            CALL RSADPA(RESOU,'E',1,'INST',(I-1),0,LTPS2,K8B)
            ZR(LTPS2) = ZR(LTPS+I-1)                
            CALL RSEXCH (RESOU,GRANDE,(I-1),CHDEPS,IRET)
            CALL VTCREM (CHDEPS, RAIDE, 'G', 'R' )
            CALL JEVEUO(CHDEPS//'.VALE', 'E', LVALS )
            DO 300 IEQ = 1,NEQ
               ZR(LVALS+IEQ-1) = ZR(NPARA+NBVA*(IEQ-1)+I-1)
 300        CONTINUE
            CALL RSNOCH(RESOU,GRANDE,(I-1),' ')
 200     CONTINUE
      ENDIF
C  On finalise le RESOU
      IF ( IRES.EQ.0 ) THEN
         KREFE = RESOU(1:8)
         CALL WKVECT(KREFE//'.REFD','G V K24',3,JORDR)
         ZK24(JORDR) = ZK24(JREFE)
         ZK24(JORDR+1) = ZK24(JREFE+1)
         ZK24(JORDR+2) = ZK24(JREFE+2)
         CALL JELIBE(KREFE//'.REFD')
      ENDIF
C
      CALL JEDEMA()
      END

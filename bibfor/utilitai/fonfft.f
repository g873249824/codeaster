      SUBROUTINE FONFFT ( NSENS, NOMFON, SORTIE, METHOD, BASE )
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*)       NOMFON, SORTIE
      CHARACTER*(1)                               BASE
C     ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 05/07/2004   AUTEUR GREFFET N.GREFFET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C     CALCUL DE LA FFT OU DE LA FFT-1 (E. BOYERE 09/06/00)
C     ----------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      CHARACTER*8   CBID
      CHARACTER*16  NOMRES, METHOD
      CHARACTER*19  NOMFI, NOMFS
      CHARACTER*24  VALE, PROL
      REAL*8        PAS,PASFRQ,PAS2
C     ----------------------------------------------------------------
      CALL JEMARQ()
      NOMFI = NOMFON
      NOMFS = SORTIE
C
C     --- AFFECTATION DU .PROL ---
      PROL = NOMFI//'.PROL'
      CALL JEVEUO(PROL,'L',LPRO)
      IF (ZK16(LPRO).NE.'FONCTION'.AND.ZK16(LPRO).NE.'FONCT_C') THEN
         CALL UTMESS('F','FONFFT',
     +      'SEULE LE CALCUL DE LA FFT D UNE FONCTION EST IMPLEMENTE')
      ENDIF
C
C     ---  NOMBRE DE POINTS ----
      VALE = NOMFI//'.VALE'
      CALL JELIRA(VALE,'LONUTI',NBVAL,CBID)
      CALL JEVEUO(VALE,'L',LVAR)
      IF (NSENS.EQ.1) THEN
         NBVA = NBVAL/2
      ELSEIF (NSENS.EQ.-1) THEN
         NBVA = NBVAL/3
      ENDIF
      N = 1
  100 CONTINUE
      NBPTS = 2**N
      IF (NBPTS.LT.NBVA) THEN
         N = N + 1
         GOTO 100
      ENDIF
C     Methode de prise en compte du signal : 
C     -TRONCATURE : on tronque au 2**N inferieur le plus proche de NBVA
C     -PROL_ZERO : on prolonge le signal avec des zero pour aller
C                   au 2**N le plus proche superieur a NBVA
      IF ( (METHOD.EQ.'TRONCATURE') .AND. (NBPTS.NE.NBVA) ) THEN
         NBPTS = 2**(N-1)
         NBPTS1 = NBPTS
         NBPTS2 = 2*NBPTS
      ELSE
         NBPTS = 2**N
         NBPTS1 = NBVA
         NBPTS2 = NBPTS
      ENDIF
C
      LFON  = LVAR + NBVA
C     --- TRANSORMATION PAR FOURIER
      IF (NSENS.EQ.1) THEN
C     --- SENS DIRECT
C     --- RECOPIE DES VARIABLES ---
         CALL WKVECT('&&TRAVAIL','V V C',NBPTS,LTRA)
         DO 199 I = 1,NBPTS1
            ZC(LTRA+I-1) = DCMPLX(ZR(LFON+I-1),0.D0)
  199    CONTINUE
         IF (NBPTS.GT.NBVA) THEN
            DO 1999 I = 1,(NBPTS-NBVA)
               ZC(LTRA+NBVA+I-1) =  DCMPLX(0.D0,0.D0)
 1999       CONTINUE
         ENDIF
  
         CALL FFT(ZC(LTRA),NBPTS,1)
         PAS = ZR(LVAR+1)-ZR(LVAR)
         NBVAL1 = 3*NBPTS
         CALL WKVECT(NOMFS//'.VALE',BASE//' V R',NBVAL1,LRES)
         LRES1 = LRES + NBPTS
         PASFRQ = 1.D0/((NBPTS-1)*PAS)
         DO 198 I = 1,NBPTS
            ZR(LRES+I-1) = (I-1)*PASFRQ
  198    CONTINUE
         DO 200 I = 1,NBPTS
            II = 2*I-1
            ZR(LRES1+II-1) = DBLE(ZC(LTRA+I-1))*PAS
            ZR(LRES1+II) = DIMAG(ZC(LTRA+I-1))*PAS
  200    CONTINUE
      ELSEIF (NSENS.EQ.-1) THEN
C     --- SENS INVERSE
C
C        Pour cas tronque
C         NBPTS=2*NBPTS
         CALL WKVECT('&&TRAVAIL','V V C',NBPTS2,LTRA)
         DO 201 I = 1,NBPTS
            II = 2*I-1
            ZC(LTRA+I-1) = DCMPLX(ZR(LFON+II-1),ZR(LFON+II))
            ZC(LTRA+NBPTS2-I+1) = 
     &               DCMPLX(ZR(LFON+II-1),-ZR(LFON+II)) 
  201    CONTINUE
         CALL FFT(ZC(LTRA),NBPTS2,-1)
         PAS = ZR(LVAR+1)-ZR(LVAR)
         CALL WKVECT(NOMFS//'.VALE',BASE//' V R',2*NBPTS2,LRES)
         LRES1 = LRES + NBPTS2
         DO 202 I = 1,NBPTS2
            ZR(LRES+I-1) = 1.D0/((NBPTS2-1)*PAS)*(I-1)
  202    CONTINUE
         PAS2 = 1/ZR(LVAR+NBPTS2-1)
         DO 203 I = 1,NBPTS2
            ZR(LRES1+I-1) = DBLE(ZC(LTRA+I-1))/PAS2
  203    CONTINUE
      ENDIF
C
      NOMRES = ZK16(LPRO+3)
      IF ( NOMRES(1:4) .EQ. 'DEPL' ) THEN
         NOMRES = 'VITE'
      ELSEIF ( NOMRES(1:4) .EQ. 'VITE' ) THEN
         NOMRES = 'ACCE'
      ELSE
         NOMRES      = 'TOUTRESU'
      ENDIF
      PROL = NOMFS//'.PROL'
      CALL WKVECT(PROL,'G V K16',5,LPROS)
      IF (NSENS.EQ.1) THEN
         ZK16(LPROS  ) = 'FONCT_C'
         ZK16(LPROS+2) = 'FREQ'
      ELSEIF (NSENS.EQ.-1) THEN
         ZK16(LPROS  ) = 'FONCTION'
         ZK16(LPROS+2) = 'INST'
      ENDIF
      IF (ZK16(LPRO+1)(1:3).EQ.'INT') THEN
         ZK16(LPROS+1) = 'LIN LIN '
      ELSE
         ZK16(LPROS+1) = ZK16(LPRO+1)
      ENDIF
      ZK16(LPROS+3) = NOMRES
      IF (ZK16(LPRO+4)(1:1).EQ.'I' .OR. ZK16(LPRO+4)(2:2).EQ.'I') THEN
         ZK16(LPROS+4) = 'EE      '
      ELSE
         ZK16(LPROS+4) = ZK16(LPRO+4)
      ENDIF
C
      CALL JEDETC('V','&&',1)      

      CALL JEDEMA()
      END

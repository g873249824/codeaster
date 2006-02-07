      SUBROUTINE ASCIMA (CHARGE,INFCHA,NUMEDD,MATASS)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/02/2006   AUTEUR CIBHHLV L.VIVAN 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*24       CHARGE,INFCHA
      CHARACTER*(*)      NUMEDD,MATASS
C ----------------------------------------------------------------------
C     ASSEMBLAGE DES MATRICES
C
C IN  CHARGE  : LISTE DES CHARGES
C IN  INFCHA  : INFORMATION SUR LES CHARGES
C IN  NUMEDD  : NUMEROTATION DU SYSTEME
C VAR MATASS  : MATRICE ASSEMBLEE AVEC ELIMINATION DES DDLS IMPOSES PAR
C               DES CHARGES CINEMATIQUES
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C----------------------------------------------------------------------
C     VARIABLES LOCALES
C----------------------------------------------------------------------
      CHARACTER*8 KBID
      CHARACTER*24 LCHCI
C----------------------------------------------------------------------
C                DEBUT DES INSTRUCTIONS
C----------------------------------------------------------------------
      CALL JEMARQ()
      CALL JEEXIN(CHARGE,IRET)
      IF (IRET.EQ.0) GOTO 9999
      LCHCI = '&&ASCIMA.LCHCI'
      CALL JEVEUO(CHARGE,'L',IDCHA)
      CALL JEVEUO(INFCHA,'L',IDINFC)
      NCHARG = ZI(IDINFC)
      CALL WKVECT(LCHCI,'V V K24',NCHARG,IDCHCI)
      NCHCI = 0
      DO 1 ICH = 1,NCHARG
        IF (ZI(IDINFC+ICH).LT.0) THEN
          NCHCI = NCHCI+1
          ZK24(IDCHCI-1+NCHCI) = ZK24(IDCHA-1+ICH)
        ENDIF
1     CONTINUE
      IF ( NCHCI.NE.0 ) THEN
         CALL ASSCHC('V',MATASS,NCHCI,ZK24(IDCHCI),NUMEDD,'ZERO')
      ENDIF
      CALL JEDETR(LCHCI)
 9999 CONTINUE
      CALL JEDEMA()
      END

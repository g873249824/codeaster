      SUBROUTINE SSTRIV(RDIAK,RDIAM,LPROD,IPOS,NEQ)
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8            RDIAK(NEQ),RDIAM(NEQ)
      INTEGER                       LPROD(NEQ),IPOS(NEQ),NEQ
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 23/05/95   AUTEUR D6BHHBQ B.QUINNEZ 
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
C        TRI DES PLUS PETITS K/M
C
C     ------------------------------------------------------------------
C     IN RDIAK : TABLEAU CONTENANT LA DIAGONALE DE LA RAIDEUR
C     IN RDIAM : TABLEAU CONTENANT LA DIAGONALE DE LA MASSE
C     IN LPROD : ADRESSE DANS ZI DES DDL SUR LESQUELS ON TRIE
C     IN NEQ   : NOMBRE D EQUATIONS
C     OUT IPOS : TABLEAU DES INDIRECTIONS APRES LE TRI
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      ICONT = 0
      DO 1 I = 1, NEQ
        IPOS(I) = I
        ICONT = ICONT + LPROD(I)
 1    CONTINUE
 10   CONTINUE
      INDIC = 0
      DO 2 LL = 1, NEQ-1
        IF(LPROD(IPOS(LL)).EQ.0 .AND. LPROD(IPOS(LL+1)).EQ.1) THEN
          ITEMP = IPOS(LL)
          IPOS(LL) = IPOS(LL+1)
          IPOS(LL+1) = ITEMP
          INDIC =1
        ENDIF
 2    CONTINUE
      IF(INDIC .EQ. 1) GOTO 10
C
 31   CONTINUE
      INDIC = 0
      DO 32 LL = 1, ICONT-1
        IF(RDIAM(IPOS(LL)).GT.0.0D0.AND.RDIAM(IPOS(LL+1)).GT.0.0D0) THEN
          IF(RDIAK(IPOS(LL)).GT.0.0D0.AND.RDIAK(IPOS(LL+1)).GT.0.0D0)
     &                                                 THEN
            IF(RDIAK(IPOS(LL))/RDIAM(IPOS(LL)) .GT.
     +           RDIAK(IPOS(LL+1))/RDIAM(IPOS(LL+1))) THEN
              ITEMP = IPOS(LL)
              IPOS(LL) = IPOS(LL+1)
              IPOS(LL+1) = ITEMP
              INDIC =1
            ENDIF
          ELSE IF(RDIAK(IPOS(LL+1)).GT.0.0D0) THEN
            ITEMP = IPOS(LL)
            IPOS(LL) = IPOS(LL+1)
            IPOS(LL+1) = ITEMP
            INDIC =1
          ENDIF
        ELSE IF(RDIAK(IPOS(LL+1)).GT.0.0D0 .AND.
     +         RDIAM(IPOS(LL+1)).GT.0.0D0) THEN
          ITEMP = IPOS(LL)
          IPOS(LL) = IPOS(LL+1)
          IPOS(LL+1) = ITEMP
          INDIC =1
        ELSE IF(RDIAM(IPOS(LL)).EQ.0.AND.RDIAM(IPOS(LL+1)).NE.0) THEN
          ITEMP = IPOS(LL)
          IPOS(LL) = IPOS(LL+1)
          IPOS(LL+1) = ITEMP
          INDIC =1
        ENDIF
 32   CONTINUE
      IF(INDIC .EQ. 1) GOTO 31
      END

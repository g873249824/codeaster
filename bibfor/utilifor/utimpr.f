      SUBROUTINE UTIMPR ( CH1 , TEXTC , NB , RVAL )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 06/01/95   AUTEUR G8BHHAC A.Y.PORTABILITE 
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
      CHARACTER* 1        CH1
      CHARACTER*(*)             TEXTC
      INTEGER                           NB
      REAL *8                                RVAL(*)
C     ==================================================================
      INTEGER          MXCOLS , ITABU , LIGCOU , COLCOU , IDF
      COMMON /UTINIP/  MXCOLS , ITABU , LIGCOU , COLCOU , IDF
      PARAMETER      ( NT = 10 )
      CHARACTER*132    TAMPON
      COMMON /UTTAMP/  TAMPON(NT)
      INTEGER          LDEB
      COMMON /UTDEB /  LDEB
C     ------------------------------------------------------------------
      INTEGER          LGVAL
      PARAMETER      ( LGVAL = 12 )
      CHARACTER*(LGVAL) CVAL
C     ------------------------------------------------------------------
      IF ( CH1 .EQ. 'L' ) THEN
        LIGCOU = LIGCOU + 1
        IF ( LIGCOU .GT. NT ) THEN
          CALL UTVTAM
          LIGCOU = 1
        ENDIF
        COLCOU = LDEB
      END IF
      NBTB = (COLCOU-LDEB)/ITABU
      IRTB = MOD((COLCOU-LDEB),ITABU)
      IF ( IRTB .GT. 0 ) THEN
        COLCOU = (NBTB+1)*ITABU+LDEB
          IF ( COLCOU .GT. MXCOLS ) THEN
           LIGCOU = LIGCOU + 1
           IF ( LIGCOU .GT. NT ) THEN
              CALL UTVTAM
              LIGCOU = 1
           ENDIF
           COLCOU = LDEB
        ENDIF
      ENDIF
      CALL UTRTAM ( TEXTC )
      DO 1 K = 1,NB
        WRITE ( CVAL , '(1X,1PE11.4)' ) RVAL(K)
        NBTB = (COLCOU-LDEB)/ITABU
        IRTB = MOD((COLCOU-LDEB),ITABU)
        IF ( IRTB .EQ. 0 ) THEN
           NBTB = NBTB - 1
        ENDIF
        COLCOU = (NBTB+1)*ITABU+LDEB
        IF ( COLCOU .GT. MXCOLS .OR. COLCOU+LGVAL .GT. MXCOLS ) THEN
           LIGCOU = LIGCOU + 1
           COLCOU = LDEB
           IF ( LIGCOU .GT. NT ) THEN
              CALL UTVTAM
              LIGCOU = 1
           ENDIF
        ENDIF
        CALL UTRTAM ( CVAL )
 1    CONTINUE
C
      END

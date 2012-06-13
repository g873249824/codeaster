      SUBROUTINE MTDETE ( LMAT  , MANTIS , EXPO )
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER             LMAT ,           EXPO
      REAL*8                      MANTIS
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     CALCUL DU DETERMINANT D'UNE MATRICE DECOMPOSEE SOUS FORME L*D*LT
C     ------------------------------------------------------------------
C
C     ------------------------------------------------------------------
C
C     ------------------------------------------------------------------
      INTEGER I, NEQ, IRET, LDIAG,NBNEG
      CHARACTER*24     NOMDIA
      DATA  NOMDIA/'                   .DIGS'/
C     ------------------------------------------------------------------
C
C
      CALL JEMARQ()
      NOMDIA(1:19) = ZK24(ZI(LMAT+1))
      NEQ          = ZI(LMAT+2 )
      CALL JEEXIN(NOMDIA,IRET)
      IF (IRET.EQ.0) CALL U2MESK('F','MODELISA2_9',1,NOMDIA)
      CALL JEVEUO(NOMDIA,'L',LDIAG)
      LDIAG=LDIAG+NEQ
C
C        --- CALCUL DU DETERMINANT --
      IF ( ZI(LMAT+3) .EQ. 1 ) THEN
C
C        --- DIAGONALE A COEFFICIENTS REELS ---
         CALL ALMULR( 'ZERO', ZR(LDIAG), NEQ , MANTIS, EXPO )
         NBNEG  = 0
         DO 10 I=0, NEQ-1
            IF ( ZR(LDIAG+I) .LE. 0.D0 ) NBNEG = NBNEG + 1
  10     CONTINUE
      ELSE
         CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEDETR(NOMDIA)
      CALL JEDEMA()
      END

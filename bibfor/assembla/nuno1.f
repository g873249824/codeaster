      SUBROUTINE NUNO1(I,ILIGR,NUNOEL,N,INUM21,INUNO2,NLILI)
      IMPLICIT NONE

      INCLUDE 'jeveux.h'
      INTEGER I,ILIGR

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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

C ---- OBJET : FONCTION INVERSE DU CHAMP .NUNO D'UNE S.D. NUME_DDL
C      ! LE CHAMP .NUNO N'EST PLUS CONSERVE DANS LA S.D. FINALE!
C ---- DESCRIPTION DES PARAMETRES
C IN  I  I     : NUMERO DU NOEUD DANS LA NUMEROTATION .NUNO
C OUT I  ILIGR : NUMERO DANS .LILI DU LIGREL DANS LEQUEL EST DECLARE
C                LE NOEUD NUMERO I
C OUT I  NUNOEL: NUMERO DU NOEUD DANS LA NUMEROTATION LOCALE DU LIGREL

C-----------------------------------------------------------------------
C     FONCTIONS JEVEUX
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C----------------------------------------------------------------------

C-----------------------------------------------------------------------
      INTEGER I1 ,I2 ,ILI ,ILI1 ,INUM21 ,INUNO2 ,J 
      INTEGER JLI ,N ,NLILI ,NUNOEL 
C-----------------------------------------------------------------------
      CALL ASSERT((I.GT.0) .AND. (I.LE.N))
      J = ZI(INUM21+I)
      IF (J.EQ.0) THEN
        ILIGR = 0
        NUNOEL = 0
        GO TO 50
      END IF

C---- RECHERCHE DU LIGREL (CALCUL DE ILIGR)

      ILI = 1
      I1 = ZI(INUNO2+ILI-1)
   10 CONTINUE
      DO 20 JLI = ILI + 1,NLILI + 1
        I2 = ZI(INUNO2+JLI-1)
        ILI1 = JLI
        IF (I2.GT.I1) GO TO 30
   20 CONTINUE
   30 CONTINUE
      IF ((J.GE.I1) .AND. (J.LT.I2)) THEN
        ILIGR = ILI1 - 1
        GO TO 40
      ELSE
        ILI = ILI1
        I1 = I2
        GO TO 10
      END IF
   40 CONTINUE

C---- CALCUL DE NUNOEL

      NUNOEL = J - ZI(INUNO2+ILIGR-1) + 1
   50 CONTINUE
      END

      SUBROUTINE CRIPOI(NBM,B,CRIT)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C-----------------------------------------------------------------------
C COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
C CALCUL DU POIDS RELATIF DES TERMES EXTRADIAGONAUX DE LA MATRICE B(S)
C PAR RAPPORT AUX TERMES DIAGONAUX
C APPELANT : POIBIJ
C-----------------------------------------------------------------------
C  IN : NBM  : NOMBRE DE MODES RETENUS POUR LE COUPLAGE FLUIDELASTIQUE
C              => ORDRE DE LA MATRICE B(S)  (NB: NBM > 1)
C  IN : B    : MATRICE B(S)
C OUT : CRIT : CRITERE DE POIDS RELATIF DES TERMES EXTRADIAGONAUX
C-----------------------------------------------------------------------
      INTEGER     NBM
      COMPLEX*16  B(NBM,NBM)
      REAL*8      CRIT
C
      REAL*8      DCABS2,R8MIEM,R8NNEM,R8PREM
C-----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER I ,J 
      REAL*8 BII ,BIJ ,SOMMII ,SOMMIJ ,TOLE ,TOLR ,X 
      REAL*8 Y 
C-----------------------------------------------------------------------
      TOLE = 100.D0*R8MIEM()
      TOLR = R8PREM()
C
C-----1.CALCUL DE LA SOMME DES CARRES DES TERMES DIAGONAUX
C
      SOMMII = 0.D0
C
      DO 10 I = 1,NBM
        BII = DCABS2(B(I,I))
        SOMMII = SOMMII + BII*BII
  10  CONTINUE
C
      IF (SOMMII.LT.TOLE) THEN
C
        CALL U2MESS('A','ALGELINE_30')
        CRIT = R8NNEM()
C
      ELSE
C
C-------2.CALCUL DE LA SOMME DES CARRES DES TERMES EXTRADIAGONAUX
C
        SOMMIJ = 0.D0
C
        DO 20 I = 2,NBM
          BIJ = DCABS2(B(I,1))
          SOMMIJ = SOMMIJ + BIJ*BIJ
  20    CONTINUE
C
        DO 30 J = 2,NBM
          DO 31 I = 1,J-1
            BIJ = DCABS2(B(I,J))
            SOMMIJ = SOMMIJ + BIJ*BIJ
  31      CONTINUE
          IF (J.LT.NBM) THEN
            DO 32 I = J+1,NBM
              BIJ = DCABS2(B(I,J))
              SOMMIJ = SOMMIJ + BIJ*BIJ
  32        CONTINUE
          ENDIF
  30    CONTINUE
C
C-------3.CALCUL DU CRITERE
C
        X = SOMMIJ/DBLE(NBM-1)
C
        IF (SOMMII.LT.X*TOLR) THEN
C
          CALL U2MESS('A','ALGELINE_31')
          CRIT = R8NNEM()
C
        ELSE
C
          Y = X/SOMMII
          CRIT = DBLE(SQRT(Y))*100.D0
C
        ENDIF
C
      ENDIF
C
      END

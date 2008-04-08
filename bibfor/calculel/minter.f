      FUNCTION MINTER(DIME  ,M1    ,M2    ,D1    ,D2    ,
     &                MM1   ,MM2   ,PAN1  ,PAN2  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 08/04/2008   AUTEUR MEUNIER S.MEUNIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C
C ======================================================================
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      LOGICAL MINTER
      INTEGER M1
      INTEGER M2
      INTEGER DIME
      INTEGER D1(*)
      INTEGER D2(*)
      REAL*8  MM1(*)
      REAL*8  MM2(*)
      REAL*8  PAN1(DIME+2,*)
      REAL*8  PAN2(DIME+2,*)
C
C ----------------------------------------------------------------------
C
C APPARIEMENT DE DEUX GROUPES DE MAILLE PAR LA METHODE
C BOITES ENGLOBANTES + ARBRE BSP
C
C TEST APPROCHE D'INTERSECTION DE LA MAILLE M1 AVEC LA MAILLE M2
C
C ----------------------------------------------------------------------
C
C
C IN  DIME  : DIMENSION DE L'ESPACE
C IN  M1    : MAILLE 1
C IN  M2    : MAILLE 2
C IN  D1    : SD BOITE.DIME ASSOCIEE A M1 (CF BOITE)
C IN  D2    : SD BOITE.DIME ASSOCIEE A M2 (CF BOITE)
C IN  MM1   : SD BOITE.MINMAX ASSOCIEE A M1 (CF BOITE)
C IN  MM2   : SD BOITE.MINMAX ASSOCIEE A M2 (CF BOITE)
C IN  PAN1  : SD BOITE.PAN ASSOCIEE A M1 (CF BOITE)
C IN  PAN2  : SD BOITE.PAN ASSOCIEE A M2 (CF BOITE)
C OUT INTER : .TRUE. SI CONVEXES ENGLOBANT M1 ET M2 S'INTERSECTENT
C
C
C ----------------------------------------------------------------------
C
      INTEGER NP1,NP2,I,J,K,NS,P1,P2,IRET
      REAL*8  A(4,9),B(4,3),C(9),S2(9),R0,R1,DET
C
C ----------------------------------------------------------------------
C
C
C --- PREMIER TEST: BOITE MINMAX
C
      MINTER = .FALSE.
      P1     = 2*DIME*(M1-1)
      P2     = 2*DIME*(M2-1)

      DO 10 I = 1, DIME
        P1 = P1 + 1
        P2 = P2 + 1
        R0 = MAX(MM1(P1),MM2(P2))
        P1 = P1 + 1
        P2 = P2 + 1
        R1 = MIN(MM1(P1),MM2(P2))
        IF (R0.GT.R1) GOTO 80
 10   CONTINUE
C
C --- SECOND TEST: INTERSECTION PAN
C
      MINTER = .TRUE.
      P1     = D1(1+2*M1)
      NP1    = D1(3+2*M1) - P1
      P1     = P1 - 1
      P2     = D2(1+2*M2)
      NP2    = D2(3+2*M2) - P2
      P2     = P2 - 1
C
      DO 20 J = 1, DIME
        DO 21 I = 1, DIME
          B(I,J) = -PAN1(I,P1+J)
 21     CONTINUE
 20   CONTINUE
C
      K = 0
      DO 30 J = J, NP1
        K = K + 1
        DO 40 I = 1, DIME
          A(I,K) = PAN1(I,P1+J)
 40     CONTINUE
        S2(K) = PAN1(I,P1+J)
 30   CONTINUE
C
      DO 50 J = 1, NP2
        K = K + 1
        DO 60 I = 1, DIME
          A(I,K) = PAN2(I,P2+J)
 60     CONTINUE
        S2(K) = PAN2(I,P2+J)
 50   CONTINUE
C
      NS = NP1 + NP2 - DIME
C
      CALL MGAUSS('NFVP',B,A,4,DIME,NS,DET,IRET)
      CALL MMPROD(PAN1(1,P1+1),DIME+2,DIME+1,1,0,DIME,A,4,0,0,NS,C)
C
      DO 70 J = 1, NS
        S2(J) = S2(J) + C(J)
 70   CONTINUE
C
      CALL SMPLX2(A     ,S2    ,4     ,DIME  ,NS    ,
     &            MINTER)

 80   CONTINUE

      END

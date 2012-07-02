      SUBROUTINE PREDIA(A,B,DIAG,NNO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
      INTEGER I ,IC ,J ,NNO
C-----------------------------------------------------------------------
C
C    ESTIMATEUR ZZ (2-EME VERSION 92)
C
C      PRECONDITIONNEMENT PAR LA DIAGONALE DU SYSTEME LOCAL
C
      REAL*8    A(9,9),B(9,4),DIAG(9)
      DO 1 I=1,NNO
         DIAG(I) = 1.D0/SQRT(A(I,I))
1        CONTINUE
      DO 2 I=1,NNO
        DO 3 J=1,I
          A(I,J) = A(I,J) * DIAG(I) *DIAG(J)
3       CONTINUE
2     CONTINUE
      DO 4 IC=1,4
        DO 5 I=1,NNO
          B(I,IC) = B(I,IC) * DIAG(I)
5       CONTINUE
4     CONTINUE
      DO 6 I=1,NNO
        DO 7 J=I+1,NNO
          A(I,J) = A(J,I)
7       CONTINUE
6     CONTINUE
      END

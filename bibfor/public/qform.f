      SUBROUTINE QFORM ( M, N, Q, LDQ, WA )
      IMPLICIT   NONE
      INTEGER    M, N, LDQ
      REAL*8     Q(LDQ,M), WA(M)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PUBLIC  DATE 29/10/2003   AUTEUR BOYERE E.BOYERE 
C-----------------------------------------------------------------------
C COPYRIGHT (C) ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980
C               BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C-----------------------------------------------------------------------
C     SUBROUTINE QFORM
C
C     THIS SUBROUTINE PROCEEDS FROM THE COMPUTED QR FACTORIZATION OF
C     AN M BY N MATRIX A TO ACCUMULATE THE M BY M ORTHOGONAL MATRIX
C     Q FROM ITS FACTORED FORM.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE QFORM(M,N,Q,LDQ,WA)
C
C     WHERE
C
C       M IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF ROWS OF A AND THE ORDER OF Q.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF COLUMNS OF A.
C
C       Q IS AN M BY M ARRAY. ON INPUT THE FULL LOWER TRAPEZOID IN
C         THE FIRST MIN(M,N) COLUMNS OF Q CONTAINS THE FACTORED FORM.
C         ON OUTPUT Q HAS BEEN ACCUMULATED INTO A SQUARE MATRIX.
C
C       LDQ IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN M
C         WHICH SPECIFIES THE LEADING DIMENSION OF THE ARRAY Q.
C
C       WA IS A WORK ARRAY OF LENGTH M.
C-----------------------------------------------------------------------
      INTEGER  I, J, JM1, K, L, MINMN, NP1
      REAL*8   ONE, SUM, TEMP, ZERO
C
      DATA  ONE, ZERO / 1.0D0, 0.0D0 /
C     ------------------------------------------------------------------
C
C     ZERO OUT UPPER TRIANGLE OF Q IN THE FIRST MIN(M,N) COLUMNS.
C
      MINMN = MIN(M,N)
      IF (MINMN .LT. 2) GO TO 30
      DO 20 J = 2, MINMN
         JM1 = J - 1
         DO 10 I = 1, JM1
            Q(I,J) = ZERO
   10       CONTINUE
   20    CONTINUE
   30 CONTINUE
C
C     INITIALIZE REMAINING COLUMNS TO THOSE OF THE IDENTITY MATRIX.
C
      NP1 = N + 1
      IF (M .LT. NP1) GO TO 60
      DO 50 J = NP1, M
         DO 40 I = 1, M
            Q(I,J) = ZERO
   40       CONTINUE
         Q(J,J) = ONE
   50    CONTINUE
   60 CONTINUE
C
C     ACCUMULATE Q FROM ITS FACTORED FORM.
C
      DO 120 L = 1, MINMN
         K = MINMN - L + 1
         DO 70 I = K, M
            WA(I) = Q(I,K)
            Q(I,K) = ZERO
   70       CONTINUE
         Q(K,K) = ONE
         IF (WA(K) .EQ. ZERO) GO TO 110
         DO 100 J = K, M
            SUM = ZERO
            DO 80 I = K, M
               SUM = SUM + Q(I,J)*WA(I)
   80          CONTINUE
            TEMP = SUM/WA(K)
            DO 90 I = K, M
               Q(I,J) = Q(I,J) - TEMP*WA(I)
   90          CONTINUE
  100       CONTINUE
  110    CONTINUE
  120    CONTINUE
C
C     LAST CARD OF SUBROUTINE QFORM.
C
      END

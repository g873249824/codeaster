      SUBROUTINE DLACPY( UPLO, M, N, A, LDA, B, LDB )
C----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 12/12/2002   AUTEUR MCOURTOI M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) LAPACK
C ======================================================================
C 
C     SUBROUTINE LAPACK RECOPIANT UNE MATRICE SUIVANT SON TYPE.
C-----------------------------------------------------------------------
C
C  -- LAPACK AUXILIARY ROUTINE (VERSION 2.0) --
C     UNIV. OF TENNESSEE, UNIV. OF CALIFORNIA BERKELEY, NAG LTD.,
C     COURANT INSTITUTE, ARGONNE NATIONAL LAB, AND RICE UNIVERSITY
C     FEBRUARY 29, 1992
C
C  PURPOSE
C  =======
C
C  DLACPY COPIES ALL OR PART OF A TWO-DIMENSIONAL MATRIX A TO ANOTHER
C  MATRIX B.
C
C  ARGUMENTS
C  =========
C
C  UPLO    (INPUT) CHARACTER*1
C          SPECIFIES THE PART OF THE MATRIX A TO BE COPIED TO B.
C          = 'U':      UPPER TRIANGULAR PART
C          = 'L':      LOWER TRIANGULAR PART
C          OTHERWISE:  ALL OF THE MATRIX A
C
C  M       (INPUT) INTEGER
C          THE NUMBER OF ROWS OF THE MATRIX A.  M >= 0.
C
C  N       (INPUT) INTEGER
C          THE NUMBER OF COLUMNS OF THE MATRIX A.  N >= 0.
C
C  A       (INPUT) REAL*8 ARRAY, DIMENSION (LDA,N)
C          THE M BY N MATRIX A.  IF UPLO = 'U', ONLY THE UPPER TRIANGLE
C          OR TRAPEZOID IS ACCESSED, IF UPLO = 'L', ONLY THE LOWER
C          TRIANGLE OR TRAPEZOID IS ACCESSED.
C
C  LDA     (INPUT) INTEGER
C          THE LEADING DIMENSION OF THE ARRAY A.  LDA >= MAX(1,M).
C
C  B       (OUTPUT) REAL*8 ARRAY, DIMENSION (LDB,N)
C          ON EXIT, B = A IN THE LOCATIONS SPECIFIED BY UPLO.
C
C  LDB     (INPUT) INTEGER
C          THE LEADING DIMENSION OF THE ARRAY B.  LDB >= MAX(1,M).
C
C-----------------------------------------------------------------------
C
C ASTER INFORMATION
C 14/01/2000 TOILETTAGE DU FORTRAN SUIVANT LES REGLES ASTER.
C            IMPLICIT NONE.
C-----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE
C
C     .. SCALAR ARGUMENTS ..
      CHARACTER*1        UPLO
      INTEGER            LDA, LDB, M, N
C     ..
C     .. ARRAY ARGUMENTS ..
      REAL*8   A( LDA, * ), B( LDB, * )
C     ..
      
C     .. LOCAL SCALARS ..
      INTEGER            I, J
C     ..
C     .. EXTERNAL FUNCTIONS ..
      LOGICAL            LSAME
C     ..
C     .. EXECUTABLE STATEMENTS ..
C
      IF( LSAME( UPLO, 'U' ) ) THEN
         DO 20 J = 1, N
            DO 10 I = 1, MIN( J, M )
               B( I, J ) = A( I, J )
   10       CONTINUE
   20    CONTINUE
      ELSE IF( LSAME( UPLO, 'L' ) ) THEN
         DO 40 J = 1, N
            DO 30 I = J, M
               B( I, J ) = A( I, J )
   30       CONTINUE
   40    CONTINUE
      ELSE
         DO 60 J = 1, N
            DO 50 I = 1, M
               B( I, J ) = A( I, J )
   50       CONTINUE
   60    CONTINUE
      END IF
C
C     END OF DLACPY
C
      END

      SUBROUTINE HYBRD1(N,X,FVEC,TOL,WA,LWA,INFO,
     +                  COEF1,FLUID,GEOM1,CFPCD1,DZ,D2Z,DT,ITDASH,URM1)
      IMPLICIT  NONE
      INTEGER   N,INFO,LWA,ITDASH
      REAL*8    TOL,X(N),FVEC(N),WA(LWA),COEF1(*),FLUID(*),GEOM1(*),
     *          CFPCD1(*),URM1,DZ,D2Z,DT
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PUBLIC  DATE 29/10/2003   AUTEUR BOYERE E.BOYERE 
C-----------------------------------------------------------------------
C COPYRIGHT (C) ARGONNE NATIONAL LABORATORY. MINPACK PROJECT. MARCH 1980
C               BURTON S. GARBOW, KENNETH E. HILLSTROM, JORGE J. MORE
C-----------------------------------------------------------------------
C     SUBROUTINE HYBRD1
C
C     THE PURPOSE OF HYBRD1 IS TO FIND A ZERO OF A SYSTEM OF
C     N NONLINEAR FUNCTIONS IN N VARIABLES BY A MODIFICATION
C     OF THE POWELL HYBRID METHOD. THIS IS DONE BY USING THE
C     MORE GENERAL NONLINEAR EQUATION SOLVER HYBRD. THE USER
C     MUST PROVIDE A SUBROUTINE WHICH CALCULATES THE FUNCTIONS.
C     THE JACOBIAN IS THEN CALCULATED BY A FORWARD-DIFFERENCE
C     APPROXIMATION.
C
C     THE SUBROUTINE STATEMENT IS
C
C       SUBROUTINE HYBRD1(FCN,N,X,FVEC,TOL,INFO,WA,LWA)
C
C     WHERE
C
C       FCN IS THE NAME OF THE USER-SUPPLIED SUBROUTINE WHICH
C         CALCULATES THE FUNCTIONS. FCN MUST BE DECLARED
C         IN AN EXTERNAL STATEMENT IN THE USER CALLING
C         PROGRAM, AND SHOULD BE WRITTEN AS FOLLOWS.
C
C         SUBROUTINE FCN(N,X,FVEC,IFLAG)
C         INTEGER N,IFLAG
C         REAL*8 X(N),FVEC(N)
C         ----------
C         CALCULATE THE FUNCTIONS AT X AND
C         RETURN THIS VECTOR IN FVEC.
C         ---------
C         RETURN
C         END
C
C         THE VALUE OF IFLAG SHOULD NOT BE CHANGED BY FCN UNLESS
C         THE USER WANTS TO TERMINATE EXECUTION OF HYBRD1.
C         IN THIS CASE SET IFLAG TO A NEGATIVE INTEGER.
C
C       N IS A POSITIVE INTEGER INPUT VARIABLE SET TO THE NUMBER
C         OF FUNCTIONS AND VARIABLES.
C
C       X IS AN ARRAY OF LENGTH N. ON INPUT X MUST CONTAIN
C         AN INITIAL ESTIMATE OF THE SOLUTION VECTOR. ON OUTPUT X
C         CONTAINS THE FINAL ESTIMATE OF THE SOLUTION VECTOR.
C
C       FVEC IS AN OUTPUT ARRAY OF LENGTH N WHICH CONTAINS
C         THE FUNCTIONS EVALUATED AT THE OUTPUT X.
C
C       TOL IS A NONNEGATIVE INPUT VARIABLE. TERMINATION OCCURS
C         WHEN THE ALGORITHM ESTIMATES THAT THE RELATIVE ERROR
C         BETWEEN X AND THE SOLUTION IS AT MOST TOL.
C
C       INFO IS AN INTEGER OUTPUT VARIABLE. IF THE USER HAS
C         TERMINATED EXECUTION, INFO IS SET TO THE (NEGATIVE)
C         VALUE OF IFLAG. SEE DESCRIPTION OF FCN. OTHERWISE,
C         INFO IS SET AS FOLLOWS.
C
C         INFO = 0   IMPROPER INPUT PARAMETERS.
C
C         INFO = 1   ALGORITHM ESTIMATES THAT THE RELATIVE ERROR
C                    BETWEEN X AND THE SOLUTION IS AT MOST TOL.
C
C         INFO = 2   NUMBER OF CALLS TO FCN HAS REACHED OR EXCEEDED
C                    200*(N+1).
C
C         INFO = 3   TOL IS TOO SMALL. NO FURTHER IMPROVEMENT IN
C                    THE APPROXIMATE SOLUTION X IS POSSIBLE.
C
C         INFO = 4   ITERATION IS NOT MAKING GOOD PROGRESS.
C
C       WA IS A WORK ARRAY OF LENGTH LWA.
C
C       LWA IS A POSITIVE INTEGER INPUT VARIABLE NOT LESS THAN
C         (N*(3*N+13))/2.
C-----------------------------------------------------------------------
      INTEGER   INDEX,J,LR,MAXFEV,ML,MODE,MU,NFEV,NPRINT
      REAL*8    EPSFCN, FACTOR, ONE, XTOL, ZERO
C
      DATA  FACTOR, ONE, ZERO / 1.0D2, 1.0D0, 0.0D0 /
C     ------------------------------------------------------------------
      INFO = 0
C
C     CHECK THE INPUT PARAMETERS FOR ERRORS.
C
      IF (N .LE. 0 .OR. TOL .LT. ZERO .OR. LWA .LT. (N*(3*N + 13))/2)
     *   GO TO 20
C
C     CALL HYBRD.
C
      MAXFEV = 200*(N + 1)
      XTOL = TOL
      ML = N - 1
      MU = N - 1
      EPSFCN = ZERO
      MODE = 2
      DO 10 J = 1, N
         WA(J) = ONE
   10    CONTINUE
      NPRINT = 0
      LR = (N*(N + 1))/2
      INDEX = 6*N + LR
      CALL HYBR1(N,X,FVEC,XTOL,MAXFEV,ML,MU,EPSFCN,WA(1),MODE,
     *           FACTOR,NPRINT,INFO,NFEV,WA(INDEX+1),N,WA(6*N+1),LR,
     *           WA(N+1),WA(2*N+1),WA(3*N+1),WA(4*N+1),WA(5*N+1),
     *           COEF1,FLUID,GEOM1,CFPCD1,DZ,D2Z,DT,ITDASH,URM1)
      IF (INFO .EQ. 5) INFO = 4
   20 CONTINUE
C
C     LAST CARD OF SUBROUTINE HYBRD1.
C
      END

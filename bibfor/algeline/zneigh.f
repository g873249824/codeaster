      SUBROUTINE ZNEIGH (RNORM, N, H, LDH, RITZ, BOUNDS, 
     &                   Q, LDQ, WORKL, RWORK, IERR)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 17/02/2003   AUTEUR NICOLAS O.NICOLAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C ======================================================================
C
C     SUBROUTINE ARPACK CALCULANT LES MODES PROPRES DE LA MATRICE DE
C     HESSENBERG AINSI QUE LEURS ERREURS.
C-----------------------------------------------------------------------
C\BEGINDOC
C
C\NAME: ZNEIGH
C
C\DESCRIPTION:
C  COMPUTE THE EIGENVALUES OF THE CURRENT UPPER HESSENBERG MATRIX
C  AND THE CORRESPONDING RITZ ESTIMATES GIVEN THE CURRENT RESIDUAL NORM.
C
C\USAGE:
C  CALL ZNEIGH
C     ( RNORM, N, H, LDH, RITZ, BOUNDS, Q, LDQ, WORKL, RWORK, IERR )
C
C\ARGUMENTS
C  RNORM   DOUBLE PRECISION SCALAR.  (INPUT)
C          RESIDUAL NORM CORRESPONDING TO THE CURRENT UPPER HESSENBERG 
C          MATRIX H.
C
C  N       INTEGER.  (INPUT)
C          SIZE OF THE MATRIX H.
C
C  H       COMPLEX*16 N BY N ARRAY.  (INPUT)
C          H CONTAINS THE CURRENT UPPER HESSENBERG MATRIX.
C
C  LDH     INTEGER.  (INPUT)
C          LEADING DIMENSION OF H EXACTLY AS DECLARED IN THE CALLING
C          PROGRAM.
C
C  RITZ    COMPLEX*16 ARRAY OF LENGTH N.  (OUTPUT)
C          ON OUTPUT, RITZ(1:N) CONTAINS THE EIGENVALUES OF H.
C
C  BOUNDS  COMPLEX*16 ARRAY OF LENGTH N.  (OUTPUT)
C          ON OUTPUT, BOUNDS CONTAINS THE RITZ ESTIMATES ASSOCIATED WITH
C          THE EIGENVALUES HELD IN RITZ.  THIS IS EQUAL TO RNORM 
C          TIMES THE LAST COMPONENTS OF THE EIGENVECTORS CORRESPONDING 
C          TO THE EIGENVALUES IN RITZ.
C
C  Q       COMPLEX*16 N BY N ARRAY.  (WORKSPACE)
C          WORKSPACE NEEDED TO STORE THE EIGENVECTORS OF H.
C
C  LDQ     INTEGER.  (INPUT)
C          LEADING DIMENSION OF Q EXACTLY AS DECLARED IN THE CALLING
C          PROGRAM.
C
C  WORKL   COMPLEX*16 WORK ARRAY OF LENGTH N**2 + 3*N.  (WORKSPACE)
C          PRIVATE (REPLICATED) ARRAY ON EACH PE OR ARRAY ALLOCATED ON
C          THE FRONT END.  THIS IS NEEDED TO KEEP THE FULL SCHUR FORM
C          OF H AND ALSO IN THE CALCULATION OF THE EIGENVECTORS OF H.
C
C  RWORK   DOUBLE PRECISION  WORK ARRAY OF LENGTH N (WORKSPACE)
C          PRIVATE (REPLICATED) ARRAY ON EACH PE OR ARRAY ALLOCATED ON
C          THE FRONT END. 
C
C  IERR    INTEGER.  (OUTPUT)
C          ERROR EXIT FLAG FROM GLAHQR OR GTREVC.
C
C\ENDDOC
C
C-----------------------------------------------------------------------
C
C\BEGINLIB
C
C\LOCAL VARIABLES:
C     XXXXXX  COMPLEX*16
C
C\ROUTINES CALLED:
C     IVOUT   ARPACK UTILITY ROUTINE THAT PRINTS INTEGERS.
C     ZMOUT   ARPACK UTILITY ROUTINE THAT PRINTS MATRICES
C     ZVOUT   ARPACK UTILITY ROUTINE THAT PRINTS VECTORS.
C     DVOUT   ARPACK UTILITY ROUTINE THAT PRINTS VECTORS.
C     GLACPY  LAPACK MATRIX COPY ROUTINE.
C     GLAHQR  LAPACK ROUTINE TO COMPUTE THE SCHUR FORM OF AN
C             UPPER HESSENBERG MATRIX.
C     GLASET  LAPACK MATRIX INITIALIZATION ROUTINE.
C     GTREVC  LAPACK ROUTINE TO COMPUTE THE EIGENVECTORS OF A MATRIX
C             IN UPPER TRIANGULAR FORM
C     GLCOPY   LEVEL 1 BLAS THAT COPIES ONE VECTOR TO ANOTHER. 
C     GLSCAL  LEVEL 1 BLAS THAT SCALES A COMPLEX VECTOR BY A REAL 
C             NUMBER.
C     GLNRM2  LEVEL 1 BLAS THAT COMPUTES THE NORM OF A VECTOR.
C     
C
C\AUTHOR
C     DANNY SORENSEN               PHUONG VU
C     RICHARD LEHOUCQ              CRPC / RICE UNIVERSITY
C     DEPT. OF COMPUTATIONAL &     HOUSTON, TEXAS
C     APPLIED MATHEMATICS 
C     RICE UNIVERSITY           
C     HOUSTON, TEXAS 
C
C\SCCS INFORMATION: @(#)
C FILE: NEIGH.F   SID: 2.2   DATE OF SID: 4/20/96   RELEASE: 2
C
C\REMARKS
C     NONE
C
C\ENDLIB
C
C-----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C     %-----------------------------%
C     | INCLUDE FILES FOR DEBUGGING |
C     %-----------------------------%

      INTEGER LOGFIL, NDIGIT, MGETV0,
     &  MNAUPD, MNAUP2, MNAITR, MNEIGH, MNAPPS, MNGETS, MNEUPD
      COMMON /DEBUG/
     &  LOGFIL, NDIGIT, MGETV0,
     &  MNAUPD, MNAUP2, MNAITR, MNEIGH, MNAPPS, MNGETS, MNEUPD
C
C     %------------------%
C     | SCALAR ARGUMENTS |
C     %------------------%
C
      INTEGER IERR, N, LDH, LDQ
      REAL*8 RNORM
C
C     %-----------------%
C     | ARRAY ARGUMENTS |
C     %-----------------%
C
      COMPLEX*16 BOUNDS(N), H(LDH,N), Q(LDQ,N), RITZ(N),
     &           WORKL(N*(N+3)) 
      REAL*8     RWORK(N)
C 
C     %------------%
C     | PARAMETERS |
C     %------------%
C
      COMPLEX*16  ONE, ZERO
      REAL*8      RONE
      PARAMETER  (ONE = (1.0D+0, 0.0D+0), ZERO = (0.0D+0, 0.0D+0),
     &           RONE = 1.0D+0)
C 
C     %------------------------%
C     | LOCAL SCALARS & ARRAYS |
C     %------------------------%
C
      LOGICAL    SELECT(1)
      INTEGER    J,  MSGLVL
      COMPLEX*16 VL(1)
      REAL*8     TEMP
C
C     %--------------------%
C     | EXTERNAL FUNCTIONS |
C     %--------------------%
C
      REAL*8    GLNRM2
C
C     %-----------------------%
C     | EXECUTABLE STATEMENTS |
C     %-----------------------%
C
C     %-------------------------------%
C     | INITIALIZE TIMING STATISTICS  |
C     | & MESSAGE LEVEL FOR DEBUGGING |
C     %-------------------------------%
C
      MSGLVL = MNEIGH
C 
      IF (MSGLVL .GT. 2) THEN
          CALL ZMOUT (LOGFIL, N, N, H, LDH, NDIGIT, 
     &         '_NEIGH: ENTERING UPPER HESSENBERG MATRIX H ')
      END IF
C 
C     %----------------------------------------------------------%
C     | 1. COMPUTE THE EIGENVALUES, THE LAST COMPONENTS OF THE   |
C     |    CORRESPONDING SCHUR VECTORS AND THE FULL SCHUR FORM T |
C     |    OF THE CURRENT UPPER HESSENBERG MATRIX H.             |
C     |    GLAHQR RETURNS THE FULL SCHUR FORM OF H               | 
C     |    IN WORKL(1:N**2), AND THE SCHUR VECTORS IN Q.         |
C     %----------------------------------------------------------%
C
      CALL GLACPY ('A', N, N, H, LDH, WORKL, N)
      CALL GLASET ('A', N, N, ZERO, ONE, Q, LDQ)
      
      CALL GLAHQR (.TRUE., .TRUE., N, 1, N, WORKL, LDH, RITZ,
     &             1, N, Q, LDQ, IERR)
      IF (IERR .NE. 0) GO TO 9000
C
      CALL GLCOPY (N, Q(N-1,1), LDQ, BOUNDS, 1)
      IF (MSGLVL .GT. 1) THEN
         CALL ZVOUT (LOGFIL, N, BOUNDS, NDIGIT,
     &              '_NEIGH: LAST ROW OF THE SCHUR MATRIX FOR H')
      END IF
C
C     %----------------------------------------------------------%
C     | 2. COMPUTE THE EIGENVECTORS OF THE FULL SCHUR FORM T AND |
C     |    APPLY THE SCHUR VECTORS TO GET THE CORRESPONDING      |
C     |    EIGENVECTORS.                                         |
C     %----------------------------------------------------------%
C
      CALL GTREVC ('R', 'B', SELECT, N, WORKL, N, VL, N, Q, 
     &             LDQ, N, N, WORKL(N*N+1), RWORK, IERR)
C
      IF (IERR .NE. 0) GO TO 9000
C
C     %------------------------------------------------%
C     | SCALE THE RETURNING EIGENVECTORS SO THAT THEIR |
C     | EUCLIDEAN NORMS ARE ALL ONE. LAPACK SUBROUTINE |
C     | GTREVC RETURNS EACH EIGENVECTOR NORMALIZED SO  |
C     | THAT THE ELEMENT OF LARGEST MAGNITUDE HAS      |
C     | MAGNITUDE 1; HERE THE MAGNITUDE OF A COMPLEX   |
C     | NUMBER (X,Y) IS TAKEN TO BE |X| + |Y|.         |
C     %------------------------------------------------%
C
      DO 10 J=1, N
            TEMP = GLNRM2( N, Q(1,J), 1 )
            CALL GLSCAL ( N, RONE / TEMP, Q(1,J), 1 )
   10 CONTINUE
C
      IF (MSGLVL .GT. 1) THEN
         CALL GLCOPY(N, Q(N,1), LDQ, WORKL, 1)
         CALL ZVOUT (LOGFIL, N, WORKL, NDIGIT,
     &              '_NEIGH: LAST ROW OF THE EIGENVECTOR MATRIX FOR H')
      END IF
C
C     %----------------------------%
C     | COMPUTE THE RITZ ESTIMATES |
C     %----------------------------%
C
      CALL GLCOPY(N, Q(N,1), N, BOUNDS, 1)
      CALL GLSCAL(N, RNORM, BOUNDS, 1)
C
      IF (MSGLVL .GT. 2) THEN
         CALL ZVOUT (LOGFIL, N, RITZ, NDIGIT,
     &              '_NEIGH: THE EIGENVALUES OF H')
         CALL ZVOUT (LOGFIL, N, BOUNDS, NDIGIT,
     &              '_NEIGH: RITZ ESTIMATES FOR THE EIGENVALUES OF H')
      END IF
C
C
 9000 CONTINUE
C
C     %---------------%
C     | END OF ZNEIGH |
C     %---------------%
C
      END

      SUBROUTINE  GLSWAP (N,ZX,INCX,ZY,INCY)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 17/02/2003   AUTEUR NICOLAS O.NICOLAS 
C ======================================================================
C COPYRIGHT (C) BLAS
C ======================================================================
C     INTERCHANGES TWO VECTORS.
C     JACK DONGARRA, 3/11/78.
C     MODIFIED 12/3/93, ARRAY(1) DECLARATIONS CHANGED TO ARRAY(*)
C
C ======================================================================
C REMPLACE LA BLAS ZSWAP SUR LES MACHINES OU ELLE N'EST PAS DISPONIBLE
C DANS LES LIBRAIRIES SYSTEME
C-----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE
C
      COMPLEX*16 ZX(*),ZY(*),ZTEMP
      INTEGER I,INCX,INCY,IX,IY,N
C
      IF(N.LE.0)GOTO 9999
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20
C
C       CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS NOT EQUAL
C         TO 1
C
      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        ZTEMP = ZX(IX)
        ZX(IX) = ZY(IY)
        ZY(IY) = ZTEMP
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      GOTO 9999
C
C       CODE FOR BOTH INCREMENTS EQUAL TO 1
   20 CONTINUE
      DO 30 I = 1,N
        ZTEMP = ZX(I)
        ZX(I) = ZY(I)
        ZY(I) = ZTEMP
   30 CONTINUE
9999  CONTINUE
      END


      SUBROUTINE EFCOOL(FID,MAA,MDIM,COO,MODCOO,NUMCO,PFLTAB,PSIZE,
     &                  TYPREP,NOM,UNIT,CRET)
      IMPLICIT NONE
      CHARACTER *(*) MAA
      INTEGER FID,MDIM,MODCOO,N,TYPREP,CRET,PSIZE,NUMCO
      INTEGER PFLTAB(*)
      REAL*8 COO(*)
      CHARACTER*(*) NOM,UNIT
      CALL U2MESS('F','FERMETUR_2')
      END


      SUBROUTINE EFCHRE(FID,MAA,CHA,VAL,INTLAC,N,LOCNAME,NUMCO,
     &                  PROFIL,PFLMOD,TYPENT,TYPGEO,NUMDT,DTUNIT,
     &                  DT,NUMO,CRET)
      IMPLICIT NONE
      CHARACTER *(*) CHA,MAA,PROFIL,LOCNAME
      CHARACTER*(*) DTUNIT
      INTEGER FID,N,PFLMOD,TYPENT,TYPGEO,CRET
      INTEGER INTLAC,NUMCO,NUMDT,NUMO
      REAL*8 DT
      REAL*8 VAL(*)
      CALL U2MESS('F','FERMETUR_2')
      END

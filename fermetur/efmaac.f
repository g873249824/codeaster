      SUBROUTINE EFMAAC ( FID , NOM , DIM , TYPE, DESC, CRET )
      IMPLICIT NONE
      CHARACTER *(*) NOM
      CHARACTER *(*) DESC
      INTEGER FID, DIM, TYPE, CRET
      CALL UTMESS('F','EFMAAC','LA BIBLIOTHEQUE "MED" EST INDISPONIBLE'
     &            //' SUR CETTE MACHINE.')
      END
   

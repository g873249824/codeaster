      SUBROUTINE I2RDLI (N,T,ADR)
      IMPLICIT NONE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C
      INTEGER N,T(*),ADR
C
      LOGICAL FINI,TROUVE
      INTEGER I,J
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      I = 1
      J = 0
C
      TROUVE = .FALSE.
      FINI   = .FALSE.
C
10    CONTINUE
      IF ( (.NOT. FINI) .AND. (I .LT. ADR) ) THEN
C
         IF ( T(I) .LT. N ) THEN
C
            I = I + 1
C
         ELSE IF ( T(I) .EQ. N ) THEN
C
            TROUVE = .TRUE.
            FINI   = .TRUE.
C
         ELSE
C
            FINI = .TRUE.
C
         ENDIF
C
         GOTO 10
C
      ENDIF
C
      IF ( .NOT. TROUVE ) THEN
C
         DO 20, J = ADR-1, I, -1
C
            T(J+1) = T(J)
C
20       CONTINUE
C
         T(I) = N
         ADR  = ADR + 1
C
      ENDIF
C
      END

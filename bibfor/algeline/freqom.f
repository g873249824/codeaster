      FUNCTION   FREQOM ( OMEGA )
      IMPLICIT NONE
      REAL*8     FREQOM,  OMEGA
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     ------------------------------------------------------------------
C     CALCULE LA FREQUENCE FREQOM ASSOCIEE A LA PULSATION OMEGA
C              FREQUENCE = SQRT(OMEGA) / (2*PI)
C     ------------------------------------------------------------------
C     REMARQUE : SI LA PULSATION D'ENTREE EST NEGATIVE
C                   ALORS ON RETOURNE  (-FREQOM)
C     ------------------------------------------------------------------
      REAL*8       R8DEPI, DEPIDE
      SAVE                 DEPIDE
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      DATA                 DEPIDE/-1.D0/
      IF ( DEPIDE .LT. 0) THEN
         DEPIDE = R8DEPI()
         DEPIDE = DEPIDE * DEPIDE
         DEPIDE = 1.D0 / DEPIDE
      ENDIF
      IF ( OMEGA .GE. 0.D0 )THEN
         FREQOM = + SQRT( + OMEGA * DEPIDE )
      ELSE
         FREQOM = - SQRT( - OMEGA * DEPIDE )
      ENDIF
      END

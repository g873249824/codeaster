      FUNCTION   OMEGA2 ( FREQ )
      IMPLICIT NONE
      REAL*8     OMEGA2,  FREQ
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
C     CALCULE LA PULSATION OMEGA**2 ASSOCIEE A LA FREQUENCE FREQ
C              OMEGA**2 = ( FREQ * 2*PI ) ** 2
C     ------------------------------------------------------------------
C     REMARQUE : SI LA FREQUENCE D'ENTREE EST NEGATIVE
C                   ALORS ON RETOURNE  (-OMEGA2)
C     ------------------------------------------------------------------
      REAL*8       R8DEPI, DEPIDE
      SAVE                 DEPIDE
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      DATA                 DEPIDE/-1.D0/
C     ------------------------------------------------------------------
      IF ( DEPIDE .LT. 0) THEN
         DEPIDE = R8DEPI()
         DEPIDE = DEPIDE * DEPIDE
      ENDIF
      IF (FREQ .GE. 0 ) THEN
         OMEGA2 = +  FREQ * FREQ * DEPIDE
      ELSE
         OMEGA2 = -  FREQ * FREQ * DEPIDE
      ENDIF
      END

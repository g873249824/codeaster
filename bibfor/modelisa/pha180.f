      SUBROUTINE PHA180(IFOI,PTF,PHASE)
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C-----------------------------------------------------------------------
C     PROJECTION D'UN SPECTRE D'EXCITATION TURBULENTE REPARTIE SUR UNE
C     BASE MODALE PERTURBEE PAR COUPLAGE FLUIDE-STRUCTURE
C     VALEURS DES PHASES POUR LES INTERSPECTRES GRAPPE1, DEBIT 180M3/H
C-----------------------------------------------------------------------
C IN  : IFOI   : COMPTEUR DES INTERSPECTRES AU-DESSUS DE LA DIAGONALE
C                IFOI = (IFO2-1)*(IFO2-2)/2 + IFO1
C                IFO1 INDICE DE LIGNE , IFO2 INDICE DE COLONNE (IFO2>1)
C IN  : PTF    : VALEUR DE LA FREQUENCE
C OUT : PHASE  : VALEUR DE LA PHASE
C
C
      INCLUDE 'jeveux.h'
      INTEGER      IFOI
      REAL*8       PTF,PHASE
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      REAL*8 PI ,R8PI 
C-----------------------------------------------------------------------
      PI = R8PI()
C
      GO TO (12,13,23,14,24,34,15,25,35,45,16,26,36,46,56) IFOI
C
  12  CONTINUE
      PHASE = PI
      GO TO 100
C
  13  CONTINUE
      IF (PTF.LE.60.D0) THEN
        PHASE = 0.D0
      ELSE IF (PTF.GT.60.D0 .AND. PTF.LE.120.D0) THEN
        PHASE = -PI/2.D0
      ELSE
        PHASE = -PI/4.D0
      ENDIF
      GO TO 100
C
  23  CONTINUE
      PHASE = PI
      GO TO 100
C
  14  CONTINUE
      IF (PTF.LE.60.D0) THEN
        PHASE = PI
      ELSE
        PHASE = 2.D0*PI/3.D0
      ENDIF
      GO TO 100
C
  24  CONTINUE
      IF (PTF.LE.55.D0) THEN
        PHASE = 0.D0
      ELSE
        PHASE = -PI/6.D0
      ENDIF
      GO TO 100
C
  34  CONTINUE
      PHASE = PI
      GO TO 100
C
  15  CONTINUE
      IF (PTF.LE.15.D0) THEN
        PHASE = 0.D0
      ELSE IF (PTF.GT.15.D0 .AND. PTF.LE.45.D0) THEN
        PHASE = PI
      ELSE IF (PTF.GT.45.D0 .AND. PTF.LE.55.D0) THEN
        PHASE = 0.D0
      ELSE
        PHASE = PI
      ENDIF
      GO TO 100
C
  25  CONTINUE
      IF (PTF.LE.20.D0) THEN
        PHASE = PI
      ELSE IF (PTF.GT.20.D0 .AND. PTF.LE.45.D0) THEN
        PHASE = 0.D0
      ELSE IF (PTF.GT.45.D0 .AND. PTF.LE.60.D0) THEN
        PHASE = PI
      ELSE IF (PTF.GT.60.D0 .AND. PTF.LE.110.D0) THEN
        PHASE = PI/2.D0
      ELSE
        PHASE = 0.D0
      ENDIF
      GO TO 100
C
  35  CONTINUE
      IF (PTF.LE.125.D0) THEN
        PHASE = 0.D0
      ELSE
        PHASE = PI
      ENDIF
      GO TO 100
C
  45  CONTINUE
      IF (PTF.LE.45.D0) THEN
        PHASE = 0.D0
      ELSE
        PHASE = PI
      ENDIF
      GO TO 100
C
  16  CONTINUE
      PHASE = PI
      GO TO 100
C
  26  CONTINUE
      IF (PTF.LE.65.D0) THEN
        PHASE = 0.D0
      ELSE IF (PTF.GT.65.D0 .AND. PTF.LE.105.D0) THEN
        PHASE = PI/6.D0
      ELSE
        PHASE = 0.D0
      ENDIF
      GO TO 100
C
  36  CONTINUE
      IF (PTF.LE.60.D0) THEN
        PHASE = PI
      ELSE IF (PTF.GT.60.D0 .AND. PTF.LE.120.D0) THEN
        PHASE = 0.D0
      ELSE
        PHASE = PI
      ENDIF
      GO TO 100
C
  46  CONTINUE
      IF (PTF.LE.15.D0) THEN
        PHASE = 5.D0*PI/6.D0
      ELSE IF (PTF.GT.15.D0 .AND. PTF.LE.85.D0) THEN
        PHASE = 0.D0
      ELSE
        PHASE = 5.D0*PI/6.D0
      ENDIF
      GO TO 100
C
  56  CONTINUE
      IF (PTF.LE.15.D0) THEN
        PHASE = PI
      ELSE IF (PTF.GT.15.D0 .AND. PTF.LE.45.D0) THEN
        PHASE = 0.D0
      ELSE IF (PTF.GT.45.D0 .AND. PTF.LE.55.D0) THEN
        PHASE = PI
      ELSE
        PHASE = 0.D0
      ENDIF
C
 100  CONTINUE
      END

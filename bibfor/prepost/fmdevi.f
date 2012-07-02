      SUBROUTINE FMDEVI(NBFONC,NBPTOT,SIGM,DEV)
      IMPLICIT NONE
C
      INCLUDE 'jeveux.h'
      INTEGER           NBFONC,NBPTOT
      REAL*8                        SIGM(NBFONC*NBPTOT)
      REAL*8                             DEV(NBFONC*NBPTOT)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C     -----------------------------------------------------------------
C     NBFONC  : IN  : NOMBRE DE FONCTIONS (6 EN 3D 4 EN 2D)
C     NBPTOT  : IN  : NOMBRE DE PAS DE TEMPS DE CALCUL
C     SIGM    : IN  : VECTEUR DES CONTRAINTES EN TOUS LES PAS DE TEMPS
C     DEV     : OUT : VECTEUR DU DEVIATEUR DES CONTRAINTES
C     -----------------------------------------------------------------
C     ------------------------------------------------------------------
      REAL*8  PH
      INTEGER I ,IDEC ,J
C-----------------------------------------------------------------------
C
C------- CALCUL DU DEVIATEUR -------
C
      DO 10 I=1,NBPTOT
        IDEC = (I-1)*NBFONC
        PH = (SIGM(IDEC+1)+SIGM(IDEC+2)+SIGM(IDEC+3))/3.D0
        DO 20 J=1,NBFONC
          DEV(IDEC+J) = SIGM(IDEC+J)
            IF(J.LE.3) THEN
              DEV(IDEC+J)=DEV(IDEC+J)-PH
            ENDIF
  20    CONTINUE
  10  CONTINUE
C
      END

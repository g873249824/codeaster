      SUBROUTINE VROQUA(THETA ,QUATER)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
       IMPLICIT NONE
       REAL*8   QUATER(4),THETA(3)
C
C ----------------------------------------------------------------------
C
C ROUTINE UTILITAIRE (QUATERNION)
C
C CALCULE LE QUATERNION CORRESPONDANT AU VECTEUR-ROTATION THETA
C
C ----------------------------------------------------------------------
C
C
C OUT QUATER : QUATERNION
C IN  THETA  : VECTEUR ROTATION
C
C ----------------------------------------------------------------------
C
      REAL*8   EPSIL,DEMI,UN
      REAL*8   DDOT
      REAL*8   ANGLE,COEF,PROSCA
      INTEGER  I
C
C ----------------------------------------------------------------------
C
      EPSIL  = 1.D-4
      DEMI   = 5.D-1
      UN     = 1.D0
C
      PROSCA    = DDOT(3,THETA,1,THETA,1)
      ANGLE     = DEMI * SQRT(PROSCA)
      QUATER(4) = COS(ANGLE)
      IF (ANGLE.GT.EPSIL) THEN
        COEF = DEMI * SIN(ANGLE) / ANGLE
      ELSE
        COEF = UN - ANGLE**2/6.D0
        COEF = DEMI * COEF
      ENDIF
      DO 1 I=1,3
        QUATER(I) = COEF * THETA(I)
1     CONTINUE
C
      END

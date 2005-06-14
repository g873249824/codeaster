      SUBROUTINE MAJUST(ALIAS,XI,YI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 20/12/2000   AUTEUR ADBHHPM P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE
      CHARACTER*8 ALIAS
      REAL*8 XI,YI,XII,YII
      IF ((ALIAS(1:3).EQ.'SG2') .OR. (ALIAS(1:3).EQ.'SG3')) THEN
        IF (XI.LT.-1.D0) XI = -1.D0
        IF (XI.GT.1.D0) XI = 1.D0
      END IF
      IF ((ALIAS(1:3).EQ.'TR3') .OR. (ALIAS(1:3).EQ.'TR6')) THEN
        IF (XI.LT.-1.D0) XI = -1.D0
        IF (YI.LT.-1.D0) YI = -1.D0
        IF (((XI-YI+2.D0).LT.-0.D0) .AND. ((XI+YI).GT.-0.D0)) THEN
          XI = -1.D0
          YI = 1.D0
        END IF
        IF (((XI-YI-2.D0).GT.0.D0) .AND. ((XI+YI).GT.-0.D0)) THEN
          XI = 1.D0
          YI = -1.D0
        END IF
        IF (((XI-YI-2).LT.-0.D0) .AND. ((XI-YI+2).GT.0.D0) .AND.
     &      ((XI+YI).GT.0.D0)) THEN
          XII = (XI-YI)/2.D0
          YII = (YI-XI)/2.D0
          XI = XII
          YI = YII
        END IF
      END IF

      IF ((ALIAS(1:3).EQ.'QU4') .OR. (ALIAS(1:3).EQ.'QU8') .OR.
     &    (ALIAS(1:3).EQ.'QU9')) THEN
        IF (XI.LT.-1.D0) XI = -1.D0
        IF (XI.GT.1.D0) XI = 1.D0
        IF (YI.GT.1.D0) YI = 1.D0
        IF (YI.LT.-1.D0) YI = -1.D0
      END IF

      END

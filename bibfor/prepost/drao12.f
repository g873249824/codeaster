      SUBROUTINE DRAO12(COORD1,COORD2,XO1O2,YO1O2,ZO1O2,DO1O2,
     &                   COORDA,RAY)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF PREPOST  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================

      IMPLICIT NONE

C DECLARATION GLOBALE

      REAL*8 COORD1(3)
      REAL*8 COORD2(3)
      REAL*8 XO1O2, YO1O2, ZO1O2, DO1O2
      REAL*8 COORDA(3)
      REAL*8 RAY(2)

C DECLARATION LOCALE

      REAL*8 XAO1, YAO1, ZAO1, XAO2, YAO2, ZAO2
      REAL*8 DAO1, DAO2, PAO1O2, PAO2O1, N2, N3, N4
      REAL*8 R, COS1, COS2

      XAO1 = COORDA(1)-COORD1(1)
      YAO1 = COORDA(2)-COORD1(2)
      ZAO1 = COORDA(3)-COORD1(3)
      XAO2 = COORDA(1)-COORD2(1)
      YAO2 = COORDA(2)-COORD2(2)
      ZAO2 = COORDA(3)-COORD2(3)

      DAO1 = SQRT( XAO1**2 + YAO1**2 + ZAO1**2 )
      DAO2 = SQRT( XAO2**2 + YAO2**2 + ZAO2**2 )

      R = SQRT(( YAO1*ZO1O2 - ZAO1*YO1O2 )**2 +
     &         ( ZAO1*XO1O2 - XAO1*ZO1O2 )**2 +
     &         ( XAO1*YO1O2 - YAO1*XO1O2 )**2 ) / DO1O2

      RAY(1) = R
      RAY(2) = 0.0D0

      PAO1O2 =( XAO1*XO1O2 ) +( YAO1*YO1O2 ) +( ZAO1*ZO1O2 )
      IF ( DAO1.EQ.0.D0 ) THEN
        COS1 = 1.0D0
      ELSE
        COS1 = PAO1O2 /(DO1O2*DAO1)
      ENDIF
      PAO2O1 =( -XAO2*XO1O2 ) +( -YAO2*YO1O2 ) +( -ZAO2*ZO1O2 )
      IF ( DAO2.EQ.0.D0 ) THEN
        COS2 = 1.0D0
      ELSE
        COS2 = PAO2O1 /(DO1O2*DAO2)
      ENDIF
      N2 =( DAO1*COS1 ) / DO1O2
      N3 =( DAO2*COS2 ) / DO1O2
      N4 = N2 + N3
      IF ( ABS(1.D0-N2).LE.1.0D-10 ) N2 = 1.0D0
      IF ( ABS(1.D0-N3).LE.1.0D-10 ) N3 = 1.0D0
      IF ( ABS(1.D0-N4).LE.1.0D-10 ) N4 = 1.0D0
      IF ( N4.NE.1.0D0 ) THEN
        CALL U2MESS('F','PREPOST_26')
      ENDIF

      IF ( N2.GT.1.0D0 .OR. N3.GT.1.0D0 ) THEN
        IF ( N2.GT.1.0D0 ) RAY(2) = -1.0D0
        IF ( N3.GT.1.0D0 ) RAY(2) =  1.0D0
      ENDIF

      END

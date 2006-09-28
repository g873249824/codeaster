      SUBROUTINE NMTAMA(IMATE,INSTAM,INSTAP,TM,TP,MATM,MAT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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

      INTEGER IMATE
      REAL*8  INSTAM,INSTAP,TM,TP,MATM(3),MAT(14)

C ----------------------------------------------------------------------
C TAHERI :  LECTURE DES CARACTERISTIQUES DU MATERIAU
C ----------------------------------------------------------------------
C IN  IMATE  ADRESSE DU MATERIAU CODE
C IN  INSTAM INSTANT -
C IN  INSTAP INSTANT +
C IN  TM     TEMPERATURE EN T-
C IN  TP     TEMPERATURE EN T+
C OUT MATM   CARACTERISTIQUES (ELASTIQUES) EN T-
C OUT MAT    CARACTERISTIQUES (ELASTIQUES, PLASTIQUES, VISQUEUSES) EN T+
C             1 = TROISK            (ELASTICITE)
C             2 = DEUXMU            (ELASTICITE)
C             3 = ALPHA             (THERMIQUE)
C             4 = R_0               (ECROUISSAGE)
C             5 = ALPHA             (ECROUISSAGE)
C             6 = M                 (ECROUISSAGE)
C             7 = A                 (ECROUISSAGE)
C             8 = B                 (ECROUISSAGE)
C             9 = C1                (ECROUISSAGE)
C            10 = C_INF             (ECROUISSAGE)
C            11 = S                 (ECROUISSAGE)
C            12 = 1/N               (VISCOSITE)
C            13 = K/(DT)**1/N       (VISCOSITE)
C            14 = UN_SUR_M          (VISCOSITE)
C ----------------------------------------------------------------------

      LOGICAL     VISCO
      CHARACTER*8 NOM(14)
      CHARACTER*2 BL2,FB2,OK(14)
      REAL*8      E,NU

      DATA NOM / 'E','NU','ALPHA',
     &           'R_0','ALPHA','M','A','B','C1','C_INF','S',
     &           'N','UN_SUR_K','UN_SUR_M' /
      DATA BL2 / '  '/
      DATA FB2 / 'F '/


C - LECTURE DES CARACTERISTIQUES ELASTIQUES DU MATERIAU (T- ET T+)

      CALL RCVALA(IMATE,' ','ELAS',1,'TEMP',TM,2,NOM(1),MATM(1),OK(1),
     &              FB2)
      CALL RCVALA(IMATE,' ','ELAS',1,'TEMP',TM,1,NOM(3),MATM(3),OK(3),
     & BL2)
      IF (OK(3).NE.'OK') MATM(3) = 0.D0
      E       = MATM(1)
      NU      = MATM(2)
      MATM(1) = E/(1.D0-2.D0*NU)
      MATM(2) = E/(1.D0+NU)

      CALL RCVALA(IMATE,' ','ELAS',1,'TEMP',TP,2,NOM(1),MAT(1),OK(1),
     & FB2)
      CALL RCVALA(IMATE,' ','ELAS',1,'TEMP',TP,1,NOM(3),MAT(3),OK(3),
     & BL2)
      IF (OK(3).NE.'OK') MAT(3) = 0.D0
      E      = MAT(1)
      NU     = MAT(2)
      MAT(1) = E/(1.D0-2.D0*NU)
      MAT(2) = E/(1.D0+NU)


C - LECTURE DES CARACTERISTIQUES D'ECROUISSAGE (T+)
      CALL RCVALA(IMATE,' ','TAHERI',1,'TEMP',TP,8,NOM(4),MAT(4),OK(4),
     & FB2)
      MAT(7) = MAT(7) * (2.D0/3.D0)**MAT(5)

C LECTURE DES CARACTERISTIQUES DE VISCOSITE (TEMPS +)
      CALL RCVALA(IMATE,' ','LEMAITRE',1,'TEMP',TP,3,NOM(12),
     &            MAT(12),OK(12),BL2)
      VISCO = OK(12).EQ.'OK'

      IF (VISCO) THEN
        IF (MAT(12).EQ.0.D0)
     &    CALL U2MESS('F','ALGORITH8_32')
        MAT(12) = 1.D0 / MAT(12)

        IF (MAT(13).EQ.0.D0)
     &    CALL U2MESS('F','ALGORITH8_33')
        MAT(13) = 1.D0 / MAT(13) / (INSTAP-INSTAM)**MAT(12)

        IF (OK(14).NE.'OK') MAT(14) = 0.D0

      ELSE
        MAT(12) = 1.D0
        MAT(13) = 0.D0
        MAT(14) = 1.D0
      END IF


      END

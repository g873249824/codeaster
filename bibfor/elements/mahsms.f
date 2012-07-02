      SUBROUTINE MAHSMS(IND1,NB1,XI,KSI3S2,INTSR,XR,EPAIS,VECTN,
     &                                       VECTG,VECTT,HSFM,HSS)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
      INTEGER NB1,INTSR
      REAL*8 XI(3,*),XR(*),VECTN(9,3)
      REAL*8 EPAIS,KSI3S2
      REAL*8 VECTG(2,3),VECTT(3,3),HSFM(3,9),HSS(2,9)
C
C
C     CONSTRUCTION DU VECTEUR N AUX PTS D'INTEGRATION REDUIT
C     (POUR CHAQUE INTSR, STOCKAGE DANS VECTT)
C
C     ET
C
C     CONSTRUCTION DES VECTEURS GA AUX PTS D'INTEGRATION REDUIT
C     (POUR CHAQUE INTSR, STOCKAGE DANS VECTG)
C
C     ET
C
C     CONSTRUCTION DES VECTEURS TA AUX PTS D'INTEGRATION REDUIT (T3=N)
C     (POUR CHAQUE INTSR, STOCKAGE DANS VECTT)
C
C     IND1= 0     0 : CALCULS AUX PTS D'INTEGRATION REDUIT
C
C-----------------------------------------------------------------------
      INTEGER IND1 ,IND2 
C-----------------------------------------------------------------------
      CALL VECTGT(IND1,NB1,XI,KSI3S2,INTSR,XR,EPAIS,VECTN,VECTG,VECTT)
C
C     CONSTRUCTION DE HSM = HFM * S:(3,9) AUX PTS D'INTEGRATION REDUITS
C
C     ET
C
C     CONSTRUCTION DE HSS = HS * S :(2,9) AUX PTS D'INTEGRATION REDUITS
C
C     IND2= 1  --->  CALCUL DE HSS ( 0 SINON )
C
      IND2= 1
C
      CALL HFMSS(IND2,VECTT,HSFM,HSS)
C
      END

      SUBROUTINE DJACBM(EPAIS,VECTG,VECTT,DVECTG,DJM1)
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
      IMPLICIT NONE
      INTEGER NBCOU,ICOU,INTE
      REAL*8 EPAIS,VECTG(2,3),DVECTG(2,3),DJM1(3,3),DETJ2
      REAL*8 MATJ(3,3),DMATJ(3,3),DETJ,T1,T2,T3,DDETJ,VECTT(3,3)
      REAL*8 NUM11,NUM12,NUM13,NUM21,NUM22,NUM23,NUM31,NUM32,NUM33
      COMMON /COUCHE/NBCOU,ICOU,INTE
C
C     CALCUL DE LA DERIVEE DU JACOBIEN DJM1
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      MATJ(1,1)=VECTG(1,1)
      MATJ(1,2)=VECTG(1,2)
      MATJ(1,3)=VECTG(1,3)
C
      MATJ(2,1)=VECTG(2,1)
      MATJ(2,2)=VECTG(2,2)
      MATJ(2,3)=VECTG(2,3)
C
      MATJ(3,1)=VECTT(3,1)*EPAIS/2.D0
      MATJ(3,2)=VECTT(3,2)*EPAIS/2.D0
      MATJ(3,3)=VECTT(3,3)*EPAIS/2.D0
C
      DMATJ(1,1)=DVECTG(1,1)
      DMATJ(1,2)=DVECTG(1,2)
      DMATJ(1,3)=DVECTG(1,3)
C
      DMATJ(2,1)=DVECTG(2,1)
      DMATJ(2,2)=DVECTG(2,2)
      DMATJ(2,3)=DVECTG(2,3)
C
      DMATJ(3,1)=VECTT(3,1)/(2.D0*NBCOU)
      DMATJ(3,2)=VECTT(3,2)/(2.D0*NBCOU)
      DMATJ(3,3)=VECTT(3,3)/(2.D0*NBCOU)
C
C     CONSTRUCTION DE J-1 AUX X PTS D'INTEGRATION
C
C     CALCUL DU DETERMINANT
C
C
      NUM11 =  MATJ(2,2)*MATJ(3,3)-MATJ(2,3)*MATJ(3,2)
      NUM12 =-(MATJ(1,2)*MATJ(3,3)-MATJ(1,3)*MATJ(3,2))
      NUM13 =  MATJ(1,2)*MATJ(2,3)-MATJ(1,3)*MATJ(2,2)
C
      NUM21 =-(MATJ(2,1)*MATJ(3,3)-MATJ(2,3)*MATJ(3,1))
      NUM22 =  MATJ(1,1)*MATJ(3,3)-MATJ(1,3)*MATJ(3,1)
      NUM23 =-(MATJ(1,1)*MATJ(2,3)-MATJ(1,3)*MATJ(2,1))
C
      NUM31 =  MATJ(2,1)*MATJ(3,2)-MATJ(2,2)*MATJ(3,1)
      NUM32 =-(MATJ(1,1)*MATJ(3,2)-MATJ(1,2)*MATJ(3,1))
      NUM33 =  MATJ(1,1)*MATJ(2,2)-MATJ(1,2)*MATJ(2,1)
C
      DETJ= MATJ(1,1)*NUM11 +MATJ(1,2)*NUM21 +MATJ(1,3)*NUM31
C
C      JM1(1,1)= NUM11/DETJ
C      JM1(1,2)= NUM12/DETJ
C      JM1(1,3)= NUM13/DETJ
C
C      JM1(2,1)= NUM21/DETJ
C      JM1(2,2)= NUM22/DETJ
C      JM1(2,3)= NUM23/DETJ
C
C      JM1(3,1)= NUM31/DETJ
C      JM1(3,2)= NUM32/DETJ
C      JM1(3,3)= NUM33/DETJ
C
      T1 = MATJ(2,2)*DMATJ(3,3) + DMATJ(2,2)*MATJ(3,3)
     &    -MATJ(3,2)*DMATJ(2,3) - DMATJ(3,2)*MATJ(2,3)
      T2 =-MATJ(2,1)*DMATJ(3,3) - DMATJ(2,1)*MATJ(3,3)
     &    +MATJ(3,1)*DMATJ(2,3) + DMATJ(3,1)*MATJ(2,3)
      T3 = MATJ(2,1)*DMATJ(3,2) + DMATJ(2,1)*MATJ(3,2)
     &    -MATJ(3,1)*DMATJ(2,2) - DMATJ(3,1)*MATJ(2,2)
C
      DDETJ=  DMATJ(1,1)*NUM11 + MATJ(1,1)*T1
     &       +DMATJ(1,2)*NUM21 + MATJ(1,2)*T2
     &       +DMATJ(1,3)*NUM31 + MATJ(1,3)*T3
      DETJ2 = DETJ*DETJ
C
      DJM1(1,1)= (DETJ*T1-NUM11*DDETJ)/DETJ2
      DJM1(2,1)= (DETJ*T2-NUM21*DDETJ)/DETJ2
      DJM1(3,1)= (DETJ*T3-NUM31*DDETJ)/DETJ2
C
      T1 = MATJ(1,3)*DMATJ(3,2) + DMATJ(1,3)*MATJ(3,2)
     &    -MATJ(1,2)*DMATJ(3,3) - DMATJ(1,2)*MATJ(3,3)
      T2 = MATJ(1,1)*DMATJ(3,3) + DMATJ(1,1)*MATJ(3,3)
     &    -MATJ(3,1)*DMATJ(1,3) - DMATJ(3,1)*MATJ(1,3)
      T3 = MATJ(3,1)*DMATJ(1,2) + DMATJ(3,1)*MATJ(1,2)
     &    -MATJ(1,1)*DMATJ(3,2) - DMATJ(1,1)*MATJ(3,2)
C
      DJM1(1,2)= (DETJ*T1-NUM12*DDETJ)/DETJ2
      DJM1(2,2)= (DETJ*T2-NUM22*DDETJ)/DETJ2
      DJM1(3,2)= (DETJ*T3-NUM32*DDETJ)/DETJ2
C
      T1 = MATJ(2,3)*DMATJ(1,2) + DMATJ(2,3)*MATJ(1,2)
     &    -MATJ(2,2)*DMATJ(1,3) - DMATJ(2,2)*MATJ(1,3)
      T2 = MATJ(2,1)*DMATJ(1,3) + DMATJ(2,1)*MATJ(1,3)
     &    -MATJ(1,1)*DMATJ(2,3) - DMATJ(1,1)*MATJ(2,3)
      T3 = MATJ(1,1)*DMATJ(2,2) + DMATJ(1,1)*MATJ(2,2)
     &    -MATJ(1,2)*DMATJ(2,1) - DMATJ(1,2)*MATJ(2,1)
C
      DJM1(1,3)= (DETJ*T1-NUM13*DDETJ)/DETJ2
      DJM1(2,3)= (DETJ*T2-NUM23*DDETJ)/DETJ2
      DJM1(3,3)= (DETJ*T3-NUM33*DDETJ)/DETJ2
C
      END

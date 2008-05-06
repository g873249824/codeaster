      SUBROUTINE PARGLR(NLIT,ELB,EA,NUA,LINER,OMX,OMY,RX,RY,HH,
     &                  BN11,BN12,BN22,BN33,BM11,BM12,BM22,
     &                  BC11,BC22)
      IMPLICIT   NONE
      INTEGER    NLIT
      REAL*8     ELB(*),EA(*),NUA(*),LINER(*),OMX(*),OMY(*),RX(*),RY(*)
      REAL*8     BN11,BN12,BN22,BN33,BM11,BM12,BM22,BC11,BC22,HH
C.......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 06/05/2008   AUTEUR MARKOVIC D.MARKOVIC 
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
      REAL*8 ESN,EOX,EOY,NEO,EOO,EROX,EROY,NERO,EROO,ER2OX,ER2OY,NER2O
      REAL*8 ER2OO,EB,NUB
      INTEGER II


      EB = ELB(1)
      NUB= ELB(2)
      
      ESN=EB/(1-NUB**2)
      EOX=0.D0
      EOY=0.D0
      NEO=0.D0
      EOO=0.D0
      EROX=0.D0
      EROY=0.D0
      NERO=0.D0
      EROO=0.D0
      ER2OX=0.D0
      ER2OY=0.D0
      NER2O=0.D0
      ER2OO=0.D0
      DO 33, II=1,NLIT
        EOX=EOX+EA(II)*OMX(II)/(1.D0-NUA(II)**2)
        EOY=EOY+EA(II)*OMY(II)/(1.D0-NUA(II)**2)
        NEO=NEO+NUA(II)*EA(II)*(OMX(II)+OMY(II))/2.D0/(1.D0-NUA(II)**2)
        EOO=EOO+LINER(II)*EA(II)
     &   *(OMX(II)+OMY(II))/2.D0/(1.D0+NUA(II))/2.D0
        EROX=EROX+EA(II)*RX(II)*OMX(II)/(1.D0-NUA(II)**2)
        EROY=EROY+EA(II)*RY(II)*OMY(II)/(1.D0-NUA(II)**2)
        NERO=NERO+NUA(II)*EA(II)
     &   *(RX(II)+RY(II))/2.D0 *(OMX(II)+OMY(II))/2.D0/(1.D0-NUA(II)**2)
        EROO=EROO+LINER(II)*EA(II)
     & *(RX(II)+RY(II))/2.D0 *(OMX(II)+OMY(II))/2.D0/(1.D0+NUA(II))/2.D0
        ER2OX=ER2OX+EA(II)*RX(II)**2*OMX(II)/(1.D0-NUA(II)**2)
        ER2OY=ER2OY+EA(II)*RY(II)**2*OMY(II)/(1.D0-NUA(II)**2)
        NER2O=NER2O+NUA(II)*EA(II)
     &   *((RX(II)+RY(II))/2.D0)**2
     &   *(OMX(II)+OMY(II))/2.D0/(1.D0-NUA(II)**2)
        ER2OO=ER2OO+LINER(II)*EA(II)
     &   *((RX(II)+RY(II))/2.D0)**2
     &   *(OMX(II)+OMY(II))/2.D0/(1.D0+NUA(II))/2.D0
 33   CONTINUE
      BN11=    ESN * HH       + EOX
      BN12=NUB*ESN * HH       + NEO
      BN22=    ESN * HH       + EOY
      BN33=EB*HH/(1+NUB)/2.D0 + EOO

C-----ELASTICITE ORTHOTROPE NON ACTIVEE
       BC11=EROX * HH/2.D0
C       BC12=NERO * HH/2.D0
       BC22=EROY * HH/2.D0
C       BC33=EROO * HH/2.D0
       BM11=    ESN * HH**3/12.D0 + ER2OX*HH**2/4.D0
       BM12=NUB*ESN * HH**3/12.D0 + NER2O*HH**2/4.D0
       BM22=    ESN * HH**3/12.D0 + ER2OY*HH**2/4.D0
C       BM33=EB*HH**3/(1+NUB)/24.D0+ ER2OO*HH**2/4.D0
      END

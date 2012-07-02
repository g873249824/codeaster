      SUBROUTINE FORPES(INTSN,NB1,XR,RHO,EPAIS,VPESAN,RNORMC,VECL1)
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
C
      INTEGER INTSN,NB1,INTSX
      REAL*8 WGT,RHO
      REAL*8 XR(*),VPESAN(3),VECL1(42)
C
C-----------------------------------------------------------------------
      INTEGER I ,I1 ,I2 ,L1 
      REAL*8 EPAIS ,RNORMC 
C-----------------------------------------------------------------------
      WGT=XR(127-1+INTSN)
C
      L1=135
      INTSX=8*(INTSN-1)
C
      I1=L1+INTSX
C
      DO 10 I=1,NB1
         I2=5*(I-1)
         VECL1(I2+1)=VECL1(I2+1)+WGT*RHO*EPAIS*VPESAN(1)*XR(I1+I)*RNORMC
         VECL1(I2+2)=VECL1(I2+2)+WGT*RHO*EPAIS*VPESAN(2)*XR(I1+I)*RNORMC
         VECL1(I2+3)=VECL1(I2+3)+WGT*RHO*EPAIS*VPESAN(3)*XR(I1+I)*RNORMC
 10   CONTINUE
      END

      SUBROUTINE DVECT(IND,NB1,INTSX,ZR,VECTN,
     &                  VECTG,VECTT,DVECTG,DVECTT)
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
      INTEGER IND,NB1,INTSX,NBCOU,ICOU,INTE
      REAL*8 ZR(*),VECTN(9,3)
      REAL*8 VECTG(2,3),VECTT(3,3)
      REAL*8 DVECTG(2,3),DVECTT(3,3)
      REAL*8 RNORM,DRNORM
      COMMON /COUCHE/NBCOU,ICOU,INTE
C
C-----------------------------------------------------------------------
      INTEGER I1 ,I2 ,INTSX1 ,J ,K ,L2 ,L3 

      REAL*8 DZICDH 
C-----------------------------------------------------------------------
      DZICDH = (ICOU-1+(INTE-1)/2.D0)/NBCOU
C
      IF  (IND.EQ.0) THEN
C
C     CALCULS AUX PTS D'INTEGRATION REDUITE
C
      L2= 44
      L3= 76
      ELSE IF  (IND.EQ.1) THEN
C
C     CALCULS AUX PTS D'INTEGRATION NORMALE
C
      L2=207
      L3=279
C
      ENDIF
C   
         INTSX1=8*(INTSX-1)
      DO 15 K=1,3   
         DVECTT(3,K)=0.0D0
 15   CONTINUE
C
         I1=L2+INTSX1
         I2=L3+INTSX1
      DO 40 K=1,3
         DVECTG(1,K)=0.D0
         DVECTG(2,K)=0.D0
      DO 50 J=1,NB1
         DVECTG(1,K)= DVECTG(1,K)
     &                     +ZR(I1+J)*DZICDH*VECTN(J,K)
         DVECTG(2,K)= DVECTG(2,K)
     &                     +ZR(I2+J)*DZICDH*VECTN(J,K)
 50   CONTINUE
 40   CONTINUE
C
         RNORM=SQRT(VECTG(1,1)*VECTG(1,1)
     &             +VECTG(1,2)*VECTG(1,2)
     &             +VECTG(1,3)*VECTG(1,3))
C
         DRNORM=(VECTG(1,1)*DVECTG(1,1)+VECTG(1,2)*DVECTG(1,2)+
     &           VECTG(1,3)*DVECTG(1,3))/RNORM
C
      DO 60 K=1,3
         DVECTT(1,K)=(DVECTG(1,K)*RNORM-VECTG(1,K)*DRNORM)
     &               /(RNORM*RNORM)
 60   CONTINUE
C
         DVECTT(2,1)= VECTT(3,2)*DVECTT(1,3)-VECTT(3,3)*DVECTT(1,2)
         DVECTT(2,2)= VECTT(3,3)*DVECTT(1,1)-VECTT(3,1)*DVECTT(1,3)
         DVECTT(2,3)= VECTT(3,1)*DVECTT(1,2)-VECTT(3,2)*DVECTT(1,1)
C
      END

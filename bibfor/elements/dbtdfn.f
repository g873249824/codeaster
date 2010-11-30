      SUBROUTINE DBTDFN(IND,NB1,NB2,KSI3S2,INTSN,XR,HIC,VECTPT,
     &                  HSJ1FX,DHSJ1F,BTDF,DBTDF)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 17/12/2007   AUTEUR DESROCHES X.DESROCHES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER NB1,NB2,INTE,INTSN
      REAL*8 XR(*),VECTPT(9,2,3),DZICDH,KSI3S2,HIC
      REAL*8 HSJ1FX(3,9),DHSJ1F(3,9),DBTDF(3,42),BTDF(3,42)
      REAL*8 DDNSDS(9,42),DNSDSF(9,42),R8PREM
      COMMON /COUCHE/NBCOU,ICOU,INTE
      COMMON /DNSF/DNSDSF
C
      DZICDH = (ICOU-1+(INTE-1)/2.D0)/NBCOU
C      IF (KSI3S2.LT.R8PREM()) THEN
C         COEF=0.D0
C      ELSE
C         COEF=DZICDH/(KSI3S2*HIC)
C      ENDIF
C
      IF (IND.EQ.1) THEN
         L1=459
         L2=540
         L3=621
      ELSE IF (IND.EQ.0) THEN
         L1=351
         L2=387
         L3=423
      ENDIF
C
      DO 15 I=1,9
      DO 16 J=1,5*NB1+2
         DDNSDS(I,J)=0.D0
         IF (I.LE.3) DBTDF(I,J)=0.D0
 16   CONTINUE
 15   CONTINUE
C
         INTSN1=9*(INTSN-1)
C
C                         DN   
C     CONSTRUCTION DE   ------    AUX PTS DE GAUSS NORMAL
C                        DQSI  F
C
         I3=L1+INTSN1
         I4=L2+INTSN1
         I5=L3+INTSN1
      DO 30 J=1,NB1
         J1=5*(J-1)
         DDNSDS(1,J1+4)=-XR(I4+J)*DZICDH*VECTPT(J,2,1)
         DDNSDS(1,J1+5)= XR(I4+J)*DZICDH*VECTPT(J,1,1)
C
         DDNSDS(2,J1+4)=-XR(I5+J)*DZICDH*VECTPT(J,2,1)
         DDNSDS(2,J1+5)= XR(I5+J)*DZICDH*VECTPT(J,1,1)
C
         DDNSDS(3,J1+4)=-XR(I3+J)/2*VECTPT(J,2,1)/NBCOU
         DDNSDS(3,J1+5)= XR(I3+J)/2*VECTPT(J,1,1)/NBCOU
C
         DDNSDS(4,J1+4)=-XR(I4+J)*DZICDH*VECTPT(J,2,2)
         DDNSDS(4,J1+5)= XR(I4+J)*DZICDH*VECTPT(J,1,2)
C
         DDNSDS(5,J1+4)=-XR(I5+J)*DZICDH*VECTPT(J,2,2)
         DDNSDS(5,J1+5)= XR(I5+J)*DZICDH*VECTPT(J,1,2)
C
         DDNSDS(6,J1+4)=-XR(I3+J)/2*VECTPT(J,2,2)/NBCOU
         DDNSDS(6,J1+5)= XR(I3+J)/2*VECTPT(J,1,2)/NBCOU
C
         DDNSDS(7,J1+4)=-XR(I4+J)*DZICDH*VECTPT(J,2,3)
         DDNSDS(7,J1+5)= XR(I4+J)*DZICDH*VECTPT(J,1,3)
C
         DDNSDS(8,J1+4)=-XR(I5+J)*DZICDH*VECTPT(J,2,3)
         DDNSDS(8,J1+5)= XR(I5+J)*DZICDH*VECTPT(J,1,3)
C
         DDNSDS(9,J1+4)=-XR(I3+J)/2*VECTPT(J,2,3)/NBCOU
         DDNSDS(9,J1+5)= XR(I3+J)/2*VECTPT(J,1,3)/NBCOU
 30   CONTINUE
C
         DDNSDS(1,5*NB1+1)=-XR(I4+NB2)*DZICDH*VECTPT(NB2,2,1)
         DDNSDS(1,5*NB1+2)= XR(I4+NB2)*DZICDH*VECTPT(NB2,1,1)
C
         DDNSDS(2,5*NB1+1)=-XR(I5+NB2)*DZICDH*VECTPT(NB2,2,1)
         DDNSDS(2,5*NB1+2)= XR(I5+NB2)*DZICDH*VECTPT(NB2,1,1)
C
         DDNSDS(3,5*NB1+1)=-XR(I3+NB2)/2*VECTPT(NB2,2,1)/NBCOU
         DDNSDS(3,5*NB1+2)= XR(I3+NB2)/2*VECTPT(NB2,1,1)/NBCOU
C
         DDNSDS(4,5*NB1+1)=-XR(I4+NB2)*DZICDH*VECTPT(NB2,2,2)
         DDNSDS(4,5*NB1+2)= XR(I4+NB2)*DZICDH*VECTPT(NB2,1,2)
C
         DDNSDS(5,5*NB1+1)=-XR(I5+NB2)*DZICDH*VECTPT(NB2,2,2)
         DDNSDS(5,5*NB1+2)= XR(I5+NB2)*DZICDH*VECTPT(NB2,1,2)
C
         DDNSDS(6,5*NB1+1)=-XR(I3+NB2)/2*VECTPT(NB2,2,2)/NBCOU
         DDNSDS(6,5*NB1+2)= XR(I3+NB2)/2*VECTPT(NB2,1,2)/NBCOU
C
         DDNSDS(7,5*NB1+1)=-XR(I4+NB2)*DZICDH*VECTPT(NB2,2,3)
         DDNSDS(7,5*NB1+2)= XR(I4+NB2)*DZICDH*VECTPT(NB2,1,3)
C
         DDNSDS(8,5*NB1+1)=-XR(I5+NB2)*DZICDH*VECTPT(NB2,2,3)
         DDNSDS(8,5*NB1+2)= XR(I5+NB2)*DZICDH*VECTPT(NB2,1,3)
C
         DDNSDS(9,5*NB1+1)=-XR(I3+NB2)/2*VECTPT(NB2,2,3)/NBCOU
         DDNSDS(9,5*NB1+2)= XR(I3+NB2)/2*VECTPT(NB2,1,3)/NBCOU
C
C     CONSTRUCTION DE BTILDF = HFM * S * JTILD-1 * DNSDSF  : (3,5*NB1+2)
C
      DO 40  I=1,3
      DO 50 JB=1,NB1
      DO 60  J=4,5
         J1=J+5*(JB-1)
         DBTDF(I,J1)=0.D0
      DO 70  K=1,9
         DBTDF(I,J1)=DBTDF(I,J1)+HSJ1FX(I,K)*DDNSDS(K,J1)
     &                          +DHSJ1F(I,K)*DNSDSF(K,J1)
     &                          +BTDF(I,J1)/(HIC*NBCOU)
 70   CONTINUE
 60   CONTINUE
 50   CONTINUE
C
      DO 80  J=1,2
         J1=J+5*NB1
         DBTDF(I,J1)=0.D0
      DO 90  K=1,9
         DBTDF(I,J1)=DBTDF(I,J1)+HSJ1FX(I,K)*DDNSDS(K,J1)
     &                          +DHSJ1F(I,K)*DNSDSF(K,J1)
     &                          +BTDF(I,J1)/(HIC*NBCOU)
 90   CONTINUE
 80   CONTINUE
 40   CONTINUE
C
      END

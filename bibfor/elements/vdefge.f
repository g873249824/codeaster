      SUBROUTINE VDEFGE(NOMTE,OPTION,NB1,NPGSR,XR,EPAIS,SIGMA,EFFGT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/06/2004   AUTEUR CIBHHPD S.VANDENBERGHE 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
      CHARACTER*16 NOMTE,OPTION
      REAL*8 EPAIS
      REAL*8 XR(*),SIGMA(6,*),EFFGT(8,*),EFFGTG(8,8)
C
C     DANS LE CAS DE EFGE_ELNO, ON CALCULE AUX NB1 NOEUDS
C     ON NE CALCULE PAS AU NOEUD INTERNE
C
      DO 5 I=1,NB1
      DO 6 J=1,8
         EFFGT(J,I)=0.D0
 6    CONTINUE
 5    CONTINUE
C
      L1 =1452
C
      DEMIEP=EPAIS/2.D0
C
      WNC1 = 0.33333333333333D0
      WNC2 = 1.33333333333333D0
      WNC3 = 0.33333333333333D0
      ZIC = -EPAIS/2.D0
C
      ZIC1 = ZIC
      ZIC2 = ZIC1 + DEMIEP
      ZIC3 = ZIC2 + DEMIEP
C
      IF (NOMTE(1:8).EQ.'MEC3QU9H') THEN
         EFFGTG(1,1)=DEMIEP*(WNC1*SIGMA(1,1)+WNC2*SIGMA(1,5)
     &                                      +WNC3*SIGMA(1,9)) 
         EFFGTG(1,2)=DEMIEP*(WNC1*SIGMA(1,2)+WNC2*SIGMA(1,6)
     &                                      +WNC3*SIGMA(1,10))
         EFFGTG(1,3)=DEMIEP*(WNC1*SIGMA(1,3)+WNC2*SIGMA(1,7)
     &                                      +WNC3*SIGMA(1,11))
         EFFGTG(1,4)=DEMIEP*(WNC1*SIGMA(1,4)+WNC2*SIGMA(1,8)
     &                                      +WNC3*SIGMA(1,12))
C
         EFFGTG(2,1)=DEMIEP*(WNC1*SIGMA(2,1)+WNC2*SIGMA(2,5)
     &                                      +WNC3*SIGMA(2,9)) 
         EFFGTG(2,2)=DEMIEP*(WNC1*SIGMA(2,2)+WNC2*SIGMA(2,6)
     &                                      +WNC3*SIGMA(2,10))
         EFFGTG(2,3)=DEMIEP*(WNC1*SIGMA(2,3)+WNC2*SIGMA(2,7)
     &                                      +WNC3*SIGMA(2,11))
         EFFGTG(2,4)=DEMIEP*(WNC1*SIGMA(2,4)+WNC2*SIGMA(2,8)
     &                                      +WNC3*SIGMA(2,12))
C
         EFFGTG(3,1)=DEMIEP*(WNC1*SIGMA(4,1)+WNC2*SIGMA(4,5)
     &                                      +WNC3*SIGMA(4,9)) 
         EFFGTG(3,2)=DEMIEP*(WNC1*SIGMA(4,2)+WNC2*SIGMA(4,6)
     &                                      +WNC3*SIGMA(4,10))
         EFFGTG(3,3)=DEMIEP*(WNC1*SIGMA(4,3)+WNC2*SIGMA(4,7)
     &                                      +WNC3*SIGMA(4,11))
         EFFGTG(3,4)=DEMIEP*(WNC1*SIGMA(4,4)+WNC2*SIGMA(4,8)
     &                                      +WNC3*SIGMA(4,12))
C
         EFFGTG(4,1)=DEMIEP*(WNC1*ZIC1*SIGMA(1,1)
     &                      +WNC2*ZIC2*SIGMA(1,5)
     &                      +WNC3*ZIC3*SIGMA(1,9))
         EFFGTG(4,2)=DEMIEP*(WNC1*ZIC1*SIGMA(1,2)
     &                      +WNC2*ZIC2*SIGMA(1,6)
     &                      +WNC3*ZIC3*SIGMA(1,10))
         EFFGTG(4,3)=DEMIEP*(WNC1*ZIC1*SIGMA(1,3)
     &                      +WNC2*ZIC2*SIGMA(1,7)
     &                      +WNC3*ZIC3*SIGMA(1,11))
         EFFGTG(4,4)=DEMIEP*(WNC1*ZIC1*SIGMA(1,4)
     &                      +WNC2*ZIC2*SIGMA(1,8)
     &                      +WNC3*ZIC3*SIGMA(1,12))
C
         EFFGTG(5,1)=DEMIEP*(WNC1*ZIC1*SIGMA(2,1)
     &                      +WNC2*ZIC2*SIGMA(2,5)
     &                      +WNC3*ZIC3*SIGMA(2,9))
         EFFGTG(5,2)=DEMIEP*(WNC1*ZIC1*SIGMA(2,2)
     &                      +WNC2*ZIC2*SIGMA(2,6)
     &                      +WNC3*ZIC3*SIGMA(2,10))
         EFFGTG(5,3)=DEMIEP*(WNC1*ZIC1*SIGMA(2,3)
     &                      +WNC2*ZIC2*SIGMA(2,7)
     &                      +WNC3*ZIC3*SIGMA(2,11))
         EFFGTG(5,4)=DEMIEP*(WNC1*ZIC1*SIGMA(2,4)
     &                      +WNC2*ZIC2*SIGMA(2,8)
     &                      +WNC3*ZIC3*SIGMA(2,12))
C
         EFFGTG(6,1)=DEMIEP*(WNC1*ZIC1*SIGMA(4,1)
     &                      +WNC2*ZIC2*SIGMA(4,5)
     &                      +WNC3*ZIC3*SIGMA(4,9))
         EFFGTG(6,2)=DEMIEP*(WNC1*ZIC1*SIGMA(4,2)
     &                      +WNC2*ZIC2*SIGMA(4,6)
     &                      +WNC3*ZIC3*SIGMA(4,10))
         EFFGTG(6,3)=DEMIEP*(WNC1*ZIC1*SIGMA(4,3)
     &                      +WNC2*ZIC2*SIGMA(4,7)
     &                      +WNC3*ZIC3*SIGMA(4,11))
         EFFGTG(6,4)=DEMIEP*(WNC1*ZIC1*SIGMA(4,4)
     &                      +WNC2*ZIC2*SIGMA(4,8)
     &                      +WNC3*ZIC3*SIGMA(4,12))
C
         EFFGTG(7,1)=DEMIEP*(WNC1*SIGMA(5,1)+WNC2*SIGMA(5,5)
     &                                      +WNC3*SIGMA(5,9)) 
         EFFGTG(7,2)=DEMIEP*(WNC1*SIGMA(5,2)+WNC2*SIGMA(5,6)
     &                                      +WNC3*SIGMA(5,10))
         EFFGTG(7,3)=DEMIEP*(WNC1*SIGMA(5,3)+WNC2*SIGMA(5,7)
     &                                      +WNC3*SIGMA(5,11))
         EFFGTG(7,4)=DEMIEP*(WNC1*SIGMA(5,4)+WNC2*SIGMA(5,8)
     &                                      +WNC3*SIGMA(5,12))
C
         EFFGTG(8,1)=DEMIEP*(WNC1*SIGMA(6,1)+WNC2*SIGMA(6,5)
     &                                      +WNC3*SIGMA(6,9)) 
         EFFGTG(8,2)=DEMIEP*(WNC1*SIGMA(6,2)+WNC2*SIGMA(6,6)
     &                                      +WNC3*SIGMA(6,10))
         EFFGTG(8,3)=DEMIEP*(WNC1*SIGMA(6,3)+WNC2*SIGMA(6,7)
     &                                      +WNC3*SIGMA(6,11))
         EFFGTG(8,4)=DEMIEP*(WNC1*SIGMA(6,4)+WNC2*SIGMA(6,8)
     &                                      +WNC3*SIGMA(6,12))
C
         DO 15 I=1,NB1
            I1=L1+4*(I-1)
         DO 20 K=1,NPGSR
         EFFGT(1,I)=EFFGT(1,I)+EFFGTG(1,K)*XR(I1+K)
         EFFGT(2,I)=EFFGT(2,I)+EFFGTG(2,K)*XR(I1+K)
         EFFGT(3,I)=EFFGT(3,I)+EFFGTG(3,K)*XR(I1+K)
         EFFGT(4,I)=EFFGT(4,I)+EFFGTG(4,K)*XR(I1+K)
         EFFGT(5,I)=EFFGT(5,I)+EFFGTG(5,K)*XR(I1+K)
         EFFGT(6,I)=EFFGT(6,I)+EFFGTG(6,K)*XR(I1+K)
         EFFGT(7,I)=EFFGT(7,I)+EFFGTG(7,K)*XR(I1+K)
         EFFGT(8,I)=EFFGT(8,I)+EFFGTG(8,K)*XR(I1+K)
C
 20      CONTINUE
 15      CONTINUE
C
C     VALEURS AU NOEUD INTERNE OBTENUE PAR MOYENNE DES AUTRES
C
         EFFGT(1,9)=(EFFGT(1,5)+EFFGT(1,6)+EFFGT(1,7)+EFFGT(1,8))/4.D0
         EFFGT(2,9)=(EFFGT(2,5)+EFFGT(2,6)+EFFGT(2,7)+EFFGT(2,8))/4.D0
         EFFGT(3,9)=(EFFGT(3,5)+EFFGT(3,6)+EFFGT(3,7)+EFFGT(3,8))/4.D0
         EFFGT(4,9)=(EFFGT(4,5)+EFFGT(4,6)+EFFGT(4,7)+EFFGT(4,8))/4.D0
         EFFGT(5,9)=(EFFGT(5,5)+EFFGT(5,6)+EFFGT(5,7)+EFFGT(5,8))/4.D0
         EFFGT(6,9)=(EFFGT(6,5)+EFFGT(6,6)+EFFGT(6,7)+EFFGT(6,8))/4.D0
         EFFGT(7,9)=(EFFGT(7,5)+EFFGT(7,6)+EFFGT(7,7)+EFFGT(7,8))/4.D0
         EFFGT(8,9)=(EFFGT(8,5)+EFFGT(8,6)+EFFGT(8,7)+EFFGT(8,8))/4.D0
C
      ELSE IF (NOMTE(1:8).EQ.'MEC3TR7H') THEN
C
         EFFGTG(1,1)=DEMIEP*(WNC1*SIGMA(1,1)+WNC2*SIGMA(1,4)
     &                                      +WNC3*SIGMA(1,7)) 
         EFFGTG(1,2)=DEMIEP*(WNC1*SIGMA(1,2)+WNC2*SIGMA(1,5)
     &                                      +WNC3*SIGMA(1,8))
         EFFGTG(1,3)=DEMIEP*(WNC1*SIGMA(1,3)+WNC2*SIGMA(1,6)
     &                                      +WNC3*SIGMA(1,9))
C
         EFFGTG(2,1)=DEMIEP*(WNC1*SIGMA(2,1)+WNC2*SIGMA(2,4)
     &                                      +WNC3*SIGMA(2,7)) 
         EFFGTG(2,2)=DEMIEP*(WNC1*SIGMA(2,2)+WNC2*SIGMA(2,5)
     &                                      +WNC3*SIGMA(2,8))
         EFFGTG(2,3)=DEMIEP*(WNC1*SIGMA(2,3)+WNC2*SIGMA(2,6)
     &                                      +WNC3*SIGMA(2,9))
C
         EFFGTG(3,1)=DEMIEP*(WNC1*SIGMA(4,1)+WNC2*SIGMA(4,4)
     &                                      +WNC3*SIGMA(4,7)) 
         EFFGTG(3,2)=DEMIEP*(WNC1*SIGMA(4,2)+WNC2*SIGMA(4,5)
     &                                      +WNC3*SIGMA(4,8))
         EFFGTG(3,3)=DEMIEP*(WNC1*SIGMA(4,3)+WNC2*SIGMA(4,6)
     &                                      +WNC3*SIGMA(4,9))
C
         EFFGTG(4,1)=DEMIEP*(WNC1*ZIC1*SIGMA(1,1)
     &                      +WNC2*ZIC2*SIGMA(1,4)
     &                      +WNC3*ZIC3*SIGMA(1,7))
         EFFGTG(4,2)=DEMIEP*(WNC1*ZIC1*SIGMA(1,2)
     &                      +WNC2*ZIC2*SIGMA(1,5)
     &                      +WNC3*ZIC3*SIGMA(1,8))
         EFFGTG(4,3)=DEMIEP*(WNC1*ZIC1*SIGMA(1,3)
     &                      +WNC2*ZIC2*SIGMA(1,6)
     &                      +WNC3*ZIC3*SIGMA(1,9))
C
         EFFGTG(5,1)=DEMIEP*(WNC1*ZIC1*SIGMA(2,1)
     &                      +WNC2*ZIC2*SIGMA(2,4)
     &                      +WNC3*ZIC3*SIGMA(2,7))
         EFFGTG(5,2)=DEMIEP*(WNC1*ZIC1*SIGMA(2,2)
     &                      +WNC2*ZIC2*SIGMA(2,5)
     &                      +WNC3*ZIC3*SIGMA(2,8))
         EFFGTG(5,3)=DEMIEP*(WNC1*ZIC1*SIGMA(2,3)
     &                      +WNC2*ZIC2*SIGMA(2,6)
     &                      +WNC3*ZIC3*SIGMA(2,9))
C
         EFFGTG(6,1)=DEMIEP*(WNC1*ZIC1*SIGMA(4,1)
     &                      +WNC2*ZIC2*SIGMA(4,4)
     &                      +WNC3*ZIC3*SIGMA(4,7))
         EFFGTG(6,2)=DEMIEP*(WNC1*ZIC1*SIGMA(4,2)
     &                      +WNC2*ZIC2*SIGMA(4,5)
     &                      +WNC3*ZIC3*SIGMA(4,8))
         EFFGTG(6,3)=DEMIEP*(WNC1*ZIC1*SIGMA(4,3)
     &                       +WNC2*ZIC2*SIGMA(4,6)
     &                      +WNC3*ZIC3*SIGMA(4,9))
C
         EFFGTG(7,1)=DEMIEP*(WNC1*SIGMA(5,1)+WNC2*SIGMA(5,4)
     &                                      +WNC3*SIGMA(5,7)) 
         EFFGTG(7,2)=DEMIEP*(WNC1*SIGMA(5,2)+WNC2*SIGMA(5,5)
     &                                      +WNC3*SIGMA(5,8))
         EFFGTG(7,3)=DEMIEP*(WNC1*SIGMA(5,3)+WNC2*SIGMA(5,6)
     &                                      +WNC3*SIGMA(5,9))
C
         EFFGTG(8,1)=DEMIEP*(WNC1*SIGMA(6,1)+WNC2*SIGMA(6,4)
     &                                      +WNC3*SIGMA(6,7)) 
         EFFGTG(8,2)=DEMIEP*(WNC1*SIGMA(6,2)+WNC2*SIGMA(6,5)
     &                                      +WNC3*SIGMA(6,8))
         EFFGTG(8,3)=DEMIEP*(WNC1*SIGMA(6,3)+WNC2*SIGMA(6,6)
     &                                      +WNC3*SIGMA(6,9))
C
         DO 35 I=1,NB1
            I1=L1+4*(I-1)
         DO 40 K=1,NPGSR
         EFFGT(1,I)=EFFGT(1,I)+EFFGTG(1,K)*XR(I1+K)
         EFFGT(2,I)=EFFGT(2,I)+EFFGTG(2,K)*XR(I1+K)
         EFFGT(3,I)=EFFGT(3,I)+EFFGTG(3,K)*XR(I1+K)
         EFFGT(4,I)=EFFGT(4,I)+EFFGTG(4,K)*XR(I1+K)
         EFFGT(5,I)=EFFGT(5,I)+EFFGTG(5,K)*XR(I1+K)
         EFFGT(6,I)=EFFGT(6,I)+EFFGTG(6,K)*XR(I1+K)
         EFFGT(7,I)=EFFGT(7,I)+EFFGTG(7,K)*XR(I1+K)
         EFFGT(8,I)=EFFGT(8,I)+EFFGTG(8,K)*XR(I1+K)
C
 40      CONTINUE
 35      CONTINUE
C
C     VALEURS AU NOEUD INTERNE OBTENUE PAR MOYENNE DES AUTRES
C
         EFFGT(1,7)=(EFFGT(1,1)+EFFGT(1,2)+EFFGT(1,3))/3.D0
         EFFGT(2,7)=(EFFGT(2,1)+EFFGT(2,2)+EFFGT(2,3))/3.D0
         EFFGT(3,7)=(EFFGT(3,1)+EFFGT(3,2)+EFFGT(3,3))/3.D0
         EFFGT(4,7)=(EFFGT(4,1)+EFFGT(4,2)+EFFGT(4,3))/3.D0
         EFFGT(5,7)=(EFFGT(5,1)+EFFGT(5,2)+EFFGT(5,3))/3.D0
         EFFGT(6,7)=(EFFGT(6,1)+EFFGT(6,2)+EFFGT(6,3))/3.D0
         EFFGT(7,7)=(EFFGT(7,1)+EFFGT(7,2)+EFFGT(7,3))/3.D0
         EFFGT(8,7)=(EFFGT(8,1)+EFFGT(8,2)+EFFGT(8,3))/3.D0
C
      ENDIF
C
      END

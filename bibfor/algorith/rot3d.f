      SUBROUTINE ROT3D( X,SINA,COSA,SINB,COSB,SING,COSG,Y )
      IMPLICIT REAL*8(A-H),REAL*8(O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/11/96   AUTEUR VABHHTS J.PELLET 
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
C  CODE 1083
C GENERATION D'UNE MATRICE DE ROTATION(3 AXES) ANGLES DONNES EN RADIANS
      REAL*8    RX(3,3),RY(3,3),RZ(3,3),RZYX(3,3),P(3),X(*),Y(*)
      RZ(1,1)=1.D0
      RY(2,2)=      RZ(1,1)
      RX(3,3)=      RY(2,2)
      RX(1,1)= COSA
      RX(1,2)= SINA
      RX(2,1)=-SINA
      RX(2,2)= COSA
      RX(3,2)=0.D0
      RX(3,1)=      RX(3,2)
      RX(2,3)=      RX(3,1)
      RX(1,3)=      RX(2,3)
      RY(1,1)= COSB
      RY(1,3)=-SINB
      RY(3,1)= SINB
      RY(3,3)= COSB
      RY(3,2)=0.D0
      RY(2,3)=      RY(3,2)
      RY(2,1)=      RY(2,3)
      RY(1,2)=      RY(2,1)
      RZ(2,2)= COSG
      RZ(2,3)= SING
      RZ(3,2)=-SING
      RZ(3,3)= COSG
      RZ(3,1)=0.D0
      RZ(2,1)=      RZ(3,1)
      RZ(1,3)=      RZ(2,1)
      RZ(1,2)=      RZ(1,3)
      DO 10 L=1,3
        DO 10 K=1,3
          IF( ABS(RX(K,L)).LT.1.D-6) RX(K,L)=0.D0
          IF( ABS(RY(K,L)).LT.1.D-6) RY(K,L)=0.D0
          IF( ABS(RZ(K,L)).LT.1.D-6) RZ(K,L)=0.D0
   10 CONTINUE
      DO 20 J=1,3
        DO 20 I=1,3
          RZYX(I,J)=0.D0
          DO 20 K=1,3
            P(K)=0.D0
            DO 15 L=1,3
            P(K)=P(K)+RZ(I,L)*RY(L,K)
   15       CONTINUE
            RZYX(I,J)=RZYX(I,J)+P(K)*RX(K,J)
   20 CONTINUE
      CALL PMAVEC('ZERO',3,RZYX,X,Y)
 9999 CONTINUE
      END

      SUBROUTINE MAMAGI ( NOMTE, XR, YR )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 25/07/2001   AUTEUR RATEAU G.RATEAU 
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
      CHARACTER*8 NOMTE
      REAL*8 XR(*),YR(*)
      REAL *8            PSI3(3),BT(12,27),BTB(12,12)
      REAL *8            ATILD(3),BTILD(3),CTILD(3),ZERO
      REAL *8            COEFA(4),COEFB(4),COEFC(4),COEFD(4)
      LOGICAL            FAUX
C
      ZERO = 0.D0
      FAUX = .FALSE.
      NPGE = 3
C
C--- ON PREND LES 3 POINTS D'INTEGRATION DANS L'EPAISSEUR. METHODE DE
C--- NEWTON-COTES
C
      PSI3(1)=-1.D0
      PSI3(2)= 0.D0
      PSI3(3)= 1.D0
C
C-- COEFFICIENTS DES POLYNOMES D'ORDRE 2 D'INTERPOLATION DU TYPE
C     AXI3*XI3 + B*XI3 + C
C
      ATILD(1)= 0.5D0
      BTILD(1)=-0.5D0
      CTILD(1)= 0.D0
C
      ATILD(2)=-1.D0
      BTILD(2)= 0.D0
      CTILD(2)= 1.D0
C
      ATILD(3)= 0.5D0
      BTILD(3)= 0.5D0
      CTILD(3)= 0.D0
C
C     LES 4 OU 3 FONCTIONS LINEAIRES AUX NOEUDS SOMMETS SONT DU TYPE 
C     A + B*XI1 + C*XI2 + D*XI1*XI2
C
      IF ( NOMTE(1:8) .EQ. 'MEC3QU9H' .OR.
     +     NOMTE(1:8) .EQ. 'MEGRC3Q9' ) THEN
C
      NSO  =4
      NPGSN=9
C
      COEFA(1)= 0.25D0
      COEFB(1)=-0.25D0
      COEFC(1)= 0.25D0
      COEFD(1)=-0.25D0
C
      COEFA(2)= 0.25D0
      COEFB(2)=-0.25D0
      COEFC(2)=-0.25D0
      COEFD(2)= 0.25D0
C
      COEFA(3)= 0.25D0
      COEFB(3)= 0.25D0
      COEFC(3)=-0.25D0
      COEFD(3)=-0.25D0
C
      COEFA(4)= 0.25D0
      COEFB(4)= 0.25D0
      COEFC(4)= 0.25D0
      COEFD(4)= 0.25D0
C
      ELSEIF ( NOMTE(1:8) .EQ. 'MEC3TR7H' .OR.
     +         NOMTE(1:8) .EQ. 'MEGRC3T7' ) THEN
C
      NSO  =3
      NPGSN=7
C
      COEFA(1)= 0.D0
      COEFB(1)= 0.D0
      COEFC(1)= 1.D0
      COEFD(1)= 0.D0
C
      COEFA(2)= 1.D0
      COEFB(2)=-1.D0
      COEFC(2)=-1.D0
      COEFD(2)= 0.D0
C
      COEFA(3)= 0.D0
      COEFB(3)= 1.D0
      COEFC(3)= 0.D0
      COEFD(3)= 0.D0
C
      ENDIF
C
C     CREATION DE LA MATRICE BT(NPGE*NSO,NPGE*NPGSN)
C
         IG=0
      DO 350 INTEG=1,NPGE
         XI3=PSI3(INTEG)
      DO 360 INTSN=1,NPGSN
         I1=108+INTSN
         I2=108+9+INTSN
         XI1=XR(I1)
         XI2=XR(I2)
         IG=IG+1
      DO 370 INTEF=1,NPGE
      DO 380  IFON=1,NSO
         JF=NSO*(INTEF-1)+IFON
         BIJ= (ATILD(INTEF)*XI3**2+BTILD(INTEF)*XI3+CTILD(INTEF))*
     &        (COEFA(IFON)+COEFB(IFON)*XI1+COEFC(IFON)*XI2
     &        +COEFD(IFON)*XI1*XI2)
         BT(JF,IG)=BIJ
 380  CONTINUE
 370  CONTINUE
 360  CONTINUE
 350  CONTINUE
C
      DO 385 I=1,NPGE*NSO
      DO 390 J=1,NPGE*NSO
         BTB(I,J)=0.D0
      DO 400 K=1,NPGE*NPGSN
         BTB(I,J)=BTB(I,J)+BT(I,K)*BT(J,K)
 400  CONTINUE
 390  CONTINUE
 385  CONTINUE
C
C     MATRICE DE PASSAGE = (BT*B*B)-1*BT
C
      CALL MGAUSS(BTB,BT,12,NPGE*NSO,NPGE*NPGSN,ZERO,FAUX)
C
      DO 410 I=1,NPGE*NSO
         L = NPGE*NPGSN*(I-1)
      DO 420 KP=1,NPGE*NPGSN
         YR(L+KP) = BT(I,KP)
 420  CONTINUE
 410  CONTINUE
C
      END

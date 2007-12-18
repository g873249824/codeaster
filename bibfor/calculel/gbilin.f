      SUBROUTINE GBILIN(FAMI,KP,IMATE,DUDM,DVDM,DTDM,DFDM,TGDM,POIDS,
     &            C1,C2,C3,CS,TH,COEF,RHO,PULS,AXI,G)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 17/12/2007   AUTEUR GALENNE E.GALENNE 
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
C
      CHARACTER*(*)  FAMI
      INTEGER KP,IMATE
      REAL*8 DUDM(3,4),DVDM(3,4),DTDM(3,4),DFDM(3,4),TGDM(2)
      REAL*8 C1,C2,C3,CS,TH,POIDS,G, BIL(3,3,3,3),COEF
      LOGICAL AXI
C
C ----------------------------------------------------------------------
C     CALCUL DU TAUX DE RESTITUTION D'ENERGIE G SOUS LA FORME
C     BILINEAIRE SYMETRIQUE G(U,V) EN ELATICITE LINEAIRE EN 2D
C     (DEFORMATIONS OU CONTRAINTES PLANES)
C ----------------------------------------------------------------------
C
      INTEGER I,J,K,P,L,M,IRET
C
      CHARACTER*2 CODRET(3)
      CHARACTER*8 NOMRES(3)
      REAL*8      VALRES(3)
      REAL*8  VECT(7),S11,S12,S13,S21,S22,S23,S1,S2,PULS,RHO
      REAL*8  TCLA,TFOR,TTHE,TDYN,DIVT,DIVV,S1TH,S2TH,PROD,EPSTHE
      REAL*8  E,NU,ALPHA
C
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16   ZC
      LOGICAL      ZL
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C
C DEB-------------------------------------------------------------------
C
      
      NOMRES(1) = 'E'
      NOMRES(2) = 'NU'
      NOMRES(3) = 'ALPHA'
      
      CALL VERIFT(FAMI,KP,1,'+',IMATE,'ELAS',1,EPSTHE,IRET)
      CALL RCVALB(FAMI,KP,1,'+',IMATE,' ','ELAS',0,' ',0.D0,
     &      2,NOMRES(1),VALRES(1),CODRET(1),'FM')
      CALL RCVALB(FAMI,KP,1,'+',IMATE,' ','ELAS',0,' ',0.D0,
     &      1,NOMRES(3),VALRES(3),CODRET(3),' ')
      E = VALRES(1)
      NU = VALRES(2)
      ALPHA = VALRES(3)
      DIVT = DTDM(1,1)+DTDM(2,2)
      IF (AXI) DIVT = DIVT+DTDM(3,3)
      DIVV = TH*(DVDM(1,1)+DVDM(2,2))
      IF (AXI) DIVV = DIVV+DVDM(3,3)
C
C - TERME CLASSIQUE
C
      IF (.NOT. AXI) THEN
        VECT(1)= 0.5D0*(DVDM(1,1)*DUDM(2,2)+DUDM(1,1)*DVDM(2,2))
        VECT(2)= 0.5D0*(DVDM(1,1)*DUDM(1,2)+DUDM(1,1)*DVDM(1,2))
        VECT(3)= 0.5D0*(DVDM(1,1)*DUDM(2,1)+DUDM(1,1)*DVDM(2,1))
        VECT(4)= 0.5D0*(DVDM(2,2)*DUDM(1,2)+DUDM(2,2)*DVDM(1,2))
        VECT(5)= 0.5D0*(DVDM(2,2)*DUDM(2,1)+DUDM(2,2)*DVDM(2,1))
        VECT(6)= 0.5D0*(DVDM(1,2)*DUDM(2,1)+DUDM(1,2)*DVDM(2,1))
C
        S11 =  DUDM(1,1)*DVDM(1,1) + DUDM(2,2)*DVDM(2,2)
        S12 =  DUDM(1,1)*DVDM(2,2) + DUDM(2,2)*DVDM(1,1)
        S13 = (DUDM(1,2)+DUDM(2,1))*(DVDM(1,2)+DVDM(2,1))
C
        S21 =  DUDM(1,1)*DVDM(1,1)*DTDM(1,1)
     &     + DUDM(2,2)*DVDM(2,2)*DTDM(2,2)
     &     + VECT(5)*DTDM(1,2)
     &     + VECT(2)*DTDM(2,1)
C
        S22 = VECT(1)*(DTDM(1,1)+DTDM(2,2))
     &     +VECT(3)* DTDM(1,2)
     &     +VECT(4)* DTDM(2,1)
  
        S23 = (VECT(6)+DUDM(2,1)*DVDM(2,1))*DTDM(1,1)
     &     +(VECT(6)+DUDM(1,2)*DVDM(1,2))*DTDM(2,2)
     &     +(VECT(2)+VECT(3))*DTDM(1,2)
     &     +(VECT(4)+VECT(5))*DTDM(2,1)
C
      ELSE
C Cas AXI
        S11 = DUDM(1,1)*DVDM(1,1) + DUDM(2,2)*DVDM(2,2) +
     &      DUDM(3,3)*DVDM(3,3)
        S12 = DUDM(1,1)*DVDM(2,2) + DUDM(2,2)*DVDM(1,1) +
     &      DUDM(1,1)*DVDM(3,3) + DUDM(3,3)*DVDM(1,1) +
     &      DUDM(2,2)*DVDM(3,3) + DUDM(3,3)*DVDM(2,2)
        S13 = (DUDM(1,2)+DUDM(2,1))*(DVDM(1,2)+DVDM(2,1)) +
     &      (DUDM(2,3)+DUDM(3,2))*(DVDM(2,3)+DVDM(3,2)) +
     &      (DUDM(3,1)+DUDM(1,3))*(DVDM(3,1)+DVDM(1,3))
C Calcul de S2
        DO 100 I = 1,3
          DO 101 J = 1,3
            DO 102 K = 1,3
              DO 103 L = 1,3
                BIL(I,J,K,L) =
     &          0.5D0 * (DUDM(I,J)*DVDM(K,L)+DUDM(K,L)*DVDM(I,J))
 103          CONTINUE
 102        CONTINUE
 101      CONTINUE
 100    CONTINUE
C
        S21 = 0.D0
        DO 110 K = 1,3
          DO 120 P = 1,3
            S21 = S21 + BIL(K,K,K,P)*DTDM(P,K)
 120       CONTINUE
 110     CONTINUE
C
        S22 = 0.D0
        DO 300 K = 1,3
          DO 301 L = 1,3
            IF (L .NE. K) THEN
              DO 302 P = 1,3
                S22 = S22 + BIL(L,L,K,P)*DTDM(P,K)
 302          CONTINUE
            END IF
 301      CONTINUE
 300    CONTINUE
C
        S23 = 0.D0
        DO 400 K = 1,3
          DO 401 L = 1,3
            IF (L .NE. K) THEN
              DO 402 M = 1,3
                IF (M.NE.K .AND. M.NE.L) THEN
                  DO 403 P = 1,3
                    S23 = S23 + BIL(L,M,L,P)*DTDM(P,M)
                    S23 = S23 + BIL(L,M,M,P)*DTDM(P,L)
 403              CONTINUE
                END IF
 402          CONTINUE
            END IF
 401      CONTINUE
 400    CONTINUE
C

      ENDIF
      
      S1 = C1*S11 + C2*S12 + C3*S13
      S2 = C1*S21 + C2*S22 + C3*S23

C--------------------------AUTRE MANIERE DE CALCUL POUR S2----------

C  TERME CLASSIQUE DU A LA THERMIQUE
C
      S1TH = COEF*EPSTHE*DIVV*E/(1.D0-2.D0*NU)
      PROD = 0.D0
      DO 20 I=1,2
        DO 10 J=1,2
          PROD = PROD + DVDM(I,J)*DTDM(J,I)
10      CONTINUE
20    CONTINUE
      IF (AXI) PROD = PROD+DVDM(3,3)*DTDM(3,3)
      S2TH = 0.5D0*TH*COEF*EPSTHE*PROD*E/(1.D0-2.D0*NU)
C
      TCLA = (-DIVT/2.D0*(S1-S1TH)+ (S2-S2TH))*POIDS
C
C - TERME THERMIQUE
C
      PROD = 0.D0
      IF (IRET.EQ.0) THEN
        DO 50 I=1,2
          PROD = PROD + TGDM(I)*DTDM(I,4)
50      CONTINUE     
        TTHE = POIDS*PROD*DIVV*COEF*ALPHA*E/(2.D0*(1.D0-2.D0*NU))
       ELSE
         TTHE = 0.D0
       ENDIF
C
C - TERME FORCE VOLUMIQUE
C     
      TFOR=0.D0
      DO 80 I=1,2
        PROD=0.D0
        DO 70 J=1,2
          PROD = PROD + DFDM(I,J)*DTDM(J,4)
70      CONTINUE
        TFOR = TFOR + CS*DVDM(I,4)*(PROD+DFDM(I,4)*DIVT)*POIDS
80    CONTINUE
C
C - TERME DYNAMIQUE
C
      PROD=0.D0        
      DO 200 I=1,2
        DO 210 J=1,2
          PROD = PROD + DUDM(I,J)*DTDM(J,4)*DVDM(I,4)+
     &                  DVDM(I,J)*DTDM(J,4)*DUDM(I,4)
210     CONTINUE
200   CONTINUE   
      TDYN = -0.5D0*RHO*(PULS**2)*PROD*POIDS        
C
      G  = TCLA+TTHE+TFOR+TDYN
C      
      END

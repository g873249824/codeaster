      SUBROUTINE MPROJP(ALIAS,XI,YI,GEOM,TAU1,TAU2,DIST)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/08/2002   AUTEUR ADBHHPM P.MASSIN 
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

C.......................................................................

C BUT:   FAIRE LA PROJECTION D'UN POINT SUR UNE MAILLE DONNEE

C ENTREES  ---> ALIAS       : NOM D'ALIAS DE L'ELEMENT
C          ---> GEOM        : LA GEOMETRIE DU POINT ET DE L'ELEMENT

C SORTIES  <---  XI,YI    : LES CORDONNEES PARA DU POINT VIS A VIS
C          <---  TAU1     : PREMIER VECTEUR TANGENT EN XI,YI,ZI
C          <---  TAU2     : PREMIER VECTEUR TANGENT EN XI,YI,ZI
C          <---  DIST     : DISTANCE ENTRE POINTS APPARIES
C.......................................................................


      IMPLICIT NONE
      CHARACTER*8 ALIAS
      REAL*8 TN(9),TAU1(3),TAU2(3),VEC1(3),DR(2,9)
      REAL*8 DDR(3,9),TANG(2,2),PAR11(3),PAR12(3),PAR22(3)
      REAL*8 GEOM(30),RESIDU(2),VEC(3),DIS(3),EPS
      REAL*8 DER,DES,DIST,DET,XI,YI,NTA1,NTA2,TEST
      INTEGER K,I,J,NDIM,ICOMPT,NNO

C    INITIALISATION

      XI = -0.D0
      YI = -0.D0
      IF (ALIAS(1:3).EQ.'SG2') THEN
        NNO = 2
        NDIM = 2
      ELSE IF (ALIAS(1:3).EQ.'SG3') THEN
        NDIM = 2
        NNO = 3
      ELSE IF (ALIAS(1:3).EQ.'TR3') THEN
        NDIM = 3
        NNO = 3
      ELSE IF (ALIAS(1:3).EQ.'TR6') THEN
        NDIM = 3
        NNO = 6
      ELSE IF (ALIAS(1:3).EQ.'QU4') THEN
        NDIM = 3
        NNO = 4
      ELSE IF (ALIAS(1:3).EQ.'QU8') THEN
        NDIM = 3
        NNO = 8
      ELSE IF (ALIAS(1:3).EQ.'QU9') THEN
        NDIM = 3
        NNO = 9
      ELSE
          CALL UTMESS('F','MPROJ', 'STOP1')
      END IF

       ICOMPT=0
 20    CONTINUE
        DO 10 I  = 1,3
         VEC(I)   = 0.D00
         VEC1(I)  = 0.D00
         TAU1(I)  = 0.D00
         TAU2(I)  = 0.D00
         PAR11(I) = 0.D00
         PAR12(I) = 0.D00
         PAR22(I) = 0.D00
 10     CONTINUE

       RESIDU(1) = 0.D00
       RESIDU(2) = 0.D00

       TANG(1,1) = 0.D0
       TANG(1,2) = 0.D0
       TANG(2,1) = 0.D0
       TANG(2,2) = 0.D0

           NTA1  = 0.D0
           NTA2  = 0.D0

C  CALCUL DES FFS ET LEURS DERIVEES

      CALL CALFFD(ALIAS,XI,YI,TN,DR,DDR)


C  CALCUL DE RESIDU


      DO 40 K = 1,NDIM
        DO 30 I = 1,NNO
          VEC1(K)  = GEOM(3*I+K)*TN(I) + VEC1(K)
          TAU1(K)  = GEOM(3*I+K)*DR(1,I) + TAU1(K)
          PAR11(K) = GEOM(3*I+K)*DDR(1,I) + PAR11(K)
          IF (NDIM.EQ.2) GO TO 30
          TAU2(K)  = GEOM(3*I+K)*DR(2,I) + TAU2(K)
          PAR22(K) = GEOM(3*I+K)*DDR(2,I) + PAR22(K)
          PAR12(K) = GEOM(3*I+K)*DDR(3,I) + PAR12(K)
 30    CONTINUE
 40   CONTINUE

        DO 35 K = 1,NDIM
        VEC1(K) = GEOM(K) - VEC1(K)
 35     CONTINUE

      DO 50 I = 1,3
        RESIDU(1) = VEC1(I)*TAU1(I) + RESIDU(1)
        IF (NDIM.EQ.2) GO TO 50
        RESIDU(2) = VEC1(I)*TAU2(I) + RESIDU(2)
   50 CONTINUE

C  CALCUL DE LA MATRICE

      DO 60 K = 1,NDIM
        TANG(1,1) = -TAU1(K)*TAU1(K) + PAR11(K)*VEC1(K) + TANG(1,1)
        IF (NDIM.EQ.2) GO TO 60
        TANG(1,2) = -TAU2(K)*TAU1(K) + PAR12(K)*VEC1(K) + TANG(1,2)
        TANG(2,1) = -TAU1(K)*TAU2(K) + PAR12(K)*VEC1(K) + TANG(2,1)
        TANG(2,2) = -TAU2(K)*TAU2(K) + PAR22(K)*VEC1(K) + TANG(2,2)
   60 CONTINUE

C   L'ALGORITHME DE NEWTON


      IF (NDIM.EQ.3) THEN
        DET = TANG(1,1)*TANG(2,2) - TANG(1,2)*TANG(2,1)
      ELSE IF (NDIM.EQ.2) THEN
        DET = TANG(1,1)
      ELSE
         CALL UTMESS('F','MPROJ','PROBLEM NDIM')
      END IF

      IF (DET.EQ.0.D0) THEN
        CALL UTMESS('F','PROJ_01',
     &      'MATRICE SINGULIERE (VECTEURS TANGENTS COLINEAIRE )'
     &          )
      END IF

      IF (NDIM.EQ.3) THEN
      DER = (TANG(2,2)* (-RESIDU(1))-TANG(1,2)* (-RESIDU(2)))/DET
      DES = (TANG(1,1)* (-RESIDU(2))-TANG(2,1)* (-RESIDU(1)))/DET
      ELSE IF (NDIM.EQ.2) THEN
        DER = -RESIDU(1)/TANG(1,1)
        DES = 0.D00
      ELSE
         CALL UTMESS('F', 'MPROJ', 'NDIM NI 2 NI 3')
      END IF
C   ACTUALISATION

      XI = XI + DER
      YI = YI + DES
      ICOMPT = ICOMPT + 1

C  TEST DE CONVERGENCE
      IF ((XI*XI+YI*YI).EQ.0.D0) THEN 
         TEST = SQRT(DER*DER+DES*DES)
         EPS=0.0001D0
      ELSE
         TEST = SQRT(DER*DER+DES*DES)/SQRT(XI*XI+YI*YI)
         EPS=0.01D0
      ENDIF
  
      IF ((TEST.GT.EPS) .AND. (ICOMPT.LT.20)) GO TO 20

C  AJUSTEMENT

      CALL MAJUST(ALIAS,XI,YI)
      CALL CALFFD(ALIAS,XI,YI,TN,DR,DDR)
      DO 90 I = 1,3
        DO 80 J = 1,NNO
          VEC(I) = GEOM(3*J+I)*TN(J) + VEC(I)
   80   CONTINUE
   90 CONTINUE

      DO 110 K = 1,NDIM
        DO 100 I = 1,NNO
          TAU1(K) = GEOM(3*I+K)*DR(1,I) + TAU1(K)
          IF (NDIM.EQ.2) GO TO 100
          TAU2(K) = GEOM(3*I+K)*DR(2,I) + TAU2(K)
  100   CONTINUE
  110 CONTINUE

C  NORMALISATION

      DO 120 I = 1,NDIM
        NTA1= TAU1(I)*TAU1(I)+NTA1
        NTA2= TAU2(I)*TAU2(I)+NTA2
  120 CONTINUE
      DO 130 I = 1,NDIM
       TAU1(I)=TAU1(I)/SQRT(NTA1)
       IF (NDIM.EQ.2) GO TO 130
       TAU2(I)=TAU2(I)/SQRT(NTA2)
  130 CONTINUE

      DO 140 I = 1,3
        DIS(I) = VEC(I) - GEOM(I)
  140 CONTINUE
      DIST = SQRT(DIS(1)*DIS(1)+DIS(2)*DIS(2)+DIS(3)*DIS(3))
      END

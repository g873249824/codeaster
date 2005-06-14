        SUBROUTINE  MPROJD(ALIAS,XI,YI,GEOM,TAU1,TAU2,DIST,DIR)


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/08/2002   AUTEUR ADBHHPM P.MASSIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C.......................................................................
C BUT:   FAIRE LA PROJECTION D'UN POINT SUR UNE MAILLE DONNEE SELON UNE
C        DIRECTION DE RECHERCHE DONNEE (DEFINIE PAR DIR())

C ENTREES  ---> ALIAS       : NOM D'ALIAS DE L'ELEMENT
C          ---> GEOM        : LA GEOMETRIE DU POINT ET DE L'ELEMENT
C          ---> DIR         : LA DIRECTION DE RECHERCHE
C
C SORTIES  <---  XI,YI      : LES CORDONNEES PARA DU POINT VIS A VIS
C          <---  TAU1       : PREMIER VECTEUR TANGENT EN XI,YI,ZI
C          <---  TAU2       : PREMIER VECTEUR TANGENT EN XI,YI,ZI
C          <---  DIST       : DISTANCE ENTRE POINTS APPARIES
C.......................................................................


      IMPLICIT NONE
      CHARACTER*8 ALIAS
      LOGICAL IRET
      REAL*8 TN(9),TAU1(3),TAU2(3),DR(2,9),DET
      REAL*8 DDR(3,9),TANG(3,3),ALPHA,DX(3),TANG2(2,2)
      REAL*8 GEOM(30),RESIDU(3),VEC(3),DIS(3),DIR(3)
      REAL*8 DER,DES,DIST,XI,YI,NTA1,NTA2,TEST
      INTEGER K,I,J,NDIM,ICOMPT,NNO,IND1,IND2


C    INITIALISATION
      XI = -0.D0
      YI = -0.D0
      ALPHA=1.D0
C   
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
          CALL UTMESS('F','MPROJD', 'STOP1')
      END IF


       ICOMPT=0           
 
C      DEBUT DE LA BOUCLE 

   20 CONTINUE  
   
      DO 10 I = 1,3
        DX(I)   = 0.D00
        VEC(I)  = 0.D00
        TAU1(I) = 0.D00
        TAU2(I) = 0.D00 
   10 CONTINUE

       RESIDU(1) = 0.D00
       RESIDU(2) = 0.D00
       RESIDU(3) = 0.D0

       DO 41 I=1,3
          DO 42 J=1,3
            TANG(I,J)=0.D0 
 42       CONTINUE
 41    CONTINUE

       NTA1=0.D0
       NTA2=0.D0

C  CALCUL DES FFS

      CALL CALFFD(ALIAS,XI,YI,TN,DR,DDR)

      DO 91 I = 1,3
          VEC(I)=0.D0
          TAU1(I)=0.D0
          TAU2(I)=0.D0
        DO 81 J = 1,NNO
          VEC(I)  = GEOM(3*J+I)*TN(J)   + VEC(I)
          TAU1(I) = GEOM(3*J+I)*DR(1,J) + TAU1(I)
          IF (NDIM.EQ.3) THEN
          TAU2(I) = GEOM(3*J+I)*DR(2,J) + TAU2(I)
          ENDIF
 81    CONTINUE
 91   CONTINUE
       IF (NDIM.EQ.3) THEN
       DO 25 I=1,3     
        RESIDU(I)= ALPHA*DIR(I)-GEOM(I)+VEC(I)
        DX(I) = -1.D0*RESIDU(I)
 25     CONTINUE
       ELSE
         RESIDU(1)= ALPHA*DIR(1)-GEOM(1)+VEC(1)
         RESIDU(2)= ALPHA*DIR(2)-GEOM(2)+VEC(2)
         DX(1) = -1.D0*RESIDU(1)
         DX(2) = -1.D0*RESIDU(2)
       ENDIF

C  CALCUL DE LA MATRICE
         
        IF (NDIM.EQ.2) THEN

        DO 23 I=1,2 
        TANG2(I,1)= TAU1(I)
        TANG2(I,2)= DIR(I)
 23   CONTINUE

        CALL MGAUSS(TANG2,DX,2,2,1,DET,IRET)

          XI = XI + DX(1)
          YI=0.D0
          ALPHA= ALPHA +DX(2)
          TEST = SQRT(DX(1)**2+DX(2)**2) 

        ELSEIF (NDIM.EQ.3) THEN

        DO 21 I=1,3 
        TANG(I,1)= TAU1(I)
        TANG(I,2)= TAU2(I)
        TANG(I,3)= DIR(I)
 21     CONTINUE

        CALL MGAUSS(TANG,DX,3,3,1,DET,IRET)

          XI = XI + DX(1)
          YI = YI + DX(2)
          ALPHA= ALPHA +DX(3)
          TEST = SQRT(DX(1)**2+DX(2)**2+DX(3)**2)

       ELSE
           CALL UTMESS('F','ALPHA','PROBLEME2')
       ENDIF

C   ACTUALISATION

      ICOMPT = ICOMPT + 1

C  TEST DE CONVERGENCE

      IF ((TEST.GT.0.0001D0) .AND. (ICOMPT.LT.50)) GO TO 20
 

C  AJUSTEMENT

      CALL MAJUST(ALIAS,XI,YI)
      CALL CALFFD(ALIAS,XI,YI,TN,DR,DDR)

      DO 90 I = 1,3
          VEC(I)=0.D0
        DO 80 J = 1,NNO
          VEC(I) = GEOM(3*J+I)*TN(J) + VEC(I)
   80   CONTINUE
   90 CONTINUE


      DO 110 K = 1,NDIM
           TAU1(K)=0.D0
           TAU2(K)=0.D0
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
      DIST = SQRT(DIS(1)**2+DIS(2)**2+DIS(3)**2)
      END

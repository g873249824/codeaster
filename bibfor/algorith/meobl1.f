      SUBROUTINE MEOBL1 (EPS,B,D,DELTAB,DELTAD,MULT,LAMBDA,
     &                    MU,ECROB,ECROD,ALPHA,K1,K2,DSIDEP)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/04/2010   AUTEUR IDOUX L.IDOUX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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

      IMPLICIT NONE

      REAL*8            EPS(6),B(6),D,DSIDEP(6,6)
      REAL*8            DELTAB(6),DELTAD,MULT
      REAL*8            LAMBDA,MU,ALPHA,K1,K2,ECROB,ECROD

C--CALCUL DE LA MATRICE TANGENTE POUR LA LOI ENDO_ORTHO_BETON
C
C
C
C
C
C-------------------------------------------------------------


      LOGICAL           IRET

      INTEGER           I,J,K,T(3,3)
      REAL*8             KRON(6),UN,DEUX
      REAL*8             CC(6),VECC(3,3),VALCC(3),CCP(6),CPE(6)
      REAL*8        VECEPS(3,3),VALEPS(3)
      REAL*8             FB(6),VECFB(3,3),VALFB(3),TREB
      REAL*8             TREPS,DCOEFD,ENE,FD,TREM
      REAL*8             DFMF,TDFBDB(6,6),TDFBDE(6,6)
      REAL*8             TDFDDE(6),TDFDDD
      REAL*8             INTERD,INTERT(6),INTERG
      REAL*8             PSI(6),KSI,IKSI
      REAL*8             MATB(6),MATD(6)
      REAL*8        FBS,DELTAS
      REAL*8        FBSM,SDFBDB,SDFBDE(6)
      REAL*8         COUPL,DCRIT(6)



      DATA  KRON/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/

      UN=1.D0
      DEUX=2.D0
      T(1,1)=1
      T(2,2)=2
      T(3,3)=3
      T(1,2)=4
      T(2,1)=4
      T(1,3)=5
      T(3,1)=5
      T(2,3)=6
      T(3,2)=6
      CALL R8INIR(36,0.D0,DSIDEP,1)
C-------------------------------------------------------
C-------------------------------------------------------
C----CALCUL DE FB: FORCE THERMO ASSOCIEE A
C-------------------ENDOMMAGEMENT ANISOTROPE DE TRACTION


      CALL R8INIR(6,0.D0,CC,1)

      DO 9 I=1,3
        DO 10 J=I,3
          DO 11 K=1,3
            CC(T(I,J))=CC(T(I,J))+B(T(I,K))*EPS(T(K,J))+
     &                 B(T(J,K))*EPS(T(K,I))
 11       CONTINUE
 10     CONTINUE
 9    CONTINUE
      CALL DIAGO3(CC,VECC,VALCC)
      CALL R8INIR(6,0.D0,CCP,1)
      CALL R8INIR(6,0.D0,CPE,1)
      DO 12 I=1,3
        IF (VALCC(I).LT.0.D0) THEN
          VALCC(I)=0.D0
        ENDIF
 12   CONTINUE
      DO 13 I=1,3
        DO 14 J=I,3
          DO 15 K=1,3
          CCP(T(I,J))=CCP(T(I,J))+VECC(I,K)*VALCC(K)*VECC(J,K)
 15       CONTINUE
 14     CONTINUE
 13   CONTINUE
      DO 16 I=1,3
        DO 17 J=I,3
          DO 18 K=1,3
            CPE(T(I,J))=CPE(T(I,J))+ CCP(T(I,K))*EPS(T(K,J))+
     &                    CCP(T(J,K))*EPS(T(K,I))
  18      CONTINUE
  17    CONTINUE
  16  CONTINUE

      CALL R8INIR(6,0.D0,FB,1)
      TREB=0.D0
      DO 301 I=1,3
      TREB=TREB+CC(I)/2
 301  CONTINUE
      IF (TREB.GT.0.D0) THEN
        DO 19 I=1,6
          FB(I)=-LAMBDA*TREB*EPS(I)
  19    CONTINUE
      ENDIF
      DO 20 I=1,6
        FB(I)=FB(I)-MU/DEUX*CPE(I)+ECROB*(KRON(I)-B(I))
  20  CONTINUE

       FBS=FB(1)

       DELTAS=DELTAB(1)


       IF (FBS.LT.0.D0) THEN
         FBSM=FBS
       ELSE
         FBSM=0.D0
       ENDIF


C----CALCUL DE FD: FORCE THERMO ASSOCIEE A
C-------------------ENDOMMAGEMENT ISOTROPE DE COMPRESSION


        TREPS=EPS(1)+EPS(2)+EPS(3)
        CALL DIAGO3(EPS,VECEPS,VALEPS)
        DO 22 I=1,3
          IF (VALEPS(I).GT.0.D0) THEN
            VALEPS(I)=0.D0
          ENDIF
 22     CONTINUE

        TREM=VALEPS(1)**2+VALEPS(2)**2+VALEPS(3)**2
        IF (TREPS.GT.0.D0) THEN
          TREPS=0.D0
        ENDIF
        DCOEFD=DEUX*(UN-D)
        ENE=LAMBDA/2*TREPS**2+MU*TREM
        FD=DCOEFD*ENE-DEUX*D*ECROD
        IF (FD.LT.0.D0) THEN
          FD=0.D0
        ENDIF


C---CALCUL DE DERIVEES UTILES----------------------------------

       IF (FBS.LE.0.D0) THEN
         DFMF=1.D0
       ELSE
         DFMF=0.D0
       ENDIF

      DCRIT(1)=-K1*(-TREPS/K2/(UN+(-TREPS/K2)**DEUX)
     &           +ATAN2(-TREPS/K2,UN))
      DCRIT(2)=-K1*(-TREPS/K2/(UN+(-TREPS/K2)**DEUX)
     &           +ATAN2(-TREPS/K2,UN))
      DCRIT(3)=-K1*(-TREPS/K2/(UN+(-TREPS/K2)**DEUX)
     &           +ATAN2(-TREPS/K2,UN))
      DCRIT(4)=0.D0
      DCRIT(5)=0.D0
      DCRIT(6)=0.D0



      CALL DFBDB(3,B,EPS,DEUX*MU,LAMBDA,ECROB,TDFBDB)
      CALL DFBDE(3,B,EPS,DEUX*MU,LAMBDA,TDFBDE)

            SDFBDB=TDFBDB(1,1)

      CALL DFDDE(EPS,D,3,LAMBDA,MU,TDFDDE)
      CALL DFDDD(EPS,D,3,LAMBDA,MU,ECROD,TDFDDD)



      DO 381 I=1,6
        SDFBDE(I)=TDFBDE(1,I)
 381  CONTINUE

      COUPL=SQRT(ALPHA*FBSM**DEUX+(UN-ALPHA)*FD**DEUX)
      IF ((FD.NE.0.D0).AND.(FBSM.NE.0.D0)) THEN

C---CALCUL DE DBDE ET DDDE-------------------------------------

C---CALCUL DE KSI ET PSI

      INTERD=0.D0
      INTERG=0.D0
      CALL R8INIR(6,0.D0,INTERT,1)
      CALL R8INIR(6,0.D0,PSI,1)
      KSI=0.D0

      DO 110 I=1,6
        INTERT(I)=(UN-ALPHA)*FD*TDFDDE(I)+ALPHA*FBSM*DFMF*SDFBDE(I)
     &           -COUPL*DCRIT(I)
 110  CONTINUE

        INTERG=DELTAS/FD-ALPHA*FBSM/(UN-ALPHA)/FD/TDFDDD
        INTERD=ALPHA*FBSM*DFMF*SDFBDB
        DO 313 J=1,6
          PSI(J)=-ALPHA*DELTAD*DFMF*SDFBDE(J)-INTERG*INTERT(J)
     &                  +(UN-ALPHA)*DELTAS*TDFDDE(J)
 313  CONTINUE


       KSI=ALPHA*DELTAD*DFMF*SDFBDB-(UN-ALPHA)*FD
     &              +INTERG*INTERD




       IF (KSI.NE.0.D0) THEN
         IKSI=UN/KSI
       ELSE
         CALL U2MESS('F','ALGORITH4_54')
       ENDIF





C-- ! ksi n est plus disponible

      CALL R8INIR(6,0.D0,MATB,1)
      CALL R8INIR(6,0.D0,MATD,1)

      DO 150 I=1,6
        MATD(I)=-INTERT(I)/(UN-ALPHA)/FD/TDFDDD
     &         -INTERD*IKSI*PSI(I)/(UN-ALPHA)/FD/TDFDDD
        MATB(I)=MATB(I)+IKSI*PSI(I)
150    CONTINUE

       DO 201 I=1,6
         DO 202 J=1,6
           DSIDEP(I,J)=-TDFDDE(I)*MATD(J)-SDFBDE(I)*MATB(J)
 202           CONTINUE
 201   CONTINUE

       ELSEIF ((FD.EQ.0.D0).AND.(FBSM.NE.0.D0)) THEN

         CALL R8INIR(6,0.D0,PSI,1)
         KSI=-ALPHA*MULT*DFMF*SDFBDB
         DO 581 J=1,6
           PSI(J)=ALPHA*MULT*DFMF*SDFBDE(J)
     &          -FBSM*ALPHA*MULT/COUPL*DCRIT(J)
 581     CONTINUE

         IF (KSI.NE.0.D0) THEN
           IKSI=UN/KSI
         ELSE
           CALL U2MESS('F','ALGORITH5_79')
         ENDIF

         CALL R8INIR(6,0.D0,MATB,1)

         DO 551 J=1,6
             MATB(J)=IKSI*PSI(J)
551           CONTINUE

         DO 561 I=1,6
           DO 562 J=1,6
              DSIDEP(I,J)=DSIDEP(I,J)-SDFBDE(I)*MATB(J)
 562             CONTINUE
 561     CONTINUE

       ELSEIF ((FD.NE.0.D0).AND.(FBSM.EQ.0.D0)) THEN

         DO 661 I=1,6
           DO 662 J=1,6
             DSIDEP(I,J)= -TDFDDE(I)*(-TDFDDE(J)+COUPL/(UN-ALPHA)
     &                      *DCRIT(J)/FD)/TDFDDD
 662             CONTINUE
 661     CONTINUE

      ENDIF


      END

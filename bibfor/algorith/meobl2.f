      SUBROUTINE MEOBL2 (EPS,B,D,DELTAB,DELTAD,MULT,LAMBDA,
     &                    MU,ECROB,ECROD,ALPHA,K1,K2,DSIDEP)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/05/2010   AUTEUR IDOUX L.IDOUX 
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

      INTEGER            I,J,K,T2(2,2),IRET
      REAL*8             RAC2,NOFBM,UN,DET,DEUX,FB(6)
      REAL*8             TREPS,FD,DFMF(3,3),TDFBDB(6,6),TDFBDE(6,6)
      REAL*8             TDFDDE(6),TDFDDD,INTERD(3),INTERT(6),INTERG(3)
      REAL*8             PSI(3,6),KSI(3,3),IKSI(3,3),MATB(3,6),MATD(6)
      REAL*8             FBS(3),VECFBS(2,2),VALFBS(2),DELTAS(3)
      REAL*8             FBSM(3),SDFBDB(3,3),SDFBDE(3,6)
      REAL*8             COUPL,DCRIT(6)

      DEUX=2.D0
      RAC2=SQRT(DEUX)
      UN=1.D0
      T2(1,1)=1
      T2(2,2)=2
      T2(1,2)=3
      T2(2,1)=3

C-------------------------------------------------------
C-------------------------------------------------------
C----CALCUL DE FB: FORCE THERMO ASSOCIEE A
C-------------------ENDOMMAGEMENT ANISOTROPE DE TRACTION

       CALL CEOBFB(B,EPS,LAMBDA,MU,ECROB,FB)

       FBS(1)=FB(1)
       FBS(2)=FB(2)
       FBS(3)=FB(4)

       DELTAS(1)=DELTAB(1)
       DELTAS(2)=DELTAB(2)
       DELTAS(3)=DELTAB(4)

      CALL DIAGO2(FBS,VECFBS,VALFBS)

      DO 29 I=1,2
        IF (VALFBS(I).GT.0.D0) THEN
          VALFBS(I)=0.D0
        ENDIF
  29  CONTINUE
      CALL R8INIR(3,0.D0,FBSM,1)
      DO 26 I=1,2
        DO 27 J=I,2
          DO 28 K=1,2
        FBSM(T2(I,J))=FBSM(T2(I,J))+VECFBS(I,K)*VALFBS(K)*VECFBS(J,K)
  28      CONTINUE
  27    CONTINUE
  26  CONTINUE

C----CALCUL DE FD: FORCE THERMO ASSOCIEE A
C-------------------ENDOMMAGEMENT ISOTROPE DE COMPRESSION

        CALL CEOBFD(D,EPS,LAMBDA,MU,ECROD,FD)
        IF (FD.LT.0.D0) THEN
          FD=0.D0
        ENDIF

C---CALCUL DE DERIVEES UTILES----------------------------------

      CALL DFMDF(3,FBS,DFMF)

C----CALCUL DE LA DERIVEE DU SEUIL---------------------

      TREPS=EPS(1)+EPS(2)+EPS(3)
      IF (TREPS.GT.0.D0) THEN
        TREPS=0.D0
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

            SDFBDB(1,1)=TDFBDB(1,1)
            SDFBDB(1,2)=TDFBDB(1,2)
            SDFBDB(1,3)=TDFBDB(1,4)
            SDFBDB(2,1)=TDFBDB(2,1)
            SDFBDB(2,2)=TDFBDB(2,2)
            SDFBDB(2,3)=TDFBDB(2,4)
            SDFBDB(3,1)=TDFBDB(4,1)
            SDFBDB(3,2)=TDFBDB(4,2)
            SDFBDB(3,3)=TDFBDB(4,4)

      DO 381 I=1,6
        SDFBDE(1,I)=TDFBDE(1,I)
        SDFBDE(2,I)=TDFBDE(2,I)
        SDFBDE(3,I)=TDFBDE(4,I)
 381  CONTINUE


        FBSM(3)=RAC2*FBSM(3)
        DELTAS(3)=DELTAS(3)*RAC2

      CALL DFDDE(EPS,D,3,LAMBDA,MU,TDFDDE)
      CALL DFDDD(EPS,D,3,LAMBDA,MU,ECROD,TDFDDD)

         NOFBM=FBSM(1)**2+FBSM(2)**2+FBSM(3)**2

      COUPL=SQRT(ALPHA*NOFBM+(UN-ALPHA)*FD**DEUX)
      CALL R8INIR(36,0.D0,DSIDEP,1)

       IF ((FD.NE.0.D0).AND.(NOFBM.NE.0.D0)) THEN


C---CALCUL DE DBDE ET DDDE-------------------------------------

C---CALCUL DE KSI ET PSI

      CALL R8INIR(3,0.D0,INTERD,1)
      CALL R8INIR(3,0.D0,INTERG,1)
      CALL R8INIR(6,0.D0,INTERT,1)
      CALL R8INIR(18,0.D0,PSI,1)
      CALL R8INIR(9,0.D0,KSI,1)

      DO 110 I=1,6
        INTERT(I)=(UN-ALPHA)*FD*TDFDDE(I)-COUPL*DCRIT(I)
        DO 111 J=1,3
          DO 112 K=1,3
          INTERT(I)=INTERT(I)+ALPHA*FBSM(K)*DFMF(K,J)*SDFBDE(J,I)
 112      CONTINUE
 111    CONTINUE
 110  CONTINUE



      DO 310 I=1,3
        INTERG(I)=DELTAS(I)/FD-ALPHA*FBSM(I)/(UN-ALPHA)/FD/TDFDDD
        DO 311 J=1,3
          DO 312 K=1,3
          KSI(I,J)=KSI(I,J)+ALPHA*DELTAD*DFMF(I,K)*SDFBDB(K,J)
          INTERD(I)=INTERD(I)+ALPHA*FBSM(K)*DFMF(K,J)*SDFBDB(J,I)
 312      CONTINUE
 311    CONTINUE
        DO 313 J=1,6
          DO 314 K=1,3
          PSI(I,J)=PSI(I,J)-ALPHA*DELTAD*DFMF(I,K)*SDFBDE(K,J)
 314      CONTINUE
 313    CONTINUE
 310  CONTINUE


      DO 120 I=1,3
        KSI(I,I)=KSI(I,I)-(UN-ALPHA)*FD
 120  CONTINUE

      DO 130 I=1,3
        DO 131 J=1,3
        KSI(I,J)=KSI(I,J)+INTERG(I)*INTERD(J)
 131    CONTINUE
        DO 331 J=1,6
        PSI(I,J)=PSI(I,J)-INTERG(I)*INTERT(J)
     &                  +(UN-ALPHA)*DELTAS(I)*TDFDDE(J)
 331    CONTINUE
 130  CONTINUE


      CALL R8INIR(9,0.D0,IKSI,1)
      DO 140 I=1,3
        IKSI(I,I)=1.D0
 140  CONTINUE

      CALL MGAUSS('NFVP',KSI,IKSI,3,3,3,DET,IRET)


C-- ! ksi n est plus disponible

      CALL R8INIR(18,0.D0,MATB,1)
      CALL R8INIR(6,0.D0,MATD,1)

      DO 150 I=1,6
        MATD(I)=-INTERT(I)/(UN-ALPHA)/FD/TDFDDD
        DO 151 J=1,3
               DO 152 K=1,3
            MATB(J,I)=MATB(J,I)+IKSI(J,K)*PSI(K,I)
            MATD(I)=MATD(I)-INTERD(J)*IKSI(J,K)*PSI(K,I)
     &                   /(UN-ALPHA)/FD/TDFDDD
152          CONTINUE
C            WRITE(6,*) 'MB(',J,',',I,')=',MATB(J,I),';'
151        CONTINUE
150    CONTINUE

       DO 201 I=1,6
         DO 202 J=1,6
           DSIDEP(I,J)=-TDFDDE(I)*MATD(J)
C         WRITE(6,*) 'DID(',I,',',J,')=', DSIDEP(I,J),';'
           DO 203 K=1,3
             DSIDEP(I,J)=DSIDEP(I,J)-SDFBDE(K,I)*MATB(K,J)
 203             CONTINUE
 202           CONTINUE
 201   CONTINUE




       ELSEIF ((FD.EQ.0.D0).AND.(NOFBM.NE.0.D0)) THEN

         CALL R8INIR(9,0.D0,KSI,1)
         CALL R8INIR(18,0.D0,PSI,1)

         DO 500 I=1,3
           DO 501 J=1,3
             KSI(I,J)=-FBSM(I)*FBSM(J)/NOFBM
             DO 502 K=1,3
               KSI(I,J)=KSI(I,J)-ALPHA*MULT*DFMF(I,K)*SDFBDB(K,J)
 502         CONTINUE
 501       CONTINUE
           DO 581 J=1,6
             PSI(I,J)=PSI(I,J)-FBSM(I)*ALPHA*MULT/COUPL*DCRIT(J)
             DO 582 K=1,3
               PSI(I,J)=PSI(I,J)+ALPHA*MULT*DFMF(I,K)*SDFBDE(K,J)
 582         CONTINUE
 581       CONTINUE
 500     CONTINUE

         DO 504 I=1,3
           KSI(I,I)=KSI(I,I)+1
 504     CONTINUE

         CALL R8INIR(9,0.D0,IKSI,1)
         DO 505 I=1,3
           IKSI(I,I)=1.D0
 505     CONTINUE

         CALL MGAUSS('NFVP',KSI,IKSI,3,3,3,DET,IRET)

         CALL R8INIR(18,0.D0,MATB,1)

         DO 550 I=1,3
           DO 551 J=1,6
                  DO 552 K=1,3
               MATB(I,J)=MATB(I,J)+IKSI(I,K)*PSI(K,J)
552               CONTINUE
551             CONTINUE
550      CONTINUE

         DO 561 I=1,6
           DO 562 J=1,6
             DO 563 K=1,3
              DSIDEP(I,J)=DSIDEP(I,J)-SDFBDE(K,I)*MATB(K,J)
 563               CONTINUE
 562             CONTINUE
 561     CONTINUE

        ELSEIF ((FD.NE.0.D0).AND.(NOFBM.EQ.0.D0)) THEN

         DO 661 I=1,6
           DO 662 J=1,6
             DSIDEP(I,J)= -TDFDDE(I)*(-TDFDDE(J)+COUPL/(UN-ALPHA)
     &                      *DCRIT(J)/FD)/TDFDDD
 662             CONTINUE
 661     CONTINUE

      ENDIF



      END

      SUBROUTINE SH1MEK(XETEMP,SIGMA,RE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C               ELEMENT SHB15
C
      IMPLICIT REAL *8(A-H,O-Z)
      INCLUDE 'jeveux.h'
      INTEGER IPROPE
      REAL*8 XE(45),RE(45,45)
      REAL*8 XCOQ(3,3),BKSIP(3,15,15),B(3,15)
      REAL*8 XCENT(3),PPP(3,3),TMPKE2(45,45)
      REAL*8 XL(3,3),XXX(3),YYY(3),TMPKE(45,45)
      REAL*8 XXG5(15),XYG5(15),XZG5(15),PXG5(15)
      REAL*8 SIGLOC(6),SIGMA(*)
C
      REAL*8 SIGMAG(6)
C
      REAL*8 SITMP1(15,15),SITMP2(15,15)
      REAL*8 XETEMP(*)

C
C ON DEFINI LES POINTS GAUSS ET LES POIDS
C
C 5 points sur la facette 1-2-3:
C
C
      DO 10 IP=1,5
         XZG5(IP)    =  0.5D0
         XYG5(IP)    =  0.5D0
         XZG5(IP+5)  =  0.5D0
         XYG5(IP+5)  =  0.D0
         XZG5(IP+10) =  0.D0
         XYG5(IP+10) =  0.5D0
   10 CONTINUE
C
      DO 20 IP=1,3
         XXG5(5*(IP-1)+1) = -0.906179845938664D0
         XXG5(5*(IP-1)+2) = -0.538469310105683D0
         XXG5(5*(IP-1)+3) =  0.D0
         XXG5(5*(IP-1)+4) =  0.538469310105683D0
         XXG5(5*(IP-1)+5) =  0.906179845938664D0
C
         PXG5(5*(IP-1)+1) =  0.236926885056189D0/6.D0
         PXG5(5*(IP-1)+2) =  0.478628670499366D0/6.D0
         PXG5(5*(IP-1)+3) =  0.568888888888889D0/6.D0
         PXG5(5*(IP-1)+4) =  0.478628670499366D0/6.D0
         PXG5(5*(IP-1)+5) =  0.236926885056189D0/6.D0
   20 CONTINUE
C     ON FAIT UNE COPIE DE XETEMP DANS XE
      DO 30 I = 1,45
        XE(I) = XETEMP(I)
   30 CONTINUE
C
C TYPE DE LOI DE COMPORTEMENT:
C     IRDC = 1 : SHB6 MEME TYPE QUE SHB8 DANS PLEXUS
C     IRDC = 2 : C.P.
C     IRDC = 3 : 3D COMPLETE
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CC CALCUL DE K.SIGMA                                                C
CC          EN ENTREE DANS WORK : SIGMA NORMALEMENT LONGUEUR 30     C
CC                         PROPEL(1): 1 POUR RE=RE+KSIGMA           C
CC                         PROPEL(1): 0 POUR RE=KSIGMA              C
CC             SORTIE           : RE(45*45)=RE(45*45)+KSIGMA        C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CC
CC CALCUL DE B (1 2 3) AUX 5 POINTS DE GAUSS
CC
       CALL SH1KSI(15,XXG5,XYG5,XZG5,BKSIP)
       DO 50 J=1,15
         DO 40 I=1,15
           SITMP2(I,J) = 0.D0
  40     CONTINUE
  50   CONTINUE
CC
CC DEBUT DE LA BOUCLE SUR LES 5 PTS GAUSS
CC
       DO 150 IP=1,15
CC
CC CALCUL DE B
CC
         CALL S1CALB(BKSIP(1,1,IP),XE,B,AJAC)
CC
CC CALCUL DE MATRICE DE PASSAGE POUR POUVOIR CALCULER LES CONTRAINTES
CC DANS LE REPERE GLOBAL
CC
         DO 60 I=1,6
CC CONTRAINTES LOCALES POUR POUVOIR TRAITER LA PLASTICITE AVANT
            SIGLOC(I)=SIGMA((IP-1)*6+I)
  60     CONTINUE
         ZETA  = XXG5(IP)
         ZLAMB = 0.5D0*(1.D0-ZETA)
         DO 80 I=1,3
            DO 70 J=1,3
               XCOQ(J,I) = ZLAMB*XE((I-1)*3+J)
     &             + (1.D0-ZLAMB)*XE(3*I+6+J)
  70        CONTINUE
  80     CONTINUE
C
         CALL RLOSH6(XCOQ,XCENT,PPP,XL,XXX,YYY,RBID)
CC
CC PASSAGE DES CONTRAINTES AU REPERE GLOBAL
CC
         CALL CHRP3D(PPP,SIGLOC,SIGMAG,1)
         DO 100 J = 1,15
           DO 90 I = 1,15
             SITMP1(I,J) = 0.D0
  90       CONTINUE
 100     CONTINUE
C
         DO 120 J = 1,15
           DO 110 I = 1,15
             SITMP1(I,J) = SIGMAG(1)*B(1,I)*B(1,J) +
     &         SIGMAG(2)*B(2,I)*B(2,J) +
     &         SIGMAG(3)*B(3,I)*B(3,J) +
     &         SIGMAG(4)*(B(1,I)*B(2,J)+B(2,I)*B(1,J)) +
     &         SIGMAG(6)*(B(1,I)*B(3,J)+B(3,I)*B(1,J)) +
     &         SIGMAG(5)*(B(3,I)*B(2,J)+B(2,I)*B(3,J))
 110       CONTINUE
 120     CONTINUE
C
         DO 140 J=1,15
            DO 130 I=1,15
               SITMP2(I,J) = SITMP2(I,J)
     &                     + AJAC*PXG5(IP)*SITMP1(I,J)
 130       CONTINUE
 140    CONTINUE
 150  CONTINUE
       CALL R8INIR(2025,0.D0,TMPKE,1)
       DO 180 KK=1,3
         DO 170 I=1,15
            DO 160 J=1,15
               TMPKE(I+(KK-1)*15,J+(KK-1)*15) = SITMP2(I,J)
 160        CONTINUE
 170     CONTINUE
 180   CONTINUE
CC
CC ON MET DE L'ORDRE:
CC
       CALL R8INIR(2025,0.D0,TMPKE2,1)
       DO 200 J=1,15
         DO 190 I=1,45
            TMPKE2(I,(J-1)*3+1)=TMPKE(I,J)
            TMPKE2(I,(J-1)*3+2)=TMPKE(I,J+15)
            TMPKE2(I,(J-1)*3+3)=TMPKE(I,J+30)
 190     CONTINUE
 200   CONTINUE
       CALL R8INIR(2025,0.D0,TMPKE,1)
       DO 220 I=1,15
         DO 210 J=1,45
            TMPKE((I-1)*3+1,J)=TMPKE2(I,J)
            TMPKE((I-1)*3+2,J)=TMPKE2(I+15,J)
            TMPKE((I-1)*3+3,J)=TMPKE2(I+30,J)
 210     CONTINUE
 220   CONTINUE
C
       IPROPE = 1
C
       IF(IPROPE.EQ.0) THEN
          CALL DCOPY(2025,TMPKE,1,RE,1)
       END IF
C
       IF(IPROPE.EQ.1) THEN
          CALL DAXPY(2025,1.D0,TMPKE,1,RE,1)
       END IF
C
       END

      SUBROUTINE SH2FOR(XETEMP,PARA,XIDEPM,SIGMA,XIVECT)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C               ELEMENT SHB20
C
      IMPLICIT REAL *8(A-H,O-Z)
      INTEGER LAG
      REAL*8 PARA(*)
      REAL*8 XIVECT(*),XETEMP(*)
      REAL*8 XE(60),XIDEPM(*),SIGMA(*)
      REAL*8 XCOQ(3,4),BKSIP(3,20,20),B(3,20)
      REAL*8 XCENT(3),PPP(3,3)
      REAL*8 XL(3,4),XXX(3),YYY(3)
      REAL*8 TMPKE(60,60),TMPKE2(60,60)
      REAL*8 XXG5(20),XYG5(20),XZG5(20),PXG5(20)
      REAL*8 SIGLOC(6),SITMP1(20,20),SITMP2(20,20)
      REAL*8 F(3,20),SIGMAG(6),FQ(60),POIDS
C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

C INFOS:
C XE EST RANGE COMME CA: (XNOEUD1 YNOEUD1 ZNOEUD1, XNOEUD2 YNOEUD2
C... ZNOEUD2)
C DANS SHB15_TEST_NUM: ATTENTION A LA NUMEROTATION DES NOEUDS
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C ON DEFINI LES POINTS GAUSS ET LES POIDS
C
      XZG5(1) = -0.906179845938664D0
      XZG5(2) = -0.538469310105683D0
      XZG5(3) =  0.D0
      XZG5(4) =  0.538469310105683D0
      XZG5(5) =  0.906179845938664D0
C
      PXG5(1) =  0.236926885056189D0
      PXG5(2) =  0.478628670499366D0
      PXG5(3) =  0.568888888888889D0
      PXG5(4) =  0.478628670499366D0
      PXG5(5) =  0.236926885056189D0
C
      DO 71 IZ =1,5
         XXG5(IZ)    = -0.577350269189625D0
         XXG5(IZ+5)  =  0.577350269189625D0
         XXG5(IZ+10) =  0.577350269189625D0
         XXG5(IZ+15) = -0.577350269189625D0
         XYG5(IZ)    = -0.577350269189625D0
         XYG5(IZ+5)  = -0.577350269189625D0
         XYG5(IZ+10) =  0.577350269189625D0
         XYG5(IZ+15) =  0.577350269189625D0
         XZG5(IZ+5)  = XZG5(IZ)
         PXG5(IZ+5)  = PXG5(IZ)
         XZG5(IZ+10) = XZG5(IZ)
         PXG5(IZ+10) = PXG5(IZ)
         XZG5(IZ+15) = XZG5(IZ)
         PXG5(IZ+15) = PXG5(IZ)
   71 CONTINUE
C
C     ON FAIT UNE COPIE DE XETEMP DANS XE
      DO 10 I = 1,60
         XE(I) = XETEMP(I)
   10 CONTINUE
C
C
C TYPE DE LOI DE COMPORTEMENT:
C     IRDC = 1 : SHB6 MEME TYPE QUE SHB8 DANS PLEXUS
C     IRDC = 2 : C.P.
C     IRDC = 3 : 3D COMPLETE
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
CC                                                                  C
CC ON CALCULE BSIGMA: SORTIE DANS OUT(24)                           C
CC                    ENTREE DE SIGMA DANS WORK(DIM=30)             C
CC                    ENTREE DU MATERIAU DANS D(1) ET D(2)          C
CC                    ENTREE DE QIALPHA PAS PRECEDENT               C
CC                                      DANS RE(1 A 12)             C
CC                              QIALPHA(J,I)=RE(J+(I-1)*3)          C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      LAG = NINT(PARA(6))
      CALL R8INIR(400,0.D0,SITMP2,1)
      DO 400 J=1,20
         DO 390 I=1,3
           F(I,J) = 0.D0
  390    CONTINUE
  400 CONTINUE
CC
CC CALCUL DE BKSIP(3,15,IP) DANS REPERE DE REFERENCE
CC      BKSIP(1,*,IP) = VECTEUR BX AU POINT GAUSS IP
CC      BKSIP(2,*,IP) = VECTEUR BY AU POINT GAUSS IP
CC      BKSIP(3,*,IP) = VECTEUR BZ AU POINT GAUSS IP
CC
      CALL SH2KSI(20,XXG5,XYG5,XZG5,BKSIP)
C
      DO 460 IP=1,20
CC
CC RECHERCHE DE SIGMA DU POINT DE GAUSS GLOBAL
CC
         DO 409 I=1,6
            SIGLOC(I)=SIGMA((IP-1)*6+I)
  409    CONTINUE
         ZETA  = XZG5(IP)
         ZLAMB = 0.5D0*(1.D0-ZETA)
         DO 420 I=1,4
            DO 410 J=1,3
               XCOQ(J,I) = ZLAMB*XE((I-1)*3+J)
     &             + (1.D0-ZLAMB)*XE(3*I+9+J)
  410       CONTINUE
  420    CONTINUE
         CALL RLOSHB(XCOQ,XCENT,PPP,XL,XXX,YYY,RBID)
CC
CC PASSAGE DES CONTRAINTES AU REPERE GLOBAL
CC
         CALL CHRP3D(PPP,SIGLOC,SIGMAG,1)
         CALL S2CALB(BKSIP(1,1,IP),XE,B,AJAC)
CC
CC CALCUL DE BQ.SIGMA SI LAGRANGIEN TOTAL
CC
         IF (LAG.EQ.1) THEN
            CALL R8INIR(400,0.D0,SITMP1,1)
            DO 422 J = 1,20
               DO 421 I = 1,20
                  SITMP1(I,J) = SIGMAG(1)*B(1,I)*B(1,J) +
     &             SIGMAG(2)*B(2,I)*B(2,J) +
     &             SIGMAG(3)*B(3,I)*B(3,J) +
     &             SIGMAG(4)*(B(1,I)*B(2,J)+B(2,I)*B(1,J)) +
     &             SIGMAG(6)* (B(1,I)*B(3,J)+B(3,I)*B(1,J)) +
     &             SIGMAG(5)* (B(3,I)*B(2,J)+B(2,I)*B(3,J))
  421          CONTINUE
  422       CONTINUE
            DO 440 J=1,20
              DO 430 I=1,20
                 SITMP2(I,J) = SITMP2(I,J)
     &           + AJAC*PXG5(IP)*SITMP1(I,J)
  430         CONTINUE
  440       CONTINUE
         END IF
CC
CC CALCUL DE B.SIGMA EN GLOBAL
CC
         POIDS = AJAC*PXG5(IP)
         DO 450 K=1,20
            F(1,K) = F(1,K) + POIDS *
     &      (B(1,K)*SIGMAG(1)+B(2,K)*SIGMAG(4)+B(3,K)*SIGMAG(6))
            F(2,K) = F(2,K) + POIDS *
     &      (B(1,K)*SIGMAG(4)+B(2,K)*SIGMAG(2)+B(3,K)*SIGMAG(5))
            F(3,K) = F(3,K) + POIDS *
     &      (B(1,K)*SIGMAG(6)+B(2,K)*SIGMAG(5)+B(3,K)*SIGMAG(3))
  450    CONTINUE
CC
CC SI LAGRANGIEN TOTAL: AJOUT DE FQ A F
CC
  460  CONTINUE
       IF (LAG.EQ.1) THEN
         CALL R8INIR(3600,0.D0,TMPKE,1)
         DO 490 KK=1,3
            DO 480 I=1,20
               DO 470 J=1,20
                  TMPKE(I+(KK-1)*20,J+(KK-1)*20) = SITMP2(I,J)
  470          CONTINUE
  480       CONTINUE
  490    CONTINUE
         CALL R8INIR(3600,0.D0,TMPKE2,1)
         DO 510 J=1,20
            DO 500 I=1,60
               TMPKE2(I,(J-1)*3+1)=TMPKE(I,J)
               TMPKE2(I,(J-1)*3+2)=TMPKE(I,J+20)
               TMPKE2(I,(J-1)*3+3)=TMPKE(I,J+40)
  500       CONTINUE
  510    CONTINUE
         CALL R8INIR(3600,0.D0,TMPKE,1)
         DO 530 I=1,20
            DO 520 J=1,60
               TMPKE((I-1)*3+1,J)=TMPKE2(I,J)
               TMPKE((I-1)*3+2,J)=TMPKE2(I+20,J)
               TMPKE((I-1)*3+3,J)=TMPKE2(I+40,J)
  520       CONTINUE
  530    CONTINUE
         CALL MULMAT(60,60,1,TMPKE,XIDEPM,FQ)
         DO 540 K=1,20
            F(1,K) = F(1,K) + FQ((K-1)*3+1)
            F(2,K) = F(2,K) + FQ((K-1)*3+2)
            F(3,K) = F(3,K) + FQ((K-1)*3+3)
  540    CONTINUE
       END IF
CC
CC ATTENTION A L'ORDRE DE XIVECT
CC
       DO 560 I=1,3
         DO 550 J=1,20
            XIVECT((J-1)*3+I) = F(I,J)
  550    CONTINUE
  560  CONTINUE

       END

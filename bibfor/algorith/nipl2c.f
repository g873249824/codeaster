      SUBROUTINE NIPL2C(FAMI, NNO1, NNO2, NPG1, IPOIDS, IVF1, IVF2,
     &                  IDFDE1, DFDI, GEOM, TYPMOD, OPTION, IMATE,
     &                  COMPOR, LGPG, CRIT, INSTAM, INSTAP, DEPLM,
     &                  DDEPL, ANGMAS, GONFLM, DGONFL, SIGM, VIM, SIGP,
     &                  VIP, FINTU, FINTA, KUU, KUA, KAA, CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C RESPONSABLE SFAYOLLE S.FAYOLLE
C TOLE CRP_21
      IMPLICIT NONE

      INCLUDE 'jeveux.h'
      INTEGER NNO1, NNO2, NPG1, IMATE, LGPG, CODRET, IPOIDS, IVF1, IVF2
      INTEGER IDFDE1

      REAL*8 INSTAM, INSTAP, DFDI(NNO1,2), GEOM(2,NNO1), CRIT(6)
      REAL*8 DEPLM(2,NNO1), DDEPL(2,NNO1), GONFLM(1,NNO2)
      REAL*8 DGONFL(1,NNO2), SIGM(5,NPG1), VIM(LGPG,NPG1), SIGP(5,NPG1)
      REAL*8 VIP(LGPG,NPG1), KUU(2,9,2,9), KUA(2,9,1,4), KAA(1,4,1,4)
      REAL*8 FINTU(2,9), FINTA(1,4), ANGMAS(3), TREPST

      CHARACTER*(*) FAMI
      CHARACTER*8 TYPMOD(*)
      CHARACTER*16 COMPOR(*), OPTION

C......................................................................
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C           EN HYPO-ELASTICITE
C......................................................................
C IN  NNO1    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AUX DEPLACEMENTS
C IN  NNO2    : NOMBRE DE NOEUDS DE L'ELEMENT LIES A LA PRESSION
C IN  NPG1    : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF1    : VALEUR  DES FONCTIONS DE FORME LIES AUX DEPLACEMENTS
C IN  VFF2    : VALEUR  DES FONCTIONS DE FORME LIES A LA PRESSION
C                  ET AU GONFLEMENT
C IN  DFDE1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDK1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM    : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  IMATE   : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  INSTAM  : INSTANT PRECEDENT
C IN  INSTAP  : INSTANT DE CALCUL
C IN  TM      : TEMPERATURE AUX NOEUDS A L'INSTANT PRECEDENT
C IN  TP      : TEMPERATURE AUX NOEUDS A L'INSTANT DE CALCUL
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  DEPLM   : DEPLACEMENT A L'INSTANT PRECEDENT
C IN  DDEPL   : INCREMENT DE DEPLACEMENT
C IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C IN  GONFLM  : P ET G  A L'INSTANT PRECEDENT
C IN  DGONFL  : INCREMENT POUR P ET G
C IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
C OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
C OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT FINTU   : FORCES INTERNES
C OUT FINTA   : FORCES INTERNES LIEES AUX MULTIPLICATEURS
C OUT KUU     : MATRICE DE RIGIDITE (RIGI_MECA_TANG ET FULL_MECA)
C OUT KUA     : MATRICE DE RIGIDITE TERMES CROISES U - PG
C                                       (RIGI_MECA_TANG ET FULL_MECA)
C OUT KAA     : MATRICE DE RIGIDITE TERME PG (RIGI_MECA_TANG, FULL_MECA)
C......................................................................
C

      LOGICAL GRAND, AXI

      INTEGER KPG, N, KL, PQ, I, J, M

      REAL*8 RAC2, DEPS(6), F(3,3), R
      REAL*8 EPSLDC(6), DEPLDC(6) , SIGMAM(6), SIGMA(6),DSIDEP(6,6)
      REAL*8 EPSM(6), DEF(4,9,2), DEFD(4,9,2), DEFTR(9,2), SIGTR
      REAL*8 DIVUM, DDIVU, RBID, TMP, DSBDEP(6,6)
      REAL*8 PM, DP, POIDS, VFF1, VFF2, VFFN, VFFM
      REAL*8 DDOT, ALPHA

C-----------------------------------------------------------------------
C - INITIALISATION

      CALL R8INIR(18, 0.D0, FINTU,1)
      CALL R8INIR( 4, 0.D0, FINTA,1)
      CALL R8INIR(324, 0.D0, KUU,1)
      CALL R8INIR(72, 0.D0, KUA,1)
      CALL R8INIR( 16, 0.D0, KAA,1)

      RAC2  = SQRT(2.D0)
      GRAND = .FALSE.
      AXI   = TYPMOD(1) .EQ. 'AXIS'

C - CALCUL POUR CHAQUE POINT DE GAUSS
      DO 800 KPG = 1,NPG1

C - CALCUL DE LA PRESSION ET DU GONFLEMENT
        PM = 0.D0
        DP = 0.D0
        DO 20 N = 1, NNO2
          VFF2 = ZR(IVF2-1+N+(KPG-1)*NNO2)
          PM = PM + VFF2*GONFLM(1,N)
          DP = DP + VFF2*DGONFL(1,N)
 20     CONTINUE

C - CALCUL DES ELEMENTS GEOMETRIQUES
C - CALCUL DE DFDI,F,EPS,R(EN AXI) ET POIDS
        CALL R8INIR(6, 0.D0, EPSM,1)
        CALL R8INIR(6, 0.D0, DEPS,1)
        CALL NMGEOM(2,NNO1,AXI,GRAND,GEOM,KPG,IPOIDS,IVF1,IDFDE1,
     &              DEPLM,.TRUE.,POIDS,DFDI,F,EPSM,R)

        CALL NMGEOM(2,NNO1,AXI,GRAND,GEOM,KPG,IPOIDS,IVF1,IDFDE1,
     &              DDEPL,.TRUE.,POIDS,DFDI,F,DEPS,R)
        DIVUM = EPSM(1) + EPSM(2) + EPSM(3)
        DDIVU = DEPS(1) + DEPS(2) + DEPS(3)

C - CALCUL DES MATRICES B ET BD
        DO 35 N=1,NNO1
          DO 30 I=1,2
            DEF(1,N,I) =  F(I,1)*DFDI(N,1)
            DEF(2,N,I) =  F(I,2)*DFDI(N,2)
            DEF(3,N,I) =  0.D0
            DEF(4,N,I) = (F(I,1)*DFDI(N,2) + F(I,2)*DFDI(N,1))/RAC2
 30       CONTINUE
 35     CONTINUE

C - TERME DE CORRECTION (3,3) AXI QUI PORTE EN FAIT SUR LE DDL 1
        IF (AXI) THEN
          DO 50 N=1,NNO1
            VFF1 = ZR(IVF1-1+N+(KPG-1)*NNO1)
            DEF(3,N,1) = F(3,3)*VFF1/R
 50       CONTINUE
        END IF

C - CALCUL DE LA TRACE ET DEVIATEUR DE B
        DO 70 N = 1,NNO1
          DO 65 I = 1,2
            DEFTR(N,I) =  DEF(1,N,I) + DEF(2,N,I) + DEF(3,N,I)
            DO 60 KL = 1,3
              DEFD(KL,N,I) = DEF(KL,N,I) - DEFTR(N,I)/3.D0
 60         CONTINUE
            DEFD(4,N,I) = DEF(4,N,I)
 65       CONTINUE
 70     CONTINUE

C - DEFORMATION POUR LA LOI DE COMPORTEMENT
        CALL DCOPY(6, EPSM,1, EPSLDC,1)
        CALL DCOPY(6, DEPS,1, DEPLDC,1)

C - CONTRAINTE EN T- POUR LA LOI DE COMPORTEMENT
        SIGMAM(1) = SIGM(1,KPG) + SIGM(5,KPG)
        SIGMAM(2) = SIGM(2,KPG) + SIGM(5,KPG)
        SIGMAM(3) = SIGM(3,KPG) + SIGM(5,KPG)
        SIGMAM(4) = SIGM(4,KPG)*RAC2
        SIGMAM(5) = 0.D0
        SIGMAM(6) = 0.D0

C - APPEL A LA LOI DE COMPORTEMENT
        CALL NMCOMP(FAMI, KPG, 1, 2, TYPMOD, IMATE, COMPOR, CRIT,INSTAM,
     &              INSTAP, 6, EPSLDC, DEPLDC, 6, SIGMAM, VIM(1,KPG), 
     &              OPTION, ANGMAS, 1, RBID, SIGMA, VIP(1,KPG), 
     &              36, DSIDEP, 1, RBID, CODRET)

C - CALCUL DE LA MATRICE D'ELASTICITE BULLE
        CALL TANBUL(OPTION, 3, KPG, IMATE, COMPOR, ALPHA, DSBDEP,
     &              TREPST)

C - CALCUL DE LA MATRICE DE RIGIDITE
        IF ( OPTION(1:16) .EQ. 'RIGI_MECA_TANG'
     &  .OR. OPTION(1: 9) .EQ. 'FULL_MECA'    ) THEN

C - TERME K_UU
          DO 105 N=1,NNO1
            DO 104 I=1,2
              DO 103 M=1,NNO1
                DO 102 J=1,2
                  TMP = 0.D0
                  DO 101 KL = 1,4
                    DO 100 PQ = 1,4
                      TMP=TMP+DEFD(KL,N,I)*DSIDEP(KL,PQ)*DEFD(PQ,M,J)
 100                CONTINUE
 101              CONTINUE
                  KUU(I,N,J,M) = KUU(I,N,J,M) + POIDS*TMP
 102            CONTINUE
 103          CONTINUE
 104        CONTINUE
 105      CONTINUE

C - TERME K_UP
          DO 112 N = 1, NNO1
            DO 111 I = 1,2
              DO 110 M = 1, NNO2
                VFF2 = ZR(IVF2-1+M+(KPG-1)*NNO2)
                TMP = DEFTR(N,I)*VFF2
                KUA(I,N,1,M) = KUA(I,N,1,M) + POIDS*TMP
 110          CONTINUE
 111        CONTINUE
 112      CONTINUE

C - TERME K_PP
          DO 145 N = 1,NNO2
            VFFN = ZR(IVF2-1+N+(KPG-1)*NNO2)
            DO 140 M = 1,NNO2
              VFFM = ZR(IVF2-1+M+(KPG-1)*NNO2)
              TMP = VFFN * VFFM*ALPHA
              KAA(1,N,1,M) = KAA(1,N,1,M) - POIDS*TMP
 140        CONTINUE
 145      CONTINUE
        ENDIF

C - CALCUL DE LA FORCE INTERIEURE ET DES CONTRAINTES DE CAUCHY
        IF(OPTION(1:9).EQ.'FULL_MECA'.OR.
     &     OPTION(1:9).EQ.'RAPH_MECA') THEN

C - CONTRAINTES A L'EQUILIBRE
          SIGTR = SIGMA(1) + SIGMA(2) + SIGMA(3)
          DO 180 PQ=1,3
            SIGMA(PQ) = SIGMA(PQ) - SIGTR/3 + (PM+DP)
 180      CONTINUE

C - CALCUL DE FINT_U
          DO 190 N=1,NNO1
            DO 189 I=1,2
              TMP = DDOT(4, SIGMA,1, DEF(1,N,I),1)
              FINTU(I,N) = FINTU(I,N) + TMP*POIDS
 189        CONTINUE
 190      CONTINUE

C - CALCUL DE FINT_P
          DO 191 N = 1, NNO2
            VFF2 = ZR(IVF2-1+N+(KPG-1)*NNO2)
            TMP = (DIVUM + DDIVU -(PM + DP)*ALPHA-TREPST)*VFF2
            FINTA(1,N) = FINTA(1,N) + TMP*POIDS
 191      CONTINUE

C - STOCKAGE DES CONTRAINTES
          DO 290 KL=1,3
            SIGP(KL,KPG) = SIGMA(KL)
 290      CONTINUE
          SIGP(4,KPG) = SIGMA(4)/RAC2
          SIGP(5,KPG) = SIGTR/3.D0 - PM - DP
        ENDIF
 800  CONTINUE

      END

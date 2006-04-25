       SUBROUTINE  NIPL3D(NNO1,NNO2,NPG1,IPOIDS,IVF1,IVF2,IDFDE1,
     &                  GEOM,TYPMOD,OPTION,IMATE,COMPOR,LGPG,CRIT,
     &                  INSTAM,INSTAP,
     &                  TM,TP,TREF,
     &                  DEPLM,DDEPL,
     &                  ANGMAS,
     &                  GONFLM,DGONFL,
     &                  SIGM,VIM,DFDI,SIGP,VIP,
     &                  FINTU, FINTA,KUU , KUA , KAA ,CODRET)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/04/2006   AUTEUR CIBHHPD L.SALMONA 
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
C TOLE CRP_21
       IMPLICIT NONE

       INTEGER       NNO1,NNO2, NPG1, IMATE, LGPG, CODRET
       INTEGER       IPOIDS,IVF1,IVF2,IDFDE1
       CHARACTER*8   TYPMOD(*)
       CHARACTER*16  OPTION, COMPOR(4)

       REAL*8        INSTAM,INSTAP
       REAL*8        GEOM(3,NNO1), CRIT(3), TM(NNO1),TP(NNO1), TREF
       REAL*8        DEPLM(3,NNO1),DDEPL(3,NNO1)
       REAL*8        GONFLM(2,NNO2),DGONFL(2,NNO2)
       REAL*8        DFDI(NNO1,3)
       REAL*8        SIGM(7,NPG1),SIGP(7,NPG1)
       REAL*8        VIM(LGPG,NPG1),VIP(LGPG,NPG1)
       REAL*8        KUU(3,20,3,20),KUA(3,20,2,8), KAA(2,8,2,8)
       REAL*8        FINTU(3,20), FINTA(2,8)
       REAL*8        ANGMAS(3)
C......................................................................
C
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C                               EN 3D
C......................................................................
C IN  NNO1    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AUX DEPLACEMENTS
C IN  NNO2    : NOMBRE DE NOEUDS DE L'ELEMENT LIES A LA PRESSION
C IN  NPG1    : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF1    : VALEUR  DES FONCTIONS DE FORME LIES AUX DEPLACEMENTS
C IN  VFF2    : VALEUR  DES FONCTIONS DE FORME LIES A LA PRESSION
C                                                 ET AU GONFLEMENT
C IN  DFDE1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDN1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
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
C OUT KUA     : MATRICE DE RIGIDITE TERMES CROISES  U - (PG)
C                                   (RIGI_MECA_TANG ET FULL_MECA)
C OUT KAA     : MATRICE DE RIGIDITE TERME PG (RIGI_MECA_TANG,FULL_MECA)

C......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER  ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      LOGICAL      GRAND

      INTEGER      KPG,N,I,M,J,KL,PQ

      REAL*8       DSIDEP(6,6),F(3,3),DEPS(6)
      REAL*8       EPSM(6), EPSLDC(6), DEPLDC(6)
      REAL*8       POIDS,TEMPM,TEMPP,TMP,TMP2,RAC2
      REAL*8       R,SIGMA(6),SIGMAM(6)
      REAL*8       PM,GM,DP,DG, DIVUM, DDIVU, SIGTR
      REAL*8       DEF(6,27,3), DEFD(6,27,3), DEFTR(27,3)
      REAL*8       RBID, DDOT,R8VIDE

C - INITIALISATION

      RAC2  = SQRT(2.D0)
      GRAND = .FALSE.
      CALL R8INIR(60 ,  0.D0, FINTU,1)
      CALL R8INIR(16 ,  0.D0, FINTA,1)
      CALL R8INIR(3600, 0.D0, KUU,1)
      CALL R8INIR(960 , 0.D0, KUA,1)
      CALL R8INIR( 256, 0.D0, KAA,1)


C - CALCUL POUR CHAQUE POINT DE GAUSS

      DO 800 KPG=1,NPG1

C - CALCUL DE LA TEMPERATURE AU POINT DE GAUSS

        TEMPM = 0.D0
        TEMPP = 0.D0
C
        DO 10 N=1,NNO1
          TEMPM = TEMPM + TM(N)*ZR(IVF1+N+(KPG-1)*NNO1-1)
          TEMPP = TEMPP + TP(N)*ZR(IVF1+N+(KPG-1)*NNO1-1)
 10     CONTINUE

C      CALCUL DE LA PRESSION ET DU GONFLEMENT

        GM = 0.D0
        DG = 0.D0
        PM = 0.D0
        DP = 0.D0
        DO 20 N = 1, NNO2
          PM = PM + ZR(IVF2+N+(KPG-1)*NNO2-1)*GONFLM(1,N)
          GM = GM + ZR(IVF2+N+(KPG-1)*NNO2-1)*GONFLM(2,N)
          DP = DP + ZR(IVF2+N+(KPG-1)*NNO2-1)*DGONFL(1,N)
          DG = DG + ZR(IVF2+N+(KPG-1)*NNO2-1)*DGONFL(2,N)
 20     CONTINUE

C - CALCUL DES ELEMENTS GEOMETRIQUES

C     CALCUL DE DFDI,F,EPS ET POIDS

        CALL R8INIR(6, 0.D0, EPSM,1)
        CALL R8INIR(6, 0.D0, DEPS,1)
        CALL NMGEOM(3,NNO1,.FALSE.,GRAND,GEOM,KPG,IPOIDS,
     &              IVF1,IDFDE1,DEPLM,POIDS,DFDI,
     &              F,EPSM,R)

C     CALCUL DE DEPS

        CALL NMGEOM(3,NNO1,.FALSE.,GRAND,GEOM,KPG,IPOIDS,
     &              IVF1,IDFDE1,DDEPL,POIDS,DFDI,
     &              F,DEPS,R)

        DIVUM = EPSM(1) + EPSM(2) + EPSM(3)
        DDIVU = DEPS(1) + DEPS(2) + DEPS(3)

C      CALCUL DE  B   (PRODUITS SYMETR. DE F PAR N),

        DO 35 N=1,NNO1
          DO 30 I=1,3
            DEF(1,N,I) =  F(I,1)*DFDI(N,1)
            DEF(2,N,I) =  F(I,2)*DFDI(N,2)
            DEF(3,N,I) =  F(I,3)*DFDI(N,3)
            DEF(4,N,I) = (F(I,1)*DFDI(N,2) + F(I,2)*DFDI(N,1))/RAC2
            DEF(5,N,I) = (F(I,1)*DFDI(N,3) + F(I,3)*DFDI(N,1))/RAC2
            DEF(6,N,I) = (F(I,2)*DFDI(N,3) + F(I,3)*DFDI(N,2))/RAC2
 30       CONTINUE
 35     CONTINUE

C     CALCUL DE B0 ET BD
        DO 50 N = 1,NNO1
          DO 49 I = 1,3
            DEFTR(N,I) =  DEF(1,N,I) + DEF(2,N,I) + DEF(3,N,I)
            DO 48 KL = 1,3
              DEFD(KL,N,I) = DEF(KL,N,I) - DEFTR(N,I)/3.D0
 48         CONTINUE
            DEFD(4,N,I) = DEF(4,N,I)
            DEFD(5,N,I) = DEF(5,N,I)
            DEFD(6,N,I) = DEF(6,N,I)
 49       CONTINUE
 50     CONTINUE

C      DEFORMATION POUR LA LOI DE COMPORTEMENT

        CALL DCOPY(6, EPSM,1, EPSLDC,1)
        CALL DCOPY(6, DEPS,1, DEPLDC,1)

        DO 60 J = 1,3
          EPSLDC(J) = EPSM(J) + (GM - DIVUM)/3.D0
          DEPLDC(J) = DEPS(J) + (DG - DDIVU)/3.D0
 60     CONTINUE

C      CONTRAINTE EN T- POUR LA LOI DE COMPORTEMENT

        DO 62 I=1,3
          SIGMAM(I) = SIGM(I,KPG) + SIGM(7,KPG)
 62     CONTINUE
        DO 65 I=4,6
          SIGMAM(I) = SIGM(I,KPG)*RAC2
 65     CONTINUE

C -    APPEL A LA LOI DE COMPORTEMENT
      CALL NMCOMP('RIGI',KPG,1,3,TYPMOD,IMATE,COMPOR,CRIT,
     &            INSTAM,INSTAP,
     &            TEMPM,TEMPP,TREF,
     &            0.D0, 0.D0, 0.D0,
     &            EPSLDC,DEPLDC,
     &            SIGMAM,VIM(1,KPG),
     &            OPTION,
     &            RBID,RBID,
     &            0,RBID,RBID,
     &            ANGMAS,
     &            RBID,
     &            SIGMA,VIP(1,KPG),DSIDEP,CODRET)

C - CALCUL DE LA MATRICE DE RIGIDITE

        IF ( OPTION(1:9) .EQ. 'RIGI_MECA'
     &  .OR. OPTION(1: 9) .EQ. 'FULL_MECA'    ) THEN

C        TERME K_UU

          DO 80 N=1,NNO1
          DO 79 I=1,3
            DO 78 M=1,NNO1
            DO 76 J=1,3
              TMP = 0.D0
              DO 75 KL = 1,6
                DO 74 PQ = 1,6
                  TMP = TMP + DEFD(KL,N,I)*DSIDEP(KL,PQ)*DEFD(PQ,M,J)
 74             CONTINUE
 75             CONTINUE
            KUU(I,N,J,M) = KUU(I,N,J,M) + POIDS*TMP
76          CONTINUE
78          CONTINUE
79        CONTINUE
80        CONTINUE

C        TERME K_UP

          DO 90 N = 1, NNO1
          DO 89 I = 1,3
            DO 88 M = 1, NNO2
              TMP = DEFTR(N,I)*ZR(IVF2+M+(KPG-1)*NNO2-1)
              KUA(I,N,1,M) = KUA(I,N,1,M) + POIDS*TMP
 88         CONTINUE
 89       CONTINUE
 90       CONTINUE

C        TERME K_UG

          DO 100 N = 1, NNO1
          DO 99 I = 1,3
            TMP = 0.D0
            DO 98 KL = 1,6
              DO 97 PQ = 1,3
                TMP = TMP + DEFD(KL,N,I)*DSIDEP(KL,PQ)
 97           CONTINUE
 98         CONTINUE
            TMP = TMP/3.D0
            DO 96 M = 1, NNO2
              KUA(I,N,2,M) = KUA(I,N,2,M) + POIDS*TMP*
     &        ZR(IVF2+M+(KPG-1)*NNO2-1)
 96         CONTINUE
 99       CONTINUE
 100      CONTINUE

C     TERME K_PP = 0

C        TERME K_PG

          DO 110 N = 1,NNO2
            DO 109 M = 1,NNO2
              TMP = ZR(IVF2+N+(KPG-1)*NNO2-1)*
     &              ZR(IVF2+M+(KPG-1)*NNO2-1)
              KAA(1,N,2,M) = KAA(1,N,2,M) - POIDS*TMP
              KAA(2,M,1,N) = KAA(2,M,1,N) - POIDS*TMP
 109        CONTINUE
 110      CONTINUE

C        TERME K_GG

          TMP = 0.D0
          DO 120 KL = 1,3
            DO 119 PQ = 1,3
              TMP = TMP + DSIDEP(KL,PQ)
 119      CONTINUE
 120      CONTINUE
          TMP = TMP/9.D0
          DO 118 N = 1,NNO2
            DO 117 M = 1,NNO2
              TMP2 = ZR(IVF2+N+(KPG-1)*NNO2-1)*
     &               ZR(IVF2+M+(KPG-1)*NNO2-1)
              KAA(2,N,2,M) = KAA(2,N,2,M) + POIDS*TMP*TMP2
 117        CONTINUE
 118      CONTINUE

        END IF

C - CALCUL DE LA FORCE INTERIEURE ET DES CONTRAINTES DE CAUCHY

        IF(OPTION(1:9).EQ.'FULL_MECA'.OR.
     &     OPTION(1:9).EQ.'RAPH_MECA') THEN

C        CONTRAINTES A L'EQUILIBRE
          SIGTR = SIGMA(1) + SIGMA(2) + SIGMA(3)
          DO 130 PQ=1,3
            SIGMA(PQ) = SIGMA(PQ) - SIGTR/3 + (PM+DP)
 130      CONTINUE

C        CALCUL DE FINT_U

          DO 140 N=1,NNO1
            DO 139 I=1,3
              TMP = DDOT(6, SIGMA,1, DEF(1,N,I),1)
              FINTU(I,N) = FINTU(I,N) + TMP*POIDS
 139        CONTINUE
 140      CONTINUE

C        CALCUL DE FINT_P ET FINT_G
          DO 150 N = 1, NNO2
            TMP = (DIVUM+DDIVU-GM-DG)*ZR(IVF2+N+(KPG-1)*NNO2-1)
            FINTA(1,N) = FINTA(1,N) + TMP*POIDS

            TMP = (SIGTR/3.D0 - PM - DP)*ZR(IVF2+N+(KPG-1)*NNO2-1)
            FINTA(2,N) = FINTA(2,N) + TMP*POIDS
 150      CONTINUE

C        STOCKAGE DES CONTRAINTES

          DO 190 KL=1,3
            SIGP(KL,KPG) = SIGMA(KL)
 190      CONTINUE
           DO 195 KL=4,6
            SIGP(KL,KPG) = SIGMA(KL)/RAC2
 195      CONTINUE
          SIGP(7,KPG) = SIGTR/3.D0 - PM - DP

        END IF

800   CONTINUE
      END

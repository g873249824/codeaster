       SUBROUTINE  NMGR3D(NNO,NPG,IPOIDS,IVF,IDFDE,GEOMI,
     &                    TYPMOD,OPTION,IMATE,COMPOR,LGPG,CRIT,
     &                    INSTAM,INSTAP,
     &                    DEPLM,DEPLP,
     &                    ANGMAS,
     &                    SIGM,VIM,MATSYM,
     &                    DFDI,PFF,DEF,SIGP,VIP,MATUU,VECTU,CODRET)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/04/2011   AUTEUR COURTOIS M.COURTOIS 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE VABHHTS J.PELLET
C TOLE CRP_21

       IMPLICIT NONE
C
       INTEGER       NNO, NPG, IMATE, LGPG, CODRET,IPOIDS,IVF,IDFDE
C
       CHARACTER*8   TYPMOD(*)
       CHARACTER*16  OPTION, COMPOR(4)
C
       REAL*8        INSTAM,INSTAP
       REAL*8        GEOMI(3,NNO), CRIT(3)
       REAL*8        DEPLM(1:3,1:NNO),DEPLP(1:3,1:NNO),DFDI(NNO,3)
       REAL*8        PFF(6,NNO,NNO),DEF(6,NNO,3)
       REAL*8        SIGM(6,NPG),SIGP(6,NPG)
       REAL*8        VIM(LGPG,NPG),VIP(LGPG,NPG)
       REAL*8        MATUU(*),VECTU(3,NNO),MAXEPS
       LOGICAL       MATSYM

C
C.......................................................................
C
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C           EN GRANDES ROTATIONS 3D
C.......................................................................
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  POIDSG  : POIDS DES POINTS DE GAUSS
C IN  VFF     : VALEUR  DES FONCTIONS DE FORME
C IN  DFDE    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  DFDK    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOMI   : COORDONEES DES NOEUDS SUR CONFIG INITIALE
C IN  TYPMOD  : TYPE DE MODEELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  IMATE   : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  INSTAM  : INSTANT PRECEDENT
C IN  INSTAP  : INSTANT DE CALCUL
C IN  DEPLM   : DEPLACEMENT A L'INSTANT PRECEDENT
C IN  DEPLP   : DEPLACEMENT A L'INSTANT COURANT
C IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
C IN  MATSYM  : VRAI SI LA MATRICE DE RIGIDITE EST SYMETRIQUE
C OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
C OUT DEF     : PRODUIT DER. FCT. FORME PAR F   AU DERNIER PT DE GAUSS
C OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
C OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
C.......................................................................
C
      LOGICAL GRAND,RESI,RIGI

      INTEGER KPG,KK,KKD,N,I,M,J,J1,KL,PQ,COD(27),NMAX

      REAL*8 DSIDEP(6,6),F(3,3),FM(3,3),FR(3,3),EPSM(6),EPSP(6),DEPS(6)
      REAL*8 R,SIGMA(6),SIGN(6),SIG(6),SIGG(6),FTF,DETF,FMM(3,3)
      REAL*8 POIDS,TMP1,TMP2,R8BID
      REAL*8 ELGEOM(10,27),ANGMAS(3),R8NNEM

      INTEGER INDI(6),INDJ(6)
      REAL*8  RIND(6),RIND1(6),RAC2
      DATA    INDI / 1 , 2 , 3 , 1, 1, 2 /
      DATA    INDJ / 1 , 2 , 3 , 2, 3, 3 /
      DATA    RIND / 0.5D0,0.5D0,0.5D0,0.70710678118655D0,
     &               0.70710678118655D0,0.70710678118655D0 /
      DATA    RIND1 / 0.5D0 , 0.5D0 , 0.5D0 , 1.D0, 1.D0, 1.D0 /

C 1 - INITIALISATION

      RAC2   = SQRT(2.D0)
      GRAND  = .TRUE.
      RESI = OPTION(1:4).EQ.'RAPH' .OR. OPTION(1:4).EQ.'FULL'
      RIGI = OPTION(1:4).EQ.'RIGI' .OR. OPTION(1:4).EQ.'FULL'

C 3 - CALCUL DES ELEMENTS GEOMETRIQUES SPECIFIQUES AU COMPORTEMENT

      CALL LCEGEO(NNO   ,NPG   ,IPOIDS,IVF   ,IDFDE ,
     &            GEOMI ,TYPMOD,COMPOR,3     ,DFDI  ,
     &            DEPLM ,DEPLP ,ELGEOM)

C 4 - INITIALISATION CODES RETOURS

      DO 1955 KPG=1,NPG
        COD(KPG)=0
1955  CONTINUE

C 5 - CALCUL POUR CHAQUE POINT DE GAUSS

      DO 800 KPG=1,NPG


C 5.2 - CALCUL DES ELEMENTS GEOMETRIQUES

C 5.2.1 - CALCUL DE EPSM EN T- POUR LDC

       DO 20 J = 1,6
        EPSM (J)=0.D0
        EPSP (J)=0.D0
20     CONTINUE
       CALL NMGEOM(3,NNO,.FALSE.,GRAND,GEOMI,KPG,IPOIDS,
     &            IVF,IDFDE,DEPLM,.TRUE.,POIDS,DFDI,
     &                   FM,EPSM,R)

C 5.2.2 - CALCUL DE F, EPSP, DFDI, R ET POIDS EN T+

       CALL NMGEOM(3,NNO,.FALSE.,GRAND,GEOMI,KPG,IPOIDS,
     &            IVF,IDFDE,DEPLP,.TRUE.,POIDS,DFDI,
     &                   F,EPSP,R)


C 5.2.3 - CALCUL DE DEPS POUR LDC

       MAXEPS=0.D0
       DO 25 J = 1,6
         DEPS (J)=EPSP(J)-EPSM(J)
         MAXEPS=MAX(MAXEPS,ABS(EPSP(J)))
25     CONTINUE

C  VERIFICATION QUE EPS RESTE PETIT
        IF (MAXEPS.GT.0.05D0) THEN
           IF( COMPOR(1)(1:4).NE.'ELAS') THEN
              CALL U2MESR('A','COMPOR2_9',1,MAXEPS)
           ENDIF
        ENDIF

C 5.2.4 - CALCUL DES PRODUITS SYMETR. DE F PAR N,

       IF (RESI) THEN
        DO 26 I=1,3
         DO 27 J=1,3
          FR(I,J) = F(I,J)
 27      CONTINUE
 26     CONTINUE
       ELSE
        DO 28 I=1,3
         DO 29 J=1,3
          FR(I,J) = FM(I,J)
 29      CONTINUE
 28     CONTINUE
       ENDIF

       DO 40 N=1,NNO
        DO 30 I=1,3
         DEF(1,N,I) =  FR(I,1)*DFDI(N,1)
         DEF(2,N,I) =  FR(I,2)*DFDI(N,2)
         DEF(3,N,I) =  FR(I,3)*DFDI(N,3)
         DEF(4,N,I) = (FR(I,1)*DFDI(N,2) + FR(I,2)*DFDI(N,1))/RAC2
         DEF(5,N,I) = (FR(I,1)*DFDI(N,3) + FR(I,3)*DFDI(N,1))/RAC2
         DEF(6,N,I) = (FR(I,2)*DFDI(N,3) + FR(I,3)*DFDI(N,2))/RAC2
 30     CONTINUE
 40    CONTINUE


C 5.2.6 - CALCUL DES PRODUITS DE FONCTIONS DE FORMES (ET DERIVEES)

       IF (RIGI) THEN
        DO 125 N=1,NNO
         IF(MATSYM) THEN
          NMAX = N
         ELSE
           NMAX = NNO
         ENDIF
         DO 126 M=1,NMAX
          PFF(1,N,M) =  DFDI(N,1)*DFDI(M,1)
          PFF(2,N,M) =  DFDI(N,2)*DFDI(M,2)
          PFF(3,N,M) =  DFDI(N,3)*DFDI(M,3)
          PFF(4,N,M) =(DFDI(N,1)*DFDI(M,2)+DFDI(N,2)*DFDI(M,1))/RAC2
          PFF(5,N,M) =(DFDI(N,1)*DFDI(M,3)+DFDI(N,3)*DFDI(M,1))/RAC2
          PFF(6,N,M) =(DFDI(N,2)*DFDI(M,3)+DFDI(N,3)*DFDI(M,2))/RAC2
 126     CONTINUE
 125    CONTINUE
       ENDIF

C 5.3 - LOI DE COMPORTEMENT
C 5.3.1 - CONTRAINTE CAUCHY -> CONTRAINTE LAGRANGE POUR LDC EN T-

       DETF = FM(3,3)*(FM(1,1)*FM(2,2)-FM(1,2)*FM(2,1))
     &      - FM(2,3)*(FM(1,1)*FM(3,2)-FM(3,1)*FM(1,2))
     &      + FM(1,3)*(FM(2,1)*FM(3,2)-FM(3,1)*FM(2,2))
       CALL MATINV('S',3,FM,FMM,R8BID)
       DO 127 PQ = 1,6
        SIGN(PQ) = 0.D0
        DO 128 KL = 1,6
         FTF = (FMM(INDI(PQ),INDI(KL))*FMM(INDJ(PQ),INDJ(KL)) +
     &          FMM(INDI(PQ),INDJ(KL))*FMM(INDJ(PQ),INDI(KL)))*RIND1(KL)
         SIGN(PQ) =  SIGN(PQ)+ FTF*SIGM(KL,KPG)
 128    CONTINUE
        SIGN(PQ) = SIGN(PQ)*DETF
 127   CONTINUE

       SIGN(4) = SIGN(4)*RAC2
       SIGN(5) = SIGN(5)*RAC2
       SIGN(6) = SIGN(6)*RAC2

C 5.3.2 - INTEGRATION
C --- ANGLE DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
C --- INITIALISE A R8NNEM (ON NE S'EN SERT PAS)
       CALL R8INIR(3,  R8NNEM(), ANGMAS ,1)

C -    APPEL A LA LOI DE COMPORTEMENT
       CALL NMCOMP('RIGI',KPG,1,3,TYPMOD,IMATE,COMPOR,CRIT,
     &            INSTAM,INSTAP,
     &            EPSM,DEPS,
     &            SIGN,VIM(1,KPG),
     &            OPTION,
     &            ANGMAS,
     &            ELGEOM(1,KPG),
     &            SIGMA,VIP(1,KPG),DSIDEP,COD(KPG))

       IF(COD(KPG).EQ.1) THEN
         GOTO 1956
       ENDIF

C 5.4 - CALCUL DE LA MATRICE DE RIGIDITE

       IF (RIGI) THEN
        DO 160 N=1,NNO
         DO 150 I=1,3
          DO 151,KL=1,6
           SIG(KL)=0.D0
           SIG(KL)=SIG(KL)+DEF(1,N,I)*DSIDEP(1,KL)
           SIG(KL)=SIG(KL)+DEF(2,N,I)*DSIDEP(2,KL)
           SIG(KL)=SIG(KL)+DEF(3,N,I)*DSIDEP(3,KL)
           SIG(KL)=SIG(KL)+DEF(4,N,I)*DSIDEP(4,KL)
           SIG(KL)=SIG(KL)+DEF(5,N,I)*DSIDEP(5,KL)
           SIG(KL)=SIG(KL)+DEF(6,N,I)*DSIDEP(6,KL)
151       CONTINUE
          IF(MATSYM) THEN
           NMAX = N
          ELSE
           NMAX = NNO
          ENDIF
          DO 140 J=1,3
           DO 130 M=1,NMAX

C 5.4.1 - RIGIDITE GEOMETRIQUE

            IF (OPTION(1:4).EQ.'RIGI') THEN
              SIGG(1)=SIGN(1)
              SIGG(2)=SIGN(2)
              SIGG(3)=SIGN(3)
              SIGG(4)=SIGN(4)
              SIGG(5)=SIGN(5)
              SIGG(6)=SIGN(6)
             ELSE
              SIGG(1)=SIGMA(1)
              SIGG(2)=SIGMA(2)
              SIGG(3)=SIGMA(3)
              SIGG(4)=SIGMA(4)
              SIGG(5)=SIGMA(5)
              SIGG(6)=SIGMA(6)
             ENDIF

            TMP1 = 0.D0
            IF (I.EQ.J) THEN
             TMP1 = PFF(1,N,M)*SIGG(1)
     &           + PFF(2,N,M)*SIGG(2)
     &           + PFF(3,N,M)*SIGG(3)
     &           + PFF(4,N,M)*SIGG(4)
     &           + PFF(5,N,M)*SIGG(5)
     &           + PFF(6,N,M)*SIGG(6)
            ENDIF

C 5.4.2 - RIGIDITE ELASTIQUE

            TMP2=0.D0
            TMP2=TMP2+SIG(1)*DEF(1,M,J)
            TMP2=TMP2+SIG(2)*DEF(2,M,J)
            TMP2=TMP2+SIG(3)*DEF(3,M,J)
            TMP2=TMP2+SIG(4)*DEF(4,M,J)
            TMP2=TMP2+SIG(5)*DEF(5,M,J)
            TMP2=TMP2+SIG(6)*DEF(6,M,J)

            IF(MATSYM) THEN
C 5.4.3 - STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
              IF (M.EQ.N) THEN
               J1 = I
              ELSE
               J1 = 3
              ENDIF
            IF (J.LE.J1) THEN
             KKD = (3*(N-1)+I-1) * (3*(N-1)+I) /2
             KK = KKD + 3*(M-1)+J
             MATUU(KK) = MATUU(KK) + (TMP1+TMP2)*POIDS
            END IF
            ELSE
C 5.4.4 - STOCKAGE SANS SYMETRIE
              KK = 3*NNO*(3*(N-1)+I-1) + 3*(M-1)+J
              MATUU(KK) = MATUU(KK) + (TMP1+TMP2)*POIDS
            ENDIF

 130       CONTINUE
 140      CONTINUE
 150     CONTINUE
 160    CONTINUE
       ENDIF

C 5.5 - CALCUL DE LA FORCE INTERIEURE

       IF (RESI) THEN
        DO 230 N=1,NNO
         DO 220 I=1,3
          DO 210 KL=1,6
           VECTU(I,N)=VECTU(I,N)+DEF(KL,N,I)*SIGMA(KL)*POIDS
 210      CONTINUE
 220     CONTINUE
 230    CONTINUE

C 5.6 - CALCUL DES CONTRAINTES DE CAUCHY, CONVERSION LAGRANGE -> CAUCHY

        DETF = F(3,3)*(F(1,1)*F(2,2)-F(1,2)*F(2,1))
     &      - F(2,3)*(F(1,1)*F(3,2)-F(3,1)*F(1,2))
     &      + F(1,3)*(F(2,1)*F(3,2)-F(3,1)*F(2,2))
        DO 190 PQ = 1,6
         SIGP(PQ,KPG) = 0.D0
         DO 200 KL = 1,6
          FTF = (F(INDI(PQ),INDI(KL))*F(INDJ(PQ),INDJ(KL)) +
     &          F(INDI(PQ),INDJ(KL))*F(INDJ(PQ),INDI(KL)))*RIND(KL)
          SIGP(PQ,KPG) =  SIGP(PQ,KPG)+ FTF*SIGMA(KL)
 200     CONTINUE
         SIGP(PQ,KPG) = SIGP(PQ,KPG)/DETF
 190    CONTINUE
       ENDIF

800   CONTINUE

1956  CONTINUE

C - SYNTHESE DES CODES RETOURS

      CALL CODERE(COD,NPG,CODRET)
      END

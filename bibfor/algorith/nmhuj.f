      SUBROUTINE NMHUJ (TYPMOD,  IMAT, COMP, CRIT,
     &           INSTAM, INSTAP, TEMPM, TEMPF, TREF, ANGMAS, EPSD,
     &           DEPS, SIGD, VIND, OPT, SIGF, VINF, DSDE, IRET)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/04/2013   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C  ================================================================
C  INTEGRATION DE LA LOI DE COMPORTEMENT ELASTO PLASTIQUE DE HUJEUX
C  AVEC    . 50 VARIABLES INTERNES
C          . 4 FONCTIONS SEUIL ELASTIQUE DEDOUBLEES AVEC CYCLIQUE
C
C  INTEGRATION DES CONTRAINTES           = SIG(T+DT)
C  INTEGRATION DES VARIABLES INTERNES    = VIN(T+DT)
C  ET CALCUL DU JACOBIEN ASSOCIE         = DS/DE(T+DT) OU DS/DE(T)
C  ================================================================
C  IN      TYPMOD  TYPE DE MODELISATION
C          IMAT    ADRESSE DU MATERIAU CODE
C          COMP    COMPORTEMENT DE L ELEMENT
C                  COMP(1) = RELATION DE COMPORTEMENT (CHABOCHE...)
C                  COMP(2) = NB DE VARIABLES INTERNES
C                  COMP(3) = TYPE DE DEFORMATION (PETIT,JAUMANN...)
C          CRIT    CRITERES  LOCAUX
C                  CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
C                            (ITER_INTE_MAXI == ITECREL)
C                  CRIT(2) = TYPE DE JACOBIEN A T+DT
C                            (TYPE_MATR_COMP == MACOMP)
C                            0 = EN VITESSE     > SYMETRIQUE
C                            1 = EN INCREMENTAL > NON-SYMETRIQUE
C                  CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
C                            (RESI_INTE_RELA == RESCREL)
C                  CRIT(5) = NOMBRE D'INCREMENTS POUR LE
C                            REDECOUPAGE LOCAL DU PAS DE TEMPS
C                            (RESI_INTE_PAS == ITEDEC )
C                            0 = PAS DE REDECOUPAGE
C                            N = NOMBRE DE PALIERS
C          INSTAM  INSTANT T
C          INSTAP  INSTANT T+DT
C          TEMPM   TEMPERATURE A T
C          TEMPF   TEMPERATURE A T+DT
C          TREF    TEMPERATURE DE REFERENCE
C          ANGMAS  LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM),
C                    + UN REEL QUI VAUT 0 SI NAUTIQUIES OU 2 SI EULER
C                    + LES 3 ANGLES D'EULER
C          EPSD    DEFORMATION TOTALE A T
C          DEPS    INCREMENT DE DEFORMATION TOTALE
C          SIGD    CONTRAINTE A T
C          VIND    VARIABLES INTERNES A T    + INDICATEUR ETAT T
C          OPT     OPTION DE CALCUL A FAIRE
C                          'RIGI_MECA_TANG'> DSDE(T)
C                          'FULL_MECA'     > DSDE(T+DT) , SIG(T+DT)
C                          'RAPH_MECA'     > SIG(T+DT)
C  OUT     SIGF    CONTRAINTE A T+DT
C          VINF    VARIABLES INTERNES A T+DT + INDICATEUR ETAT T+DT
C          DSDE    MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
C          IRET    CODE RETOUR DE  L'INTEGRATION DE LA LOI CJS
C                         IRET=0 => PAS DE PROBLEME
C                         IRET=1 => ECHEC
C  ----------------------------------------------------------------
C  INFO    MATERD        (*,1) = CARACTERISTIQUES ELASTIQUES A T
C                        (*,2) = CARACTERISTIQUES PLASTIQUES A T
C          MATERF        (*,1) = CARACTERISTIQUES ELASTIQUES A T+DT
C                        (*,2) = CARACTERISTIQUES PLASTIQUES A T+DT
C          NDT             NB DE COMPOSANTE TOTALES DES TENSEURS
C                                  = 6  3D
C                                  = 4  AXIS  C_PLAN  D_PLAN
C                                  = 1  1D
C          NDI             NB DE COMPOSANTE DIRECTES DES TENSEURS
C          NVI             NB DE VARIABLES INTERNES
C  ----------------------------------------------------------------
C  ROUTINE LC....UTILITAIRES POUR INTEGRATION LOI DE COMPORTEMENT
C  ----------------------------------------------------------------
C  ORDRE DES TENSEURS      3D      XX YY ZZ XY XZ YZ
C                          DP      XX YY ZZ XY
C                          AX      RR ZZ TT RZ
C                          1D      XX YY ZZ
C  ----------------------------------------------------------------
C  ATTENTION
C  SI OPT = 'RIGI_MECA_TANG' NE PAS TOUCHER AUX VARIABLES SIGF,VINF
C  QUI N ONT PAS DE PLACE MEMOIRE ALLOUEE
C
C  SIG EPS DEPS  ONT DEJA LEURS COMPOSANTES DE CISAILLEMENT
C  MULTIPLIES PAR RACINE DE 2 > PRISE EN COMPTE DES DOUBLES
C  PRODUITS TENSORIELS ET CONSERVATION DE LA SYMETRIE
C
C  ----------------------------------------------------------------
      INTEGER       IMAT, NDT, NDI, NVI, IRET, IRET1
      INTEGER       I, INC, INCMAX, NDTT, LIMSUP
      REAL*8        CRIT(*), VIND(50), VINF(50), VIND0(50)
      REAL*8        INSTAM, INSTAP, TEMPM, TEMPF, TREF
      REAL*8        EPSD(6), DEPS(6), DEPS0(6)
      REAL*8        SIGD(6), SIGF(6), DSDE(6,6), SEUIL
      REAL*8        PISO, DEPSR(6), DEPSQ(6), TIN(3)
      REAL*8        D, Q, M, PHI, B, DEGR, ANGMAS(3)
      REAL*8        PC0, SIGD0(6), HILL, DSIG(6)
      CHARACTER*7   ETATD, ETATF
      CHARACTER*8    MOD, TYPMOD(*)
      CHARACTER*16  COMP(*), OPT
      REAL*8        DEPSTH(6), ALPHA(3)
      REAL*8        DET, R8PREM, R8VIDE, BID16(6), BID66(6,6)
      REAL*8        MATERF(22,2), ZERO, UN, DEUX, DIX
      REAL*8        NEPS, NSIG, PTRAC, RTRAC
      INTEGER        IISNAN
      LOGICAL       DEBUG, CONV, REORIE, TRACT

      PARAMETER     ( DEGR  = 0.0174532925199D0 )

C     ----------------------------------------------------------------
      COMMON /TDIM/   NDT, NDI
      COMMON /MESHUJ/ DEBUG
C     ----------------------------------------------------------------
      DATA       ZERO / 0.0D0 /
      DATA       UN   / 1.0D0 /
      DATA       DEUX / 2.0D0 /
      DATA       DIX  / 10.D0 /

      IRET = 0
      DEBUG = .FALSE.
      TRACT = .FALSE.
C --- DEBUG = .TRUE. : MODE AFFICHAGE ENRICHI

      IF (DEBUG) WRITE(6,'(A)')'HHHHHHHHHHHHHHHHHHHHHH'
      MOD   = TYPMOD(1)

C ---> RECUPERATION COEF DE LA LOI HUJEUX
C      (INDEPENDANTS DE LA TEMPERATURE)
C      NB DE CMP DIRECTES/CISAILLEMENT
C      NB VARIABLES INTERNES
      CALL HUJMAT (MOD, IMAT, TEMPF, MATERF, NDT, NDI, NVI)

      PTRAC = MATERF(21,2)
      RTRAC = ABS(1.D-6*MATERF(8,2))

C --- REORIENTATION DES PLANS DE GLISSEMENT SUR LES AXES DU
C     REPERE LOCAL DONNE PAR LES ANGLES NAUTIQUES (ANGMAS)
      IF (ANGMAS(1).EQ.R8VIDE()) CALL U2MESS('F','ALGORITH8_20')
      REORIE =(ANGMAS(1).NE.ZERO) .OR. (ANGMAS(2).NE.ZERO)
     &         .OR. (ANGMAS(3).NE.ZERO)
      CALL HUJORI ('LOCAL', 1, REORIE, ANGMAS, SIGD, BID66)
      CALL HUJORI ('LOCAL', 1, REORIE, ANGMAS, EPSD, BID66)
      CALL HUJORI ('LOCAL', 1, REORIE, ANGMAS, DEPS, BID66)

C --- ON TRAVAILLE TOUJOURS AVEC UN TENSEUR CONTRAINTES
C     DEFINI EN 3D

      NDTT = 6
      IF (NDT.LT.6) THEN
        NDTT = 4
        NDT  = 6
      ENDIF


C     CALCUL DE DEPSTH ET EPSDTH
C     --------------------------
C ---> COEF DE DILATATION LE MEME A TPLUS ET TMOINS
      IF (MATERF(17,1).EQ.UN) THEN

        IF ( ((IISNAN(TEMPM).GT.0) .OR. (IISNAN(TREF).GT.0))
     &       .AND. (MATERF(3,1).NE.ZERO) )
     &  CALL U2MESS('F','CALCULEL_15')

        ALPHA(1) = MATERF(3,1)
        ALPHA(2) = MATERF(3,1)
        ALPHA(3) = MATERF(3,1)

      ELSEIF (MATERF(17,1).EQ.DEUX) THEN

        ALPHA(1) = MATERF(10,1)
        ALPHA(2) = MATERF(11,1)
        ALPHA(3) = MATERF(12,1)
        IF ( ((IISNAN(TEMPM).GT.0) .OR. (IISNAN(TREF).GT.0)) .AND.
     &       ((ALPHA(1).NE.ZERO) .OR. (ALPHA(2).NE.ZERO) .OR.
     &        (ALPHA(3).NE.ZERO)) )
     &  CALL U2MESS('F','CALCULEL_15')

      ELSE
        CALL U2MESS('F', 'COMPOR1_33')
      ENDIF

      IF ( (IISNAN(TEMPM).GT.0) .OR. (IISNAN(TEMPF).GT.0) .OR.
     &     (IISNAN(TREF) .GT.0) ) THEN

        DO 20 I = 1, NDI
          DEPSTH(I) = DEPS(I)
  20      CONTINUE

      ELSE

        DO 25 I = 1, NDI
          DEPSTH(I) = DEPS(I) -
     &                ALPHA(I)*(TEMPF-TREF) + ALPHA(I)*(TEMPM-TREF)
  25      CONTINUE

      ENDIF

      DO 21 I = NDI+1, NDT
        DEPSTH(I) = DEPS(I)
  21    CONTINUE

      IF (NDTT .LT. 6) THEN
        DO 22 I = NDTT+1, 6
          DEPSTH(I) = ZERO
          SIGD(I)   = ZERO
  22      CONTINUE
      ENDIF

C ---> INITIALISATION SEUIL DEVIATOIRE SI NUL

      DO 30 I = 1, NDI
        IF (VIND(I) .EQ. ZERO) THEN

           IF (MATERF(13, 2) .EQ. ZERO) THEN
             VIND(I) = 1.D-3
           ELSE
             VIND(I) = MATERF(13,2)
           ENDIF

           CALL HUJCRD(I, MATERF, SIGD, VIND, SEUIL)

C --- SI LE SEUIL EST DESEQUILIBRE A L'ETAT INITIAL
C     ON EQUILIBRE LE SEUIL EN CALCULANT LA VALEUR DE R
C     APPROPRIEE

           IF (SEUIL.GT.ZERO) THEN
             CALL HUJPRJ(I,SIGD,TIN,PISO,Q)
             PISO       = PISO - PTRAC
             B          = MATERF(4,2)
             PHI        = MATERF(5,2)
             M          = SIN(DEGR*PHI)
             PC0        = MATERF(7,2)
             VIND(I)    = -Q/(M*PISO*(UN-B*LOG(PISO/PC0)))
             VIND(23+I) = UN
           ENDIF

        ENDIF
  30    CONTINUE

C ---> INITIALISATION SEUIL ISOTROPE SI NUL
      IF (VIND(4) .EQ. ZERO) THEN
         IF (MATERF(14, 2) .EQ. ZERO) THEN
           VIND(4) = 1.D-3
         ELSE
           VIND(4) = MATERF(14,2)
         ENDIF

         CALL HUJCRI(MATERF, SIGD, VIND, SEUIL)

C --- SI LE SEUIL EST DESEQUILIBRE A L'ETAT INITIAL
C     ON EQUILIBRE LE SEUIL EN CALCULANT LA VALEUR DE R
C     APPROPRIEE

         IF (SEUIL .GT. ZERO) THEN
           PISO    = (SIGD(1)+SIGD(2)+SIGD(3))/3
           D       = MATERF(3,2)
           PC0     = MATERF(7,2)
           VIND(4) = PISO/(D*PC0)
           VIND(27)= UN
         ENDIF

      ENDIF

C ---> INITIALISATION SEUIL CYCLIQUE SI NUL
      DO 40 I = 1, NDI
        IF (VIND(4+I) .EQ. ZERO) THEN
          IF (MATERF(18, 2) .EQ. ZERO) THEN
            VIND(4+I) = 1.D-3
          ELSE
            VIND(4+I) = MATERF(18,2)
          ENDIF
        ENDIF
 40     CONTINUE

      IF (VIND(8) .EQ. ZERO) THEN
         IF (MATERF(19, 2) .EQ. ZERO) THEN
           VIND(8) = 1.D-3
         ELSE
           VIND(8) = MATERF(19,2)
         ENDIF
      ENDIF

CONTROLE DES INDICATEURS DE PLASTICITE
      DO 39 I = 1, 4
        IF (ABS(VIND(27+I)-UN).LT.R8PREM()) VIND(23+I)=-UN
  39    CONTINUE

      IF (OPT(1:9).NE.'RIGI_MECA') CALL LCEQVN (50, VIND, VINF)

C ---> ETAT ELASTIQUE OU PLASTIQUE A T
      IF (((VIND(24) .EQ. ZERO) .OR.
     &   (VIND(24) .EQ. -UN .AND. VIND(28) .EQ. ZERO)) .AND.
     &   ((VIND(25) .EQ. ZERO) .OR.
     &   (VIND(25) .EQ. -UN .AND. VIND(29) .EQ. ZERO)) .AND.
     &   ((VIND(26) .EQ. ZERO) .OR.
     &   (VIND(26) .EQ. -UN .AND. VIND(30) .EQ. ZERO)) .AND.
     &   ((VIND(27) .EQ. ZERO).OR.
     &   (VIND(27) .EQ. -UN .AND. VIND(31) .EQ. ZERO))) THEN
        ETATD = 'ELASTIC'
      ELSE
        ETATD = 'PLASTIC'
      ENDIF

C     -------------------------------------------------------------
C     OPTIONS 'FULL_MECA' ET 'RAPH_MECA' = CALCUL DE SIG(T+DT)
C     -------------------------------------------------------------
      IF (OPT(1:9).EQ.'RAPH_MECA'.OR.OPT(1:9).EQ.'FULL_MECA') THEN

      IF(DEBUG)WRITE(6,*)'DEPS =',(DEPSTH(I),I=1,3)

       DO 44 I = 1, 3
         CALL HUJPRJ(I,SIGD,TIN,PISO,Q)
         IF (ABS(PISO+DEUX*RTRAC-PTRAC).LT.R8PREM()) TRACT = .TRUE.
  44     CONTINUE

C ---> INTEGRATION ELASTIQUE SUR DT
        DO 45 I = 1, NDT
          DEPSQ(I) = ZERO
  45      CONTINUE

C -----------------------------------------------
C ---> INCREMENT TOTAL DE DEFORMATION A APPLIQUER
C -----------------------------------------------
C - ENREGISTREMENT DE L'ETAT DE CONTRAINTES A T
        CALL LCEQVE (SIGD,SIGD0)
C - ENREGISTREMENT DE L'INCREMENT TOTAL DEPS0
        CALL LCEQVE (DEPSTH,DEPS0)
C - INITIALISATION DES DEFORMATIONS RESTANTES
        CALL LCEQVE (DEPSTH,DEPSQ)
        CALL LCEQVN (NVI, VIND, VIND0)
C - INITIALISATION DU COMPTEUR D'ITERATIONS LOCALES
        VIND(35) = ZERO

C -----------------------------------------------------
C ---> PREDICTION VIA TENSEUR ELASTIQUE DES CONTRAINTES
C -----------------------------------------------------
        INC    = 0
        INCMAX = 1
 100    CONTINUE

        INC = INC + 1
        CALL LCEQVE (DEPSQ, DEPSR)
        CALL HUJPRE (ETATD, MOD, CRIT, IMAT, MATERF, DEPSR, SIGD,
     &               SIGF, VIND0, IRET)
        IF (IRET .EQ. 1) GOTO 9999

C ----------------------------------------------------
C ---> CONTROLE DE L EVOLUTION DE LA PRESSION ISOTROPE
C ----------------------------------------------------
        IRET1 =0
        CALL HUJDP (MOD, DEPSR, SIGD, SIGF, MATERF,
     &              VIND, INCMAX, IRET1)
        IF (DEBUG .AND. IRET1.EQ.1)
     &  WRITE (6,'(A)') 'NMHUJ :: HUJDP :: PAS DE RESUBDIVISON'

C --- ON LIMITE LE REDECOUPAGE LOCAL A 20 POUR HUJDP
        LIMSUP = 20
        IF (ABS(CRIT(5)).GT.LIMSUP) LIMSUP = INT(ABS(CRIT(5)))
        IF (INCMAX.GE.LIMSUP) THEN
          INCMAX = LIMSUP
        ELSEIF (INCMAX.LE.1) THEN
          INCMAX =1
        ENDIF

        IF (INC.EQ.1 .AND. INCMAX.GT.1) THEN
          DO 48 I=1, NDT
            DEPSQ(I)=DEPS0(I) /INCMAX
            DEPSR(I)=DEPS0(I) /INCMAX
 48         CONTINUE
          CALL HUJPRE (ETATD, MOD, CRIT, IMAT, MATERF, DEPSR,
     &                 SIGD, SIGF, VIND0, IRET)
        ENDIF

C ---------------------------------------------
C CALCUL DE L'ETAT DE CONTRAINTES CORRESPONDANT
C ---------------------------------------------
        IF(DEBUG)WRITE(6,*)'NMHUJ -- VINF =',(VINF(I),I=24,31)
        CALL HUJRES(MOD, CRIT, MATERF, IMAT, NVI, DEPSR,
     &       SIGD, VIND, SIGF, VINF, IRET, ETATF)
        IF (IRET.EQ.1) GOTO 9999

C -------------------------------------------
C - CONTROLE DES DEFORMATIONS DEJA APPLIQUEES
C -------------------------------------------
        IF (INC.LT.INCMAX) THEN
          CONV =.FALSE.
        ELSE
          CONV =.TRUE.
        ENDIF

        IF (.NOT.CONV) THEN
          CALL LCEQVE (SIGF, SIGD)
          CALL LCEQVN (NVI, VINF, VIND)
          GOTO 100
        ENDIF

C --- CALCUL DU CRITERE DE HILL: DSIG*DEPS
          HILL = ZERO
          NSIG = ZERO
          NEPS = ZERO
          DO 57 I = 1, NDT
            DSIG(I) = SIGF(I) - SIGD0(I)
            HILL    = HILL + DSIG(I)*DEPS0(I)
            NSIG    = NSIG + DSIG(I)**2.D0
            NEPS    = NEPS + DEPS0(I)**2.D0
 57       CONTINUE

C --- NORMALISATION DU CRITERE : VARIE ENTRE -1 ET 1
          IF ((NEPS.GT.R8PREM()).AND.(NSIG.GT.R8PREM())) THEN
            VINF(32) = HILL/SQRT(NEPS*NSIG)
          ELSE
            VINF(32) = ZERO
          ENDIF

      ENDIF
Caf 07/05/07 fin <IF RAPH_MECA et FULL_MECA>

C       ----------------------------------------------------------------
C       OPTIONS 'FULL_MECA' ET 'RIGI_MECA_TANG' = CALCUL DE DSDE
C       ----------------------------------------------------------------
C       CALCUL ELASTIQUE ET EVALUATION DE DSDE A (T)
C       POUR 'RIGI_MECA_TANG' ET POUR 'FULL_MECA'
C       ----------------------------------------------------------------
      IF (OPT .EQ. 'RIGI_MECA_TANG') THEN

        CALL LCINMA (ZERO, DSDE)

C REMARQUE: CALCUL DE DSDE A T AVEC MATERF CAR PARAMETRES HUJEUX
C --------  INDEPENDANTS DE LA TEMPERATURE

C ---> CALCUL MATRICE DE RIGIDITE ELASTIQUE
        IF (ETATD .EQ. 'ELASTIC') THEN
          CALL HUJTEL (MOD, MATERF, SIGD, DSDE)
        ENDIF

C ---> CALCUL MATRICE TANGENTE DU PROBLEME CONTINU
        IF (ETATD .EQ. 'PLASTIC') THEN
          CALL HUJTID (MOD, IMAT, SIGD, VIND, DSDE, IRET)
          IF (IRET.EQ.1) GOTO 9999
        ENDIF

        CALL HUJORI ('GLOBA', 2, REORIE, ANGMAS, BID16, DSDE)

      ELSEIF (OPT .EQ. 'FULL_MECA') THEN

        CALL LCINMA (ZERO, DSDE)

C ---> CALCUL MATRICE DE RIGIDITE ELASTIQUE
        IF (ETATF .EQ. 'ELASTIC')  THEN
          CALL HUJTEL (MOD, MATERF, SIGF, DSDE)
        ENDIF

C ---> CALCUL MATRICE TANGENTE DU PROBLEME CONTINU
        IF (ETATF .EQ. 'PLASTIC') THEN
          CALL HUJTID (MOD, IMAT, SIGF, VINF, DSDE, IRET)
          IF (IRET.EQ.1) GOTO 9999
        ENDIF

      ELSEIF (OPT .EQ. 'FULL_MECA_ELAS') THEN

        CALL LCINMA (ZERO, DSDE)
        CALL HUJTEL (MOD, MATERF, SIGF, DSDE)

      ELSEIF (OPT .EQ. 'RIGI_MECA_ELAS') THEN

        CALL LCINMA (ZERO, DSDE)
        CALL HUJTEL (MOD, MATERF, SIGD, DSDE)
        CALL HUJORI ('GLOBA', 2, REORIE, ANGMAS, BID16, DSDE)

      ENDIF
C fin <IF RIGI_MECA_TANG>

C ---> CALCUL DETERMINANT DE LA MATRICE TANGENTE + INDICATEUR
C --- RELIE AUX MECANISMES ACTIFS
      IF (OPT(1:9) .NE. 'RIGI_MECA') THEN

        CALL HUJORI ('GLOBA', 2, REORIE, ANGMAS, BID16, DSDE)

        IF(OPT .EQ.'FULL_MECA')THEN
          CALL MGAUSS ('NCSD', DSDE, SIGD, 6, 6, 1, DET, IRET)
          IF (IRET.EQ.1) THEN
            VINF(33) = UN
            IRET = 0
          ELSE
            VINF(33) = DET
          ENDIF
        ENDIF

        VINF(34) = ZERO

        DO 60 I=1,8
          IF (ABS(VINF(23+I)-UN).LT.R8PREM()) THEN
            IF (I.EQ.1) VINF(34)=VINF(34)+DIX**ZERO
            IF (I.EQ.2) VINF(34)=VINF(34)+DIX**UN
            IF (I.EQ.3) VINF(34)=VINF(34)+DIX**DEUX
            IF (I.EQ.4) VINF(34)=VINF(34)+DIX**3.D0
            IF (I.EQ.5) VINF(34)=VINF(34)+DIX**4.D0
            IF (I.EQ.6) VINF(34)=VINF(34)+DIX**5.D0
            IF (I.EQ.7) VINF(34)=VINF(34)+DIX**6.D0
            IF (I.EQ.8) VINF(34)=VINF(34)+DIX**7.D0
          ENDIF
 60     CONTINUE


      ENDIF
C --- ON RENVOIE LA VALEUR ADEQUATE DE NDT
C     POUR MODELISATION D_PLAN
      IF (NDTT.EQ.4) NDT = 4

      IF (OPT .EQ. 'RAPH_MECA' .OR. OPT(1:9) .EQ. 'FULL_MECA')
     &CALL HUJORI ('GLOBA', 1, REORIE, ANGMAS, SIGF, BID66)

 9999 CONTINUE

      IF (OPT(1:9).EQ.'RAPH_MECA'.OR.OPT(1:9).EQ.'FULL_MECA') THEN
        IF (IRET.EQ.1) THEN
          IF (.NOT.TRACT) THEN
            CALL LCINMA (ZERO, DSDE)
            CALL HUJTEL (MOD, MATERF, SIGD, DSDE)
            CALL LCEQVE(SIGD0,SIGF)
            CALL LCEQVE(SIGD0,SIGD)
            CALL LCEQVN (50, VIND0, VINF)
            CALL LCEQVN (50, VIND0, VIND)

            IF (DEBUG) THEN
              WRITE(6,*)'************************************'
              WRITE(6,*)'DEPS =',(DEPS0(I),I=1,NDT)
              WRITE(6,*)'SIGD =',(SIGD0(I),I=1,NDT)
              WRITE(6,*)'VIND =',(VIND0(I),I=1,50)
              WRITE(6,*)
            ENDIF
          ELSE

            CALL LCINMA (ZERO, DSDE)
            CALL HUJTEL (MOD, MATERF, SIGD, DSDE)
            DO 61 I = 1, 3
              SIGF(I)   = -DEUX*RTRAC+PTRAC
              SIGF(I+3) = ZERO
  61        CONTINUE
            CALL LCEQVN (50, VIND0, VINF)
            IRET = 0
          ENDIF
        ENDIF
        CALL LCEQVE(SIGD0,SIGD)
        CALL LCEQVE(DEPS0,DEPS)
        CALL LCEQVN (50, VIND0, VIND)
      ENDIF

      END

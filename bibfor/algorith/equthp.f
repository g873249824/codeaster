       SUBROUTINE EQUTHP(
     &             IMATE,OPTION,NDIM,COMPOR,TYPMOD,
     &             KPI,NPG,
     &             DIMDEF,DIMCON,NBVARI,
     &             DEFGEM,CONGEM,VINTM,
     &             DEFGEP,CONGEP,VINTP,
     &             MECANI,PRESS1,PRESS2,TEMPE,
     &             CRIT,RINSTM,RINSTP,
     &             R,DRDS,DSDE,RETCOM)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/07/2009   AUTEUR MEUNIER S.MEUNIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21
C ======================================================================
       IMPLICIT NONE
C ======================================================================
C     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C     EN MECANIQUE DES MILIEUX POREUX PARTIELLEMENT SATURES
C     AVEC COUPLAGE THM 3D
C
C     VERSION PERMANENTE DE EQUTHM
C
C.......................................................................
C ARGUMENTS D'ENTREE
C C. CHAVANT "ARCHITECTURE THM", 05/01/99 P. 18
C               CRIT    CRITERES  LOCAUX
C                       CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
C                                 (ITER_INTE_MAXI == ITECREL)
C                       CRIT(2) = TYPE DE JACOBIEN A T+DT
C                                 (TYPE_MATR_COMP == MACOMP)
C                                 0 = EN VITESSE     > SYMETRIQUE
C                                 1 = EN INCREMENTAL > NON-SYMETRIQUE
C                       CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
C                                 (RESI_INTE_RELA == RESCREL)
C                       CRIT(5) = NOMBRE D'INCREMENTS POUR LE
C                                 REDECOUPAGE LOCAL DU PAS DE TEMPS
C                                 (RESI_INTE_PAS == ITEDEC )
C                                 0 = PAS DE REDECOUPAGE
C                                 N = NOMBRE DE PALIERS
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  OPTION  : OPTION DE CALCUL
C IN  DIMDEF  : DIMENSION DU TABLEAU DES DEFORMATIONS GENERALISEES
C               AU POINT DE GAUSS
C IN  DIMCON  : DIMENSION DU TABLEAU DES CONTRAINTES GENERALISEES
C               AU POINT DE GAUSS
C IN  NBVARI  : NOMBRE TOTAL DE VARIABLES INTERNES "MECANIQUES"
C IN  DEFGEP  : TABLEAU DES DEFORMATIONS GENERALISEES
C               AU POINT DE GAUSS AU TEMPS PLUS
C IN  DEFGEM  : TABLEAU DES DEFORMATIONS GENERALISEES
C               AU POINT DE GAUSS AU TEMPS MOINS
C             : EPSXY = (DV/DX+DU/DY)/SQRT(2)
C IN  CONGEM  : TABLEAU DES CONTRAINTES GENERALISEES
C               AU POINT DE GAUSS AU TEMPS MOINS
C IN  VINTM   : TABLEAU DES VARIABLES INTERNES (MECANIQUES ET
C               HYDRAULIQUES)AU POINT DE GAUSS AU TEMPS MOINS
C IN  MECANI  : TABLEAU CONTENANT
C               YAMEC = MECA(1), YAMEC=1 : IL Y A UNE EQUATION MECANIQUE
C               ADDEME = MECA(2), ADRESSE DANS LES TABLEAUX DES DEFORMAT
C               GENERALISEES AU POINT DE GAUSS DEFGEP ET DEFGEM DES
C               DEFORMATIONS CORRESPONDANT A LA MECANIQUE
C               ADCOME = MECA(3), ADRESSE DANS LES TABLEAUX DES CONTRAIN
C               GENERALISEES AU POINT DE GAUSS CONGEP ET CONGEM DES
C               CONTRAINTES CORRESPONDANT A LA MECANIQUE
C               NDEFME = MECA(4), NOMBRE DE DEFORMATIONS MECANIQUES
C               NCONME = MECA(5), NOMBRE DE CONTRAINTES MECANIQUES
C IN  PRESS1    : TABLEAU CONTENANT
C               YAP1 = PRESS1(1), YAP1 = 1 >> IL Y A UNE PREMIERE
C               EQUATION DE PRESSION
C               NBPHA1=PRESS1(2) NOMBRE DE PHASES POUR LE CONSTITUANT 1
C               ADDEP1 = PRESS1(3), ADRESSE DANS LES TABLEAUX DES DEFORM
C               GENERALISEES AU POINT DE GAUSS DEFGEP ET DEFGEM DES
C               DEFORMATIONS CORRESPONDANT A LA PREMIERE PRESSION
C               ADCP11=PRESS1(4), ADRESSE DANS LES TABLEAUX DES CONTRAIN
C               GENERALISEES AU POINT DE GAUSS CONGEP ET CONGEM DES
C               CONTRAINTES CORRESPONDANT A LA PREMIERE PHASE DU
C               PREMIER CONSTITUANT
C               ADCP12=PRESS1(5), ADRESSE DANS LES TABLEAUX DES CONTRAIN
C               GENERALISEES AU POINT DE GAUSS CONGEP ET CONGEM DES
C               CONTRAINTES CORRESPONDANT A LA DEUXIEME PHASE DU
C               PREMIER CONSTITUANT
C               NDEFP1 = PRESS1(6), NOMBRE DE DEFORMATIONS PRESSION 1
C               NCONP1 = PRESS1(7), NOMBRE DE CONTRAINTES POUR
C               CHAQUE PHASE DU CONSTITUANT 1
C IN  PRESS2    : TABLEAU CONTENANT
C               YAP2 = PRESS2(1), YAP2 = 1 >> IL Y A UNE SECONDE
C               EQUATION DE PRESSION
C               ADDEP2 = PRESS2(3), ADRESSE DANS LES TABLEAUX DES DEFORM
C               GENERALISEES AU POINT DE GAUSS DEFGEP ET DEFGEM DES
C               DEFORMATIONS CORRESPONDANT A LA SECONDE PRESSION
C               NBPHA2=PRESS2(2) NOMBRE DE PHASES POUR LE CONSTITUANT 2
C               ADCP21=PRESS2(4), ADRESSE DANS LES TABLEAUX DES CONTRAIN
C               GENERALISEES AU POINT DE GAUSS CONGEP ET CONGEM DES
C               CONTRAINTES CORRESPONDANT A LA PREMIERE PHASE DU
C               SECOND CONSTITUANT
C               ADCP22=PRESS2(5), ADRESSE DANS LES TABLEAUX DES CONTRAIN
C               GENERALISEES AU POINT DE GAUSS CONGEP ET CONGEM DES
C               CONTRAINTES CORRESPONDANT A LA DEUXIEME PHASE DU
C               SECOND CONSTITUANT
C               NDEFP2 = PRESS2(6), NOMBRE DE DEFORMATIONS PRESSION 2
C               NCONP2 = PRESS2(7), NOMBRE DE CONTRAINTES POUR
C               CHAQUE PHASE DU CONSTITUANT 2
C IN  TEMPE    : TABLEAU CONTENANT
C               YATE = TEMPE(1), YATE=1 : IL Y A UNE EQUATION THERMIQUE
C               ADDETE = TEMPE(2), ADRESSE DANS LES TABLEAUX DES DEFORMA
C               GENERALISEES AU POINT DE GAUSS DEFGEP ET DEFGEM DES
C               DEFORMATIONS CORRESPONDANT A LA THERMIQUE
C               ADCOTE = TEMPE(3), ADRESSE DANS LES TABLEAUX DES CONTRAI
C               GENERALISEES AU POINT DE GAUSS CONGEP ET CONGEM DES
C               CONTRAINTES CORRESPONDANT A LA THERMIQUE
C               NDEFTE = TEMPE(4), NOMBRE DE DEFORMATIONS THERMIQUES
C               NCONTE = TEMPE(5), NOMBRE DE CONTRAINTES THERMIQUES
C OUT CONGEP  : TABLEAU DES CONTRAINTES GENERALISEES
C               AU POINT DE GAUSS AU TEMPS PLUS
C             : SIGXY = LE VRAI
C OUT VINTP   : TABLEAU DES VARIABLES INTERNES (MECANIQUES ET HYDRAULIQU
C               AU POINT DE GAUSS AU TEMPS PLUS
C OUT R       : TABLEAU DES RESIDUS
C OUT DRDE    : TABLEAU DE LA MATRICE TANGENTE AU POINT DE GAUSS
C OUT         : RETCOM RETOUR DES LOIS DE COMPORTEMENT
C ======================================================================
C   -------------------------------------------------------------------
C     SUBROUTINE APPELLEE :
C       DEDIEE A EQUTHP : COMTHM
C     FONCTIONS INTRINSEQUES :
C       SQRT.
C   -------------------------------------------------------------------

      INTEGER      IMATE,NDIM,NBVARI,KPI,NPG,DIMDEF,DIMCON,RETCOM
      INTEGER      MECANI(5),PRESS1(7),PRESS2(7),TEMPE(5)
      INTEGER      YAMEC,ADDEME,ADCOME,YATE,ADDETE,ADCOTE,I,J
      INTEGER      YAP1,NBPHA1,ADDEP1,ADCP11,ADCP12
      INTEGER      YAP2,NBPHA2,ADDEP2,ADCP21,ADCP22
      REAL*8       DEFGEM(1:DIMDEF),DEFGEP(1:DIMDEF),CONGEM(1:DIMCON)
      REAL*8       CONGEP(1:DIMCON),VINTM(1:NBVARI),VINTP(1:NBVARI)
      REAL*8       R(1:DIMDEF+1),DRDS(1:DIMDEF+1,1:DIMCON),PESA(3)
      REAL*8       DSDE(1:DIMCON,1:DIMDEF),CRIT(*),RINSTP,RINSTM
      REAL*8       DEUX,RAC2
      PARAMETER   (DEUX = 2.D0)
      LOGICAL PERMAN
      CHARACTER*8  TYPMOD(2)
      CHARACTER*16 OPTION,COMPOR(*)
C ======================================================================
C --- INITIALISATIONS DES VARIABLES DEFINISSANT LE PROBLEME ------------
C ======================================================================
      PERMAN = .TRUE.
      RAC2   = SQRT(DEUX)
      YAMEC  = MECANI(1)
      ADDEME = MECANI(2)
      ADCOME = MECANI(3)
      YAP1   = PRESS1(1)
      NBPHA1 = PRESS1(2)
      ADDEP1 = PRESS1(3)
      ADCP11 = PRESS1(4)
      ADCP12 = PRESS1(5)
      YAP2   = PRESS2(1)
      NBPHA2 = PRESS2(2)
      ADDEP2 = PRESS2(3)
      ADCP21 = PRESS2(4)
      ADCP22 = PRESS2(5)
      YATE   = TEMPE(1)
      ADDETE = TEMPE(2)
      ADCOTE = TEMPE(3)
C ============================================================
C --- COMME CONGEM CONTIENT LES VRAIES CONTRAINTES ET --------
C --- COMME PAR LA SUITE ON TRAVAILLE AVEC SQRT(2)*SXY -------
C --- ON COMMENCE PAR MODIFIER LES CONGEM EN CONSEQUENCE -----
C ============================================================
      IF(YAMEC.EQ.1) THEN
         DO 100 I = 4 , 6
           CONGEM(ADCOME+I-1)= CONGEM(ADCOME+I-1)*RAC2
 100     CONTINUE
      ENDIF
C ============================================================
C --- INITIALISATION DES TABLEAUX A ZERO ---------------------
C --- ET DU TABLEAU CONGEP A CONGEM --------------------------
C ============================================================
      IF ((OPTION     .EQ.'RAPH_MECA') .OR.
     +    (OPTION(1:9).EQ.'FULL_MECA')) THEN
         DO 1 I=1,DIMCON
           CONGEP(I)=CONGEM(I)
 1       CONTINUE
      ENDIF
C
      DO 2 I=1,DIMDEF
        DO 3 J=1,DIMCON
          DRDS(I,J)=0.D0
          DSDE(J,I)=0.D0
   3    CONTINUE
        R(I)=0.D0
   2  CONTINUE
C ======================================================================
C --- INITIALISATION DE LA COMPOSANTE ADDITIONNELLE DE R ET DF ---------
C --- DUE A LA DECOMPOSITION DU TERME EN TEMPERATURE (GAUSS & SOMMET): -
C --- UNE PARTIE DE LA COMPOSANTE 7 DE R(ET LA LIGNE 7 DE DF) S'INTEGRE-
C --- AU SOMMET ET L'AUTRE AU PT DE GAUSS ------------------------------
C --- ON DECIDE D'ENVOYER LA COMPOSANTE R7SOMMET A L'ADRESSE DIMDEF+1 --
C --- ET DE LAISSER R7GAUSS A L'ADRESSE ADDETE -------------------------
C ======================================================================
      R(DIMDEF+1)=0.D0

      DO 800 J=1,DIMCON
         DRDS(DIMDEF+1,J)=0.D0
 800  CONTINUE

             CALL COMTHM(OPTION,PERMAN,IMATE,TYPMOD,COMPOR,
     &             CRIT,RINSTM,RINSTP,
     &             NDIM,DIMDEF,DIMCON,NBVARI,YAMEC,YAP1,
     &             YAP2,YATE,ADDEME,ADCOME,ADDEP1,ADCP11,
     &             ADCP12,ADDEP2,ADCP21,ADCP22,ADDETE,ADCOTE,
     &             DEFGEM,DEFGEP,CONGEM,CONGEP,VINTM,VINTP,
     &             DSDE,PESA,RETCOM,KPI,NPG)
           IF (RETCOM.NE.0) THEN
            GOTO 9000
           ENDIF
C ======================================================================
C --- CALCUL DE LA CONTRAINTE VIRTUELLE R ------------------------------
C ======================================================================
      IF((OPTION(1:9).EQ.'FULL_MECA').OR.
     &   (OPTION(1:9).EQ.'RAPH_MECA')) THEN
C ======================================================================
C --- SI PRESENCE DE MECANIQUE -----------------------------------------
C ======================================================================
        IF(YAMEC.EQ.1) THEN
C
C  CONTRIBUTIONS A R2 INDEPENDANTE DE YAP1 , YAP2 ET YATE
C  CONTRAINTES SIGPRIMPLUS PAGE 33
C
          DO 6 I=1,6
            R(ADDEME+NDIM+I-1)= R(ADDEME+NDIM+I-1)
     &      +CONGEP(ADCOME-1+I)
  6       CONTINUE
C  SCALAIRE SIGPPLUS MULTIPLIE PAR LE TENSEUR UNITE PAGE 33
          DO 7 I=1,3
            R(ADDEME+NDIM-1+I)=R(ADDEME+NDIM-1+I)
     &      +CONGEP(ADCOME+6)
  7       CONTINUE
        ENDIF
C ======================================================================
C --- SI PRESENCE DE PRESS1 --------------------------------------------
C ======================================================================
        IF(YAP1.EQ.1) THEN

C  CONTRIBUTIONS A R4 DEPENDANTES DE YAP1
          DO 12 I=1,NDIM
            R(ADDEP1+I)=R(ADDEP1+I)+CONGEP(ADCP11+I-1)
  12      CONTINUE
          IF(NBPHA1.GT.1) THEN
            DO 13 I=1,NDIM
            R(ADDEP1+I)=R(ADDEP1+I)+CONGEP(ADCP12+I-1)
  13        CONTINUE
          ENDIF
C ======================================================================
C --- ON NE PASSE JAMAIS DANS CETTE BOUCLE -----------------------------
C --- ON LA LAISSE POUR UNE EVENTUELLE MODELISATION THM PERMANENTE -----
C ======================================================================
          IF(YATE.EQ.1) THEN

C   CONTRIBUTIONS A R7 !!SOMMET!! DEPENDANTES DE YAP1
C   PRODUITS ENTHALPIE MASSIQUE - APPORTS MASSE FLUIDE
            R(DIMDEF+1)=
     &      R(DIMDEF+1)-CONGEP(ADCP11)*CONGEP(ADCP11+NDIM+1)

C        PRODUITS ENTHALPIE MASSIQUE - APPORTS MASSE FLUIDE
C        CONTRIBUTION SECONDE PHASE DU FLUIDE 1
            IF(NBPHA1.GT.1) THEN
              R(DIMDEF+1)=
     &        R(DIMDEF+1)-CONGEP(ADCP12)*CONGEP(ADCP12+NDIM+1)
            ENDIF
C
C    CONTRIBUTION A R7 !!GAUSS!!
C    PRODUIT SCALAIRE GRAVITE VECTEURS COURANTS DE MASSE FLUIDE
C        PESA . MFL11
            DO 14 I=1,NDIM
              R(ADDETE)=R(ADDETE)+CONGEP(ADCP11+I)*PESA(I)
  14        CONTINUE
C        PESA . MFL12
            IF(NBPHA1.GT.1) THEN
              DO 15 I=1,NDIM
                R(ADDETE)=R(ADDETE)+CONGEP(ADCP12+I)*PESA(I)
  15          CONTINUE
            ENDIF
C
C    CONTRIBUTIONS A R8 DEPENDANTES DE YAP1
C    PRODUITS ENTHALPIE MASSIQUE - VECTEURS COURANT DE MASSE FLUIDE
            DO 16 I=1,NDIM
              R(ADDETE+I)=
     &        R(ADDETE+I)+CONGEP(ADCP11+NDIM+1)*CONGEP(ADCP11+I)
  16        CONTINUE
            IF(NBPHA1.GT.1) THEN
C        PRODUITS ENTHALPIE MASSIQUE - VECTEURS COURANT DE MASSE FLUID
C        CONTRIBUTION SECONDE PHASE DU FLUIDE 1
              DO 17 I=1,NDIM
                R(ADDETE+I)=
     &          R(ADDETE+I)+CONGEP(ADCP12+NDIM+1)*CONGEP(ADCP12+I)
  17          CONTINUE
            ENDIF
C
          ENDIF
C ======================================================================
C
        ENDIF
C ======================================================================
C --- SI PRESENCE DE PRESS2 --------------------------------------------
C ======================================================================
        IF(YAP2.EQ.1) THEN

C    CONTRIBUTIONS A R6 DEPENDANTES DE YAP2
          DO 18 I=1,NDIM
            R(ADDEP2+I)=R(ADDEP2+I)+CONGEP(ADCP21+I-1)
  18      CONTINUE
          IF(NBPHA2.GT.1) THEN
            DO 19 I=1,NDIM
              R(ADDEP2+I)=R(ADDEP2+I)+CONGEP(ADCP22+I-1)
  19        CONTINUE
          ENDIF
C ======================================================================
C --- ON NE PASSE JAMAIS DANS CETTE BOUCLE -----------------------------
C --- ON LA LAISSE POUR UNE EVENTUELLE MODELISATION THM PERMANENTE -----
C ======================================================================
          IF(YATE.EQ.1) THEN

C    CONTRIBUTIONS A R7GAUSS
C    PRODUIT SCALAIRE GRAVITE VECTEURS COURANTS DE MASSE FLUIDE
C         PESA . MFL21
            DO 20 I=1,NDIM
              R(ADDETE)=R(ADDETE)+CONGEP(ADCP21+I)*PESA(I)
  20        CONTINUE

C         PESA . MFL22
            IF(NBPHA2.GT.1) THEN
              DO 21 I=1,NDIM
                R(ADDETE)=R(ADDETE)+CONGEP(ADCP22+I)*PESA(I)
  21          CONTINUE
            ENDIF

C    CONTRIBUTIONS A R8 DEPENDANTES DE YAP2
C    PRODUITS ENTHALPIE MASSIQUE - VECTEURS COURANT DE MASSE FLUIDE
            DO 22 I=1,NDIM
              R(ADDETE+I)=
     &        R(ADDETE+I)+CONGEP(ADCP21+NDIM+1)*CONGEP(ADCP21+I)
  22        CONTINUE

C          PRODUITS ENTHALPIE MASSIQUE - VECTEURS COURANT
C          DE MASSE FLUIDE
C          CONTRIBUTION SECONDE PHASE DU FLUIDE 1
            IF(NBPHA2.GT.1) THEN
              DO 23 I=1,NDIM
                R(ADDETE+I)=
     &          R(ADDETE+I)+CONGEP(ADCP22+NDIM+1)*CONGEP(ADCP22+I)
  23          CONTINUE
            ENDIF
          ENDIF
C ======================================================================
        ENDIF
C ======================================================================
C --- SI PRESENCE DE THERMIQUE -----------------------------------------
C ======================================================================
        IF(YATE.EQ.1) THEN

C   CONTRIBUTION A R8 INDEPENDANTE DE YAMEC , YAP1 , YAP2
C         >>>>   VECTEUR COURANT DE CHALEUR
          DO 24 I=1,NDIM
            R(ADDETE+I)=R(ADDETE+I)+CONGEP(ADCOTE+I)
  24      CONTINUE
        ENDIF
      ENDIF
C ======================================================================
C --- CALCUL DES MATRICES DERIVEES CONSTITUTIVES DE DF -----------------
C ======================================================================
      IF ( (OPTION(1:9) .EQ. 'RIGI_MECA') .OR.
     &     (OPTION(1:9) .EQ. 'FULL_MECA')    ) THEN
C ======================================================================
C --- SI PRESENCE DE MECANIQUE -----------------------------------------
C ======================================================================
        IF(YAMEC.EQ.1) THEN

C    CONTRIBUTIONS A DR/DS INDEPENDANTES DE YAP1 ET YATE
C    CALCUL DE DR2/DS :
C    DR2DS:DERIVEES PAR RAPPORT AUX CONTRAINTES SIGPRIMPLUSIJ
C    TABLEAU 6 - 6 : ON N'ECRIT QUE LES TERMES NON NULS
C    (1 SUR DIAGONALE)

          DO 25 I=1,6
            DRDS(ADDEME+NDIM-1+I,ADCOME+I-1)=
     &      DRDS(ADDEME+NDIM-1+I,ADCOME+I-1)+1.D0
  25      CONTINUE
C    DR2DS:DERIVEES PAR RAPPORT AU SCALAIRE SIGPPLUS
C    >> TENSEUR ISOTROPE : ON N'ECRIT QUE LES
C    TROIS PREMIERS TERMES = 1

          DO 26 I=1,3
            DRDS(ADDEME+NDIM-1+I,ADCOME+6)=
     &      DRDS(ADDEME+NDIM-1+I,ADCOME+6)+1.D0
  26      CONTINUE
        ENDIF
C ======================================================================
C --- SI PRESENCE DE PRESS1 --------------------------------------------
C ======================================================================
        IF(YAP1.EQ.1) THEN

C     DR4P11:DERIVEE / COURANTM11PLUS  (VECTEUR COURANT MASSE FLUIDE)
          DO 28 I=1,NDIM
            DRDS(ADDEP1+I,ADCP11+I-1)=
     &      DRDS(ADDEP1+I,ADCP11+I-1)+1.D0
  28      CONTINUE

          IF(NBPHA1.GT.1) THEN

C     DR4P12:DERIVEE / COURANTM12PLUS  (VECTEUR COURANT MASSE FLUIDE)
            DO 30 I=1,NDIM
              DRDS(ADDEP1+I,ADCP12+I-1)=
     &        DRDS(ADDEP1+I,ADCP12+I-1)+1.D0
  30        CONTINUE
          ENDIF
        ENDIF
C ======================================================================
C --- SI PRESENCE DE PRESS2 --------------------------------------------
C ======================================================================
        IF(YAP2.EQ.1) THEN

C     DR6P21:DERIVEE / COURANTM21PLUS  (VECTEUR COURANT MASSE FLUIDE)
          DO 32 I=1,NDIM
            DRDS(ADDEP2+I,ADCP21+I-1)=
     &      DRDS(ADDEP2+I,ADCP21+I-1)+1.D0
  32      CONTINUE

          IF(NBPHA2.GT.1) THEN

C     DR6P22:DERIVEE / COURANTM22PLUS  (VECTEUR COURANT MASSE FLUIDE)
            DO 34 I=1,NDIM
              DRDS(ADDEP2+I,ADCP22+I-1)=
     &        DRDS(ADDEP2+I,ADCP22+I-1)+1.D0
  34        CONTINUE
          ENDIF
        ENDIF
C ======================================================================
C --- SI PRESENCE DE THERMIQUE -----------------------------------------
C ======================================================================
        IF(YATE.EQ.1) THEN

C     DR7SOMMET/DT:DERIVEE / QPRIMPLUS  (APPORT DE CHALEUR  REDUIT )
          DRDS(DIMDEF+1,ADCOTE)=DRDS(DIMDEF+1,ADCOTE)-1.D0

C     DR8DT:DERIVEE / QPLUS  (VECTEUR COURANT DE CHALEUR)
          DO 35 I=1,NDIM
            DRDS(ADDETE+I,ADCOTE+I)=DRDS(ADDETE+I,ADCOTE+I)+1.D0
  35      CONTINUE
C
          IF(YAP1.EQ.1) THEN

C     DR7SOMMET/P11:DERIVEE / M11PLUS  (APPORT MASSE FLUIDE 1)

            DRDS(DIMDEF+1,ADCP11)=
     &      DRDS(DIMDEF+1,ADCP11)-CONGEP(ADCP11+NDIM+1)

C     DR7GAUSS/P11:DERIVEE/COURANTM11PLUS : VECTEUR COURANT MASSE FLUIDE
            DO 351 I=1,NDIM
              DRDS(ADDETE,ADCP11+I)=DRDS(ADDETE,ADCP11+I)+PESA(I)
 351        CONTINUE

C     DR8P11:DERIVEE/HM11PLUS  (ENTHALPIE MASSIQUE DU FLUIDE 1)
            DO 36 I=1,NDIM
              DRDS(ADDETE+I,ADCP11+NDIM+1)=DRDS(ADDETE+I,ADCP11+NDIM+1)
     &        +CONGEP(ADCP11+I)
  36        CONTINUE

C     DR8P11:DERIVEE/COURANTM11PLUS : VECTEUR COURANT MASSE FLU1
            DO 37 I=1,NDIM
              DRDS(ADDETE+I,ADCP11+I)=DRDS(ADDETE+I,ADCP11+I)
     &        +CONGEP(ADCP11+NDIM+1)
  37        CONTINUE
C
            IF(NBPHA1.GT.1) THEN

C  R7GAUSS/P12:DERIVEE/COURANTM12PLUS : VECTEUR COURANT MASSE FL1 PH 2
              DO 371 I=1,NDIM
                DRDS(ADDETE,ADCP12+I)=DRDS(ADDETE,ADCP12+I)+PESA(I)
 371          CONTINUE

C     DR8P12:DERIVEE/HM12PLUS (ENTHALPIE MASSIQUE DU FLUIDE 1 PHASE 2)
              DO 38 I=1,NDIM
                DRDS(ADDETE+I,ADCP12+NDIM+1)=
     &          DRDS(ADDETE+I,ADCP12+NDIM+1)+CONGEP(ADCP12+I)
  38          CONTINUE

C     DR8P12:DERIVEE/COURANTM12PLUS : VECTEUR COURANT MASSE FL 1 PHASE 2
              DO 39 I=1,NDIM
                DRDS(ADDETE+I,ADCP12+I)=DRDS(ADDETE+I,ADCP12+I)
     &         +CONGEP(ADCP12+NDIM+1)
  39          CONTINUE
            ENDIF
          ENDIF
C
          IF(YAP2.EQ.1) THEN

C  DR7GAUSS/P11:DERIVEE/COURANTM11PLUS : VECTEUR COURANT MASSE FLUIDE 1
            DO 391 I=1,NDIM
              DRDS(ADDETE,ADCP21+I)=DRDS(ADDETE,ADCP21+I)+PESA(I)
 391        CONTINUE

C     DR8P21:DERIVEE/HM21PLUS  (ENTHALPIE MASSIQUE DU FLUIDE 2)
            DO 40 I=1,NDIM
             DRDS(ADDETE+I,ADCP21+NDIM+1)=DRDS(ADDETE+I,ADCP21+NDIM+1)
     &        +CONGEP(ADCP21+I)
  40        CONTINUE

C     DR8P21:DERIVEE/COURANTM21PLUS : VECTEUR COURANT MASSE FLUIDE 2
            DO 41 I=1,NDIM
              DRDS(ADDETE+I,ADCP21+I)=DRDS(ADDETE+I,ADCP21+I)
     &        +CONGEP(ADCP21+NDIM+1)
  41        CONTINUE
C
            IF(NBPHA2.GT.1) THEN

C DR7GAUSS/P22:DERIVEE/COURANTM12PLUS:VECTEUR COURANT MASSE FL 2 PH 2
              DO 411 I=1,NDIM
                DRDS(ADDETE,ADCP22+I)=DRDS(ADDETE,ADCP22+I)+PESA(I)
 411          CONTINUE
C     DR8P22:DERIVEE/HM22PLUS (ENTHALPIE MASSIQUE DU FLUIDE 2 PHASE 2)
              DO 42 I=1,NDIM
                DRDS(ADDETE+I,ADCP22+NDIM+1)=
     &          DRDS(ADDETE+I,ADCP22+NDIM+1)+CONGEP(ADCP22+I)
  42          CONTINUE

C     DR8P22:DERIVEE/COURANTM22PLUS : VECTEUR COURANT MASSE FL 2 PHASE 2
              DO 43 I=1,NDIM
                DRDS(ADDETE+I,ADCP22+I)=DRDS(ADDETE+I,ADCP22+I)
     &         +CONGEP(ADCP22+NDIM+1)
  43          CONTINUE
            ENDIF
          ENDIF
C
        ENDIF

      ENDIF
C ======================================================================
C --- FIN DU CALCUL DE DF ----------------------------------------------
C ======================================================================
C --- COMME CONGEP DOIT FINALEMENT CONTENIR LES VRAIES CONTRAINTES -----
C --- ET COMME ON A TRAVAILLE AVEC SQRT(2)*SXY -------------------------
C --- ON MODIFIE LES CONGEP EN CONSEQUENCE -----------------------------
C ======================================================================
      IF ((YAMEC.EQ.1).AND.
     +   ((OPTION     .EQ.'RAPH_MECA') .OR.
     +    (OPTION(1:9).EQ.'FULL_MECA'))) THEN
          DO 110 I = 4 , 6
             CONGEP(ADCOME+I-1)= CONGEP(ADCOME+I-1)/RAC2
 110    CONTINUE
      ENDIF
C ======================================================================
 9000 CONTINUE
C ======================================================================
      END

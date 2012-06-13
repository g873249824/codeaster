      SUBROUTINE WPSORC
     &  (LMASSE, LAMOR, LMATRA, NBEQ,
     &   NBVECT, NFREQ, TOLSOR, VECT, RESID, WORKD, WORKL, LONWL,
     &   SELEC, DSOR, SIGMA, VAUX,WORKV, DDLEXC, DDLLAG,
     &   NEQACT, MAXITR, IFM, NIV, PRIRAM, ALPHA, NCONV,
     &   FLAGE,VAUC,RWORK,SOLVEU)
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C ======================================================================
C TOLE CRP_21
C
C     SUBROUTINE ASTER ORCHESTRANT LA METHODE DE SORENSEN: UN ARNOLDI
C     COMPLEXE AVEC REDEMARRAGE IMPLICITE VIA QR (VERSION ARPACK 2.8).
C     CAS QUADRATIQUE COMPLEXE
C---------------------------------------------------------------------
C     PARTANT DU PROBLEME QUADRATIQUE AUX VALEURS PROPRES
C      REDUCTION A UN PROBLEME GENERALISE
C
C         !K   0! !P!          !-C   -M! !P!
C         !     ! ! ! = LAMBDA !       ! ! ! <=> K.G*Z = LAMBDA*M.G*Z
C         !0  -M! !Q!          !-M    0! !Q!
C
CC     AVEC
C      - LES MATRICES SYMETRIQUES (A) ET (B), CORRESPONDANT AUX
C     MATRICES DE RAIDEUR ET A CELLE DE MASSE (RESP. RAIDEUR GEOMETRIQUE
C     , EN FLAMBEMENT),
C      - LE COMPLEXE, LAMBDA, CORRESPONDANT AU CARRE DE LA PULSATION
C      - LE OU LES VECTEURS PROPRES COMPLEXES ASSOCIES, X,
C        (A- ET B- ORTHOGONAUX ENTRE EUX AINSI QU'AVEC CEUX DES AUTRES
C        VALEURS PROPRES).
C
C     ON RESOUT LE PROBLEME STANDARD
C                             (OP)*X =  MU*X
C     AVEC
C       - L'OPERATEUR SHIFTE (OP) = INV((A)-SIGMA*(B))*(B),
C       - LE 'SHIFT' COMPLEXE SIGMA,
C       - LA VALEUR PROPRE MU = 1/(LAMBDA-SIGMA),
C       - LE OU LES MEMES VECTEURS PROPRES QU'INITIALEMENT, X.
C   ------------------------------------------------------------------
C   CETTE METHODE, PARTANT D'UNE FACTORISATION DE TYPE ARNOLDI D'ORDRE
C   M=K+P DU PROBLEME, PILOTE UN RESTART A L'ORDRE K SUR P NOUVELLES
C   ITERATIONS. CE RESTART PERMET D'AMELIORER LES K PREMIERES VALEURS
C   PROPRES SOUHAITEES, LES P DERNIERES SERVANT UNIQUEMENT AUX CALCULS
C   AUXILIAIRES.
C   ELLE PERMET
C     - DE MINIMISER LA TAILLE DU SOUS-ESPACE DE PROJECTION,
C     - D'EFFECTUER DES RESTARTS DE MANIERE TRANSPARENTE, EFFICACE ET
C       AVEC DES PRE-REQUIS MEMOIRE FIXES,
C     - DE MIEUX PRENDRE EN COMPTE LES MULTIPLICITES,
C     - DE TRAITER AVEC UN BON COMPROMIS LA STRATEGIE DE RE-ORTHONORMA
C       LISATION.
C   ------------------------------------------------------------------
C     PARAMETRES D'APPELS:
C
C IN  LMASSE : IS : DESCRIPTEUR MATRICE DE "MASSE".
C IN  LMATRA : IS : DESCRIPTEUR MATRICE DE "RAIDEUR"-SHIFT"MASSE"
C                     FACTORISEE.
C IN  NBEQ   : IS : DIMENSION DES VECTEURS.
C IN  NBVECT : IS : DIMENSION DE L'ESPACE DE PROJECTION.
C IN  NFREQ  : IS : NOMBRE DE VALEURS PROPRES DEMANDEES.
C IN  TOLSOR : R8 : NORME D'ERREUR SOUHAITEE (SI 0.D0 ALORS LA VALEUR
C                   PAR DEFAUT EST LA PRECISION MACHINE).
C IN  LONWL  : IS : TAILLE DU VECTEUR DE TRAVAIL WORKL.
C IN  FSHIFT : C8 : VALEUR DU SHIFT SIGMA EN OMEGA2.
C IN  DDLEXC : IS : DDLEXC(1..NBEQ) VECTEUR POSITION DES DDLS BLOQUES.
C IN  DDLLAG : IS : DDLLAG(1..NBEQ) VECTEUR POSITION DES LAGRANGES.
C IN  NEQACT : IS : NOMBRE DE DDLS ACTIFS.
C IN  MAXITR : IS : NOMBRE MAXIMUM DE RESTARTS.
C IN  IFM    : IS : UNITE LOGIQUE D'IMPRESSION DES .MESS
C IN  NIV    : IS : NIVEAU D'IMPRESSION
C IN  PRIRAM : IS : PRIRAM(1..8) VECTEUR NIVEAU D'IMPRESSION ARPACK
C IN  ALPHA  : R8 : PARAMETRE VPGSKP D'ORTHONORMALISATION.
C IN  OMECOR : R8 : OMEGA2 DE CORPS RIGIDE
C
C OUT VECT   : C8 : VECT(1..2*NBEQ,1..NBVECT) MATRICE DES
C                   VECTEURS D'ARNOLDI.
C OUT RESID  : C8 : RESID(1..2*NBEQ) VECTEUR RESIDU.
C OUT WORKD  : C8 : WORKD(1..6*NBEQ) VECTEUR DE TRAVAIL PRIMAIRE IRAM
C OUT WORKL  : C8 : WORKL(1..LONWL) VECTEUR DE TRAVAIL SECONDAIRE IRAM
C OUT SELEC  : LS : SELEC(1..NBVECT) VECTEUR DE TRAVAIL POUR DNEUPD.
C OUT DSOR   : C8 : DSOR(1..NFREQ+1) MATRICE DES VALEURS PROPRES.
C OUT VAUX   : C8 : VAUX(1..2*NBEQ) VECTEUR DE TRAVAIL POUR WPSORC.
C OUT RWORK  : C8 : RWORK(1..2*NBEQ) VECTEUR DE TRAVAIL REEL.
C OUT WORKV  : C8 : WORKV(1..6*NBVECT) VECTEUR DE TRAVAIL POUR DNEUPD
C OUT NCONV  : IS : NOMBRE DE MODES CONVERGES.
C OUT FLAGE  : LO : FLAG PERMETTANT DE GERER LES IMPRESSIONS
C IN  SOLVEU : K19 : SD SOLVEUR POUR PARAMETRER LE SOLVEUR LINEAIRE
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE


C DECLARATION PARAMETRES D'APPELS
      INCLUDE 'jeveux.h'
      INTEGER LMASSE, LMATRA, NBEQ, NBVECT, NFREQ, LONWL, DDLEXC(*),
     &  DDLLAG(*), NEQACT, MAXITR, IFM, NIV, PRIRAM(8), NCONV,
     &  LAMOR
      REAL*8  TOLSOR, ALPHA, RWORK(*)
      REAL*8 VALR
      LOGICAL SELEC(*), FLAGE
      COMPLEX*16  SIGMA, VECT(NBEQ,*), DSOR(*), RESID(*),
     &  WORKD(*), WORKL(*), VAUX(*), VAUC(2*NBEQ,*), WORKV(*)
      CHARACTER*19 SOLVEU
C--------------------------------------------------------------------
C DECLARATION VARIABLES LOCALES

C POUR LE FONCTIONNEMENT GLOBAL
      INTEGER    I, J
      INTEGER VALI(11)
      INTEGER    AU1,AU2,AU3,AU5

C POUR ARPACK
      INTEGER     IDO, INFO, ISHFTS, MODE, IPARAM(11),IPNTR(14)
      LOGICAL     RVEC
      CHARACTER*1 BMAT
      CHARACTER*2 WHICH

      INTEGER LOGFIL, NDIGIT, MGETV0,
     &  MNAUPD, MNAUP2, MNAITR, MNEIGH, MNAPPS, MNGETS, MNEUPD
      COMMON /DEBUG/
     &  LOGFIL, NDIGIT, MGETV0,
     &  MNAUPD, MNAUP2, MNAITR, MNEIGH, MNAPPS, MNGETS, MNEUPD
C------------------------------------------------------------------
C INITIALISATION POUR ARPACK

C NIVEAU D'IMPRESSION ARPACK
      NDIGIT = -3
      LOGFIL = IFM
      MGETV0 = PRIRAM(1)
      MNAUPD = PRIRAM(2)
      MNAUP2 = PRIRAM(3)
      MNAITR = PRIRAM(4)
      MNEIGH = PRIRAM(5)
      MNAPPS = PRIRAM(6)
      MNGETS = PRIRAM(7)
      MNEUPD = PRIRAM(8)

C FONCTIONNEMENT D'ARPACK
      IDO = 0
      INFO = 0
      ISHFTS = 1
      MODE = 3
      RVEC = .TRUE.
      BMAT  = 'G'
      WHICH = 'LM'
      IPARAM(1) = ISHFTS
      IPARAM(3) = MAXITR
      IPARAM(4) = 1
      IPARAM(7) = MODE
C------------------------------------------------------------------
C BOUCLE PRINCIPALE

      CALL JEMARQ()
C     ---- ALLOCATION DES ZONES DE TRAVAIL ---
      CALL WKVECT('&&WPSORC.VECTEUR.AUX.U1R','V V C',NBEQ,AU1  )
      CALL WKVECT('&&WPSORC.VECTEUR.AUX.U2R','V V C',NBEQ,AU2  )
      CALL WKVECT('&&WPSORC.VECTEUR.AUX.U3R','V V C',NBEQ,AU3  )
      CALL WKVECT('&&WPSORC.VECTEUR.AUX.U5C','V V C',2*NBEQ,AU5)
C      CALL WKVECT('&&WPSORC.VECTEUR.AUX.VC ','V V C',NBEQ,AV   )
C******************************************************************
 20   CONTINUE

C CALCUL DES VALEURS PROPRES DE (OP)
      CALL ZNAUPD
     &  (IDO, BMAT, 2*NBEQ, WHICH, NFREQ, TOLSOR, RESID, NBVECT,
     &   VAUC, 2*NBEQ, IPARAM, IPNTR, WORKD, WORKL, LONWL, RWORK,
     &   INFO,2*NEQACT, ALPHA)

C NOMBRE DE MODES CONVERGES
      NCONV = IPARAM(5)

C GESTION DES FLAGS D'ERREURS
      IF ((INFO.EQ.1).AND.(NIV.GE.1)) THEN
        WRITE(IFM,*)
        WRITE(IFM,*)'<WPSORC/ZNAUPD 1> NOMBRE MAXIMAL D''ITERATIONS'
        WRITE(IFM,*)' NMAX_ITER_SOREN = ',MAXITR,' A ETE ATTEINT !'
        WRITE(IFM,*)
      ELSE IF (INFO.EQ.2) THEN
        CALL U2MESS('F','ALGELINE3_72')
      ELSE IF ((INFO.EQ.3).AND.(NIV.GE.1)) THEN
        WRITE(IFM,*)
        WRITE(IFM,*)'<WPSORC/ZNAUPD 3> AUCUN SHIFT NE PEUT ETRE'//
     &   ' APPLIQUE'
        WRITE(IFM,*)
      ELSE IF (INFO.EQ.-7) THEN
        CALL U2MESS('F','ALGELINE3_73')
      ELSE IF (INFO.EQ.-8) THEN
        CALL U2MESS('F','ALGELINE3_74')
      ELSE IF (INFO.EQ.-9) THEN
        CALL U2MESS('F','ALGELINE3_75')
      ELSE IF ((INFO.EQ.-9999).AND.(NIV.GE.1)) THEN
        WRITE(IFM,*)
        WRITE(IFM,*)'<WPSORC/ZNAUPD -9999> PROBLEME FACTORISATION'//
     &    ' D''ARNOLDI'
        WRITE(IFM,*)
      ELSE IF (INFO.LT.0) THEN
          VALI (1) = INFO
        CALL U2MESG('F', 'ALGELINE4_82',0,' ',1,VALI,0,0.D0)
      ENDIF
C
C GESTION DES MODES CONVERGES
      IF ((NCONV.LT.NFREQ).AND.(IDO.EQ.99)) THEN
          VALI (1) = NCONV
          VALI (2) = NFREQ
          VALI (3) = INFO
          VALI (4) = NBVECT
          VALI (5) = MAXITR
          VALR = TOLSOR
        CALL U2MESG('A', 'ALGELINE4_98',0,' ',5,VALI,1,VALR)
        FLAGE = .FALSE.
      ENDIF

C---------------------------------------------------------------------
C ZONE GERANT LA 'REVERSE COMMUNICATION' VIA IDO

      IF (IDO .EQ. -1) THEN
C CALCUL DU Y = (OP)*X INITIAL
C 1/ CALCUL D'UN ELT. INITIAL X REPONDANT AU C.I. DE LAGRANGE
C 2/ CALCUL DE Y = (OP)* X AVEC DDL CINEMATIQUEMENT BLOQUES
C X <- X*DDL_LAGRANGE
        DO 25 J=1,NBEQ
          VAUX(J) = 0.D0 * WORKD(IPNTR(1)+J-1) * DDLLAG(J)
          VAUX(J+NBEQ) = WORKD(IPNTR(1)+NBEQ+J-1)*DDLLAG(J)
   25   CONTINUE
          CALL WP2AYC(LMATRA,LMASSE,LAMOR,SIGMA,DDLEXC,
     &            VAUX(1),VAUX(NBEQ+1),WORKD(IPNTR(1)),
     &            WORKD(IPNTR(1)+NBEQ),
     &            ZC(AU1),ZC(AU2),ZC(AU3),NBEQ,SOLVEU)
        DO 30 J= 1,NBEQ
          VAUX(J) = WORKD(IPNTR(1)+J-1) * DDLEXC(J)
          VAUX(J+NBEQ) = WORKD(IPNTR(1)+NBEQ+J-1)*DDLEXC(J)
   30   CONTINUE
          CALL WP2AYC(LMATRA,LMASSE,LAMOR,SIGMA,DDLEXC,
     &            VAUX(1),VAUX(NBEQ+1),WORKD(IPNTR(1)),
     &            WORKD(IPNTR(1)+NBEQ),
     &            ZC(AU1),ZC(AU2),ZC(AU3),NBEQ,SOLVEU)
C RETOUR VERS DNAUPD
        DO 40 J=1,NBEQ
          WORKD(IPNTR(2)+J-1) = WORKD(IPNTR(1)+J-1) *DDLEXC(J)
          WORKD(IPNTR(2)+NBEQ+J-1) = WORKD(IPNTR(1)+NBEQ+J-1)*DDLEXC(J)
   40   CONTINUE
        GOTO 20

      ELSE IF ( IDO .EQ. 1) THEN
C CALCUL DU Y = (OP)*X CONNAISSANT DEJA (B)*X (EN FAIT ON CONNAIT
C SEULEMENT (ID)*X VIA IDO= 2 CAR PRODUIT SCALAIRE= L2)
C X <- (OP)*X
        DO 45 J=1,NBEQ
          WORKD(IPNTR(3)+J-1) = WORKD(IPNTR(3)+J-1)*DDLEXC(J)
          WORKD(IPNTR(3)+NBEQ+J-1) = WORKD(IPNTR(3)+NBEQ+J-1)*DDLEXC(J)
   45   CONTINUE
        CALL WP2AYC(LMATRA,LMASSE,LAMOR,SIGMA,DDLEXC,
     &    WORKD(IPNTR(3)),WORKD(IPNTR(3)+NBEQ),VAUX(1),VAUX(NBEQ+1),
     &            ZC(AU1),ZC(AU2),ZC(AU3),NBEQ,SOLVEU)
C RETOUR VERS DNAUPD
        DO 50 J=1,NBEQ
          WORKD(IPNTR(2)+J-1) = VAUX(J) * DDLEXC(J)
          WORKD(IPNTR(2)+NBEQ+J-1) = VAUX(J+NBEQ) * DDLEXC(J)
   50   CONTINUE
        GOTO 20

      ELSE IF ( IDO .EQ. 2) THEN
C X <- X*DDL_BLOQUE  (PRODUIT SCALAIRE= L2)
         DO 55 J=1,NBEQ
           WORKD(IPNTR(2)+J-1)=WORKD(IPNTR(1)+J-1) * DDLEXC(J)
           WORKD(IPNTR(2)+NBEQ+J-1)=WORKD(IPNTR(1)+NBEQ+J-1)* DDLEXC(J)
   55   CONTINUE
C RETOUR VERS DNAUPD
        GOTO 20

      END IF
C--------------------------------------------------------------------
C CALCUL DES MODES PROPRES APPROCHES DU PB INITIAL
       INFO = 0
       CALL ZNEUPD
     &   (RVEC, 'A', SELEC, DSOR, VAUC, 2*NBEQ,
     &    SIGMA, WORKV, BMAT, 2*NBEQ, WHICH, NFREQ, TOLSOR,
     &    RESID, NBVECT, VAUC, 2*NBEQ, IPARAM, IPNTR, WORKD,
     &    WORKL, LONWL, RWORK, INFO)


C GESTION DES FLAGS D'ERREURS
        IF (INFO.EQ.1) THEN
          CALL U2MESS('F','ALGELINE3_74')
        ELSE IF (INFO.EQ.-7) THEN
          CALL U2MESS('F','ALGELINE3_73')
        ELSE IF (INFO.EQ.-8) THEN
          CALL U2MESS('F','ALGELINE3_98')
        ELSE IF (INFO.EQ.-9) THEN
          CALL U2MESS('F','ALGELINE3_99')
        ELSE IF (INFO.EQ.-14) THEN
          CALL U2MESS('F','ALGELINE3_78')
        ELSE IF (INFO.LT.0) THEN
          VALI (1) = INFO
          CALL U2MESG('F', 'ALGELINE4_82',0,' ',1,VALI,0,0.D0)
        ENDIF
C--------------------------------------------------------------------
C TESTS ET POST-TRAITEMENTS

C POUR TEST
C      DO 59 J=1,NCONV
C       WRITE(IFM,*) '******** VALEUR DE RITZ N ********',J
C       WRITE(IFM,*)abs(DSOR(J)-SIGMA),
C     &             DIMAG(DSOR(J))/6.28D0,-DBLE(DSOR(J))/ABS(DSOR(J))
C  59  CONTINUE

C TRI DES MODES PROPRES PAR RAPPORT AU NCONV DSOR(I)
      CALL VPORDC(1, 0, NCONV, DSOR, VAUC, 2*NBEQ)

      DO 337 J=1,NCONV
        DO 338 I=1,NBEQ
C     --- REMPLISSAGE DU VECT PAR LA PARTIE BASSE DE VAUC
          VECT(I,J)= VAUC(I+NBEQ,J)
  338   CONTINUE
  337 CONTINUE

C     --- DESTRUCTION DES OJB TEMPORAIRES
      CALL JEDETC('V','&&WPSORC',1)
      CALL JEDEMA()

      END

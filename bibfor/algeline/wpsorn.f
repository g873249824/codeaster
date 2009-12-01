      SUBROUTINE WPSORN
     &  (APPR, LMASSE, LAMOR, LMATRA, NBEQ,
     &   NBVECT, NFREQ, TOLSOR, VECT, RESID, WORKD, WORKL, LONWL,
     &   SELEC, DSOR, VPR, VPI, SIGMA, VAUX,WORKV, DDLEXC, DDLLAG,
     &   NEQACT, MAXITR, IFM, NIV, PRIRAM, ALPHA, NCONV,
     &   FLAGE,VAUR,VAUC,VAUL)
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 12/01/2009   AUTEUR SELLENET N.SELLENET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C---------------------------------------------------------------------
C
C     SUBROUTINE ASTER ORCHESTRANT LA METHODE DE SORENSEN: UN ARNOLDI
C     COMPLEXE AVEC REDEMARRAGE IMPLICITE VIA QR (VERSION ARPACK 2.8).
C     CAS QUADRATIQUE REEL
C---------------------------------------------------------------------
C     PARTANT DU PROBLEME QUADRATIQUE AUX VALEURS PROPRES
C      REDUCTION A UN PROBLEME GENERALISE
C
C         !K   0! !P!          !-C   -M! !P!
C         !     ! ! ! = LAMBDA !       ! ! ! <=> K.G*Z = LAMBDA*M.G*Z
C         !0  -M! !Q!          !-M    0! !Q!
C
C     AVEC
C      - LES MATRICES SYMETRIQUES (A) ET (B), CORRESPONDANT AUX
C     MATRICES DE RAIDEUR ET A CELLE DE MASSE (RESP. RAIDEUR GEOMETRIQUE
C     , EN FLAMBEMENT),
C      - LE COMPLEXE, LAMBDA, CORRESPONDANT AU CARRE DE LA PULSATION
C      - LE OU LES VECTEURS PROPRES COMPLEXES ASSOCIES, X,
C        (A- ET B- ORTHOGONAUX ENTRE EUX AINSI QU'AVEC CEUX DES AUTRES
C        VALEURS PROPRES).
C
C  ------------------------------------------------------------------
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
C   -------------------------------------------------------------------
C     SUBROUTINES APPELLEES:
C
C       DNAUPD -> (SUBROUTINE ISSUE DU PACKAGE ARPACK 2.5 RELEASE 2)
C         CALCUL DES VALEURS PROPRES DE (OP) EN COMMUNIQUANT LES DONNEES
C         MECANIQUE EN 'REVERSE COMMUNICATION MODE' VIA L'INTEGER IDO.
C       DNEUPD -> (SUBROUTINE ISSUE DU PACKAGE ARPACK 2.5 RELEASE 2)
C         CALCUL ET FILTRAGE DES MODES PROPRES DU PROBLEME INITIAL.
C       VPGSKP    -> (SUBROUTINE IMPLANTANT LA METHODE DE KAHAN-PARLET)
C         (A)- ET (B)- ORTHONORMALISATION DES VECTEURS PROPRES.
C       RLDLGG -> (SUBROUTINE ASTER)
C         RESOLUTION DE SYSTEME LDLT.
C       MRMULT -> (SUBROUTINE ASTER)
C         PRODUIT MATRICE-VECTEUR.
C       VPORDO -> (SUBROUTINE ASTER)
C         REMISE EN ORDRE DES MODES PROPRES.
C
C     FONCTIONS INTRINSEQUES:
C
C       ABS.
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
C IN  FSHIFT : R8 : VALEUR DU SHIFT SIGMA EN OMEGA2.
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
C OUT VECT   : R8 : VECT(1..NBEQ,1..NBVECT) MATRICE DES
C                   VECTEURS D'ARNOLDI.
C OUT RESID  : R8 : RESID(1..NBEQ) VECTEUR RESIDU.
C OUT WORKD  : R8 : WORKD(1..3*NBEQ) VECTEUR DE TRAVAIL PRIMAIRE IRAM
C OUT WORKL  : R8 : WORKL(1..LONWL) VECTEUR DE TRAVAIL SECONDAIRE IRAM
C OUT SELEC  : LS : SELEC(1..NBVECT) VECTEUR DE TRAVAIL POUR DNEUPD.
C OUT DSOR   : R8 : DSOR(1..NFREQ+1,1..2) MATRICE DES VALEURS PROPRES.
C OUT VAUX   : R8 : VAUX(1..NBEQ) VECTEUR DE TRAVAIL POUR WPSORN.
C OUT WORKV  : R8 : WORKV(1..3*NBVECT) VECTEUR DE TRAVAIL POUR DNEUPD
C                     ET VPGSKP.
C OUT NCONV  : IS : NOMBRE DE MODES CONVERGES.
C OUT FLAGE  : LO : FLAG PERMETTANT DE GERER LES IMPRESSIONS
C
C ASTER INFORMATION
C 11/01/2000 TOILETTAGE DU FORTRAN SUIVANT LES REGLES ASTER,
C 23/03/2000 PASSAGE OMECOR POUR TESTS SI IM(VP) < 0, TRANSF DU MSG,
C            CHANGEMENT MSGS DNAUPD/1 ET 3, DNEUPD/-14 ET 0,
C            CHANGEMENT UTMESS(F.. EN UTMESS(S.. POUR NCONV < NFREQ,
C            SORTIE NCONV ET FLAGE POUR OP0045.
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C----------- DECLARATION DES COMMUNS NORMALISES JEVEUX -----------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16    ZK16
      CHARACTER*24    ZK24
      CHARACTER*32    ZK32
      CHARACTER*80    ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C----------- FIN DES COMMUNS NORMALISES JEVEUX -------------------

C DECLARATION PARAMETRES D'APPELS
      CHARACTER*1       APPR
      INTEGER LMASSE, LMATRA, NBEQ, NBVECT, NFREQ, LONWL, DDLEXC(*),
     &  DDLLAG(*), NEQACT, MAXITR, IFM, NIV, PRIRAM(8), NCONV, LAMOR
      REAL*8  TOLSOR, RESID(*), WORKD(*),
     &  WORKL(*), VAUX(*),
     &  VAUR(2*NBEQ,*),VPR(*),VPI(*),
     &  WORKV(*), ALPHA, DSOR(NFREQ+1,*)
      LOGICAL SELEC(*), FLAGE
      COMPLEX*16  SIGMA, VECT(NBEQ,*), VAUC(2*NBEQ,*), VAUL(2*NBEQ,*)
C--------------------------------------------------------------------
C DECLARATION VARIABLES LOCALES

C POUR LE FONCTIONNEMENT GLOBAL
      INTEGER    I, J
      INTEGER VALI(11)
      INTEGER    AU1,AU2,AU3,AU5,AV

C POUR ARPACK
      INTEGER     IDO, INFO, ISHFTS, MODE, IPARAM(11),IPNTR(14)
      REAL*8      SIGMAR, SIGMAI
      REAL*8 VALR
      LOGICAL     RVEC
      CHARACTER*1 BMAT
      CHARACTER*2 WHICH

      INTEGER LOGFIL, NDIGIT, MGETV0,
     &  MNAUPD, MNAUP2, MNAITR, MNEIGH, MNAPPS, MNGETS, MNEUPD
      COMMON /DEBUG/
     &  LOGFIL, NDIGIT, MGETV0,
     &  MNAUPD, MNAUP2, MNAITR, MNEIGH, MNAPPS, MNGETS, MNEUPD
C------------------------------------------------------------------
      DO 10 I=1,11
         IPARAM(I) = 0
   10 CONTINUE

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
      IF (APPR.EQ.'R') THEN
        MODE = 3
      ELSE
        MODE = 4
      ENDIF
      SIGMAR = DBLE(SIGMA)
      SIGMAI = DIMAG(SIGMA)
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
      CALL WKVECT('&&WPSORN.VECTEUR.AUX.U1R','V V R',NBEQ,AU1  )
      CALL WKVECT('&&WPSORN.VECTEUR.AUX.U2R','V V R',NBEQ,AU2  )
      CALL WKVECT('&&WPSORN.VECTEUR.AUX.U3R','V V R',NBEQ,AU3  )
      CALL WKVECT('&&WPSORN.VECTEUR.AUX.U5C','V V C',2*NBEQ,AU5)
      CALL WKVECT('&&WPSORN.VECTEUR.AUX.VC ','V V C',NBEQ,AV   )
C******************************************************************
 20   CONTINUE

C CALCUL DES VALEURS PROPRES DE (OP)
      CALL DNAUPD
     &  (IDO, BMAT, 2*NBEQ, WHICH, NFREQ, TOLSOR, RESID, NBVECT,
     &   VAUR, 2*NBEQ, IPARAM, IPNTR, WORKD, WORKL, LONWL, INFO,
     &   2*NEQACT, ALPHA)

C NOMBRE DE MODES CONVERGES
      NCONV = IPARAM(5)

C GESTION DES FLAGS D'ERREURS
      IF ((INFO.EQ.1).AND.(NIV.GE.1)) THEN
        WRITE(IFM,*)
        WRITE(IFM,*)'<WPSORN/DNAUPD 1> NOMBRE MAXIMAL D''ITERATIONS'
        WRITE(IFM,*)' NMAX_ITER_SOREN = ',MAXITR,' A ETE ATTEINT !'
        WRITE(IFM,*)
      ELSE IF (INFO.EQ.2) THEN
        CALL U2MESS('F','ALGELINE3_72')
      ELSE IF ((INFO.EQ.3).AND.(NIV.GE.1)) THEN
        WRITE(IFM,*)
        WRITE(IFM,*)'<WPSORN/DNAUPD 3> AUCUN SHIFT NE PEUT ETRE'//
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
        WRITE(IFM,*)'<WPSORN/DNAUPD -9999> PROBLEME FACTORISATION'//
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
          CALL WP2AY1(APPR,LMATRA,LMASSE,LAMOR,SIGMA,DDLEXC,
     &            VAUX(1),VAUX(NBEQ+1),WORKD(IPNTR(1)),
     &            WORKD(IPNTR(1)+NBEQ),
     &            ZR(AU1),ZR(AU2),ZR(AU3),ZC(AV),NBEQ)
        DO 30 J= 1,NBEQ
          VAUX(J) = WORKD(IPNTR(1)+J-1) * DDLEXC(J)
          VAUX(J+NBEQ) = WORKD(IPNTR(1)+NBEQ+J-1)*DDLEXC(J)
   30   CONTINUE
          CALL WP2AY1(APPR,LMATRA,LMASSE,LAMOR,SIGMA,DDLEXC,
     &            VAUX(1),VAUX(NBEQ+1),WORKD(IPNTR(1)),
     &            WORKD(IPNTR(1)+NBEQ),
     &            ZR(AU1),ZR(AU2),ZR(AU3),ZC(AV),NBEQ)
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
        CALL WP2AY1(APPR,LMATRA,LMASSE,LAMOR,SIGMA,DDLEXC,
     &    WORKD(IPNTR(3)),WORKD(IPNTR(3)+NBEQ),VAUX(1),VAUX(NBEQ+1),
     &            ZR(AU1),ZR(AU2),ZR(AU3),ZC(AV),NBEQ)
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
       CALL DNEUPD
     &   (RVEC, 'A', SELEC, DSOR, DSOR(1,2), VAUR, 2*NBEQ,
     &    SIGMAR, SIGMAI, WORKV, BMAT, 2*NBEQ, WHICH, NFREQ, TOLSOR,
     &    RESID, NBVECT, VAUR, 2*NBEQ, IPARAM, IPNTR, WORKD,
     &    WORKL, LONWL, INFO)

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
C       WRITE(IFM,*) 'RE: LANDAJ/ FJ INIT',DSOR(J,1)
C       WRITE(IFM,*) 'IM: LANDAJ/ FJ INIT',DSOR(J,2)
C  59  CONTINUE

      DO 333 J = 1, NCONV
         VPR(J) = DSOR(J,1)
         VPI(J) = DSOR(J,2)
333   CONTINUE

C      REMPLISSAGE DE VAUC AVEC VAUR
C     DNEUPD SORT LES VECTEURS COMPLEXES PAR COLONNE
C     PARTIE REELLE PUIS PARTIE IMAGINAIRE SANS LES CONJUGUES


      DO 340 J=2,NCONV,2
        DO 341 I=1,2*NBEQ
          VAUL(I,J/2)=DCMPLX(VAUR(I,J-1),VAUR(I,J))
  341   CONTINUE
  340 CONTINUE


      DO 335 J=2,NCONV,2
        DO 336 I=1,2*NBEQ
          VAUC(I,J-1)=VAUL(I,J/2)
          VAUC(I,J)=DCONJG(VAUL(I,J/2))
  336   CONTINUE
  335 CONTINUE
C*****************************************************************

      DO 337 J=1,NCONV
        DO 338 I=1,NBEQ
C     --- REMPLISSAGE DU VECT PAR LA PARTIE BASSE DE VECTA
          VECT(I,J)= VAUC(I+NBEQ,J)
  338   CONTINUE
  337 CONTINUE


C     --- DESTRUCTION DES OJB TEMPORAIRES
      CALL JEDETC('V','&&WPSORN',1)
      CALL JEDEMA()

C FIN DE WPSORN

      END

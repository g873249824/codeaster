      SUBROUTINE ALITMI ( NP1,NP2,NP3,NP4,N2,NBM,NBMCD,ICOUPL,TC,DT0,DT,
     &    VECDT,NBNL,ICHOC,ITEST,INDNEW,INDNE0,IDECRT,
     &    FTEST,FTEST0,ICONFB,TCONF1,TCONF2,TCONFE,TYPCH,NBSEG,
     &    PHII,CHOC,ALPHA,BETA,GAMMA,ORIG,RC,THETA,OLD,OLDIA,ITFORN,
     &    VGAP,VECR4,XSI0,INDIC,TPFL,VECI1,VECR1,VECR2,VECR5,VECR3,
     &    MASGI,AMORI,PULSI,AMOR,AMOR0,PULS,PULS0,
     &    ACCG0,VITG0,DEPG0,VITGE,DEPGE,VITG,DEPG,VITGC,DEPGC,
     &    VITGT,DEPGT,VITG0T,DEPG0T,
     &    CMOD0,KMOD0,CMOD,KMOD,CMODCA,KMODCA,AMFLU0,AMFLUC,CMODFA,
     &    LOCFLC,NPFTS,TEXTTS,FEXTTS,NDEF,INDT,
     &    FEXMOD,FNLMOD,FMRES,FMODA,FMOD0,FMOD00,FMODT,FMOD0T,
     &    DIV,TOL,TOLC,TOLN,TOLV,INTGE1,INTGE2,INDX,INDXF,
     &    FTMP,MTMP1,MTMP2,MTMP6,
     &    TTR,U,W,DD,LOC,VVG,VG,VG0,VD,VD0,
     &    RR,RR0,RI,PREMAC,PREREL,TRANS,PULSD,S0,Z0,SR0,ZA1,ZA2,ZA3,ZIN)
C
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/01/2010   AUTEUR MACOCCO K.MACOCCO 
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
C TOLE  CRP_21
C-----------------------------------------------------------------------
C DESCRIPTION : PROCEDURE DE CALCUL DU VECTEUR D'ETAT A L'INSTANT N+1
C -----------   EN FONCTION DU VECTEUR D'ETAT A L'INSTANT N
C
C               APPELANT : MDITM2
C
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C ARGUMENTS
C ---------
      INTEGER       NP1, NP2, NP3, NP4, N2, NBM, NBMCD, ICOUPL
      REAL*8        TC, DT0, DT, VECDT(*)
      INTEGER       NBNL, ICHOC, ITEST, INDNEW, INDNE0, IDECRT
      REAL*8        FTEST, FTEST0
      INTEGER       ICONFB(*)
      REAL*8        TCONF1(4,*), TCONF2(4,*), TCONFE(4,*)
      INTEGER       TYPCH(*), NBSEG(*)
      REAL*8        PHII(NP2,NP1,*),
     &              CHOC(6,*), ALPHA(2,*), BETA(2,*), GAMMA(2,*),
     &              ORIG(6,*), RC(NP3,*), THETA(NP3,*), OLD(9,*)
      INTEGER       OLDIA(*), ITFORN(*)
      REAL*8        VGAP, VECR4(*), XSI0(*)
      INTEGER       INDIC
      CHARACTER*8   TPFL
      INTEGER       VECI1(*)
      REAL*8        VECR1(*), VECR2(*), VECR5(*), VECR3(*)
      REAL*8        MASGI(*), AMORI(*), PULSI(*)
      REAL*8        AMOR(*), AMOR0(*), PULS(*), PULS0(*)
      REAL*8        ACCG0(*), VITG0(*), DEPG0(*),
     &              VITGE(*), DEPGE(*), VITG(*), DEPG(*),
     &              VITGC(*), DEPGC(*), VITGT(*), DEPGT(*),
     &              VITG0T(*), DEPG0T(*)
      REAL*8        CMOD0(NP1,*), KMOD0(NP1,*),
     &              CMOD(NP1,*), KMOD(NP1,*),
     &              CMODCA(NP1,*), KMODCA(NP1,*),
     &              AMFLU0(NP1,*), AMFLUC(NP1,*), CMODFA(NP1,*)
      LOGICAL       LOCFLC(*)
      INTEGER       NPFTS
      REAL*8        TEXTTS(*), FEXTTS(NP4,*)
      INTEGER       NDEF, INDT
      REAL*8        FEXMOD(*), FNLMOD(*), FMRES(*), FMODA(*), FMOD0(*),
     &              FMOD00(*), FMODT(*), FMOD0T(*)
      REAL*8        DIV, TOL, TOLC, TOLN, TOLV
      INTEGER       INTGE1(*), INTGE2(*), INDX(*), INDXF(*)
      REAL*8        FTMP(*), MTMP1(NP1,*), MTMP2(NP1,*), MTMP6(3,*)
      REAL*8        TTR(N2,*), U(*), W(*), DD(*)
      LOGICAL       LOC(*)
      REAL*8        VVG(NP1,*), VG(NP1,*), VG0(NP1,*),
     &              VD(NP1,*), VD0(NP1,*), RR(*), RR0(*), RI(*)
      REAL*8        PREMAC, PREREL, TRANS(2,2,*), PULSD(*)
      COMPLEX*16    S0(*), Z0(*), SR0(*), ZA1(*), ZA2(*), ZA3(*), ZIN(*)
C
C VARIABLES LOCALES
C -----------------
      INTEGER       I, IC, IER,
     &              NBCHE, NBCHEE, ICONFE, NBCHA, NBCHEA, ICONFA, ICONF,
     &              INEWTO, ICHOC0, NITER, NITER0, TYPJ
      REAL*8        OMEGA, TETAES, MAXVIT, FTESTE, SOMVIT, DTC
C DEBUG
      REAL*8        TOLCH
C DEBUG
C
C FONCTIONS INTRINSEQUES
C ----------------------
C     INTRINSIC     ABS, MIN
C
C ROUTINES EXTERNES
C -----------------
C     EXTERNAL      ADIMVE, CALCMD, CALCMI, CALFMN, CALFNL, COUPLA,
C    &              ESTIVD, MATINI, LCINVN, NEWTON, PROJMD,
C    &              PROJVD, SOMMMA, TESTCH,
C DEBUG
C     EXTERNAL      DCOPY
C DEBUG
C
C-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
C
C-----------------------------------------------------------------------
C     INITIALISATIONS
C-----------------------------------------------------------------------
C DEBUG
      TOLCH = 10.0D0 * TOLN
C DEBUG
      ICHOC0 = ICHOC
      NITER  = 0
      NITER0 = 10
      TETAES = 1.0D0
      MAXVIT = 1.0D0
      INEWTO = 0
      CALL MATINI ( NP1,NP1,0.D0,VG)
      CALL MATINI ( NP1,NP1,0.D0,VD)
      CALL VECINI ( NP1, 0.D0, FMODT)
      CALL VECINI ( NP1, 0.D0, DEPG0T)
      CALL VECINI ( NP1, 0.D0, VITG0T)
      CALL VECINI ( NP1, 0.D0, FMOD0T)
C
C-----------------------------------------------------------------------
C     ESTIMATION DES DDLS GENERALISES A L'INSTANT N+1
C     (REPETER JUSQU'A VALIDATION DE L'INSTANT N+1)
C-----------------------------------------------------------------------
  10  CONTINUE
      CALL VECINI ( NP1, 0.D0, DEPGE)
      CALL VECINI ( NP1, 0.D0, VITGE)
      CALL VECINI ( NP1, 0.D0, DEPG)
      CALL VECINI ( NP1, 0.D0, VITG)
CC
CC 1.  ESTIMATION DES DDLS A L'INSTANT N+1 PAR LE SCHEMA D'EULER
CC     ---------------------------------------------------------
CC     INEWTO = 0 INDIQUE A ESTIVD QUE LA ROUTINE APPELANTE EST ALITMI
CC
      CALL ESTIVD ( NBM,DT,VITGE,DEPGE,ACCG0,VITG0,DEPG0,TETAES,
     &              MAXVIT,INEWTO)
CC
CC 2.  TEST DE CHANGEMENT DE CONFIGURATION ENTRE LES INSTANTS N ET N+1
CC     AVEC LA SOLUTION DU SCHEMA D'EULER
CC     ----------------------------------
C
      CALL TESTCH ( NP1,NP2,NP3,NBM,NBNL,
     &              TOLN,TOLC,TOLV,TYPCH,NBSEG,PHII,
     &              ALPHA,BETA,GAMMA,ORIG,RC,THETA,
     &              TCONF1,DEPGE,
     &              NBCHE,NBCHEE,ICONFE,FTESTE,ICONFB,TCONFE)
C
C 3.  RAFFINEMENT DU PAS DE TEMPS SI LA SOLUTION DU SCHEMA D'EULER
C     CONDUIT A UNE VARIATION IMPORTANTE DU DEPLACEMENT PHYSIQUE
C     ENTRE LES INSTANTS N ET N+1
C     ---------------------------
      IF ( (ICONFE.EQ.-1).AND.(NITER.LE.NITER0) ) THEN
C
C 3.1    SI L'INSTANT N EST UN INSTANT DE CHANGEMENT DE CONFIGURATION
C        OU SI ON EST PROCHE D'UN CHANGEMENT D'ETAT A L'INSTANT N
C        => DT = DT/10
C
         IF ( (INDNE0.EQ.1).OR.(ABS(FTEST0).LT.TOL) ) THEN
            TC = TC - DT
            DT = DT/10.0D0
            TC = TC + DT
            IDECRT = 1
            NITER = NITER + 1
C --------- ON RETOURNE A L'ESTIMATION D'EULER ESTIVD
            GO TO 10
C
C 3.2    SINON => DT = DT/2
C
         ELSE
            TC = TC - DT
            DT = DT/2.0D0
            TC = TC + DT
            IDECRT = 1
            NITER = NITER + 1
C --------- ON RETOURNE A L'ESTIMATION D'EULER ESTIVD
            GO TO 10
C
         ENDIF
      ENDIF
C
C 4.  ESTIMATION DE LA FORCE NON-LINEAIRE A L'INSTANT N+1 A L'AIDE DE
C     LA SOLUTION DU SCHEMA D'EULER
C     -----------------------------
C     INEWTO = 0 INDIQUE A MDCHOE QUE LA ROUTINE APPELANTE EST ALITMI
C
      CALL CALFNL ( NP1,NP2,NP3,NP4,NBM,NBM,NPFTS,TC,
     &              NBNL,TYPCH,NBSEG,PHII,
     &              CHOC,ALPHA,BETA,GAMMA,ORIG,RC,THETA,
     &              MASGI,AMORI,PULSI,
     &              VITGE,DEPGE,VITG0,DEPG0,
     &              CMOD,KMOD,CMODCA,KMODCA,
     &              TEXTTS,FEXTTS,NDEF,INDT,NITER,
     &              FEXMOD,FNLMOD,FMRES,FMODA,FTMP,MTMP1,MTMP6,
     &              OLD,OLDIA,ICHOC,ITFORN,INEWTO,TOLN)
C
C 5.  DIAGONALISATION DE LA MATRICE DE RAIDEUR A L'INSTANT N+1
C     --------------------------------------------------------
      IER = 0
      CALL CALCMD ( NP1,KMODCA,KMOD0,NBM,NBMCD,TYPJ,VVG,VG,VG0,VD,VD0,
     &              RR,RR0,RI,N2,IER,ICHOC,PREMAC,PREREL,
     &              MTMP1,MTMP2,TTR,
     &              U,W,DD,INTGE1,INTGE2,INDX,INDXF,LOC)
C
      IF ( IER.NE.0 )
     &   CALL U2MESS('F','ALGORITH_10')
C
      DO 20 I = 1, NBM
         PULS(I) = RR(I)
  20  CONTINUE
      DO 30 I = 1, NBM
         IF ( (PULS(I).EQ.0.0D0).AND.(I.LE.NBMCD) ) THEN
            PULS(I) = PULS0(I)
            CALL U2MESS('I','ALGORITH_11')
         ENDIF
  30  CONTINUE
C
      IF ( (ICHOC0.EQ.1).AND.(ICHOC.EQ.0) ) TYPJ = 1
C
C 6.  CALCUL DES FORCES DE COUPLAGE A L'INSTANT N+1 LE CAS ECHEANT
C     ------------------------------------------------------------
      IF ( (ICHOC.EQ.1).AND.(ICOUPL.EQ.1) ) THEN
         CALL COUPLA ( NP1,NBM,INDIC,TPFL,VECI1,
     &                 VGAP,VECR4,VECR1,VECR2,VECR5,VECR3,
     &                 MASGI,PULS,LOCFLC,AMFLU0,AMFLUC,XSI0)
         CALL SOMMMA ( NP1,NBM,NBM,AMFLUC,CMODCA,CMODFA)
      ENDIF
C
C 7.  CALCUL DES EXCITATIONS GENERALISEES A L'INSTANT N
C     -------------------------------------------------
      CALL CALFMN ( NP1,NBM,ICHOC0,
     &              FMOD0,FMOD00,CMOD,KMOD,VITG0,DEPG0)
      CALL ADIMVE ( NBM,FMOD0,MASGI)
C
C 8.  PROJECTIONS SUR LA BASE MODALE A L'INSTANT N+1
C     ----------------------------------------------
C 8.1 PROJECTION DE LA MATRICE D'AMORTISSEMENT
C
      IF ( (ICHOC.EQ.1).AND.(ICOUPL.EQ.1) ) THEN
         CALL PROJMD (ICHOC,NP1,NBM,NBMCD,CMODFA,VG,VD,AMOR,MTMP1,MTMP2)
      ELSE
         CALL PROJMD (ICHOC,NP1,NBM,NBMCD,CMODCA,VG,VD,AMOR,MTMP1,MTMP2)
      ENDIF
C
C 8.2 PROJECTIONS DU VECTEUR EXCITATIONS  GENERALISEES  A L'INSTANT N
C                 DU VECTEUR EXCITATIONS  GENERALISEES  A L'INSTANT N+1
C                 DU VECTEUR DEPLACEMENTS GENERALISES   A L'INSTANT N
C                 DU VECTEUR VITESSES     GENERALISEES  A L'INSTANT N
C
      CALL PROJVD ( ICHOC,NP1,NBM,NBM,VG,FMOD0,FMOD0T)
      CALL PROJVD ( ICHOC,NP1,NBM,NBM,VG,FMODA,FMODT)
      CALL PROJVD ( ICHOC,NP1,NBM,NBM,VG,DEPG0,DEPG0T)
      CALL PROJVD ( ICHOC,NP1,NBM,NBM,VG,VITG0,VITG0T)
C
C 9.  CALCUL DES DDLS GENERALISES A L'INSTANT N+1 PAR METHODE INTEGRALE
C     APPLICATION DU SCHEMA ITMI
C     --------------------------
      CALL CALCMI ( NP1,NBMCD,DT0,DT,
     &              VITGT,DEPGT,VITG0T,DEPG0T,FMODT,FMOD0T,
     &              AMOR,AMOR0,PULS,PULS0,
     &              TRANS,PULSD,S0,Z0,SR0,ZA1,ZA2,ZA3,ZIN)
C
C 10. RETOUR SUR LA BASE MODALE EN VOL
C     --------------------------------
C 10.1 PROJECTION DU VECTEUR DEPLACEMENTS GENERALISES A L'INSTANT N+1
C
      CALL PROJVD ( ICHOC,NP1,NBM,NBMCD,VD,DEPGT,DEPG)
C
C 10.2 PROJECTION DU VECTEUR VITESSES GENERALISEES A L'INSTANT N+1
C
      CALL PROJVD ( ICHOC,NP1,NBM,NBMCD,VD,VITGT,VITG)
C
C 11. TEST DE CHANGEMENT DE CONFIGURATION ENTRE LES INSTANTS N ET N+1
C     AVEC LA SOLUTION DU SCHEMA ITMI
C     -------------------------------
      IF ( ICHOC.EQ.1 ) THEN
         CALL TESTCH ( NP1,NP2,NP3,NBM,NBNL,
     &                 TOLN,TOLC,TOLV,TYPCH,NBSEG,PHII,
     &                 ALPHA,BETA,GAMMA,ORIG,RC,THETA,
     &                 TCONF1,DEPG,
     &                 NBCHA,NBCHEA,ICONFA,FTEST,ICONFB,TCONF2)
      ELSE
         CALL TESTCH ( NP1,NP2,NP3,NBMCD,NBNL,
     &                 TOLN,TOLC,TOLV,TYPCH,NBSEG,PHII,
     &                 ALPHA,BETA,GAMMA,ORIG,RC,THETA,
     &                 TCONF1,DEPG,
     &                 NBCHA,NBCHEA,ICONFA,FTEST,ICONFB,TCONF2)
      ENDIF
C
      IF ( ICONFE.NE.0 ) THEN
         ICONF = ICONFA
      ELSE
         ICONF = 0
      ENDIF
C
C 12. VALIDATION DE L'INSTANT N+1 OU RAFFINEMENT DU PAS DE TEMPS
C     EN FONCTION DU CHANGEMENT DE CONFIGURATION
C     ------------------------------------------
C 12.1 SI UN CHANGEMENT DE CONFIGURATION SE PRODUIT ENTRE LES
C      INSTANTS N ET N+1
C
      IF ( ICONF.EQ.0 ) THEN
C
C 12.1.1 SI LE CHANGEMENT DE CONFIGURATION EST PROCHE, APPEL A NEWTON
C
         IF ( ((ABS(FTEST).LT.TOL).AND.(ABS(FTEST0).LT.TOLC))
     &        .OR.(NITER.GE.NITER0) ) THEN
C
            ICHOC = ICHOC0
C
            CALL NEWTON ( NP1,NP2,NP3,NP4,NBM,N2,NBMCD,ICOUPL,TC,DT,DTC,
     &        VECDT,NBNL,TYPCH,NBSEG,PHII,CHOC,ALPHA,BETA,GAMMA,ORIG,RC,
     &        THETA,VGAP,VECR4,INDIC,TPFL,VECI1,VECR1,VECR2,VECR5,VECR3,
     &        MASGI,AMORI,PULSI,AMOR,AMOR0,PULS,PULS0,XSI0,
     &        VITG,DEPG,ACCG0,VITG0,DEPG0,VITGC,DEPGC,VITGT,DEPGT,
     &        CMOD,KMOD,CMOD0,KMOD0,CMODCA,KMODCA,AMFLU0,AMFLUC,
     &        LOCFLC,CMODFA,NPFTS,TEXTTS,FEXTTS,NDEF,INDT,
     &        FEXMOD,FNLMOD,FMODA,FMRES,FMOD0,FMOD00,
     &        FMODT,FMOD0T,VITG0T,DEPG0T,
     &        FTMP,MTMP1,MTMP2,MTMP6,
     &        TTR,U,W,DD,LOC,INTGE1,INTGE2,INDX,INDXF,
     &        VVG,VG,VG0,VD,VD0,RR,RR0,RI,PREMAC,PREREL,TRANS,PULSD,S0,
     &        Z0,SR0,ZA1,ZA2,ZA3,ZIN,OLD,OLDIA,
     &        ICONFE,ICONFA,NBCHA,NBCHEA,FTEST,ICONFB,TCONF1,TCONF2,
     &        TOLN,TOLC,TOLV,ICHOC,ITFORN)
C
C --------- VALIDATION DE L'INSTANT N+1
            DT0 = DT
C ......... LES PULSATIONS PULS(I) SONT CELLES DE LA BASE MODALE DE LA
C ......... DE LA CONFIGURATION A L'INSTANT N, CAR LES JACOBIENS DES
C ......... FORCES NON LINEAIRES SONT IMPLICITES A L'INSTANT N LORS DE
C ......... L'APPEL A NEWTON. ON NE PEUT DONC PAS ESTIMER A PRIORI LE
C ......... NOUVEAU PAS DE TEMPS.
C ......... ON CHOISIT DT = MIN(DT0,ABS(DTC)), DTC ETANT L'INCREMENT
C ......... TEMPOREL AYANT PERMIS D'ATTEINDRE LE CHANGEMENT DE CONF.
C DEBUG
C            IF ( DTC.NE.0.0D0 ) DT = MIN(DT0,ABS(DTC))
            IF ( DTC.EQ.0.0D0 ) THEN
               CALL DCOPY ( NBM,DEPGE(1),1,DEPGC(1),1)
               CALL DCOPY ( NBM,VITGE(1),1,VITGC(1),1)
            ELSE
               DT = MIN(DT0,ABS(DTC))
            ENDIF
C DEBUG
            TC = TC + DT
            INDNEW = 1
            ITEST = 1
C
C 12.1.2 SINON ON RECALCULE LA CONFIGURATION A L'INSTANT N+1
C        EN RAFFINANT LE PAS DE TEMPS
C
         ELSE
C
            TC = TC - DT
C
C --------- SI UN CHANGEMENT DE CONFIGURATION S'EST PRODUIT
C --------- A L'INSTANT N
            IF ( INDNE0.EQ.1 ) THEN
C
C ............ CALCUL DU PRODUIT SCALAIRE DES VECTEURS VITESSES
C ............ GENERALISEES (INSTANTS N ET N+1)
               SOMVIT = 0.0D0
               DO 50 I = 1, NBM
                  SOMVIT = SOMVIT + VITG(I)*VITG0(I)
  50           CONTINUE
C
C ............ SI LE PRODUIT SCALAIRE EST NEGATIF => DT = DT/5
               IF ( SOMVIT.LT.0.0D0 ) THEN
                  DT = DT/5.0D0
C
C ............ SINON => DT = DT/2
               ELSE
                  DT = DT/2.0D0
               ENDIF
C
C --------- SINON (PAS DE CHANGEMENT DE CONFIGURATION A L'INSTANT N)
C --------- => DT = DT/2
            ELSE
               DT = DT/2.0D0
            ENDIF
C
            TC = TC + DT
            ITEST = 0
            NITER = NITER + 1
C
C --------- ON RETOURNE A L'ESTIMATION D'EULER ESTIVD
            GO TO 10
C
         ENDIF
C
C 12.2 SI UNE VARIATION IMPORTANTE DU DEPLACEMENT PHYSIQUE SE PRODUIT
C      ENTRE LES INSTANTS N ET N+1, ON RECALCULE LA CONFIGURATION
C      A L'INSTANT N+1 EN RAFFINANT LE PAS DE TEMPS (DT = DT/2)
C
      ELSE IF ( ICONF.EQ.-1 ) THEN
C
         TC = TC - DT
         DT = DT/2.0D0
         TC = TC + DT
         ITEST = 0
         NITER = NITER + 1
C
C ------ ON RETOURNE A L'ESTIMATION D'EULER ESTIVD
         GO TO 10
C
C 12.3 S'IL N'Y A PAS DE CHANGEMENT DE CONFIGURATION ENTRE LES
C      INSTANTS N ET N+1, VALIDATION DE L'INSTANT N+1
C      (ICONF = 1 DANS CE DERNIER CAS)
C
      ELSE
C
C DEBUG
         DO 55 IC = 1, NBNL
            IF ( (ABS(TCONFE(4,IC)).GT.TOLCH).AND.
     &           (ABS(TCONF2(4,IC)).GT.TOLCH).AND.
     &           (TCONFE(4,IC)*TCONF2(4,IC).LT.0.0D0) ) THEN
               TC = TC - DT
               DT = DT/2.0D0
               TC = TC + DT
               ITEST = 0
               NITER = NITER + 1
C
C ------------ ON RETOURNE A L'ESTIMATION D'EULER ESTIVD
               GO TO 10
            ENDIF
  55     CONTINUE
C DEBUG
         DT0 = DT
C
C 12.3.1 SI ITEST = 0
C        ON A RAFFINE LE PAS DE TEMPS LORS D'UNE ITERATION PRECEDENTE :
C        - POUR DETERMINER L'INSTANT N : RAFFINEMENT DU PAS DE TEMPS
C          APRES L'ESTIMATION D'EULER (3.1 OU 3.2) CAR VARIATION
C          IMPORTANTE DU DEPLACEMENT PHYSIQUE
C          NOUVELLE ESTIMATION D'EULER PUIS APPLICATION DU SCHEMA ITMI
C          PAS DE CHANGEMENT DE CONFIGURATION NI DE VARIATION IMPORTANTE
C          DU DEPLACEMENT PHYSIQUE APRES APPLICATION DU SCHEMA ITMI
C          PASSAGE EN 11.3.2 AVEC IDECRT = 1 => ITEST = 0
C        - POUR DETERMINER L'INSTANT N+1 : RAFFINEMENT DU PAS DE TEMPS
C          APRES APPLICATION DU SCHEMA ITMI
C          CHANGEMENT DE CONFIGURATION PAS ASSEZ PROCHE (11.1.2) OU
C          VARIATION IMPORTANTE DU DEPLACEMENT PHYSIQUE (11.2)
C        ON NE DETECTE PAS DE CHANGEMENT DE CONFIGURATION A L'ITERATION
C        COURANTE, NI DE VARIATION IMPORTANTE DU DEPLACEMENT PHYSIQUE
C        ON CONSERVE LE PAS DE TEMPS RAFFINE POUR L'ITERATION SUIVANTE
C        AFIN DE SE RAPPROCHER DU CHANGEMENT DE CONFIGURATION OU DE NE
C        PAS CAUSER DE VARIATION IMPORTANTE DU DEPLACEMENT PHYSIQUE
C
         IF ( ITEST.EQ.0 ) THEN
C
C ......... SI ON SE RETROUVE EN 11.3 A L'ISSUE DE L'ITERATION SUIVANTE,
C ......... IL FAUDRA CALCULER UN NOUVEAU PAS DE TEMPS
            ITEST = 1
C
C 12.3.2 SINON (ITEST = 1)
C
         ELSE
C
C --------- SI ON A RAFFINE LE PAS DE TEMPS POUR L'ESTIMATION D'EULER,
C --------- ON CONSERVE LE PAS DE TEMPS RAFFINE
            IF ( IDECRT.EQ.1 ) THEN
               ITEST = 0
C
C --------- SINON ON CALCULE LE NOUVEAU PAS DE TEMPS
            ELSE
               OMEGA = 0.0D0
               DO 60 I = 1, NBMCD
                  IF ( PULS(I).GT.OMEGA ) OMEGA = PULS(I)
  60           CONTINUE
               DT = 1.0D0/(DIV*OMEGA*15.0D0)
               ITEST = 1
            ENDIF
         ENDIF
C
         TC = TC + DT
C
      ENDIF
C
C --- FIN DE ALITMI.
      END

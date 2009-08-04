      SUBROUTINE MEFMAT(NDIM,NUMGRP,NBZ,NBGRP,NBMOD,MATMA,DCENT,CP,CF,
     &               VIT,RHO,PSTAT,DPSTAT,RINT,PHIX,PHIY,Z,MATM,
     &               MATR,MATA,ITYPG,AXG,ZG,RHOG,VITG,CDG,CPG)
      IMPLICIT REAL*8 (A-H,O-Z)
C
      INTEGER       NDIM(14),NUMGRP(*),NBMOD
      REAL*8        MATMA(*),DCENT(*)
      REAL*8        CP(*),CF(*),VIT(0:*),RHO(0:*),PSTAT(*),DPSTAT(*)
      REAL*8        MATM(NBMOD,NBMOD),RINT(*),PHIX(NBZ*NBGRP,NBMOD),
     &              PHIY(NBZ*NBGRP,NBMOD),Z(*)
      REAL*8        MATR(NBMOD,NBMOD),MATA(NBMOD,NBMOD)
C
      INTEGER       ITYPG(*)
      REAL*8        ZG(*),AXG(*),RHOG(*),VITG(*),CDG(*),CPG(*)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/08/2009   AUTEUR MEUNIER S.MEUNIER 
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
C ----------------------------------------------------------------------
C     CALCUL DES MATRICES DE MASSE, DE RAIDEUR, D AMORTISSEMENT SOUS
C     ECOULEMENT
C     OPERATEUR APPELANT : OP0144 , FLUST3, MEFIST
C ----------------------------------------------------------------------
C     OPTION DE CALCUL   : CALC_FLUI_STRU , CALCUL DES PARAMETRES DE
C     COUPLAGE FLUIDE-STRUCTURE POUR UNE CONFIGURATION DE TYPE "FAISCEAU
C     DE TUBES SOUS ECOULEMENT AXIAL"
C ----------------------------------------------------------------------
C IN  : NDIM   : TABLEAU DES DIMENSIONS
C IN  : NUMGRP : INDICES DES GROUPES D EQUIVALENCE
C IN  : NBZ     : NOMBRE DE POINTS DE DISCRETISATION
C IN  : NBGRP  : NOMBRE DE GROUPES D'EQUIVALENCE DE CYLINDRES
C IN  : NBMOD  : NOMBRE DE MODES PRIS EN COMPTE POUR LE COUPLAGE
C IN  : MATMA  : VECTEUR CONTENANT LES MATRICES MODALES, MASSE,RIGIDITE,
C                AMORTISSEMENT
C IN  : DCENT  : VECTEUR CONTENANT LES TABLEAUX DE COEFFICIENTS ET
C                LES MATRICES EN AIR
C IN  : CP     : COEFFICIENT DE PORTANCE CP DU FLUIDE AUTOUR D UN
C                CYLINDRE INCLINE, AUX POINTS DE DISCRETISATION
C IN  : CF     : COEFFICIENT DE TRAINEE VISQUEUSE DU FLUIDE LE LONG DES
C                PAROIS, AUX POINTS DE DISCRETISATION
C IN  : VIT    : VITESSE D ECOULEMENT DU FLUIDE AUX POINTS DE
C                DISCRETISATION
C IN  : RHO    : MASSE VOLUMIQUE DU FLUIDE AUX POINTS DE DISCRETISATION
C IN  : PSTAT  : PROFIL DE PRESSION STATIONNAIRE
C IN  : DPSTAT : PROFIL DE GRADIENT DE PRESSION STATIONNAIRE
C IN  : RINT   : RAYONS DES CYLINDRES
C IN  : PHIX   : DEFORMEES MODALES INTERPOLEES DANS LE REPERE AXIAL
C IN  : PHIY   : DEFORMEES MODALES INTERPOLEES DANS LE REPERE AXIAL
C OUT : MATM   : MATRICE DE MASSE AJOUTEE REPRESENTANT LA PROJECTION DES
C                EFFORTS FLUIDES INERTIELS DANS LA BASE DES DEFORMEES
C                MODALES DES CYLINDRES
C OUT : MATR   : MATRICE DE RAIDEUR  AJOUTEE REPRESENTANT LA PROJECTION
C                DES EFFORTS FLUIDES DE RAIDEUR DANS LA BASE DES
C                DEFORMEES MODALES DES CYLINDRES
C OUT : MATA   : MATRICE D AMORTISSEMENT AJOUTEE REPRESENTANT LA
C                PROJECTION DES EFFORTS FLUIDES D AMORTISSEMENT DANS LA
C                BASE DES DEFORMEES MODALES DES CYLINDRES
C
C IN  : ITYPG  : VECTEUR DES GROUPES D'APPARTENANCE DES GRILLES
C IN  : ZG     : POINTS DE DISCRETISATION DES GRILLES (EN LEURMILIEU)
C IN  : AXG    : SECTION SOLIDE DES TYPES DE GRILLES
C IN  : RHOG   : PROFIL DE MASSE VOLUMIQUE DE L'ECOULEMENT AU NIVEAU
C                         DES GRILLES
C IN  : VITG   : PROFIL DE VITESSE DE L'ECOULEMENT AU NIVEAU DES GRILLES
C IN  : CDG    : COEFF DE TRAINEE POUR CHAQUE TYPE DE GRILLES
C IN  : CPG    : PENTE DU COEFF DE PORTANCE POUR CHAQUE TYPE DE GRILLES
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C ----------------------------------------------------------------------
      INTEGER      I,J
      INTEGER      IMOD,IGRP,JMOD,JGRP
      INTEGER      NCYL
      REAL*8       MEFIN1,MEFIN2,MEFIN3,MEFIN4,MEFIN5
      REAL*8       RAYO
C
      INTEGER      KG,K,NGZ1,NGZ2
      REAL*8       ECART
C ----------------------------------------------------------------------
      CALL JEMARQ()
C
C --- LECTURE DES DIMENSIONS
      NBCYL  = NDIM(3)
      NTYPG  = NDIM(13)
      NBGTOT = NDIM(14)
C
C --- CREATION DES OBJETS DE TRAVAIL
      CALL WKVECT('&&MEFMAT.TMP.GH','V V R',NBZ*2,IG)
      IH  = IG + NBZ
      IF(NTYPG.NE.0) THEN
        CALL WKVECT('&&MEFMAT.AIREG' ,'V V R',NTYPG,IAIREG)
        CALL WKVECT('&&MEFMAT.PHIXG' ,'V V R',NBGRP*NBGTOT*NBMOD,IPHIXG)
        CALL WKVECT('&&MEFMAT.PHIYG' ,'V V R',NBGRP*NBGTOT*NBMOD,IPHIYG)
        CALL WKVECT('&&MEFMAT.DPHIXG','V V R',NBGRP*NBGTOT*NBMOD,IDPHXG)
        CALL WKVECT('&&MEFMAT.DPHIYG','V V R',NBGRP*NBGTOT*NBMOD,IDPHYG)
      ENDIF
C
      PI = R8PI()
C
C --- VITESSE MOYENNE D ECOULEMENT ET MASSE VOLUMIQUE MOYENNE
C
      RHO0 = RHO(0)
      VIT0 = VIT(0)
C
C --- DECALAGES DES TABLEAUX DE COEFFICIENTS ET DES MATRICES EN AIR
C --- DANS LE VECTEUR DCENT
C
      IPPXX = NBCYL + NBCYL + NBCYL*NBCYL + NBCYL*NBCYL
      IPPXY = IPPXX + NBCYL*NBGRP
      IPPYX = IPPXY + NBCYL*NBGRP
      IPPYY = IPPYX + NBCYL*NBGRP
      IVNXX = IPPYY + NBCYL*NBGRP
      IVNXY = IVNXX + NBCYL*NBGRP
      IVNYX = IVNXY + NBCYL*NBGRP
      IVNYY = IVNYX + NBCYL*NBGRP
C
C --- DECALAGES DES MATRICES MODALES DANS LE VECTEUR MATMA
C
      IMATRA = NBMOD
      IMATAA = IMATRA + NBMOD
C
C --- INITIALISATIONS
C
      CALL MATINI(NBMOD,NBMOD,0.D0,MATM)
      CALL MATINI(NBMOD,NBMOD,0.D0,MATA)
      CALL MATINI(NBMOD,NBMOD,0.D0,MATR)
C
C---  SECTION SOLIDE D'UNE CELLULE ELEMENTAIRE DE GRILLE
C
      IF (NTYPG.NE.0) THEN
C
         DO 45 K = 1,NTYPG
            ZR(IAIREG+K-1) = AXG(K)/DBLE(NBCYL)
45       CONTINUE
C
C---  CALCUL (PAR INTERPOLATION  LINEAIRE) DES DEFORMEES MODALES
C---  ET DE LEUR GRADIENT AUX COTES ZG DES GRILLES
C
         DO 30 IMOD = 1,NBMOD
           DO 37 IGRP = 1,NBGRP
              DO 32 I = 1,NBZ
              DO 33 J = 1,NBGTOT
                 ECART = (Z(I)-ZG(J))*(Z(I-1)-ZG(J))
                 IF (ECART.LE.0.D0) THEN
           ZR(IPHIXG+(IMOD-1)*NBGRP*NBGTOT+(IGRP-1)*NBGTOT+J-1) =
     &       PHIX((IGRP-1)*NBZ+I-1,IMOD)*(Z(I)-ZG(J))/(Z(I)-Z(I-1))+
     &       PHIX((IGRP-1)*NBZ+I,IMOD)*(ZG(J)-Z(I-1))/(Z(I)-Z(I-1))
C
           ZR(IPHIYG+(IMOD-1)*NBGRP*NBGTOT+(IGRP-1)*NBGTOT+J-1) =
     &       PHIY((IGRP-1)*NBZ+I-1,IMOD)*(Z(I)-ZG(J))/(Z(I)-Z(I-1))+
     &       PHIY((IGRP-1)*NBZ+I,IMOD)*(ZG(J)-Z(I-1))/(Z(I)-Z(I-1))
C
           ZR(IDPHXG+(IMOD-1)*NBGRP*NBGTOT+(IGRP-1)*NBGTOT+J-1) =
     &       ( PHIX((IGRP-1)*NBZ+I,IMOD)-PHIX((IGRP-1)*NBZ+I-1,IMOD) ) /
     &       ( Z(I)-Z(I-1) )
C
           ZR(IDPHYG+(IMOD-1)*NBGRP*NBGTOT+(IGRP-1)*NBGTOT+J-1) =
     &       ( PHIY((IGRP-1)*NBZ+I,IMOD)-PHIY((IGRP-1)*NBZ+I-1,IMOD) ) /
     &       ( Z(I)-Z(I-1) )
C
                 ENDIF
33           CONTINUE
32           CONTINUE
37        CONTINUE
30       CONTINUE
C
      ENDIF
C
      DO 4 JMOD = 1,NBMOD
      DO 41 IMOD = 1,NBMOD
C
         DO 411 JGRP = 1,NBGRP
         DO 4111 IGRP = 1,NBGRP
C
            DO 41112 I = 1,NBCYL
               IF (NUMGRP(I).EQ.IGRP) THEN
                  RAYO = RINT(I)
               ENDIF
41112       CONTINUE
            AIRE = PI*RAYO*RAYO
C
C --- CONTRIBUTION DES EFFORTS NORMAUX DE FROTTEMENT VISQUEUX
C --- -> TERMES D'AMORTISSEMENT ET DE RAIDEUR AJOUTES
C
C --- AMORTISSEMENT AJOUTE
C
            NCYL = 0
            IF (IGRP.EQ.JGRP) THEN
               DO 41111 I = 1,NBCYL
                  IF (NUMGRP(I).EQ.IGRP) NCYL = NCYL - 1
41111          CONTINUE
            ENDIF
C
            MATA(IMOD,JMOD) = MATA(IMOD,JMOD)-RHO0*ABS(VIT0)*RAYO*

     &      ( ( DCENT(IVNXX+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIX,CF) +
     &          DCENT(IVNXY+NBCYL*(JGRP-1)+IGRP) *
     &          MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIY,CF) +
     &          DCENT(IVNYX+NBCYL*(JGRP-1)+IGRP) *
     &          MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIX,CF) +
     &        ( DCENT(IVNYY+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIY,CF) )
C
            MATA(IMOD,JMOD) = MATA(IMOD,JMOD)-RHO0*ABS(VIT0)*RAYO*

     &      ( ( DCENT(IVNXX+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIX,CP) +
     &          DCENT(IVNXY+NBCYL*(JGRP-1)+IGRP) *
     &          MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIY,CP) +
     &          DCENT(IVNYX+NBCYL*(JGRP-1)+IGRP) *
     &          MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIX,CP) +
     &        ( DCENT(IVNYY+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIY,CP) )
C
C ---  RAIDEUR AJOUTEE
C
            MATR(IMOD,JMOD) = MATR(IMOD,JMOD)-RHO0*ABS(VIT0)*RAYO*

     &        ( DCENT(IVNXX+NBCYL*(JGRP-1)+IGRP) * MEFIN4(NBZ,NBGRP,
     &          IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIX,VIT,CF,ZR(IG)) +
     &          DCENT(IVNXY+NBCYL*(JGRP-1)+IGRP) * MEFIN4(NBZ,NBGRP,
     &          IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIY,VIT,CF,ZR(IG)) +
     &          DCENT(IVNYX+NBCYL*(JGRP-1)+IGRP) * MEFIN4(NBZ,NBGRP,
     &          IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIX,VIT,CF,ZR(IG)) +
     &          DCENT(IVNYY+NBCYL*(JGRP-1)+IGRP) * MEFIN4(NBZ,NBGRP,
     &          IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIY,VIT,CF,ZR(IG)) )
C
            MATR(IMOD,JMOD) = MATR(IMOD,JMOD)-RHO0*ABS(VIT0)*RAYO*

     &      ( ( DCENT(IVNXX+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          MEFIN4(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIX,VIT,
     &                 CP,ZR(IG)) +
     &          DCENT(IVNXY+NBCYL*(JGRP-1)+IGRP) *
     &          MEFIN4(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIY,VIT,
     &                 CP,ZR(IG)) +
     &          DCENT(IVNYX+NBCYL*(JGRP-1)+IGRP) *
     &          MEFIN4(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIX,VIT,
     &                 CP,ZR(IG)) +
     &        ( DCENT(IVNYY+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          MEFIN4(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIY,VIT,
     &                 CP,ZR(IG)) )
C
C
C --- CONTRIBUTION DES EFFORTS DE PRESSION PERTURBEE
C --- -> TERMES DE MASSE, AMORTISSEMENT ET RAIDEUR AJOUTES
C
C --- MASSE AJOUTEE
C
            MATM(IMOD,JMOD) = MATM(IMOD,JMOD) - AIRE *
     &      ( DCENT(IPPXX+NBCYL*(JGRP-1)+IGRP) *
     &        MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIX,RHO) +
     &        DCENT(IPPXY+NBCYL*(JGRP-1)+IGRP) *
     &        MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIY,RHO) +
     &        DCENT(IPPYX+NBCYL*(JGRP-1)+IGRP) *
     &        MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIX,RHO) +
     &        DCENT(IPPYY+NBCYL*(JGRP-1)+IGRP) *
     &        MEFIN1(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIY,RHO) )
C
C --- AMORTISSEMENT AJOUTE
C
            MATA(IMOD,JMOD) = MATA(IMOD,JMOD)
     &      - 2.D0 * RHO0 * VIT0 * AIRE *
     &      ( DCENT(IPPXX+NBCYL*(JGRP-1)+IGRP) *
     &        MEFIN2(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIX,ZR(IG)) +
     &        DCENT(IPPXY+NBCYL*(JGRP-1)+IGRP) *
     &        MEFIN2(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIX,PHIY,ZR(IG)) +
     &        DCENT(IPPYX+NBCYL*(JGRP-1)+IGRP) *
     &        MEFIN2(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIX,ZR(IG)) +
     &        DCENT(IPPYY+NBCYL*(JGRP-1)+IGRP) *
     &        MEFIN2(NBZ,NBGRP,IMOD,IGRP,JMOD,JGRP,Z,PHIY,PHIY,ZR(IG)) )
C
C --- RAIDEUR AJOUTEE
C
            MATR(IMOD,JMOD) = MATR(IMOD,JMOD) - RHO0 * VIT0 * AIRE *
     &      ( DCENT(IPPXX+NBCYL*(JGRP-1)+IGRP) * MEFIN3(NBZ,NBGRP,IMOD,
     &        IGRP,JMOD,JGRP,Z,PHIX,PHIX,VIT,ZR(IG),ZR(IH)) +
     &        DCENT(IPPXY+NBCYL*(JGRP-1)+IGRP) * MEFIN3(NBZ,NBGRP,IMOD,
     &        IGRP,JMOD,JGRP,Z,PHIX,PHIY,VIT,ZR(IG),ZR(IH)) +
     &        DCENT(IPPYX+NBCYL*(JGRP-1)+IGRP) * MEFIN3(NBZ,NBGRP,IMOD,
     &        IGRP,JMOD,JGRP,Z,PHIY,PHIX,VIT,ZR(IG),ZR(IH)) +
     &        DCENT(IPPYY+NBCYL*(JGRP-1)+IGRP) * MEFIN3(NBZ,NBGRP,IMOD,
     &        IGRP,JMOD,JGRP,Z,PHIY,PHIY,VIT,ZR(IG),ZR(IH)) )
C
 4111    CONTINUE
  411    CONTINUE
C
         DO 412 IGRP = 1,NBGRP
C
            NCYL = 0
            DO 4121 I = 1,NBCYL
               IF (NUMGRP(I).EQ.IGRP) NCYL = NCYL + 1
4121        CONTINUE
C
            DO 4122 I = 1,NBCYL
               IF (NUMGRP(I).EQ.IGRP) THEN
                  RAYO = RINT(I)
               ENDIF
4122        CONTINUE
            AIRE = PI*RAYO*RAYO
CC
C ---    CONTRIBUTION DES EFFORTS DE PRESSION STATIONNAIRE
C ---    -> TERMES DE RAIDEUR AJOUTEE
C
C ---    RAIDEUR AJOUTEE
C
            MATR(IMOD,JMOD) = MATR(IMOD,JMOD)-AIRE*NCYL*
     &         (MEFIN3(NBZ,NBGRP,IMOD,IGRP,JMOD,
     &          IGRP,Z,PHIX,PHIX,PSTAT,ZR(IG),ZR(IH))+
     &          MEFIN3(NBZ,NBGRP,IMOD,IGRP,JMOD,
     &          IGRP,Z,PHIY,PHIY,PSTAT,ZR(IG),ZR(IH))+
     &          MEFIN5(NBZ,NBGRP,IMOD,IGRP,JMOD,
     &          IGRP,Z,PHIX,PHIX,DPSTAT,ZR(IG))+
     &          MEFIN5(NBZ,NBGRP,IMOD,IGRP,JMOD,
     &          IGRP,Z,PHIY,PHIY,DPSTAT,ZR(IG)))
C
  412    CONTINUE
C
C---    CONTRIBUTION DES EFFORTS DE CONTRAINTES SUR LES GRILLES
C           ---> TERMES D'AMORTISSEMENT ET DE RAIDEUR AJOUTES
C
      IF (NTYPG.NE.0) THEN
C
         DO 36 KG = 1,NBGTOT
C
         DO 34 JGRP = 1,NBGRP
         DO 341 IGRP = 1,NBGRP
C
            NCYL = 0
            IF (IGRP.EQ.JGRP) THEN
               DO 35 I = 1,NBCYL
                  IF (NUMGRP(I).EQ.IGRP) NCYL = NCYL-1
35             CONTINUE
            ENDIF
C
            NGZ1 = (IGRP-1)*NBGTOT+KG
            NGZ2 = (JGRP-1)*NBGTOT+KG
C
C---   AMORTISSEMENT AJOUTE
C
            DO 46 K = 1,NTYPG
              IF (ITYPG(KG).EQ.K) THEN
              MATA(IMOD,JMOD) = MATA(IMOD,JMOD)
     &        - 0.5D0 * RHOG(KG) * ABS(VITG(KG)) *
     &          ZR(IAIREG+K-1) * CPG(K) *
     &      ( ( DCENT(IVNXX+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          ZR(IPHIXG+(IMOD-1)*NBGTOT*NBGRP+NGZ1-1) *
     &          ZR(IPHIXG+(JMOD-1)*NBGTOT*NBGRP+NGZ2-1) +
     &          DCENT(IVNXY+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIXG+(IMOD-1)*NBGTOT*NBGRP+NGZ1-1) *
     &          ZR(IPHIYG+(JMOD-1)*NBGTOT*NBGRP+NGZ2-1) +
     &          DCENT(IVNYX+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIYG+(IMOD-1)*NBGTOT*NBGRP+NGZ1-1) *
     &          ZR(IPHIXG+(JMOD-1)*NBGTOT*NBGRP+NGZ2-1) +
     &        ( DCENT(IVNYY+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          ZR(IPHIYG+(IMOD-1)*NBGTOT*NBGRP+NGZ1-1) *
     &          ZR(IPHIYG+(JMOD-1)*NBGTOT*NBGRP+NGZ2-1) )
C
              MATA(IMOD,JMOD) = MATA(IMOD,JMOD)
     &        - 0.5D0 * RHOG(KG) * ABS(VITG(KG)) *
     &          ZR(IAIREG+K-1) * CDG(K) *
     &      ( ( DCENT(IVNXX+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          ZR(IPHIXG+(IMOD-1)*NBGTOT*NBGRP+NGZ1-1) *
     &          ZR(IPHIXG+(JMOD-1)*NBGTOT*NBGRP+NGZ2-1) +
     &          DCENT(IVNXY+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIXG+(IMOD-1)*NBGTOT*NBGRP+NGZ1-1) *
     &          ZR(IPHIYG+(JMOD-1)*NBGTOT*NBGRP+NGZ2-1) +
     &          DCENT(IVNYX+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIYG+(IMOD-1)*NBGTOT*NBGRP+NGZ1-1) *
     &          ZR(IPHIXG+(JMOD-1)*NBGTOT*NBGRP+NGZ2-1) +
     &        ( DCENT(IVNYY+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          ZR(IPHIYG+(IMOD-1)*NBGTOT*NBGRP+NGZ1-1) *
     &          ZR(IPHIYG+(JMOD-1)*NBGTOT*NBGRP+NGZ2-1) )
              ENDIF
46          CONTINUE
C
C ---  RAIDEUR AJOUTEE
C
            DO 47 K = 1,NTYPG
              IF (ITYPG(KG).EQ.K) THEN
              MATR(IMOD,JMOD) = MATR(IMOD,JMOD)
     &        - 0.5D0 * RHOG(KG) * ABS(VITG(KG)) *
     &          ZR(IAIREG+K-1) * CDG(K) * VITG(KG) *
     &        ( DCENT(IVNXX+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIXG+(IMOD-1)*NBGRP*NBGTOT+NGZ1-1) *
     &          ZR(IDPHXG+(JMOD-1)*NBGRP*NBGTOT+NGZ2-1) +
     &          DCENT(IVNXY+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIXG+(IMOD-1)*NBGRP*NBGTOT+NGZ1-1) *
     &          ZR(IDPHYG+(JMOD-1)*NBGRP*NBGTOT+NGZ2-1) +
     &          DCENT(IVNYX+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIYG+(IMOD-1)*NBGRP*NBGTOT+NGZ1-1) *
     &          ZR(IDPHXG+(JMOD-1)*NBGRP*NBGTOT+NGZ2-1) +
     &          DCENT(IVNYY+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIYG+(IMOD-1)*NBGRP*NBGTOT+NGZ1-1) *
     &          ZR(IDPHYG+(JMOD-1)*NBGRP*NBGTOT+NGZ2-1) )
C
              MATR(IMOD,JMOD) = MATR(IMOD,JMOD)
     &        - 0.5D0 * RHOG(KG) * ABS(VITG(KG)) *
     &          ZR(IAIREG+K-1) * CPG(K) * VITG(KG) *
     &      ( ( DCENT(IVNXX+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          ZR(IPHIXG+(IMOD-1)*NBGRP*NBGTOT+NGZ1-1) *
     &          ZR(IDPHXG+(JMOD-1)*NBGRP*NBGTOT+NGZ2-1) +
     &          DCENT(IVNXY+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIXG+(IMOD-1)*NBGRP*NBGTOT+NGZ1-1) *
     &          ZR(IDPHYG+(JMOD-1)*NBGRP*NBGTOT+NGZ2-1) +
     &          DCENT(IVNYX+NBCYL*(JGRP-1)+IGRP) *
     &          ZR(IPHIYG+(IMOD-1)*NBGRP*NBGTOT+NGZ1-1) *
     &          ZR(IDPHXG+(JMOD-1)*NBGRP*NBGTOT+NGZ2-1) +
     &        ( DCENT(IVNYY+NBCYL*(JGRP-1)+IGRP) + DBLE(NCYL) ) *
     &          ZR(IPHIYG+(IMOD-1)*NBGRP*NBGTOT+NGZ1-1) *
     &          ZR(IDPHYG+(JMOD-1)*NBGRP*NBGTOT+NGZ2-1) )
C
              ENDIF
47          CONTINUE
C
341      CONTINUE
34       CONTINUE
36       CONTINUE
C
      ENDIF
C
C ---    TERMES DE MASSE, AMORTISSEMENT ET RAIDEUR DE STRUCTURE
C
         IF(IMOD.EQ.JMOD) THEN
            MATM(IMOD,JMOD) = MATM(IMOD,JMOD)+MATMA(IMOD)
            MATA(IMOD,JMOD) = MATA(IMOD,JMOD)+MATMA(IMATAA+IMOD)
            MATR(IMOD,JMOD) = MATR(IMOD,JMOD)+MATMA(IMATRA+IMOD)
         ENDIF
C
  41  CONTINUE
  4   CONTINUE
C
      CALL JEDETC('V','&&MEFMAT',1)
      CALL JEDEMA()
      END

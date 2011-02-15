      SUBROUTINE TE0512 (OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/02/2011   AUTEUR TRAN V-X.TRAN 
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
C
C     BUT: -- CALCUL
C               - DU TAUX DE TRIAXIALITE DES CONTRAINTES (TRIAX)
C               - DE LA CONTRAINTES EQUIVALENTE D'ENDOMMAGEMENT (SIGMA*)
C               - DE L'ENDOMMAGEMENT DE LEMAITRE-SERMAGE (DOMLE)
C
C        TAUX DE TRIAXIALITE : TRIAX
C        ---------------------------
C           TRIAX    = TRSIG / SIGEQ
C
C    AVEC   SIGD     = SIGMA - 1/3 TRACE(SIGMA) I
C           SIGEQ    = ( 3/2 SIGD : SIGD ) ** 1/2
C           TRSIG    = 1/3 TRACE(SIGMA)
C           SIGMA    = TENSEUR DES CONTRAINTES
C           SIGD     = DEVIATEUR DE SIGMA
C           I        = TENSEUR IDENTITE
C
C        CONTRAINTES EQUIVALENTE D'ENDOMMAGEMENT : SIGMA*
C        -----------------------------------------------
C           SI_ENDO  = SIGMA_EQ (2/3(1+NU) + 3(1-2 NU) TRIAX**2 )**1/2
C
C        LOI D'ENDOMMAGEMENT DE LEMAITRE-SERMAGE: DOMLE
C        ----------------------------------------------
C           D� = PUISSANCE([Y/VAR_S];EXP_S)*p�
C
C        LOI D'ENDOMMAGEMENT DE LEMAITRE-SERMAGE INTEGREE: DOMLE
C        -------------------------------------------------------
C           DOMLE(+) = 1 - PUISSANCE([PUISSANCE(1-DOMLE(-);2*EXP_S+1)
C                    - (2*EXP_S+1/2)
C                    *(PUISSANCE(K(+);EXP_S)+PUISSANCE(K(-);EXP_S))
C                    *(p(+) - p(-))];1/2*EXP_S+1)
C     OU
C           K(+) = PUISSANCE(SIGMA*(+);2) / (E(+)*VAR_S(+))
C
C.......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER  ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      INTEGER  MXCMEL,NBPGMX,NBRES, NBRES2,MXCVAR
      PARAMETER ( MXCMEL = 162 )
      PARAMETER ( NBPGMX =  27 )
      PARAMETER ( NBRES  =   2 )
      PARAMETER ( NBRES2 =   3 )
      PARAMETER ( MXCVAR = 378 )

      INTEGER  NBSIGM
      INTEGER  I,K
      INTEGER  NNO,NNOS,NPG,IRET
      INTEGER  NBSIG,IGAU,INDIC,NDIM
      INTEGER  IMATE,ICONPG
      INTEGER  IDTRGP,IVARMR,IVARPR,IENDMG
      INTEGER  IEPSP, JGANO,IPOIDS,IVF,IDFDE
      INTEGER  ICOMPO,IBID,JTAB(7),NBVARI


      REAL*8 SIGMA(MXCMEL),SIGD(MXCMEL)
      REAL*8 SIGEQ(NBPGMX),TRSIG(NBPGMX)
      REAL*8 CENDO(NBPGMX),CENDOM(NBPGMX)
      REAL*8 SENDO(NBPGMX)
      REAL*8 DOMLE(NBPGMX)
      REAL*8 TRIAX(NBPGMX)
      REAL*8 VALRES(NBRES),VALRE2(NBRES2)
      REAL*8 ZERO,UN,DEUX,TROIS,UNDEMI,UNTIER,DETIER,TRDEMI
      REAL*8 XNU,COE1,COE2
      REAL*8 PETITS(27),EXPO(27),IEXPO(27),RESU1,RESU2
      REAL*8 KMOISS,KPLUSS,KSOMM,PDIFF,PSEUIL(27),PPLUS,VALE
      REAL*8 DOMMOI(NBPGMX)
      REAL*8 XVARI1(MXCVAR),XVARI2(MXCVAR)
      REAL*8 XES,TS

      CHARACTER*4  FAMI
      CHARACTER*2  CODRES(NBRES),CODRE2(NBRES2)
      CHARACTER*8  NOMRES(NBRES)
      CHARACTER*8  NOMRE2(NBRES2)
      CHARACTER*16 PHENO,PHENOM,PHENO2,PHENM2

      DATA NOMRES / 'E','NU' /
      DATA NOMRE2 / 'S','EPSP_SEUIL','EXP_S' /
C
C ----------------------------------------------------------------------
C
C ----------------------------------------------------------------------
C --- 0. INITIALISATION
C ----------------------------------------------------------------------
C
      ZERO   = 0.0D0
      UN     = 1.0D0
      DEUX   = 2.0D0
      TROIS  = 3.0D0
      UNDEMI = 1.0D0 / 2.0D0
      UNTIER = 1.0D0 / 3.0D0
      DETIER = 2.0D0 / 3.0D0
      TRDEMI = 3.0D0 / 2.0D0
C
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)
      NBSIG = NBSIGM()

C ---    CARACTERISTIQUES MATERIAUX
      CALL JEVECH('PMATERC','L',IMATE)
C
C ---    TENSEUR DES CONTRAINTES
      CALL JEVECH('PCONTGP','L',ICONPG)
C
C ---    TAUX TRIAXIALITE, CONTRAINTES ENDO, DOMMAGE @[T-]
      CALL JEVECH('PTRIAGM','L',IENDMG)
C
C ---    VARIABLES INTERNES @[T-]
      CALL JEVECH('PVARIMR','L',IVARMR)
C
C ---    VARIABLES INTERNES @[T+]
      CALL JEVECH('PVARIPR','L',IVARPR)
C
C ---    EVALUATION DES DONNEES MATERIAUX
      PHENO = 'ELAS'
      CALL RCCOMA (ZI(IMATE),PHENO,PHENOM,CODRES(1))
      IF (CODRES(1).EQ.'NO') CALL U2MESS('F','FATIGUE1_7')

      PHENO2 = 'DOMMA_LEMAITRE'
      CALL RCCOMA (ZI(IMATE),PHENO2,PHENM2,CODRES(1))
      IF (CODRES(1).EQ.'NO') CALL U2MESS('F','FATIGUE1_6')
C
C ----------------------------------------------------------------------
C --- 1. PREALABLES
C ----------------------------------------------------------------------
C
C --- 1.1 AFFECTATION DE SIGMA
C
      K = 0
      DO 20 IGAU = 1, NPG
        DO 10 I = 1, NBSIG
          K = K+1
          SIGMA(I+(IGAU-1)*NBSIG) = ZR(ICONPG+K-1)
  10    CONTINUE
  20  CONTINUE
C
C --- 1.2 CALCUL DU DEVIATEUR DES CONTRAINTES SIGD ET
C       DE LA TRACE DE SIGMA TRSIG
C
      DO 30 IGAU = 1, NPG
        INDIC = (IGAU-1)*NBSIG
        TRSIG(IGAU) = UNTIER *
     &                (SIGMA(INDIC+1)+ SIGMA(INDIC+2) + SIGMA(INDIC+3))
        SIGD(INDIC+1) = SIGMA(INDIC+1) - TRSIG(IGAU)
        SIGD(INDIC+2) = SIGMA(INDIC+2) - TRSIG(IGAU)
        SIGD(INDIC+3) = SIGMA(INDIC+3) - TRSIG(IGAU)
        SIGD(INDIC+4) = SIGMA(INDIC+4)
        SIGD(INDIC+5) = SIGMA(INDIC+5)
        SIGD(INDIC+6) = SIGMA(INDIC+6)
  30  CONTINUE
C
C --- 1.3 CALCUL DE LA CONTRAINTE EQUIVALENTE SIGEQ
C
      DO 40 IGAU = 1, NPG
        INDIC = (IGAU-1)*NBSIG
        SIGEQ(IGAU) = SIGD(INDIC+1) * SIGD(INDIC+1)
     &              + SIGD(INDIC+2) * SIGD(INDIC+2)
     &              + SIGD(INDIC+3) * SIGD(INDIC+3)
     &              + SIGD(INDIC+4) * SIGD(INDIC+4) * DEUX
        IF(NDIM.EQ.3) SIGEQ(IGAU) = SIGEQ(IGAU)
     &              + SIGD(INDIC+5) * SIGD(INDIC+5) * DEUX
     &              + SIGD(INDIC+6) * SIGD(INDIC+6) * DEUX
        SIGEQ(IGAU) = (SIGEQ(IGAU) * TRDEMI) ** UNDEMI
  40  CONTINUE
C
C ----------------------------------------------------------------------
C --- 2. CALCUL DU TAUX DE TRIAXIALITE DES CONTRAINTES TRIAX
C ----------------------------------------------------------------------
C
      DO 50 IGAU = 1, NPG
        TRIAX(IGAU) = TRSIG(IGAU) / SIGEQ(IGAU)
  50  CONTINUE
C
C ----------------------------------------------------------------------
C --- 3. CALCUL DE LA CONTRAINTE EQUIVALENTE D'ENDOMMAGEMENT (SENDO)
C ---    ET DU CARRE DE LA CONTRAINTES EQUIVALENTE D'ENDOMMAGEMENT
C ---    NORMALISEE (CENDO)
C ----------------------------------------------------------------------
      DO 60 IGAU = 1, NPG
        CALL RCVALB(FAMI,IGAU,1,'+',ZI(IMATE),' ',PHENOM,0,' ',
     &                  0.D0,NBRES,NOMRES,VALRES,CODRES,'FM')
        CALL RCVALB(FAMI,IGAU,1,'+',ZI(IMATE),' ',PHENM2,0,' ',
     &                  0.D0,NBRES2,NOMRE2,VALRE2,CODRE2,'FM')

        TS = VALRE2(1)
        PSEUIL(IGAU) = VALRE2(2)
        PETITS(IGAU) = VALRE2(3)

        EXPO(IGAU) = DEUX*PETITS(IGAU)+UN
        IEXPO(IGAU) = UN/EXPO(IGAU)
        XES = VALRES(1)*TS*DEUX
        XNU = VALRES(2)
        COE1 = DETIER * (UN + XNU)
        COE2 = TROIS * (UN - DEUX * XNU)

        SENDO(IGAU) = (COE1*SIGEQ(IGAU)**DEUX
     &                 +COE2*TRSIG(IGAU)*TRSIG(IGAU))**UNDEMI
        CENDO(IGAU) = (COE1*SIGEQ(IGAU)**DEUX
     &                 +COE2*TRSIG(IGAU)*TRSIG(IGAU))/XES
  60  CONTINUE
C
C ----------------------------------------------------------------------
C --- 3. CALCUL DE L'ENDOMMAGEMENT DE LEMAITRE-SERMAGE DOMLE
C        ET DE L'ENDOMMAGEMENT CUMULE DOMCU
C ----------------------------------------------------------------------
C
C --- 3.1 RECUPERATION DU COMPORTEMENT
C
      CALL TECACH('OON','PVARIPR',7,JTAB,IRET)
      NBVARI = MAX(JTAB(6),1)*JTAB(7)
      NBSIG  = NBVARI
      CALL JEVECH('PCOMPOR','L',ICOMPO)

      CALL PSVARI (ZK16(ICOMPO),NBVARI,'3D',IEPSP,IBID)
C
C --- 3.2 AFFECTATION DU VECTEUR DE TRAVAIL XVARI[1,2], CENDOM, DOMMOI
C         ET DOMCU REPRESENTANT LES VARIABLES INTERNES @[T-,T+],
C         LA CONTRAINTE D'ENDOMMAGEMENT NORMALISEE @T-, L'ENDOMMAGEMENT
C         DE LEMAITRE-SERMAGE @T- ET L'ENDOMMAGEMENT CUMULE @T-
C
       K = 0
       DO 80 IGAU = 1, NPG
         DO 70 I = 1, NBSIG
           K = K+1
           XVARI1(I+(IGAU-1)*NBSIG) = ZR(IVARMR+K-1)
           XVARI2(I+(IGAU-1)*NBSIG) = ZR(IVARPR+K-1)
  70     CONTINUE
         CENDOM(IGAU) = ZR(IENDMG-1+4*(IGAU-1)+3)
         DOMMOI(IGAU) = ZR(IENDMG-1+4*(IGAU-1)+4)
  80  CONTINUE
C
C --- 3.3 RECUPERATION DE LA DEFORMATION PLASTIQUE CUMULEE
C         STOCKEE DANS LA PREMIERE COMPOSANTE DE VARI_[1,2] (IEPSP = 1)
      DO 90 IGAU = 1, NPG

        PPLUS = XVARI2(IEPSP+(IGAU-1)*NBSIG)
        IF (PPLUS.GT.PSEUIL(IGAU)-ZERO) THEN
          IF (DOMMOI(IGAU).GE.UN) THEN
            RESU1 = ZERO
          ELSE
            RESU1 = (UN-DOMMOI(IGAU))**EXPO(IGAU)
          ENDIF
          KMOISS = CENDOM(IGAU)**PETITS(IGAU)
          KPLUSS = CENDO(IGAU)**PETITS(IGAU)
          KSOMM  = KMOISS + KPLUSS
          PDIFF  = XVARI2(IEPSP+(IGAU-1)*NBSIG)
     &               - XVARI1(IEPSP+(IGAU-1)*NBSIG)
          RESU2  = (EXPO(IGAU)/DEUX)*KSOMM*PDIFF
          VALE   = RESU1 - RESU2
          IF (VALE.GT.ZERO) THEN
            DOMLE(IGAU) = UN-VALE**IEXPO(IGAU)
          ELSE
            DOMLE(IGAU) = UN+(-UN*VALE)**IEXPO(IGAU)
          ENDIF
        ELSE
          DOMLE(IGAU) = ZERO
        ENDIF
C
C --- 3.4 LA VALEUR DE L'ENDOMMAGEMENT EST BORNEE A 1
C
        IF (DOMLE(IGAU).GT.UN) THEN
          DOMLE(IGAU) = UN
        ENDIF
C
C
  90  CONTINUE
C
C ----------------------------------------------------------------------
C --- 5. RANGEMENT DE :
C       * TAUX DE TRIAXIALITE DES CONTRAINTES TRIAX
C       * CONTRAINTE EQUIVALENTE D'ENDOMMAGEMENT SENDO
C       * CONTRAINTE EQUIVALENTE D'ENDOMMAGEMENT NORMALISEE CENDO
C       * ENDOMMAGEMENT DE LEMAITRE-SERMAGE DOMLE
C ----------------------------------------------------------------------
C
      CALL JEVECH ('PTRIAPG','E',IDTRGP)

      DO 100 IGAU = 1, NPG
        ZR(IDTRGP-1+4*(IGAU-1)+1) = TRIAX(IGAU)
        ZR(IDTRGP-1+4*(IGAU-1)+2) = SENDO(IGAU)
        ZR(IDTRGP-1+4*(IGAU-1)+3) = CENDO(IGAU)
        ZR(IDTRGP-1+4*(IGAU-1)+4) = DOMLE(IGAU)
  100 CONTINUE
C
      END

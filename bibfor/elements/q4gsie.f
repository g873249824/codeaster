      SUBROUTINE Q4GSIE (OPTION,FAMI  ,XYZL  ,PGL   ,DEPL  ,NBCOU ,
     &                   CDL   )
      IMPLICIT  NONE
      CHARACTER*4   FAMI
      CHARACTER*16  OPTION
      REAL*8        XYZL(3,*),PGL(3,*), DEPL(*), CDL(*)
      INTEGER       NBCOU
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 20/02/2012   AUTEUR CHEIGNON E.CHEIGNON 
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
C     ------------------------------------------------------------------
C     RELATION ELAS_COQUE/ELAS_COQMU
C     CONTRAINTES DE L'ELEMENT DE PLAQUE Q4G (SIEF_ELGA)
C     ------------------------------------------------------------------
C     IN  XYZL   : COORDONNEES LOCALES DES QUATRE NOEUDS
C     IN  PGL    : MATRICE DE PASSAGE GLOBAL - LOCAL
C     IN  DEPL   : DEPLACEMENTS
C     OUT CDL    : CONTRAINTES AUX POINTS DE GAUSS DANS LE REPERE LOCAL
C                  LE CALCUL EST FAIT SUR UNE SEULE COUCHE (ELAS_COQUE)
C                  SUR 3 NIVEAUX : 3 PTS D INTEGRATION DANS L EPAISSEUR
C                  CORRESPONDANT AUX NIVEAUX INF, MOY, SUP
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER         ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8          ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16      ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL         ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                     ZK24
      CHARACTER*32                              ZK32
      CHARACTER*80                                       ZK80
      COMMON /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      INTEGER     NNOMAI
      PARAMETER  (NNOMAI=4)
      INTEGER     NDDLME
      PARAMETER  (NDDLME=2)
      INTEGER     NDDLFL
      PARAMETER  (NDDLFL=3)

      INTEGER     NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,IVF,IDFDX,IDFD2,JGANO
      INTEGER     JCACO,I,J,K,IE,ICPG,IG,ICOU,INIV,MULTIC
      REAL*8      ZIC,EPAIS,EXCEN
      REAL*8      DEPF(NDDLFL*NNOMAI),DEPM(NDDLME*NNOMAI)
      REAL*8      VT(2),LAMBDA(4)
      REAL*8      DF(3,3),DM(3,3),DMF(3,3),DC(2,2),DCI(2,2)
      REAL*8      DMC(3,2),DFC(3,2)
      REAL*8      H(3,3),D1I(2,2),D2I(2,4)
      REAL*8      BF(3,NDDLFL*NNOMAI),BM(3,NDDLME*NNOMAI)
      REAL*8      SM(3),SF(3),HLT2(4,6)
      REAL*8      EPS(3),SIG(3),CIST(2)
      REAL*8      QSI,ETA,CARAQ4(25),T2EV(4),T2VE(4),T1VE(9)
      REAL*8      BC(2,12)
      REAL*8      BCDF(2)
      REAL*8      JACOB(5),HICOU
      LOGICAL     COUPMF,LCALCT
C     ------------------------------------------------------------------
C
      CALL ELREF5(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,
     +                                         IVF,IDFDX,IDFD2,JGANO)
C
C     ----- RAPPEL DES MATRICES DE RIGIDITE DU MATERIAU EN FLEXION,
C           MEMBRANE ET CISAILLEMENT INVERSEES -------------------------
C     ----- CALCUL DES GRANDEURS GEOMETRIQUES SUR LE QUADRANGLE --------
      CALL GQUAD4 ( XYZL, CARAQ4 )

C     ----- CARACTERISTIQUES DES MATERIAUX --------
      CALL DXMATE(FAMI,DF,DM,DMF,DC,DCI,DMC,DFC,NNO,PGL,MULTIC,COUPMF,
     &                                                T2EV,T2VE,T1VE)

C     -------- CALCUL DE LA MATRICE DE HOOKE EN MEMBRANE ---------------
      IF (MULTIC.EQ.0) THEN
        CALL JEVECH('PCACOQU','L',JCACO)
        EPAIS = ZR(JCACO)
        HICOU = EPAIS/NBCOU
        EXCEN = ZR(JCACO-1+5)
        DO 10 K = 1,9
          H(K,1) = DM(K,1)/EPAIS
   10   CONTINUE
      END IF

C     ----- COMPOSANTES DEPLACEMENT MEMBRANE ET FLEXION ----------------
      DO 30 J = 1,NNOMAI
        DO 20 I = 1,NDDLME
          DEPM(I+2* (J-1)) = DEPL(I+6* (J-1))
   20   CONTINUE
        DEPF(1+3* (J-1)) = DEPL(1+2+6* (J-1))
        DEPF(2+3* (J-1)) = DEPL(3+2+6* (J-1))
        DEPF(3+3* (J-1)) = -DEPL(2+2+6* (J-1))
   30 CONTINUE
C              ---------------------
C
C  BOUCLE SUR LES POINTS D INTEGRATION
C
      IF (OPTION.EQ.'EPSI_ELGA')THEN
        LCALCT=.FALSE.
      ELSE
        LCALCT=.TRUE.
      ENDIF

      DO 300 IE = 1,NPG
        QSI = ZR(ICOOPG-1+NDIM*(IE-1)+1)
        ETA = ZR(ICOOPG-1+NDIM*(IE-1)+2)
C         ----- CALCUL DU JACOBIEN SUR LE QUADRANGLE ----------------
        CALL JQUAD4(XYZL,QSI,ETA,JACOB)
C         ------- CALCUL DU PRODUIT HL.T2 ---------------------------
        CALL DSXHLT(DF,JACOB(2),HLT2)
C         ----- CALCUL DE LA MATRICE BM -----------------------------
        CALL DXQBM(QSI,ETA,JACOB(2),BM)
C         ----- CALCUL DE LA MATRICE BF AU POINT QSI ETA ------------
        CALL DSQBFB(QSI,ETA,JACOB(2),BF)
C         ---- CALCUL DE LA MATRICE BC AU POINT QSI ETA -------------
        CALL Q4GBC(QSI,ETA,JACOB(2),CARAQ4,BC)
C         ------ SM = BM.DEPM ----------------------------------------
        DO 310 I = 1,3
          SM(I) = 0.D0
 310    CONTINUE
        DO 330 I = 1,3
          DO 320 J = 1,NDDLME*NNOMAI
            SM(I) = SM(I) + BM(I,J)*DEPM(J)
 320      CONTINUE
 330    CONTINUE
C         ------ SF = BF.DEPF ---------------------------------------
        DO 340 I = 1,3
          SF(I) = 0.D0
 340    CONTINUE
        DO 360 I = 1,3
          DO 350 J = 1,NDDLFL*NNOMAI
            SF(I) = SF(I) + BF(I,J)*DEPF(J)
 350      CONTINUE
 360    CONTINUE
C
C  BOUCLE SUR LES COUCHES
C
        DO 400 ICOU = 1, NBCOU
C
C  BOUCLE SUR LES POINTS D'INTEGRATION DANS L'EPAISSEUR DE LA COUCHE
C
          DO 500, IG = 1 , 3

C           INDICE DANS LE CHAMP DE CONTRAINTES A ECRIRE
            ICPG = 6*3*NBCOU*(IE-1) + 6*3*(ICOU-1) + 6*(IG-1)

            IF (MULTIC.EQ.0) THEN
C             -- MONOCOUCHE
C             -- COTE DES POINTS D'INTEGRATION
C             --------------------------------
              ZIC = EXCEN - EPAIS/2.D0 + (ICOU-1)*HICOU
              IF (IG.EQ.1) THEN
                ZIC = ZIC
              ELSE IF (IG.EQ.2) THEN
                ZIC = ZIC + HICOU/2.D0
              ELSE
                ZIC = ZIC + HICOU
              END IF
              D1I(1,1) = 3.D0/ (2.D0*EPAIS) -
     +                   ZIC*ZIC*6.D0/ (EPAIS*EPAIS*EPAIS)
              D1I(2,2) = D1I(1,1)
              D1I(1,2) = 0.D0
              D1I(2,1) = 0.D0
            ELSE
C             -- EN MULTICOUCHES
C             -- ON CALCULE TOUT D'UN COUP
              INIV = IG - 2
              CALL DXDMUL(LCALCT,ICOU,INIV,T1VE,T2VE,H,D1I,D2I,
     &                    ZIC,HICOU)
            ENDIF
C
            DO 370 I = 1,3
              EPS(I) = SM(I) + ZIC*SF(I)
              SIG(I) = 0.D0
 370        CONTINUE
C         ------ VT = DC.BC.DEPF -------------------------------------
            VT(1) = 0.D0
            VT(2) = 0.D0
            BCDF(1) = 0.D0
            BCDF(2) = 0.D0
            DO 230 J = 1,12
              BCDF(1) = BCDF(1) + BC(1,J)*DEPF(J)
              BCDF(2) = BCDF(2) + BC(2,J)*DEPF(J)
 230        CONTINUE
            VT(1) = DC(1,1)*BCDF(1) + DC(1,2)*BCDF(2)
            VT(2) = DC(2,1)*BCDF(1) + DC(2,2)*BCDF(2)

            IF (OPTION.EQ.'EPSI_ELGA') THEN
C           ------ DCIS = DCI.VT --------------------------------------
              CDL(ICPG+1) = EPS(1)
              CDL(ICPG+2) = EPS(2)
              CDL(ICPG+3) = 0.D0
C           --- PASSAGE DE LA DISTORSION A LA DEFORMATION DE CIS. ------
              CDL(ICPG+4) = EPS(3)/2.D0
              CDL(ICPG+5) = BCDF(1)/2.D0
              CDL(ICPG+6) = BCDF(2)/2.D0

            ELSE
C             SIEF_ELGA

              DO 390 I = 1,3
                DO 380 J = 1,3
                  SIG(I) = SIG(I) + H(I,J)*EPS(J)
 380            CONTINUE
 390          CONTINUE

C         ------ CIST = D1I.VT ( + D2I.LAMBDA SI MULTICOUCHES ) ------
              CIST(1) = D1I(1,1)*VT(1) + D1I(1,2)*VT(2)
              CIST(2) = D1I(2,1)*VT(1) + D1I(2,2)*VT(2)
              IF (MULTIC.GT.0) THEN
                CALL Q4GLXY(HLT2, DEPF, LAMBDA)
                DO 246 J = 1,4
                  CIST(1) = CIST(1) + D2I(1,J)*LAMBDA(J)
                  CIST(2) = CIST(2) + D2I(2,J)*LAMBDA(J)
 246            CONTINUE
              END IF
C
              CDL(ICPG+1) = SIG(1)
              CDL(ICPG+2) = SIG(2)
              CDL(ICPG+3) = 0.D0
              CDL(ICPG+4) = SIG(3)
              CDL(ICPG+5) = CIST(1)
              CDL(ICPG+6) = CIST(2)
            ENDIF
 500      CONTINUE
 400    CONTINUE
 300  CONTINUE
C
      END

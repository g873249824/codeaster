      SUBROUTINE Q4GCOL ( FAMI,XYZL, OPTION, PGL, ICOU, INIV, DEPL, CDL,
     &                     NPG )
      IMPLICIT  NONE
      INTEGER       ICOU, INIV, NPG
      REAL*8        XYZL(3,*),PGL(3,*), DEPL(*), CDL(*)
      CHARACTER*16  OPTION
      CHARACTER*4   FAMI
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2011   AUTEUR DESOZA T.DESOZA 
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
C     ------------------------------------------------------------------
C     CONTRAINTES DE L'ELEMENT DE PLAQUE Q4GAMMA
C     ------------------------------------------------------------------
C     IN  XYZL   : COORDONNEES LOCALES DES TROIS NOEUDS
C     IN  OPTION : NOM DE L'OPTION DE CALCUL
C     IN  PGL    : MATRICE DE PASSAGE GLOBAL - LOCAL
C     IN  ICOU   : NUMERO DE LA COUCHE
C     IN  INIV   : NIVEAU DANS LA COUCHE (-1:INF , 0:MOY , 1:SUP)
C     IN  DEPL   : DEPLACEMENTS
C     OUT CDL    : CONTRAINTES AUX NOEUDS SIGM_ELNO DANS LE REPERE
C                  INTRINSEQUE A L'ELEMENT
C                : CONTRAINTES AUX GAUSS SIEF_ELGA DANS LE REPERE
C                  INTRINSEQUE A L'ELEMENT CAS ELAS_COQUE
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
      INTEGER  NDIM,NNO,NNOS,IPOIDS,ICOOPG,IVF,IDFDX,IDFD2,JGANO,JNBSP
      INTEGER  MULTIC,NE,JCACO,I,J,K,IE,NBCOU
      REAL*8   HIC,ZMIN,DEUX,X3I,EPAIS,EXCEN
      REAL*8   DEPF(12),DEPM(8),H(3,3),D1I(2,2),D2I(2,4),DMC(3,2)
      REAL*8   DF(3,3),DM(3,3),DMF(3,3),DC(2,2),DCI(2,2),DFC(3,2)
      REAL*8   BF(3,12),BM(3,8),BC(2,12)
      REAL*8   SM(3),SF(3),HLT2(4,6),VT(2),LAMBDA(4)
      REAL*8   EPS(3),SIG(3),BCDF(2),CIST(2),CARAQ4(25)
      REAL*8   T2EV(4), T2VE(4), T1VE(9), JACOB(5), QSI, ETA
      LOGICAL  COUPMF
C     ------------------------------------------------------------------
C
      CALL ELREF5(' ','NOEU',NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,
     +                                         IVF,IDFDX,IDFD2,JGANO)
      NE  = NNO
C
      DEUX = 2.D0
C
C     ----- RAPPEL DES MATRICES DE RIGIDITE DU MATERIAU EN FLEXION,
C           MEMBRANE ET CISAILLEMENT INVERSEES -------------------------
C     ----- CALCUL DES GRANDEURS GEOMETRIQUES SUR LE QUADRANGLE --------
      CALL GQUAD4 ( XYZL, CARAQ4 )
C
C     ----- CARACTERISTIQUES DES MATERIAUX --------
      CALL DXMATE(FAMI,DF,DM,DMF,DC,DCI,DMC,DFC,NNO,PGL,MULTIC,
     +                                         COUPMF,T2EV,T2VE,T1VE)
C
C     -------- CALCUL DE D1I ET D2I ------------------------------------
      IF (MULTIC.EQ.0) THEN
        CALL JEVECH('PCACOQU','L',JCACO)
        EPAIS = ZR(JCACO)
        CALL JEVECH('PNBSP_I','L',JNBSP)
        NBCOU = ZI(JNBSP)
        HIC = EPAIS/NBCOU
        ZMIN = -EPAIS/2.0D0
        EXCEN = ZR(JCACO+5-1)
        IF (INIV.LT.0) THEN
          X3I = ZMIN + (ICOU - 1)*HIC + EXCEN
        ELSE IF (INIV.EQ.0) THEN
          X3I = ZMIN + (ICOU - 1)*HIC + HIC/2.0D0 + EXCEN
        ELSE IF (INIV.GT.0) THEN
          X3I = ZMIN + (ICOU - 1)*HIC + HIC + EXCEN
        END IF
        DO 10 K = 1,9
          H(K,1) = DM(K,1)/EPAIS
   10   CONTINUE
        D1I(1,1) = 3.D0/ (DEUX*EPAIS) -
     +             X3I*X3I*6.D0/ (EPAIS*EPAIS*EPAIS)
        D1I(2,2) = D1I(1,1)
        D1I(1,2) = 0.D0
        D1I(2,1) = 0.D0
      ELSE
        CALL DXDMUL(ICOU,INIV,T1VE,T2VE,H,D1I,D2I,X3I,HIC)
      END IF
C     ----- COMPOSANTES DEPLACEMENT MEMBRANE ET FLEXION ----------------
      DO 30 J = 1,NNO
        DO 20 I = 1,2
          DEPM(I+2* (J-1)) = DEPL(I+6* (J-1))
   20   CONTINUE
        DEPF(1+3* (J-1)) = DEPL(1+2+6* (J-1))
        DEPF(2+3* (J-1)) = DEPL(3+2+6* (J-1))
        DEPF(3+3* (J-1)) = -DEPL(2+2+6* (J-1))
   30 CONTINUE
C     
C            ---------------------
      DO 210 IE = 1,NE
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
C         ------ SM = BM.DEPM ---------------------------------------
        DO 212 I = 1,3
          SM(I) = 0.D0
 212    CONTINUE
        DO 214 I = 1,3
          DO 216 J = 1,8
            SM(I) = SM(I) + BM(I,J)*DEPM(J)
 216      CONTINUE
 214    CONTINUE
C         ------ SF = BF.DEPF ---------------------------------------
        DO 218 I = 1,3
          SF(I) = 0.D0
 218    CONTINUE
        DO 220 I = 1,3
          DO 222 J = 1,12
            SF(I) = SF(I) + BF(I,J)*DEPF(J)
 222      CONTINUE
 220    CONTINUE
        DO 224 I = 1,3
          EPS(I) = SM(I) + X3I*SF(I)
          SIG(I) = 0.D0
 224    CONTINUE
        DO 226 I = 1,3
          DO 228 J = 1,3
            SIG(I) = SIG(I) + H(I,J)*EPS(J)
 228      CONTINUE
 226    CONTINUE
C         ------ VT = DC.BC.DEPF -------------------------------------
        VT(1) = 0.D0
        VT(2) = 0.D0
        BCDF(1) = 0.D0
        BCDF(2) = 0.D0
        DO 230 J = 1,12
          BCDF(1) = BCDF(1) + BC(1,J)*DEPF(J)
          BCDF(2) = BCDF(2) + BC(2,J)*DEPF(J)
 230    CONTINUE
        VT(1) = DC(1,1)*BCDF(1) + DC(1,2)*BCDF(2)
        VT(2) = DC(2,1)*BCDF(2) + DC(2,2)*BCDF(2)
C         ------ CIST = D1I.VT ( + D2I.LAMBDA SI MULTICOUCHES ) ------
        CIST(1) = D1I(1,1)*VT(1) + D1I(1,2)*VT(2)
        CIST(2) = D1I(2,1)*VT(1) + D1I(2,2)*VT(2)
        IF (MULTIC.GT.0) THEN
          CALL Q4GLXY(HLT2, DEPF, LAMBDA)
          DO 246 J = 1,4
            CIST(1) = CIST(1) + D2I(1,J)*LAMBDA(J)
            CIST(2) = CIST(2) + D2I(2,J)*LAMBDA(J)
 246      CONTINUE
        END IF
        CDL(1+6* (IE-1)) = SIG(1)
        CDL(2+6* (IE-1)) = SIG(2)
        CDL(3+6* (IE-1)) = 0.D0
        CDL(4+6* (IE-1)) = SIG(3)
        CDL(5+6* (IE-1)) = CIST(1)
        CDL(6+6* (IE-1)) = CIST(2)
 210  CONTINUE

C
      END

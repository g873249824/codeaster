      SUBROUTINE DSQCOL ( FAMI,XYZL, PGL, ICOU, INIV, DEPL, CDL)
      IMPLICIT  NONE
      INTEGER       ICOU, INIV
      REAL*8        XYZL(3,*),PGL(3,*), DEPL(*), CDL(*)
      CHARACTER*4   FAMI
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/05/2011   AUTEUR MACOCCO K.MACOCCO 
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
C     CONTRAINTES DE L'ELEMENT DE PLAQUE DSQ
C     ------------------------------------------------------------------
C     IN  XYZL   : COORDONNEES LOCALES DES TROIS NOEUDS
C     IN  PGL    : MATRICE DE PASSAGE GLOBAL - LOCAL
C     IN  ICOU   : NUMERO DE LA COUCHE
C     IN  INIV   : NIVEAU DANS LA COUCHE (-1:INF , 0:MOY , 1:SUP)
C     IN  DEPL   : DEPLACEMENTS
C     OUT CDL    : CONTRAINTES AUX NOEUDS DANS LE REPERE
C                  INTRINSEQUE A L'ELEMENT
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
      INTEGER       MULTIC,NE,JCACO,I,J,K,IE,NBCOU,NPG
      REAL*8        HIC,ZMIN,DEUX,X3I,EPAIS
      REAL*8        QSI,ETA
      REAL*8        DEPF(12),DEPM(8),H(3,3),D1I(2,2),D2I(2,4),DMC(3,2)
      REAL*8        DF(3,3),DM(3,3),DMF(3,3),DC(2,2),DCI(2,2),DFC(3,2)
      REAL*8        HFT2(2,6),HLT2(4,6),AN(4,12),HMFT2(2,6)
      REAL*8        BFB(3,12),BFA(3,4),BFN(3,12),BF(3,12)
      REAL*8        BCB(2,12),BCA(2,4),BCN(2,12),BC(2,12),BCM(2,8)
      REAL*8        BM(3,8)
      REAL*8        SF(3),SM(3),VT(2),LAMBDA(4),EXCEN
      REAL*8        EPS(3),SIG(3),CIST(2)
      REAL*8        JACOB(5),CARAQ4(25),T2EV(4),T2VE(4),T1VE(9)
      LOGICAL       COUPMF
C     ------------------------------------------------------------------
C
      CALL ELREF5(' ','NOEU',NDIM,NNO,NNOS,NPG,IPOIDS,ICOOPG,
     +                                         IVF,IDFDX,IDFD2,JGANO)
      NE  = NNO
C
      DEUX = 2.D0

C     ----- RAPPEL DES MATRICES DE RIGIDITE DU MATERIAU EN FLEXION,
C           MEMBRANE ET CISAILLEMENT INVERSEES -------------------------
C     ----- CALCUL DES GRANDEURS GEOMETRIQUES SUR LE QUADRANGLE --------
      CALL GQUAD4 ( XYZL, CARAQ4 )

C     ----- CARACTERISTIQUES DES MATERIAUX --------
      CALL DXMATE(FAMI,DF,DM,DMF,DC,DCI,DMC,DFC,NNO,PGL,MULTIC,
     +                                         COUPMF,T2EV,T2VE,T1VE)

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
        CALL DXDMUL(.TRUE.,ICOU,INIV,T1VE,T2VE,H,D1I,D2I,X3I,HIC)
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
C     ---- CALCUL DE LA MATRICE AN -------------------------------------
      CALL DSQDIS(XYZL,CARAQ4,DF,DCI,AN)
C              ---------------------
      DO 210 IE = 1,NE
        QSI = ZR(ICOOPG-1+NDIM*(IE-1)+1)
        ETA = ZR(ICOOPG-1+NDIM*(IE-1)+2)
C         ----- CALCUL DU JACOBIEN SUR LE QUADRANGLE -----------------
        CALL JQUAD4 ( XYZL, QSI, ETA, JACOB )
C
C ---   CALCUL DU PRODUIT HF.T2 :
C       ------------------------
        CALL DSXHFT ( DF, JACOB(2), HFT2 )
C
C ---   CALCUL DU PRODUIT HMF.T2 :
C       ------------------------
        CALL DXHMFT ( DMF, JACOB(2), HMFT2 )
C
C ---   CALCUL DES MATRICES BCB, BCA ET BCM :
C       -----------------------------------
        CALL DSQCIS ( QSI, ETA, CARAQ4, HMFT2, HFT2, BCM, BCB, BCA )
C
C         ------ BC = BCB + BCA.AN -----------------------------------
        DO 214 I = 1,2
          DO 216 J = 1,12
            BCN(I,J) = 0.D0
            DO 218 K = 1,4
              BCN(I,J) = BCN(I,J) + BCA(I,K)*AN(K,J)
 218        CONTINUE
            BC(I,J) = BCB(I,J) + BCN(I,J)
 216      CONTINUE
 214    CONTINUE
C         ------ VT = BC.DEPF ---------------------------------------
        VT(1) = 0.D0
        VT(2) = 0.D0
        DO 220 I = 1,2
          DO 222 J = 1,12
            VT(I) = VT(I) + BC(I,J)*DEPF(J)
 222      CONTINUE
 220    CONTINUE
C         ------ CIST = D1I.VT ( + D2I.LAMBDA SI MULTICOUCHES ) ------
        CIST(1) = D1I(1,1)*VT(1) + D1I(1,2)*VT(2)
        CIST(2) = D1I(2,1)*VT(1) + D1I(2,2)*VT(2)
        IF (MULTIC.GT.0) THEN
C         ------- CALCUL DU PRODUIT HL.T2 ------------------------
          CALL DSXHLT ( DF, JACOB(2), HLT2 )
          CALL DSQLXY(QSI,ETA,HLT2,AN,DEPF,CARAQ4(13),LAMBDA)
          DO 252 J = 1,4
            CIST(1) = CIST(1) + D2I(1,J)*LAMBDA(J)
            CIST(2) = CIST(2) + D2I(2,J)*LAMBDA(J)
 252      CONTINUE
        END IF
C         ----- CALCUL DE LA MATRICE BM AU POINT QSI ETA -------------
        CALL DXQBM ( QSI, ETA, JACOB(2), BM )
C         ------ SM = BM.DEPM ----------------------------------------
        DO 254 I = 1,3
          SM(I) = 0.D0
 254    CONTINUE
        DO 256 I = 1,3
          DO 258 J = 1,8
            SM(I) = SM(I) + BM(I,J)*DEPM(J)
 258      CONTINUE
 256    CONTINUE
C         ----- CALCUL DE LA MATRICE BFB AU POINT QSI ETA -----------
        CALL DSQBFB ( QSI, ETA, JACOB(2), BFB )
C         ----- CALCUL DE LA MATRICE BFA AU POINT QSI ETA -----------
        CALL DSQBFA ( QSI, ETA, JACOB(2), CARAQ4, BFA )
C         ------ BF = BFB + BFA.AN ----------------------------------
        DO 262 I = 1,3
          DO 264 J = 1,12
            BFN(I,J) = 0.D0
            DO 266 K = 1,4
              BFN(I,J) = BFN(I,J) + BFA(I,K)*AN(K,J)
 266        CONTINUE
            BF(I,J) = BFB(I,J) + BFN(I,J)
 264      CONTINUE
 262    CONTINUE
C         ------ SF = BF.DEPF ---------------------------------------
        DO 268 I = 1,3
          SF(I) = 0.D0
 268    CONTINUE
        DO 270 I = 1,3
          DO 272 J = 1,12
            SF(I) = SF(I) + BF(I,J)*DEPF(J)
 272      CONTINUE
 270    CONTINUE
        DO 274 I = 1,3
          EPS(I) = SM(I) + X3I*SF(I)
          SIG(I) = 0.D0
 274    CONTINUE
        DO 276 I = 1,3
          DO 278 J = 1,3
            SIG(I) = SIG(I) + H(I,J)*EPS(J)
 278      CONTINUE
 276    CONTINUE
        CDL(1+6* (IE-1)) = SIG(1)
        CDL(2+6* (IE-1)) = SIG(2)
        CDL(3+6* (IE-1)) = 0.D0
        CDL(4+6* (IE-1)) = SIG(3)
        CDL(5+6* (IE-1)) = CIST(1)
        CDL(6+6* (IE-1)) = CIST(2)
 210  CONTINUE
C
      END

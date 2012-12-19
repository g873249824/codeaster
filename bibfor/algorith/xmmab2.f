      SUBROUTINE XMMAB2(NDIM  ,JNNE,NDEPLE,NNC   ,JNNM   ,
     &                  NFAES ,CFACE ,HPG   ,FFC   ,FFE   ,
     &                  FFM   ,JACOBI,JPCAI, LAMBDA,COEFCR,
     &                  COEFCP,COEFFR,DLAGRF,JEU,
     &                  COEFFP,LPENAF,COEFFF,TAU1  ,TAU2  ,
     &                  RESE  ,NRESE ,MPROJ ,NORM  ,TYPMAI,
     &                  NSINGE,NSINGM,RRE   ,RRM   ,NVIT  ,
     &                  NCONTA,JDDLE,JDDLM,NFHE,MMAT  )   
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C TOLE CRP_21
C
      IMPLICIT NONE
      INTEGER  NDIM,NNC,JNNE(3),JNNM(3),NFAES,JPCAI,CFACE(5,3)
      INTEGER  NSINGE,NSINGM,NFHE
      INTEGER  NVIT,NCONTA,NDEPLE,JDDLE(2),JDDLM(2)
      REAL*8   HPG,FFC(8),FFE(20),FFM(20),JACOBI,NORM(3),COEFCP
      REAL*8   LAMBDA,COEFFF,COEFFR,RRE,RRM,COEFCR,COEFFP,DLAGRF(2)
      REAL*8   TAU1(3),TAU2(3),RESE(3),NRESE,MMAT(336,336),MPROJ(3,3)
      REAL*8   JEU
      CHARACTER*8  TYPMAI
      LOGICAL  LPENAF
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
C
C CALCUL DE B ET DE BT POUR LE CONTACT METHODE CONTINUE
C SANS ADHERENCE
C
C ----------------------------------------------------------------------
C
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  NNES   : NOMBRE DE NOEUDS SOMMETS DE LA MAILLE ESCLAVE
C IN  NNC    : NOMBRE DE NOEUDS DE CONTACT
C IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
C IN  NFAES  : NUMERO DE LA FACETTE DE CONTACT ESCLAVE
C IN  CFACE  : MATRICE DE CONECTIVITE DES FACETTES DE CONTACT
C IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFC    : FONCTIONS DE FORME DU PT CONTACT DANS ELC
C IN  FFE    : FONCTIONS DE FORME DU PT CONTACT DANS ESC
C IN  FFM    : FONCTIONS DE FORME DE LA PROJECTION DU PTC DANS MAIT
C IN  NDDLSE : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  JPCAI  : POINTEUR VERS LE VECTEUR DES ARRETES ESCLAVES
C              INTERSECTEES
C IN  LAMBDA : VALEUR DU SEUIL
C IN  COEFFA : COEF_REGU_FROT
C IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C IN  TAU1   : PREMIERE TANGENTE
C IN  TAU2   : SECONDE TANGENTE
C IN  RESE   : PROJECTION DE LA BOULE UNITE POUR LE FROTTEMENT
C IN  NRESE  : RACINE DE LA NORME DE RESE
C IN  MPROJ  : MATRICE DE L'OPERATEUR DE PROJECTION
C IN  TYPMAI : NOM DE LA MAILLE ESCLAVE D'ORIGINE (QUADRATIQUE)
C IN  NSINGE : NOMBRE DE FONCTION SINGULIERE ESCLAVE
C IN  NSINGM : NOMBRE DE FONCTION SINGULIERE MAITRE
C IN  RRE    : SQRT LST ESCLAVE
C IN  RRM    : SQRT LST MAITRE
C IN  NVIT   : POINT VITAL OU PAS
C I/O MMAT   : MATRICE ELEMENTAIRE DE CONTACT/FROTTEMENT
C
C ----------------------------------------------------------------------
C
      INTEGER   I,J,K,L,M,II,JJ,INI,INJ,PLI,PLJ,XOULA,IIN,JJN,DDLE
      INTEGER   NNE,NNES,NNM,NNMS,DDLES,DDLEM,DDLMS,DDLMM
      REAL*8    C1(3),C2(3),C3(3),D1(3),D2(3),D3(3),H1(3),H2(3)
      REAL*8    G(3,3),D(3,3),B(3,3),C(3,3),R(3,3),MP,MB,MBT,MM,MMT
      REAL*8    F(3,3),TT(3,3),DDOT
C ----------------------------------------------------------------------
C
C --- INITIALISATIONS
C
      NNE=JNNE(1)
      NNES=JNNE(2)
      NNM=JNNM(1)
      NNMS=JNNM(2)
      DDLES=JDDLE(1)
      DDLEM=JDDLE(2)
      DDLMS=JDDLM(1)
      DDLMM=JDDLM(2)
C
      DO 1 I = 1,3
        DO 2 J = 1,3
          G(I,J) = 0.D0
          D(I,J) = 0.D0
          B(I,J) = 0.D0
          R(I,J) = 0.D0
          TT(I,J)=0.D0
2       CONTINUE
1     CONTINUE
      DO 3 K = 1,3
        C1(K) = MPROJ(K,1)
        C2(K) = MPROJ(K,2)
        C3(K) = MPROJ(K,3)
        D1(K) = 0.D0
        D2(K) = 0.D0
        D3(K) = 0.D0
        H1(K) = 0.D0
        H2(K) = 0.D0
3     CONTINUE
C
C --- G = [K][P_TAU]
C
      CALL MKKVEC(RESE,NRESE,NDIM,C1,D1)
      CALL MKKVEC(RESE,NRESE,NDIM,C2,D2)
      CALL MKKVEC(RESE,NRESE,NDIM,C3,D3)

      DO 4 K = 1,NDIM
        G(K,1) = D1(K)
        G(K,2) = D2(K)
        G(K,3) = D3(K)
4     CONTINUE
C
C --- D = [P_TAU]*[K]*[P_TAU]
C
      DO 13 I = 1,NDIM
        DO 14 J = 1,NDIM
          DO 15 K = 1,NDIM
            D(I,J) = G(K,I)*MPROJ(K,J) + D(I,J)
15        CONTINUE
14      CONTINUE
13    CONTINUE
C
      CALL MKKVEC(RESE,NRESE,NDIM,TAU1,H1)
      CALL MKKVEC(RESE,NRESE,NDIM,TAU2,H2)
C
C --- B = [P_B,[K]TAU1,[K]TAU2]*[P_TAU]
C
      CALL NORMEV(RESE,NRESE)
      DO 24 I = 1,NDIM
        DO 25  K = 1,NDIM
          B(1,I) = RESE(K)*MPROJ(K,I)+B(1,I)
          B(2,I) = H1(K)*MPROJ(K,I)+B(2,I)
          B(3,I) = H2(K)*MPROJ(K,I)+B(3,I)
25      CONTINUE
24    CONTINUE
C
C --- C = (P_B)[P_TAU]*(N)
C
      DO 8 I = 1,NDIM
        DO 9 J = 1,NDIM
          C(I,J) = B(1,I)*NORM(J)
9       CONTINUE
8     CONTINUE
C
C --- R = [TAU1,TAU2][ID-K][TAU1,TAU2]
C
      DO 857 K = 1,NDIM
        R(1,1) = (TAU1(K)-H1(K))*TAU1(K) + R(1,1)
        R(1,2) = (TAU1(K)-H1(K))*TAU2(K) + R(1,2)
        R(2,1) = (TAU2(K)-H2(K))*TAU1(K) + R(2,1)
        R(2,2) = (TAU2(K)-H2(K))*TAU2(K) + R(2,2)
857   CONTINUE
C
C---- TT = [TAU1,TAU2][ID][TAU1,TAU2]
C
      DO 301 I = 1,NDIM
        TT(1,1) = TAU1(I)*TAU1(I) + TT(1,1)
        TT(1,2) = TAU1(I)*TAU2(I) + TT(1,2)
        TT(2,1) = TAU2(I)*TAU1(I) + TT(2,1)
        TT(2,2) = TAU2(I)*TAU2(I) + TT(2,2)
301   CONTINUE
C
      IF(NCONTA.EQ.3.AND.NDIM.EQ.3) THEN
      MP = (LAMBDA-COEFCR*JEU)*COEFFF*HPG*JACOBI
      ELSE
      MP = LAMBDA*COEFFF*HPG*JACOBI
      ENDIF

      DDLE = DDLES*NNES+DDLEM*(NNE-NNES)

      IF (NNM.NE.0) THEN
C
C --------------------- CALCUL DE [A] ET [B] -----------------------
C
      DO 70 L = 1,NDIM
        DO 10 K = 1,NDIM
          IF (L.EQ.1) THEN
C SUPPRESSION DU TERME EN AT DANS LE CAS DU GLISSEMENT
            MB  = 0.D0
            IF(NCONTA.EQ.3.AND.NDIM.EQ.3) THEN
               MBT = COEFFF*HPG*JACOBI*B(L,K)
            ELSE
            MBT = 0.D0
            ENDIF
          ELSE
            IF(.NOT.LPENAF) THEN
                 IF(NCONTA.EQ.3.AND.NDIM.EQ.3) THEN
                   MB  = NVIT*HPG*JACOBI*B(L,K)
                  ELSE
                   MB  = NVIT*MP*B(L,K)
                 ENDIF
            ENDIF
            IF(LPENAF)      MB  = 0.D0
            IF(.NOT.LPENAF) MBT = MP*B(L,K)
            IF(LPENAF)      MBT = 0.D0
          ENDIF
          DO 20 I = 1,NNC
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,I,NFHE,PLI)
            II = PLI+L-1
            DO 30 J = 1,NDEPLE
C --- BLOCS ES:CONT, CONT:ES
              MM = MB*FFC(I)*FFE(J)
              MMT= MBT*FFC(I)*FFE(J)
              CALL INDENT(J,DDLES,DDLEM,NNES,JJN)
              JJ = JJN+K
              MMAT(II,JJ) = -MM
              MMAT(JJ,II) = -MMT
              JJ = JJ + NDIM
              MMAT(II,JJ) = MM
              MMAT(JJ,II) = MMT
              DO 40 M = 1,NSINGE
                JJ = JJ + NDIM
                MMAT(II,JJ) = RRE * MM
                MMAT(JJ,II) = RRE * MMT
40            CONTINUE
30          CONTINUE
            DO 50 J = 1,NNM
C --- BLOCS MA:CONT, CONT:MA
              MM = MB*FFC(I)*FFM(J)
              MMT= MBT*FFC(I)*FFM(J)
              CALL INDENT(J,DDLMS,DDLMM,NNMS,JJN)
              JJ = DDLE + JJN + K
              MMAT(II,JJ) = MM
              MMAT(JJ,II) = MMT
              JJ = JJ + NDIM
              MMAT(II,JJ) = MM
              MMAT(JJ,II) = MMT
              DO 60 M = 1,NSINGM
                JJ = JJ + NDIM
                MMAT(II,JJ) = RRM * MM
                MMAT(JJ,II) = RRM * MMT
60            CONTINUE
50          CONTINUE
20        CONTINUE
10      CONTINUE
70    CONTINUE
C
C --------------------- CALCUL DE [BU] ---------------------------------
C
      DO 100 K = 1,NDIM
        DO 110 L = 1,NDIM
          IF(LPENAF) THEN
            MB  = -MP*COEFFP*D(L,K)
            MBT = -MP*COEFFP*D(L,K)
          ELSE
            IF(NCONTA.EQ.3.AND.NDIM.EQ.3) THEN
            MB  = -MP*COEFFR*D(L,K)+COEFCR*COEFFF*HPG*JACOBI*C(L,K)
            MBT = -MP*COEFFR*D(L,K)+COEFCR*COEFFF*HPG*JACOBI*C(L,K)
            ELSE
            MB  = -MP*COEFFR*D(L,K)
            MBT = -MP*COEFFR*D(L,K)
            ENDIF
          ENDIF
          DO 200 I = 1,NDEPLE
            DO 210 J = 1,NDEPLE
C --- BLOCS ES:ES
              MM = MB *FFE(I)*FFE(J)
              MMT= MBT*FFE(I)*FFE(J)
              CALL INDENT(I,DDLES,DDLEM,NNES,IIN)
              CALL INDENT(J,DDLES,DDLEM,NNES,JJN)
              II = IIN + L
              JJ = JJN + K
              MMAT(II,JJ) =  MM
              JJ = JJ + NDIM
              MMAT(II,JJ) = -MM
              MMAT(JJ,II) = -MMT
              II = II + NDIM
              MMAT(II,JJ) =  MM
              DO 215 M = 1,NSINGE
                JJ = JJ + NDIM
                II = II - NDIM
                MMAT(II,JJ) = -RRE * MM
                MMAT(JJ,II) = -RRE * MMT
                II = II + NDIM
                MMAT(II,JJ) =  RRE * MM
                MMAT(JJ,II) =  RRE * MMT
                II = II + NDIM
                MMAT(II,JJ) =  RRE * RRE * MM
215           CONTINUE
210         CONTINUE
            DO 220 J = 1,NNM
C --- BLOCS ES:MA, MA:ES
              MM = MB *FFE(I)*FFM(J)
              MMT= MBT*FFE(I)*FFM(J)
              CALL INDENT(I,DDLES,DDLEM,NNES,IIN)
              CALL INDENT(J,DDLMS,DDLMM,NNMS,JJN)
              II = IIN + L
              JJ = DDLE + JJN + K
              MMAT(II,JJ) = -MM
              MMAT(JJ,II) = -MMT
              JJ = JJ + NDIM
              MMAT(II,JJ) = -MM
              MMAT(JJ,II) = -MMT
              II = II + NDIM
              JJ = JJ - NDIM
              MMAT(II,JJ) =  MM
              MMAT(JJ,II) =  MMT
              JJ = JJ + NDIM
              MMAT(II,JJ) =  MM
              MMAT(JJ,II) =  MMT
              DO 230 M = 1,NSINGM
                II = II - NDIM
                JJ = JJ + NDIM
                MMAT(II,JJ) = -RRM * MM
                MMAT(JJ,II) = -RRM * MMT
                II = II + NDIM
                MMAT(II,JJ) =  RRM * MM
                MMAT(JJ,II) =  RRM * MMT
                JJ = JJ - NDIM
230           CONTINUE
              DO 240 M = 1,NSINGE
                II = II + NDIM
                JJ = JJ - NDIM
                MMAT(II,JJ) =  RRE * MM
                MMAT(JJ,II) =  RRE * MMT
                JJ = JJ + NDIM
                MMAT(II,JJ) =  RRE * MM
                MMAT(JJ,II) =  RRE * MMT
                II = II - NDIM
240           CONTINUE
              DO 250 M = 1,NSINGE*NSINGM
                II = II + NDIM
                JJ = JJ + NDIM
                MMAT(II,JJ) =  RRE * RRM * MM
                MMAT(JJ,II) =  RRE * RRM * MMT
250           CONTINUE
220         CONTINUE
200       CONTINUE
          DO 300 I = 1,NNM
            DO 320 J = 1,NNM
C --- BLOCS MA:MA
              MM = MB *FFM(I)*FFM(J)
              MMT= MBT*FFM(I)*FFM(J)
              CALL INDENT(I,DDLMS,DDLMM,NNMS,IIN)
              CALL INDENT(J,DDLMS,DDLMM,NNMS,JJN)
              II = DDLE + IIN + L
              JJ = DDLE + JJN + K
              MMAT(II,JJ) =  MM
              JJ = JJ + NDIM
              MMAT(II,JJ) =  MM
              MMAT(JJ,II) =  MMT
              II = II + NDIM
              MMAT(II,JJ) =  MM
              DO 330 M = 1,NSINGM
                JJ = JJ + NDIM
                II = II - NDIM
                MMAT(II,JJ) =  RRM * MM
                MMAT(JJ,II) =  RRM * MMT
                II = II + NDIM
                MMAT(II,JJ) =  RRM * MM
                MMAT(JJ,II) =  RRM * MMT
                II = II + NDIM
                MMAT(II,JJ) =  RRM * RRM * MM
330           CONTINUE
320         CONTINUE
300       CONTINUE
110     CONTINUE
100   CONTINUE
C
      ELSE
C --------------------- CALCUL DE [A] ET [B] -----------------------
C
      DO 550 L = 1,NDIM
        DO 510 K = 1,NDIM
          IF (L.EQ.1) THEN
            MB  = 0.D0
            IF(NCONTA.EQ.3.AND.NDIM.EQ.3) THEN
            MBT = COEFFF*HPG*JACOBI*B(L,K) 
            ELSE
            MBT = 0.D0
            ENDIF
          ELSE
            IF(.NOT.LPENAF) THEN
            IF(NCONTA.EQ.3.AND.NDIM.EQ.3) THEN
            MB  = NVIT*HPG*JACOBI*B(L,K)
            ELSE
            MB  = NVIT*MP*B(L,K)
            ENDIF
            ENDIF
            IF(LPENAF)     MB = 0.D0
            IF(.NOT.LPENAF) MBT = MP*B(L,K)
            IF(LPENAF)      MBT = 0.D0
          ENDIF
          DO 520 I = 1,NNC
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,I,NFHE,PLI)
            II = PLI+L-1
            DO 530 J = 1,NDEPLE
C --- BLOCS ES:CONT, CONT:ES
              MM = MB*FFC(I)*FFE(J)
              MMT= MBT*FFC(I)*FFE(J)
              CALL INDENT(J,DDLES,DDLEM,NNES,JJN)
              JJ = JJN + K
              MMAT(II,JJ) = RRE * MM
              MMAT(JJ,II) = RRE * MMT
530         CONTINUE
520       CONTINUE
510     CONTINUE
550   CONTINUE
C
C --------------------- CALCUL DE [BU] ---------------------------------
C
      DO 600 K = 1,NDIM
        DO 610 L = 1,NDIM
          IF(LPENAF) THEN
            MB  = -MP*COEFFP*D(L,K)
          ELSE
            IF(NCONTA.EQ.3.AND.NDIM.EQ.3) THEN
            MB  = -MP*COEFFR*D(L,K)+COEFCR*COEFFF*HPG*JACOBI*C(L,K)
            ELSE
            MB  = -MP*COEFFR*D(L,K)
            ENDIF
          ENDIF
          DO 620 I = 1,NDEPLE
            DO 630 J = 1,NDEPLE
C --- BLOCS ES:ES
              MM = MB *FFE(I)*FFE(J)
              CALL INDENT(I,DDLES,DDLEM,NNES,IIN)
              CALL INDENT(J,DDLES,DDLEM,NNES,JJN)
              II = IIN + L
              JJ = JJN + K
              MMAT(II,JJ) = RRE * RRE * MM
630         CONTINUE
620       CONTINUE
610     CONTINUE
600   CONTINUE
      ENDIF
C
C --------------------- CALCUL DE [F] ----------------------------------
C
      IF (NVIT.EQ.1) THEN
      DO 400 I = 1,NNC
        DO 410 J = 1,NNC
          CALL XPLMA2(NDIM,NNE,NNES,DDLES,I,NFHE,PLI)
          CALL XPLMA2(NDIM,NNE,NNES,DDLES,J,NFHE,PLJ)
          DO 420 L = 1,NDIM-1
            DO 430 K = 1,NDIM-1
              II = PLI+K
              JJ = PLJ+L
              IF(LPENAF) THEN
                MMAT(II,JJ) = HPG*JACOBI*FFC(I)*FFC(J)*TT(K,L)
              ELSE
                IF(NCONTA.EQ.3.AND.NDIM.EQ.3) THEN
                MMAT(II,JJ) = JACOBI*HPG*FFC(I)*FFC(J)*R(K,L)/COEFFR
                ELSE
                MMAT(II,JJ) = MP*FFC(I)*FFC(J)*R(K,L)/COEFFR
                ENDIF
              ENDIF
430         CONTINUE
420       CONTINUE
410     CONTINUE
400   CONTINUE
      ENDIF
C ------------------- CALCUL DE [E] ------------------------------------
C
C ------------- COUPLAGE MULTIPLICATEURS CONTACT-FROTTEMENT ------------
      IF (NVIT.EQ.1) THEN
        DO 800 I = 1,NNC
         DO 810 J = 1,NNC
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,I,NFHE,PLI)
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,J,NFHE,PLJ)
            DO 830 K = 1,NDIM-1
              II = PLI+K
              JJ = PLJ
              IF(LPENAF) THEN
                MMAT(II,JJ) = 0.D0
              ELSE
                MMAT(II,JJ) = 0.D0
              ENDIF
830         CONTINUE
            
810       CONTINUE
800     CONTINUE
      ENDIF
      END

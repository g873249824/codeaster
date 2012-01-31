      SUBROUTINE XMMAB1(NDIM  ,JNNE, NDEPLE  ,NNC   ,JNNM   ,
     &                  NFAES ,CFACE ,HPG   ,FFC   ,FFE   ,
     &                  FFM   ,JACOBI,JPCAI ,LAMBDA,
     &                  DVITET ,COEFFR,
     &                  COEFFP,COEFFF,LPENAF,TAU1  ,TAU2  ,
     &                  RESE  ,MPROJ ,TYPMAI,NSINGE,
     &                  NSINGM,RRE   ,RRM   ,NVIT  ,NCONTA,
     &                  JDDLE,JDDLM,NFHE,MMAT  )  
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 30/01/2012   AUTEUR DESOZA T.DESOZA 
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
      INTEGER  NDIM,JNNE(3),NNC,JNNM(3),NFAES,JPCAI,CFACE(5,3)
      INTEGER  NSINGE,NSINGM,NCONTA,JDDLE(2),JDDLM(2)
      INTEGER  NVIT,NDEPLE,NFHE
      REAL*8   HPG,FFC(8),FFE(8),FFM(8),JACOBI,DDOT
      REAL*8   LAMBDA,COEFFF,COEFFR,COEFFP,RRE,RRM,DVITET(3)
      REAL*8   TAU1(3),TAU2(3),RESE(3),MMAT(336,336),MPROJ(3,3)
      CHARACTER*8  TYPMAI
      LOGICAL  LPENAF
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
C
C CALCUL DE B ET DE BT POUR LE CONTACT METHODE CONTINUE
C AVEC ADHERENCE
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
C IN  DDLES : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  JPCAI  : POINTEUR VERS LE VECTEUR DES ARRETES ESCLAVES
C              INTERSECTEES
C IN  LAMBDA : VALEUR DU SEUIL_INIT
C IN  COEFFA : COEF_REGU_FROT
C IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C IN  TAU1   : PREMIERE TANGENTE
C IN  TAU2   : SECONDE TANGENTE
C IN  RESE   : PROJECTION DE LA BOULE UNITE POUR LE FROTTEMENT
C IN  MPROJ  : MATRICE DE L'OPERATEUR DE PROJECTION
C IN  TYPMAI : NOM DE LA MAILLE ESCLAVE D'ORIGINE (QUADRATIQUE)
C IN  NSINGE : NOMBRE DE FONCTION SINGULIERE ESCLAVE
C IN  NSINGM : NOMBRE DE FONCTION SINGULIERE MAITRE
C IN  RRE    : SQRT LST ESCLAVE
C IN  RRM    : SQRT LST MAITRE
C IN  NVIT   : POINT VITAL OU PAS
C I/O MMAT   : MATRICE ELEMENTAIRE DE CONTACT/FROTTEMENT
C ----------------------------------------------------------------------
      INTEGER   I, J, K, L, M, II, JJ, INI, PLI,INJ, PLJ
      INTEGER   XOULA,JJN,IIN,DDLE
      INTEGER   NNE,NNES,NNM,NNMS,DDLES,DDLEM,DDLMS,DDLMM
      REAL*8    E(3,3), A(3,3), MP, MB, MBT ,MM ,MMT
      REAL*8    TT(3,3), V(2)
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
      V(1)=0
      V(2)=0
C
      DO 1 I = 1,3
        DO 2 J = 1,3
          A(I,J)  = 0.D0
          E(I,J)  = 0.D0
          TT(I,J) = 0.D0
2       CONTINUE
1     CONTINUE
      V(1) = DDOT(NDIM,DVITET,1,TAU1,1)
      IF(NDIM.EQ.3) V(2) = DDOT(NDIM,DVITET,1,TAU2,2)
C     TT = ID
      DO 301 I = 1,NDIM
        TT(1,1) = TAU1(I)*TAU1(I) + TT(1,1)
        TT(1,2) = TAU1(I)*TAU2(I) + TT(1,2)
        TT(2,1) = TAU2(I)*TAU1(I) + TT(2,1)
        TT(2,2) = TAU2(I)*TAU2(I) + TT(2,2)
301   CONTINUE
C
C --- E = [P_TAU]T*[P_TAU]
C
C --- MPROJ MATRICE DE PROJECTION ORTHOGONALE SUR LE PLAN TANGENT
C --- E = [MPROJ]T*[MPROJ] = [MPROJ]*[MPROJ] = [MPROJ]
C ---        CAR ORTHOGONAL^   CAR PROJECTEUR^
      DO 3 I = 1,NDIM
        DO 4 J = 1,NDIM
          DO 5 K = 1,NDIM
            E(I,J) = MPROJ(K,I)*MPROJ(K,J) + E(I,J)
5         CONTINUE
4       CONTINUE
3     CONTINUE
C
C --- A = [P_B,TAU1,TAU2]*[P_TAU]
C
C --- RESE = COEFFP*VIT
C ---        GT SEMI MULTIPLICATEUR AUGMENTE FROTTEMENT
      DO 6 I = 1,NDIM
        DO 7 K = 1,NDIM
          A(1,I) = RESE(K)*MPROJ(K,I) + A(1,I)
          A(2,I) = TAU1(K)*MPROJ(K,I) + A(2,I)
          A(3,I) = TAU2(K)*MPROJ(K,I) + A(3,I)
7       CONTINUE
6     CONTINUE
C ---- MP = MU*GN*WG*JAC
      MP = LAMBDA*COEFFF*HPG*JACOBI
C
      DDLE = DDLES*NNES+DDLEM*(NNE-NNES)
      IF (NNM.NE.0) THEN
C
C --------------------- CALCUL DE [A] ET [B] -----------------------
C
      DO 70 L = 1,NDIM
        DO 10 K = 1,NDIM
C ROUTINE ADHERENTE, ON GARDE LA CONTRIBUTION A [A]
          IF (L.EQ.1) THEN
            MB  = 0.D0
            MBT = COEFFF*HPG*JACOBI*A(L,K)
          ELSE
            IF(.NOT.LPENAF) MB = NVIT*MP*A(L,K)
            IF(LPENAF)      MB = 0.D0
            IF(.NOT.LPENAF) MBT = MP*A(L,K)
            IF(LPENAF)      MBT = 0.D0
          ENDIF
          DO 20 I = 1,NNC
            INI=XOULA(CFACE,NFAES,I,JPCAI,TYPMAI,NCONTA)
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,INI,NFHE,PLI)
            II = PLI+L-1
            DO 30 J = 1,NDEPLE
              MM = MB *FFC(I)*FFE(J)
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
              MM = MB *FFC(I)*FFM(J)
              MMT= MBT*FFC(I)*FFM(J)
              CALL INDENT(J,DDLMS,DDLMM,NNMS,JJN)
              JJ = DDLE + JJN + K
              MMAT(II,JJ) = MM
              MMAT(JJ,II) = MMT
              JJ = JJ + NDIM
              MMAT(II,JJ) = MM
              IF(.NOT.LPENAF) MMAT(JJ,II) = MMT
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
            MB  = -MP*COEFFP*E(L,K)
            MBT = -MP*COEFFP*E(L,K)
          ELSE
            MB  = -MP*COEFFR*E(L,K)
            MBT = -MP*COEFFR*E(L,K)
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
      ELSE
C
C --------------------- CALCUL DE [A] ET [B] -----------------------
C
      DO 550 L = 1,NDIM
        DO 510 K = 1,NDIM
          IF (L.EQ.1) THEN
            MB  = 0.D0
            MBT = COEFFF*HPG*JACOBI*A(L,K)
          ELSE
            IF(.NOT.LPENAF) MB = NVIT*MP*A(L,K)
            IF(LPENAF)      MB = 0.D0
            IF(.NOT.LPENAF) MBT = MP*A(L,K)
            IF(LPENAF)      MBT = 0.D0
          ENDIF
          DO 520 I = 1,NNC
            INI=XOULA(CFACE,NFAES,I,JPCAI,TYPMAI,NCONTA)
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,INI,NFHE,PLI)
            II = PLI+L-1
            DO 530 J = 1,NDEPLE
C --- BLOCS ES:CONT, CONT:ES
              MM = MB *FFC(I)*FFE(J)
              MMT= MBT*FFC(I)*FFE(J)
              CALL INDENT(J,DDLES,DDLEM,NNES,JJN)
              JJ = JJN + K
              MMAT(II,JJ) = RRE * MM
              IF(.NOT.LPENAF) MMAT(JJ,II) = RRE * MMT
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
            MB  = -MP*COEFFP*E(L,K)
          ELSE
            MB  = -MP*COEFFR*E(L,K)
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
C --------------------- CALCUL DE [F] ----------------------------------
C
C ---------------SEULEMENT EN METHODE PENALISEE-------------------------
      IF(LPENAF)THEN
        IF (NVIT.EQ.1) THEN
        DO 400 I = 1,NNC
         DO 410 J = 1,NNC
            INI=XOULA(CFACE,NFAES,I,JPCAI,TYPMAI,NCONTA)
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,INI,NFHE,PLI)
            INJ=XOULA(CFACE,NFAES,J,JPCAI,TYPMAI,NCONTA)
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,INJ,NFHE,PLJ)
            DO 420 L = 1,NDIM-1
              DO 430 K = 1,NDIM-1
                II = PLI+L
                JJ = PLJ+K
                MMAT(II,JJ) = FFC(I)*FFC(J)*HPG*JACOBI*TT(L,K)
430           CONTINUE
420         CONTINUE
410       CONTINUE
400     CONTINUE
        ENDIF
      ENDIF
C ------------------- CALCUL DE [E] ------------------------------------
C
C ------------- COUPLAGE MULTIPLICATEURS CONTACT-FROTTEMENT ------------
      IF (NVIT.EQ.1) THEN
        DO 800 I = 1,NNC
         DO 810 J = 1,NNC
            INI=XOULA(CFACE,NFAES,I,JPCAI,TYPMAI,NCONTA)
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,INI,NFHE,PLI)
            INJ=XOULA(CFACE,NFAES,J,JPCAI,TYPMAI,NCONTA)
            CALL XPLMA2(NDIM,NNE,NNES,DDLES,INJ,NFHE,PLJ)
            DO 830 K = 1,NDIM-1
              II = PLI+K
              JJ = PLJ
              IF(LPENAF) THEN
                MMAT(II,JJ) = 0.D0
              ELSE
                MMAT(II,JJ) = -FFC(I)*FFC(J)*COEFFF*HPG*JACOBI*V(K)
              ENDIF
830         CONTINUE
            
810       CONTINUE
800     CONTINUE
      ENDIF
C
      END

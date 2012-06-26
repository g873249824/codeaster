      SUBROUTINE MMMTMM(PHASEP,LNEWTG,NDIM  ,NNM   ,MPROJN,
     &                  MPROJT,WPG   ,FFM   ,DFFM  ,JACOBI,
     &                  COEFAC,COEFAF,COEFFF,RESE  ,NRESE ,
     &                  LAMBDA,DLAGRC,JEU   ,H11T1N,H12T2N,
     &                  H21T1N,H22T2N,MATRMM)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 25/06/2012   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT     NONE
      CHARACTER*9  PHASEP
      LOGICAL      LNEWTG
      INTEGER      NDIM,NNM
      REAL*8       MPROJN(3,3),MPROJT(3,3)
      REAL*8       WPG,FFM(9),JACOBI,DFFM(2,9)
      REAL*8       RESE(3),NRESE
      REAL*8       COEFAC,COEFAF,JEU
      REAL*8       LAMBDA,COEFFF,DLAGRC
      REAL*8       H11T1N(3,3),H12T2N(3,3)
      REAL*8       H21T1N(3,3),H22T2N(3,3)
      REAL*8       MATRMM(27,27)
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C CALCUL DE LA MATRICE DEPL_MAIT/DEPL_MAIT
C
C ----------------------------------------------------------------------
C
C
C IN  PHASEP : PHASE DE CALCUL
C              'CONT'      - CONTACT
C              'CONT_PENA' - CONTACT PENALISE
C              'ADHE'      - ADHERENCE
C              'ADHE_PENA' - ADHERENCE PENALISE
C              'GLIS'      - GLISSEMENT
C              'GLIS_PENA' - GLISSEMENT PENALISE
C IN  LNEWTG : .TRUE. SI CALCUL CONTRIBUTION GEOMETRIQUE EN NEWTON GENE.
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
C IN  MPROJN : MATRICE DE PROJECTION NORMALE [Pn]
C IN  MPROJT : MATRICE DE PROJECTION TANGENTE [Pt]
C IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFM    : FONCTIONS DE FORMES DEPL. MAIT.
C IN  DFFM   : DERIVEES PREMIERES DES FONCTIONS DE FORME MAITRES
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  COEFAC : COEF_AUGM_CONT
C IN  COEFAF : COEF_AUGM_FROT
C IN  LAMBDA : LAGRANGIEN DE CONTACT
C IN  DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
C IN  DJEU   : INCREMENT DEPDEL DU JEU
C IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
C               GTK = LAMBDAF + COEFAF*VITESSE
C IN  NRESE  : NORME DU SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
C IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C IN  H11T1N : MATRICE
C IN  H21T1N : MATRICE
C IN  H12T2N : MATRICE
C IN  H22T2N : MATRICE
C OUT MATRMM : MATRICE ELEMENTAIRE DEPL_M/DEPL_M
C
C ----------------------------------------------------------------------
C
      INTEGER   I, J, K,L,II, JJ,IDIM
      REAL*8    G(3,3),E(3,3),D(3,3),MATPRB(3,3),DFFMT(9,2)
      REAL*8    C1(3),C2(3),C3(3),D1(3),D2(3),D3(3)
C
C ----------------------------------------------------------------------
C
      CALL MATINI(3,3,0.D0,E)
      CALL MATINI(3,3,0.D0,D)
      CALL MATINI(3,3,0.D0,G)
      CALL VECINI(3,0.D0,D1)
      CALL VECINI(3,0.D0,D2)
      CALL VECINI(3,0.D0,D3)
      CALL VECINI(3,0.D0,C1)
      CALL VECINI(3,0.D0,C2)
      CALL VECINI(3,0.D0,C3)
C
      DO 3 IDIM = 1,3
        C1(IDIM) = MPROJT(IDIM,1)
        C2(IDIM) = MPROJT(IDIM,2)
        C3(IDIM) = MPROJT(IDIM,3)
3     CONTINUE
C
      DO 17 I=1,9
        DO 18 J=1,2
          DFFMT(I,J) = DFFM(J,I)
18      CONTINUE
17    CONTINUE
C
C --- PRODUIT [E] = [Pt]x[Pt]
C
      CALL PMAT  (3,MPROJT,MPROJT,E    )
C
C --- MATRICE DE PROJECTION SUR LA BOULE UNITE
C
      IF (PHASEP(1:4).EQ.'GLIS') THEN
        CALL MMMMPB(RESE  ,NRESE ,NDIM  ,MATPRB)
      ENDIF
C
C --- VECTEUR PROJ. BOULE SUR PLAN TGT
C
      IF (PHASEP(1:4).EQ.'GLIS') THEN
        CALL PMAVEC('ZERO',3,MATPRB,C1,D1)
        CALL PMAVEC('ZERO',3,MATPRB,C2,D2)
        CALL PMAVEC('ZERO',3,MATPRB,C3,D3)
C
C ----- MATRICE [G] = [{D1}{D2}{D3}]
C
        DO 416 IDIM = 1,3
          G(IDIM,1) = D1(IDIM)
          G(IDIM,2) = D2(IDIM)
          G(IDIM,3) = D3(IDIM)
  416    CONTINUE
C
C ----- MATRICE [D] = [Pt]*[G]t
C
        DO 423 I = 1,NDIM
          DO 424 J = 1,NDIM
            DO 425 K = 1,NDIM
              D(I,J) = G(K,I)*MPROJT(K,J) + D(I,J)
 425        CONTINUE
 424      CONTINUE
 423    CONTINUE
      ENDIF
C
C --- CALCUL DES TERMES
C
      IF (PHASEP(1:4).EQ.'CONT') THEN
        IF (PHASEP(6:9).EQ.'PENA') THEN
            DO 160 I = 1,NNM
              DO 150 J = 1,NNM
                DO 140 K = 1,NDIM
                  DO 130 L = 1,NDIM
                  II = NDIM*(I-1)+L
                  JJ = NDIM*(J-1)+K
                  MATRMM(II,JJ) = MATRMM(II,JJ) + COEFAC*
     &                            WPG*JACOBI*FFM(I)*MPROJN(L,K)*FFM(J)
  130             CONTINUE
  140           CONTINUE
  150         CONTINUE
  160       CONTINUE
        ELSE
          IF (LNEWTG) THEN
            DO 761 I = 1,NNM
              DO 751 J = 1,NNM
                DO 741 K = 1,NDIM
                  DO 731 L = 1,NDIM
                    II = NDIM*(I-1)+L
                    JJ = NDIM*(J-1)+K
                    MATRMM(II,JJ) = MATRMM(II,JJ) -
     &   WPG*JACOBI*2.0D0*
     &  (DLAGRC-COEFAC*JEU)*H11T1N(L,K)*FFM(I)*DFFMT(J,1)-
     &   WPG*JACOBI*2.0D0*
     &  (DLAGRC-COEFAC*JEU)*H12T2N(L,K)*FFM(I)*DFFMT(J,1)-
     &   WPG*JACOBI*2.0D0*
     &  (DLAGRC-COEFAC*JEU)*H21T1N(L,K)*FFM(I)*DFFMT(J,2)-
     &   WPG*JACOBI*2.0D0*
     &  (DLAGRC-COEFAC*JEU)*H22T2N(L,K)*FFM(I)*DFFMT(J,2)
  731             CONTINUE
  741           CONTINUE
  751         CONTINUE
  761       CONTINUE
          ELSE
            DO 361 I = 1,NNM
              DO 351 J = 1,NNM
                DO 341 K = 1,NDIM
                  DO 331 L = 1,NDIM
                    II = NDIM*(I-1)+L
                    JJ = NDIM*(J-1)+K
                    MATRMM(II,JJ) = MATRMM(II,JJ) + COEFAC*
     &  WPG*JACOBI*FFM(I)*MPROJN(L,K)*FFM(J)
  331             CONTINUE
  341           CONTINUE
  351         CONTINUE
  361       CONTINUE
          ENDIF
        ENDIF
      ELSEIF (PHASEP(1:4).EQ.'ADHE') THEN
        IF (PHASEP(6:9).EQ.'PENA') THEN
          DO 165 I = 1,NNM
            DO 155 J = 1,NNM
              DO 145 K = 1,NDIM
                DO 135 L = 1,NDIM
                  II = NDIM*(I-1)+K
                  JJ = NDIM*(J-1)+L
                  MATRMM(II,JJ) = MATRMM(II,JJ) - COEFAF*COEFFF*LAMBDA*
     &                            WPG*JACOBI*FFM(I)*E(K,L)*FFM(J)
  135           CONTINUE
  145         CONTINUE
  155       CONTINUE
  165     CONTINUE
        ELSE
          DO 166 I = 1,NNM
            DO 156 J = 1,NNM
              DO 146 K = 1,NDIM
                DO 136 L = 1,NDIM
                  II = NDIM*(I-1)+K
                  JJ = NDIM*(J-1)+L
                  MATRMM(II,JJ) = MATRMM(II,JJ) - COEFAF*COEFFF*LAMBDA*
     &                            WPG*JACOBI*FFM(I)*E(K,L)*FFM(J)
  136           CONTINUE
  146         CONTINUE
  156       CONTINUE
  166     CONTINUE
        ENDIF
      ELSEIF (PHASEP(1:4).EQ.'GLIS') THEN
        IF (PHASEP(6:9).EQ.'PENA') THEN
          DO 465 I = 1,NNM
            DO 455 J = 1,NNM
              DO 445 K = 1,NDIM
                DO 435 L = 1,NDIM
                  II = NDIM*(I-1)+L
                  JJ = NDIM*(J-1)+K
                  MATRMM(II,JJ) = MATRMM(II,JJ) - COEFAF*COEFFF*LAMBDA*
     &                            WPG*JACOBI*FFM(I)*D(L,K)*FFM(J)
  435           CONTINUE
  445         CONTINUE
  455       CONTINUE
  465     CONTINUE
        ELSE
          DO 365 I = 1,NNM
            DO 355 J = 1,NNM
              DO 345 K = 1,NDIM
                DO 335 L = 1,NDIM
                  II = NDIM*(I-1)+L
                  JJ = NDIM*(J-1)+K
                  MATRMM(II,JJ) = MATRMM(II,JJ) - COEFAF*COEFFF*LAMBDA*
     &                            WPG*JACOBI*FFM(I)*D(L,K)*FFM(J)
  335           CONTINUE
  345         CONTINUE
  355       CONTINUE
  365     CONTINUE
        ENDIF
      ENDIF
C
      END

      SUBROUTINE XMMAB1(NDIM  ,NNE   ,NNES  ,NNC   ,NNM   ,
     &                  NFAES ,CFACE ,HPG   ,FFC   ,FFE   ,
     &                  FFM   ,JACOBI,JPCAI ,LAMBDA,COEFCA,   
     &                  JEU   ,COEFFA,COEFFF,TAU1  ,TAU2  ,
     &                  RESE  ,MPROJ ,NORM  ,TYPMAI,NSINGE,
     &                  NSINGM,RRE   ,RRM   ,NVIT  ,NDDLSE,
     &                  MMAT  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER  NDIM,NNE,NNES,NNC,NNM,NFAES,JPCAI,CFACE(5,3)
      INTEGER  NSINGE,NSINGM
      INTEGER  NVIT,NDDLSE
      REAL*8   HPG,FFC(9),FFE(9),FFM(9),JACOBI,NORM(3)
      REAL*8   LAMBDA,COEFFF,COEFFA,RRE,RRM,COEFCA,JEU
      REAL*8   TAU1(3),TAU2(3),RESE(3),MMAT(168,168),MPROJ(3,3)
      CHARACTER*8  TYPMAI
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
C IN  NDDLSE : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
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
      INTEGER   I, J, K, L, M, II, JJ, INI, PLI, XOULA
      REAL*8    E(3,3), A(3,3), C(3,3),MP, MB, MBT ,MM ,MMT
C ----------------------------------------------------------------------
C
C --- INITIALISATIONS
C
      DO 1 I = 1,3
        DO 2 J = 1,3
          A(I,J)  = 0.D0
          E(I,J)  = 0.D0
    2   CONTINUE
    1 CONTINUE
C
C --- E = [P_TAU]*[P_TAU]
C
      DO 3 I = 1,NDIM
        DO 4 J = 1,NDIM
          DO 5 K = 1,NDIM
            E(I,J) = MPROJ(K,I)*MPROJ(K,J) + E(I,J)
    5     CONTINUE
    4   CONTINUE
    3 CONTINUE
C
C --- A = [P_B,TAU1,TAU2]*[P_TAU]
C
      DO 6 I = 1,NDIM
        DO 7 K = 1,NDIM
          A(1,I) = RESE(K)*MPROJ(K,I) + A(1,I)
          A(2,I) = TAU1(K)*MPROJ(K,I) + A(2,I)
          A(3,I) = TAU2(K)*MPROJ(K,I) + A(3,I)
    7   CONTINUE
    6 CONTINUE
C
C --- C = (P_B)[P_TAU]*(N)
C
      DO 8 I = 1,NDIM
        DO 9 J = 1,NDIM
          C(I,J) = A(1,I)*NORM(J)
    9   CONTINUE
    8 CONTINUE
      MP = (LAMBDA-COEFCA*JEU)*COEFFF*HPG*JACOBI
C
      IF (NNM.NE.0) THEN
C
C --------------------- CALCUL DE [A] ET [B] -----------------------
C
      DO 70 L = 1,NDIM
        DO 10 K = 1,NDIM
          IF (L.EQ.1) THEN
            MB  = 0.D0
            MBT = COEFFF*HPG*JACOBI*A(L,K)
          ELSE
            MB  = NVIT*HPG*JACOBI*A(L,K)
            MBT = MP*A(L,K)
          ENDIF
          DO 20 I = 1,NNC
            INI=XOULA(CFACE,NFAES,I,JPCAI,TYPMAI)
            CALL XPLMA2(NDIM,NNE,NNES,NDDLSE,INI,PLI)
            II = PLI+L-1
            DO 30 J = 1,NNES
C --- BLOCS ES:CONT, CONT:ES
              MM = MB *FFC(I)*FFE(J)
              MMT= MBT*FFC(I)*FFE(J)
              JJ = NDDLSE*(J-1)+K
              MMAT(II,JJ) = -MM
              MMAT(JJ,II) = -MMT
              JJ = JJ + NDIM
              MMAT(II,JJ) = MM
              MMAT(JJ,II) = MMT
              DO 40 M = 1,NSINGE
                JJ = JJ + NDIM
                MMAT(II,JJ) = RRE * MM
                MMAT(JJ,II) = RRE * MMT
   40         CONTINUE
   30       CONTINUE
            DO 50 J = 1,NNM
C --- BLOCS MA:CONT, CONT:MA
              MM = MB *FFC(I)*FFM(J)
              MMT= MBT*FFC(I)*FFM(J)
              JJ = NDDLSE*NNES+NDIM*(NNE-NNES) + 
     &              (2+NSINGM)*NDIM*(J-1)+K
              MMAT(II,JJ) = MM
              MMAT(JJ,II) = MMT
              JJ = JJ + NDIM
              MMAT(II,JJ) = MM
              MMAT(JJ,II) = MMT
              DO 60 M = 1,NSINGM
                JJ = JJ + NDIM
                MMAT(II,JJ) = RRM * MM
                MMAT(JJ,II) = RRM * MMT
   60         CONTINUE
   50       CONTINUE
   20     CONTINUE
   10   CONTINUE
   70 CONTINUE
C
C --------------------- CALCUL DE [BU] ---------------------------------
C
      DO 100 K = 1,NDIM
        DO 110 L = 1,NDIM
          MB  = -MP*COEFFA*E(L,K)+COEFCA*COEFFF*HPG*JACOBI*C(L,K)
          MBT = -MP*COEFFA*E(L,K)+COEFCA*COEFFF*HPG*JACOBI*C(K,L)
          DO 200 I = 1,NNES
            DO 210 J = 1,NNES
C --- BLOCS ES:ES
              MM = MB *FFE(I)*FFE(J)
              MMT= MBT*FFE(I)*FFE(J)
              II = NDDLSE*(I-1)+L
              JJ = NDDLSE*(J-1)+K
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
  215         CONTINUE
  210       CONTINUE
            DO 220 J = 1,NNM
C --- BLOCS ES:MA, MA:ES
              MM = MB *FFE(I)*FFM(J)
              MMT= MBT*FFE(I)*FFM(J)
              II = NDDLSE*(I-1)+L
              JJ = NDDLSE*NNES+NDIM*(NNE-NNES) +
     &              (2+NSINGM)*NDIM*(J-1)+K
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
  230         CONTINUE
              DO 240 M = 1,NSINGE
                II = II + NDIM
                JJ = JJ - NDIM
                MMAT(II,JJ) =  RRE * MM
                MMAT(JJ,II) =  RRE * MMT
                JJ = JJ + NDIM
                MMAT(II,JJ) =  RRE * MM
                MMAT(JJ,II) =  RRE * MMT
                II = II - NDIM
  240         CONTINUE
              DO 250 M = 1,NSINGE*NSINGM
                II = II + NDIM
                JJ = JJ + NDIM
                MMAT(II,JJ) =  RRE * RRM * MM
                MMAT(JJ,II) =  RRE * RRM * MMT
  250         CONTINUE
  220       CONTINUE
  200     CONTINUE
          DO 300 I = 1,NNM
            DO 320 J = 1,NNM
C --- BLOCS MA:MA
              MM = MB *FFM(I)*FFM(J)
              MMT= MBT*FFM(I)*FFM(J)
              II = NDDLSE*NNES+NDIM*(NNE-NNES) +
     &              (2+NSINGM)*NDIM*(I-1)+L
              JJ = NDDLSE*NNES+NDIM*(NNE-NNES) +
     &              (2+NSINGM)*NDIM*(J-1)+K
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
  330         CONTINUE
  320       CONTINUE
  300     CONTINUE
  110   CONTINUE
  100 CONTINUE
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
            MB  = NVIT*HPG*JACOBI*A(L,K)
            MBT = MP*A(L,K)
          ENDIF
          DO 520 I = 1,NNC
            INI=XOULA(CFACE,NFAES,I,JPCAI,TYPMAI)
            CALL XPLMA2(NDIM,NNE,NNES,NDDLSE,INI,PLI)
            II = PLI+L-1
            DO 530 J = 1,NNES
C --- BLOCS ES:CONT, CONT:ES
              MM = MB *FFC(I)*FFE(J)
              MMT= MBT*FFC(I)*FFE(J)
              JJ = 2*NDIM*(J-1)+K
              MMAT(II,JJ) = RRE * MM
              MMAT(JJ,II) = RRE * MMT
  530       CONTINUE
  520     CONTINUE
  510   CONTINUE
  550 CONTINUE
C
C --------------------- CALCUL DE [BU] ---------------------------------
C
      DO 600 K = 1,NDIM
        DO 610 L = 1,NDIM
          MB  = -MP*COEFFA*E(L,K)+COEFCA*COEFFF*HPG*JACOBI*C(L,K)
          DO 620 I = 1,NNES
            DO 630 J = 1,NNES
C --- BLOCS ES:ES
              MM = MB *FFE(I)*FFE(J)
              II = NDDLSE*(I-1)+L
              JJ = NDDLSE*(J-1)+K
              MMAT(II,JJ) = RRE * RRE * MM
  630       CONTINUE
  620     CONTINUE
  610   CONTINUE
  600 CONTINUE
      ENDIF
C
      END

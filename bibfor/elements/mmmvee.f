      SUBROUTINE MMMVEE(PHASE ,NDIM  ,NNE   ,NORM  ,TAU1  ,
     &                  TAU2  ,MPROJT,HPG   ,FFE   ,JACOBI,
     &                  JEU   ,COEFCP,COEFFP,DLAGRC,KAPPAN,KAPPAV,
     &                  ASPERI,JEVITP,LAMBDA,COEFFF,DLAGRF,
     &                  DDEPLE,DDEPLM,RESE  ,NRESE ,VECTEE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 27/07/2010   AUTEUR DESOZA T.DESOZA 
C ======================================================================
C COPYRIGHT (C) 1991 - 2009  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
      CHARACTER*4  PHASE
      INTEGER      NDIM,NNE
      REAL*8       HPG,FFE(9),JACOBI
      REAL*8       DLAGRC,DLAGRF(2)
      REAL*8       DDEPLE(3),DDEPLM(3)
      REAL*8       RESE(3),NRESE
      REAL*8       NORM(3)
      REAL*8       TAU1(3),TAU2(3),MPROJT(3,3)
      REAL*8       COEFCP,COEFFP,JEU
      REAL*8       KAPPAN,ASPERI,KAPPAV,JEVITP
      REAL*8       LAMBDA,COEFFF
      REAL*8       VECTEE(27)
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C CALCUL DU VECTEUR DEPL_ESCL
C
C ----------------------------------------------------------------------
C
C
C IN  PHASE  : PHASE DE CALCUL
C              'CONT' - CONTACT
C              'COMP' - TERME DE COMPLIANCE SI CONTACT
C              'ASPE' - TERME DE COMPLIANCE DANS ASPERITE
C              'STAC' - TERME DE STABILISATION DU CONTACT
C              'ADHE' - CONTACT ADHERENT
C              'GLIS' - CONTACT GLISSANT
C              'EXCL' - EXCLUSION D'UN NOEUD
C              'PCON' - PENALISATION - CONTACT
C              'PADH' - PENALISATION - CONTACT ADHERENT
C              'PGLI' - PENALISATION - CONTACT GLISSANT
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNE    : NOMBRE DE NOEUDS ESCLAVE
C IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFE    : FONCTIONS DE FORMES DEPL_ESCL
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  JEU    : VALEUR DU JEU
C IN  NDEXCL : NUMERO DU NOEUD (MILIEU) EXCLU
C IN  NORM   : NORMALE
C IN  COEFCP : COEF_PENA_CONT
C IN  COEFFP : COEF_PENA_CONT
C IN  DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
C IN  KAPPAN : COEFFICIENT KN DU MODELE DE COMPLIANCE
C IN  KAPPAV : COEFFICIENT KV DU MODELE DE COMPLIANCE
C IN  ASPERI : PARAMETRE A DU MODELE DE COMPLIANCE (PROF. ASPERITE)
C IN  JEVITP : SAUT DE VITESSE NORMALE POUR COMPLIANCE
C IN  LAMBDA : VALEUR DU MULT. DE CONTACT (SEUIL DE TRESCA)
C IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C IN  DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
C IN  DDEPLE : INCREMENT DEPDEL DES DEPL. ESCLAVES
C IN  DDEPLM : INCREMENT DEPDEL DES DEPL. MAITRES
C IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
C               GTK = LAMBDAF + COEFFR*VITESSE
C IN  NRESE  : NORME DU SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
C IN  TAU1   : PREMIER VECTEUR TANGENT
C IN  TAU2   : SECOND VECTEUR TANGENT
C IN  MPROJT : MATRICE DE PROJECTION TANGENTE
C OUT VECTEE : VECTEUR ELEMENTAIRE DEPL_ESCL
C
C ----------------------------------------------------------------------
C
      INTEGER   INOE,IDIM,II,I,J,K
      REAL*8    DLAGFT(3),PLAGFT(3),PRESE(3)
      REAL*8    DVITE(3),DVITET(3),PDVITT(3)
C
C ----------------------------------------------------------------------
C
      DO 14 I=1,3
        PLAGFT(I) = 0.D0
        DLAGFT(I) = 0.D0
        PRESE (I) = 0.D0
        DVITE (I) = 0.D0
        DVITET(I) = 0.D0
        PDVITT(I) = 0.D0
14    CONTINUE
C
C --- PRE-CALCULS
C
      IF (PHASE.EQ.'ADHE') THEN
C ---   PROJECTION DU LAGRANGE DE FROTTEMENT SUR LE PLAN TANGENT
        DO 123 I=1,NDIM
          DLAGFT(I)  = DLAGRF(1)*TAU1(I)+DLAGRF(2)*TAU2(I)
123     CONTINUE
C ---   PRODUIT LAGR. FROTTEMENT. PAR MATRICE P
        DO 221 I=1,NDIM
          DO 222 J=1,NDIM
            PLAGFT(I) = MPROJT(I,J)*DLAGFT(J)+PLAGFT(I)
222       CONTINUE
221     CONTINUE
      ELSEIF ((PHASE.EQ.'GLIS').OR.(PHASE.EQ.'PGLI')) THEN
C ---   PRODUIT SEMI MULT. LAGR. FROTTEMENT. PAR MATRICE P
          DO 228 I=1,NDIM
            DO 229 J=1,NDIM
              PRESE(I) = MPROJT(I,J)*RESE(J)/NRESE+PRESE(I)
229         CONTINUE
228       CONTINUE

      ELSEIF ((PHASE.EQ.'STAF').OR.(PHASE.EQ.'PADH')) THEN
C --- CALCUL DU SAUT DE "VITESSE" [[DELTA X]]
        DO 12 I = 1,NDIM
          DVITE(I) = DDEPLE(I) - DDEPLM(I)
   12   CONTINUE
C --- PROJECTION DU SAUT SUR LE PLAN TANGENT
        DO 21 I=1,NDIM
          DO 22  K=1,NDIM
            DVITET(I) = MPROJT(I,K)*DVITE(K)+DVITET(I)
22        CONTINUE
21      CONTINUE
C ---   PRODUIT SAUT PAR MATRICE P
        DO 721 I=1,NDIM
          DO 722 J=1,NDIM
            PDVITT(I) = MPROJT(I,J)*DVITET(J)+PDVITT(I)
722       CONTINUE
721     CONTINUE
      ENDIF
C
      IF (PHASE.EQ.'CONT') THEN
        DO 70 INOE = 1,NNE
          DO 60 IDIM = 1,NDIM
            II = NDIM*(INOE-1)+IDIM
            VECTEE(II) = VECTEE(II)-
     &                   HPG*FFE(INOE)*JACOBI*NORM(IDIM)*
     &                   DLAGRC
   60     CONTINUE
   70   CONTINUE
C
      ELSEIF ((PHASE.EQ.'STAC').OR.(PHASE.EQ.'PCON')) THEN
        DO 75 INOE = 1,NNE
          DO 65 IDIM = 1,NDIM
            II = NDIM*(INOE-1)+IDIM
            VECTEE(II) = VECTEE(II)+
     &                   HPG*FFE(INOE)*JACOBI*NORM(IDIM)*
     &                   (JEU*COEFCP)
   65     CONTINUE
   75   CONTINUE
      ELSEIF (PHASE.EQ.'COMP') THEN
        DO 71 INOE = 1,NNE
          DO 61 IDIM = 1,NDIM
            II = NDIM*(INOE-1)+IDIM
            VECTEE(II) = VECTEE(II)+
     &                   HPG*FFE(INOE)*JACOBI*NORM(IDIM)*
     &                   (KAPPAN*(JEU-ASPERI)**2)
   61     CONTINUE
   71   CONTINUE
C
      ELSEIF (PHASE.EQ.'ASPE') THEN
        DO 72 INOE = 1,NNE
          DO 62 IDIM = 1,NDIM
            II = NDIM*(INOE-1)+IDIM
            VECTEE(II) = VECTEE(II)+
     &                   HPG*FFE(INOE)*JACOBI*NORM(IDIM)*
     &                   (KAPPAN*(JEU-ASPERI)**2+KAPPAV*JEVITP)
   62     CONTINUE
   72   CONTINUE
C
      ELSEIF (PHASE.EQ.'ADHE') THEN
        DO 73 INOE = 1,NNE
          DO 63 IDIM = 1,NDIM
            II = NDIM*(INOE-1)+IDIM
            VECTEE(II) = VECTEE(II)-
     &                   HPG*FFE(INOE)*JACOBI*PLAGFT(IDIM)*
     &                   LAMBDA*COEFFF
   63     CONTINUE
   73   CONTINUE
C
      ELSEIF ((PHASE.EQ.'GLIS').OR.(PHASE.EQ.'PGLI')) THEN
        DO 74 INOE = 1,NNE
          DO 64 IDIM = 1,NDIM
            II = NDIM*(INOE-1)+IDIM
            VECTEE(II) = VECTEE(II)-
     &                   HPG*FFE(INOE)*JACOBI*PRESE(IDIM)*
     &                   LAMBDA*COEFFF
   64     CONTINUE
   74   CONTINUE

      ELSEIF (PHASE.EQ.'STAF') THEN
        DO 76 INOE = 1,NNE
          DO 66 IDIM = 1,NDIM
            II = NDIM*(INOE-1)+IDIM
            VECTEE(II) = VECTEE(II)-
     &                   HPG*FFE(INOE)*JACOBI*PDVITT(IDIM)*
     &                   LAMBDA*COEFFF*COEFFP
   66     CONTINUE
   76   CONTINUE

      ELSEIF (PHASE.EQ.'PADH') THEN
        DO 77 INOE = 1,NNE
          DO 67 IDIM = 1,NDIM
            II = NDIM*(INOE-1)+IDIM
            VECTEE(II) = VECTEE(II)-
     &                   HPG*FFE(INOE)*JACOBI*PDVITT(IDIM)*
     &                   LAMBDA*COEFFF*COEFFP
   67     CONTINUE
   77   CONTINUE
      ELSEIF (PHASE.EQ.'EXCL') THEN

      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      END

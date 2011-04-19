      SUBROUTINE MMMVEE(PHASEZ,NDIM  ,NNE   ,NORM  ,TAU1  ,
     &                  TAU2  ,MPROJT,WPG   ,FFE   ,JACOBI,
     &                  JEU   ,COEFCP,COEFFP,LAMBDA,COEFFF,
     &                  DLAGRC,DLAGRF,DVITE ,RESE  ,NRESE ,
     &                  VECTEE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 18/04/2011   AUTEUR ABBAS M.ABBAS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_21
C
      IMPLICIT NONE
      CHARACTER*(*) PHASEZ
      INTEGER       NDIM,NNE
      REAL*8        WPG,FFE(9),JACOBI
      REAL*8        DLAGRC,DLAGRF(2),DVITE(3)
      REAL*8        RESE(3),NRESE
      REAL*8        NORM(3)
      REAL*8        TAU1(3),TAU2(3),MPROJT(3,3)
      REAL*8        COEFCP,COEFFP,JEU
      REAL*8        LAMBDA,COEFFF
      REAL*8        VECTEE(27)
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
C IN  PHASEP : PHASE DE CALCUL
C              'CONT'      - CONTACT
C              'CONT_PENA' - CONTACT PENALISE
C              'ADHE'      - ADHERENCE
C              'ADHE_PENA' - ADHERENCE PENALISE
C              'GLIS'      - GLISSEMENT
C              'GLIS_PENA' - GLISSEMENT PENALISE
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNE    : NOMBRE DE NOEUDS ESCLAVE
C IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFE    : FONCTIONS DE FORMES DEPL_ESCL
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  JEU    : VALEUR DU JEU
C IN  NORM   : NORMALE
C IN  COEFCP : COEF_PENA_CONT
C IN  COEFFP : COEF_PENA_FROT
C IN  JEVITP : SAUT DE VITESSE NORMALE POUR COMPLIANCE
C IN  LAMBDA : VALEUR DU MULT. DE CONTACT (SEUIL DE TRESCA)
C IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C IN  DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
C IN  DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
C IN  DVITE  : SAUT DE "VITESSE" [[DELTA X]]
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
      INTEGER      INOE,IDIM,II,I,J,K
      REAL*8       DLAGFT(3),PLAGFT(3),PRESE(3)
      REAL*8       DVITET(3),PDVITT(3)
      CHARACTER*9  PHASEP
C
C ----------------------------------------------------------------------
C
      PHASEP = PHASEZ
      DO 14 I=1,3
        PLAGFT(I) = 0.D0
        DLAGFT(I) = 0.D0
        PRESE (I) = 0.D0
        DVITET(I) = 0.D0
        PDVITT(I) = 0.D0
14    CONTINUE
C
C --- PROJECTION DU LAGRANGE DE FROTTEMENT SUR LE PLAN TANGENT
C
      DO 123 I=1,NDIM
        DLAGFT(I)  = DLAGRF(1)*TAU1(I)+DLAGRF(2)*TAU2(I)
123   CONTINUE
C
C --- PRODUIT LAGR. FROTTEMENT. PAR MATRICE P
C
      DO 221 I=1,NDIM
        DO 222 J=1,NDIM
          PLAGFT(I) = MPROJT(I,J)*DLAGFT(J)+PLAGFT(I)
222     CONTINUE
221   CONTINUE
C
C --- PRODUIT SEMI MULT. LAGR. FROTTEMENT. PAR MATRICE P
C
      IF (PHASEP(1:4).EQ.'GLIS') THEN
        DO 228 I=1,NDIM
          DO 229 J=1,NDIM
            PRESE(I) = MPROJT(I,J)*RESE(J)/NRESE+PRESE(I)
229       CONTINUE
228     CONTINUE
      ENDIF
C
C --- PROJECTION DU SAUT SUR LE PLAN TANGENT
C
      DO 21 I=1,NDIM
        DO 22  K=1,NDIM
          DVITET(I) = MPROJT(I,K)*DVITE(K)+DVITET(I)
22      CONTINUE
21    CONTINUE
C
C --- PRODUIT SAUT PAR MATRICE P
C
      DO 721 I=1,NDIM
        DO 722 J=1,NDIM
          PDVITT(I) = MPROJT(I,J)*DVITET(J)+PDVITT(I)
722     CONTINUE
721   CONTINUE    
C
C --- CALCUL DES TERMES
C
      IF (PHASEP(1:4).EQ.'CONT') THEN
        IF (PHASEP(6:9).EQ.'PENA') THEN
          DO 75 INOE = 1,NNE
            DO 65 IDIM = 1,NDIM
              II = NDIM*(INOE-1)+IDIM
              VECTEE(II) = VECTEE(II)+
     &                     WPG*FFE(INOE)*JACOBI*NORM(IDIM)*
     &                     (JEU*COEFCP)
   65       CONTINUE
   75     CONTINUE 
        ELSE
          DO 70 INOE = 1,NNE
            DO 60 IDIM = 1,NDIM
              II = NDIM*(INOE-1)+IDIM
              VECTEE(II) = VECTEE(II)-
     &                     WPG*FFE(INOE)*JACOBI*NORM(IDIM)*
     &                     (DLAGRC-JEU*COEFCP)
   60       CONTINUE
   70     CONTINUE
        ENDIF
C        
      ELSEIF (PHASEP(1:4).EQ.'GLIS') THEN
        DO 74 INOE = 1,NNE
          DO 64 IDIM = 1,NDIM
            II = NDIM*(INOE-1)+IDIM
            VECTEE(II) = VECTEE(II)-
     &                   WPG*FFE(INOE)*JACOBI*PRESE(IDIM)*
     &                   LAMBDA*COEFFF
   64     CONTINUE
   74   CONTINUE   
C
      ELSEIF (PHASEP(1:4).EQ.'ADHE') THEN
        IF (PHASEP(6:9).EQ.'PENA') THEN      
          DO 77 INOE = 1,NNE
            DO 67 IDIM = 1,NDIM
              II = NDIM*(INOE-1)+IDIM
              VECTEE(II) = VECTEE(II)-
     &                     WPG*FFE(INOE)*JACOBI*LAMBDA*COEFFF*
     &                     PDVITT(IDIM)*COEFFP
   67       CONTINUE
   77     CONTINUE
        ELSE
          DO 73 INOE = 1,NNE
            DO 63 IDIM = 1,NDIM
              II = NDIM*(INOE-1)+IDIM
              VECTEE(II) = VECTEE(II)-
     &                     WPG*FFE(INOE)*JACOBI*LAMBDA*COEFFF*
     &                     (PLAGFT(IDIM)+PDVITT(IDIM)*COEFFP)
   63       CONTINUE
   73     CONTINUE 
        ENDIF
C
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      END

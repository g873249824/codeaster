      SUBROUTINE XMMJEC(NDIM  ,JNNM ,JNNE ,NDEPLE,
     &                  NSINGE,NSINGM,FFE   ,FFM   ,NORM  ,
     &                  JGEOM ,JDEPDE,RRE   ,RRM ,
     &                  JDDLE ,JDDLM ,NFHE  ,NFHM  ,LMULTI,
     &                  HEAVFA,JEUCA )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER NDIM
      REAL*8  NORM(3)
      REAL*8  FFE(9),FFM(9)
      REAL*8  JEUCA
      INTEGER JGEOM,JDEPDE
      INTEGER JNNM(3),JNNE(3),JDDLE(2),JDDLM(2)
      INTEGER NSINGE,NSINGM,NFHE,NFHM,HEAVFA(*)
      REAL*8  RRE,RRM
      LOGICAL LMULTI
C
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM-GG - TE)
C
C CALCUL DU JEU
C
C ----------------------------------------------------------------------
C
C
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NDDL   : NOMBRE TOTAL DE DEGRES DE LIBERTE DE LA MAILLE DE CONTACT
C IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
C IN  NNC    : NOMBRE DE NOEUDS DE LA MAILLE DE CONTACT
C IN  NNES   : NOMBRE DE NOEUDS SOMMETS DE LA MAILLE ESCLAVE
C IN  NSINGE : NOMBRE DE FONCTIONS SINGULIERE ESCLAVES
C IN  NSINGM : NOMBRE DE FONCTIONS SINGULIERE MAIT RES
C IN  DDLES : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
C IN  RRE    : SQRT LSN PT ESCLAVE
C IN  RRM    : SQRT LSN PT MAITRE
C IN  NORM   : VALEUR DE LA NORMALE
C IN  JGEOM  : POINTEUR JEVEUX SUR GEOMETRIE INITIALE
C IN  JDEPDE : POINTEUR JEVEUX POUR DEPDEL
C OUT JEUCA  : VALEUR DU JEU POUR LES SECONDS MEMBRES DE CONTACT
C
C
C
C
      INTEGER IDIM,INOM,ISINGE,INOES,ISINGM,IN,JN,NDDLE
      INTEGER NDEPLE,NNE,NNES,NNEM,NNM,NNMS,DDLES,DDLEM,DDLMS,DDLMM
      INTEGER IFH,IDDL
      REAL*8  POSE(3),POSM(3),IESCL(6),IMAIT(6),POS
      INTEGER PL
C
C ----------------------------------------------------------------------
C

C
C --- INNITIALISATION
C
      IESCL(1) = 1
      IESCL(2) =-1
      IESCL(2+NFHE)=-RRE
      IMAIT(1) = 1
      IMAIT(2) = 1
      IMAIT(2+NFHM)= RRM
      NNE=JNNE(1)
      NNES=JNNE(2)
      NNEM=JNNE(3)
      NNM=JNNM(1)
      NNMS=JNNM(2)
      DDLES=JDDLE(1)
      DDLEM=JDDLE(2)
      DDLMS=JDDLM(1)
      DDLMM=JDDLM(2)
      NDDLE = DDLES*NNES+DDLEM*NNEM
C
      JEUCA  = 0.D0
      CALL VECINI(3,0.D0,POSE)
      CALL VECINI(3,0.D0,POSM)
C
C --- CALCUL DE LA POSITION COURANTE DU POINT ESCLAVE
C
      DO 10 IDIM = 1,NDIM
        DO 20 INOES = 1,NDEPLE
          CALL INDENT(INOES,DDLES,DDLEM,NNES,IN)
          IF (NNM.NE.0) THEN
            IF (LMULTI) THEN
              DO 30 IFH = 1,NFHE
                IESCL(1+IFH)=HEAVFA(NFHE*(INOES-1)+IFH)
   30         CONTINUE
            ENDIF
            POS = ZR(JGEOM-1+NDIM*(INOES-1)+IDIM)
            DO 40 IDDL=1,1+NFHE+NSINGE
              PL = IN + (IDDL-1)*NDIM + IDIM
              POS = POS + IESCL(IDDL)*ZR(JDEPDE-1+PL)
   40       CONTINUE
            POSE(IDIM) = POSE(IDIM) + POS*FFE(INOES)
          ELSE
            PL = IN + IDIM
            POSE(IDIM) = POSE(IDIM) - RRE*FFE(INOES)*ZR(JDEPDE-1+PL)
          ENDIF
 20     CONTINUE
 10   CONTINUE
C
C --- CALCUL DE LA POSITION COURANTE DU POINT MAITRE
C
      DO 50 IDIM = 1,NDIM
        DO 60 INOM = 1,NNM
          CALL INDENT(INOM,DDLMS,DDLMM,NNMS,IN)
          IN = IN + NDDLE
          IF (LMULTI) THEN
            DO 70 IFH = 1,NFHM
              IMAIT(1+IFH)=HEAVFA(NFHE*NNE+NFHM*(INOM-1)+IFH)
   70       CONTINUE
          ENDIF
          POS = ZR(JGEOM-1+NNE*NDIM+(INOM-1)*NDIM+IDIM)
          DO 80 IDDL=1,1+NFHM+NSINGM
            PL = IN + (IDDL-1)*NDIM + IDIM
            POS = POS + IMAIT(IDDL)*ZR(JDEPDE-1+PL)
   80     CONTINUE
          POSM(IDIM) = POSM(IDIM) + POS*FFM(INOM)
 60     CONTINUE
 50   CONTINUE
C
C --- CALCUL DU JEU
C
      DO 90 IDIM = 1,NDIM
        JEUCA  = JEUCA  + NORM(IDIM)*(POSE(IDIM)-POSM(IDIM))
  90  CONTINUE
C
      END

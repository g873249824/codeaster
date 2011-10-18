      SUBROUTINE MMMTUU(PHASEP,NDIM  ,NNE   ,NNM   ,MPROJN,
     &                  MPROJT,WPG   ,FFE   ,FFM   ,JACOBI,
     &                  COEFAC,COEFAF,COEFFF,RESE  ,NRESE ,
     &                  LAMBDA,MATREE,MATRMM,MATREM,MATRME)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 17/10/2011   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*9  PHASEP
      INTEGER      NDIM,NNE,NNM
      REAL*8       MPROJN(3,3),MPROJT(3,3)
      REAL*8       FFE(9),FFM(9)
      REAL*8       WPG,JACOBI
      REAL*8       RESE(3),NRESE
      REAL*8       COEFAC,COEFAF
      REAL*8       LAMBDA,COEFFF
      REAL*8       MATREM(27,27),MATRME(27,27)
      REAL*8       MATREE(27,27),MATRMM(27,27)
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
C
C CALCUL DE LA MATRICE DEPL/DEPL
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
C IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
C IN  MPROJN : MATRICE DE PROJECTION NORMALE [Pn]
C IN  MPROJT : MATRICE DE PROJECTION TANGENTE [Pt]
C IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFE    : FONCTIONS DE FORMES DEPL. ESCL.
C IN  FFM    : FONCTIONS DE FORMES DEPL. MAIT.
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  COEFAC : COEF_AUGM_CONT
C IN  COEFAF : COEF_AUGM_FROT
C IN  LAMBDA : LAGRANGIEN DE CONTACT
C IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
C               GTK = LAMBDAF + COEFAF*VITESSE
C IN  NRESE  : NORME DU SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
C IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
C OUT MATREE : MATRICE ELEMENTAIRE DEPL_E/DEPL_E
C OUT MATRMM : MATRICE ELEMENTAIRE DEPL_M/DEPL_M
C OUT MATRME : MATRICE ELEMENTAIRE DEPL_M/DEPL_E
C OUT MATREM : MATRICE ELEMENTAIRE DEPL_E/DEPL_M
C
C ----------------------------------------------------------------------
C
C
C --- DEPL_ESCL/DEPL_ESCL
C
      CALL MMMTEE(PHASEP,NDIM  ,NNE   ,MPROJN,MPROJT,
     &            WPG   ,FFE   ,JACOBI,COEFAC,COEFAF,
     &            COEFFF,RESE  ,NRESE ,LAMBDA,MATREE)
C
C --- DEPL_MAIT/DEPL_MAIT
C
      CALL MMMTMM(PHASEP,NDIM  ,NNM   ,MPROJN,MPROJT,
     &            WPG   ,FFM   ,JACOBI,COEFAC,COEFAF,
     &            COEFFF,RESE  ,NRESE ,LAMBDA,MATRMM)
C
C --- DEPL_ESCL/DEPL_MAIT
C
      CALL MMMTEM(PHASEP,NDIM  ,NNE   ,NNM   ,MPROJN,
     &            MPROJT,WPG   ,FFE   ,FFM   ,JACOBI,
     &            COEFAC,COEFAF,COEFFF,RESE  ,NRESE ,
     &            LAMBDA,MATREM)
C
C --- DEPL_MAIT/DEPL_ESCL
C
      CALL MMMTME(PHASEP,NDIM  ,NNE   ,NNM   ,MPROJN,
     &            MPROJT,WPG   ,FFE   ,FFM   ,JACOBI,
     &            COEFAC,COEFAF,COEFFF,RESE  ,NRESE ,
     &            LAMBDA,MATRME)
C
      END

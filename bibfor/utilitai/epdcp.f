      SUBROUTINE EPDCP(TC,TD,SIGI,EPSI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C
C FONCTION : CALCUL DE LA DEFORMATION DANS LA DIRECTION DE LA PLUS
C     GRANDE CONTRAINTE EQUIVALENTES
C ----------------------------------------------------------------------
C     IN     TC    TENSEUR DES CONTRAINTE  (XX YY ZZ XY XZ YZ)
C            TD   TENSEUR DES DEFORMATIONS (XX YY ZZ XY XZ YZ)
C            NDIM  DIMENSION ESPACE 3 OU 2
C     OUT    SIGI  LA PLUS GRANDE CONTRAINTE EQUIVALENTE
C            EPSI  DEFORMATION DANS LA DIRECTION DE LA PLUS
C                  GRANDE CONTRAINTE EQUIVALENTES
C
C
C ----------------------------------------------------------------------
      IMPLICIT NONE
      REAL*8 TC(6),TD(6),TR(6),TU(6),VECP(3,3),VECINT(3)
      REAL*8 EQUI(3),SIGI,EPSI,JACAUX(3),T(3,3)

      REAL*8 TOL,TOLDYN
      INTEGER NBVEC,NPERM
      INTEGER TYPE,IORDRE
C-----------------------------------------------------------------------
      INTEGER I ,K ,NITJAC 
C-----------------------------------------------------------------------
      DATA NPERM,TOL,TOLDYN/20,1.D-10,1.D-2/
C ----------------------------------------------------------------------


C       MATRICE TR = (XX XY XZ YY YZ ZZ) (POUR JACOBI)
C
      TR(1) = TC(1)
      TR(2) = TC(4)
      TR(3) = TC(5)
      TR(4) = TC(2)
      TR(5) = TC(6)
      TR(6) = TC(3)
C
C       MATRICE UNITE = (1 0 0 1 0 1) (POUR JACOBI)
C
      TU(1) = 1.D0
      TU(2) = 0.D0
      TU(3) = 0.D0
      TU(4) = 1.D0
      TU(5) = 0.D0
      TU(6) = 1.D0
C
C       MATRICE DES DEFORMATIONS PLASTIQUES
C
      T(1,1)=TD(1)
      T(2,2)=TD(2)
      T(3,3)=TD(3)
      T(1,2)=TD(4)
      T(2,1)=TD(4)
      T(3,1)=TD(5)
      T(1,3)=TD(5)
      T(3,2)=TD(6)
      T(2,3)=TD(6)

      NBVEC = 3
      TYPE = 0
      IORDRE = 1
      CALL JACOBI(NBVEC,NPERM,TOL,TOLDYN,TR,TU,VECP,EQUI(1),JACAUX,
     &            NITJAC,TYPE,IORDRE)
      IF (EQUI(1).GT.(0.D0)) THEN
         VECINT(1) = 0.D0
         VECINT(2) = 0.D0
         VECINT(3) = 0.D0
         DO 1 K=1,3
           VECINT(1)=VECINT(1)+T(1,K)*VECP(K,1)
           VECINT(2)=VECINT(2)+T(2,K)*VECP(K,1)
           VECINT(3)=VECINT(3)+T(3,K)*VECP(K,1)
1        CONTINUE
         EPSI = 0.D0
         DO 3 I=1,3
         EPSI=EPSI+VECINT(I)*VECP(I,1)
3        CONTINUE
         SIGI=EQUI(1)
      ELSE
         EPSI = 0.D0
         SIGI=0.D0
      ENDIF

      END

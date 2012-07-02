      SUBROUTINE NBVAL(CK,CM,CMAT,NDIM,LAMBDA,NB)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C***********************************************************************
C    B. GUIGON   P. RICHARD                    DATE 06/04/92
C-----------------------------------------------------------------------
C  BUT:  < CALCULER LE NOMBRE DE VALEUR PROPRES INFERIEURES A LAMBDA
      IMPLICIT NONE
C          D'UN  PROBLEME HERMITIEN >
C
C   CALCULER LE NOMBRE DE VALEURS PROPRES INFERIEURES A LAMBDA D'UN
C   PROBLEME HERMITIEN
C                     CK*X= L CM*X
C-----------------------------------------------------------------------
C
C CK       /I/: MATRICE RAIDEUR DU PROBLEME
C CM       /I/: MATRICE MASSE DU PROBLEME
C NDIM     /I/: DIMENSION DES MATRICES
C LAMBDA   /I/: VOIR DESCRIPTION DE LA ROUTINE
C NB       /O/: NOMBRE DE VALEURS PROPRES
C
C-----------------------------------------------------------------------
C
      INTEGER    NDIM,NB
      COMPLEX*16 CK(*),CM(*),CMAT(*)
      REAL*8     LAMBDA
      INTEGER    I,IPIVO
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
C      INITIALISATION DE LA MATRICE K-LAMBDA*M
C
C-----------------------------------------------------------------------
      INTEGER IDIAG 
C-----------------------------------------------------------------------
      DO 10 I=1,NDIM*(NDIM+1)/2
        CMAT(I)=CK(I)-LAMBDA*CM(I)
 10   CONTINUE
C
C    FACTORISATION DE LA MATRICE
C
      CALL TRLDC(CMAT,NDIM,IPIVO)
C
C    COMPTAGE DU NOMBRE DE TERME NEGATIF SUR LA DIAGONALE DE 'D'
C    DANS LA DECOMPOSTION LDLT DE LA MATRICE
C
      NB=0
      DO 20 I=1, NDIM
        IDIAG = I*(I-1)/2+1
        IF (DBLE(CMAT(IDIAG)).LT.0.D0) NB=NB+1
 20   CONTINUE
C
      END

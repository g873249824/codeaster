      SUBROUTINE XMMAB0(NDIM  ,NNC   ,JNNE   ,NFAES ,
     &                  JPCAI ,HPG   ,FFC   ,JACOBI,COEFCR,
     &                  LPENAC,TYPMAI,CFACE ,TAU1  ,
     &                  TAU2  ,JDDLE,NCONTA,
     &                  NFHE,LMULTI,HEAVNO,MMAT  )  
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
      INTEGER  NDIM,NNC,JNNE(3),NFAES,JPCAI,CFACE(5,3),JDDLE(2)

      REAL*8   HPG,FFC(8),JACOBI,COEFCR
      REAL*8   TAU1(3),TAU2(3)
      REAL*8   MMAT(336,336)
      CHARACTER*8  TYPMAI
      INTEGER  NCONTA,NFHE,HEAVNO(8)
      LOGICAL  LPENAC,LMULTI
C
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
C
C CALCUL DE F POUR LE CONTACT METHODE CONTINUE
C CAS SANS CONTACT (XFEM)
C
C ----------------------------------------------------------------------
C ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
C TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
C ----------------------------------------------------------------------
C
C IN  NDIM   : DIMENSION DU PROBLEME
C IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
C IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
C IN  FFC    : FONCTIONS DE FORME DU POINT DE CONTACT
C IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
C IN  TAU1   : PREMIER VECTEUR TANGENT
C IN  TAU2   : DEUXIEME VECTEUR TANGENT
C IN  NDDLSE : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
C I/O MMAT   : MATRICE ELEMENTAIRE DE CONTACT/FROTTEMENT
C
C ----------------------------------------------------------------------
C
      INTEGER I,J,K,L,II,JJ,INI,INJ,PLI,PLJ,XOULA
      INTEGER NNE,NNES,DDLES
      REAL*8  TT(2,2)
C
C ----------------------------------------------------------------------
C
C --- INITIALISATIONS
      NNE=JNNE(1)
      NNES=JNNE(2)
      DDLES=JDDLE(1)
C
      DO 300 I = 1,2
        DO 290 J = 1,2
          TT(I,J)  = 0.D0
290     CONTINUE
300   CONTINUE
C
C --- MATRICE
C
      DO 301 I = 1,NDIM
        TT(1,1) = TAU1(I)*TAU1(I) + TT(1,1)
        TT(1,2) = TAU1(I)*TAU2(I) + TT(1,2)
        TT(2,1) = TAU2(I)*TAU1(I) + TT(2,1)
        TT(2,2) = TAU2(I)*TAU2(I) + TT(2,2)
301   CONTINUE
C
      DO 284 I = 1,NNC
        DO 283 J = 1,NNC
          CALL XPLMA2(NDIM,NNE,NNES,DDLES,I,NFHE,PLI)
          IF (LMULTI) PLI = PLI + (HEAVNO(I)-1)*NDIM
          CALL XPLMA2(NDIM,NNE,NNES,DDLES,J,NFHE,PLJ)
          IF (LMULTI) PLJ = PLJ + (HEAVNO(J)-1)*NDIM
          DO 282 L = 1,NDIM-1
            DO 281 K = 1,NDIM-1
              II = PLI+L
              JJ = PLJ+K
              IF(LPENAC) THEN
                MMAT(II,JJ) = HPG*FFC(I)*FFC(J)*
     &           JACOBI*TT(L,K)
              ELSE
                MMAT(II,JJ) = HPG*FFC(I)*FFC(J)*
     &           JACOBI*TT(L,K)
              ENDIF
281         CONTINUE
282       CONTINUE
283     CONTINUE
284   CONTINUE
C
      END

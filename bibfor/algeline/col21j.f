      SUBROUTINE COL21J(FRONTI,FRONTJ,FRN,J,L,N,N1,T1,T2)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C RESPONSABLE JFBHHUC C.ROSE
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C     VERSION MODIFIEE POUR L' APPEL A DGEMV (PRODUITS MATRICE-VECTEUR)
C     LE STOCKAGE DES COLONNES DE LA FACTORISEE EST MODIFIE
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER N,N1
      REAL*8 FRONTI(*),FRONTJ(*),T1(N),T2(N),FRN(*)
C
      INTEGER I,J,L,LL,IC1,IC2,ID1,ID2,JD1,JD
      IC1 = 3
      IC2 = IC1 + N
      JD1 = 0
      LL = L
      DO 120 K = 1,N1
          ID1 = IC1
          ID2 = IC2
CCDIR$ IVDEP
          DO 110 I = 1,LL
              JD1 = JD1 + 1
              FRONTJ(JD1) = FRONTJ(JD1) - T1(K)*FRONTI(ID1) -
     +                      T2(K)*FRONTI(ID2)
              ID1 = ID1 + 1
              ID2 = ID2 + 1
  110     CONTINUE
          LL = LL - 1
          IC1 = IC1 + 1
          IC2 = IC2 + 1
          JD1 = JD1 + 2*J + K
  120 CONTINUE
      JD1 = 0
      DO 140 K = N1 + 1,L
          ID1 = IC1
          ID2 = IC2
          JD = JD1
CCDIR$ IVDEP
          DO 130 I = 1,LL
              JD = JD + 1
              FRN(JD) = FRN(JD) - T1(K)*FRONTI(ID1)
              ID1 = ID1 + 1
  130     CONTINUE
C
          DO 131 I = 1,LL
              JD1 = JD1 + 1
              FRN(JD1) = FRN(JD1) - T2(K)*FRONTI(ID2)
              ID2 = ID2 + 1
 131       CONTINUE
          LL = LL - 1
          IC1 = IC1 + 1
          IC2 = IC2 + 1
  140 CONTINUE
      END

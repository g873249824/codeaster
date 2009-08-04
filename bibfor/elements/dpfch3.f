      SUBROUTINE DPFCH3 ( NNO, NNF, POIDS, DFRDEF, DFRDNF, DFRDKF,
     &         COOR, DFRDEG, DFRDNG, DFRDKG, DFDX, DFDY, DFDZ, JAC )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/08/2009   AUTEUR MEUNIER S.MEUNIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT NONE
C      REAL*8 (A-H,O-Z)
      INTEGER           NNO, NNF
      REAL*8            POIDS,DFRDEG(1),DFRDNG(1),DFRDKG(1),COOR(1)
      REAL*8            DFRDEF(1),DFRDNF(1),DFRDKF(1)
      REAL*8            DFDX(1),DFDY(1),DFDZ(1),JAC
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES DERIVEES DES FONCTIONS DE FORME
C               PAR RAPPORT A UN ELEMENT COURANT EN UN POINT DE GAUSS
C               POUR LES ELEMENTS 3D NON ISOPARAMETRIQUES
C                                    ====================
C    - ARGUMENTS:
C        DONNEES:
C          NNO           -->  NOMBRE DE NOEUDS
C          NNF           -->  NOMBRE DE FONCTIONS DE FORME
C          POIDS         -->  POIDS DU POINT DE GAUSS
C   DFRDEG,DFDNG,DFRDKG  -->  DERIVEES FONCTIONS DE FORME (GEOMETRIE)
C   DFRDEF,DFDNF,DFRDKF  -->  DERIVEES FONCTIONS DE FORME (VARIABLES)
C          COOR          -->  COORDONNEES DES NOEUDS
C
C        RESULTATS:
C          DFDX          <--  DERIVEES DES F. DE F. / X
C          DFDY          <--  DERIVEES DES F. DE F. / Y
C          DFDZ          <--  DERIVEES DES F. DE F. / Z
C          JAC           <--  JACOBIEN AU POINT DE GAUSS
C ......................................................................
C
      INTEGER     I, J, II
      REAL*8      G(3,3),J11,J12,J13,J21,J22,J23,J31,J32,J33,DE,DN,DK
      REAL*8 VALR
C
C     --- INITIALISATION DE LA MATRICE JACOBIENNE A ZERO
C
      CALL MATINI(3,3,0.D0,G)

C
C     --- CALCUL DE LA MATRICE JACOBIENNE (TRANSFORMATION GEOMETRIQUE)
C
      DO 100 I = 1, NNO
         II = 3*(I-1)
         DE = DFRDEG(I)
         DN = DFRDNG(I)
         DK = DFRDKG(I)
         DO 110 J = 1, 3
            G(1,J) = G(1,J) + COOR(II+J) * DE
            G(2,J) = G(2,J) + COOR(II+J) * DN
            G(3,J) = G(3,J) + COOR(II+J) * DK
110      CONTINUE
100   CONTINUE
C
C     --- CALCUL DE L'INVERSE DE LA MATRICE JACOBIENNE
C
      J11 = G(2,2) * G(3,3) - G(2,3) * G(3,2)
      J21 = G(3,1) * G(2,3) - G(2,1) * G(3,3)
      J31 = G(2,1) * G(3,2) - G(3,1) * G(2,2)
      J12 = G(1,3) * G(3,2) - G(1,2) * G(3,3)
      J22 = G(1,1) * G(3,3) - G(1,3) * G(3,1)
      J32 = G(1,2) * G(3,1) - G(3,2) * G(1,1)
      J13 = G(1,2) * G(2,3) - G(1,3) * G(2,2)
      J23 = G(2,1) * G(1,3) - G(2,3) * G(1,1)
      J33 = G(1,1) * G(2,2) - G(1,2) * G(2,1)
C
C     --- DETERMINANT DE LA MATRICE JACOBIENNE
C
      JAC = G(1,1) * J11 + G(1,2) * J21 + G(1,3) * J31
      IF(JAC.LE.0.0D0) THEN
         VALR = JAC
         CALL U2MESG('A','ELEMENTS5_30',0,' ',0,0,1,VALR)
      ENDIF
C
C     --- CALCUL DES DERIVEES EN ESPACE DES FONCTIONS DE FORME
C         DES VARIABLES
C
      DO 200 I = 1, NNF
         DFDX(I) = (J11*DFRDEF(I)+J12*DFRDNF(I)+J13*DFRDKF(I))/JAC
         DFDY(I) = (J21*DFRDEF(I)+J22*DFRDNF(I)+J23*DFRDKF(I))/JAC
         DFDZ(I) = (J31*DFRDEF(I)+J32*DFRDNF(I)+J33*DFRDKF(I))/JAC
200   CONTINUE
C
C
      JAC = ABS(JAC) * POIDS
C
      END

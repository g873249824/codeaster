      SUBROUTINE ARLTE(NDIM  ,NPIG    ,PIG    ,
     &                 FCPIG1    ,DFPIG1   ,NDML1   ,MTL1,
     &                 FCPIG2    ,DFPIG2   ,NDML2   ,MTL2)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 13/10/2009   AUTEUR CAO B.CAO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MEUNIER S.MEUNIER
C
      IMPLICIT NONE
      INTEGER NDIM
      INTEGER NPIG
      REAL*8  PIG(NPIG)
      INTEGER NDML1
      REAL*8  FCPIG1(NDML1,*),DFPIG1(NDIM,NDML1,*)
      REAL*8  MTL1(*)
      INTEGER NDML2
      REAL*8  FCPIG2(NDML2,*),DFPIG2(NDIM,NDML2,*)
      REAL*8  MTL2(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE ARLEQUIN
C
C MATRICES ELEMENTAIRES DE COUPLAGE
C
C ----------------------------------------------------------------------
C
C
C MAILLE 1 : SUPPORT DES MULTIPLICATEURS
C
C IN  NDIM   : DIMENSION DE L'ESPACE
C IN  NDML1    : NOMBRE DE NOEUDS MAILLE 1
C IN  NDML2    : NOMBRE DE NOEUDS MAILLE 2
C IN  NPIG     : NOMBRE DE POINTS D'INTEGRATION
C IN  PIG     : POIDS D'INTEGRATION
C IN  FCPIG1     : FNCTS FORME PTS D'INTEGRATION MAILLE 1
C IN  DFPIG1    : DERIVEES FNCTS FORME ASSOCIEES
C IN  FCPIG2     : FNCTS FORME PTS D'INTEGRATION MAILLE 2
C IN  DFPIG2    : DERIVEES FNCT FORME ASSOCIEES
C I/O MTL1     : MATRICES ELEMENTAIRES MAILLE 1
C               DIM: ((1+NDIM*NDIM)*NDML1*NDML1)
C I/O MTL2     : MATRICES ELEMENTAIRES MAILLE 2
C               DIM: ((1+NDIM*NDIM)*NDML1*NDML2)
C
C STRUCTURE DE MTL* :
C ( W1.1*W2.1  , W1.1*W2.2  , ..., W1.2*W2.1, W1.2*W2.2, ...,
C   W1.1X*W2.1X, W1.1Y*W2.1X, [W1.1Z*W2.1X], W1.1X*W2.1Y, ...,
C   W1.1X*W2.2X, ..., W1.2X*W2.1X, ... )
C
C ----------------------------------------------------------------------
C
      INTEGER NDML11,NDML12,PMAT1,PMAT2,PMAT3,PMAT4
      INTEGER IAUX,JAUX,KAUX,LAUX,MAUX
      REAL*8  VLR0,VLR1,VLR2
C
C ----------------------------------------------------------------------
C
      NDML11 = NDML1*NDML1
      NDML12 = NDML1*NDML2
C
C --- FORMULE D'INTEGRATION
C

      DO 99 IAUX = 1, NPIG

        VLR0 = PIG(IAUX)

        PMAT1 = 1
        PMAT2 = 1
        PMAT3 = NDML11
        PMAT4 = NDML12
C
C --- INTEGRATION MATRICES MTL1
C
        DO 10 JAUX = 1, NDML1
          VLR1 = VLR0 * FCPIG1(JAUX,IAUX)

          DO 20 KAUX = 1, NDML1
            MTL1(PMAT1) = MTL1(PMAT1) + VLR1 * FCPIG1(KAUX,IAUX)
            PMAT1 = PMAT1 + 1

            DO 21 LAUX = 1, NDIM
              VLR2 = VLR0 * DFPIG1(LAUX,KAUX,IAUX)




              DO 22 MAUX = 1, NDIM

                PMAT3 = PMAT3 + 1
                MTL1(PMAT3) = MTL1(PMAT3) + VLR2*DFPIG1(MAUX,JAUX,IAUX)

  22          CONTINUE

  21        CONTINUE

  20      CONTINUE
C
C --- INTEGRATION MATRICES MTL2
C
          DO 30 KAUX = 1, NDML2

            MTL2(PMAT2) = MTL2(PMAT2) + VLR1 * FCPIG2(KAUX,IAUX)
            PMAT2 = PMAT2 + 1

            DO 31 LAUX = 1, NDIM

              VLR2 = VLR0 * DFPIG2(LAUX,KAUX,IAUX)

              DO 32 MAUX = 1, NDIM
                PMAT4 = PMAT4 + 1
                MTL2(PMAT4) = MTL2(PMAT4) + VLR2*DFPIG1(MAUX,JAUX,IAUX)

 32           CONTINUE

 31         CONTINUE

 30       CONTINUE


 10    CONTINUE


 99   CONTINUE



      END

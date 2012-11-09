      SUBROUTINE TE0017 ( OPTION, NOMTE )
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'

      CHARACTER*16        OPTION, NOMTE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C.......................................................................

C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'CHAR_MECA_FORC_F '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C

      INTEGER      IPOIDS,IVF,IDFDE,IGEOM,ITEMPS,IFORC,IER
      INTEGER      JGANO,NNO,NDL,KP,NPG1,II,I,L,IVECTU,NDIM,NNOS
      REAL*8       DFDX(27),DFDY(27),DFDZ(27),POIDS,FX,FY,FZ
      REAL*8       XX,YY,ZZ,VALPAR(4)
      CHARACTER*8  NOMPAR(4)
C     ------------------------------------------------------------------

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PVECTUR','E',IVECTU)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PFF3D3D','L',IFORC)

      VALPAR(4) = ZR(ITEMPS)
      NOMPAR(1) = 'X'
      NOMPAR(2) = 'Y'
      NOMPAR(3) = 'Z'
      NOMPAR(4) = 'INST'

      NDL = 3*NNO
      DO 20 I = 1,NDL
        ZR(IVECTU+I-1) = 0.0D0
   20 CONTINUE

C    BOUCLE SUR LES POINTS DE GAUSS

      DO 50 KP = 1,NPG1

        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )

        XX = 0.D0
        YY = 0.D0
        ZZ = 0.D0
        DO 30 I = 1,NNO
          XX = XX + ZR(IGEOM+3*I-3)*ZR(IVF+L+I-1)
          YY = YY + ZR(IGEOM+3*I-2)*ZR(IVF+L+I-1)
          ZZ = ZZ + ZR(IGEOM+3*I-1)*ZR(IVF+L+I-1)
   30   CONTINUE
        VALPAR(1) = XX
        VALPAR(2) = YY
        VALPAR(3) = ZZ
        CALL FOINTE('FM',ZK8(IFORC  ),4,NOMPAR,VALPAR,FX,IER)
        CALL FOINTE('FM',ZK8(IFORC+1),4,NOMPAR,VALPAR,FY,IER)
        CALL FOINTE('FM',ZK8(IFORC+2),4,NOMPAR,VALPAR,FZ,IER)

        DO 40 I = 1,NNO
          II = 3* (I-1)
          ZR(IVECTU+II  ) = ZR(IVECTU+II  ) + POIDS*ZR(IVF+L+I-1)*FX
          ZR(IVECTU+II+1) = ZR(IVECTU+II+1) + POIDS*ZR(IVF+L+I-1)*FY
          ZR(IVECTU+II+2) = ZR(IVECTU+II+2) + POIDS*ZR(IVF+L+I-1)*FZ

   40   CONTINUE

   50 CONTINUE

      END

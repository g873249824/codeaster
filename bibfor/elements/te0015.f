      SUBROUTINE TE0015(OPTION,NOMTE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*16 NOMTE,OPTION
C.......................................................................

C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'CHAR_MECA_PESA_R '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................


      INTEGER ICODRE
      CHARACTER*16 PHENOM
      REAL*8 R8BID,RHO,COEF
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),POIDS
      INTEGER IPOIDS,IVF,IDFDE,IGEOM
      INTEGER JGANO,IMATE,IPESA,IVECTU,NNOS
      INTEGER NDIM,NNO,NPG,NDL,KP,L,I,II,J






      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PPESANR','L',IPESA)
      CALL JEVECH('PVECTUR','E',IVECTU)

      CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,ICODRE)
      CALL RCVALB('FPG1',1,1,'+',ZI(IMATE),' ',PHENOM,0,' ',R8BID,
     &            1,'RHO',RHO,ICODRE,1)

      NDL = 3*NNO
      DO 10 I = 1,NDL
        ZR(IVECTU+I-1) = 0.0D0
   10 CONTINUE

C    BOUCLE SUR LES POINTS DE GAUSS

      DO 40 KP = 1,NPG

        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )

        COEF = RHO*POIDS*ZR(IPESA)

        DO 30 I = 1,NNO
          II = 3* (I-1)

          DO 20 J = 1,3
            ZR(IVECTU+II+J-1) = ZR(IVECTU+II+J-1) +
     &                          COEF*ZR(IVF+L+I-1)*ZR(IPESA+J)
   20     CONTINUE

   30   CONTINUE

   40 CONTINUE


      END

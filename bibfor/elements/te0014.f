      SUBROUTINE TE0014(OPTION,NOMTE)
      IMPLICIT REAL*8 (A-H,O-Z)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 30/03/2004   AUTEUR CIBHHLV L.VIVAN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*16 OPTION,NOMTE
C.......................................................................

C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'CHAR_MECA_ROTA_R '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
      CHARACTER*2 CODRET

      CHARACTER*16 PHENOM
      REAL*8 AMM(81,81),FT(81),X(27),Y(27),Z(27)
      REAL*8 XI,XIJ
      REAL*8 DFDX(27),DFDY(27),DFDZ(27),POIDS
      REAL*8 RHO,OM1,OM2,OM3,OMM,OMO,RRI
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IMATE
      INTEGER JGANO,NDL,NNO,KP,NPG,II,JJ,I,J,IDEPLM,IDEPLP
      INTEGER NDIM,IVECTU,IROTA,L,IC
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      NDL = 3*NNO
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL TECACH('ONN','PDEPLMR',1,IDEPLM,IRET)
      CALL TECACH('ONN','PDEPLPR',1,IDEPLP,IRET)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PROTATR','L',IROTA)
      CALL JEVECH('PVECTUR','E',IVECTU)

      CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,CODRET)
      CALL RCVALA(ZI(IMATE),PHENOM,1,' ',R8B,1,'RHO',RHO,CODRET,'FM')

      DO 30 I = 1,NDL
        DO 20 J = 1,NDL
          AMM(I,J) = 0.D+00
   20   CONTINUE
   30 CONTINUE

      OMM = ZR(IROTA)*ZR(IROTA)
      OM1 = ZR(IROTA)*ZR(IROTA+1)
      OM2 = ZR(IROTA)*ZR(IROTA+2)
      OM3 = ZR(IROTA)*ZR(IROTA+3)
      IF (IDEPLM.EQ.0 .OR. IDEPLP.EQ.0) THEN
        DO 40 I = 1,NNO
          X(I) = ZR(IGEOM+3* (I-1)) - ZR(IROTA+4)
          Y(I) = ZR(IGEOM+3*I-2) - ZR(IROTA+5)
          Z(I) = ZR(IGEOM+3*I-1) - ZR(IROTA+6)
   40   CONTINUE
      ELSE
        DO 50 I = 1,NNO
          X(I) = ZR(IGEOM+3*I-3) + ZR(IDEPLM+3*I-3) + ZR(IDEPLP+3*I-3) -
     &           ZR(IROTA+4)
          Y(I) = ZR(IGEOM+3*I-2) + ZR(IDEPLM+3*I-2) + ZR(IDEPLP+3*I-2) -
     &           ZR(IROTA+5)
          Z(I) = ZR(IGEOM+3*I-1) + ZR(IDEPLM+3*I-1) + ZR(IDEPLP+3*I-1) -
     &           ZR(IROTA+6)
   50   CONTINUE
      END IF
      DO 60 I = 1,NNO
        OMO = OM1*X(I) + OM2*Y(I) + OM3*Z(I)
        FT(3*I-2) = OMM*X(I) - OMO*OM1
        FT(3*I-1) = OMM*Y(I) - OMO*OM2
        FT(3*I) = OMM*Z(I) - OMO*OM3
   60 CONTINUE

C    BOUCLE SUR LES POINTS DE GAUSS

      DO 100 KP = 1,NPG

        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )
        DO 90 I = 1,NNO
          XI = RHO*POIDS*ZR(IVF+L+I-1)
          II = 3* (I-1)
          DO 80 J = 1,NNO
            XIJ = XI*ZR(IVF+L+J-1)
            JJ = 3* (J-1)
            DO 70 IC = 1,3
              AMM(II+IC,JJ+IC) = AMM(II+IC,JJ+IC) + XIJ
   70       CONTINUE
   80     CONTINUE
   90   CONTINUE
  100 CONTINUE

      DO 120 I = 1,NDL
        RRI = 0.D0
        DO 110 J = 1,NDL
          RRI = RRI + AMM(I,J)*FT(J)
  110   CONTINUE
        AMM(I,I) = RRI
  120 CONTINUE

      DO 130 I = 1,NDL
        ZR(IVECTU+I-1) = AMM(I,I)
  130 CONTINUE

      END

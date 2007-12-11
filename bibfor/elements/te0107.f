      SUBROUTINE TE0107 ( OPTION , NOMTE )
      IMPLICIT NONE
      CHARACTER*16  OPTION,NOMTE
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
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
C                          OPTION : 'CHAR_THER_TEXT_F'
C                          CAS COQUE
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
      INTEGER    NBRES
      PARAMETER (NBRES=4)
      CHARACTER*8  NOMPAR(NBRES)
      REAL*8       PC(3),FPL,FMO,VALPAR(NBRES),THETA
      REAL*8       COOR2D(18),X,Y,Z,RP1,RP2,RP3,TEXN,POID,LONG
      REAL*8       COEFM2,TEXTM2,COEFM1,TEXTM1,COEFP1,TEXTP1
      REAL*8       DFDX(9),DFDY(9),POIDS,COUR,COSA,SINA,ZERO,UN
      REAL*8       COENP1,COEN,TEXNP1,MATNP(9),COEFP2,TEXTP2
      INTEGER      I,K,IER,NNO,KP,NPG1,GI,PI,IVECTT,ICOEF
      INTEGER      ITEMPS,ITEX,NNOS,JGANO,NDIM
      INTEGER      IPOIDS,IVF,IDFDE,IGEOM

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

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)
      ZERO = 0.D0
      UN = 1.D0
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PCOEFHF','L',ICOEF)
      CALL JEVECH('PT_EXTF','L',ITEX)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PVECTTR','E',IVECTT)

      THETA = ZR(ITEMPS+2)

      IF (NOMTE(1:8).NE.'THCPSE3 ' .AND. NOMTE(1:8).NE.'THCASE3 ' .AND.
     &    NOMTE(1:8).NE.'THCOSE3 ' .AND. NOMTE(1:8).NE.'THCOSE2 ') THEN

        NOMPAR(1) = 'X'
        NOMPAR(2) = 'Y'
        NOMPAR(3) = 'Z'
        NOMPAR(4) = 'INST'

        CALL CQ3D2D(NNO,ZR(IGEOM),1.D0,ZERO,COOR2D)

        DO 40 KP = 1,NPG1
          K = (KP-1)*NNO
          CALL DFDM2D(NNO,KP,IPOIDS,IDFDE,COOR2D,DFDX,DFDY,POIDS)

          X = ZERO
          Y = ZERO
          Z = ZERO
          DO 10 I = 1,NNO
            X = X + ZR(IGEOM+3* (I-1))*ZR(IVF+K+I-1)
            Y = Y + ZR(IGEOM+3* (I-1)+1)*ZR(IVF+K+I-1)
            Z = Z + ZR(IGEOM+3* (I-1)+2)*ZR(IVF+K+I-1)
   10     CONTINUE
          VALPAR(1) = X
          VALPAR(2) = Y
          VALPAR(3) = Z
          VALPAR(4) = ZR(ITEMPS)
          CALL FOINTE('FM',ZK8(ICOEF),4,NOMPAR,VALPAR,COEFM2,IER)
          CALL FOINTE('FM',ZK8(ITEX+1),4,NOMPAR,VALPAR,TEXTM2,IER)
          CALL FOINTE('FM',ZK8(ICOEF+1),4,NOMPAR,VALPAR,COEFP2,IER)
          CALL FOINTE('FM',ZK8(ITEX+2),4,NOMPAR,VALPAR,TEXTP2,IER)
          VALPAR(4) = ZR(ITEMPS) - ZR(ITEMPS+1)
          CALL FOINTE('FM',ZK8(ICOEF),4,NOMPAR,VALPAR,COEFM1,IER)
          CALL FOINTE('FM',ZK8(ITEX+1),4,NOMPAR,VALPAR,TEXTM1,IER)
          CALL FOINTE('FM',ZK8(ICOEF+1),4,NOMPAR,VALPAR,COEFP1,IER)
          CALL FOINTE('FM',ZK8(ITEX+2),4,NOMPAR,VALPAR,TEXTP1,IER)
          FMO = THETA*COEFM2*TEXTM2 + (UN-THETA)*COEFM1*TEXTM1
          FPL = THETA*COEFP2*TEXTP2 + (UN-THETA)*COEFP1*TEXTP1
          PC(1) = ZERO
          PC(2) = FMO
          PC(3) = FPL

          DO 30 GI = 1,NNO
            DO 20 PI = 1,3
              I = 3* (GI-1) + PI - 1 + IVECTT
              ZR(I) = ZR(I) + POIDS*ZR(IVF+K+GI-1)*PC(PI)
   20       CONTINUE
   30     CONTINUE
   40   CONTINUE

      ELSE IF (NOMTE(1:8).EQ.'THCPSE3 ' .OR.
     &         NOMTE(1:8).EQ.'THCASE3 ') THEN

        NOMPAR(1) = 'X'
        NOMPAR(2) = 'Y'
        NOMPAR(3) = 'INST'

        DO 80 KP = 1,NPG1
          K = (KP-1)*NNO
          CALL DFDM1D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IGEOM),DFDX,
     &                COUR,POIDS,COSA,SINA)
          X = ZERO
          Y = ZERO
          DO 50 I = 1,NNO
            X = X + ZR(IGEOM+2* (I-1))*ZR(IVF+K+I-1)
            Y = Y + ZR(IGEOM+2* (I-1)+1)*ZR(IVF+K+I-1)
   50     CONTINUE

          IF (NOMTE(3:4).EQ.'CA') POIDS = POIDS*X

          VALPAR(1) = X
          VALPAR(2) = Y
          VALPAR(3) = ZR(ITEMPS)
          CALL FOINTE('FM',ZK8(ICOEF),3,NOMPAR,VALPAR,COEFM2,IER)
          CALL FOINTE('FM',ZK8(ITEX+1),3,NOMPAR,VALPAR,TEXTM2,IER)
          CALL FOINTE('FM',ZK8(ICOEF+1),3,NOMPAR,VALPAR,COEFP2,IER)
          CALL FOINTE('FM',ZK8(ITEX+2),3,NOMPAR,VALPAR,TEXTP2,IER)
          VALPAR(3) = ZR(ITEMPS) - ZR(ITEMPS+1)
          CALL FOINTE('FM',ZK8(ICOEF),3,NOMPAR,VALPAR,COEFM1,IER)
          CALL FOINTE('FM',ZK8(ITEX+1),3,NOMPAR,VALPAR,TEXTM1,IER)
          CALL FOINTE('FM',ZK8(ICOEF+1),3,NOMPAR,VALPAR,COEFP1,IER)
          CALL FOINTE('FM',ZK8(ITEX+2),3,NOMPAR,VALPAR,TEXTP1,IER)
          FMO = THETA*COEFM2*TEXTM2 + (UN-THETA)*COEFM1*TEXTM1
          FPL = THETA*COEFP2*TEXTP2 + (UN-THETA)*COEFP1*TEXTP1
          PC(1) = ZERO
          PC(2) = FMO
          PC(3) = FPL

          DO 70 GI = 1,NNO
            DO 60 PI = 1,3
              I = 3* (GI-1) + PI - 1 + IVECTT
              ZR(I) = ZR(I) + POIDS*ZR(IVF+K+GI-1)*PC(PI)
   60       CONTINUE
   70     CONTINUE
   80   CONTINUE

      ELSE IF (NOMTE(1:8).EQ.'THCOSE3 ' .OR.
     &         NOMTE(1:8).EQ.'THCOSE2 ') THEN

        LONG = (ZR(IGEOM+3)-ZR(IGEOM))**2 +
     &         (ZR(IGEOM+3+1)-ZR(IGEOM+1))**2 +
     &         (ZR(IGEOM+3+2)-ZR(IGEOM+2))**2
        LONG = SQRT(LONG)/2.D0

        NOMPAR(1) = 'X'
        NOMPAR(2) = 'Y'
        NOMPAR(3) = 'Z'
        NOMPAR(4) = 'INST'

        RP1 = 1.33333333333333D0
        RP2 = 0.33333333333333D0
        RP3 = 0.33333333333333D0

        DO 110 KP = 1,NPG1
          K = (KP-1)*NNO

          X = ZERO
          Y = ZERO
          Z = ZERO
          DO 90 I = 1,NNO
            X = X + ZR(IGEOM+3* (I-1))*ZR(IVF+K+I-1)
            Y = Y + ZR(IGEOM+3* (I-1)+1)*ZR(IVF+K+I-1)
            Z = Z + ZR(IGEOM+3* (I-1)+2)*ZR(IVF+K+I-1)
   90     CONTINUE

          VALPAR(1) = X
          VALPAR(2) = Y
          VALPAR(3) = Z
          VALPAR(4) = ZR(ITEMPS)
          CALL FOINTE('FM',ZK8(ICOEF),4,NOMPAR,VALPAR,COENP1,IER)
          VALPAR(4) = ZR(ITEMPS) - ZR(ITEMPS+1)
          CALL FOINTE('FM',ZK8(ICOEF),4,NOMPAR,VALPAR,COEN,IER)

          VALPAR(4) = ZR(ITEMPS)
          CALL FOINTE('FM',ZK8(ITEX),4,NOMPAR,VALPAR,TEXNP1,IER)
          VALPAR(4) = ZR(ITEMPS) - ZR(ITEMPS+1)
          CALL FOINTE('FM',ZK8(ITEX),4,NOMPAR,VALPAR,TEXN,IER)

          POID = ZR(IPOIDS-1+KP)

          MATNP(1) = RP1*POID*ZR(IVF-1+K+1)
          MATNP(2) = RP2*POID*ZR(IVF-1+K+1)
          MATNP(3) = RP3*POID*ZR(IVF-1+K+1)

          MATNP(4) = RP1*POID*ZR(IVF-1+K+2)
          MATNP(5) = RP2*POID*ZR(IVF-1+K+2)
          MATNP(6) = RP3*POID*ZR(IVF-1+K+2)

          IF (NOMTE(1:8).EQ.'THCOSE3 ') THEN
            MATNP(7) = RP1*POID*ZR(IVF-1+K+3)
            MATNP(8) = RP2*POID*ZR(IVF-1+K+3)
            MATNP(9) = RP3*POID*ZR(IVF-1+K+3)
          END IF

C      IMPORTANT: COENP1 OU COEN = CONV * EPAISSEUR

          DO 100 I = 1,3*NNO
            ZR(IVECTT-1+I) = ZR(IVECTT-1+I) +
     &                       LONG*MATNP(I)* (THETA*COENP1*TEXNP1+
     &                       (UN-THETA)*COEN*TEXN)/2.D0
  100     CONTINUE
  110   CONTINUE

      END IF

      END

      SUBROUTINE TE0108 ( OPTION , NOMTE )
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
C                          OPTION : 'CHAR_THER_TEXT_R'
C                          CAS COQUE
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
      REAL*8   PC(3),FPL,FMO,COOR2D(18),ZERO,COEFMO,COEFPL
      REAL*8   DFDX(9),DFDY(9),POIDS,COUR,COSA,SINA
      REAL*8   R,MATNP(9),LONG,LAMB,TEXT,TEXTMO,TEXTPL,RP1,RP2,RP3
      INTEGER  I,K,NNO,KP,NPG1,GI,PI,IVECTT,ICOEF
      INTEGER  ITEMPS,ITEX,NNOS,NDIM,JGANO
      INTEGER  IPOIDS,IVF,IDFDE,IGEOM

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
C
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)
      ZERO = 0.D0

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PVECTTR','E',IVECTT)
      CALL JEVECH('PCOEFHR','L',ICOEF)
      CALL JEVECH('PT_EXTR','L',ITEX)
      CALL JEVECH('PTEMPSR','L',ITEMPS)

      IF (NOMTE(1:8).NE.'THCOSE3 ' .AND. NOMTE(1:8).NE.'THCOSE2 ') THEN
        COEFMO = ZR(ICOEF)
        COEFPL = ZR(ICOEF+1)
        TEXTMO = ZR(ITEX+1)
        TEXTPL = ZR(ITEX+2)

        FMO = COEFMO*TEXTMO
        FPL = COEFPL*TEXTPL
        PC(1) = ZERO
        PC(2) = FMO
        PC(3) = FPL
      END IF

      IF (NOMTE(1:8).NE.'THCPSE3 ' .AND. NOMTE(1:8).NE.'THCASE3 ' .AND.
     &    NOMTE(1:8).NE.'THCOSE3 ' .AND. NOMTE(1:8).NE.'THCOSE2 ') THEN

        CALL CQ3D2D(NNO,ZR(IGEOM),1.D0,ZERO,COOR2D)

        DO 30 KP = 1,NPG1
          K = (KP-1)*NNO
          CALL DFDM2D(NNO,KP,IPOIDS,IDFDE,COOR2D,DFDX,DFDY,POIDS)
          DO 20 GI = 1,NNO
            DO 10 PI = 1,3
              I = 3* (GI-1) + PI - 1 + IVECTT
              ZR(I) = ZR(I) + POIDS*ZR(IVF+K+GI-1)*PC(PI)
   10       CONTINUE
   20     CONTINUE
   30   CONTINUE

      ELSE IF (NOMTE(1:8).EQ.'THCPSE3 ' .OR.
     &         NOMTE(1:8).EQ.'THCASE3 ') THEN

        DO 80 KP = 1,NPG1
          K = (KP-1)*NNO
          CALL DFDM1D(NNO,ZR(IPOIDS+KP-1),ZR(IDFDE+K),ZR(IGEOM),DFDX,
     &                COUR,POIDS,COSA,SINA)
          DO 50 PI = 1,3

            IF (NOMTE(3:4).EQ.'CA') THEN
              R = ZERO
              DO 40 I = 1,NNO
                R = R + ZR(IGEOM+2* (I-1))*ZR(IVF+K+I-1)
   40         CONTINUE
              POIDS = POIDS*R
            END IF

   50     CONTINUE
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

C      IMPORTANT: LAMB = CONV * EPAISSEUR

        LAMB = ZR(ICOEF)/2.D0
        TEXT = ZR(ITEX)

        RP1 = 1.33333333333333D0
        RP2 = 0.33333333333333D0
        RP3 = 0.33333333333333D0

        DO 100 KP = 1,NPG1

          K = (KP-1)*NNO

          POIDS = ZR(IPOIDS-1+KP)

          MATNP(1) = RP1*POIDS*ZR(IVF-1+K+1)
          MATNP(2) = RP2*POIDS*ZR(IVF-1+K+1)
          MATNP(3) = RP3*POIDS*ZR(IVF-1+K+1)

          MATNP(4) = RP1*POIDS*ZR(IVF-1+K+2)
          MATNP(5) = RP2*POIDS*ZR(IVF-1+K+2)
          MATNP(6) = RP3*POIDS*ZR(IVF-1+K+2)

          IF (NOMTE(1:8).EQ.'THCOSE3 ') THEN
            MATNP(7) = RP1*POIDS*ZR(IVF-1+K+3)
            MATNP(8) = RP2*POIDS*ZR(IVF-1+K+3)
            MATNP(9) = RP3*POIDS*ZR(IVF-1+K+3)
          END IF

          DO 90 I = 1,3*NNO
            ZR(IVECTT-1+I) = ZR(IVECTT-1+I) + LONG*MATNP(I)*LAMB*TEXT
   90     CONTINUE
  100   CONTINUE

      END IF

      END

      SUBROUTINE TE0315(OPTION,NOMTE)
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
C.......................................................................

C     BUT: CALCUL DES VECTEURS ELEMENTAIRES DE FLUX FLUIDE EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 1D

C          OPTION : 'CHAR_THER_ACCE_R 'OU 'CHAR_THER_ACCE_X'
C                    OU 'CHAR_THER_ACCE_Y'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C          ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      CHARACTER*2 CODRET
      CHARACTER*16 NOMTE,OPTION
      REAL*8 POIDS,NX,NY,NORM(2),ACLOC(2,3)
      REAL*8 COEF,ACC(2,4),FLUFN(4),R8PI,PI
      INTEGER IPOIDS,IVF,IDFDE,IGEOM,IFLUX
      INTEGER NDI,NNO,KP,NPG,IVECTT,IMATE
      INTEGER LDEC,MATER

C---------------- COMMUNS NORMALISES  JEVEUX  --------------------------
      COMMON /IVARJE/ZI(1)
      COMMON /RVARJE/ZR(1)
      COMMON /CVARJE/ZC(1)
      COMMON /LVARJE/ZL(1)
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      INTEGER ZI
      REAL*8 ZR
      COMPLEX*16 ZC
      LOGICAL ZL
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
C------------FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PVECTTR','E',IVECTT)

      CALL RCVALA(ZI(IMATE),'THER',0,' ',R8B,1,'RHO_CP',RHO,CODRET,'FM')

      IF (OPTION(16:16).EQ.'R') THEN
        CALL JEVECH('PACCELR','L',IACCE)
      ELSE
        IF ((OPTION(16:16).EQ.'X') .OR. (OPTION(16:16).EQ.'Y')) THEN
          CALL JEVECH('PTEMPER','L',ITEMP)
        END IF
      END IF

      K = 0
      DO 20 I = 1,NNO
        IF (OPTION(16:16).EQ.'R') THEN
          DO 10 IDIM = 1,2
            K = K + 1
            ACLOC(IDIM,I) = ZR(IACCE+K-1)
   10     CONTINUE
        ELSE IF ((OPTION(16:16).EQ.'X')) THEN
          K = K + 1
          ACLOC(1,I) = ZR(ITEMP+K-1)
          ACLOC(2,I) = 0.D0
        ELSE IF (OPTION(16:16).EQ.'Y') THEN
          K = K + 1
          ACLOC(1,I) = 0.D0
          ACLOC(2,I) = ZR(ITEMP+K-1)
        END IF
   20 CONTINUE

      DO 30 I = 1,NNO
        ZR(IVECTT+I-1) = 0.D0
   30 CONTINUE

C     BOUCLE SUR LES POINTS DE GAUSS

      DO 70 KP = 1,NPG
        LDEC = (KP-1)*NNO

        NX = 0.D0
        NY = 0.D0
C        --- ON CALCULE L ACCEL AU POINT DE GAUSS
        ACC(1,KP) = 0.D0
        ACC(2,KP) = 0.D0
        DO 40 I = 1,NNO
          ACC(1,KP) = ACC(1,KP) + ACLOC(1,I)*ZR(IVF+LDEC+I-1)
          ACC(2,KP) = ACC(2,KP) + ACLOC(2,I)*ZR(IVF+LDEC+I-1)
   40   CONTINUE

        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),NX,NY,POIDS)
        NORM(1) = NX
        NORM(2) = NY
        FLUFN(KP) = 0.D0

C CALCUL DU FLUX FLUIDE NORMAL AU POINT DE GAUSS

        FLUFN(KP) = ACC(1,KP)*NORM(1) + ACC(2,KP)*NORM(2)

C CAS AXISYMETRIQUE

        IF (NOMTE(3:4).EQ.'AX') THEN
          R = 0.D0
          DO 50 I = 1,NNO
            R = R + ZR(IGEOM+2* (I-1))*ZR(IVF+LDEC+I-1)
   50     CONTINUE
          POIDS = POIDS*R
        END IF

        DO 60 I = 1,NNO
          ZR(IVECTT+I-1) = ZR(IVECTT+I-1) +
     &                     POIDS*FLUFN(KP)*RHO*ZR(IVF+LDEC+I-1)
   60   CONTINUE
   70 CONTINUE

   80 CONTINUE
      END

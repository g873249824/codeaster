      SUBROUTINE ELRFVF(ELREFZ,X,DIMF,FF,NNO)
      IMPLICIT NONE
      INTEGER DIMF,NNO
      REAL*8 X(*),FF(*)
      CHARACTER*(*) ELREFZ
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 05/12/2002   AUTEUR CIBHHAB S.VANDENBERGHE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20

C BUT:   CALCUL DES FONCTIONS DE FORMES ET DE LEURS DERIVEES
C        AU POINT DE COORDONNEES X,Y,Z

C ----------------------------------------------------------------------
C   IN   ELREFZ : NOM DE L'ELREFE (K8)
C        X      : VECTEUR DU POINT DE CALCUL DES F FORMES ET DERIVEES
C        DIMF   : DIMENSION DE FF
C   OUT  FF     : FONCTIONS DE FORMES EN X,Y,Z
C        NNO    : NOMBRE DE NOEUDS
C   -------------------------------------------------------------------
      CHARACTER*8 ELREFE
      INTEGER I,NDIM,NNOS,NBFPG,NBPG(10)
      REAL*8 AL31,AL32,AL33,U,X0,Y0,Z0,AL,Z01,Z02,Z04,PFACE1,PFACE2
      REAL*8 PFACE3,PFACE4,PMILI1,PMILI2,PMILI3,PMILI4,TNP1,TNP2,TNP3
      REAL*8 TNP4,UXXI,UYYI,X1,X2,X3,X4,D1,D2,D3,D4
      REAL*8 ZERO,UNDEMI,UN,DEUX,QUATRE,UNS4,UNS8,XBID(3*27)

C -----  FONCTIONS FORMULES
      AL31(U) = 0.5D00*U* (U-1.D00)
      AL32(U) = - (U+1.D00)* (U-1.D00)
      AL33(U) = 0.5D00*U* (U+1.D00)
C DEB ------------------------------------------------------------------

      ELREFE = ELREFZ
      CALL CARREF(ELREFE,NDIM,NNO,NNOS,NBFPG,NBPG,XBID)
      ZERO = 0.0D0
      UNDEMI = 0.5D0
      UN = 1.0D0
      DEUX = 2.0D0
      QUATRE = 4.0D0
      UNS4 = UN/4.0D0
      UNS8 = UN/8.0D0

C     ------------------------------------------------------------------
      IF (ELREFE.EQ.'HEXA8' .OR. ELREFE.EQ.'HEXI8' .OR.
     &    ELREFE.EQ.'HEXA8L') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 8

        FF(1) = (UN-X0)* (UN-Y0)* (UN-Z0)*UNS8
        FF(2) = (UN+X0)* (UN-Y0)* (UN-Z0)*UNS8
        FF(3) = (UN+X0)* (UN+Y0)* (UN-Z0)*UNS8
        FF(4) = (UN-X0)* (UN+Y0)* (UN-Z0)*UNS8
        FF(5) = (UN-X0)* (UN-Y0)* (UN+Z0)*UNS8
        FF(6) = (UN+X0)* (UN-Y0)* (UN+Z0)*UNS8
        FF(7) = (UN+X0)* (UN+Y0)* (UN+Z0)*UNS8
        FF(8) = (UN-X0)* (UN+Y0)* (UN+Z0)*UNS8

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'HEXA20' .OR. ELREFE.EQ.'HEXS20' .OR.
     &         ELREFE.EQ.'HEXD20' .OR. ELREFE.EQ.'HEXI20') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 20

        FF(1) = (UN-X0)* (UN-Y0)* (UN-Z0)* (-X0-Y0-Z0-DEUX)*UNS8
        FF(2) = (UN+X0)* (UN-Y0)* (UN-Z0)* (X0-Y0-Z0-DEUX)*UNS8
        FF(3) = (UN+X0)* (UN+Y0)* (UN-Z0)* (X0+Y0-Z0-DEUX)*UNS8
        FF(4) = (UN-X0)* (UN+Y0)* (UN-Z0)* (-X0+Y0-Z0-DEUX)*UNS8
        FF(5) = (UN-X0)* (UN-Y0)* (UN+Z0)* (-X0-Y0+Z0-DEUX)*UNS8
        FF(6) = (UN+X0)* (UN-Y0)* (UN+Z0)* (X0-Y0+Z0-DEUX)*UNS8
        FF(7) = (UN+X0)* (UN+Y0)* (UN+Z0)* (X0+Y0+Z0-DEUX)*UNS8
        FF(8) = (UN-X0)* (UN+Y0)* (UN+Z0)* (-X0+Y0+Z0-DEUX)*UNS8
        FF(9) = (UN-X0*X0)* (UN-Y0)* (UN-Z0)*UNS4
        FF(10) = (UN+X0)* (UN-Y0*Y0)* (UN-Z0)*UNS4
        FF(11) = (UN-X0*X0)* (UN+Y0)* (UN-Z0)*UNS4
        FF(12) = (UN-X0)* (UN-Y0*Y0)* (UN-Z0)*UNS4
        FF(13) = (UN-X0)* (UN-Y0)* (UN-Z0*Z0)*UNS4
        FF(14) = (UN+X0)* (UN-Y0)* (UN-Z0*Z0)*UNS4
        FF(15) = (UN+X0)* (UN+Y0)* (UN-Z0*Z0)*UNS4
        FF(16) = (UN-X0)* (UN+Y0)* (UN-Z0*Z0)*UNS4
        FF(17) = (UN-X0*X0)* (UN-Y0)* (UN+Z0)*UNS4
        FF(18) = (UN+X0)* (UN-Y0*Y0)* (UN+Z0)*UNS4
        FF(19) = (UN-X0*X0)* (UN+Y0)* (UN+Z0)*UNS4
        FF(20) = (UN-X0)* (UN-Y0*Y0)* (UN+Z0)*UNS4

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'HEXA27') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 27

        FF(1) = AL31(X0)*AL31(Y0)*AL31(Z0)
        FF(2) = AL33(X0)*AL31(Y0)*AL31(Z0)
        FF(3) = AL33(X0)*AL33(Y0)*AL31(Z0)
        FF(4) = AL31(X0)*AL33(Y0)*AL31(Z0)
        FF(5) = AL31(X0)*AL31(Y0)*AL33(Z0)
        FF(6) = AL33(X0)*AL31(Y0)*AL33(Z0)
        FF(7) = AL33(X0)*AL33(Y0)*AL33(Z0)
        FF(8) = AL31(X0)*AL33(Y0)*AL33(Z0)
        FF(9) = AL32(X0)*AL31(Y0)*AL31(Z0)
        FF(10) = AL33(X0)*AL32(Y0)*AL31(Z0)
        FF(11) = AL32(X0)*AL33(Y0)*AL31(Z0)
        FF(12) = AL31(X0)*AL32(Y0)*AL31(Z0)
        FF(13) = AL31(X0)*AL31(Y0)*AL32(Z0)
        FF(14) = AL33(X0)*AL31(Y0)*AL32(Z0)
        FF(15) = AL33(X0)*AL33(Y0)*AL32(Z0)
        FF(16) = AL31(X0)*AL33(Y0)*AL32(Z0)
        FF(17) = AL32(X0)*AL31(Y0)*AL33(Z0)
        FF(18) = AL33(X0)*AL32(Y0)*AL33(Z0)
        FF(19) = AL32(X0)*AL33(Y0)*AL33(Z0)
        FF(20) = AL31(X0)*AL32(Y0)*AL33(Z0)
        FF(21) = AL32(X0)*AL32(Y0)*AL31(Z0)
        FF(22) = AL32(X0)*AL31(Y0)*AL32(Z0)
        FF(23) = AL33(X0)*AL32(Y0)*AL32(Z0)
        FF(24) = AL32(X0)*AL33(Y0)*AL32(Z0)
        FF(25) = AL31(X0)*AL32(Y0)*AL32(Z0)
        FF(26) = AL32(X0)*AL32(Y0)*AL33(Z0)
        FF(27) = AL32(X0)*AL32(Y0)*AL32(Z0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'PENTA6' .OR. ELREFE.EQ.'PENTA6L') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 6

        FF(1) = UNDEMI*Y0* (UN-X0)
        FF(2) = UNDEMI*Z0* (UN-X0)
        FF(3) = UNDEMI* (UN-Y0-Z0)* (UN-X0)
        FF(4) = UNDEMI*Y0* (UN+X0)
        FF(5) = UNDEMI*Z0* (UN+X0)
        FF(6) = UNDEMI* (UN-Y0-Z0)* (UN+X0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'PENTA15' .OR. ELREFE.EQ.'PENTA15D') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 15
        AL = UN - Y0 - Z0

        FF(1) = Y0* (UN-X0)* ((DEUX*Y0)-DEUX-X0)/DEUX
        FF(2) = Z0* (UN-X0)* ((DEUX*Z0)-DEUX-X0)/DEUX
        FF(3) = AL* (X0-UN)* (X0+ (DEUX*Y0)+ (DEUX*Z0))/DEUX
        FF(4) = Y0* (UN+X0)* ((DEUX*Y0)-DEUX+X0)/DEUX
        FF(5) = Z0* (UN+X0)* ((DEUX*Z0)-DEUX+X0)/DEUX
        FF(6) = AL* (-X0-UN)* (-X0+ (DEUX*Y0)+ (DEUX*Z0))/DEUX

        FF(7) = DEUX*Y0*Z0* (UN-X0)
        FF(8) = DEUX*Z0*AL* (UN-X0)
        FF(9) = DEUX*Y0*AL* (UN-X0)

        FF(10) = Y0* (UN-X0*X0)
        FF(11) = Z0* (UN-X0*X0)
        FF(12) = AL* (UN-X0*X0)

        FF(13) = DEUX*Y0*Z0* (UN+X0)
        FF(14) = DEUX*Z0*AL* (UN+X0)
        FF(15) = DEUX*Y0*AL* (UN+X0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'TETRA4' .OR. ELREFE.EQ.'TETRI4' .OR.
     &         ELREFE.EQ.'TETRA4L') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 4

        FF(1) = Y0
        FF(2) = Z0
        FF(3) = UN - X0 - Y0 - Z0
        FF(4) = X0

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'TETRA10' .OR. ELREFE.EQ.'TETRA10D' .OR.
     &         ELREFE.EQ.'TETRI10') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 10
        AL = UN - X0 - Y0 - Z0

        FF(1) = (DEUX*Y0-UN)*Y0
        FF(2) = (DEUX*Z0-UN)*Z0
        FF(3) = (DEUX*AL-UN)*AL
        FF(4) = (DEUX*X0-UN)*X0
        FF(5) = QUATRE*Z0*Y0
        FF(6) = QUATRE*Z0*AL
        FF(7) = QUATRE*AL*Y0
        FF(8) = QUATRE*X0*Y0
        FF(9) = QUATRE*X0*Z0
        FF(10) = QUATRE*X0*AL

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'PYRAM5') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 5
        Z04 = (UN-Z0)*QUATRE

        PFACE1 = X0 + Y0 + Z0 - UN
        PFACE2 = -X0 + Y0 + Z0 - UN
        PFACE3 = -X0 - Y0 + Z0 - UN
        PFACE4 = X0 - Y0 + Z0 - UN

        IF (ABS(Z0-UN).LT.1.0D-6) THEN
          DO 10 I = 1,4
            FF(I) = ZERO
   10     CONTINUE
          FF(5) = UN
        ELSE
          FF(1) = PFACE2*PFACE3/Z04
          FF(2) = PFACE3*PFACE4/Z04
          FF(3) = PFACE1*PFACE4/Z04
          FF(4) = PFACE1*PFACE2/Z04
          FF(5) = Z0
        END IF

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'PYRAM13' .OR. ELREFE.EQ.'PYRAM13D') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 13
        Z01 = UN - Z0
        Z02 = (UN-Z0)*DEUX

        PFACE1 = X0 + Y0 + Z0 - UN
        PFACE2 = -X0 + Y0 + Z0 - UN
        PFACE3 = -X0 - Y0 + Z0 - UN
        PFACE4 = X0 - Y0 + Z0 - UN

        PMILI1 = X0 - UNDEMI
        PMILI2 = Y0 - UNDEMI
        PMILI3 = -X0 - UNDEMI
        PMILI4 = -Y0 - UNDEMI

        IF (ABS(Z0-UN).LT.1.0D-6) THEN
          DO 20 I = 1,13
            FF(I) = ZERO
   20     CONTINUE
          FF(5) = UN
        ELSE
          FF(1) = PFACE2*PFACE3*PMILI1/Z02
          FF(2) = PFACE3*PFACE4*PMILI2/Z02
          FF(3) = PFACE4*PFACE1*PMILI3/Z02
          FF(4) = PFACE1*PFACE2*PMILI4/Z02
          FF(5) = DEUX*Z0* (Z0-UNDEMI)
          FF(6) = -PFACE2*PFACE3*PFACE4/Z02
          FF(7) = -PFACE3*PFACE4*PFACE1/Z02
          FF(8) = -PFACE4*PFACE1*PFACE2/Z02
          FF(9) = -PFACE1*PFACE2*PFACE3/Z02
          FF(10) = Z0*PFACE2*PFACE3/Z01
          FF(11) = Z0*PFACE3*PFACE4/Z01
          FF(12) = Z0*PFACE4*PFACE1/Z01
          FF(13) = Z0*PFACE1*PFACE2/Z01
        END IF

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'FACE4') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 4

        FF(1) = UNS4* (UN-X0)* (UN-Y0)
        FF(2) = UNS4* (UN+X0)* (UN-Y0)
        FF(3) = UNS4* (UN+X0)* (UN+Y0)
        FF(4) = UNS4* (UN-X0)* (UN+Y0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'FACE8') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 8

        FF(1) = UNS4* (UN-X0)* (UN-Y0)* (-UN-X0-Y0)
        FF(2) = UNS4* (UN+X0)* (UN-Y0)* (-UN+X0-Y0)
        FF(3) = UNS4* (UN+X0)* (UN+Y0)* (-UN+X0+Y0)
        FF(4) = UNS4* (UN-X0)* (UN+Y0)* (-UN-X0+Y0)
        FF(5) = UNDEMI* (UN-X0*X0)* (UN-Y0)
        FF(6) = UNDEMI* (UN-Y0*Y0)* (UN+X0)
        FF(7) = UNDEMI* (UN-X0*X0)* (UN+Y0)
        FF(8) = UNDEMI* (UN-Y0*Y0)* (UN-X0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'FACE9') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 9

        FF(1) = AL31(X0)*AL31(Y0)
        FF(2) = AL33(X0)*AL31(Y0)
        FF(3) = AL33(X0)*AL33(Y0)
        FF(4) = AL31(X0)*AL33(Y0)
        FF(5) = AL32(X0)*AL31(Y0)
        FF(6) = AL33(X0)*AL32(Y0)
        FF(7) = AL32(X0)*AL33(Y0)
        FF(8) = AL31(X0)*AL32(Y0)
        FF(9) = AL32(X0)*AL32(Y0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'FACE3') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 3

        FF(1) = UN - X0 - Y0
        FF(2) = X0
        FF(3) = Y0

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'FACE6') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 6
        AL = UN - X0 - Y0

        FF(1) = -AL* (UN-DEUX*AL)
        FF(2) = -X0* (UN-DEUX*X0)
        FF(3) = -Y0* (UN-DEUX*Y0)
        FF(4) = QUATRE*X0*AL
        FF(5) = QUATRE*X0*Y0
        FF(6) = QUATRE*Y0*AL

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'TRIA3' .OR. ELREFE.EQ.'TRIA3H' .OR.
     &         ELREFE.EQ.'TRIA3L' .OR. ELREFE.EQ.'TRIL6' .OR.
     &         ELREFE.EQ.'TRIA6D' .OR. ELREFE.EQ.'TRIA6' .OR.
     &         ELREFE.EQ.'TRIA6H' .OR. ELREFE.EQ.'TRII3' .OR.
     &         ELREFE.EQ.'TRII6' .OR. ELREFE.EQ.'TRIA7' .OR.
     &         ELREFE.EQ.'TRIA3D') THEN

        X0 = X(1)
        Y0 = X(2)

        IF (NNO.EQ.3) THEN
          FF(1) = (UN+Y0)/DEUX
          FF(2) = - (X0+Y0)/DEUX
          FF(3) = (UN+X0)/DEUX

        ELSE IF (NNO.EQ.6) THEN
          FF(1) = Y0* (Y0+UN)/DEUX
          FF(2) = (X0+Y0)* (X0+Y0+UN)/DEUX
          FF(3) = X0* (X0+UN)/DEUX
          FF(4) = - (UN+Y0)* (X0+Y0)
          FF(5) = - (UN+X0)* (X0+Y0)
          FF(6) = (UN+X0)* (UN+Y0)

        ELSE IF (NNO.EQ.7) THEN
          FF(1) = Y0* (Y0+UN)/DEUX - 3.0D0* (Y0+UN)* (X0+UN)* (X0+Y0)/
     &            8.0D0
          FF(2) = (X0+Y0)* (X0+Y0+UN)/DEUX -
     &            3.0D0* (Y0+UN)* (X0+UN)* (X0+Y0)/8.0D0
          FF(3) = X0* (X0+UN)/DEUX - 3.0D0* (Y0+UN)* (X0+UN)* (X0+Y0)/
     &            8.0D0
          FF(4) = - (UN+Y0)* (X0+Y0) + 12.0D0* (Y0+UN)* (X0+UN)*
     &            (X0+Y0)/8.0D0
          FF(5) = - (UN+X0)* (X0+Y0) + 12.0D0* (Y0+UN)* (X0+UN)*
     &            (X0+Y0)/8.0D0
          FF(6) = (X0+UN)* (Y0+UN) + 12.0D0* (Y0+UN)* (X0+UN)* (X0+Y0)/
     &            8.0D0
          FF(7) = -27.0D0* (Y0+UN)* (X0+UN)* (X0+Y0)/8.0D0
        END IF

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'QUAD4' .OR. ELREFE.EQ.'QUAD4L' .OR.
     &         ELREFE.EQ.'QUAD8' .OR. ELREFE.EQ.'QUA8D' .OR.
     &         ELREFE.EQ.'QUAS8' .OR. ELREFE.EQ.'QUAI4' .OR.
     &         ELREFE.EQ.'QUAI8' .OR. ELREFE.EQ.'QUAD9' .OR.
     &         ELREFE.EQ.'QUAD4D') THEN

        X0 = X(1)
        Y0 = X(2)

        IF (NNO.EQ.4) THEN
          FF(1) = (UN+Y0)* (UN-X0)/QUATRE
          FF(2) = (UN-X0)* (UN-Y0)/QUATRE
          FF(3) = (UN+X0)* (UN-Y0)/QUATRE
          FF(4) = (UN+X0)* (UN+Y0)/QUATRE

        ELSE IF (NNO.EQ.8) THEN
          FF(1) = UNS4* (UN+Y0)* (UN-X0)* (Y0-X0-UN)
          FF(2) = UNS4* (UN-Y0)* (UN-X0)* (-Y0-X0-UN)
          FF(3) = UNS4* (UN-Y0)* (UN+X0)* (-Y0+X0-UN)
          FF(4) = UNS4* (UN+Y0)* (UN+X0)* (Y0+X0-UN)
          FF(5) = UNDEMI* (UN-X0)* (UN-Y0**2)
          FF(6) = UNDEMI* (UN-Y0)* (UN-X0**2)
          FF(7) = UNDEMI* (UN+X0)* (UN-Y0**2)
          FF(8) = UNDEMI* (UN+Y0)* (UN-X0**2)

        ELSE IF (NNO.EQ.9) THEN
          FF(1) = X0*Y0* (Y0+UN)* (X0-UN)/QUATRE
          FF(2) = X0*Y0* (Y0-UN)* (X0-UN)/QUATRE
          FF(3) = X0*Y0* (Y0-UN)* (X0+UN)/QUATRE
          FF(4) = X0*Y0* (Y0+UN)* (X0+UN)/QUATRE
          FF(5) = X0* (Y0-UN)* (X0-UN)* (Y0+UN)/ (-DEUX)
          FF(6) = Y0* (Y0-UN)* (X0+UN)* (X0-UN)/ (-DEUX)
          FF(7) = X0* (Y0-UN)* (X0+UN)* (Y0+UN)/ (-DEUX)
          FF(8) = Y0* (Y0+UN)* (X0-UN)* (X0+UN)/ (-DEUX)
          FF(9) = (Y0+UN)* (X0+UN)* (X0-UN)* (Y0-UN)
        END IF

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'SEG2' .OR. ELREFE.EQ.'CABPOU' .OR.
     &         ELREFE.EQ.'THCOSE2') THEN

        X0 = X(1)
        NNO = 2

        FF(1) = (UN-X0)/DEUX
        FF(2) = (UN+X0)/DEUX

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'SEG3' .OR. ELREFE.EQ.'THCOSE3' .OR.
     &         ELREFE.EQ.'MET3SEG3' .OR. ELREFE.EQ.'MET6SEG3') THEN

        X0 = X(1)
        NNO = 3

        FF(1) = - (UN-X0)*X0/DEUX
        FF(2) = (UN+X0)*X0/DEUX
        FF(3) = (UN+X0)* (UN-X0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'MET3SEG4') THEN
        NNO = 4
        X0 = X(1)

        X1 = -1.D0
        X2 = 1.D0
        X3 = -1.D0/3.D0
        X4 = 1.D0/3.D0
        D1 = (X1-X2)* (X1-X3)* (X1-X4)

        FF(1) = (X0-X2)* (X0-X3)* (X0-X4)/D1
        D2 = (X2-X1)* (X2-X3)* (X2-X4)

        FF(2) = (X0-X1)* (X0-X3)* (X0-X4)/D2
        D3 = (X3-X1)* (X3-X2)* (X3-X4)

        FF(3) = (X0-X1)* (X0-X2)* (X0-X4)/D3
        D4 = (X4-X1)* (X4-X2)* (X4-X3)

        FF(4) = (X0-X1)* (X0-X2)* (X0-X3)/D4

C     ------------------------------------------------------------------

      END IF

      IF (DIMF.LT.NNO) THEN
        CALL UTMESS('F','ELRFVF',' ERREUR PROGRAMMEUR'//
     &            'ECRASEMENT DE FF, DIMF EST INFERIEUR AU NB DE NOEUDS'
     &              )
      END IF

      END

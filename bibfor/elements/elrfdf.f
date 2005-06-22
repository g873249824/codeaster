      SUBROUTINE ELRFDF(ELREFZ,X,DIMD,DFF,NNO,NDIM)
      IMPLICIT NONE
      INTEGER DIMD,NNO,NDIM
      REAL*8 X(*),DFF(3,*)
      CHARACTER*(*) ELREFZ
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 23/06/2005   AUTEUR VABHHTS J.PELLET 
C RESPONSABLE VABHHTS J.PELLET
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
C        AU POINT DE COORDONNEES XI,YI,ZI

C ----------------------------------------------------------------------
C   IN   ELREFZ : NOM DE L'ELREFE (K8)
C        X      : POINT DE CALCUL DES F FORMES ET DERIVEES
C        DIMD   : DIMENSION DE DFF
C   OUT  DFF    : FONCTIONS DE FORMES EN XI,YI,ZI
C        NNO    : NOMBRE DE NOEUDS
C        NDIM : DIMENSION TOPOLOGIQUE DE L'ELREFE
C   -------------------------------------------------------------------
      CHARACTER*8 ELREFE
      INTEGER I,J
      REAL*8 ZERO,UNDEMI,UN,DEUX,TROIS,QUATRE,UNS4,UNS8
      REAL*8 X0,Y0,Z0,AL,X1,X2,X3,X4,D1,D2,D3,D4
      REAL*8 PFACE1,PFACE2,PFACE3,PFACE4,Z01,Z02,Z04
      REAL*8 PMILI1,PMILI2,PMILI3,PMILI4
      REAL*8 U,AL31,AL32,AL33,DAL31,DAL32,DAL33

C -----  FONCTIONS FORMULES
      AL31(U) = 0.5D0*U* (U-1.0D0)
      AL32(U) = - (U+1.0D0)* (U-1.0D0)
      AL33(U) = 0.5D0*U* (U+1.0D0)
      DAL31(U) = 0.5D0* (2.0D0*U-1.0D0)
      DAL32(U) = -2.0D0*U
      DAL33(U) = 0.5D0* (2.0D0*U+1.0D0)
C DEB ------------------------------------------------------------------
      ELREFE = ELREFZ

      ZERO = 0.0D0
      UNDEMI = 0.5D0
      UN = 1.0D0
      DEUX = 2.0D0
      TROIS = 3.0D0
      QUATRE = 4.0D0
      UNS4 = UN/QUATRE
      UNS8 = UN/8.0D0

C     ------------------------------------------------------------------
      IF (ELREFE.EQ.'HE8'.OR.ELREFE.EQ.'X20') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 8
        NDIM = 3

        DFF(1,1) = - (UN-Y0)* (UN-Z0)*UNS8
        DFF(2,1) = - (UN-X0)* (UN-Z0)*UNS8
        DFF(3,1) = - (UN-X0)* (UN-Y0)*UNS8

        DFF(1,2) = (UN-Y0)* (UN-Z0)*UNS8
        DFF(2,2) = - (UN+X0)* (UN-Z0)*UNS8
        DFF(3,2) = - (UN+X0)* (UN-Y0)*UNS8

        DFF(1,3) = (UN+Y0)* (UN-Z0)*UNS8
        DFF(2,3) = (UN+X0)* (UN-Z0)*UNS8
        DFF(3,3) = - (UN+X0)* (UN+Y0)*UNS8

        DFF(1,4) = - (UN+Y0)* (UN-Z0)*UNS8
        DFF(2,4) = (UN-X0)* (UN-Z0)*UNS8
        DFF(3,4) = - (UN-X0)* (UN+Y0)*UNS8

        DFF(1,5) = - (UN-Y0)* (UN+Z0)*UNS8
        DFF(2,5) = - (UN-X0)* (UN+Z0)*UNS8
        DFF(3,5) = (UN-X0)* (UN-Y0)*UNS8

        DFF(1,6) = (UN-Y0)* (UN+Z0)*UNS8
        DFF(2,6) = - (UN+X0)* (UN+Z0)*UNS8
        DFF(3,6) = (UN+X0)* (UN-Y0)*UNS8

        DFF(1,7) = (UN+Y0)* (UN+Z0)*UNS8
        DFF(2,7) = (UN+X0)* (UN+Z0)*UNS8
        DFF(3,7) = (UN+X0)* (UN+Y0)*UNS8

        DFF(1,8) = - (UN+Y0)* (UN+Z0)*UNS8
        DFF(2,8) = (UN-X0)* (UN+Z0)*UNS8
        DFF(3,8) = (UN-X0)* (UN+Y0)*UNS8

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'H20') THEN
        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 20
        NDIM = 3

        DFF(1,1) = - (UN-Y0)* (UN-Z0)* (-DEUX*X0-Y0-Z0-UN)*UNS8
        DFF(2,1) = - (UN-X0)* (UN-Z0)* (-X0-DEUX*Y0-Z0-UN)*UNS8
        DFF(3,1) = - (UN-X0)* (UN-Y0)* (-X0-Y0-DEUX*Z0-UN)*UNS8

        DFF(1,2) = (UN-Y0)* (UN-Z0)* (DEUX*X0-Y0-Z0-UN)*UNS8
        DFF(2,2) = - (UN+X0)* (UN-Z0)* (X0-DEUX*Y0-Z0-UN)*UNS8
        DFF(3,2) = - (UN+X0)* (UN-Y0)* (X0-Y0-DEUX*Z0-UN)*UNS8

        DFF(1,3) = (UN+Y0)* (UN-Z0)* (DEUX*X0+Y0-Z0-UN)*UNS8
        DFF(2,3) = (UN+X0)* (UN-Z0)* (X0+DEUX*Y0-Z0-UN)*UNS8
        DFF(3,3) = - (UN+X0)* (UN+Y0)* (X0+Y0-DEUX*Z0-UN)*UNS8

        DFF(1,4) = - (UN+Y0)* (UN-Z0)* (-DEUX*X0+Y0-Z0-UN)*UNS8
        DFF(2,4) = (UN-X0)* (UN-Z0)* (-X0+DEUX*Y0-Z0-UN)*UNS8
        DFF(3,4) = - (UN-X0)* (UN+Y0)* (-X0+Y0-DEUX*Z0-UN)*UNS8

        DFF(1,5) = - (UN-Y0)* (UN+Z0)* (-DEUX*X0-Y0+Z0-UN)*UNS8
        DFF(2,5) = - (UN-X0)* (UN+Z0)* (-X0-DEUX*Y0+Z0-UN)*UNS8
        DFF(3,5) = (UN-X0)* (UN-Y0)* (-X0-Y0+DEUX*Z0-UN)*UNS8

        DFF(1,6) = (UN-Y0)* (UN+Z0)* (DEUX*X0-Y0+Z0-UN)*UNS8
        DFF(2,6) = - (UN+X0)* (UN+Z0)* (X0-DEUX*Y0+Z0-UN)*UNS8
        DFF(3,6) = (UN+X0)* (UN-Y0)* (X0-Y0+DEUX*Z0-UN)*UNS8

        DFF(1,7) = (UN+Y0)* (UN+Z0)* (DEUX*X0+Y0+Z0-UN)*UNS8
        DFF(2,7) = (UN+X0)* (UN+Z0)* (X0+DEUX*Y0+Z0-UN)*UNS8
        DFF(3,7) = (UN+X0)* (UN+Y0)* (X0+Y0+DEUX*Z0-UN)*UNS8

        DFF(1,8) = - (UN+Y0)* (UN+Z0)* (-DEUX*X0+Y0+Z0-UN)*UNS8
        DFF(2,8) = (UN-X0)* (UN+Z0)* (-X0+DEUX*Y0+Z0-UN)*UNS8
        DFF(3,8) = (UN-X0)* (UN+Y0)* (-X0+Y0+DEUX*Z0-UN)*UNS8

        DFF(1,9) = -DEUX*X0* (UN-Y0)* (UN-Z0)*UNS4
        DFF(2,9) = - (UN-X0*X0)* (UN-Z0)*UNS4
        DFF(3,9) = - (UN-X0*X0)* (UN-Y0)*UNS4

        DFF(1,10) = (UN-Y0*Y0)* (UN-Z0)*UNS4
        DFF(2,10) = -DEUX*Y0* (UN+X0)* (UN-Z0)*UNS4
        DFF(3,10) = - (UN+X0)* (UN-Y0*Y0)*UNS4

        DFF(1,11) = -DEUX*X0* (UN+Y0)* (UN-Z0)*UNS4
        DFF(2,11) = (UN-X0*X0)* (UN-Z0)*UNS4
        DFF(3,11) = - (UN-X0*X0)* (UN+Y0)*UNS4

        DFF(1,12) = - (UN-Y0*Y0)* (UN-Z0)*UNS4
        DFF(2,12) = -DEUX*Y0* (UN-X0)* (UN-Z0)*UNS4
        DFF(3,12) = - (UN-X0)* (UN-Y0*Y0)*UNS4

        DFF(1,13) = - (UN-Z0*Z0)* (UN-Y0)*UNS4
        DFF(2,13) = - (UN-X0)* (UN-Z0*Z0)*UNS4
        DFF(3,13) = -DEUX*Z0* (UN-Y0)* (UN-X0)*UNS4

        DFF(1,14) = (UN-Z0*Z0)* (UN-Y0)*UNS4
        DFF(2,14) = - (UN+X0)* (UN-Z0*Z0)*UNS4
        DFF(3,14) = -DEUX*Z0* (UN-Y0)* (UN+X0)*UNS4

        DFF(1,15) = (UN-Z0*Z0)* (UN+Y0)*UNS4
        DFF(2,15) = (UN+X0)* (UN-Z0*Z0)*UNS4
        DFF(3,15) = -DEUX*Z0* (UN+Y0)* (UN+X0)*UNS4

        DFF(1,16) = - (UN-Z0*Z0)* (UN+Y0)*UNS4
        DFF(2,16) = (UN-X0)* (UN-Z0*Z0)*UNS4
        DFF(3,16) = -DEUX*Z0* (UN+Y0)* (UN-X0)*UNS4

        DFF(1,17) = -DEUX*X0* (UN-Y0)* (UN+Z0)*UNS4
        DFF(2,17) = - (UN-X0*X0)* (UN+Z0)*UNS4
        DFF(3,17) = (UN-X0*X0)* (UN-Y0)*UNS4

        DFF(1,18) = (UN-Y0*Y0)* (UN+Z0)*UNS4
        DFF(2,18) = -DEUX*Y0* (UN+X0)* (UN+Z0)*UNS4
        DFF(3,18) = (UN+X0)* (UN-Y0*Y0)*UNS4

        DFF(1,19) = -DEUX*X0* (UN+Y0)* (UN+Z0)*UNS4
        DFF(2,19) = (UN-X0*X0)* (UN+Z0)*UNS4
        DFF(3,19) = (UN-X0*X0)* (UN+Y0)*UNS4

        DFF(1,20) = - (UN-Y0*Y0)* (UN+Z0)*UNS4
        DFF(2,20) = -DEUX*Y0* (UN-X0)* (UN+Z0)*UNS4
        DFF(3,20) = (UN-X0)* (UN-Y0*Y0)*UNS4

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'H27') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 27
        NDIM = 3

        DFF(1,1) = DAL31(X0)*AL31(Y0)*AL31(Z0)
        DFF(2,1) = AL31(X0)*DAL31(Y0)*AL31(Z0)
        DFF(3,1) = AL31(X0)*AL31(Y0)*DAL31(Z0)
        DFF(1,2) = DAL33(X0)*AL31(Y0)*AL31(Z0)
        DFF(2,2) = AL33(X0)*DAL31(Y0)*AL31(Z0)
        DFF(3,2) = AL33(X0)*AL31(Y0)*DAL31(Z0)
        DFF(1,3) = DAL33(X0)*AL33(Y0)*AL31(Z0)
        DFF(2,3) = AL33(X0)*DAL33(Y0)*AL31(Z0)
        DFF(3,3) = AL33(X0)*AL33(Y0)*DAL31(Z0)
        DFF(1,4) = DAL31(X0)*AL33(Y0)*AL31(Z0)
        DFF(2,4) = AL31(X0)*DAL33(Y0)*AL31(Z0)
        DFF(3,4) = AL31(X0)*AL33(Y0)*DAL31(Z0)
        DFF(1,5) = DAL31(X0)*AL31(Y0)*AL33(Z0)
        DFF(2,5) = AL31(X0)*DAL31(Y0)*AL33(Z0)
        DFF(3,5) = AL31(X0)*AL31(Y0)*DAL33(Z0)
        DFF(1,6) = DAL33(X0)*AL31(Y0)*AL33(Z0)
        DFF(2,6) = AL33(X0)*DAL31(Y0)*AL33(Z0)
        DFF(3,6) = AL33(X0)*AL31(Y0)*DAL33(Z0)
        DFF(1,7) = DAL33(X0)*AL33(Y0)*AL33(Z0)
        DFF(2,7) = AL33(X0)*DAL33(Y0)*AL33(Z0)
        DFF(3,7) = AL33(X0)*AL33(Y0)*DAL33(Z0)
        DFF(1,8) = DAL31(X0)*AL33(Y0)*AL33(Z0)
        DFF(2,8) = AL31(X0)*DAL33(Y0)*AL33(Z0)
        DFF(3,8) = AL31(X0)*AL33(Y0)*DAL33(Z0)
        DFF(1,9) = DAL32(X0)*AL31(Y0)*AL31(Z0)
        DFF(2,9) = AL32(X0)*DAL31(Y0)*AL31(Z0)
        DFF(3,9) = AL32(X0)*AL31(Y0)*DAL31(Z0)
        DFF(1,10) = DAL33(X0)*AL32(Y0)*AL31(Z0)
        DFF(2,10) = AL33(X0)*DAL32(Y0)*AL31(Z0)
        DFF(3,10) = AL33(X0)*AL32(Y0)*DAL31(Z0)
        DFF(1,11) = DAL32(X0)*AL33(Y0)*AL31(Z0)
        DFF(2,11) = AL32(X0)*DAL33(Y0)*AL31(Z0)
        DFF(3,11) = AL32(X0)*AL33(Y0)*DAL31(Z0)
        DFF(1,12) = DAL31(X0)*AL32(Y0)*AL31(Z0)
        DFF(2,12) = AL31(X0)*DAL32(Y0)*AL31(Z0)
        DFF(3,12) = AL31(X0)*AL32(Y0)*DAL31(Z0)
        DFF(1,13) = DAL31(X0)*AL31(Y0)*AL32(Z0)
        DFF(2,13) = AL31(X0)*DAL31(Y0)*AL32(Z0)
        DFF(3,13) = AL31(X0)*AL31(Y0)*DAL32(Z0)
        DFF(1,14) = DAL33(X0)*AL31(Y0)*AL32(Z0)
        DFF(2,14) = AL33(X0)*DAL31(Y0)*AL32(Z0)
        DFF(3,14) = AL33(X0)*AL31(Y0)*DAL32(Z0)
        DFF(1,15) = DAL33(X0)*AL33(Y0)*AL32(Z0)
        DFF(2,15) = AL33(X0)*DAL33(Y0)*AL32(Z0)
        DFF(3,15) = AL33(X0)*AL33(Y0)*DAL32(Z0)
        DFF(1,16) = DAL31(X0)*AL33(Y0)*AL32(Z0)
        DFF(2,16) = AL31(X0)*DAL33(Y0)*AL32(Z0)
        DFF(3,16) = AL31(X0)*AL33(Y0)*DAL32(Z0)
        DFF(1,17) = DAL32(X0)*AL31(Y0)*AL33(Z0)
        DFF(2,17) = AL32(X0)*DAL31(Y0)*AL33(Z0)
        DFF(3,17) = AL32(X0)*AL31(Y0)*DAL33(Z0)
        DFF(1,18) = DAL33(X0)*AL32(Y0)*AL33(Z0)
        DFF(2,18) = AL33(X0)*DAL32(Y0)*AL33(Z0)
        DFF(3,18) = AL33(X0)*AL32(Y0)*DAL33(Z0)
        DFF(1,19) = DAL32(X0)*AL33(Y0)*AL33(Z0)
        DFF(2,19) = AL32(X0)*DAL33(Y0)*AL33(Z0)
        DFF(3,19) = AL32(X0)*AL33(Y0)*DAL33(Z0)
        DFF(1,20) = DAL31(X0)*AL32(Y0)*AL33(Z0)
        DFF(2,20) = AL31(X0)*DAL32(Y0)*AL33(Z0)
        DFF(3,20) = AL31(X0)*AL32(Y0)*DAL33(Z0)
        DFF(1,21) = DAL32(X0)*AL32(Y0)*AL31(Z0)
        DFF(2,21) = AL32(X0)*DAL32(Y0)*AL31(Z0)
        DFF(3,21) = AL32(X0)*AL32(Y0)*DAL31(Z0)
        DFF(1,22) = DAL32(X0)*AL31(Y0)*AL32(Z0)
        DFF(2,22) = AL32(X0)*DAL31(Y0)*AL32(Z0)
        DFF(3,22) = AL32(X0)*AL31(Y0)*DAL32(Z0)
        DFF(1,23) = DAL33(X0)*AL32(Y0)*AL32(Z0)
        DFF(2,23) = AL33(X0)*DAL32(Y0)*AL32(Z0)
        DFF(3,23) = AL33(X0)*AL32(Y0)*DAL32(Z0)
        DFF(1,24) = DAL32(X0)*AL33(Y0)*AL32(Z0)
        DFF(2,24) = AL32(X0)*DAL33(Y0)*AL32(Z0)
        DFF(3,24) = AL32(X0)*AL33(Y0)*DAL32(Z0)
        DFF(1,25) = DAL31(X0)*AL32(Y0)*AL32(Z0)
        DFF(2,25) = AL31(X0)*DAL32(Y0)*AL32(Z0)
        DFF(3,25) = AL31(X0)*AL32(Y0)*DAL32(Z0)
        DFF(1,26) = DAL32(X0)*AL32(Y0)*AL33(Z0)
        DFF(2,26) = AL32(X0)*DAL32(Y0)*AL33(Z0)
        DFF(3,26) = AL32(X0)*AL32(Y0)*DAL33(Z0)
        DFF(1,27) = DAL32(X0)*AL32(Y0)*AL32(Z0)
        DFF(2,27) = AL32(X0)*DAL32(Y0)*AL32(Z0)
        DFF(3,27) = AL32(X0)*AL32(Y0)*DAL32(Z0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'PE6'.OR.ELREFE.EQ.'X15') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 6
        NDIM = 3
        AL = (UN-Y0-Z0)

        DFF(1,1) = -Y0*UNDEMI
        DFF(2,1) = (UN-X0)*UNDEMI
        DFF(3,1) = ZERO

        DFF(1,2) = -Z0*UNDEMI
        DFF(2,2) = ZERO
        DFF(3,2) = (UN-X0)*UNDEMI

        DFF(1,3) = -AL*UNDEMI
        DFF(2,3) = - (UN-X0)*UNDEMI
        DFF(3,3) = - (UN-X0)*UNDEMI

        DFF(1,4) = Y0*UNDEMI
        DFF(2,4) = (UN+X0)*UNDEMI
        DFF(3,4) = ZERO

        DFF(1,5) = Z0*UNDEMI
        DFF(2,5) = ZERO
        DFF(3,5) = (UN+X0)*UNDEMI

        DFF(1,6) = AL*UNDEMI
        DFF(2,6) = - (UN+X0)*UNDEMI
        DFF(3,6) = - (UN+X0)*UNDEMI

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'P15') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 15
        NDIM = 3
        AL = UN - Y0 - Z0

        DFF(1,1) = (-Y0* (DEUX*Y0-DEUX-X0)-Y0* (UN-X0))/DEUX
        DFF(2,1) = (UN-X0)* (QUATRE*Y0-DEUX-X0)/DEUX
        DFF(3,1) = ZERO

        DFF(1,2) = -Z0* (DEUX*Z0-UN-DEUX*X0)/DEUX
        DFF(2,2) = ZERO
        DFF(3,2) = (UN-X0)* (QUATRE*Z0-DEUX-X0)/DEUX

        DFF(1,3) = AL* (DEUX*X0+DEUX*Y0+DEUX*Z0-UN)/DEUX
        DFF(2,3) = (X0-UN)* (-X0-QUATRE*Y0-QUATRE*Z0+DEUX)/DEUX
        DFF(3,3) = (X0-UN)* (-X0-QUATRE*Y0-QUATRE*Z0+DEUX)/DEUX

        DFF(1,4) = Y0* (DEUX*Y0-UN+DEUX*X0)/DEUX
        DFF(2,4) = (UN+X0)* (QUATRE*Y0-DEUX+X0)/DEUX
        DFF(3,4) = ZERO

        DFF(1,5) = Z0* (DEUX*Z0-UN+DEUX*X0)/DEUX
        DFF(2,5) = ZERO
        DFF(3,5) = (UN+X0)* (QUATRE*Z0-DEUX+X0)/DEUX

        DFF(1,6) = AL* (DEUX*X0-DEUX*Y0-DEUX*Z0+UN)/DEUX
        DFF(2,6) = (X0+UN)* (-X0+QUATRE*Y0+QUATRE*Z0-DEUX)/DEUX
        DFF(3,6) = (X0+UN)* (-X0+QUATRE*Y0+QUATRE*Z0-DEUX)/DEUX

        DFF(1,7) = -DEUX*Y0*Z0
        DFF(2,7) = DEUX*Z0* (UN-X0)
        DFF(3,7) = DEUX*Y0* (UN-X0)

        DFF(1,8) = -DEUX*AL*Z0
        DFF(2,8) = -DEUX*Z0* (UN-X0)
        DFF(3,8) = (DEUX*AL-DEUX*Z0)* (UN-X0)

        DFF(1,9) = -DEUX*Y0*AL
        DFF(2,9) = (DEUX*AL-DEUX*Y0)* (UN-X0)
        DFF(3,9) = -DEUX*Y0* (UN-X0)

        DFF(1,10) = -DEUX*Y0*X0
        DFF(2,10) = (UN-X0*X0)
        DFF(3,10) = ZERO

        DFF(1,11) = -DEUX*Z0*X0
        DFF(2,11) = ZERO
        DFF(3,11) = (UN-X0*X0)

        DFF(1,12) = -DEUX*AL*X0
        DFF(2,12) = - (UN-X0*X0)
        DFF(3,12) = - (UN-X0*X0)

        DFF(1,13) = DEUX*Y0*Z0
        DFF(2,13) = DEUX*Z0* (UN+X0)
        DFF(3,13) = DEUX*Y0* (UN+X0)

        DFF(1,14) = DEUX*AL*Z0
        DFF(2,14) = -DEUX*Z0* (UN+X0)
        DFF(3,14) = (DEUX*AL-DEUX*Z0)* (UN+X0)

        DFF(1,15) = DEUX*Y0*AL
        DFF(2,15) = (DEUX*AL-DEUX*Y0)* (UN+X0)
        DFF(3,15) = -DEUX*Y0* (UN+X0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'TE4'.OR.ELREFE.EQ.'X10') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 4
        NDIM = 3

        DFF(1,1) = ZERO
        DFF(2,1) = UN
        DFF(3,1) = ZERO
        DFF(1,2) = ZERO
        DFF(2,2) = ZERO
        DFF(3,2) = UN
        DFF(1,3) = -UN
        DFF(2,3) = -UN
        DFF(3,3) = -UN
        DFF(1,4) = UN
        DFF(2,4) = ZERO
        DFF(3,4) = ZERO

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'T10') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 10
        NDIM = 3
        AL = UN - X0 - Y0 - Z0

        DFF(1,1) = ZERO
        DFF(2,1) = QUATRE*Y0 - UN
        DFF(3,1) = ZERO
        DFF(1,2) = ZERO
        DFF(2,2) = ZERO
        DFF(3,2) = QUATRE*Z0 - UN
        DFF(1,3) = UN - QUATRE*AL
        DFF(2,3) = UN - QUATRE*AL
        DFF(3,3) = UN - QUATRE*AL
        DFF(1,4) = QUATRE*X0 - UN
        DFF(2,4) = ZERO
        DFF(3,4) = ZERO
        DFF(1,5) = ZERO
        DFF(2,5) = QUATRE*Z0
        DFF(3,5) = QUATRE*Y0
        DFF(1,6) = -QUATRE*Z0
        DFF(2,6) = -QUATRE*Z0
        DFF(3,6) = QUATRE* (AL-Z0)
        DFF(1,7) = -QUATRE*Y0
        DFF(2,7) = QUATRE* (AL-Y0)
        DFF(3,7) = -QUATRE*Y0
        DFF(1,8) = QUATRE*Y0
        DFF(2,8) = QUATRE*X0
        DFF(3,8) = ZERO
        DFF(1,9) = QUATRE*Z0
        DFF(2,9) = ZERO
        DFF(3,9) = QUATRE*X0
        DFF(1,10) = QUATRE* (AL-X0)
        DFF(2,10) = -QUATRE*X0
        DFF(3,10) = -QUATRE*X0

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'PY5') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 5
        NDIM = 3
        Z01 = UN - Z0
        Z04 = (UN-Z0)*QUATRE

        PFACE1 = X0 + Y0 + Z0 - UN
        PFACE2 = -X0 + Y0 + Z0 - UN
        PFACE3 = -X0 - Y0 + Z0 - UN
        PFACE4 = X0 - Y0 + Z0 - UN

        IF (ABS(Z0-UN).LT.1.0D-6) THEN
          DO 20 I = 1,5
            DO 10 J = 1,2
              DFF(J,I) = ZERO
   10       CONTINUE
   20     CONTINUE

          DFF(1,1) = UNDEMI
          DFF(1,3) = -UNDEMI

          DFF(2,2) = UNDEMI
          DFF(2,4) = -UNDEMI

          DFF(3,1) = -UNDEMI
          DFF(3,2) = -UNDEMI
          DFF(3,3) = -UNDEMI
          DFF(3,4) = -UNDEMI
          DFF(3,5) = UN

        ELSE

          DFF(1,1) = (-PFACE2-PFACE3)/Z04
          DFF(1,2) = (PFACE3-PFACE4)/Z04
          DFF(1,3) = (PFACE1+PFACE4)/Z04
          DFF(1,4) = (PFACE2-PFACE1)/Z04
          DFF(1,5) = ZERO

          DFF(2,1) = (PFACE3-PFACE2)/Z04
          DFF(2,2) = (-PFACE3-PFACE4)/Z04
          DFF(2,3) = (PFACE4-PFACE1)/Z04
          DFF(2,4) = (PFACE1+PFACE2)/Z04
          DFF(2,5) = ZERO

          DFF(3,1) = (PFACE2+PFACE3+PFACE2*PFACE3/Z01)/Z04
          DFF(3,2) = (PFACE3+PFACE4+PFACE3*PFACE4/Z01)/Z04
          DFF(3,3) = (PFACE4+PFACE1+PFACE4*PFACE1/Z01)/Z04
          DFF(3,4) = (PFACE1+PFACE2+PFACE1*PFACE2/Z01)/Z04
          DFF(3,5) = UN
        END IF

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'P13') THEN

        X0 = X(1)
        Y0 = X(2)
        Z0 = X(3)
        NNO = 13
        NDIM = 3
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
          DO 40 I = 1,13
            DO 30 J = 1,2
              DFF(J,I) = ZERO
   30       CONTINUE
   40     CONTINUE

          DFF(1,1) = -UNDEMI
          DFF(1,3) = UNDEMI
          DFF(1,9) = DEUX
          DFF(1,11) = -DEUX

          DFF(2,2) = -UNDEMI
          DFF(2,4) = UNDEMI
          DFF(2,10) = DEUX
          DFF(2,12) = -DEUX

          DFF(3,1) = UN/QUATRE
          DFF(3,2) = UN/QUATRE
          DFF(3,3) = UN/QUATRE
          DFF(3,4) = UN/QUATRE
          DFF(3,6) = ZERO
          DFF(3,7) = ZERO
          DFF(3,8) = ZERO
          DFF(3,9) = ZERO

          DO 50 I = 10,13
            DFF(3,I) = -UN
   50     CONTINUE

          DFF(3,5) = TROIS

        ELSE

          DFF(1,1) = (PFACE2*PFACE3- (PFACE2+PFACE3)*PMILI1)/Z02
          DFF(1,2) = (PFACE3-PFACE4)*PMILI2/Z02
          DFF(1,3) = ((PFACE1+PFACE4)*PMILI3-PFACE4*PFACE1)/Z02
          DFF(1,4) = (PFACE2-PFACE1)*PMILI4/Z02
          DFF(1,5) = ZERO
          DFF(1,6) = (PFACE3*PFACE4+PFACE2*PFACE4-PFACE2*PFACE3)/Z02
          DFF(1,7) = (PFACE4*PFACE1-PFACE3*PFACE1-PFACE3*PFACE4)/Z02
          DFF(1,8) = (PFACE4*PFACE1-PFACE1*PFACE2-PFACE4*PFACE2)/Z02
          DFF(1,9) = (PFACE1*PFACE3+PFACE1*PFACE2-PFACE3*PFACE2)/Z02
          DFF(1,10) = (-PFACE3-PFACE2)*Z0/Z01
          DFF(1,11) = (PFACE3-PFACE4)*Z0/Z01
          DFF(1,12) = (PFACE1+PFACE4)*Z0/Z01
          DFF(1,13) = (PFACE2-PFACE1)*Z0/Z01

          DFF(2,1) = (PFACE3-PFACE2)*PMILI1/Z02
          DFF(2,2) = (PFACE3*PFACE4- (PFACE3+PFACE4)*PMILI2)/Z02
          DFF(2,3) = (PFACE4-PFACE1)*PMILI3/Z02
          DFF(2,4) = ((PFACE2+PFACE1)*PMILI4-PFACE1*PFACE2)/Z02
          DFF(2,5) = ZERO
          DFF(2,6) = (PFACE2*PFACE4+PFACE2*PFACE3-PFACE3*PFACE4)/Z02
          DFF(2,7) = (PFACE4*PFACE1+PFACE3*PFACE1-PFACE3*PFACE4)/Z02
          DFF(2,8) = (PFACE1*PFACE2-PFACE4*PFACE2-PFACE4*PFACE1)/Z02
          DFF(2,9) = (PFACE1*PFACE2-PFACE2*PFACE3-PFACE1*PFACE3)/Z02
          DFF(2,10) = (PFACE3-PFACE2)*Z0/Z01
          DFF(2,11) = (-PFACE4-PFACE3)*Z0/Z01
          DFF(2,12) = (PFACE4-PFACE1)*Z0/Z01
          DFF(2,13) = (PFACE2+PFACE1)*Z0/Z01

          DFF(3,1) = (PFACE2+PFACE3+PFACE2*PFACE3/Z01)*PMILI1/Z02
          DFF(3,2) = (PFACE3+PFACE4+PFACE3*PFACE4/Z01)*PMILI2/Z02
          DFF(3,3) = (PFACE1+PFACE4+PFACE1*PFACE4/Z01)*PMILI3/Z02
          DFF(3,4) = (PFACE2+PFACE1+PFACE1*PFACE2/Z01)*PMILI4/Z02
          DFF(3,5) = QUATRE*Z0 - UN
          DFF(3,6) = - (PFACE3*PFACE4+PFACE2*PFACE4+PFACE2*PFACE3+
     &               PFACE2*PFACE3*PFACE4/Z01)/Z02
          DFF(3,7) = - (PFACE4*PFACE1+PFACE3*PFACE1+PFACE3*PFACE4+
     &               PFACE3*PFACE4*PFACE1/Z01)/Z02
          DFF(3,8) = - (PFACE1*PFACE2+PFACE4*PFACE2+PFACE4*PFACE1+
     &               PFACE4*PFACE1*PFACE2/Z01)/Z02
          DFF(3,9) = - (PFACE2*PFACE3+PFACE1*PFACE3+PFACE1*PFACE2+
     &               PFACE1*PFACE2*PFACE3/Z01)/Z02
          DFF(3,10) = PFACE2*PFACE3/Z01/Z01 + (PFACE3+PFACE2)*Z0/Z01
          DFF(3,11) = PFACE3*PFACE4/Z01/Z01 + (PFACE4+PFACE3)*Z0/Z01
          DFF(3,12) = PFACE4*PFACE1/Z01/Z01 + (PFACE1+PFACE4)*Z0/Z01
          DFF(3,13) = PFACE1*PFACE2/Z01/Z01 + (PFACE1+PFACE2)*Z0/Z01
        END IF

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'TR3') THEN

        NNO = 3
        NDIM = 2

        DFF(1,1) = -UN
        DFF(1,2) = +UN
        DFF(1,3) = ZERO
        DFF(2,1) = -UN
        DFF(2,2) = ZERO
        DFF(2,3) = +UN

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'TR6') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 6
        NDIM = 2
        AL = UN - X0 - Y0

        DFF(1,1) = UN - QUATRE*AL
        DFF(1,2) = -UN + QUATRE*X0
        DFF(1,3) = ZERO
        DFF(1,4) = QUATRE* (AL-X0)
        DFF(1,5) = QUATRE*Y0
        DFF(1,6) = -QUATRE*Y0
        DFF(2,1) = UN - QUATRE*AL
        DFF(2,2) = ZERO
        DFF(2,3) = -UN + QUATRE*Y0
        DFF(2,4) = -QUATRE*X0
        DFF(2,5) = QUATRE*X0
        DFF(2,6) = QUATRE* (AL-Y0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'TR7') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 7
        NDIM = 2

        DFF(1,1) = -TROIS + 4.0D0*X0 + 7.0D0*Y0 - 6.0D0*X0*Y0 
     &                    - 3.0D0*Y0*Y0
        DFF(1,2) = -UN + 4.0D0*X0 + 3.0D0*Y0 - 6.0D0*X0*Y0
     &                    - 3.0D0*Y0*Y0
        DFF(1,3) = 3.0D0*Y0*( UN - 2.0D0*X0 - Y0 )
        DFF(1,4) = 4.0D0*( UN - 2.0D0*X0 - 4.0D0*Y0 + 6.0D0*X0*Y0
     &                        + 3.0D0*Y0*Y0 )
        DFF(1,5) = 4.0D0*Y0*( -2.0D0 + 6.0D0*X0 + 3.0D0*Y0 )
        DFF(1,6) = 4.0D0*Y0*( -4.0D0 + 6.0D0*X0 + 3.0D0*Y0 )
        DFF(1,7) = 27.D0*Y0*( UN - 2.0D0*X0 - Y0 )

        DFF(2,1) = -TROIS + 4.0D0*Y0 + 7.0D0*X0 - 6.0D0*X0*Y0 
     &                    - 3.0D0*X0*X0
        DFF(2,2) = 3.0D0*X0*( UN - 2.0D0*Y0 - X0 )
        DFF(2,3) = -UN + 4.0D0*Y0 + 3.0D0*X0 - 6.0D0*X0*Y0
     &                    - 3.0D0*X0*X0
        DFF(2,4) = 4.0D0*X0*( -4.0D0 + 6.0D0*Y0 + 3.0D0*X0 )
        DFF(2,5) = 4.0D0*X0*( -2.0D0 + 6.0D0*Y0 + 3.0D0*X0 )
        DFF(2,6) = 4.0D0*( UN - 2.0D0*Y0 - 4.0D0*X0 + 6.0D0*X0*Y0
     &                        + 3.0D0*X0*X0 )
        DFF(2,7) = 27.D0*X0*( UN - 2.0D0*Y0 - X0 )

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'QU4') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 4
        NDIM = 2

        DFF(1,1) = -(UN-Y0)*UNS4
        DFF(1,2) =  (UN-Y0)*UNS4
        DFF(1,3) =  (UN+Y0)*UNS4
        DFF(1,4) = -(UN+Y0)*UNS4
        DFF(2,1) = -(UN-X0)*UNS4
        DFF(2,2) = -(UN+X0)*UNS4
        DFF(2,3) =  (UN+X0)*UNS4
        DFF(2,4) =  (UN-X0)*UNS4

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'QU8') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 8
        NDIM = 2

        DFF(1,1) = -UNS4* (UN-Y0)* (-DEUX*X0-Y0)
        DFF(2,1) = -UNS4* (UN-X0)* (-DEUX*Y0-X0)

        DFF(1,2) =  UNS4* (UN-Y0)* ( DEUX*X0-Y0)
        DFF(2,2) = -UNS4* (UN+X0)* (-DEUX*Y0+X0)

        DFF(1,3) = UNS4* (UN+Y0)* (DEUX*X0+Y0)
        DFF(2,3) = UNS4* (UN+X0)* (DEUX*Y0+X0)

        DFF(1,4) = -UNS4* (UN+Y0)* (-DEUX*X0+Y0)
        DFF(2,4) =  UNS4* (UN-X0)* ( DEUX*Y0-X0)

        DFF(1,5) = -DEUX*X0* (UN-Y0)*UNDEMI
        DFF(2,5) = - (UN-X0*X0)*UNDEMI

        DFF(1,6) = (UN-Y0*Y0)*UNDEMI
        DFF(2,6) = -DEUX*Y0* (UN+X0)*UNDEMI

        DFF(1,7) = -DEUX*X0* (UN+Y0)*UNDEMI
        DFF(2,7) = (UN-X0*X0)*UNDEMI

        DFF(1,8) = - (UN-Y0*Y0)*UNDEMI
        DFF(2,8) = -DEUX*Y0* (UN-X0)*UNDEMI

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'QU9') THEN

        X0 = X(1)
        Y0 = X(2)
        NNO = 9
        NDIM = 2

        DFF(1,1) = DAL31(X0)*AL31(Y0)
        DFF(2,1) = AL31(X0)*DAL31(Y0)
        DFF(1,2) = DAL33(X0)*AL31(Y0)
        DFF(2,2) = AL33(X0)*DAL31(Y0)
        DFF(1,3) = DAL33(X0)*AL33(Y0)
        DFF(2,3) = AL33(X0)*DAL33(Y0)
        DFF(1,4) = DAL31(X0)*AL33(Y0)
        DFF(2,4) = AL31(X0)*DAL33(Y0)
        DFF(1,5) = DAL32(X0)*AL31(Y0)
        DFF(2,5) = AL32(X0)*DAL31(Y0)
        DFF(1,6) = DAL33(X0)*AL32(Y0)
        DFF(2,6) = AL33(X0)*DAL32(Y0)
        DFF(1,7) = DAL32(X0)*AL33(Y0)
        DFF(2,7) = AL32(X0)*DAL33(Y0)
        DFF(1,8) = DAL31(X0)*AL32(Y0)
        DFF(2,8) = AL31(X0)*DAL32(Y0)
        DFF(1,9) = DAL32(X0)*AL32(Y0)
        DFF(2,9) = AL32(X0)*DAL32(Y0)

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'PO1') THEN
        NNO = 1
        NDIM = 0

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'SE2') THEN
        NNO = 2
        NDIM = 1

        DFF(1,1) = -UNDEMI
        DFF(1,2) = UNDEMI

C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'SE3') THEN
        X0 = X(1)
        NNO = 3
        NDIM = 1

        DFF(1,1) = X0 - UNDEMI
        DFF(1,2) = X0 + UNDEMI
        DFF(1,3) = -DEUX*X0
C     ------------------------------------------------------------------
      ELSE IF (ELREFE.EQ.'SE4') THEN
        X0 = X(1)
        NNO = 4
        NDIM = 1

        X1 = -1.D0
        X2 = 1.D0
        X3 = -1.D0/3.D0
        X4 = 1.D0/3.D0
        D1 = (X1-X2)* (X1-X3)* (X1-X4)
        DFF(1,1) = ((X0-X2)* (X0-X3)+ (X0-X2)* (X0-X4)+
     &             (X0-X3)* (X0-X4))/D1
        D2 = (X2-X1)* (X2-X3)* (X2-X4)
        DFF(1,2) = ((X0-X1)* (X0-X3)+ (X0-X1)* (X0-X4)+
     &             (X0-X3)* (X0-X4))/D2
        D3 = (X3-X1)* (X3-X2)* (X3-X4)
        DFF(1,3) = ((X0-X1)* (X0-X2)+ (X0-X1)* (X0-X4)+
     &             (X0-X2)* (X0-X4))/D3
        D4 = (X4-X1)* (X4-X2)* (X4-X3)
        DFF(1,4) = ((X0-X1)* (X0-X2)+ (X0-X1)* (X0-X3)+
     &             (X0-X2)* (X0-X3))/D4

C     ------------------------------------------------------------------
      ELSE
        CALL ASSERT(.FALSE.)
      END IF


C     ------------------------------------------------------------------

      IF (DIMD.LT. (NNO*NDIM)) THEN
        CALL UTMESS('F','ELRFDF',' ERREUR PROGRAMMEUR '//
     &          'ECRASEMENT DE DFF, DIMF EST INFERIEUR AU NB DE NOEUDS '
     &              //'* NB CMPS')
      END IF

      END

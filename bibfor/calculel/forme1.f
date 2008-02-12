      SUBROUTINE FORME1 ( M, TYPEMA, W, NNO, NDIM )
      IMPLICIT NONE
      CHARACTER*8  TYPEMA
      CHARACTER*24 VALK
      REAL*8       M(*), W(*)
      INTEGER      NNO , NDIM
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/02/2008   AUTEUR ABBAS M.ABBAS 
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
C TOLE CRP_20
C A_UTIL
C ----------------------------------------------------------------------
C         CALCUL DES DERIVEES PREMIERES DES FONCTIONS DE FORME
C ----------------------------------------------------------------------
C VARIABLES D'ENTREE
C REAL*8      M(*)        : POINT SUR MAILLE DE REFERENCE (X,[Y],[Z])
C CHARACTER*8 TYPEMA      : TYPE DE LA MAILLE
C
C VARIABLES DE SORTIE
C REAL*8      W(DIME,NNO) : DERIVEES 1ERES DES FONCTIONS DE FORME EN M
C                           (DW1/DX, [DW1/DY], [DW1/DZ], DW2/DX ...)
C INTEGER     NNO         : NOMBRE DE NOEUDS
C INTEGER     NDIM        : DIMENSION DE LA MAILLE
C ---------------------------------------------------------------------
      INTEGER  IN
      REAL*8   DFF(3,27)
C
      IF (TYPEMA(1:4).EQ.'SEG2') THEN
         CALL ELRFDF ( 'SE2', M, 2, W, NNO, NDIM )

      ELSEIF (TYPEMA(1:4).EQ.'SEG3') THEN
         CALL ELRFDF ( 'SE3', M, 3, W, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'TRIA3') THEN
         CALL ELRFDF ( 'TR3', M, 6, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'TRIA6') THEN
         CALL ELRFDF ( 'TR6', M, 12, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'TRIA7') THEN
         CALL ELRFDF ( 'TR7', M, 14, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'TRIW6') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'TW6', M, 12, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'TRIH3') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'TH3', M, 6, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'QUAD4') THEN
         CALL ELRFDF ( 'QU4', M, 8, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'QUAD6') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'QU6', M, 12, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'QUAD8') THEN
         CALL ELRFDF ( 'QU8', M, 16, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'QUAD9') THEN
         CALL ELRFDF ( 'QU9', M, 18, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'QUAH4') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'QH4', M, 8, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:6).EQ.'TETRA4') THEN
         CALL ELRFDF ( 'TE4', M, 12, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:7).EQ.'TETRA10') THEN
         CALL ELRFDF ( 'T10', M, 30, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:6).EQ.'PENTA6') THEN
         CALL ELRFDF ( 'PE6', M, 18, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:7).EQ.'PENTA12') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'P12', M, 36, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:7).EQ.'PENTA14') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'P14', M, 42, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:7).EQ.'PENTA15') THEN
         CALL ELRFDF ( 'P15', M, 45, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:6).EQ.'PENTH6') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'PH6', M, 18, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:5).EQ.'HEXA8') THEN
         CALL ELRFDF ( 'HE8', M, 24, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:6).EQ.'HEXA16') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'H16', M, 48, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:6).EQ.'HEXA18') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'H18', M, 54, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:6).EQ.'HEXA20') THEN
         CALL ELRFDF ( 'H20', M, 60, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:6).EQ.'HEXA27') THEN
         CALL ELRFDF ( 'H27', M, 81, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:6).EQ.'HEXAH8') THEN
         VALK = TYPEMA
         CALL U2MESG('F', 'CALCULEL5_87',1,VALK,0,0,0,0.D0)
         CALL ELRFDF ( 'HH8', M, 24, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:6).EQ.'PYRAM5') THEN
         CALL ELRFDF ( 'PY5', M, 15, DFF, NNO, NDIM )

      ELSEIF (TYPEMA(1:7).EQ.'PYRAM13') THEN
         CALL ELRFDF ( 'P13', M, 39, DFF, NNO, NDIM )

      ELSE
         CALL U2MESK('F','CALCULEL2_31',1,TYPEMA)
      ENDIF

      IF ( NDIM .EQ. 2 ) THEN
         DO 10 IN = 1 , NNO
            W(1+(IN-1)*NDIM)  = DFF(1,IN)
            W(2+(IN-1)*NDIM)  = DFF(2,IN)
 10      CONTINUE
      ELSEIF ( NDIM .EQ. 3 ) THEN
         DO 20 IN = 1 , NNO
            W(1+(IN-1)*NDIM)  = DFF(1,IN)
            W(2+(IN-1)*NDIM)  = DFF(2,IN)
            W(3+(IN-1)*NDIM)  = DFF(3,IN)
 20      CONTINUE
      ENDIF

      END

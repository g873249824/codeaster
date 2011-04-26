      SUBROUTINE NMFORE(NDIM,NNO1,NNO2,NNO3,NPG,IW,VFF1,VFF2,VFF3,
     &  IDFDE1,MAT,IDFDE2,GEOM,TYPMOD,REFE,VECT)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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

       IMPLICIT NONE

       CHARACTER*8   TYPMOD(*)

       INTEGER NDIM,NNO1,NNO2,NNO3,NPG,IDFDE1,IDFDE2,IW,MAT
       REAL*8  VFF1(NNO1,NPG),VFF2(NNO2,NPG),VFF3(NNO3,NPG)
       REAL*8  GEOM(NDIM,NNO1)
       REAL*8  REFE(3)
       REAL*8  VECT(*)
C ----------------------------------------------------------------------
C
C     FORC_NODA POUR GRAD_VARI (2D ET 3D)
C
C IN  NDIM    : DIMENSION DES ELEMENTS
C IN  NNO1    : NOMBRE DE NOEUDS (FAMILLE U)
C IN  VFF1    : VALEUR DES FONCTIONS DE FORME (FAMILLE U)
C IN  IDFDE1  : DERIVEES DES FONCTIONS DE FORME DE REFERENCE (FAMILLE U)
C IN  NNO2    : NOMBRE DE NOEUDS (FAMILLE E)
C IN  VFF2    : VALEUR DES FONCTIONS DE FORME (FAMILLE E)
C IN  IDFDE2  : DERIVEES DES FONCTIONS DE FORME DE REFERENCE (FAMILLE E)
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  IW      : POIDS DES POINTS DE GAUSS DE REFERENCE (INDICE)
C IN  GEOM    : COORDONNEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODEELISATION
C IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
C OUT VECT    : FORCES INTERIEURES    (RAPH_MECA   ET FULL_MECA_*)
C ----------------------------------------------------------------------

      LOGICAL GRAND,AXI
      INTEGER NDDL,NDIMSI,G,N,I,KL,KK
C      INTEGER IU(3*27),IA(8),IL(8)
      INTEGER IU(3,27),IA(8),IL(8)
      REAL*8  DFDI1(27,3)
      REAL*8  R,WG,B(6,3,27)
      REAL*8  T1,SIGREF,VARREF,LAGREF
      REAL*8  R8VIDE
C ----------------------------------------------------------------------



C - INITIALISATION

      GRAND  = .FALSE.
      AXI    = .FALSE.
      NDDL   = NNO1*NDIM + NNO2*2
      NDIMSI = 2*NDIM

      SIGREF = REFE(1)
      IF (REFE(2).EQ.R8VIDE()) THEN
        VARREF = 1.D0
      ELSE
        VARREF = REFE(2)
      END IF
      IF (REFE(3).EQ.R8VIDE()) THEN
        CALL U2MESK('F','MECANONLINE5_54',1,'LAGR_REFE')
      ELSE
        LAGREF = REFE(3)
      END IF

      CALL R8INIR(NDDL,0.D0,VECT,1)
      CALL NMGVDD(NDIM,NNO1,NNO2,IU,IA,IL)




      DO 1000 G=1,NPG

C      CALCUL DES ELEMENTS GEOMETRIQUES DE L'EF POUR U

        CALL DFDMIP(NDIM,NNO1,AXI,GEOM,G,IW,VFF1(1,G),IDFDE1,R,WG,DFDI1)
        CALL NMMABU(NDIM,NNO1,AXI,GRAND,DFDI1,B)
        DO 300 N=1,NNO1
          DO 310 I=1,NDIM
            KK = IU(I,N)
            T1 = 0
            DO 320 KL = 1,NDIMSI
              T1 = T1 + ABS(B(KL,I,N))
 320        CONTINUE
            VECT(KK) = VECT(KK) + WG*T1*SIGREF
 310      CONTINUE
 300    CONTINUE

        DO 400 N = 1,NNO2
          KK = IA(N)
          VECT(KK) = VECT(KK) + WG*VFF2(N,G)*LAGREF
 400    CONTINUE

        DO 500 N = 1,NNO3
          KK = IL(N)
          VECT(KK) = VECT(KK) + WG*VFF3(N,G)*VARREF
 500    CONTINUE

 1000 CONTINUE

      END

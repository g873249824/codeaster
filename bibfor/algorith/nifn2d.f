       SUBROUTINE NIFN2D(NNO1  , NNO2  , NPG   , IPOIDS, IVF1 , IVF2,
     &                   IDFDE1, DFDI  , GEOM  , AXI   , SIG   ,
     &                   DEPLM , GONFLM , FINTU , FINTA )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
       IMPLICIT NONE
       LOGICAL       AXI
       INTEGER       NNO1,NNO2, NPG, IPOIDS, IVF1 , IVF2, IDFDE1
       REAL*8        GEOM(2,NNO1)
       REAL*8        SIG(5,NPG),DFDI(NNO1,2)
       REAL*8        DEPLM(2,NNO1),GONFLM(2,NNO2),FINTU(2,9), FINTA(2,4)
C......................................................................
C
C     BUT:  CALCUL  DE L'OPTION FORC_NODA EN QUASI INCOMPRESSIBLE
C                  DEFORMATION = 'PETIT'
C     APPELEE PAR  TE0480.F
C......................................................................
C IN  NNO1    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AUX DEPLACEMENTS
C IN  NNO2    : NOMBRE DE NOEUDS DE L'ELEMENT LIES A LA PRESSION
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  IPOIDS  : POIDS DES POINTS DE GAUSS
C IN  IVF1    : VALEUR  DES FONCTIONS DE FORME LIES AUX DEPLACEMENTS
C IN  IVF2    : VALEUR  DES FONCTIONS DE FORME LIES A LA PRESSION
C IN  IDFDE1  : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
C IN  GEOM    : COORDONEES DES NOEUDS
C IN  AXI     : CALCUL AXISYMETRIQUE OU NON
C IN  DEPLM   : DEPLACEMENTS A L'INSTANT PRECEDENT
C IN  GONFLM  : VARIABLES LIEES AU GONFLEMENT A L'INSTANT PRECEDENT
C IN  SIG     : CONTRAINTES A L'INSTANT PRECEDENT
C OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
C OUT  FINTU  : VECTEUR DES FORCES INTERNES (COMPOSANTES U)
C OUT  FINTA  : VECTEUR DES FORCES INTERNES (COMPOSANTES P et G)
C......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      LOGICAL      GRAND
      INTEGER      KPG,N,I
      REAL*8       TMP, RAC2,  GM, DIVUM
      REAL*8       DEF(4,9,2),F(3,3),R,POIDS,EPSM(6), SIGMA(6)
      REAL*8       DDOT, VFF1, VFF2
C -------------------------------------------------------------------

C - PRE REQUIS
      IF (NNO1 .GT. 9) CALL U2MESS('F','ALGORITH6_54')

C - INITIALISATION
      CALL R8INIR(18, 0.D0, FINTU,1)
      CALL R8INIR( 8, 0.D0, FINTA,1)
      RAC2  = SQRT(2.D0)
      GRAND = .FALSE.

C - CALCUL POUR CHAQUE POINT DE GAUSS

      DO 800 KPG = 1,NPG
C - CALCUL DU GONFLEMENT
        GM = 0.D0
        DO 1 N = 1, NNO2
          VFF2 = ZR(IVF2-1+N+(KPG-1)*NNO2)
          GM = GM + VFF2*GONFLM(2,N)
 1      CONTINUE

C      CALCUL DES ELEMENTS GEOMETRIQUES :F,DFDI
        CALL R8INIR(6, 0.D0, EPSM,1)
        CALL NMGEOM(2,NNO1,AXI,GRAND,GEOM,KPG,IPOIDS,IVF1,IDFDE1,
     &              DEPLM,POIDS,DFDI,F,EPSM,R)
        DIVUM = EPSM(1) + EPSM(2) + EPSM(3)

C      CALCUL DE LA MATRICE B
        DO 35 N=1,NNO1
          DO 30 I=1,2
            DEF(1,N,I) =  F(I,1)*DFDI(N,1)
            DEF(2,N,I) =  F(I,2)*DFDI(N,2)
            DEF(3,N,I) =  0.D0
            DEF(4,N,I) = (F(I,1)*DFDI(N,2) + F(I,2)*DFDI(N,1))/RAC2
 30       CONTINUE
 35     CONTINUE

C      TERME DE CORRECTION (3,3) AXI QUI PORTE EN FAIT SUR LE DDL 1
        IF (AXI) THEN
          DO 50 N=1,NNO1
            VFF1 = ZR(IVF1-1+N+(KPG-1)*NNO1)
            DEF(3,N,1) = F(3,3)*VFF1/R
 50       CONTINUE
        END IF

C      CALCUL DES CONTRAINTES MECANIQUES A L'EQUILIBRE
        SIGMA(1) = SIG(1,KPG)
        SIGMA(2) = SIG(2,KPG)
        SIGMA(3) = SIG(3,KPG)
        SIGMA(4) = SIG(4,KPG)*RAC2
        SIGMA(5) = 0.D0
        SIGMA(6) = 0.D0

C        CALCUL DE FINT_U
        DO 3 N=1,NNO1
          DO 2 I=1,2
            TMP = DDOT(4, SIGMA,1, DEF(1,N,I),1)
            FINTU(I,N) = FINTU(I,N) + TMP*POIDS
 2        CONTINUE
 3      CONTINUE

C        CALCUL DE FINT_P ET FINT_G
        DO 4 N = 1, NNO2
          VFF2 = ZR(IVF2-1+N+(KPG-1)*NNO2)
          TMP = (DIVUM - GM )*VFF2
          FINTA(1,N) = FINTA(1,N) + TMP*POIDS
          TMP = SIG(5,KPG)*VFF2
          FINTA(2,N) = FINTA(2,N) + TMP*POIDS
 4      CONTINUE

 800  CONTINUE
      END

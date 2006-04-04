      SUBROUTINE TE0088(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/04/2006   AUTEUR CIBHHLV L.VIVAN 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*16 OPTION,NOMTE
C ......................................................................

C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
C          CORRESPONDANT A UN CHARGEMENT EN PRESSION REPARTIE
C          SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 2D

C          OPTION : 'CHAR_MECA_PRES_R'

C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

      REAL*8 POIDS,R,TX,TY,VNORM,NX,NY,PRES,CISA,PR(9),CI(9)
      INTEGER NNO,KP,NPG,IPOIDS,IVF,IDFDE,IGEOM
      INTEGER IPRES,IVECTU,K,I,L
      LOGICAL LTEATT,LAXI

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

      LAXI = .FALSE.
      IF (LTEATT(' ','AXIS','OUI')) LAXI = .TRUE.

      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECD('PPRESSR',IPRES,0.D0)
      CALL JEVECH('PVECTUR','E',IVECTU)

C    BOUCLE SUR LES POINTS DE GAUSS

      DO 40 KP = 1,NPG
        K = (KP-1)*NNO

C CALCUL DE P AU POINT DE GAUSS KP A PARTIR DE P AUX NOEUDS
        S = 0.D0
        T = 0.D0
        DO 10 I = 1,NNO
          S = S + ZR(IPRES+2*(I-1)  )*ZR(IVF+K+I-1)
          T = T + ZR(IPRES+2*(I-1)+1)*ZR(IVF+K+I-1)
   10   CONTINUE
        PR(KP) = S
        CI(KP) = T

        CALL VFF2DN(NDIM,NNO,KP,IPOIDS,IDFDE,ZR(IGEOM),NX,NY,POIDS)

        IF (LAXI) THEN
          R = 0.D0
          DO 20 I = 1,NNO
            R = R + ZR(IGEOM+2*(I-1))*ZR(IVF+K+I-1)
   20     CONTINUE
          POIDS = POIDS*R
        END IF

        TX = -NX*PR(KP) - NY*CI(KP)
        TY = -NY*PR(KP) + NX*CI(KP)
        DO 30 I = 1,NNO
          ZR(IVECTU+2*I-2) = ZR(IVECTU+2*I-2) + TX*ZR(IVF+K+I-1)*POIDS
          ZR(IVECTU+2*I-1) = ZR(IVECTU+2*I-1) + TY*ZR(IVF+K+I-1)*POIDS
   30   CONTINUE
   40 CONTINUE
      END

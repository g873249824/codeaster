      SUBROUTINE TE0049(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 24/09/2007   AUTEUR LEBOUVIER F.LEBOUVIER 
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
C.......................................................................

C     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'CHAR_MECA_EPSI_R  ' ET 'CHAR_MECA_EPSI_F  '

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      REAL*8 SIGI(162),EPSI(162),BSIGMA(81),REPERE(7)
      REAL*8 INSTAN,NHARM,BARY(3)
      INTEGER NBSIGM,IDIM
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

C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

C --- INITIALISATIONS :
C     -----------------
      ZERO = 0.0D0
      INSTAN = ZERO
      NHARM = ZERO

C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG = NBSIGM()

      DO 10 I = 1,NBSIG*NPG1
        EPSI(I) = ZERO
        SIGI(I) = ZERO
   10 CONTINUE

      DO 20 I = 1,NDIM*NNO
        BSIGMA(I) = ZERO
   20 CONTINUE

C ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
C      ----------------------------------------------
      CALL JEVECH('PGEOMER','L',IGEOM)

C ---- RECUPERATION DU MATERIAU
C      ------------------------
      CALL JEVECH('PMATERC','L',IMATE)

C ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE
C      ------------------------------------------------------------
C     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )

      BARY(1) = 0.D0
      BARY(2) = 0.D0
      BARY(3) = 0.D0
      DO 150 I = 1,NNO
        DO 140 IDIM = 1,NDIM
          BARY(IDIM) = BARY(IDIM)+ZR(IGEOM+IDIM+NDIM*(I-1)-1)/NNO
 140    CONTINUE
 150  CONTINUE
      CALL ORTREP(ZI(IMATE),NDIM,BARY,REPERE)

C ---- RECUPERATION DE L'INSTANT
C      -------------------------
      CALL TECACH('NNN','PTEMPSR',1,ITEMPS,IRET)
      IF (ITEMPS.NE.0) INSTAN = ZR(ITEMPS)

C ---- CONSTRUCTION DU VECTEUR DES DEFORMATIONS INITIALES DEFINIES AUX
C ---- POINTS D'INTEGRATION A PARTIR DES DONNEES UTILISATEUR
C      -----------------------------------------------------
      CALL EPSIMC(OPTION,ZR(IGEOM),NNO,NPG1,NDIM,NBSIG,ZR(IVF),EPSI)

C ---- CALCUL DU VECTEUR DES CONTRAINTES INITIALES AUX POINTS
C ---- D'INTEGRATION
C      -------------
      CALL SIGIMC('RIGI',NNO,NDIM,NBSIG,NPG1,ZR(IVF),ZR(IGEOM),
     &            INSTAN,ZI(IMATE),REPERE,EPSI,SIGI)

C ---- CALCUL DU VECTEUR DES FORCES DUES AUX CONTRAINTES INITIALES
C ---- (I.E. BT*SIG_INITIALES)
C      ----------------------
      CALL BSIGMC(NNO,NDIM,NBSIG,NPG1,IPOIDS,IVF,IDFDE,
     +              ZR(IGEOM), NHARM, SIGI, BSIGMA )

C ---- RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE AVEC LE
C ---- VECTEUR DES FORCES DUES AUX CONTRAINTES INITIALES
C      -------------------------------------------------
      CALL JEVECH('PVECTUR','E',IVECTU)

      DO 30 I = 1,NDIM*NNO
        ZR(IVECTU+I-1) = BSIGMA(I)
   30 CONTINUE

C FIN ------------------------------------------------------------------
      END

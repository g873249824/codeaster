      SUBROUTINE TE0022(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 04/05/2004   AUTEUR SMICHEL S.MICHEL-PONNELLE 
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

C     BUT: CALCUL DES CONTRAINTES AUX POINTS DE GAUSS
C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTION : 'SIEF_ELGA_DEPL'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................

      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*8 MODELI
      CHARACTER*16 NOMTE,OPTION
      REAL*8 SIGMA(162),REPERE(7),INSTAN,NHARM
      REAL*8 SIGM2(162)
      INTEGER NBSIGM,NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO
      INTEGER IHYDR,ISECH,ISREF
      LOGICAL LSENS

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

      MODELI(1:2) = NOMTE(3:4)

C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG = NBSIGM(MODELI)

C --- INITIALISATIONS :
C     -----------------
      ZERO = 0.0D0
      INSTAN = ZERO
      NHARM = ZERO
      IF (OPTION(11:14).EQ.'SENS') THEN
        LSENS = .TRUE.
      ELSE
        LSENS = .FALSE.
      END IF

      DO 10 I = 1,NBSIG*NPG1
        SIGMA(I) = ZERO
   10 CONTINUE

C ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
C      ----------------------------------------------
      CALL JEVECH('PGEOMER','L',IGEOM)

C ---- RECUPERATION DU MATERIAU
C      ------------------------
      CALL JEVECH('PMATERC','L',IMATE)

C ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE
C      ------------------------------------------------------------
      CALL ORTREP(ZI(IMATE),NDIM,REPERE)

C ---- RECUPERATION DU CHAMP DE DEPLACEMENT SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PDEPLAR','L',IDEPL)

C ---- RECUPERATION DU CHAMP DE DEPLACEMENT DERIVE SUR L'ELEMENT
C      ---------------------------------------------------------
      IF (LSENS) CALL JEVECH('PDEPSEN','L',IDEPS)

C ---- RECUPERATION DU CHAMP DE TEMPERATURE SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PTEMPER','L',ITEMPE)

C ---- RECUPERATION DE LA TEMPERATURE DE REFERENCE
C      -------------------------------------------
      CALL JEVECH('PTEREF','L',ITREF)

C ---- RECUPERATION DU CHAMP DE L'HDRATATION SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PHYDRER','L',IHYDR)

C ---- RECUPERATION DU CHAMP DU SECHAGE SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PSECHER','L',ISECH)      

C ---- RECUPERATION DU SECHAGE DE REFERENCE
C      -------------------------------------------
      CALL JEVECH('PSECREF','L',ISREF)
      
C ---- CALCUL DES CONTRAINTES 'VRAIES' SUR L'ELEMENT
C ---- (I.E. SIGMA_MECA - SIGMA_THERMIQUES - SIGMA_RETRAIT)
C      ------------------------------------
      CALL SIGVMC(MODELI,NNO,NDIM,NBSIG,NPG1,IPOIDS,IVF,IDFDE,
     &            ZR(IGEOM),ZR(IDEPL), ZR(ITEMPE),ZR(ITREF),
     &            ZR(IHYDR),ZR(ISECH),ZR(ISREF),INSTAN,REPERE,
     &            ZI(IMATE),NHARM,SIGMA,.FALSE.)

C ---- CALC DU TERME COMPLEMENTAIRE DE CONTR 'VRAIES' SUR L'ELEMENT
C ---- DANS LE CAS DE LA SENSIBILITE (TERME DA/DP*B*U)
C ---- (I.E. SIGMA_MECA - SIGMA_THERMIQUES)
C ATTENTION!! POUR L'INSTANT(30/9/02) ON DOIT AVOIR SIGMA_THERMIQUE=0
C      ------------------------------------
      IF (LSENS) THEN
        CALL SIGVMC(MODELI,NNO,NDIM,NBSIG,NPG1,IPOIDS,IVF,IDFDE,
     &              ZR(IGEOM),ZR(IDEPS),ZR(ITEMPE),ZR(ITREF),
     &              ZR(IHYDR),ZR(ISECH),ZR(ISREF),INSTAN,REPERE,
     &              ZI(IMATE),NHARM,SIGM2,.TRUE.)
        DO 20 I = 1,NBSIG*NPG1
          SIGMA(I) = SIGMA(I) + SIGM2(I)
   20   CONTINUE
      END IF

C ---- RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
C ---- AVEC LE VECTEUR DES CONTRAINTES AUX POINTS D'INTEGRATION
C      --------------------------------------------------------
      CALL JEVECH('PCONTRR','E',ICONT)

      DO 30 I = 1,NBSIG*NPG1
        ZR(ICONT+I-1) = SIGMA(I)
   30 CONTINUE

      END

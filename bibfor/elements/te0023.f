      SUBROUTINE TE0023(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE
C.......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 28/03/2007   AUTEUR PELLET J.PELLET 
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

C     BUT: CALCUL DES CONTRAINTES AUX NOEUDS PAR EXTRAPOLATION
C                 DES CONTRAINTES AUX POINTS DE GAUSS

C          ELEMENTS ISOPARAMETRIQUES 3D

C          OPTIONS : 'SIGM_ELNO_DEPL'

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      CHARACTER*8 MODELI
      REAL*8 SIGMA(162),CONTNO(162),REPERE(7),BARY(3)
      REAL*8 NHARM,INSTAN,ZERO,DEPLA(81),SIGM2(162)
      LOGICAL LSENS
      INTEGER JGANO,NBSIGM,NITER,I,ICONT,IDEPL,ITER,IDEPLC,IDFDE,
     &        IGEOM,IMATE,J,INO,IPOIDS,IVF,NBINCO,
     &        NBSIG,NDIM,NNO,NNOS,NPG,IDEPS,IGAU,IRET,IDIM
C     ------------------------------------------------------------------

      MODELI(1:2) = NOMTE(3:4)

C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C      ------------------------

      CALL ELREF4(' ','GANO',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

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

C ---- RECUPERATION DU CHAMP DE DEPLACEMENT SUR L'ELEMENT
C      --------------------------------------------------
      NBINCO = NNO*NDIM
      CALL JEVECH('PDEPLAR','L',IDEPL)

C ---- RECUPERATION DU CHAMP DE DEPLACEMENT DERIVE SUR L'ELEMENT
C      ---------------------------------------------------------
      IF (LSENS) CALL JEVECH('PDEPSEN','L',IDEPS)

        DO 20 I = 1,NBSIG*NPG
          SIGMA(I) = ZERO
   20   CONTINUE

        DO 50 I = 1,NBINCO
          DEPLA(I) = ZR(IDEPL-1+I)
   50   CONTINUE

C ---- CALCUL DES CONTRAINTES 'VRAIES' AUX POINTS D'INTEGRATION
C ---- DE L'ELEMENT :
C ---- (I.E. SIGMA_MECA - SIGMA_THERMIQUES - SIGMA_RETRAIT)
C      ------------------------------------
        CALL SIGVMC('GANO',MODELI,NNO,NDIM,NBSIG,NPG,IPOIDS,IVF,
     &              IDFDE,ZR(IGEOM),DEPLA,
     &              INSTAN,REPERE,
     &              ZI(IMATE),NHARM,SIGMA,.FALSE.)


C ---- CALC DU TERME COMPLEMENTAIRE DE CONTR 'VRAIES' SUR L'ELEMENT
C ---- DANS LE CAS DE LA SENSIBILITE (TERME DA/DP*B*U)
C ---- (I.E. SIGMA_MECA - SIGMA_THERMIQUES)
C ATTENTION!! POUR L'INSTANT(30/9/02) ON DOIT AVOIR SIGMA_THERMIQUE=0
C      ------------------------------------
        IF (LSENS) THEN
          DO 60 I = 1,NBINCO
            DEPLA(I) = ZR(IDEPS-1+I)
   60     CONTINUE
          CALL SIGVMC('GANO',MODELI,NNO,NDIM,NBSIG,NPG,IPOIDS,IVF,
     &                IDFDE,ZR(IGEOM),DEPLA,
     &                INSTAN,REPERE,ZI(IMATE),NHARM,SIGM2,.TRUE.)
          DO 70 I = 1,NBSIG*NPG
            SIGMA(I) = SIGMA(I) + SIGM2(I)
   70     CONTINUE
        END IF

        CALL PPGAN2(JGANO,NBSIG,SIGMA,CONTNO)


C ---- RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
C ---- AVEC LE VECTEUR DES CONTRAINTES AUX NOEUDS
C      ------------------------------------------

        CALL JEVECH('PCONTRR','E',ICONT)
        DO 130 INO = 1,NNO
          DO 120 J = 1,6
            ZR(ICONT+6* (INO-1)-1+J) = CONTNO(6* (INO-1)+J)
  120     CONTINUE
  130   CONTINUE

      END

      SUBROUTINE TE0081(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INCLUDE 'jeveux.h'

      CHARACTER*16 OPTION,NOMTE,PHENOM
C ......................................................................
C    - FONCTION REALISEE:
C            OPTION : 'RIGI_MECA      '
C                            CALCUL DES MATRICES ELEMENTAIRES  2D
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................

C-----------------------------------------------------------------------
      INTEGER I ,IGAU ,IGEOM ,IMATE ,IMATUU ,J ,K
      INTEGER NBINCO ,NBRES ,NBSIG
      REAL*8 ZERO
C-----------------------------------------------------------------------
      PARAMETER (NBRES=7)
      INTEGER ICODRE(NBRES)
      REAL*8 B(486),BTDB(81,81),D(36),JACGAU
      REAL*8 REPERE(7),XYZGAU(3),INSTAN,NHARM
      REAL*8 BARY(3)
      INTEGER NBSIGM,NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO
      INTEGER IDIM

      CHARACTER*4 FAMI

      FAMI  = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,JGANO)

C --- INITIALISATIONS :
C     -----------------
      NDIM = 2
      ZERO = 0.0D0
      INSTAN = ZERO
      NBINCO = NDIM*NNO
      NHARM = ZERO

      DO 20 I = 1,NBINCO
        DO 10 J = 1,NBINCO
          BTDB(I,J) = ZERO
   10   CONTINUE
   20 CONTINUE

      XYZGAU(1) = ZERO
      XYZGAU(2) = ZERO
      XYZGAU(3) = ZERO


C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG = NBSIGM()

C ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
C      ----------------------------------------------
      CALL JEVECH('PGEOMER','L',IGEOM)

C ---- RECUPERATION DU MATERIAU
C      ------------------------
      CALL JEVECH('PMATERC','L',IMATE)
      CALL RCCOMA(ZI(IMATE),'ELAS',1,PHENOM,ICODRE)

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

C ---  BOUCLE SUR LES POINTS D'INTEGRATION
C      -----------------------------------
      DO 50 IGAU = 1,NPG1

C  --      CALCUL DE LA MATRICE B RELIANT LES DEFORMATIONS DU
C  --      PREMIER ORDRE AUX DEPLACEMENTS AU POINT D'INTEGRATION
C  --      COURANT : (EPS_1) = (B)*(UN)
C          ----------------------------
        CALL BMATMC(IGAU,NBSIG,ZR(IGEOM),IPOIDS,IVF,IDFDE,
     +                  NNO, NHARM, JACGAU, B)

C  --      CALCUL DE LA MATRICE DE HOOKE (LE MATERIAU POUVANT
C  --      ETRE ISOTROPE, ISOTROPE-TRANSVERSE OU ORTHOTROPE)
C          -------------------------------------------------
        CALL DMATMC(FAMI,'  ',ZI(IMATE),INSTAN,'+',IGAU,1,REPERE,
     &              XYZGAU,NBSIG,D)

C  --      MATRICE DE RIGIDITE ELEMENTAIRE BT*D*B
C          ---------------------------------------
        CALL BTDBMC(B,D,JACGAU,NDIM,NNO,NBSIG,PHENOM,BTDB)

   50 CONTINUE

C ---- RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
C      ------------------------------------------------
      CALL JEVECH('PMATUUR','E',IMATUU)

      K = 0
      DO 70 I = 1,NBINCO
        DO 60 J = 1,I
          K = K + 1
          ZR(IMATUU+K-1) = BTDB(I,J)
   60    CONTINUE
   70 CONTINUE


      END

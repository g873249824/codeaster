      SUBROUTINE TE0086 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 21/01/2013   AUTEUR PELLET J.PELLET 
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

      CHARACTER*16        OPTION , NOMTE
C ......................................................................
C    - FONCTION REALISEE:  CALCUL DES CONTRAINTES EN 2D
C                          OPTION : 'SIGM_ELNO  '
C                             OU  : 'SIEF_ELGA  '
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................
C
      REAL*8           SIGMA(54),BARY(3),REPERE(7)
      REAL*8           NHARM, INSTAN,CONTNO(54)
      INTEGER          IDIM
C
C
C-----------------------------------------------------------------------
      INTEGER I ,ICONT ,IDEPL ,IDFDE ,IGAU ,IGEOM ,IMATE
      INTEGER INO ,IPOIDS ,ISIG ,IVF ,J ,NBSIG,JGANO
      INTEGER NBSIG1 ,NBSIG2 ,NBSIGM ,NDIM ,NNO ,NNOS ,NPG

      REAL*8 ZERO
C-----------------------------------------------------------------------
      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C
C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT
C      -----------------------------------------
      NBSIG1  = NBSIGM()
      NBSIG2  = 6
      NBSIG   = NBSIG1
C
C --- INITIALISATIONS :
C     -----------------
      ZERO     = 0.0D0
      INSTAN   = ZERO
      NHARM    = ZERO
C
      DO 10 I = 1, NBSIG2*NPG
         SIGMA(I)  = ZERO
10    CONTINUE
C
C ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
C      ----------------------------------------------
      CALL JEVECH('PGEOMER','L',IGEOM)
C
C ---- RECUPERATION DU MATERIAU
C      ------------------------
      CALL JEVECH('PMATERC','L',IMATE)
C
C ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE
C      ------------------------------------------------------------
C     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )

      BARY(1) = 0.D0
      BARY(2) = 0.D0
      BARY(3) = 0.D0
      DO 160 I = 1,NNO
        DO 150 IDIM = 1,NDIM
           BARY(IDIM) = BARY(IDIM)+ZR(IGEOM+IDIM+NDIM*(I-1)-1)/NNO
 150    CONTINUE
 160  CONTINUE
      CALL ORTREP(ZI(IMATE),NDIM,BARY,REPERE)
C
C ---- RECUPERATION DU CHAMP DE DEPLACEMENT SUR L'ELEMENT
C      --------------------------------------------------
      CALL JEVECH('PDEPLAR','L',IDEPL)


      DO 20 I = 1,NBSIG*NPG
        SIGMA(I) = ZERO
20    CONTINUE

C
C

C       CALCUL DES CONTRAINTES 'VRAIES' AUX POINTS D'INTEGRATION
C       DE L'ELEMENT : (I.E. SIGMA_MECA - SIGMA_THERMIQUES)
C       --------------------------------------------------------
      CALL SIGVMC('RIGI',NNO,NDIM,NBSIG1,NPG,IPOIDS,IVF,IDFDE,
     +           ZR(IGEOM),ZR(IDEPL),
     +           INSTAN,REPERE,ZI(IMATE),NHARM,SIGMA)

      IF (OPTION(6:9).EQ.'ELGA') THEN

        CALL JEVECH('PCONTRR','E',ICONT)

C         --------------------
C ---- AFFECTATION DU VECTEUR EN SORTIE AVEC LES CONTRAINTES AUX
C ---- POINTS D'INTEGRATION
C      --------------------
        DO 80 IGAU = 1, NPG
        DO 81 ISIG = 1, NBSIG
          ZR(ICONT+NBSIG*(IGAU-1)+ISIG-1) = SIGMA(NBSIG*(IGAU-1)+ISIG)
81     CONTINUE
80     CONTINUE
C
      ELSE
C
        CALL PPGAN2(JGANO,1,NBSIG,SIGMA,CONTNO)
C
C
C ---- RECUPERATION ET AFFECTATION DU VECTEUR EN SORTIE
C ---- AVEC LE VECTEUR DES CONTRAINTES AUX NOEUDS
C      ------------------------------------------

        CALL JEVECH('PCONTRR','E',ICONT)
        DO 140 INO = 1,NNO
          DO 130 J = 1,NBSIG
            ZR(ICONT+NBSIG* (INO-1)-1+J) = CONTNO(NBSIG* (INO-1)+J)
  130     CONTINUE
  140   CONTINUE
      END IF

      END

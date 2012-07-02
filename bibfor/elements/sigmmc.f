      SUBROUTINE SIGMMC (FAMI,NNO,NDIM,NBSIG,NPG,IPOIDS,IVF,
     +                   IDFDE,XYZ,DEPL,INSTAN,REPERE,MATER,
     +                   NHARM,SIGMA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C.======================================================================
      IMPLICIT NONE
C
C      SIGMMC   -- CALCUL DES  CONTRAINTES AUX POINTS D'INTEGRATION
C                  POUR LES ELEMENTS ISOPARAMETRIQUES
C
C   ARGUMENT        E/S  TYPE         ROLE
C    NNO            IN     I        NOMBRE DE NOEUDS DE L'ELEMENT
C    NDIM           IN     I        DIMENSION DE L'ELEMENT (2 OU 3)
C    NBSIG          IN     I        NOMBRE DE CONTRAINTES ASSOCIE
C                                   A L'ELEMENT
C    NPG            IN     I        NOMBRE DE POINTS D'INTEGRATION
C                                   DE L'ELEMENT
C    IPOIDS         IN     I        POIDS D'INTEGRATION
C    IVF            IN     I        FONCTIONS DE FORME
C    IDFDE          IN     I        DERIVEES DES FONCTIONS DE FORME
C    XYZ(1)         IN     R        COORDONNEES DES CONNECTIVITES
C    DEPL(1)        IN     R        VECTEUR DES DEPLACEMENTS SUR
C                                   L'ELEMENT
C    INSTAN         IN     R        INSTANT DE CALCUL (0 PAR DEFAUT)
C    REPERE(7)      IN     R        VALEURS DEFINISSANT LE REPERE
C                                   D'ORTHOTROPIE
C    MATER          IN     I        MATERIAU
C    NHARM          IN     R        NUMERO D'HARMONIQUE
C    SIGMA(1)       OUT    R        CONTRAINTES AUX POINTS D'INTEGRATION
C
C.========================= DEBUT DES DECLARATIONS ====================
C -----  ARGUMENTS
      INCLUDE 'jeveux.h'
           REAL*8       XYZ(1), DEPL(1), REPERE(7), SIGMA(1)
           REAL*8       INSTAN, NHARM
           CHARACTER*(*) FAMI
C -----  VARIABLES LOCALES
           INTEGER      IGAU,I,NNO
           REAL*8       B(486), D(36), JACGAU, XYZGAU(3)
           CHARACTER*2  K2BID
           LOGICAL      LTEATT
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
C --- INITIALISATIONS :
C     -----------------
C-----------------------------------------------------------------------
      INTEGER IDFDE ,IDIM ,IPOIDS ,IVF ,MATER ,NBINCO ,NBSIG 
      INTEGER NDIM ,NDIM2 ,NPG 
      REAL*8 ZERO 
C-----------------------------------------------------------------------
      K2BID  = '  '
      ZERO   = 0.0D0
      NBINCO = NDIM*NNO
      NDIM2  = NDIM
      IF (LTEATT(' ','FOURIER','OUI')) THEN
        NDIM2 = 2
      ENDIF
C
      DO 10 I = 1, NBSIG*NPG
         SIGMA(I) = ZERO
 10   CONTINUE
C
C --- CALCUL DES CONTRAINTES AUX POINTS D'INTEGRATION
C ---  BOUCLE SUR LES POINTS D'INTEGRATION
C      -----------------------------------
      DO 20 IGAU = 1, NPG
C
C  --      COORDONNEES ET TEMPERATURE AU POINT D'INTEGRATION
C  --      COURANT
C          -------
          XYZGAU(1) = ZERO
          XYZGAU(2) = ZERO
          XYZGAU(3) = ZERO

          DO 30 I = 1, NNO
C
            DO 40 IDIM = 1, NDIM2
               XYZGAU(IDIM) = XYZGAU(IDIM) +
     +                   ZR(IVF+I+NNO*(IGAU-1)-1)*XYZ(IDIM+NDIM2*(I-1))
  40         CONTINUE
C
  30      CONTINUE
C
C  --      CALCUL DE LA MATRICE B RELIANT LES DEFORMATIONS DU
C  --      PREMIER ORDRE AUX DEPLACEMENTS AU POINT D'INTEGRATION
C  --      COURANT : (EPS_1) = (B)*(UN)
C          ----------------------------
          CALL BMATMC(IGAU, NBSIG,  XYZ, IPOIDS,IVF,IDFDE,
     +                NNO, NHARM, JACGAU, B)
C
C  --      CALCUL DE LA MATRICE DE HOOKE (LE MATERIAU POUVANT
C  --      ETRE ISOTROPE, ISOTROPE-TRANSVERSE OU ORTHOTROPE)
C          -------------------------------------------------
          CALL DMATMC(FAMI,K2BID,MATER, INSTAN, '+', IGAU, 1,
     +                REPERE, XYZGAU, NBSIG, D)
C
C  --      CALCUL DE LA CONTRAINTE AU POINT D'INTEGRATION COURANT
C          ------------------------------------------------------
          CALL DBUDEF(DEPL, B, D, NBSIG, NBINCO,
     +                SIGMA(1+NBSIG*(IGAU-1)))
  20  CONTINUE
C
C.============================ FIN DE LA ROUTINE ======================
      END

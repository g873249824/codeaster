      SUBROUTINE SIGVMC (FAMI,NNO,NDIM,NBSIG,NPG,
     &                    IPOIDS,IVF,IDFDE,XYZ,DEPL,
     &                    INSTAN, REPERE,MATER,NHARM,SIGMA)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 20/06/2012   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT REAL*8 (A-H,O-Z)
C
C      SIGVMC   -- CALCUL DES  CONTRAINTES 'VRAIES'
C                  (I.E. SIGMA_MECA - SIGMA_THERMIQUES- SIGMA_RETRAIT)
C                  AUX POINTS D'INTEGRATION POUR LES ELEMENTS
C                  ISOPARAMETRIQUES
C
C   ARGUMENT        E/S  TYPE         ROLE
C    FAMI           IN     K        FAMILLE DE POINT DE GAUSS
C    NNO            IN     I        NOMBRE DE NOEUDS DE L'ELEMENT
C    NDIM           IN     I        DIMENSION DE L'ELEMENT (2 OU 3)
C    NBSIG          IN     I        NOMBRE DE CONTRAINTES ASSOCIE
C                                   A L'ELEMENT
C    NPG            IN     I        NOMBRE DE POINTS D'INTEGRATION
C                                   DE L'ELEMENT
C    NI(1)          IN     R        FONCTIONS DE FORME
C    DNIDX(1)       IN     R        DERIVEES DES FONCTIONS DE FORME
C                                   / X SUR L'ELEMENT DE REFERENCE
C    DNIDY(1)       IN     R        DERIVEES DES FONCTIONS DE FORME
C                                   / Y SUR L'ELEMENT DE REFERENCE
C    DNIDZ(1)       IN     R        DERIVEES DES FONCTIONS DE FORME
C                                   / Z SUR L'ELEMENT DE REFERENCE
C    POIDS(1)       IN     R        POIDS D'INTEGRATION
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
           CHARACTER*(*) FAMI
           REAL*8       XYZ(1), DEPL(1), REPERE(7), SIGMA(1)
           REAL*8       INSTAN, NHARM
           INTEGER      IPOIDS,IVF,IDFDE
C -----  VARIABLES LOCALES
           CHARACTER*16 OPTION
           REAL*8       SIGTH(162),SIGHY(162),SIGSE(162)
C
C
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
C --- INITIALISATIONS :
C     -----------------
      ZERO   = 0.0D0
C
      DO 10 I = 1, NBSIG*NPG
         SIGMA(I) = ZERO
 10   CONTINUE

C
C --- CALCUL DES CONTRAINTES MECANIQUES AUX POINTS D'INTEGRATION
C      ---------------------------------------------------------
      CALL SIGMMC(FAMI,NNO,NDIM,NBSIG,NPG,IPOIDS,IVF,IDFDE,
     +           XYZ,DEPL,INSTAN,REPERE,MATER,NHARM,
     +           SIGMA)
C
C --- CALCUL DES CONTRAINTES THERMIQUES AUX POINTS D'INTEGRATION
C      ---------------------------------------------------------
      OPTION = 'CALC_CONT_TEMP_R'
      CALL SIGTMC(FAMI,NNO,NDIM,NBSIG,NPG,ZR(IVF),XYZ,
     +            INSTAN,MATER,REPERE,OPTION,SIGTH)
C
C--- CALCUL DES CONTRAINTES DUES AUX RETRAIT DE DESSICCATION
C           ET D'HYDRATATION
C      ---------------------------------------------------------

      OPTION = 'CALC_CONT_HYDR_R'
      CALL SIGTMC(FAMI,NNO,NDIM,NBSIG,NPG,ZR(IVF),XYZ,
     +            INSTAN,MATER,REPERE,OPTION,SIGHY)


      OPTION = 'CALC_CONT_SECH_R'
      CALL SIGTMC(FAMI,NNO,NDIM,NBSIG,NPG,ZR(IVF),XYZ,
     +            INSTAN,MATER,REPERE,OPTION,SIGSE)

C --- CALCUL DES CONTRAINTES TOTALES AUX POINTS D'INTEGRATION
C      ---------------------------------------------------------
      DO 20 I = 1, NBSIG*NPG
         SIGMA(I) = SIGMA(I) - SIGTH(I) - SIGHY(I) - SIGSE(I)
 20   CONTINUE
C
C.============================ FIN DE LA ROUTINE ======================
      END

      SUBROUTINE  DMATMC(FAMI,MODELI,MATER,INSTAN,POUM,IGAU,ISGAU,
     &                   REPERE,XYZGAU,NBSIG,D)
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
      IMPLICIT NONE
C
C      DMATMC :   CALCUL DE LA MATRICE DE HOOKE POUR LES ELEMENTS
C                 ISOPARAMETRIQUES POUR DES MATERIAUX ISOTROPE,
C                 ORTHOTROPE ET ISOTROPE TRANSVERSE
C
C   ARGUMENT        E/S  TYPE         ROLE
C    FAMI           IN     K4       FAMILLE DU POINT DE GAUSS
C    MODELI         IN     K2       MODELISATION
C    MATER          IN     I        MATERIAU
C    IGAU           IN     I        POINT DE GAUSS
C    ISGAU          IN     I        SOUS-POINT DE GAUSS
C    INSTAN         IN     R        INSTANT DE CALCUL (0 PAR DEFAUT)
C    POUM           IN     K1       + OU -
C    REPERE(7)      IN     R        VALEURS DEFINISSANT LE REPERE
C                                   D'ORTHOTROPIE
C    XYZGAU(3)      IN     R        COORDONNEES DU POINT D'INTEGRATION
C    NBSIG          IN     I        NOMBRE DE CONTRAINTES ASSOCIE A
C                                   L'ELEMENT
C    D(NBSIG,1)     OUT    R        MATRICE DE HOOKE
C
C
C
C.========================= DEBUT DES DECLARATIONS ====================
C -----  ARGUMENTS
           CHARACTER*(*)  FAMI, POUM
           CHARACTER*2    MODELI
           INTEGER      MATER,NBSIG,IGAU,ISGAU
           REAL*8       REPERE(7), XYZGAU(1), D(NBSIG,1), INSTAN
           LOGICAL      LTEATT
C
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
C       ------------------------
C ----  CAS MASSIF 3D ET FOURIER
C       ------------------------
      IF (LTEATT(' ','DIM_TOPO_MAILLE','3').OR.
     &    LTEATT(' ','FOURIER','OUI')) THEN
C
         CALL DMAT3D(FAMI,MATER,INSTAN,POUM,IGAU,ISGAU,
     &               REPERE,XYZGAU,D)
C
C       ----------------------------------------
C ----  CAS DEFORMATIONS PLANES ET AXISYMETRIQUE
C       ----------------------------------------
      ELSEIF (LTEATT(' ','D_PLAN','OUI').OR.
     &        LTEATT(' ','AXIS','OUI').OR.MODELI.EQ.'DP') THEN
C
         CALL DMATDP(FAMI,MATER,INSTAN,POUM,IGAU,ISGAU,
     &               REPERE,D)
C
C       ----------------------
C ----  CAS CONTRAINTES PLANES
C       ----------------------
      ELSEIF (LTEATT(' ','C_PLAN','OUI')) THEN
C
         CALL DMATCP(FAMI,MATER,INSTAN,POUM,IGAU,ISGAU,
     &                  REPERE,D)
C
      ELSE
         CALL ASSERT(.FALSE.)
      ENDIF
C.============================ FIN DE LA ROUTINE ======================
      END

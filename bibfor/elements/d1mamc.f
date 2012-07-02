      SUBROUTINE  D1MAMC(FAMI,MATER,INSTAN,POUM,KPG,KSP,
     &                   REPERE,XYZGAU,
     &                   NBSIG,D1)
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
C      D1MAMC :   CALCUL DE L'INVERSE DE LA MATRICE DE HOOKE
C                 POUR LES ELEMENTS ISOPARAMETRIQUES POUR DES
C                 MATERIAUX ISOTROPE, ORTHOTROPE ET ISOTROPE TRANSVERSE
C
C   ARGUMENT        E/S  TYPE         ROLE
C    MATER          IN     I        MATERIAU
C    INSTAN         IN     R        INSTANT DE CALCUL (0 PAR DEFAUT)
C    REPERE(7)      IN     R        VALEURS DEFINISSANT LE REPERE
C                                   D'ORTHOTROPIE
C    XYZGAU(3)      IN     R        COORDONNEES DU POINT D'INTEGRATION
C    NBSIG          IN     I        NOMBRE DE CONTRAINTES ASSOCIE A
C                                   L'ELEMENT
C    D1(NBSIG,1)    OUT    R        MATRICE DE HOOKE
C
C
C
C.========================= DEBUT DES DECLARATIONS ====================
C -----  ARGUMENTS
           CHARACTER*(*) FAMI,POUM
           INTEGER      KPG,KSP
           REAL*8       REPERE(7), XYZGAU(1), D1(NBSIG,1), INSTAN
           LOGICAL      LTEATT
C
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
C       ------------------------
C ----  CAS MASSIF 3D ET FOURIER
C       ------------------------
C-----------------------------------------------------------------------
      INTEGER MATER ,NBSIG 
C-----------------------------------------------------------------------
       IF(LTEATT(' ','DIM_TOPO_MAILLE','3').OR.
     &    LTEATT(' ','FOURIER','OUI')) THEN
C
          CALL D1MA3D(FAMI,MATER,INSTAN,POUM,KPG,KSP,REPERE,XYZGAU,D1)
C
C       ----------------------------------------
C ----  CAS DEFORMATIONS PLANES ET AXISYMETRIQUE
C       ----------------------------------------
      ELSEIF(LTEATT(' ','D_PLAN','OUI').OR.
     &       LTEATT(' ','AXIS',  'OUI')) THEN
C
          CALL D1MADP(FAMI,MATER,INSTAN,POUM,KPG,KSP,REPERE,D1)
C
C       ----------------------
C ----  CAS CONTRAINTES PLANES
C       ----------------------
      ELSEIF(LTEATT(' ','C_PLAN','OUI'))THEN
C
          CALL D1MACP(FAMI,MATER,INSTAN,POUM,KPG,KSP,REPERE,D1)
C
      ELSE
         CALL U2MESS('F','ELEMENTS_11')
      ENDIF
C.============================ FIN DE LA ROUTINE ======================
      END

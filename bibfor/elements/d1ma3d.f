      SUBROUTINE  D1MA3D(FAMI,MATER,INSTAN,POUM,KPG,KSP,
     &                   REPERE,XYZGAU,D1)
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
C     D1MA3D  --   CALCUL DE L'INVERSE DE LA MATRICE DE HOOKE
C                  POUR LES ELEMENTS MASSIFS EN 3D OU EN SERIE DE
C                  FOURIER POUR DES MATERIAUX ISOTROPE, ORTHOTROPE
C                  ET ISOTROPE TRANSVERSE
C
C   ARGUMENT        E/S  TYPE         ROLE
C    FAMI           IN     K*       FAMILLE DU POINT DE GAUSS
C    MATER          IN     I        MATERIAU
C    INSTAN         IN     R        INSTANT DE CALCUL (0 PAR DEFAUT)
C    POUM           IN     K1       T ou T+DT
C    KPG            IN     I        POINT DE GAUSS
C    KSP            IN     I        SOUS-POINT DE GAUSS
C    REPERE(7)      IN     R        VALEURS DEFINISSANT LE REPERE
C                                   D'ORTHOTROPIE
C    XYZGAU(3)      IN     R        COORDONNEES DU POINT D'INTEGRATION
C    D1(6,6)        OUT    R        INVERSE DE LA MATRICE DE HOOKE
C
C
C
C.========================= DEBUT DES DECLARATIONS ====================
C -----  ARGUMENTS
           CHARACTER*(*)  POUM, FAMI
           INTEGER      KPG, KSP
           REAL*8       REPERE(7), XYZGAU(3), D1(6,6), INSTAN
C -----  VARIABLES LOCALES
C-----------------------------------------------------------------------
      INTEGER I ,IREP ,J ,MATER ,NBRES ,NBV 
      REAL*8 COEF1 ,COEF2 ,COEF3 ,DEUX ,E ,E1 ,E2 
      REAL*8 E3 ,UN ,ZERO 
C-----------------------------------------------------------------------
           PARAMETER (NBRES = 9)
C
      INTEGER ICODRE(NBRES)
           CHARACTER*8  NOMRES(NBRES), NOMPAR(2)
           CHARACTER*16 PHENOM
C
           REAL*8 VALRES(NBRES), VALPAR(1)
           REAL*8 PASSAG(6,6), D1ORTH(6,6), WORK(6,6)
           REAL*8 NU, NU12, NU21, NU13, NU23, NU31, NU32
C.========================= DEBUT DU CODE EXECUTABLE ==================
C
C ---- INITIALISATIONS
C      ---------------
      ZERO   = 0.0D0
      UN     = 1.0D0
      DEUX   = 2.0D0
C
      NOMPAR(1) = 'INST'
      VALPAR(1) = INSTAN
C
      DO 10 I = 1, 6
      DO 10 J = 1, 6
         D1(I,J)     = ZERO
         D1ORTH(I,J) = ZERO
         WORK(I,J)   = ZERO
 10   CONTINUE
C
C ---- RECUPERATION DU TYPE DU MATERIAU DANS PHENOM
C      --------------------------------------------
      CALL RCCOMA(MATER,'ELAS',PHENOM,ICODRE)
C
C      ------------
C ---- CAS ISOTROPE
C      ------------
      IF (PHENOM.EQ.'ELAS') THEN
C
          NOMRES(1) = 'E'
          NOMRES(2) = 'NU'
          NBV = 2
C
C ----   INTERPOLATION DES COEFFICIENTS EN FONCTION DE LA TEMPERATURE
C ----   ET DU TEMPS
C        -----------
          CALL RCVALB(FAMI,KPG,KSP,POUM,MATER,' ',PHENOM,1,NOMPAR,
     &                VALPAR,NBV,NOMRES,VALRES, ICODRE, 1)
C
          E  = VALRES(1)
          NU = VALRES(2)

          COEF1  =  UN/E
          COEF2  = -NU/E
          COEF3  =  DEUX*(UN + NU)/E
C
          D1(1,1) = COEF1
          D1(1,2) = COEF2
          D1(1,3) = COEF2
C
          D1(2,1) = COEF2
          D1(2,2) = COEF1
          D1(2,3) = COEF2
C
          D1(3,1) = COEF2
          D1(3,2) = COEF2
          D1(3,3) = COEF1
C
          D1(4,4) = COEF3
          D1(5,5) = COEF3
          D1(6,6) = COEF3
C
C      --------------
C ---- CAS ORTHOTROPE
C      --------------
      ELSEIF (PHENOM.EQ.'ELAS_ORTH') THEN
C
          NOMRES(1)='E_L'
          NOMRES(2)='E_T'
          NOMRES(3)='E_N'
          NOMRES(4)='NU_LT'
          NOMRES(5)='NU_LN'
          NOMRES(6)='NU_TN'
          NOMRES(7)='G_LT'
          NOMRES(8)='G_LN'
          NOMRES(9)='G_TN'
          NBV = 9
C
C ----   INTERPOLATION DES COEFFICIENTS EN FONCTION DE LA TEMPERATURE
C ----   ET DU TEMPS
C        -----------
          CALL RCVALB(FAMI,KPG,KSP,POUM,MATER,' ',PHENOM,1,NOMPAR,
     &                VALPAR,NBV,NOMRES,VALRES,ICODRE, 1)
C
          E1   = VALRES(1)
          E2   = VALRES(2)
          E3   = VALRES(3)
          NU12 = VALRES(4)
          NU13 = VALRES(5)
          NU23 = VALRES(6)
          NU21 = E2*NU12/E1
          NU31 = E3*NU13/E1
          NU32 = E3*NU23/E2
C
          D1ORTH(1,1) =  UN/E1
          D1ORTH(1,2) = -NU21/E2
          D1ORTH(1,3) = -NU31/E3
          D1ORTH(2,2) =  UN/E2
          D1ORTH(2,3) = -NU32/E3
          D1ORTH(3,3) =  UN/E3
          D1ORTH(2,1) = D1ORTH(1,2)
          D1ORTH(3,1) = D1ORTH(1,3)
          D1ORTH(3,2) = D1ORTH(2,3)
C
          D1ORTH(4,4) = UN/VALRES(7)
          D1ORTH(5,5) = UN/VALRES(8)
          D1ORTH(6,6) = UN/VALRES(9)
C
C ----   CALCUL DE LA MATRICE DE PASSAGE DU REPERE D'ORTHOTROPIE AU
C ----   REPERE GLOBAL POUR L'INVERSE DE LA MATRICE DE HOOKE
C        ---------------------------------------------------
          CALL D1PA3D(XYZGAU, REPERE, IREP, PASSAG)
C
C ----   'INVERSE' DU TENSEUR D'ELASTICITE DANS LE REPERE GLOBAL :
C ----    D1_GLOB = PASSAG_T * D1_ORTH * PASSAG
C ----    (ON NE FAIT REELLEMENT LE PRODUIT QUE SI LA MATRICE
C ----     DE PASSAGE N'EST PAS L'IDENTITE)
C        ----------------------------------
          CALL ASSERT((IREP.EQ.1).OR.(IREP.EQ.0))
          IF (IREP.EQ.1) THEN
              CALL UTBTAB('ZERO',6,6,D1ORTH,PASSAG,WORK,D1)
          ELSEIF (IREP.EQ.0) THEN
              DO 20 I = 1, 6
              DO 20 J = 1, 6
                 D1(I,J) = D1ORTH(I,J)
 20           CONTINUE
          ENDIF
C
C      -----------------------
C ---- CAS ISOTROPE-TRANSVERSE
C      -----------------------
      ELSEIF (PHENOM.EQ.'ELAS_ISTR') THEN
C
          NOMRES(1)='E_L'
          NOMRES(2)='E_N'
          NOMRES(3)='NU_LT'
          NOMRES(4)='NU_LN'
          NOMRES(5)='G_LN'
          NBV = 5
C
C ----   INTERPOLATION DES COEFFICIENTS EN FONCTION DE LA TEMPERATURE
C ----   ET DU TEMPS
C        -----------
          CALL RCVALB(FAMI,KPG,KSP,POUM,MATER,' ',PHENOM,1,NOMPAR,
     &                VALPAR,NBV,NOMRES,VALRES,  ICODRE, 1)
C
          E1   = VALRES(1)
          E3   = VALRES(2)
          NU12 = VALRES(3)
          NU13 = VALRES(4)
          NU31 = E3*NU13/E1
C
          D1ORTH(1,1) =  UN/E1
          D1ORTH(1,2) = -NU12/E1
          D1ORTH(1,3) = -NU31/E3
          D1ORTH(2,1) =  D1ORTH(1,2)
          D1ORTH(2,2) =  UN/E1
          D1ORTH(2,3) = -NU31/E3
          D1ORTH(3,1) =  D1ORTH(1,3)
          D1ORTH(3,2) =  D1ORTH(2,3)
          D1ORTH(3,3) =  UN/E3
          D1ORTH(4,4) =  DEUX*(UN+NU12)/E1
          D1ORTH(5,5) =  UN/VALRES(5)
          D1ORTH(6,6) =  D1ORTH(5,5)
C
C ----   CALCUL DE LA MATRICE DE PASSAGE DU REPERE D'ORTHOTROPIE AU
C ----   REPERE GLOBAL POUR L'INVERSE DE LA MATRICE DE HOOKE
C        ---------------------------------------------------
          CALL D1PA3D(XYZGAU, REPERE, IREP, PASSAG)
C
C ----   'INVERSE' DU TENSEUR D'ELASTICITE DANS LE REPERE GLOBAL :
C ----    D_GLOB = PASSAG_T * D_ORTH * PASSAG
C ----    (ON NE FAIT REELLEMENT LE PRODUIT QUE SI LA MATRICE
C ----     DE PASSAGE N'EST PAS L'IDENTITE)
C        ----------------------------------
          CALL ASSERT((IREP.EQ.1).OR.(IREP.EQ.0))
          IF (IREP.EQ.1) THEN
              CALL UTBTAB('ZERO',6,6,D1ORTH,PASSAG,WORK,D1)
          ELSEIF (IREP.EQ.0) THEN
              DO 30 I = 1, 6
              DO 30 J = 1, 6
                 D1(I,J) = D1ORTH(I,J)
 30           CONTINUE
          ENDIF
C
      ELSE
          CALL U2MESK('F','ELEMENTS_15',1,PHENOM)
      ENDIF
C.============================ FIN DE LA ROUTINE ======================
      END

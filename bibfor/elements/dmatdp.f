      SUBROUTINE DMATDP(FAMI,MATER,INSTAN,POUM,IGAU,ISGAU,REPERE,D)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 07/05/2013   AUTEUR DESOZA T.DESOZA 
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
C
C.======================================================================
C
C      DMATDP --   CALCUL DE LA MATRICE DE HOOKE POUR LES ELEMENTS
C                  MASSIFS 2D EN DEFORMATIONS PLANES OU AXISYMETRIQUES
C                  POUR DES MATERIAUX ISOTROPE, ORTHOTROPE
C                  ET ISOTROPE TRANSVERSE
C
C   ARGUMENT        E/S  TYPE         ROLE
C    FAMI           IN     K4       FAMILLE DU POINT DE GAUSS
C    MATER          IN     I        MATERIAU
C    INSTAN         IN     R        INSTANT DE CALCUL (0 PAR DEFAUT)
C    POUM           IN     K1       + OU -
C    IGAU           IN     I        POINT DE GAUSS
C    ISGAU          IN     I        SOUS-POINT DE GAUSS
C    REPERE(3)      IN     R        VALEURS DEFINISSANT LE REPERE
C                                   D'ORTHOTROPIE
C    D(4,4)         OUT    R        MATRICE DE HOOKE
C
C
C
C.========================= DEBUT DES DECLARATIONS ====================
      IMPLICIT NONE
C -----  ARGUMENTS
      CHARACTER*(*)  FAMI,POUM
      REAL*8   REPERE(7),D(4,4),INSTAN
      INTEGER  MATER,IGAU,ISGAU
C -----  VARIABLES LOCALES
      INTEGER NBRES,I,J,NBV,IREP
      PARAMETER (NBRES=7)

      INTEGER ICODRE(NBRES)
      CHARACTER*8 NOMRES(NBRES),NOMPAR
      CHARACTER*16 PHENOM

      REAL*8 VALRES(NBRES),VALPAR
      REAL*8 PASSAG(4,4),DORTH(4,4),WORK(4,4)
      REAL*8 NU,NU12,NU21,NU13,NU23,NU31,NU32
      REAL*8 ZERO,UNDEMI,UN,DEUX,C10,C01,C20,K
      REAL*8 E,E1,E2,E3,COEF,COEF1,COEF2,COEF3,C1,DELTA,G
C.========================= DEBUT DU CODE EXECUTABLE ==================

C ---- INITIALISATIONS
C      ---------------
      ZERO   = 0.0D0
      UNDEMI = 0.5D0
      UN     = 1.0D0
      DEUX   = 2.0D0
      VALPAR = INSTAN
      NOMPAR = 'INST'

      CALL MATINI(4,4,ZERO,D)
      CALL MATINI(4,4,ZERO,DORTH)
      CALL MATINI(4,4,ZERO,WORK)

C ---- RECUPERATION DU TYPE DU MATERIAU DANS PHENOM
C      --------------------------------------------
      CALL RCCOMA(MATER,'ELAS',1,PHENOM,ICODRE)

C      ------------
C ---- CAS ISOTROPE
C      ------------
      IF (PHENOM.EQ.'ELAS') THEN

         NOMRES(1) = 'E'
         NOMRES(2) = 'NU'
         NBV = 2

C ----   RECUPERATION DES CARACTERISTIQUES MECANIQUES
C        -----------
        CALL RCVALB(FAMI,IGAU,ISGAU,POUM,MATER,' ',PHENOM,1,NOMPAR,
     &              VALPAR,NBV,NOMRES,VALRES,ICODRE,1)


         E  = VALRES(1)
         NU = VALRES(2)

         COEF = UN/ ((UN+NU)* (UN-DEUX*NU))
         COEF1 = E* (UN-NU)*COEF
         COEF2 = E*NU*COEF
         COEF3 = UNDEMI*E/ (UN+NU)

         D(1,1) = COEF1
         D(1,2) = COEF2
         D(1,3) = COEF2

         D(2,1) = COEF2
         D(2,2) = COEF1
         D(2,3) = COEF2

         D(3,1) = COEF2
         D(3,2) = COEF2
         D(3,3) = COEF1

         D(4,4) = COEF3


C      ------------
C ---- CAS ELAS_HYPER
C      ------------
      ELSEIF (PHENOM.EQ.'ELAS_HYPER') THEN

         CALL HYPMAT(FAMI,IGAU,ISGAU,POUM,MATER,C10,C01,C20,K)

         NU =(3.D0*K-4.0D0*(C10+C01))/(6.D0*K+4.0D0*(C10+C01))
         E  = 4.D0*(C10+C01)*(UN+NU)

         COEF = UN/ ((UN+NU)* (UN-DEUX*NU))
         COEF1 = E* (UN-NU)*COEF
         COEF2 = E*NU*COEF
         COEF3 = UNDEMI*E/ (UN+NU)

         D(1,1) = COEF1
         D(1,2) = COEF2
         D(1,3) = COEF2

         D(2,1) = COEF2
         D(2,2) = COEF1
         D(2,3) = COEF2

         D(3,1) = COEF2
         D(3,2) = COEF2
         D(3,3) = COEF1

         D(4,4) = COEF3


C      --------------
C ---- CAS ORTHOTROPE
C      --------------
      ELSE IF (PHENOM.EQ.'ELAS_ORTH') THEN

         NOMRES(1) = 'E_L'
         NOMRES(2) = 'E_T'
         NOMRES(3) = 'E_N'
         NOMRES(4) = 'NU_LT'
         NOMRES(5) = 'NU_LN'
         NOMRES(6) = 'NU_TN'
         NOMRES(7) = 'G_LT'
         NBV = 7

C ----   RECUPERATION DES CARACTERISTIQUES MECANIQUES
C        -----------
        CALL RCVALB(FAMI,IGAU,ISGAU,POUM,MATER,' ',PHENOM,1,NOMPAR,
     &              VALPAR,NBV,NOMRES,VALRES,ICODRE,1)

C
         E1   = VALRES(1)
         E2   = VALRES(2)
         E3   = VALRES(3)
         NU12 = VALRES(4)
         NU13 = VALRES(5)
         NU23 = VALRES(6)
         G    = VALRES(7)
         NU21 = E2*NU12/E1
         NU31 = E3*NU13/E1
         NU32 = E3*NU23/E2
         DELTA = UN-NU23*NU32-NU31*NU13-NU21*NU12-DEUX*NU23*NU31*NU12

         DORTH(1,1) = (UN - NU23*NU32)*E1/DELTA
         DORTH(1,2) = (NU21 + NU31*NU23)*E1/DELTA
         DORTH(1,3) = (NU31 + NU21*NU32)*E1/DELTA
         DORTH(2,2) = (UN - NU13*NU31)*E2/DELTA
         DORTH(2,3) = (NU32 + NU31*NU12)*E2/DELTA
         DORTH(3,3) = (UN - NU21*NU12)*E3/DELTA
         DORTH(2,1) = DORTH(1,2)
         DORTH(3,1) = DORTH(1,3)
         DORTH(3,2) = DORTH(2,3)
C
         DORTH(4,4) = G
C
C ----   CALCUL DE LA MATRICE DE PASSAGE DU REPERE D'ORTHOTROPIE AU
C ----   REPERE GLOBAL POUR LE TENSEUR D'ELASTICITE
C        ------------------------------------------
        CALL DPAO2D(REPERE,IREP,PASSAG)

C ----   TENSEUR D'ELASTICITE DANS LE REPERE GLOBAL :
C ----    D_GLOB = PASSAG_T * D_ORTH * PASSAG
C ----    (ON NE FAIT REELLEMENT LE PRODUIT QUE SI LA MATRICE
C ----     DE PASSAGE N'EST PAS L'IDENTITE)
C        ----------------------------------
        CALL ASSERT((IREP.EQ.1).OR.(IREP.EQ.0))
        IF (IREP.EQ.1) THEN
          CALL UTBTAB('ZERO',4,4,DORTH,PASSAG,WORK,D)
        ELSE IF (IREP.EQ.0) THEN
          DO 40 I = 1,4
            DO 30 J = 1,4
              D(I,J) = DORTH(I,J)
   30       CONTINUE
   40     CONTINUE
        END IF

C      -----------------------
C ---- CAS ISOTROPE-TRANSVERSE
C      -----------------------
      ELSE IF (PHENOM.EQ.'ELAS_ISTR') THEN

         NOMRES(1) = 'E_L'
         NOMRES(2) = 'E_N'
         NOMRES(3) = 'NU_LT'
         NOMRES(4) = 'NU_LN'
         NBV = 4

C ----   RECUPERATION DES CARACTERISTIQUES MECANIQUES
C        -----------
         CALL RCVALB(FAMI,IGAU,ISGAU,POUM,MATER,' ',PHENOM,1,NOMPAR,
     &              VALPAR,NBV,NOMRES,VALRES,ICODRE,1)

         E1 = VALRES(1)
         E3 = VALRES(2)
         NU12 = VALRES(3)
         NU13 = VALRES(4)

         C1 = E1/ (UN+NU12)
         DELTA = UN - NU12 - DEUX*NU13*NU13*E3/E1

         DORTH(1,1) = C1* (UN-NU13*NU13*E3/E1)/DELTA
         DORTH(1,2) = C1* ((UN-NU13*NU13*E3/E1)/DELTA-UN)
         DORTH(1,3) = E3*NU13/DELTA
         DORTH(2,1) = DORTH(1,2)
         DORTH(2,2) = DORTH(1,1)
         DORTH(2,3) = DORTH(1,3)
         DORTH(3,1) = DORTH(1,3)
         DORTH(3,2) = DORTH(2,3)
         DORTH(3,3) = E3* (UN-NU12)/DELTA
         DORTH(4,4) = UNDEMI*C1

C ----   CALCUL DE LA MATRICE DE PASSAGE DU REPERE D'ORTHOTROPIE AU
C ----   REPERE GLOBAL POUR LE TENSEUR D'ELASTICITE
C        ------------------------------------------
        CALL DPAO2D(REPERE,IREP,PASSAG)

C ----   TENSEUR D'ELASTICITE DANS LE REPERE GLOBAL :
C ----    D_GLOB = PASSAG_T * D_ORTH * PASSAG
C ----    (ON NE FAIT REELLEMENT LE PRODUIT QUE SI LA MATRICE
C ----     DE PASSAGE N'EST PAS L'IDENTITE)
C        ----------------------------------
        CALL ASSERT((IREP.EQ.1).OR.(IREP.EQ.0))
        IF (IREP.EQ.1) THEN
          CALL UTBTAB('ZERO',4,4,DORTH,PASSAG,WORK,D)
        ELSE IF (IREP.EQ.0) THEN
          DO 60 I = 1,4
            DO 50 J = 1,4
              D(I,J) = DORTH(I,J)
   50       CONTINUE
   60     CONTINUE
        END IF

      ELSE
        CALL U2MESK('F','ELEMENTS_15',1,PHENOM)
      END IF
C.============================ FIN DE LA ROUTINE ======================
      END

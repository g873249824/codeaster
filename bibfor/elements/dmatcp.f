      SUBROUTINE DMATCP(MATER,TEMPE,HYDR,SECH,INSTAN,REPERE,D)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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

C      DMATCP --   CALCUL DE LA MATRICE DE HOOKE POUR LES ELEMENTS
C                  MASSIFS 2D EN CONTRAINTES PLANES
C                  POUR DES MATERIAUX ISOTROPE, ORTHOTROPE
C                  ET ISOTROPE TRANSVERSE

C   ARGUMENT        E/S  TYPE         ROLE
C    MATER          IN     I        MATERIAU
C    TEMPE          IN     R        TEMPERATURE AU POINT D'INTEGRATION
C    HYDR           IN     R        HYDRATATION AU POINT D'INTEGRATION
C    SECH           IN     R        SECHAGE AU POINT D'INTEGRATION
C    INSTAN         IN     R        INSTANT DE CALCUL (0 PAR DEFAUT)
C    REPERE(3)      IN     R        VALEURS DEFINISSANT LE REPERE
C                                   D'ORTHOTROPIE
C    D(4,4)         OUT    R        MATRICE DE HOOKE

C.======================================================================

      IMPLICIT NONE
C -----  ARGUMENTS
      REAL*8   TEMPE,REPERE(7),D(4,4),INSTAN,HYDR,SECH
      INTEGER  MATER
C -----  VARIABLES LOCALES
      INTEGER   NBRES,I,J,NBV,IREP
      PARAMETER (NBRES=7)

      CHARACTER*2  CODRET(NBRES)
      CHARACTER*8  NOMRES(NBRES),NOMPAR(4)
      CHARACTER*16 PHENOM

      REAL*8 VALRES(NBRES),VALPAR(4),ZERO,UNDEMI,UN
      REAL*8 PASSAG(4,4),DORTH(4,4),WORK(4,4),E,NU
      REAL*8 E1,E2,NU12,NU21,C1,DELTA,G12
C.========================= DEBUT DU CODE EXECUTABLE ==================

C ---- INITIALISATIONS
C      ---------------
      ZERO   = 0.0D0
      UNDEMI = 0.5D0
      UN     = 1.0D0

      NOMPAR(1) = 'TEMP'
      NOMPAR(2) = 'INST'
      NOMPAR(3) = 'HYDR'
      NOMPAR(4) = 'SECH'
      VALPAR(1) = TEMPE
      VALPAR(2) = INSTAN
      VALPAR(3) = HYDR
      VALPAR(4) = SECH

      DO 20 I = 1,4
        DO 10 J = 1,4
          D(I,J) = ZERO
          DORTH(I,J) = ZERO
          WORK(I,J) = ZERO
   10   CONTINUE
   20 CONTINUE

C ---- RECUPERATION DU TYPE DU MATERIAU DANS PHENOM
C      --------------------------------------------
      CALL RCCOMA(MATER,'ELAS',PHENOM,CODRET)

C      ------------
C ---- CAS ISOTROPE
C      ------------
      IF (PHENOM.EQ.'ELAS') THEN

         NOMRES(1) = 'E'
         NOMRES(2) = 'NU'
         NBV = 2

C ----   INTERPOLATION DES COEFFICIENTS EN FONCTION DE LA TEMPERATURE
C ----   ET DU TEMPS
C        -----------
         CALL RCVALA(MATER,' ',PHENOM,4,NOMPAR,VALPAR,NBV,NOMRES,VALRES,
     &              CODRET,'FM')

         E  = VALRES(1)
         NU = VALRES(2)

         D(1,1) = E/ (UN-NU*NU)
         D(1,2) = D(1,1)*NU

         D(2,1) = D(1,2)
         D(2,2) = D(1,1)

         D(4,4) = UNDEMI*E/ (UN+NU)


C      --------------
C ---- CAS ORTHOTROPE
C      --------------
      ELSE IF (PHENOM.EQ.'ELAS_ORTH') THEN

         NOMRES(1) = 'E_L'
         NOMRES(2) = 'E_T'
         NOMRES(3) = 'NU_LT'
         NOMRES(4) = 'G_LT'
         NBV = 4

C ----   INTERPOLATION DES COEFFICIENTS EN FONCTION DE LA TEMPERATURE
C ----   ET DU TEMPS
C        -----------
         CALL RCVALA(MATER,' ',PHENOM,4,NOMPAR,VALPAR,NBV,NOMRES,VALRES,
     &              CODRET,'FM')

C
         E1    = VALRES(1)
         E2    = VALRES(2)
         NU12  = VALRES(3)
         G12   = VALRES(4)
         NU21  = E2*NU12/E1
         DELTA = UN-NU12*NU21
C
         DORTH(1,1) = E1/DELTA
         DORTH(1,2) = NU12*E2/DELTA
         DORTH(2,2) = E2/DELTA
         DORTH(2,1) = DORTH(1,2)
C
         DORTH(4,4) = G12

C ----   CALCUL DE LA MATRICE DE PASSAGE DU REPERE D'ORTHOTROPIE AU
C ----   REPERE GLOBAL POUR LE TENSEUR D'ELASTICITE
C        ------------------------------------------
        CALL DPAO2D(REPERE,IREP,PASSAG)

C ----   TENSEUR D'ELASTICITE DANS LE REPERE GLOBAL :
C ----    D_GLOB = PASSAG_T * D_ORTH * PASSAG
C ----    (ON NE FAIT REELLEMENT LE PRODUIT QUE SI LA MATRICE
C ----     DE PASSAGE N'EST PAS L'IDENTITE)
C        ----------------------------------
        IF (IREP.EQ.1) THEN
          CALL UTBTAB('ZERO',4,4,DORTH,PASSAG,WORK,D)
        ELSE IF (IREP.EQ.0) THEN
          DO 40 I = 1,4
            DO 30 J = 1,4
              D(I,J) = DORTH(I,J)
   30       CONTINUE
   40     CONTINUE
        ELSE
          CALL U2MESS('F','ELEMENTS_22')
        END IF


C      -----------------------
C ---- CAS ISOTROPE-TRANSVERSE
C      -----------------------
      ELSE IF (PHENOM.EQ.'ELAS_ISTR') THEN

         NOMRES(1) = 'E_L'
         NOMRES(2) = 'NU_LT'
         NBV = 2

C ----   INTERPOLATION DES COEFFICIENTS EN FONCTION DE LA TEMPERATURE
C ----   ET DU TEMPS
C        -----------
         CALL RCVALA(MATER,' ',PHENOM,4,NOMPAR,VALPAR,NBV,NOMRES,VALRES,
     &              CODRET,'FM')

         E  = VALRES(1)
         NU = VALRES(2)

         C1 = E/ (UN+NU)
         DELTA = UN - NU*NU

         D(1,1) = E/DELTA
         D(1,2) = NU*D(1,1)
         D(2,1) = D(1,2)
         D(2,2) = D(1,1)
         D(4,4) = UNDEMI*C1

      ELSE
        CALL U2MESK('F','ELEMENTS_15',1,PHENOM)
      END IF
C.============================ FIN DE LA ROUTINE ======================
      END

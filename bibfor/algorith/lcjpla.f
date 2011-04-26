        SUBROUTINE LCJPLA (FAMI,KPG,KSP,LOI,MOD,NR,IMAT,NMAT,MATER,NVI,
     &                     DEPS,SIGF,VIN,DSDE,SIGD,VIND,VP,VECP,
     &                     THETA, DT, DEVG, DEVGII,CODRET)
        IMPLICIT   NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C       ----------------------------------------------------------------
C       MATRICE SYMETRIQUE DE COMPORTEMENT TANGENT ELASTO-PLASTIQUE
C       VISCO-PLASTIQUE EN VITESSE A T+DT OU T
C       IN  FAMI   :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C           KPG,KSP:  NUMERO DU (SOUS)POINT DE GAUSS
C           LOI    :  MODELE DE COMPORTEMENT
C           MOD    :  TYPE DE MODELISATION
C           IMAT   :  ADRESSE DU MATERIAU CODE
C           NMAT   :  DIMENSION MATER
C           MATER  :  COEFFICIENTS MATERIAU
C           NVI    :  NB VARIABLES INTERNES
C           NR     :  NB DE TERME DANS LE SYSTEME DE NEWTOW
C           DEPS   :  INCREMENT DE DEFORMATION
C           SIGF   :  CONTRAINTE A L INSTANT +
C           VIN    :  VARIABLES INTERNES A L INSTANT +
C           SIGD   :  CONTRAINTE A L INSTANT -
C           VIND   :  VARIABLES INTERNES A L INSTANT -
C           THETA  :  ?? COMP_INCR/PARM_THETA
C           DT     :  ??
C           DEVG   :  ??
C           DEVGII :  ??
C       OUT DSDE   :  MATRICE DE COMPORTEMENT TANGENT = DSIG/DEPS
C           VP     : VALEURS PROPRES DU DEVIATEUR ELASTIQUE (HOEK-BROWN)
C           VECP   : VECTEURS PROPRES DU DEVIATEUR ELASTIQUE(HOEK-BROWN)
C           CODRET : CODE RETOUR
C                    = 0, TOUT VA BIEN PAS DE REDECOUPAGE
C                    = 1 ou 2, CORRESPOND AU CODE RETOUR DE PLASTI.F
C       ----------------------------------------------------------------
C TOLE CRP_21
      INTEGER         IMAT, NMAT , NVI, NR,KPG,KSP,CODRET
      REAL*8          DSDE(6,6),DEVG(*),DEVGII,SIGF(6),DEPS(6)
      REAL*8          VIN(*), VIND(*),THETA,DT,MATER(NMAT,2)
      REAL*8          VP(3),VECP(3,3),SIGD(6)
      CHARACTER*8     MOD
      CHARACTER*16    LOI
      CHARACTER*(*)   FAMI
C       ----------------------------------------------------------------

      CODRET = 0

      IF     ( LOI(1:8) .EQ. 'ROUSS_PR' .OR.
     &         LOI(1:10) .EQ. 'ROUSS_VISC' ) THEN
         CALL RSLJPL(FAMI,KPG,KSP,LOI,IMAT,NMAT,MATER,
     &               SIGF,VIN,VIND,DEPS,THETA,DT,DSDE)
C
      ELSEIF ( LOI(1:6) .EQ. 'LAIGLE'   ) THEN
         CALL LGLJPL(MOD,NMAT,MATER,SIGF,DEVG,DEVGII,VIN,DSDE,CODRET)
C
      ELSEIF ( (LOI(1:10) .EQ. 'HOEK_BROWN').OR.
     &         (LOI(1:14) .EQ. 'HOEK_BROWN_EFF') )THEN
         CALL HBRJPL(MOD,NMAT,MATER,SIGF,VIN,VIND,VP,VECP,DSDE)
C
      ELSEIF ( LOI(1:7) .EQ. 'IRRAD3M' ) THEN
         CALL IRRJPL(MOD,NMAT,MATER,SIGF,VIND,VIN,DSDE)
      ENDIF
C
      END

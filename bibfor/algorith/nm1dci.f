      SUBROUTINE NM1DCI(IMATE,TEMPM,TEMPP,TREF,EM,EP,ALPHAM,ALPHAP,SIGM,
     &                  DEPS,VIM,OPTION,SIGP,VIP,DSDE)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/12/2003   AUTEUR PBADEL P.BADEL 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C ----------------------------------------------------------------------

      IMPLICIT NONE
C ----------------------------------------------------------------------
C          PLASTICITE VON MISES CINEMATIQUE BILINEAIRE MONODIM
C          ON PEUT AVOIR T0 DIFF TREF

C IN IMATE  : POINTEUR MATERIAU
C IN  TEMPP        : TEMPERATURE PLUS
C IN  TEMPM       : TEMPERATURE MOINS
C IN  EM        : MODULE D YOUNG MOINS
C IN  EP        : MODULE D YOUNG PLUS
C IN  ALPHAM     : COEF DILAT THERMIQUE MOINS
C IN  ALPHAM     : COEF DILAT THERMIQUE PLUS

C IN  SIGM    : CONTRAINTE AU TEMPS MOINS
C IN  DEPS    : DEFORMATION  TOTALE PLUS - DEFORMATION MOINS
C IN  VIM     : VARIABLE INTERNES MOINS
C IN  OPTION     : OPTION DE CALCUL

C OUT SIG     : CONTRAINTES PLUS
C OUT VIP     : VARIABLE INTERNES PLUS
C OUT DSDE    : DSIG/DEPS
C     ------------------------------------------------------------------
C     ARGUMENTS
C     ------------------------------------------------------------------
      REAL*8 TEMPP,TEMPM,EP,EM,ALPHAM,ALPHAP,SIGY,TREF
      REAL*8 SIGM,DEPS,VIM(2)
      REAL*8 SIGP,VIP(2),DSDE,SIELEQ
      CHARACTER*16 OPTION
      INTEGER IMATE
C     ------------------------------------------------------------------
C     VARIABLES LOCALES
C     ------------------------------------------------------------------
      REAL*8 SIGE,DP,VALPAR,VALRES(2),DEPSTH,ETM,ETP,XP,XM,HM,HP
      CHARACTER*2 FB2,CODRES(2)
      CHARACTER*8 NOMPAR,NOMECL(2)
      INTEGER NBPAR
      DATA NOMECL/'D_SIGM_EPSI','SY'/
C     ------------------------------------------------------------------
      VALPAR = TEMPM
      NBPAR = 1
      NOMPAR = 'TEMP'
      FB2 = 'FM'
      CALL RCVALA(IMATE,'ECRO_LINE',NBPAR,NOMPAR,VALPAR,1,NOMECL,VALRES,
     &            CODRES,FB2)
      ETM = VALRES(1)
      HM = EM*ETM/ (EM-ETM)

      VALPAR = TEMPP
      CALL RCVALA(IMATE,'ECRO_LINE',NBPAR,NOMPAR,VALPAR,2,NOMECL,VALRES,
     &            CODRES,FB2)
      ETP = VALRES(1)
      HP = EP*ETP/ (EP-ETP)
      SIGY = VALRES(2)
      XM = VIM(1)
C     ------------------------------------------------------------------
      DEPSTH = ALPHAP* (TEMPP-TREF) - ALPHAM* (TEMPM-TREF)
      SIGE = EP* (SIGM/EM+DEPS-DEPSTH) - HP/HM*XM

      SIELEQ = ABS(SIGE)
C     ------------------------------------------------------------------
C     CALCUL EPSP, P , SIG
C     ------------------------------------------------------------------
      IF (OPTION(1:9).EQ.'FULL_MECA' .OR. OPTION.EQ.'RAPH_MECA') THEN
        IF (SIELEQ.LE.SIGY) THEN
          VIP(2) = 0.D0
          DSDE = EP
          DP = 0.D0
          XP = HP/HM*XM 
          SIGP = EP* (SIGM/EM+DEPS-DEPSTH)
          VIP(1) = XP
        ELSE
          VIP(2) = 1.D0
          DP = (SIELEQ-SIGY)/ (EP+HP)
          IF (OPTION.EQ.'FULL_MECA_ELAS') THEN
            DSDE = EP
          ELSE
            DSDE = ETP
          ENDIF
          XP = HP/HM*XM + HP*DP*SIGE/SIELEQ
          SIGP = XP + SIGY*SIGE/SIELEQ
          VIP(1) = XP
        END IF
      END IF
      IF (OPTION(1:10).EQ.'RIGI_MECA_') THEN
        IF ((VIM(2).LT.0.5D0).OR.(OPTION.EQ.'RIGI_MECA_ELAS')) THEN
          DSDE = EP
        ELSE
          DSDE = ETP
        END IF
      END IF
      END

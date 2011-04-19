      SUBROUTINE NM1DIS(FAMI,KPG,KSP,IMATE,EM,EP,SIGM,
     &                  DEPS,VIM,OPTION,COMPOR,MATERI,SIGP,VIP,DSDE)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/04/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C          PLASTICITE VON MISES ISOTROPE BILINEAIRE MONODIM
C          ON PEUT AVOIR T0 DIFF TREF


C IN  T        : TEMPERATURE PLUS
C IN  TM       : TEMPERATURE MOINS
C IN  E        : MODULE D YOUNG
C IN  ET       : PENTE D ECROUISSAGE
C IN  ALPH     : COEF DILAT THERMIQUE
C IN  SY       : LIMITE D ELASTICITE INITIALE

C IN  SIGM    : CONTRAINTE AU TEMPS MOINS
C               UTILISE UNIQUEMENT POUR EVALUER DSDEM
C IN  DEPS    : DEFORMATION  TOTALE PLUS - DEFORMATION MOINS
C                    - INCREMENT DEFORMATION THERMIQUE
C IN  EPSPM   : DEFORMATION  PLASTIQUE MOINS
C IN  PM      : DEFORMATION  PLASTIQUE CUMULEE MOINS

C OUT SIG     : CONTRAINTES PLUS
C OUT EPSP    : DEFORMATION  PLASTIQUE PLUS
C OUT P       : DEFORMATION  PLASTIQUE CUMULEE PLUS
C OUT DSDE    : DSIG/DEPS
C     ------------------------------------------------------------------
C     ARGUMENTS
C     ------------------------------------------------------------------
      REAL*8 EM,EP,ET,SIGY
      REAL*8 SIGM,DEPS,PM,VIM(*),VIP(*),RESU
      REAL*8 SIGP,DSDE,RBID
      CHARACTER*16 OPTION,COMPOR(*)
      CHARACTER*(*) FAMI,MATERI
      INTEGER KPG,KSP,IMATE
C     ------------------------------------------------------------------
C     VARIABLES LOCALES
C     ------------------------------------------------------------------
      REAL*8 RPRIM,RM,SIGE,VALPAR,VALRES(2),AIRERP,DUM
      REAL*8 SIELEQ,RP,DP,NU,ASIGE
      INTEGER JPROLM,JVALEM,NBVALM,NBVALP,JPROLP,JVALEP,IRET
      INTEGER ICODRE(2)
      CHARACTER*8 NOMPAR,NOMECL(2),TYPE
      DATA NOMECL /'D_SIGM_E','SY'/



      NOMPAR = 'TEMP'
      PM = VIM(1)

C --- CARACTERISTIQUES ECROUISSAGE LINEAIRE

      IF ((COMPOR(1).EQ.'VMIS_ISOT_LINE') .OR.
     &   (COMPOR(1).EQ.'GRILLE_ISOT_LINE')) THEN
        CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,MATERI,'ECRO_LINE',
     &              0,' ',0.D0,1,NOMECL,
     &              VALRES,ICODRE,1)
        CALL RCVALB(FAMI,KPG,KSP,'+',IMATE,MATERI,'ECRO_LINE',
     &              0,' ',0.D0,1,
     &             NOMECL(2), VALRES(2),ICODRE(2),0)
        IF (ICODRE(2).NE.0) VALRES(2) = 0.D0
        ET = VALRES(1)
        SIGY = VALRES(2)
        RPRIM = EP*ET/ (EP-ET)
        RM = RPRIM*VIM(1) + SIGY

C --- CARACTERISTIQUES ECROUISSAGE DONNE PAR COURBE DE TRACTION

      ELSE IF (COMPOR(1).EQ.'VMIS_ISOT_TRAC') THEN
        CALL RCVARC(' ','TEMP','-',FAMI,KPG,KSP,VALPAR,IRET)
        CALL RCTYPE(IMATE,1,NOMPAR,VALPAR,RESU,TYPE)
        IF ((TYPE.EQ.'TEMP').AND.(IRET.EQ.1))
     &  CALL U2MESS('F','CALCULEL_31')
        CALL RCTRAC(IMATE,1,'SIGM',RESU,JPROLM,JVALEM,NBVALM,
     &              EM)
        CALL RCVARC(' ','TEMP','+',FAMI,KPG,KSP,VALPAR,IRET)
        CALL RCTYPE(IMATE,1,NOMPAR,VALPAR,RESU,TYPE)
        IF ((TYPE.EQ.'TEMP').AND.(IRET.EQ.1))
     &       CALL U2MESS('F','CALCULEL_31')
        CALL RCTRAC(IMATE,1,'SIGM',RESU,JPROLP,JVALEP,NBVALP,
     &              EP)
        CALL RCFONC('S',1,JPROLP,JVALEP,NBVALP,SIGY,DUM,DUM,
     &              DUM,DUM,DUM,DUM,DUM,DUM)
        CALL RCFONC('V',1,JPROLP,JVALEP,NBVALP,RBID,RBID,RBID,
     &              VIM(1),RM,RPRIM,AIRERP,RBID,RBID)
        ET=RPRIM
      END IF
C     ------------------------------------------------------------------
C     ESTIMATION ELASTIQUE
C     ------------------------------------------------------------------
      SIGE = EP* (SIGM/EM+DEPS)
      SIELEQ = ABS(SIGE)
C     ------------------------------------------------------------------
C     CALCUL EPSP, P , SIG
C     ------------------------------------------------------------------
      IF (OPTION(1:9).EQ.'FULL_MECA' .OR. OPTION.EQ.'RAPH_MECA') THEN
        IF (SIELEQ.LE.RM) THEN
          DP=0.D0
          SIGP = SIGE
          DSDE = EP
          VIP(2) = 0.D0
          VIP(1) = VIM(1)
          SIGP = SIGE
        ELSE
          VIP(2) = 1.D0
          IF ((COMPOR(1).EQ.'VMIS_ISOT_LINE') .OR.
     &     (COMPOR(1).EQ.'GRILLE_ISOT_LINE')) THEN
            DP = ABS(SIGE) - RM
            DP = DP/ (RPRIM+EP)
            RP = SIGY + RPRIM* (PM+DP)
            IF (OPTION.EQ.'FULL_MECA_ELAS') THEN
              DSDE = EP
            ELSE
              DSDE = ET
            ENDIF
          ELSE
            NU=0.5D0
            ASIGE=ABS(SIGE)
            CALL RCFONC('E',1,JPROLP,JVALEP,NBVALP,RBID,EP,
     &                  NU,VIM(1),RP,RPRIM,AIRERP,ASIGE,DP)
            IF (OPTION.EQ.'FULL_MECA_ELAS') THEN
              DSDE = EP
            ELSE
              DSDE = EP*RPRIM/ (EP+RPRIM)
            ENDIF
          END IF
          VIP(1) = VIM(1) + DP
          SIGP = SIGE/ (1.D0+EP*DP/RP)
        END IF
      END IF
      IF (OPTION(1:10).EQ.'RIGI_MECA_') THEN
        IF ((VIM(2).LT.0.5D0).OR.(OPTION.EQ.'RIGI_MECA_ELAS')) THEN
          DSDE = EP
        ELSE
          DSDE = ET
        END IF
      END IF
      END

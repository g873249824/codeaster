      SUBROUTINE PMFCOM(OPTION,COMPO,NF,TREF,TEMPM,TEMPP,E,ALPHA,ICDMAT,
     +                  NBVALC,VARIM,CONTM,DEFM,DEFP,MODF,SIGF,VARIP)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 09/09/2002   AUTEUR MJBHHPE J.L.FLEJOU 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C              SEE THE FILE "LICENSE.TERMS" FOR INFORMATION ON USAGE AND
C              REDISTRIBUTION OF THIS FILE.
C ======================================================================
      IMPLICIT NONE
      CHARACTER*16 OPTION,COMPO
      INTEGER NF,ICDMAT,NBVALC
      REAL*8 E,VARIM(NBVALC*NF),CONTM(NF),DEFM(NF),DEFP(NF),MODF(NF),
     +       SIGF(NF),VARIP(NBVALC*NF),SIGP(6)
      REAL*8 TEMPM,TEMPP,ALPHA,DSIDEP(6,6),TREF,SIGM(6),EPS(6),DEPS(6)
C     ------------------------------------------------------------------
C     AIGUILLAGE COMPORTEMENT DES ELEMENTS DE POUTRE MULTIFIBRES

C IN  COMPO : NOM DU COMPORTEMENT
C IN  NF    : NOMBRE DE FIBRES
C IN  E     : MODULE D'YOUNG (ELASTIQUE)
C IN  ICDMAT : CODE MATERIAU
C IN  NV    : NOMBRE DE VARIABLES INTERNES DU MODELE
C IN  VARIM : VARIABLES INTERNES MOINS
C IN  CONTM : CONTRAINTES MOINS (ATTENTION POUR L'INSTANT EFGEGA ET
C             PAS PAR FIBR
C IN  DEFM  : DEFORMATION MOINS
C IN  DEFP  : INCREMENT DE DEFORMATION

C OUT MODF  : MODULE TANGENT DES FIBRES
C OUT SIGF  : CONTRAINTE PLUS DES FIBRES
C OUT VARIP : VARIABLES INTERNES PLUS
C     ------------------------------------------------------------------
      INTEGER NBVAL,NBPAR,NBRES
      PARAMETER (NBVAL=12)
      REAL*8 VALPAR,VALRES(NBVAL)
      CHARACTER*2 ARRET,RETOUR,CODRES(NBVAL)
      CHARACTER*8 NOMPAR,NOECLB(9),NOMPIM(12),NOMMIS(2)
      REAL*8 A1,A2,BETA1,BETA2,Y01,Y02,B1,B2,SIGF1
      REAL*8 CSTPM(13),ET,SY,MODFM
      INTEGER I,IVARI,J
      DATA ARRET,RETOUR/'FM','  '/
      DATA NOECLB/'Y01','Y02','A1','A2','B1','B2','BETA1','BETA2',
     +     'SIGF'/
      DATA NOMPIM/'SY','EPSI_ULTM','SIGM_ULTM','EPSP_HARD','R_PM',
     +     'EP_SUR_E','A1_PM','A2_PM','ELAN','A6_PM','C_PM','A_PM'/
      DATA NOMMIS/'D_SIGM_EPSI','SY'/


      IF (COMPO.EQ.'ELAS') THEN
        DO 10 I = 1,NF
          MODF(I) = E
          SIGF(I) = E* (DEFM(I)+DEFP(I))
   10   CONTINUE
      ELSE IF (COMPO.EQ.'LABORD_1D') THEN
C ---   ON RECUPERE LES PARAMETRES MATERIAU
        CALL R8INIR(NBVAL,0.D0,VALRES,1)
        NBPAR = 0
        NOMPAR = '  '
        VALPAR = 0.D0
        NBRES = 9
        CALL RCVALA(ICDMAT,'LABORD_1D',NBPAR,NOMPAR,VALPAR,NBRES,
     +              NOECLB,VALRES,CODRES,ARRET)
        Y01 = VALRES(1)
        Y02 = VALRES(2)
        A1 = VALRES(3)
        A2 = VALRES(4)
        B1 = VALRES(5)
        B2 = VALRES(6)
        BETA1 = VALRES(7)
        BETA2 = VALRES(8)
        SIGF1 = VALRES(9)
C ---   BOUCLE COMPORTEMENT SUR CHAQUE FIBRE
        DO 20 I = 1,NF
          IVARI = NBVALC* (I-1) + 1
          CALL NMCB1D(E,Y01,Y02,A1,A2,B1,B2,BETA1,BETA2,SIGF1,ALPHA,
     +                TREF,TEMPM,TEMPP,CONTM(I),VARIM(IVARI),DEFM(I),
     +                DEFP(I),MODF(I),SIGF(I),VARIP(IVARI))
   20   CONTINUE
      ELSE IF (COMPO.EQ.'PINTO_MENEGOTTO') THEN
        NBRES = 12
        CALL R8INIR(NBVAL,0.D0,VALRES,1)
        NBPAR = 0
        NOMPAR = '  '
        VALPAR = 0.D0
        CALL RCVALA(ICDMAT,'PINTO_MENEGOTTO',NBPAR,NOMPAR,VALPAR,NBRES,
     +              NOMPIM,VALRES,CODRES,RETOUR)
        IF (CODRES(7).NE.'OK') VALRES(7) = -1.D0
        CSTPM(1) = E
        DO 30 I = 1,12
          CSTPM(I+1) = VALRES(I)
   30   CONTINUE
        DO 40 I = 1,NF
          IVARI = NBVALC* (I-1) + 1
          CALL NM1DPM(OPTION,NBVALC,ALPHA,TEMPM,13,CSTPM,CONTM(I),
     +                VARIM(IVARI),TEMPP,DEFP(I),VARIP(IVARI),SIGF(I),
     +                MODF(I))
   40   CONTINUE

      ELSE IF (COMPO.EQ.'VMIS_ISOT_LINE' .OR.
     +         COMPO.EQ.'VMIS_CINE_LINE') THEN
        NBRES = 2
        CALL R8INIR(NBVAL,0.D0,VALRES,1)
        NBPAR = 0
        NOMPAR = '  '
        VALPAR = 0.D0
        CALL RCVALA(ICDMAT,'ECRO_LINE',NBPAR,NOMPAR,VALPAR,NBRES,NOMMIS,
     +              VALRES,CODRES,ARRET)
        ET = VALRES(1)
        SY = VALRES(2)
        IF (COMPO.EQ.'VMIS_CINE_LINE') THEN
          DO 50 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
            CALL NM1DCI(TEMPM,TEMPP,E,ET,ALPHA,SY,CONTM(I),DEFP(I),
     +                  VARIM(IVARI),VARIM(IVARI+1),SIGF(I),
     +                  VARIP(IVARI),VARIP(IVARI+1),MODFM,MODF(I))
   50     CONTINUE
        ELSE
          DO 60 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
            CALL NM1DIS(TEMPM,TEMPP,E,ET,ALPHA,SY,CONTM(I),DEFP(I),
     +                  VARIM(IVARI),VARIM(IVARI+1),SIGF(I),
     +                  VARIP(IVARI),VARIP(IVARI+1),MODFM,MODF(I))
   60     CONTINUE
        END IF
      ELSE IF (COMPO.EQ.'VMIS_ISOT_TRAC') THEN
        DO 55 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
            CALL NM1TRA(ICDMAT,TEMPP,DEFM(I),DEFP(I),
     +                  VARIM(IVARI),VARIM(IVARI+1),
     +                  SIGF(I),VARIP(IVARI),VARIP(IVARI+1),MODF(I))
55      CONTINUE
      ELSE
          DO 70 I = 1,NF
            IVARI = NBVALC* (I-1) + 1
            SIGM(1) = CONTM(I)
            SIGM(2) = 0.D0
            SIGM(3) = 0.D0
            SIGM(4) = 0.D0
            SIGM(5) = 0.D0
            SIGM(6) = 0.D0
C
            EPS(1) = DEFM(I)
            EPS(2) = 0.D0
            EPS(3) = 0.D0
            EPS(4) = 0.D0
            EPS(5) = 0.D0
            EPS(6) = 0.D0
C
            DEPS(1) = DEFP(I)
            DEPS(2) = -(EPS(1)+DEPS(1))
            DEPS(3) = 0.D0
            DEPS(4) = 0.D0
            DEPS(5) = 0.D0
            DEPS(6) = 0.D0
            CALL COMP1D(OPTION,SIGM,EPS,DEPS,TREF,
     +        TEMPM,TEMPP,VARIM(IVARI),VARIP(IVARI),SIGP,DSIDEP)
            SIGF(I)=SIGP(1)
            MODF(I)=DSIDEP(1,1)
   70     CONTINUE
      END IF

      END

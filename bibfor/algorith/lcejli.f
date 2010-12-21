      SUBROUTINE LCEJLI(FAMI,KPG,KSP,NDIM,MATE,OPTION,AM,DA,SIGMA,
     &                  DSIDEP,VIM,VIP)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/12/2010   AUTEUR PELLET J.PELLET 
C TOLE CRS_1404
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE LAVERNE J.LAVERNE

      IMPLICIT NONE
      INTEGER MATE,NDIM,KPG,KSP
      REAL*8  AM(NDIM),DA(NDIM),SIGMA(6),DSIDEP(6,6)
      REAL*8  VIM(*),VIP(*)
      CHARACTER*16 OPTION
      CHARACTER*(*)  FAMI

C-----------------------------------------------------------------------
C LOI DE COMPORTEMENT COHESIVE : CZM_LIN_REG
C POUR LES ELEMENTS DE JOINT 2D ET 3D
C
C IN : AM SAUT INSTANT - : AM(1) = SAUT NORMAL, AM(2) = SAUT TANGENTIEL
C IN : DA    INCREMENT DE SAUT
C IN : MATE, OPTION, VIM
C OUT : SIGMA , DSIDEP , VIP
C-----------------------------------------------------------------------

      LOGICAL RESI, RIGI, ELAS
      INTEGER I,J,DISS,CASS
      REAL*8  SC,GC,LC,K0,VAL(4),VALPA,RTAN
      REAL*8  A(NDIM),NA,KA,KAP,R0,RC,BETA,RK,RA,COEF,COEF2
      CHARACTER*2 COD(5)
      CHARACTER*8 NOM(4)
      CHARACTER*1 POUM

C OPTION CALCUL DU RESIDU OU CALCUL DE LA MATRICE TANGENTE

      RESI = OPTION(1:9).EQ.'FULL_MECA' .OR. OPTION.EQ.'RAPH_MECA'
      RIGI = OPTION(1:9).EQ.'FULL_MECA' .OR. OPTION(1:9).EQ.'RIGI_MECA'
      ELAS = OPTION.EQ.'FULL_MECA_ELAS' .OR. OPTION.EQ.'RIGI_MECA_ELAS'


C CALCUL DU SAUT EN T+

      CALL DCOPY(NDIM,AM,1,A,1)
      IF (RESI) CALL DAXPY(NDIM,1.D0,DA,1,A,1)


C RECUPERATION DES PARAMETRES PHYSIQUES

      NOM(1) = 'GC'
      NOM(2) = 'SIGM_C'
      NOM(3) = 'PENA_ADHERENCE'
      NOM(4) = 'PENA_CONTACT'

      IF (OPTION.EQ.'RIGI_MECA_TANG') THEN
        POUM = '-'
      ELSE
        POUM = '+'
      ENDIF

      CALL RCVALB(FAMI,KPG,KSP,POUM,MATE,' ','RUPT_FRAG',0,' ',
     &            0.D0,4,NOM,VAL,COD,'F ')

      GC   = VAL(1)
      SC   = VAL(2)
      LC   = 2*GC/SC
      K0   = LC*VAL(3)
      R0   = SC*(1.D0-K0/LC)/K0
      BETA = VAL(4)

C INITIALISATION

      KA = MAX(K0,VIM(1))
      RTAN = 0.D0
      DO 10 I = 2,NDIM
        RTAN=RTAN+A(I)**2
10    CONTINUE
      NA = SQRT( MAX(0.D0,A(1))**2 + RTAN )

      RK = SC*(1.D0-KA/LC)/KA
      RC = RK + BETA*(R0-RK)


C INITIALISATION COMPLEMENTAIRE POUR RIGI_MECA_TANG (SECANTE PENALISEE)

      IF (.NOT. RESI) THEN

        IF (ELAS) THEN
          DISS = 0
        ELSE
          DISS = NINT(VIM(2))
        END IF

        CASS = NINT(VIM(3))

        GOTO 5000
      END IF

C CALCUL DE LA CONTRAINTE

      CALL R8INIR(6, 0.D0, SIGMA,1)

C     CONTRAINTE DE CONTACT PENALISE
      SIGMA(1) = RC * MIN(0.D0,A(1))

C     CONTRAINTE DE FISSURATION
      IF ((NA.GE.LC) .OR. (KA.GE.LC)) THEN

        DISS = 0
        CASS = 2

      ELSE

        IF (NA.LE.KA) THEN

          DISS = 0
          IF (KA.GT.K0) THEN
            CASS = 1
          ELSE
            CASS = 0
          ENDIF
          SIGMA(1) = SIGMA(1) + RK*MAX(0.D0,A(1))
          DO 20 I=2,NDIM
            SIGMA(I) = SIGMA(I) + RK*A(I)
20        CONTINUE

        ELSE

          DISS = 1
          CASS = 1
          RA = SC*(1.D0 - NA/LC)/NA
          SIGMA(1) = SIGMA(1) + RA*MAX(0.D0,A(1))
          DO 30 I=2,NDIM
            SIGMA(I) = SIGMA(I) + RA*A(I)
30        CONTINUE

        ENDIF

      ENDIF

C ACTUALISATION DES VARIABLES INTERNES
C   V1 :  SEUIL, PLUS GRANDE NORME DU SAUT
C   V2 :  INDICATEUR DE DISSIPATION (0 : NON, 1 : OUI)
C   V3 :  INDICATEUR D'ENDOMMAGEMENT  (0 : SAIN, 1: ENDOM, 2: CASSE)
C   V4 :  POURCENTAGE D'ENERGIE DISSIPEE
C   V5 :  VALEUR DE L'ENERGIE DISSIPEE (V4*GC)
C   V6 :  VALEUR DE L'ENERGIE RESIDUELLE COURANTE
C   V7 A V9 : VALEURS DU SAUT

      KAP    = MAX(KA,NA)
      VIP(1) = KAP
      VIP(2) = DISS
      VIP(3) = CASS
      VIP(4) = MIN(1.D0,KAP/LC)
      VIP(5) = GC*VIP(4)

      IF (CASS.NE.2) THEN
        VIP(6) = 0.5D0*(NA**2)*SC*(1.D0 - KAP/LC)/KAP
      ELSE
        VIP(6) = 0.D0
      ENDIF

      VIP(7) = A(1)
      VIP(8) = A(2)
      IF (NDIM.EQ.3) THEN
        VIP(9) = A(3)
      ELSE
        VIP(9) = 0.D0
      ENDIF


C -- MATRICE TANGENTE

 5000 CONTINUE
      IF (.NOT. RIGI) GOTO 9999

      CALL R8INIR(36, 0.D0, DSIDEP,1)

C    MATRICE TANGENTE DE CONTACT PENALISE
      IF (A(1).LE.0.D0) DSIDEP(1,1) = DSIDEP(1,1) + RC

C DANS LE CAS OU L'ELEMENT EST TOTALEMENT CASSE ON INTRODUIT UNE
C RIGIDITE ARTIFICIELLE DANS LA MATRICE TANGENTE POUR ASSURER
C LA CONVERGENCE

      IF (CASS.EQ.2) THEN

        IF (A(1).GT.0.D0) DSIDEP(1,1) = DSIDEP(1,1) - 1.D-8
        DO 39 I=2,NDIM
          DSIDEP(I,I) = DSIDEP(I,I) - 1.D-8
  39    CONTINUE
        GOTO 9999
      END IF

C    MATRICE TANGENTE DE FISSURATION
      IF ((DISS.EQ.0) .OR. ELAS) THEN

        IF (A(1).GT.0.D0) DSIDEP(1,1) = DSIDEP(1,1) + RK

        DO 40 I=2,NDIM
          DSIDEP(I,I) = DSIDEP(I,I) + RK
  40    CONTINUE

      ELSE

        COEF   =  SC*(1.D0/NA - 1.D0/LC)
        COEF2  = -SC/NA**3

        IF (A(1).LE.0.D0) THEN

          DO 42 I=2,NDIM
            DSIDEP(I,I) = DSIDEP(I,I) + COEF + COEF2*A(I)*A(I)
  42      CONTINUE

          IF (NDIM.EQ.3) THEN
            DSIDEP(2,3) = DSIDEP(2,3) + COEF2*A(2)*A(3)
            DSIDEP(3,2) = DSIDEP(3,2) + COEF2*A(3)*A(2)
          ENDIF

        ELSE

          DO 44 I=1,NDIM
            DSIDEP(I,I) = DSIDEP(I,I) + COEF + COEF2*A(I)*A(I)
  44      CONTINUE

          DO 46 J=1,NDIM-1
            DO 47 I=J+1,NDIM
              DSIDEP(J,I) = DSIDEP(J,I) + COEF2*A(J)*A(I)
              DSIDEP(I,J) = DSIDEP(I,J) + COEF2*A(I)*A(J)
  47        CONTINUE
  46      CONTINUE


        ENDIF

      ENDIF
 9999 CONTINUE


      END

      SUBROUTINE GLRCAD (ZIMAT,MP1,MP2,DELAS,RPARA,DMAX1,DMAX2,
     &                   DAM1,DAM2,CURVCU,C1,C2,NBACKN,DEPS,DEPSP,
     &                   DF,DDISS,DSIDEP,NORMM,NORMN,CRIT,CODRET)

        IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 22/05/2012   AUTEUR SFAYOLLE S.FAYOLLE 
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
C
C     INTEGRE LA LOI DE COMPORTEMENT GLRC_DAMAGE POUR UN INCREMENT
C     DE DEFORMATION DEPS DEFINIT DANS LE REPERE D ORTHOTROPIE
C
C IN  ZIMAT : ADRESSE DE LA LISTE DE MATERIAU CODE
C IN  DELAS : MATRICE ELASTIQUE EN MEMBRANE, FLEXION ET COUPLAGE
C IN  MP1 : MOMENTS LIMITES ELASTIQUES EN FLEXION POSITIVE
C IN  MP2 : MOMENTS LIMITES ELASTIQUES EN FLEXION NEGATIVE
C IN  RPARA : PARAMETRE MATERIAU DE LA LOI D ENDOMMAGEMENT
C IN  DMAX1 : ENDOMMAGEMENT MAX EN FLEXION +
C IN  DMAX2 : ENDOMMAGEMENT MAX EN FLEXION -
C IN  CURVCU : TENSEUR DES COURBURES ELASTIQUES DANS LE REPERE ORTHO
C IN  C1 : TENSEUR D ECROUISSAGE CINEMATIQUE DE PRAGER EN MEMBRANE
C IN  C2 : TENSEUR D ECROUISSAGE CINEMATIQUE DE PRAGER EN FLEXION
C IN  DEPS : INCREMENT DE DEFORMATION DANS LE REPERE ORTHO
C IN  NORMM : NORME SUR LA FONCTION MP = F(N)
C IN  NORMN : NORME SUR LA FONCTION MP = F(N)
C
C IN/OUT DAM1 : ENDOMMAGEMENT EN FLEXION +
C IN/OUT DAM2 : ENDOMMAGEMENT EN FLEXION -
C IN/OUT NBACKN : EFFORT - EFFORT DE RAPPEL
C
C OUT DEPSP : INCREMENT DE DEFORMATION PLASTIQUE DANS LE REPERE ORTHO
C OUT DF : INCREMENT D EFFORT DANS LE REPERE ORTHO
C OUT DDISS : INCREMENT DE DISSIPATION
C OUT DSIDEP : MATRICE TANGENTE
C RESPONSABLE SFAYOLLE S.FAYOLLE
C TOLE CRP_21

      LOGICAL BBOK

      INTEGER NCRIT,NCRIT2,IER,CRITNU,ZIMAT
      INTEGER I,J,KK,KKK,IPARA(4),CODRET,KMAX

      REAL*8 DELAS(6,6),ALPHA,BETA,GAMMA,K1,K2,DMAX1
      REAL*8 DMAX2,CURVCU(3),C1(6,6),C2(6,6),DEPS(6),MP1(*),MP2(*)
      REAL*8 DAM1,DAM2,NBACKN(6),NORMM,NORMN
      REAL*8 DEPSP(6),DDISS,DF(6),DSIDEP(6,6)
      REAL*8 DC1(6,6), DC2(6,6), REPS(6), DEPSTE(6)
      REAL*8 DDISST, DEPSPT(6),DEPST2(6),ZERODE
      REAL*8 DTG(6,6),CURCUP(3),DCC1(3,3),DCC2(3,3),RPARA(5)
      REAL*8 NORRM6,FPLASS,ZERO,DFP(6),DFP2(6)
      REAL*8 DFF(3,3),CRIT(*)

C---------------------------------------------
      REAL*8  NMNBN(6), NEWNBN(6)
C         = FORCE - BACKFORCE
      REAL*8  NMPLAS(2,3), NEWPLA(2,3)
C         = PLASMOM(BENDING,_X _Y _XY)
      REAL*8  NMDPLA(2,2), NEWDPL(2,2)
C         = DPLASMOM(BENDING,_X _Y)
      REAL*8  NMDDPL(2,2), NEWDDP(2,2)
C         = DDPLASMOM(BENDING,_X _Y)
      REAL*8  NMZEF, NEWZEF
C         ZERO ADIMENSIONNEL POUR LE CRITERE F
      REAL*8  NMZEG, NEWZEG, NEWZFG(2)
C         ZERO ADIMENSIONNEL POUR LE CRITERE G
      INTEGER NMIEF, NEWIEF
C         NMIEF > 0 : NBN HORS DE LA ZONE DE DEFINITION DE MP
      INTEGER NMPROX(2), NEWPRO(2)
C         NMPROX > 0 : NBN DANS ZONE DE CRITIQUE
C---------------------------------------------

      ZERO = CRIT(3)
      KMAX = NINT(CRIT(1))
      NCRIT = 0

      ALPHA = RPARA(1)
      BETA = RPARA(2)
      GAMMA = RPARA(3)
      K1 = RPARA(4)
      K2 = RPARA(5)

      ZERODE = ZERO * NORRM6(DEPS)

      DO 10, I = 1,6
C     COPIE DU TENSEUR DES EFFORT - EFFORT DE RAPPEL
        NMNBN(I) = NBACKN(I)
 10   CONTINUE

C     CALCUL DES MOMENTS LIMITES DE PLASTICITE
C     ET DES ZEROS DES CRITERES
      CALL MPPFFN(ZIMAT,NMNBN,NMPLAS,NMZEF,NMZEG,NMIEF,NORMM)

C     CALCUL DES DERIVEES DES MOMENTS LIMITES DE PLASTICITE
      CALL D0MPFN(ZIMAT,NMNBN,NMDPLA)

C     CALCUL DES DERIVEES SECONDES DES MOMENTS LIMITES DE PLASTICITE
      CALL DDMPFN(ZIMAT,NMNBN,NMDDPL)

      NEWZEF = NMZEF
      NEWZEG = NMZEG

      CALL ASSERT(NMIEF.LE.0)

      DO 30, J = 1,6
        DO 20, I = 1,6
C     DTG : MATRICE TANGENTE
          DTG(I,J) = DELAS(I,J)
 20     CONTINUE
 30   CONTINUE

      DDISS=0.D0
      CALL R8INIR(6,0.0D0,DF,1)
      CALL R8INIR(6,0.0D0,DEPSP,1)

      DO 40, I = 1,3
        CURCUP(I) = CURVCU(I)
 40   CONTINUE

C     METHODE MIXTE POUR S ASSURER
C     D AVOIR f(m,backm)<= 0 A CHAQUE PAS DE TEMPS

      DO 50, I = 1,6
C     REPS EST LE RESIDU DE L INCREMENT DE DEFORMATION
        REPS(I) = DEPS(I)
 50   CONTINUE

      DO 502, J = 1,6
        DO 501, I = 1,6
C     DC1 : MATRICE ELASTIQUE + CONSTANTES DE PRAGER
C     DC2 : MATRICE ELASTIQUE + CONSTANTES DE PRAGER
          DC1(I,J) = DTG(I,J)+C1(I,J)
          DC2(I,J) = DTG(I,J)+C2(I,J)
 501    CONTINUE
 502  CONTINUE

      DO 229, KK = 1,KMAX
        IF (NORRM6(REPS) .LE. ZERODE) THEN
C     TEST DE CV DE L ALGO D INTEGRATION
          GOTO 230
        ENDIF

        DO 60, I = 1,6
C     AFFECTATION DE L INCREMENT DE DEFORMATION TEST
          DEPSTE(I) = REPS(I)
 60     CONTINUE

C     CALCUL DE L ENDOMMAGEMENT ET DE LA MATRICE TANGENTE
        CALL TANMAT(ALPHA,BETA,GAMMA,K1,K2,DMAX1,DMAX2,
     &            DAM1,DAM2,CURCUP,DEPSTE(4),DFF)

        DO 63, J = 1,3
          DO 62, I = 1,3
            DTG(I+3,J+3) = DFF(I,J)
 62       CONTINUE
 63     CONTINUE

        DO 80, J = 1,6
          DO 70, I = 1,6
            DC1(I,J) = DTG(I,J)+C1(I,J)
            DC2(I,J) = DTG(I,J)+C2(I,J)
 70       CONTINUE
 80     CONTINUE

C     CALCUL DU PREDICTEUR ELASTIQUE ET DU NOMBRE DE CRITERE ATTEINT
        NCRIT = CRITNU(ZIMAT,NMNBN,DEPSTE,DTG,NORMM)

        DO 122, KKK = 1,KMAX
          DO 90, J = 1,6
            DEPST2(J) = 0.5D0*DEPSTE(J)
 90       CONTINUE

C     CALCUL DU PREDICTEUR ELASTIQUE ET DU NOMBRE DE CRITERE ATTEINT
          NCRIT2 = CRITNU(ZIMAT,NMNBN,DEPST2,DTG,NORMM)

          IF (NCRIT2 .NE. NCRIT) THEN
            DO 100, J = 1,6
              DEPSTE(J) = DEPST2(J)
 100        CONTINUE
            NCRIT=NCRIT2
          ELSE
            NEWZFG(1) = NEWZEF
            NEWZFG(2) = NEWZEG

            IPARA(1) = ZIMAT
            IPARA(2) = NCRIT

C     CALCUL DU NOUVEAU MOMENT
C     DE L INCREMENT DE COURBURE PLASTIQUE ET DE LA DISSIPATION
            CALL DNDISS (IPARA,NMNBN,NMPLAS,NMDPLA,NMDDPL,NMPROX,DEPSTE,
     &                   NEWNBN,NEWPLA,NEWDPL,NEWDDP,NEWZFG,
     &                   DEPSPT,DDISST,DC1,DC2,DTG,NORMM,NORMN)

            ZIMAT  = IPARA(1)
            NCRIT  = IPARA(2)
            NEWIEF = IPARA(3)
            IER    = IPARA(4)

            NEWZEF = NEWZFG(1)
            NEWZEG = NEWZFG(2)

            IF(IER .GT. 0) THEN
              DO 110, J = 1,6
                DEPSTE(J) = DEPST2(J)
 110          CONTINUE
              NCRIT=NCRIT2
            ELSE
C     LE POINT EST DANS LA ZONE G < 0
C     SI LE NOUVEAU MOMENT EST A L EXTERIEUR DE LA SURFACE DE PLAST
C     LA METHODE BRINGBACK EST UTILISEE
C     POUR ESSAYER DE LE RAMENER SUR LA SURFACE

              IF (FPLASS(NEWNBN,NEWPLA,1)  .GT.  NEWZEF
     &       .OR. FPLASS(NEWNBN,NEWPLA,2)  .GT.  NEWZEF) THEN

C     PROCEDURE BRINGBACK
                CALL BRBAGL (ZIMAT,NEWNBN,NEWPLA,NEWDPL,NEWDDP,NEWZEF,
     &                       NEWZEG,NEWIEF,NEWPRO, DEPSPT,
     &                       DDISST, DC1,DC2,DTG,BBOK,NORMM,NORMN)

C     BRINGBACK OK : INCREMENT VALIDE

                IF (BBOK) GOTO 123

C     BRINGBACK NOK : DICHOTOMIE
                DO 120, J = 1,6
                  DEPSTE(J) = DEPST2(J)
 120            CONTINUE

                NCRIT = NCRIT2
              ELSE
                GOTO 123
              ENDIF
            ENDIF
          ENDIF
 122    CONTINUE

C     NON CONVERGENCE DE L ALGO DE DICHOTOMIE
        CODRET = 1

 123    CONTINUE

C     L INCREMENT EST VALIDE : MISE A JOUR DES VARIABLES

        DO 125, J = 1,6
          NMNBN(J) = NEWNBN(J)
 125    CONTINUE

        DO 140, J = 1,3
          DO 130, I = 1,2
            NMPLAS(I,J) = NEWPLA(I,J)
 130      CONTINUE
 140    CONTINUE

        DO 160, J = 1,2
          DO 150, I = 1,2
            NMDPLA(I,J) = NEWDPL(I,J)
            NMDDPL(I,J) = NEWDDP(I,J)
 150      CONTINUE
 160    CONTINUE

        NMZEF = NEWZEF
        NMZEG = NEWZEG
        NMIEF = NEWIEF

        DO 170, J = 1,2
          NMPROX(J) = NEWPRO(J)
 170    CONTINUE

        DO 180, J = 1,6
          DEPSP(J) = DEPSP(J) + DEPSPT(J)
 180    CONTINUE

        DDISS = DDISS + DDISST

        DO 190, J = 1,3
          CURCUP(J) = CURCUP(J) + DEPSTE(J+3)
     &                   - DEPSPT(J+3)
 190    CONTINUE

        DO 200, J = 1,6
          DFP2(J) = DEPSTE(J) - DEPSPT(J)
 200    CONTINUE

        CALL MATMUL(DTG,DFP2,6,6,1,DFP)

        DO 210, J = 1,6
          DF(J) = DF(J) + DFP(J)
 210    CONTINUE

        DO 220, J = 1,6
          REPS(J) = REPS(J) - DEPSTE(J)
 220    CONTINUE
 229  CONTINUE

C     NON CONVERGENCE DE L ALGO D INTEGRATION
      CODRET = 1

 230  CONTINUE

      DO 240, J = 1,6
        NBACKN(J) = NMNBN(J)
 240  CONTINUE

      DO 270 I=1,3
        DO 260 J=1,3
          DCC1(J,I) = DC1(3+J,3+I)
          DCC2(J,I) = DC2(3+J,3+I)
 260    CONTINUE
 270  CONTINUE

      CALL DCOPY(36,DELAS,1,DSIDEP,1)

C     REALISE LE CALCUL DE LA MATRICE TANGENTE
      CALL DXKTAN(DTG,MP1,MP2,NBACKN,NCRIT,DCC1,DCC2,DSIDEP)

      END

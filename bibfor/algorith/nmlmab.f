      SUBROUTINE NMLMAB(PGL,NNO,NC,UGL,EFFNOM,TEMPM,TEMPP,CRIT,TMOINS,
     &               TPLUS,XLONG0,E,A,ALPHA,COELMA,COEFGR,FLUXNM,
     &               FLUXNP,VARIM,VARIP,KLS,FLC,EFFNOC,ALPHAM,EM,TREF)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 28/02/2005   AUTEUR MABBAS M.ABBAS 
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
C TOLE CRP_21
C TOLE CRP_7
C ----------------------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER NNO, NC, NEQ, NBT, NCOEFG, NCOEFL, NITER
      PARAMETER (NEQ = 12, NBT = 78, NCOEFG = 3, NCOEFL = 12)
      REAL*8  CRIT(3)
      REAL*8  E,A,ALPHA,XLONG0,ALPHAM,EM,TREF
      REAL*8  COEFGR(NCOEFG),FLUXNM,FLUXNP,COELMA(NCOEFL)
      REAL*8  TMOINS,TPLUS,EFFNOM,TEMPM,TEMPP
      REAL*8  UGL(NEQ),PGL(3,3)
      REAL*8  VARIM(4),VARIP(4)
      REAL*8  KLS(NBT),EFFNOC,FLC,DEPSV,RIGELA
C ----------------------------------------------------------------------
C
C     TRAITEMENT DE LA RELATION DE COMPORTEMENT NON LINEAIRE
C     DE FLUAGE DU LMAB ET DE GRANDISSEMENT POUR LES ELEMENTS DE
C     POUTRE : CALCUL DE LA MATRICE DE RAIDEUR TANGENTE ET DES FORCES
C     NODALES.
C

C ----------------------------------------------------------------------
C IN  :
C       COMPOR : NOM DE LA RELATION DE COMPORTEMENT
C       PGL    : MATRICE DE PASSAGE
C       NNO    : NOMBRE DE NOEUDS
C       NC     : NOMBRE DE DDL
C       UGL    : ACCROIS. DEPLACEMENTS EN REPERE GLOBAL
C       EFFNOM : EFFORT NORMAL ELASTIQUE PRECEDENT
C       TEMPM  : TEMPERATURE IMPOSEE A L'INSTANT PRECEDENT
C       TEMPP  : TEMPERATURE IMPOSEE A L'INSTANT COURANT
C       TREF   : TEMPERATURE DE REFERENCE
C       CRIT   : CRITERES DE CONVERGENCE LOCAUX
C       TMOINS : INSTANT PRECEDENT
C       TPLUS  : INSTANT COURANT
C       XLONG0 : LONGUEUR DE L'ELEMENT DE POUTRE AU REPOS
C       E      : MODULE D'YOUNG A L'INSTANT COURANT
C       EM     : MODULE D'YOUNG A L'INSTANT PRECEDENT
C       A      : SECTION DE LA POUTRE
C       ALPHA  : COEFFICIENT DE DILATATION THERMIQUE A L'INSTANT COURANT
C       ALPHAM : COEFFICIENT DE DILATATION THERMIQUE
C                A L'INSTANT PRECEDENT
C       COELMA : COEFFICIENTS CONSTANTS POUR LE FLUAGE
C       COEFGR : COEFFICIENTS CONSTANTS POUR LE GRANDISSEMENT
C       FLUXNM : FLUX NEUTRONIQUE A L'INSTANT PRECEDENT
C       FLUXNP : FLUX NEUTRONIQUE A L'INSTANT COURANT
C       VARIM  : VARIABLE INTERNE A L'INSTANT PRECEDENT
C       VARIP  : VARIABLE INTERNE A L'INSTANT COURANT
C
C OUT : KLS    : SOUS MATRICE DE RAIDEUR TANGENTE EN REPERE LOCAL
C       FLC    : FORCE NODALE AXIALE CORRIGEE EN REPERE LOCAL
C       EFFNOC : EFFORT NORMAL CORRIGE
C
C ----------------------------------------------------------------------
C *************** DECLARATION DES VARIABLES LOCALES ********************
      REAL*8 NMCRI3, UL(12), DLONG0, DELTAT, PREC, BA, BB, FA, FB
      REAL*8 DEPGRD, DEPTHE, DEPST, XRIG, CORREC, SIG,YG, SIGP
      REAL*8 EPSV,XX,X1,X2,DX,DX1,DX2,COEFLM(NCOEFL),SIGSIG,IER
C      EXTERNAL NMCRI3
      REAL*8  X(4),Y(4),XI
      INTEGER I

C ----------------------------------------------------------------------
      COMMON/RCONM3/COEFLM,EPSV,DEPST,SIG,XX,X1,X2,DX,DX1,DX2,DELTAT,YG,
     &               SIGSIG,DEPTHE,DEPGRD,IER
C ----------------------------------------------------------------------
C
C-- INITIALISATION DES VARIABLES
C
      CALL R8INIR (NBT,0.D0,KLS,1)
      CALL R8INIR (12,0.D0,UL,1)
      YG=E
C
      CALL DCOPY (NCOEFL,COELMA,1,COEFLM,1)
C
      EPSV  = VARIM(1)
      XX  = VARIM(2)
      X1 = VARIM(3)
      X2 = VARIM(4)
C
      CALL UTPVGL (NNO,NC,PGL,UGL,UL)
C
      DLONG0 = UL(7) - UL(1)
      DELTAT = TPLUS - TMOINS
      SIG = (E/EM) * (EFFNOM/A)
      NITER = INT(CRIT(1))
      PREC = CRIT(3)*1.D-3
C     PREC = CRIT(3)**2
      PREC = CRIT(3)
C
      IF (ABS(SIG-XX).LT.PREC)THEN
         SIGSIG = DLONG0/ABS(DLONG0)
      ELSE
         SIGSIG = (SIG-XX)/ABS(SIG-XX)
      ENDIF
C
C-- CALCUL DES INCREMENTS DE DEFORMATION
      DEPST = DLONG0/XLONG0
      DEPTHE = ALPHA*(TEMPP-TREF) - ALPHAM*(TEMPM-TREF)
      DEPGRD = (COEFGR(1)*TEMPP+COEFGR(2))*(FLUXNP**COEFGR(3))-
     &         (COEFGR(1)*TEMPM+COEFGR(2))*(FLUXNM**COEFGR(3))
C
  50  CONTINUE
      BA = 0.D0
      BB =  ABS(DEPST + EPSV)

C     RECHERCHE DU ZERO DE LA FONCTION NMCRI3
C     ANCIEN : CALL ZEROF3 (NMCRI3,BA,BB,PREC,NITER,SOLU)

C     EXAMEN DE LA SOLUTION X = 0
      NCHAN = 0
      FA = NMCRI3(BA)
      IF (ABS(FA).LE.PREC)THEN
         XI = BA
         GOTO 200
      ELSEIF (FA.LT.0.D0) THEN
         X(1)  = BA
         Y(1)  = FA
C        EXAMEN DE LA SOLUTION X = BB
C        FA < 0 ON CHERCHE DONC BB TEL QUE FB > 0
         DO 10 I=1,5
            FB = NMCRI3(BB)
            IF (IER.GT.0.5D0) GOTO 11
            IF (FB.GE.0.D0) THEN
               X(2)  = BB
               Y(2)  = FB
               GOTO 30
            ELSE
               BB = BB * 10.D0
            ENDIF
   10    CONTINUE
   11    CONTINUE
         CALL UTMESS('A','NMLMAB','F RESTE TOUJOURS NEGATIVE')
         GOTO 40
      ELSE
         X(2)  = BA
         Y(2)  = FA
C        EXAMEN DE LA SOLUTION X = BB
C        FA > 0 ON CHERCHE DONC BB TEL QUE FB < 0
         DO 20 I=1,5
            FB = NMCRI3(BB)
            IF (IER.GT.0.5D0) GOTO 21
            IF (FB.LE.0.D0) THEN
               X(1)  = BB
               Y(1)  = FB
               GOTO 30
            ELSE
               BB = BB * 10.D0
            ENDIF
   20    CONTINUE
   21    CONTINUE
         CALL UTMESS('A','NMLMAB','F  RESTE TOUJOURS POSITIVE')
         GOTO 40
      ENDIF
   40 CONTINUE
      NCHAN = NCHAN + 1
      IF (NCHAN.GT.1) THEN
         CALL UTMESS('F','NMLMAB','SIGNE DE SIGMA INDETERMINE')
      ELSE
         SIGSIG = -SIGSIG
         CALL UTMESS('A','NMLMAB','CHANGEMENT DE SIGNE DE SIGMA')
         GOTO 50
      ENDIF
   30 CONTINUE

C     CALCUL DE X(4) SOLUTION EQUATION SCALAIRE F=0

      X(3)  = X(1)
      Y(3)  = Y(1)
      X(4)  = X(2)
      Y(4)  = Y(2)

      DO 100 IT = 1,NITER
         IF ( ABS(Y(4)).LT.PREC) GOTO 110
         CALL ZEROCO(X,Y)
         XI = X(4)
         Y(4) = NMCRI3(XI)
 100  CONTINUE
      CALL UTMESS('F','NMLMAB','F=0 : PAS CONVERGE')
 110  CONTINUE
C
 200  CONTINUE
      DEPSV = SIGSIG * XI
      SIGP    = SIG + E*(DEPST-DEPTHE-DEPGRD-DEPSV)
C
      EFFNOC  = SIGP*A
      VARIP(1) = VARIM(1) + XI
      VARIP(2) = VARIM(2) + DX
      VARIP(3) = VARIM(3) + DX1
      VARIP(4) = VARIM(4) + DX2
C
C-- CALCUL DES COEFFICIENTS NON ELASTIQUES DE LA MATRICE TANGENTE
C
      CORREC = 0.D0
      RIGELA = E*A/XLONG0
      XRIG = RIGELA / (1.D0 + CORREC)
      KLS(1)  =  XRIG
      KLS(22) = -XRIG
      KLS(28) =  XRIG
C
C-- CALCUL DES FORCES NODALES
C
      FLC = EFFNOC
C
C ----------------------------------------------------------------------
C
      END

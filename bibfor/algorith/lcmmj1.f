      SUBROUTINE LCMMJ1(TAUR,MATERF,CPMONO,IFA,NMAT,NBCOMM,DT,
     &           NSFV,NSFA,IR,IS,NBSYS,NFS,NSG,HSR,VIND,DY,IEXP,EXPBP,
     &                  ITMAX,TOLER,DGSDTS,DKSDTS,DGRDBS,DKRDBS,IRET)
      IMPLICIT NONE
C TOLE CRP_21
C TOLE CRS_1404
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 19/12/2012   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PROIX J.M.PROIX
C       ----------------------------------------------------------------
C       MONOCRISTAL : DERIVEES DES TERMES UTILES POUR LE CALCUL
C                    DU JACOBIEN DU SYSTEME NL A RESOUDRE = DRDY
C                    cf. R5.03.11 comportements MONO_VISC*
C       IN
C           TAUR   :  SCISSION REDUITE SYSTEME IR
C           MATERF :  COEFFICIENTS MATERIAU A T+DT
C           CPMONO :  NOM DES COMPORTEMENTS
C           IFA    :  NUMERO FAMILLE
C           NMAT   :  DIMENSION MATER
C           NBCOMM :  INCIDES DES COEF MATERIAU
C           DT     :  ACCROISSEMENT INSTANT ACTUEL
C           NSFV   :  DEBUT DES SYST. GLIS. DE LA FAMILLE IFA DANS VIND
C           NSFA   :  DEBUT DES SYST. GLIS. DE LA FAMILLE IFA DANS Y
C           IS     :  NUMERO DU SYST. GLIS. S
C           IR     :  NUMERO DU SYST. GLIS. R
C           NBSYS  :  NOMBRE DE SYSTEMES DE GLISSEMENT FAMILLE IFA
C           HSR    :  MATRICE D'INTERACTION
C           VIND   :  VARIABLES INTERNES A L'INSTANT PRECEDENT
C           DY     :  SOLUTION           =  ( DSIG DX1 DX2 DP (DEPS3) )
C           ITMAX  :  ITER_INTE_MAXI
C           TOLER  :  RESI_INTE_RELA
C       OUT DGSDTS :  derivee dGammaS/dTauS
C       OUT DKSDTS :  dkS/dTaus
C       OUT DGRDBS :  dGammaR/dBetaS
C       OUT DKRDBS :  dkR/dBetaS
C       OUT IRET   :  CODE RETOUR
C       ----------------------------------------------------------------
      INTEGER NMAT,NUVR,NUVS,IEXP,IR,NSFA,NSFV,ITMAX,NFS,NSG
      INTEGER NBCOMM(NMAT,3),NUVI,IFA,NBSYS,IS,IRET
      REAL*8 VIND(*),DGDTAU,DGRDRR
      REAL*8 HSR(NSG,NSG), EXPBP(NSG),DP,DY(*)
      REAL*8 MATERF(NMAT*2), DT,DGAMMS,RR
      REAL*8 ALPHAM,DALPHA,ALPHAR,CRIT,DARDGR,DGAMMA
      REAL*8 SGNS,TAUR,GAMMAR,PMS
      REAL*8 DGRDAR,TOLER,DRRDPS,PS,PETITH
      REAL*8 DGSDTS,DKSDTS,DGRDBS,DKRDBS
      CHARACTER*24    CPMONO(5*NMAT+1)
      CHARACTER*16    NECOUL,NECRIS,NECRCI
      INTEGER IRR,DECIRR,NBSYST,DECAL,GDEF
      COMMON/POLYCR/IRR,DECIRR,NBSYST,DECAL,GDEF
C     ----------------------------------------------------------------
      IRET=0
      DGSDTS=0.D0
      DKSDTS=0.D0
      DGRDBS=0.D0
      DKRDBS=0.D0

      NECOUL=CPMONO(5*(IFA-1)+3)(1:16)
      NECRIS=CPMONO(5*(IFA-1)+4)(1:16)
      NECRCI=CPMONO(5*(IFA-1)+5)(1:16)

      NUVR=NSFA+IR
      NUVS=NSFA+IS
      NUVI=NSFV+3*(IR-1)
C      PM=VIND(NUVI+3)
      ALPHAM=VIND(NUVI+1)
      DGAMMS=DY(NUVR)
      GAMMAR=VIND(NUVI+2)+DGAMMS

C     CALCUL DE DALPHA
      CALL LCMMFC( MATERF(NMAT+1),IFA,NMAT,NBCOMM,NECRCI,
     &             ITMAX,TOLER, ALPHAM,DGAMMS,DALPHA,IRET )
      IF (IRET.GT.0)  GOTO 9999
      ALPHAR=ALPHAM+DALPHA

C     CALCUL DE R(P) : RP=R0+Q*(1.D0-EXP(-B*P))
C        ECROUISSAGE ISOTROPE : CALCUL DE R(P)
C          IEXP=1
C          IF (IR.EQ.1) IEXP=1
      CALL LCMMFI(MATERF(NMAT+1),IFA,NMAT,NBCOMM,NECRIS,
     &     IR,NBSYS,VIND,NSFV,DY(NSFA+1),NFS,NSG,HSR,IEXP,EXPBP,RR)

C     CALCUL de DGAMMA et de CRIT
      DECAL=NSFV

      CALL LCMMFE(TAUR,MATERF(NMAT+1),MATERF(1),IFA,
     &     NMAT,NBCOMM,NECOUL,IR,NBSYS,VIND,
     &     DY(NSFA+1),RR,ALPHAR,GAMMAR,DT,DALPHA,DGAMMA,DP,CRIT,
     &     SGNS,NFS,NSG,HSR,IRET)
      IF (IRET.GT.0)  GOTO 9999

      IF (CRIT.GT.0.D0) THEN
C        CALCUL de dF/dtau
         CALL LCMMJF( TAUR,MATERF(NMAT+1),MATERF(1),
     &         IFA,NMAT,NBCOMM,DT,NECOUL,IR,IS,NBSYS,VIND(NSFV+1),
     &         DY(NSFA+1),NFS,NSG,HSR,RR,ALPHAR,DALPHA,GAMMAR,
     &         DGAMMS,SGNS,DGDTAU,DGRDAR,DGRDRR,PETITH,IRET)
         IF (IRET.GT.0)  GOTO 9999

         DGSDTS=DGDTAU
         DKSDTS=DGDTAU

C        CALCUL DE dRr/dps
C         PS=PM+ABS(DY(NUVS))
         PMS=VIND(NSFV+3*(IS-1)+3)
         PS=PMS+ABS(DY(NUVS))
         CALL LCMMJI( MATERF(NMAT+1),IFA,NMAT,NBCOMM,NECRIS,
     &    NFS,NSG,HSR,IR,IS,PS,DRRDPS)

C        CALCUL DE DALPHAs/dGAMMAs
         CALL LCMMJC(MATERF(NMAT+1),IFA,NMAT,NBCOMM,
     &        IR,IS,NECRCI,DGAMMS,ALPHAM,DALPHA,SGNS,DARDGR)

         DGRDBS=DGRDAR*DARDGR+DGRDRR*DRRDPS*SGNS

         DKRDBS=DGRDBS

      ENDIF

9999  CONTINUE

      END

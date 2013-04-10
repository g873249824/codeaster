      SUBROUTINE HUJPRE (ETAT, MOD, CRIT, IMAT, MATER, DEPS, SIGD,
     &                    SIGF, VIND, IRET)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/04/2013   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C       ================================================================
C                   CALCUL DE LA PREDICTION EN CONTRAINTE
C       ================================================================
C       IN      ETAT    COMPORTEMENT DU POINT DU POINT DE CALCUL
C                               'ELASTIC'     > ELASTIQUE
C                               'PLASTIC'     > PLASTIQUE
C               MOD     TYPE DE MODELISATION
C               CRIT    CRITERES  LOCAUX
C                       CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
C                                 (ITER_INTE_MAXI == ITECREL)
C                       CRIT(2) = TYPE DE JACOBIEN A T+DT
C                                 (TYPE_MATR_COMP == MACOMP)
C                                 0 = EN VITESSE     > SYMETRIQUE
C                                 1 = EN INCREMENTAL > NON-SYMETRIQUE
C                       CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
C                                 (RESI_INTE_RELA == RESCREL)
C                       CRIT(5) = NOMBRE D'INCREMENTS POUR LE
C                                 REDECOUPAGE LOCAL DU PAS DE TEMPS
C                                 (RESI_INTE_PAS == ITEDEC )
C                                 0 = PAS DE REDECOUPAGE
C                                 N = NOMBRE DE PALIERS
C               DEPS    INCREMENT DE DEFORMATION TOTALE
C               SIGD    CONTRAINTE A T
C               VIND    VARIABLES INTERNES A T    + INDICATEUR ETAT T
C               OPT     OPTION DE CALCUL A FAIRE
C                               'RIGI_MECA_TANG'> DSDE(T)
C                               'FULL_MECA'     > DSDE(T+DT) , SIG(T+DT)
C                               'RAPH_MECA'     > SIG(T+DT)
C       OUT     SIGF    CONTRAINTE A T+DT
C               IRET    CODE RETOUR DE  L'INTEGRATION DE LA LOI CJS
C                              IRET=0 => PAS DE PROBLEME
C                              IRET=1 => ECHEC
      
      INCLUDE 'jeveux.h'
      INTEGER     NDT, NDI, IMAT, IRET, IADZI, IAZK24, I
      REAL*8      CRIT(*), VIND(*)
      REAL*8      DEPS(6), DEV(3), PF(3), Q, PD(3), DP(3)
      REAL*8      SIGD(6), SIGF(6), DSIG(6), DSDE(6,6), RTRAC
      REAL*8      MATER(22,2), I1, D13, TOLE1, TRACE, UN, ZERO
      REAL*8      PTRAC, PREF, MAXI, COHES, FACTOR
      CHARACTER*7 ETAT
      CHARACTER*8 MOD, NOMAIL
      LOGICAL     DEBUG

      COMMON /TDIM/   NDT, NDI
      COMMON /MESHUJ/ DEBUG
      
      DATA   UN, ZERO / 1.D0, 0.D0/
      DATA   D13, TOLE1 /0.33333333334D0, 1.0D-7/ 


      PREF  = MATER(8,2)
      PTRAC = MATER(21,2)
      RTRAC = ABS(PREF*1.D-6)

      IF (ETAT .EQ. 'ELASTIC') THEN
      
        CALL HUJELA (MOD, CRIT, MATER, DEPS, SIGD, SIGF, 
     &               IRET)
     
      ELSEIF (ETAT .EQ. 'PLASTIC') THEN
      
        CALL HUJTID (MOD, IMAT, SIGD, VIND, DSDE, IRET)
        IF (IRET.EQ.0) THEN
          CALL LCPRMV (DSDE, DEPS, DSIG)
          CALL LCSOVN (NDT, SIGD, DSIG, SIGF)
          I1   =D13*TRACE(NDI,SIGF)
        ELSE
          IRET =0
          I1   = -UN
          IF (DEBUG) THEN
            CALL TECAEL(IADZI,IAZK24)
            NOMAIL = ZK24(IAZK24-1+3) (1:8)
            WRITE(6,'(10(A))')
     &     'HUJPRE :: ECHEC DANS LA PSEUDO-PREDICTION ELASTIQUE DANS ',
     &     'LA MAILLE ',NOMAIL
          ENDIF
        ENDIF
        
        IF ((I1 + UN)/ABS(PREF) .GE. TOLE1) THEN
          IF (DEBUG) THEN
            CALL TECAEL(IADZI,IAZK24)
            NOMAIL = ZK24(IAZK24-1+3) (1:8)
            WRITE(6,'(10(A))')
     &      'HUJPRE :: TRACTION DANS LA PSEUDO-PREDICTION ELASTIQUE ',
     &      'DANS LA MAILLE ',NOMAIL
          ENDIF
          CALL HUJELA (MOD, CRIT, MATER, DEPS, SIGD, SIGF, 
     &                 IRET)
        ENDIF
        
      ENDIF


C ---> CONTROLE QU'AUCUNE COMPOSANTE DU VECTEUR SIGF NE SOIT POSITIVE
      DO 10 I = 1, NDT
        DSIG(I)= SIGF(I) - SIGD(I)
  10    CONTINUE

      MAXI  = UN
      COHES = -RTRAC+PTRAC
      FACTOR = UN

      DO 20 I = 1, NDI
        CALL HUJPRJ(I,SIGF,DEV,PF(I),Q)
        CALL HUJPRJ(I,SIGD,DEV,PD(I),Q)
        CALL HUJPRJ(I,DSIG,DEV,DP(I),Q)
        IF (PF(I).GT.COHES .AND. DP(I).GT.TOLE1) THEN
          FACTOR = (-PD(I)+COHES)/DP(I)
          IF ((FACTOR.GT.ZERO).AND.(FACTOR.LT.MAXI)) THEN
            MAXI = FACTOR
          ENDIF
        ENDIF
  20    CONTINUE


C ---> SI IL EXISTE PF(I)>0, ALORS MODIFICATION DE LA PREDICTION      
      IF (MAXI.LT.UN) THEN
        DO 30 I = 1, NDT
          DSIG(I) = MAXI * DSIG(I)
  30      CONTINUE
        CALL LCSOVN (NDT, SIGD, DSIG, SIGF)        
        IF (DEBUG) THEN
          WRITE (6,'(A,A,E12.5)')
     &    'HUJPRE :: APPLICATION DE FACTOR POUR MODIFIER ',
     &    'LA PREDICTION -> FACTOR =',MAXI
          WRITE(6,'(A,6(1X,E12.5))')'SIGF =',(SIGF(I),I=1,NDT)
        ENDIF
      ENDIF
      
      END

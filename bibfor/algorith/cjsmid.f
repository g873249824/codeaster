        SUBROUTINE CJSMID ( MOD, CRIT, MATER, NVI, EPSD, DEPS,
     >                  SIGD, SIGF, VIND, VINF,
     >                  NOCONV,AREDEC,STOPNC,
     >                  NITER,EPSCON)
        IMPLICIT NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/09/2005   AUTEUR LEBOUVIE F.LEBOUVIER 
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
C       ----------------------------------------------------------------
C     INTEGRATION PLASTIQUE (MECANISMES ISOTROPE ET DEVIATOIRE) DE CJS
C     IN   MOD      :  MODELISATION
C          CRIT     :  CRITERES DE CONVERGENCE
C          MATER    :  COEFFICIENTS MATERIAU A T+DT
C          NVI      :  NB DE VARIABLES INTERNES
C          EPSD     :  DEFORMATIONS A T
C          DEPS     :  INCREMENTS DE DEFORMATION
C          SIGD     :  CONTRAINTE  A T
C          VIND     :  VARIABLES INTERNES  A T
C          AREDEC   :  ARRET DES DECOUPAGES
C          STOPNC   :  ARRET EN CAS DE NON CONVERGENCE
C     VAR  SIGF     :  CONTRAINTE  A T+DT
C          VINF     :  VARIABLES INTERNES  A T+DT
C          NOCONV   :  PAS DE CONVERGENCE
C          NITER    :  NOMBRE D ITERATIONS A CONVERGENCE
C          EPSCON   :  VALEUR ERR FINALE
C       ----------------------------------------------------------------
        INTEGER   NDT, NDI, NVI, NR, NMOD,NITER,IRET
        INTEGER    NITIMP
        PARAMETER (NMOD = 16)
        PARAMETER (NITIMP = 200)

        INTEGER   ITER
        LOGICAL   NOCONV,AREDEC,STOPNC

        REAL*8    EPSD(6), DEPS(6)
        REAL*8    SIGD(6), SIGF(6), GD(6)
        REAL*8    VIND(*), VINF(*),EPSCON
        REAL*8    CRIT(*), MATER(14,2)
        REAL*8    R(NMOD), DRDY(NMOD,NMOD)
        REAL*8    DDY(NMOD), DY(NMOD), YD(NMOD), YF(NMOD)
        REAL*8    ERR, ERR1, ERR2, SIGNE
        REAL*8    DET,PA,QINIT
        INTEGER   UMESS,IUNIFI
C
        INTEGER ESSAI, ESSMAX
        PARAMETER (ESSMAX = 10)
C
C    SI ABS(COS_NORMALES) < TOLROT RELAX = RELAX*DECREL
C
        REAL*8 TOLROT, DECREL
        PARAMETER (TOLROT = 0.8D0)
        PARAMETER (DECREL = 0.5D0)
C
        REAL*8 RELAX(ESSMAX+1),ROTAGD(ESSMAX+1) ,
     >         XF(6),NOR1(7),NOR2(7)
        REAL*8    ERIMP(NITIMP,4)
C
        LOGICAL DEVNU1,DEVNU2,TRA1,TRA2
        INTEGER I,J

        CHARACTER*8 MOD

        COMMON /TDIM/   NDT, NDI


C     ------------------------------------------------------------------


C -> DIMENSION DU PROBLEME:
C    NR = NDT(SIG)+ 1(QISO) + 1(R)+ NDT(X) + 1(DLAMBI) + 1(DLAMBD)
C

         UMESS = IUNIFI('MESSAGE')
         NOCONV = .FALSE.
         PA =    MATER(12,2)
         QINIT = MATER(13,2)

C
C

        NR = 2* NDT + 4

C -> MISE A ZERO DES DATAS

        DO 10 I =1, NR
          DDY(I) = 0.D0
          DY(I) = 0.D0
          YD(I) = 0.D0
          YF(I) = 0.D0
 10     CONTINUE


        DO 15 I =1, NDT
          GD(I) = 0.D0
 15     CONTINUE


C -> INITIALISATION DE YD PAR LES CHAMPS (SIGD, VIND, ZERO)

        CALL LCEQVN(NDT, SIGD, YD)
        YD(NDT+1) = VIND(1)
        YD(NDT+2) = VIND(2)

        DO 20 I =1, NDT
          YD(NDT+2+I) = VIND(I+2)
 20     CONTINUE
        YD(2*NDT+3) = 0.D0
        YD(2*NDT+4) = 0.D0


C -> INITIALISATION : DY : CALCUL DE LA SOLUTION D ESSAI INITIALE EN DY
C    (SOLUTION EXPLICITE)

         CALL CJSIID( MOD, MATER, EPSD, DEPS, YD, GD, DY)




C -> INCREMENTATION DE YF = YD + DY

        CALL LCSOVN( NR, YD, DY, YF)


C---------------------------------------
C -> BOUCLE SUR LES ITERATIONS DE NEWTON
C---------------------------------------

        ITER = 0
 100    CONTINUE

        ITER = ITER + 1

C
C--->   EN CAS D'ENTREE EN TRACTION, ON A
C          1.  LES CONTRAINTES SONT RAMENEES SUR L'AXE HYDROSTATIQUE
C              A DES VALEURS FAIBLES ( EGALES A PA/100.0 SOIT -1 KPA )
C          2.  LES VARIABLES INTERNES N'EVOLUENT PAS
C          3.  ON SORT DIRECTEMENT DE CJSMID, CAR ON SUPPOSE ALORS
C              ETRE REVENU DANS LE DOMAINE ELASTIQUE
C
C       SINON IL APPARAIT ENSUITE UNE ERREUR DANS LA ROUTINE MGAUSS
C

        IF( (YF(1)+YF(2)+YF(3)) .GE. -QINIT ) THEN
           DO 31 I=1, NDI
             SIGF(I) = -QINIT/3.D0+PA/100.0D0
 31        CONTINUE
           DO 32 I=NDI+1, NDT
             SIGF(I) = 0.D0
 32        CONTINUE
           CALL LCEQVN ( NVI-1, VIND, VINF )
           VINF(NVI) = 0.D0
           GOTO 9999
        ENDIF


C -> CALCUL DU SECOND MEMBRE A T+DT :  -R(DY)
C    CALCUL DE SIGNE(S:DEPSDP)
C ET CALCUL DU JACOBIEN DU SYSTEME A T+DT :  DRDY(DY)

        DO 50 I =1, NR
        R(I) = 0.D0
        DO 60 J =1, NR
          DRDY(I,J) = 0.D0
 60     CONTINUE
 50     CONTINUE

        CALL CJSJID( MOD, MATER, EPSD, DEPS, YD, YF,
     &               GD, R, SIGNE, DRDY)


C -> RESOLUTION DU SYSTEME LINEAIRE : DRDY(DY).DDY = -R(DY)

        CALL LCEQVN( NR, R, DDY)
        CALL MGAUSS( 'NFVP',DRDY, DDY, NMOD, NR, 1, DET, IRET)
C
        RELAX(1) = 1.D0
C
C   ESTIMATION NORMALE AU POINT YD + DY
C
        DO 24 I=1, NDT
         SIGF(I) = YD(I)+DY(I)
         XF(I)   = YD(NDT+2+I)+DY(NDT+2+I)
 24     CONTINUE
        CALL CJSNOR( MATER, SIGF ,XF ,NOR1,DEVNU1,TRA1)
C
        ESSAI = 0

   40   CONTINUE
        ESSAI = ESSAI + 1
        IF ( (.NOT.DEVNU1).AND.(.NOT.TRA1)) THEN
         IF ( ESSAI.GT.ESSMAX) THEN
          IF ( AREDEC.AND.STOPNC) THEN
           CALL CJSNCN('CJSMID  ',ESSMAX,NDT,NVI,UMESS,
     >          RELAX,ROTAGD,
     >          EPSD,DEPS,SIGD,VIND)
          ELSE
           NOCONV = .TRUE.
           GOTO 200
          ENDIF
         ENDIF
C
C   ESTIMATION NORMALE AU POINT YD + RELAX*DY
C
         DO 25 I=1, NDT
          SIGF(I) = YD(I)+DY(I)+RELAX(ESSAI)*DDY(I)
          XF(I)   = YD(NDT+2+I)+DY(NDT+2+I)+
     >                         RELAX(ESSAI)*DDY(NDT+2+I)
 25      CONTINUE
         CALL CJSNOR( MATER, SIGF ,XF ,NOR2,DEVNU2,TRA2)
C
         ROTAGD(ESSAI) = 0.D0
         DO 26 I = 1 , NDT
          ROTAGD(ESSAI) = ROTAGD(ESSAI)+NOR1(I)*NOR2(I)
   26    CONTINUE
         ROTAGD(ESSAI) = ROTAGD(ESSAI)/(NOR1(NDT+1)*NOR2(NDT+1))
C
         IF ( ABS(ROTAGD(ESSAI)).LT.TOLROT.AND.
     >        (.NOT.DEVNU2).AND.(.NOT.TRA2)) THEN
          RELAX(ESSAI+1) = RELAX(ESSAI)*DECREL
          GOTO 40
         ENDIF
        ENDIF
C
C  DANS LES CAS OU DEVNU1 OU DEVNU2 (ON A DETCTE DES DEVIATEURS NULS)
C  OU TRA1 OU TRA2 ( ON A DETECTE DES TRACTIONS) ON ABANDONNE
C  LA RELAXATION SUR LES NORMALES
C
C
        DO 42 I = 1 , NR
         DY(I) = DY(I)+RELAX(ESSAI)*DDY(I)
         YF(I) = YD(I)+DY(I)
   42   CONTINUE
C



C -> VERIFICATION DE LA CONVERGENCE : ERREUR = !!DDY!!/!!DY!! < TOLER
C
C
        CALL LCNRVN(NR,DDY,ERR1)
        CALL LCNRVN(NR,DY,ERR2)
        IF(ERR2.EQ.0.D0) THEN
          ERR = ERR1
        ELSE
          ERR = ERR1 / ERR2
        ENDIF
        IF(ITER.LE.NITIMP) THEN
         ERIMP(ITER,1) = ERR1
         ERIMP(ITER,2) = ERR2
         ERIMP(ITER,3) = ERR
         ERIMP(ITER,4) = RELAX(ESSAI)
        ENDIF

        IF( ITER .LE. INT(ABS(CRIT(1))) ) THEN

C          --   CONVERVENCE   --
           IF(ERR .LT.  CRIT(3) ) THEN
            GOTO 200

C          --  NON CONVERVENCE : ITERATION SUIVANTE  --
           ELSE
            GOTO 100
           ENDIF

        ELSE

C          --  NON CONVERVENCE : ITERATION MAXI ATTEINTE  --

         IF(AREDEC.AND.STOPNC) THEN
          CALL CJSNCV('CJSMID',NITIMP,ITER,NDT,NVI,UMESS,
     >          ERIMP,
     >          EPSD,DEPS,SIGD,VIND)
          ELSE
           NOCONV = .TRUE.
          ENDIF
        ENDIF

 200    CONTINUE
        NITER = ITER
        EPSCON = ERR


C -> MISE A JOUR DES CONTRAINTES ET VARIABLES INTERNES

        CALL LCEQVN( NDT, YF(1), SIGF )
        VINF(1) = YF(NDT+1)
        VINF(2) = YF(NDT+2)
        DO 250 I=1, NDT
        VINF(2+I) = YF(NDT+2+I)
 250    CONTINUE
        VINF(NVI-1) = SIGNE


 9999   CONTINUE

        END

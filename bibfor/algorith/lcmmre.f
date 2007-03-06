        SUBROUTINE LCMMRE ( MOD, NMAT, MATERD, MATERF,TEMPF,
     3      COMP,NBCOMM, CPMONO, PGL,TOUTMS,HSR, NR, NVI,VIND,
     1       ITMAX, TOLER, TIMED, TIMEF,YD ,YF,DEPS, DY, R, IRET)
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/03/2007   AUTEUR ELGHARIB J.EL-GHARIB 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE JMBHH01 J.M.PROIX
C TOLE CRP_21
C       ----------------------------------------------------------------
C     MONOCRISTAL  : CALCUL DES TERMES DU SYSTEME NL A RESOUDRE = R(DY)
C                  DY =  DSIG DEPSVP (DALPHAS DGAMMAS DPS) PAR SYSTEME
C                  Y  = SIG EPSVP (ALPHAS GAMMAS PS) PAR SYSTEME
C                  R  = ( S    E  A   G  P    )
C  ATTENTION IL FAUT CALCULER -R
C
C     IN  MOD    :  TYPE DE MODELISATION
C         NMAT   :  DIMENSION MATER
C         MATERD :  COEFFICIENTS MATERIAU A T
C         MATERF :  COEFFICIENTS MATERIAU A T+DT
C         TEMPF  :  TEMPERATURE ACTUELLE                               
C         COMP   :  NOM COMPORTEMENT                                   
C         NBCOMM :  INCIDES DES COEF MATERIAU                          
C         CPMONO :  NOM DES COMPORTEMENTS                              
C         PGL    :  MATRICE DE PASSAGE                                 
C         TOUTMS :  TENSEURS D'ORIENTATION                             
C         HSR    :  MATRICE D'INTERACTION                              
C         NVI    :  NOMBRE DE VARIABLES INTERNES                       
C         VIND   :  VARIABLES INTERNES A L'INSTANT PRECEDENT           
C         ITMAX  :  ITER_INTE_MAXI                                     
C         TOLER  :  RESI_INTE_RELA                                     
C         TIMED  :  ISTANT PRECEDENT                                   
C         TIMEF  :  INSTANT ACTUEL                                     
C         YD     :  VARIABLES A T       = ( SIGD VIND (EPSD3)  )
C         YF     :  VARIABLES A T + DT  = ( SIGF VINF (EPSF3)  )
C         DY     :  SOLUTION ESSAI      = ( DSIG DVIN (DEPS3) )
C         DEPS   :  INCREMENT DE DEFORMATION
C         YF     :  VARIABLES A T + DT =  ( SIGF X1F X2F PF (EPS3F) )  
C         DY     :  SOLUTION           =  ( DSIG DX1 DX2 DP (DEPS3) )  
C         NR     :  DIMENSION DECLAREE DRDY                            
C     OUT R      :  RESIDU DU SYSTEME NL A T + DT
C         IRET   :  CODE RETOUR
C     ----------------------------------------------------------------
      INTEGER         NDT , NDI , NMAT, NR, NVI, NSFV, IRET
      INTEGER ITENS,NBFSYS,I,NUVI,IFA,NBSYS,IS,IV,IR,ITMAX,IEXP
C
      REAL*8          DKOOH(6,6), FKOOH(6,6),TIMED, TIMEF
      REAL*8          SIGF(6)   , SIGD(6)
      REAL*8          DEPS(6)   ,     DEPSE(6), DEVI(6),DT
      REAL*8          EPSED(6) , EPSEF(6), H1SIGF(6),VIND(*)
      REAL*8          MATERD(NMAT*2) ,MATERF(NMAT*2),TEMPF
      REAL*8          VIS(3),MS(6),TAUS,DGAMMA,DALPHA,DP,RP,SQ,PR
      REAL*8          R(NR),DY(NR),YD(NR),YF(NR),TOLER
      REAL*8          TOUTMS(5,24,6), HSR(5,24,24)
C
      CHARACTER*8     MOD
      
      INTEGER         NBCOMM(NMAT,3),MONO1,IEC,IEI,IFL,NSFA
      REAL*8          PGL(3,3),D,R0,Q,B,N,K,C,DGAMM1,ABSDGA,ALPHAM,H
      REAL*8          CRIT,ALPHAP,SGNS,GAMMAP,EXPBP(24)
      CHARACTER*16    CPMONO(5*NMAT+1),COMP(*)
      CHARACTER*16 NOMFAM,NECOUL,NECRIS,NECRCI
C     ----------------------------------------------------------------
      COMMON /TDIM/   NDT , NDI
C     ----------------------------------------------------------------
C
      DT=TIMEF-TIMED
      CALL LCEQVN ( NDT , YF(1)       , SIGF)
      CALL R8INIR(6, 0.D0, DEVI, 1)
      
      NBFSYS=NBCOMM(NMAT,2)
      IRET=0
            
C     NSFA : debut de la famille IFA dans DY et YD, YF
      NSFA=6
C     NSFV : debut de la famille IFA dans les variables internes       
      NSFV=6
      
      DO 6 IFA=1,NBFSYS
      
         NOMFAM=CPMONO(5*(IFA-1)+1)
C         NMATER=CPMONO(5*(IFA-1)+2)
         NECOUL=CPMONO(5*(IFA-1)+3)
         NECRIS=CPMONO(5*(IFA-1)+4)
         NECRCI=CPMONO(5*(IFA-1)+5)
         
         CALL LCMMSG(NOMFAM,NBSYS,0,PGL,MS)
         
         DO 7 IS=1,NBSYS
         
C           CALCUL DE LA SCISSION REDUITE =
C           PROJECTION DE SIG SUR LE SYSTEME DE GLISSEMENT
C           TAU      : SCISSION REDUITE TAU=SIG:MS
            DO 101 I=1,6
               MS(I)=TOUTMS(IFA,IS,I)
 101         CONTINUE
 
            TAUS=0.D0
            DO 10 I=1,6
               TAUS=TAUS+SIGF(I)*MS(I)
 10         CONTINUE
 
            DGAMM1=DY(NSFA+IS)
            NUVI=NSFV+3*(IS-1)
            ALPHAM=VIND(NUVI+1)
 
C           ECROUISSAGE CINEMATIQUE - CALCUL DE DALPHA

            IF(NECOUL.NE.'KOCKS_RAUCH') THEN               

            CALL LCMMFC( MATERF(NMAT+1),IFA,NMAT,NBCOMM,NECRCI,
     &        ITMAX, TOLER,ALPHAM,DGAMM1,DALPHA, IRET)
     
            IF (IRET.NE.0) GOTO 9999
 
            ALPHAP=ALPHAM+DALPHA
C           ECROUISSAGE ISOTROPE : CALCUL DE R(P)
            IEXP=0
            IF (IS.EQ.1) IEXP=1
            CALL LCMMFI(MATERF(NMAT+1),IFA,NMAT,NBCOMM,NECRIS,
     &        IS,NBSYS,VIND(NSFV+1),DY(NSFA+1),HSR,IEXP,EXPBP,RP)
            ENDIF
C           ECOULEMENT VISCOPLASTIQUE
C           ROUTINE COMMUNE A L'IMPLICITE (PLASTI-LCPLNL)
C           ET L'EXPLICITE (NMVPRK-GERPAS-RK21CO-RDIF01)
C           CAS IMPLCITE : IL FAUT PRENDRE EN COMPTE DT
C           CAS EXPLICITE : IL NE LE FAUT PAS (C'EST FAIT PAR RDIF01)
C
            GAMMAP=YD(NSFA+IS)+DGAMM1
            
            CALL LCMMFE( TAUS,MATERF(NMAT+1),MATERF(1),IFA,NMAT,NBCOMM,
     &      NECOUL,IS,NBSYS,VIND(NSFV+1),DY(NSFA+1),RP,ALPHAP,
     &      GAMMAP,DT,DALPHA,DGAMMA,DP,TEMPF,CRIT,SGNS,HSR,IRET)
            
            IF(NECOUL.EQ.'KOCKS_RAUCH') THEN
             ALPHAP=ALPHAM+DALPHA
            ENDIF
            
            DO 9 ITENS=1,6
               DEVI(ITENS)=DEVI(ITENS)+MS(ITENS)*DGAMMA
  9         CONTINUE
 
            R(NSFA+IS)=-(DGAMM1-DGAMMA)
               
  7     CONTINUE
  
        NSFA=NSFA+NBSYS
        NSFV=NSFV+NBSYS*3
  
  6   CONTINUE

      CALL LCEQVN ( NDT , YD(1)       , SIGD)
C
C                 -1                     -1
C -   HOOKF, HOOKD , DFDS , EPSEF = HOOKD  SIGD + DEPS - DEPSP
C
      IF (MATERF(NMAT).EQ.0) THEN
         CALL LCOPIL  ( 'ISOTROPE' , MOD , MATERD(1) , DKOOH )
         CALL LCOPIL  ( 'ISOTROPE' , MOD , MATERF(1) , FKOOH )
      ELSEIF (MATERF(NMAT).EQ.1) THEN
         CALL LCOPIL  ( 'ORTHOTRO' , MOD , MATERD(1) , DKOOH )
         CALL LCOPIL  ( 'ORTHOTRO' , MOD , MATERF(1) , FKOOH )
      ENDIF
      CALL LCPRMV ( DKOOH,   SIGD  , EPSED )
      CALL LCDIVE ( DEPS ,   DEVI  , DEPSE )
      CALL LCSOVE ( EPSED,   DEPSE , EPSEF )
C      TENTATIVE DE NORMALISATION DU SYSTEME : 
C     LA PREMIERE EQUATION EST  (HF-1)SIGF - (HD-1)SIGD - (DEPS-DEPSP)=0
      CALL LCPRMV ( FKOOH,   SIGF  , H1SIGF )
      CALL LCDIVE ( EPSEF,   H1SIGF  , R(1) )    
9999  CONTINUE
      END

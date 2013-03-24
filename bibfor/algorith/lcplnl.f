      SUBROUTINE LCPLNL (  FAMI,   KPG,   KSP,   LOI, TOLER,
     &                    ITMAX,   MOD,  IMAT,  NMAT,MATERD,
     &                   MATERF,    NR,   NVI, TIMED, TIMEF,
     &                     DEPS,  EPSD,  SIGD,  VIND,  COMP,
     &                   NBCOMM,CPMONO,   PGL,NFS,NSG,TOUTMS,   HSR,
     &                     SIGF,  VINF, ICOMP,CODRET,  DRDY,
     &                   TAMPON,  CRIT                      )
      IMPLICIT NONE
C ----------------------------------------------------------------------
C          CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/03/2013   AUTEUR PROIX J-M.PROIX 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PROIX J-M.PROIX
C TOLE CRP_21 CRS_1404
C
C     INTEGRATION ELASTO-PLASTIQUE ET VISCO-PLASTICITE
C           SUR DT DE Y = ( SIG , VIN )
C     LE SYSTEME  A RESOUDRE EN DY ETANT NON  LINEAIRE
C
C     ON RESOUD DONC                  R(DY) = 0
C     PAR UNE METHODE DE NEWTON       DRDY(DYI) DDYI = - R(DYI)
C                                     DYI+1 = DYI + DDYI  (DYO DEBUT)
C     ET ON REACTUALISE               YF = YD + DY
C
C     ATTENTION :     ON REACTUALISE ICI DEPS DE FACON A CE QUE
C                     DEPS(3) = DY(NR) EN C_PLAN
C
C
C     IN  FAMI   :  FAMILLE DE POINT DE GAUSS
C         KPG    :  NUMERO DU POINT DE GAUSS
C         KSP    :  NUMERO DU SOUS-POINT DE GAUSS
C         LOI    :  MODELE DE COMPORTEMENT
C         TOLER  :  TOLERANCE DE CONVERGENCE LOCALE
C         ITMAX  :  NOMBRE MAXI D'ITERATIONS LOCALES
C         MOD    :  TYPE DE MODELISATION
C         IMAT   :  ADRESSE DU MATERIAU CODE
C         NMAT   :  DIMENSION MATER
C         MATERD :  COEFFICIENTS MATERIAU A T
C         MATERF :  COEFFICIENTS MATERIAU A T+DT
C         NR     :  NB EQUATION DU SYSTEME R(DY)
C         NVI    :  NB VARIABLES INTERNES
C         TIMED  :  INSTANT  T
C         TIMEF  :  INSTANT T+DT
C         EPSD   :  DEFORMATION A T
C         SIGD   :  CONTRAINTE A T
C         VIND   :  VARIABLES INTERNES A T
C         COMP   :  COMPOR - LOI ET TYPE DE DEFORMATION
C         NBCOMM :  INCIDES DES COEF MATERIAU monocristal
C         CPMONO :  NOM DES COMPORTEMENTS monocristal
C         PGL    :  MATRICE DE PASSAGE
C         TOUTMS :  TENSEURS D'ORIENTATION monocristal
C         HSR    :  MATRICE D'INTERACTION monocristal
C         ICOMP  :  COMPTEUR POUR LE REDECOUPAGE DU PAS DE TEMPS
C     VAR DEPS   :  INCREMENT DE DEFORMATION
C     OUT SIGF   :  CONTRAINTE A T+DT
C         VINF   :  VARIABLES INTERNES A T+DT
C         CODRET :  CONTROLE DU REDECOUPAGE DU PAS DE TEMPS
C         DRDY   :  JACOBIEN
C         TAMPON :  DONNES GEOM SUIVANT LE TE APPELANT
C         CRIT   :  CRITERES DE CONVERGENCE LOCAUX
C VARIABLES LOCALES
C         R      :  VECTEUR RESIDU
C         DY     :  INCREMENT DES VARIABLES = ( DSIG  DVIN  (DEPS3)  )
C         DDY    :  CORRECTION SUR L'INCREMENT DES VARIABLES
C                                           = ( DDSIG DDVIN (DDEPS3) )
C         YD     :  VARIABLES A T   = ( SIGD  VARD  )
C         YF     :  VARIABLES A T+DT= ( SIGF  VARF  )
C         TYPESS :  TYPE DE SOLUTION D ESSAI POUR NEWTON
C         ESSAI  :  VALEUR  SOLUTION D ESSAI POUR NEWTON
C         INTG   :  COMPTEUR DU NOMBRE DE TENTATIVES D'INTEGRATIONS
C
      INTEGER         IMAT, NMAT , ICOMP
      INTEGER         TYPESS, ITMAX, IRET,KPG,KSP
      INTEGER         NR,     NDT,    NDI,    NVI,  ITER
C
      REAL*8          TOLER,  ESSAI, RBID, CRIT(*)
      REAL*8          EPSD(*),        DEPS(*)
      REAL*8          SIGD(6),        SIGF(6)
      REAL*8          VIND(*),        VINF(*)
C     DIMENSIONNEMENT DYNAMIQUE (MERCI F90)
      REAL*8          R(NR),        DRDY(NR,NR), RINI(NR)
      REAL*8          DRDY1(NR,NR)
      REAL*8          DDY(NDT+NVI),DY(NDT+NVI),YD(NDT+NVI),YF(NDT+NVI)
      REAL*8          MATERD(NMAT,2) ,MATERF(NMAT,2), DT
      REAL*8          TIMED, TIMEF, TAMPON(*), DRDYB(NR,NR)
      LOGICAL         LRELI
C
      CHARACTER*8     MOD
      CHARACTER*16    LOI,COMP(*)
      CHARACTER*(*)   FAMI
C
      COMMON /TDIM/   NDT  , NDI
C
      INTEGER I, INTG, CODRET

      INTEGER         NBCOMM(NMAT,3), VERJAC, NFS, NSG
      REAL*8          PGL(3,3),EPSTR(6)
      REAL*8          TOUTMS(NFS,NSG,6),HSR(NSG,NSG)
      CHARACTER*4     CARGAU
      CHARACTER*16    ALGO
      CHARACTER*24    CPMONO(5*NMAT+1)
C
C     ACTIVATION OU PAS DE LA RECHERCHE LINEAIRE
      LRELI = .FALSE.
      LOI=COMP(1)
      CALL UTLCAL('VALE_NOM',ALGO,CRIT(6))
      IF (ALGO.EQ.'NEWTON_RELI') LRELI = .TRUE.

C     VERIFICATION DE LA MATRICE JACOBIENNE
C     VERJAC=0 : PAS DE VERIFICATION
C     VERJAC=1 : CONSTRUCTION DE LA JACOBIENNE PAR PERTURBATION (LCJACP)
C                COMPARAISON A LA MATRICE JACOBIENNE ISSU DE LCJACB
C     VERJAC=2 : UTILISATION DE LA JACOBIENNE PAR PERTURBATION (LCJACP)
C                COMME MATRICE JACOBIENNE A LA PLACE DE LCJACB

      VERJAC = 0

      IF (ALGO.EQ.'NEWTON_PERT') THEN
         VERJAC=2
      ENDIF

      ESSAI = 1.D-5
      DT=TIMEF-TIMED

      CALL R8INIR ( NR,      0.D0 , R,  1 )
      CALL R8INIR ( NDT+NVI, 0.D0 , DDY,1 )
      CALL R8INIR ( NDT+NVI, 0.D0 , DY, 1 )
      CALL R8INIR ( NDT+NVI, 0.D0 , YD, 1 )
      CALL R8INIR ( NDT+NVI, 0.D0 , YF, 1 )

      CODRET = 0

C     CHOIX DES VALEURS DE VIND A AFFECTER A YD
      CALL LCAFYD(COMP,MATERD,MATERF,NBCOMM,CPMONO,NMAT,MOD,
     &            NVI,VIND,SIGD,NR,YD)

C     CHOIX DES PARAMETRES DE LANCEMENT DE MGAUSS
      CALL LCCAGA(LOI,CARGAU)

      IF(MOD(1:6).EQ.'C_PLAN') YD (NR) = EPSD(3)
C
C     RESOLUTION ITERATIVE PAR NEWTON DE R(DY) = 0
C     SOIT  DRDY(DYI) DDYI = -R(DYI)  ET DYI+1 = DYI + DDYI
C                                                         -
C -   INITIALISATION DU TYPE DE SOLUTION D ESSAI (-1)
      TYPESS = -1
      INTG   = 0

 2    CONTINUE

C     CALCUL DE LA SOLUTION D ESSAI INITIALE DU SYSTEME NL EN DY
      CALL LCINIT ( FAMI,KPG,KSP,LOI,TYPESS,ESSAI,MOD,NMAT,MATERD,
     &              MATERF,TIMED,TIMEF,NR, NVI, YD,
     &              EPSD,  DEPS,   DY ,
     &              COMP,NBCOMM, CPMONO, PGL,NFS,NSG,TOUTMS,
     &              VIND,SIGD, SIGF,EPSTR)

      ITER = 0

 1    CONTINUE

C     ITERATIONS DE NEWTON
      ITER = ITER + 1

C     PAR SOUCIS DE PERFORMANCES, ON NE REFAIT PAS DES OPERATIONS
C     QUI ONT DEJA ETE FAITE A L'ITERATION PRECEDENTE DANS LE CAS
C     DE LA RECHERCHE LINEAIRE
      IF (.NOT.LRELI.OR.ITER.EQ.1) THEN
C        INCREMENTATION DE  YF = YD + DY
         CALL LCSOVN ( NR , YD , DY , YF )
C
C        CALCUL DES TERMES DU SYSTEME A T+DT = -R(DY)
         CALL LCRESI(FAMI,KPG,KSP,LOI,MOD,IMAT,NMAT,MATERD,MATERF,
     &       COMP,NBCOMM,CPMONO,PGL,NFS,NSG,TOUTMS,HSR,NR,NVI,VIND,
     &               VINF,ITMAX, TOLER,TIMED,TIMEF,YD,YF,DEPS,EPSD,
     &               DY,R,IRET,CRIT)
         IF (IRET.NE.0) THEN
            GOTO 3
         ENDIF
      ENDIF
C     SAUVEGARDE DE R(DY0) POUR TEST DE CONVERGENCE
      IF (ITER.EQ.1) CALL LCEQVN(NR,R,RINI)
C
      IF (VERJAC.NE.2) THEN
C         CALCUL DU JACOBIEN DU SYSTEME A T+DT = DRDY(DY)
          CALL LCJACB(FAMI,KPG,KSP,LOI,MOD,NMAT,MATERD,MATERF,
     &            TIMED,TIMEF,YF,DEPS,ITMAX,TOLER,NBCOMM,
     &            CPMONO, PGL,NFS,NSG,TOUTMS,HSR,NR,COMP,NVI,VIND,
     &            VINF,EPSD,  YD,DY,CRIT,DRDY, IRET )
          IF (IRET.NE.0)  THEN
             GOTO 3
          ENDIF
      ENDIF

      IF (VERJAC.GE.1) THEN
         CALL LCJACP(FAMI,KPG,KSP,LOI,TOLER,ITMAX,MOD,IMAT,
     &               NMAT,MATERD,MATERF,NR,NVI,
     &               TIMED,TIMEF, DEPS,EPSD,VIND,VINF,YD,
     &               COMP,NBCOMM,CPMONO,PGL,NFS,NSG,TOUTMS,HSR,
     &               DY,R,DRDY,VERJAC,DRDYB, IRET,CRIT)
          IF (IRET.NE.0)  GOTO 3
      ENDIF
      
C     RESOLUTION DU SYSTEME LINEAIRE DRDY(DY).DDY = -R(DY)
      CALL LCEQMN ( NR , DRDY , DRDY1 )
      CALL LCEQVN ( NR ,   R ,   DDY )
      CALL MGAUSS ( CARGAU,DRDY1,DDY,NR,NR,1,RBID,IRET )
      IF (IRET.NE.0) THEN
         GOTO 3
      ENDIF

C     ACTUALISATION DE LA SOLUTION
      IF (.NOT.LRELI) THEN
C        REACTUALISATION DE DY = DY + DDY
         CALL LCSOVN ( NR , DDY , DY , DY )
      ELSEIF (LRELI) THEN
C        RECHERCHE LINEAIRE : RENVOIE DY, YF ET R RE-ACTUALISES
         CALL LCRELI(FAMI,KPG,KSP,LOI,MOD,IMAT,NMAT,MATERD,MATERF,COMP,
     &               NBCOMM,CPMONO,PGL,NFS,NSG,TOUTMS,HSR,NR,NVI,VIND,
     &               VINF,ITMAX,TOLER,TIMED,TIMEF,YD,YF,DEPS,EPSD,DY,R,
     &               DDY,IRET,CRIT)
         IF (IRET.NE.0) GOTO 3
      ENDIF
      IF ( MOD(1:6).EQ.'C_PLAN' ) DEPS(3) = DY(NR)
C
C     VERIFICATION DE LA CONVERGENCE EN DY  ET RE-INTEGRATION ?
      CALL LCCONV(LOI,YD,DY,DDY,NR,ITMAX,TOLER,ITER,INTG,
     &            NMAT,MATERF,R,RINI,EPSTR,TYPESS,ESSAI,
     &            ICOMP,NVI,VINF,IRET)
C     IRET = 0 CONVERGENCE
C          = 1 ITERATION SUIVANTE
C          = 2 RE-INTEGRATION
C          = 3 REDECOUPAGE DU PAS DE TEMPS
      IF ( IRET.GT.0 ) GOTO (1,2,3), IRET
C
C     CONVERGENCE > INCREMENTATION DE  YF = YD + DY
      CALL LCSOVN( NDT+NVI , YD , DY , YF )
C
C     POST-TRAITEMENTS POUR DES LOIS PARTICULIERES
      CALL LCPLNF(LOI, VIND,NBCOMM,NMAT,CPMONO,MATERD,MATERF,ITER,NVI,
     &            ITMAX,TOLER,PGL,NFS,NSG,TOUTMS,HSR,DT,DY,YD,YF,VINF,
     &            TAMPON,COMP,SIGD,SIGF,DEPS,NR,MOD,TIMED,TIMEF,IRET)
      IF (IRET.NE.0) THEN
         GOTO 3
      ENDIF

C     CONVERGENCE
      CODRET = 0
      GOTO 9999

 3    CONTINUE
C     NON CV, OU PB => REDECOUPAGE (LOCAL OU GLOBAL) DU PAS DE TEMPS
      CODRET = 1

 9999 CONTINUE

      END

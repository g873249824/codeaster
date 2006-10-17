      SUBROUTINE LCMMJP ( MOD, NMAT, MATER,TEMPF,
     &       TIMED, TIMEF, COMP,NBCOMM, CPMONO, PGL,TOUTMS,HSR,NR,NVI,
     &      ITMAX,TOLER,SIGF,VINF,SIGD,VIND,
     &                   DSDE , DRDY, OPTION, IRET)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C TOLE CRP_21
C MODIF ALGORITH  DATE 16/10/2006   AUTEUR JMBHH01 J.M.PROIX 
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
C     ----------------------------------------------------------------
C     COMPORTEMENT MONOCRISTALLIN
C                :  MATRICE SYMETRIQUE DE COMPORTEMENT TANGENT
C                   COHERENT A T+DT
C     ----------------------------------------------------------------
C     IN  MOD    :  TYPE DE MODELISATION
C         NMAT   :  DIMENSION MATER
C         MATER  :  COEFFICIENTS MATERIAU
C         TEMPF  :  TEMPERATURE ACTUELLE                               
C         TIMED  :  ISTANT PRECEDENT                                   
C         TIMEF  :  INSTANT ACTUEL                                     
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
C         SIGD   :  CONTRAINTES A T
C         SIGF   :  CONTRAINTES A T+DT
C         VIND   :  VARIABLES INTERNES A T
C         VINF   :  VARIABLES INTERNES A T+DT
C         DRDY   :  MATRICE JACOBIENNE
C         OPTION :  OPTION DE CALCUL MATRICE TANGENTE
C
C     OUT DSDE   :  MATRICE DE COMPORTEMENT TANGENT = DSIG/DEPS
C      DSDE = INVERSE(Y0-Y1*INVERSE(Y3)*Y2)
C     ----------------------------------------------------------------
      INTEGER         NDT , NDI , NMAT , NVI, ITMAX
      INTEGER         K,J,NR, NVV, IRET,NS
C DIMENSIONNEMENT DYNAMIQUE
      REAL*8          DRDY(NR,NR),Y0(6,6),Y1(6,(NVI-8)),DSDE(6,6)
      REAL*8          MATER(NMAT*2),Y2((NVI-8),6),KYL(6,6),DET,I6(6,6)
      REAL*8          Y3((NVI-8),(NVI-8)), TOLER
      REAL*8          YD(NR),YF(NR),DY(NR),UN,ZERO,TEMPF
      REAL*8 Z0(6,6),Z1(6,(NR-NDT)),Z2((NR-NDT),6),Z3((NR-NDT),(NR-NDT))
        REAL*8 TOUTMS(5,24,6),HSR(5,24,24),MS(6)
      CHARACTER*8     MOD
      PARAMETER       ( UN   =  1.D0   )
      PARAMETER       ( ZERO =  0.D0   )

      INTEGER         NBCOMM(NMAT,3),MONO1
      INTEGER         NBFSYS,NBSYS,IS,NSFA,NUVRF, NUVR,IFA
      REAL*8  SIGF(*),SIGD(*),VIND(*),VINF(*),TIMED,TIMEF,PGL(3,3)
      CHARACTER*16    CPMONO(5*NMAT+1),COMP(*), NOMFAM, OPTION
      COMMON /TDIM/ NDT,NDI
      DATA  I6        /UN     , ZERO  , ZERO  , ZERO  ,ZERO  ,ZERO,
     1                 ZERO   , UN    , ZERO  , ZERO  ,ZERO  ,ZERO,
     2                 ZERO   , ZERO  , UN    , ZERO  ,ZERO  ,ZERO,
     3                 ZERO   , ZERO  , ZERO  , UN    ,ZERO  ,ZERO,
     4                 ZERO   , ZERO  , ZERO  , ZERO  ,UN    ,ZERO,
     5                 ZERO   , ZERO  , ZERO  , ZERO  ,ZERO  ,UN/

C -  INITIALISATION

      NSFA = 6
      NUVRF = 6
      NBFSYS = NBCOMM(NMAT,2)
      NS = 0
      IRET=0
C - RECUPERER LES SOUS-MATRICES BLOC

      CALL LCEQVN ( NDT  ,  SIGD , YD )
      CALL LCEQVN ( NDT  ,  SIGF , YF )

      DO 99 IFA = 1, NBFSYS
         NOMFAM = CPMONO(5*(IFA-1)+1)
         CALL LCMMSG(NOMFAM,NBSYS,0,PGL,MS)
         NUVR = NUVRF
          DO 98 IS = 1, NBSYS
            YD(NSFA+IS)=VIND(NUVR+2)
            YF(NSFA+IS)=VINF(NUVR+2)
            DY(NSFA+IS)=VINF(NUVR+2)-VIND(NUVR+2)
            NUVR = NUVRF + 3
  98     CONTINUE
            NS = NS + NBSYS
  99     CONTINUE
      NUVRF = NUVRF + 3*NBSYS
      NSFA = NSFA + NBSYS
                 
C     RECALCUL DE LA DERNIERE MATRICE JACOBIENNE
      IF (OPTION.EQ. 'RIGI_MECA_TANG') THEN
          CALL R8INIR(NR,0.D0, DY, 1)         
          CALL R8INIR(NR,0.D0, YF, 1)         
          CALL R8INIR(NVI,0.D0, VIND, 1)         
          CALL LCMMJA ( MOD, NMAT, MATER, TIMED, TIMEF, TEMPF,
     &    ITMAX,TOLER,COMP,NBCOMM, CPMONO, PGL,TOUTMS,HSR,NR,NVI,VIND,
     &    YF,DY,DRDY, IRET)
      ENDIF


        DO 101 K=1,6
        DO 101 J=1,6
           Z0(K,J)=DRDY(K,J)
 101     CONTINUE
        DO 201 K=1,6
        DO 201 J=1,NS
           Z1(K,J)=DRDY(K,NDT+J)
 201     CONTINUE

        DO 301 K=1,NS
        DO 301 J=1,6
           Z2(K,J)=DRDY(NDT+K,J)
 301     CONTINUE
        DO 401 K=1,NS
        DO 401 J=1,NS
           Z3(K,J)=DRDY(NDT+K,NDT+J)
 401     CONTINUE
C       Z2=INVERSE(Z3)*Z2
        CALL MGAUSS ('NFWP',Z3, Z2, NS, NS, 6, DET, IRET )
        
C       KYL=Z1*INVERSE(Z3)*Z2
        CALL PROMAT(Z1,6,6,NS,Z2,NS,NS,6,KYL)

C       Z0=Z0+Z1*INVERSE(Z3)*Z2
        DO 501 K=1,6
        DO 501 J=1,6
           Z0(K,J)=Z0(K,J)-KYL(K,J)
           DSDE(K,J)=I6(K,J)
 501    CONTINUE
 
C       DSDE = INVERSE(Z0-Z1*INVERSE(Z3)*Z2)

C        CALL MGAUSS ('NFVP',Z0, DSDE, 6, 6, 6, DET, IRET )
        CALL MGAUSS ('NFWP',Z0, DSDE, 6, 6, 6, DET, IRET )
        
      END

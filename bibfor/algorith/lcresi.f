        SUBROUTINE LCRESI( FAMI, KPG, KSP, LOI, TYPMOD, IMAT, NMAT,
     3                     MATERD, MATERF, COMP, NBCOMM, CPMONO,
     1         PGL,NFS,NSG,TOUTMS,HSR,NR,NVI,VIND,VINF,ITMAX, TOLER,
     &   TIMED, TIMEF, YD,YF, DEPS, EPSD, DY, R, IRET ,CRIT)
        IMPLICIT   NONE
C TOLE CRP_21
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/02/2013   AUTEUR PROIX J-M.PROIX 
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
C       ----------------------------------------------------------------
C       CALCUL DES TERMES DU SYSTEME NL A RESOUDRE = R(DY)
C       IN  FAMI   :  FAMILLE DU POINT DE GAUSS
C           KPG    :  POINT DE GAUSS
C           KSP    :  SOUS-POINT DE GAUSS
C           LOI    :  MODELE DE COMPORTEMENT
C           TYPMOD    :  TYPE DE MODELISATION
C           IMAT   :  NOM DU MATERIAU
C           NMAT   :  DIMENSION MATER
C           MATERD :  COEFFICIENTS MATERIAU A T
C           MATERF :  COEFFICIENTS MATERIAU A T+DT
C           TIMED  :  INSTANT  T
C           TIMEF  :  INSTANT  T+DT
C           DEPS   :  INCREMENT DE DEFORMATION
C           EPSD   :  DEFORMATION A T
C           VIND   :  VARIABLES INTERNES A T
C           VINF   :  VARIABLES INTERNES A T+DT
C           YD     :  VARIABLES A T      =    ( SIGD  VIND  (EPSD3)  )
C           YF     :  VARIABLES A T + DT =    ( SIGF  VINF  (EPS3F)  )
C           DY     :  SOLUTION           =    ( DSIG  DVIN  (DEPS3)  )
C       OUT R      :  SYSTEME NL A T + DT
C       ----------------------------------------------------------------
C
        INTEGER  IMAT, NMAT, NR, NVI, KPG, KSP, ITMAX, IRET, NFS,NSG
        REAL*8          DEPS(6)  , EPSD(6), VIND(*), TOLER
        REAL*8          R(*) , YD(*) ,  YF(*), DY(*),VINF(*)
        REAL*8          MATERD(NMAT,2) ,MATERF(NMAT,2)
        REAL*8          TIMED, TIMEF, CRIT(*)
        CHARACTER*8     TYPMOD
        CHARACTER*16    LOI
        REAL*8 TOUTMS(NFS,NSG,6), HSR(NSG,NSG)
        CHARACTER*(*)   FAMI

        INTEGER         NBCOMM(NMAT,3)
        REAL*8          PGL(3,3)
        CHARACTER*16    COMP(*)
        CHARACTER*24    CPMONO(5*NMAT+1)

C       ----------------------------------------------------------------

      IRET=0
      IF ( LOI(1:9) .EQ. 'VISCOCHAB' ) THEN
         CALL CVMRES ( TYPMOD,   NMAT, MATERD, MATERF,
     1                 TIMED, TIMEF, YD,  YF,  EPSD,  DEPS,  DY,  R )
C
      ELSEIF ( LOI(1:8)  .EQ. 'MONOCRIS' ) THEN
         CALL LCMMRE ( TYPMOD, NMAT, MATERD, MATERF,
     3  COMP,NBCOMM, CPMONO, PGL, NFS,NSG,TOUTMS,HSR,NR, NVI,VIND,
     1  ITMAX, TOLER, TIMED, TIMEF,  YD,   YF, DEPS, DY,  R, IRET)
      ELSEIF ( LOI(1:7)  .EQ. 'IRRAD3M' ) THEN
         CALL IRRRES ( FAMI, KPG, KSP, TYPMOD,   NMAT, MATERD,MATERF,
     1                 YD,  YF,  DEPS,  DY,  R )
      ELSEIF ( LOI(1:15)  .EQ. 'BETON_BURGER_FP' ) THEN
         CALL BURRES ( TYPMOD,NMAT,MATERD,MATERF,TIMED,TIMEF,
     1                 NVI,VIND,YD,YF,DEPS,DY,NR,R )
      ELSEIF ( LOI(1:4)  .EQ. 'LETK' ) THEN
         CALL LKRESI ( TYPMOD,NMAT,MATERF,TIMED,TIMEF,
     &                 NVI,VIND,VINF,YD,YF,DEPS,NR,R )
      ELSEIF ( LOI  .EQ. 'HAYHURST' ) THEN
         CALL HAYRES ( TYPMOD,NMAT,MATERD,MATERF,TIMED,TIMEF,
     &                 YD,YF,DEPS,DY,R,CRIT,IRET)
      ELSE         
         CALL LCRESA(FAMI,KPG,KSP,TYPMOD,IMAT,NMAT,MATERD,MATERF,
     &          COMP,NR,NVI,TIMED,TIMEF,DEPS,EPSD,YF,DY,R,IRET,YD,CRIT)
     
      ENDIF

      END

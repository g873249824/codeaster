        SUBROUTINE LCRESI( LOI,  MOD,  IMAT, NMAT, MATERD,MATERF,MATCST,
     1                   TEMPD, TEMPF,TIMED,TIMEF,YD,YF,DEPS,EPSD,DY,R )
        IMPLICIT   NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/10/2001   AUTEUR ADBHHVV V.CANO 
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
C       CALCUL DES TERMES DU SYSTEME NL A RESOUDRE = R(DY)
C       IN  LOI    :  MODELE DE COMPORTEMENT
C           MOD    :  TYPE DE MODELISATION
C           IMAT   :  NOM DU MATERIAU
C           NMAT   :  DIMENSION MATER
C           MATERD :  COEFFICIENTS MATERIAU A T
C           MATERF :  COEFFICIENTS MATERIAU A T+DT
C           MATCST :  'OUI' SI MATERIAU CONSTANT SUR DT
C           TEMPD  :  TEMPERATURE A T
C           TEMPF  :  TEMPERATURE A T+DT
C           TIMED  :  INSTANT  T
C           TIMEF  :  INSTANT  T+DT
C           DEPS   :  INCREMENT DE DEFORMATION
C           EPSD   :  DEFORMATION A T
C           YD     :  VARIABLES A T      =    ( SIGD  VIND  (EPSD3)  )
C           YF     :  VARIABLES A T + DT =    ( SIGF  VINF  (EPS3F)  )
C           DY     :  SOLUTION           =    ( DSIG  DVIN  (DEPS3)  )
C       OUT R      :  SYSTEME NL A T + DT
C       ----------------------------------------------------------------
C
        INTEGER         IMAT, NMAT
        REAL*8          DEPS(6)  , EPSD(6)
        REAL*8          R(*) , YD(*) ,  YF(*), DY(*)
        REAL*8          MATERD(NMAT,2) ,MATERF(NMAT,2)
        REAL*8          TEMPD, TEMPF,   TIMED, TIMEF
        CHARACTER*8     MOD
        CHARACTER*16    LOI
        CHARACTER*3     MATCST
C       ----------------------------------------------------------------
C
C         IF    ( LOI(1:8) . EQ. 'ROUSS_PR' ) THEN
C         CALL RSLRES ( MOD,   IMAT, NMAT, MATERD, MATERF, MATCST,
C     1                 TEMPF, YD,   YF,   DEPS,   DY,     R )
C
      IF     ( LOI(1:8) .EQ. 'CHABOCHE' ) THEN
         CALL CHBRES ( MOD,   IMAT, NMAT, MATERD, MATERF, MATCST,
     1                 TEMPF, YD,   YF,   DEPS,   DY,     R )
C
      ELSEIF ( LOI(1:4) .EQ. 'OHNO' ) THEN
         CALL ONORES ( MOD,   IMAT, NMAT, MATERD, MATERF, MATCST,
     1                 TEMPF, YD,   YF,   DEPS,   DY,     R )
C
      ELSEIF ( LOI(1:5) .EQ. 'LMARC' ) THEN
         CALL LMARES ( MOD,   IMAT, NMAT, MATERD, MATERF, MATCST, TEMPF,
     1                 TIMED, TIMEF, YD,  YF,     DEPS,   DY,     R )
C
      ELSEIF ( LOI(1:9) .EQ. 'VISCOCHAB' ) THEN
         CALL CVMRES ( MOD,   IMAT, NMAT, MATERD, MATERF, MATCST, TEMPF,
     1                 TIMED, TIMEF, YD,  YF,  EPSD,  DEPS,  DY,  R )
C
      ELSEIF ( LOI(1:7)  .EQ. 'NADAI_B' ) THEN
         CALL INSRES ( MOD,   IMAT, NMAT, MATERD, MATERF, MATCST,
     1                 TEMPF, YD,   YF,   DEPS,   DY,     R )
      ENDIF
C
      END

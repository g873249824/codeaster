        SUBROUTINE LCJACB ( LOI,  MOD,  IMAT, NMAT,MATERD,MATERF,MATCST,
     1                      TEMPD,TEMPF,TIMED,TIMEF,YD,   YF,    DEPS,
     2                      EPSD,  DY,  NMOD,  DRDY )
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
C       CALCUL DU JACOBIEN DU SYSTEME NL A RESOUDRE = DRDY(DY)
C       IN  LOI    :  MODELE DE COMPORTEMENT
C           MOD    :  TYPE DE MODELISATION
C           IMAT   :  ADRESSE DU MATERIAU CODE
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
C           NMOD   :  DIMENSION DECLAREE DRDY
C       OUT DRDY   :  JACOBIEN DU SYSTEME NON LINEAIRE
C       ----------------------------------------------------------------
C
        INTEGER         IMAT, NMOD ,    NMAT
        REAL*8          DEPS(6) , EPSD(6)
        REAL*8          DRDY(NMOD,*) , YD(*) , YF(*), DY(*)
C
        REAL*8          MATERD(NMAT,2) ,MATERF(NMAT,2)
        REAL*8          TEMPD, TEMPF,   TIMED, TIMEF
C
        CHARACTER*8     MOD
        CHARACTER*16    LOI
        CHARACTER*3     MATCST
C       ----------------------------------------------------------------
C
C          IF ( LOI(1:8) .EQ. 'ROUSS_PR' ) THEN
C          CALL RSLJAC ( MOD, IMAT, NMAT, MATERD, MATERF, MATCST, TEMPF,
C     1                  YD,  YF,   DEPS, DY,     NMOD,   DRDY )
C
      IF     ( LOI(1:8) .EQ. 'CHABOCHE' ) THEN
         CALL CHBJAC ( MOD, IMAT, NMAT, MATERF, TEMPF,
     1                  YF,  DY,   NMOD,  DRDY )
C
      ELSEIF ( LOI(1:4) .EQ. 'OHNO' ) THEN
         CALL ONOJAC ( MOD, IMAT, NMAT, MATERF, TEMPF,
     1                  YF,  DY,   NMOD,  DRDY )
C
      ELSEIF ( LOI(1:5) .EQ. 'LMARC' ) THEN
         CALL LMAJAC ( MOD, IMAT, NMAT, MATERF, TEMPF, TIMED, TIMEF,
     1                  YF,  DY,   NMOD,  DRDY )
C
      ELSEIF ( LOI(1:9) .EQ. 'VISCOCHAB' ) THEN
         CALL CVMJAC ( MOD, IMAT, NMAT, MATERF, TEMPF, TIMED, TIMEF,
     1                  YF,  DY,   NMOD, EPSD,   DEPS,  DRDY )
C
      ELSEIF ( LOI(1:7)  .EQ. 'NADAI_B' ) THEN
         CALL INSJAC ( MOD, IMAT, NMAT, MATERF, TEMPF,
     1                  YF,  DY,   NMOD,  DRDY )
      ENDIF
C
      END

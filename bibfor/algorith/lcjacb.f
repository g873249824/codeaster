        SUBROUTINE LCJACB ( LOI,  MOD,  IMAT, NMAT,MATERF,TEMPF,
     1                      TIMED,TIMEF,   YF,    DEPS,
     3                COMP,NBCOMM, CPMONO, PGL,NR,NVI,
     2                      EPSD,  DY,  DRDY )
        IMPLICIT   NONE
C       ================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 06/08/2004   AUTEUR JMBHH01 J.M.PROIX 
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
C           MATERF :  COEFFICIENTS MATERIAU A T+DT
C           TIMED  :  INSTANT  T
C           TIMEF  :  INSTANT  T+DT
C           DEPS   :  INCREMENT DE DEFORMATION
C           EPSD   :  DEFORMATION A T
C           YF     :  VARIABLES A T + DT =    ( SIGF  VINF  (EPS3F)  )
C           DY     :  SOLUTION           =    ( DSIG  DVIN  (DEPS3)  )
C           NR   :  DIMENSION DECLAREE DRDY
C       OUT DRDY   :  JACOBIEN DU SYSTEME NON LINEAIRE
C       ----------------------------------------------------------------
C
        INTEGER         IMAT, NR ,    NMAT,NVI
        REAL*8          DEPS(6) , EPSD(6)
        REAL*8          DRDY(NR,NR) , YF(NR), DY(NR)
C
        REAL*8          MATERF(NMAT,2),TEMPF
        REAL*8          TIMED, TIMEF
C
        CHARACTER*8     MOD
        CHARACTER*16    LOI
        
        INTEGER         NBCOMM(NMAT,3)
        REAL*8          PGL(3,3)
        CHARACTER*16    CPMONO(5*NMAT+1),COMP(*)

C       ----------------------------------------------------------------
C
      IF     ( LOI(1:8) .EQ. 'CHABOCHE' ) THEN
         CALL CHBJAC ( MOD, NMAT, MATERF,
     1                  YF,  DY,   NR,  DRDY )
C
      ELSEIF ( LOI(1:4) .EQ. 'OHNO' ) THEN
         CALL ONOJAC ( MOD, NMAT, MATERF,
     1                  YF,  DY,   NR,  DRDY )
C
      ELSEIF ( LOI(1:5) .EQ. 'LMARC' ) THEN
         CALL LMAJAC ( MOD, NMAT, MATERF, TIMED, TIMEF,
     1                  YF,  DY,   NR,  DRDY )
C
      ELSEIF ( LOI(1:9) .EQ. 'VISCOCHAB' ) THEN
         CALL CVMJAC ( MOD, NMAT, MATERF, TIMED, TIMEF,
     1                  YF,  DY,   NR, EPSD,   DEPS,  DRDY )
C
      ELSEIF ( LOI(1:7)  .EQ. 'NADAI_B' ) THEN
         CALL INSJAC ( MOD, NMAT, MATERF,
     1                  YF,  DY,   NR,  DRDY )
C
      ELSEIF ( LOI(1:8)  .EQ. 'MONOCRIS' ) THEN
         CALL LCMMJA ( MOD, NMAT, MATERF, TIMED, TIMEF,TEMPF,
     3                COMP,NBCOMM, CPMONO, PGL,NR,NVI,
     1                  YF,  DY,   DRDY )
      ENDIF
C
      END

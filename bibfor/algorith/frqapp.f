      SUBROUTINE FRQAPP(DT,NEQ,DEP1,DEP2,ACC1,ACC2,
     +                    VMIN,FREQ)
C
      IMPLICIT NONE
      INTEGER      I
      REAL*8       DEP1(*),DEP2(*),ACC1(*),ACC2(*),VMIN(*)
      REAL*8       FREQ,DT,A,B,TEMP
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C CALCUL DE LA FREQUENCE APPARENTE POUR LE CALCUL AVEC PAS ADAPTATIF
C ----------------------------------------------------------------------
C IN  : DT     : PAS DE TEMPS
C IN  : NEQ    : NOMBRE D'EQUATIONS
C IN  : DEP1   : DEPLACEMENTS AU TEMPS T
C IN  : DEP2   : DEPLACEMENTS AU TEMPS T+DT
C IN  : ACC1   : ACCELERATIONS AU TEMPS T
C IN  : ACC2   : ACCELERATIONS AU TEMPS T+DT
C IN  : VMIN   : VITESSES DE REFERENCE
C OUT : FREQ   : FREQUENCE APPARENTE
C ------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER NEQ 
      REAL*8 DD ,DMIN ,EPS ,EPSMI ,R8DEPI ,R8MIEM ,R8PREM 
      REAL*8 TT 
C-----------------------------------------------------------------------
      TEMP = R8PREM()
      EPS = R8PREM()
      EPSMI = R8MIEM()
      DO 10 I=1,NEQ
        A = ACC2(I)-ACC1(I)
        DMIN = VMIN(I)*DT
        DD = ABS(DEP2(I)-DEP1(I))
        IF (DMIN.GE.DD) THEN
           B = DMIN
        ELSE
           B = DD
        ENDIF
C       B = MAX(VMIN(I)*DT,ABS(DEP2(I)-DEP1(I)))
C       B DEVRAIT ETRE TOUJOURS NON NUL
        IF (B.LE.EPSMI) B=EPS
        TT = ABS(A/B)
        IF (TEMP.LE.TT) TEMP = TT
C       TEMP = MAX(TEMP,ABS(A/B))
10    CONTINUE
      FREQ = SQRT(TEMP)/R8DEPI()
      END

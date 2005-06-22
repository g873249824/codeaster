       SUBROUTINE NMVESO (RB, NB, RP, NP, DRBDB, DRBDP, DRPDB, DRPDP,
     &                   DP, DBETA, NR, CPLAN)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/06/2005   AUTEUR REZETTE C.REZETTE 
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
C-----------------------------------------------------------------------
       IMPLICIT NONE
C
       INTEGER     NB, NP, NR
       LOGICAL     CPLAN, FAUX
       REAL*8      RB(NB), RP(NP), DRBDB(NB,NB), DRBDP(NB,NP)
       REAL*8      DP(NP), DBETA(NB), DRPDP(NP,NP), DRPDB(NP,NB)
C ----------------------------------------------------------------------
C     INTEGRATION DE LA LOI DE COMPORTEMENT VISCO PLASTIQUE DE
C     CHABOCHE AVEC ENDOMAGEMENT
C     METHODE ITERATIVE D'EULER IMPLICITE
C
C     GENERATION ET RESOLUTION DU SYSTEME LINEAIRE DRDY(DY).DDY = -R(DY)
C-----------------------------------------------------------------------
       INTEGER     NMOD, I, IRET
       REAL*8      ZERO, UN, MUN, DET
       PARAMETER  ( NMOD = 25 )
       PARAMETER  ( ZERO = 0.D0   )
       PARAMETER  ( UN   = 1.D0   )
       PARAMETER  ( MUN   = -1.D0   )
C
       REAL*8      DRDY(NMOD,NMOD), R(NMOD)
       CHARACTER*1 TRANS,KSTOP
C 
C
C-----------------------------------------------------------------------
C-- 1. INITIALISATIONS
C-- 1.1. INITIALISATION DE L OPERATEUR LINEAIRE DU SYSTEME 
C                     DRDY = ( DRBDB, DRBDP )
C                            ( DRPDB, DRPDP )
C
        CALL LCICMA ( DRBDB,NB,NB,NB,NB,1,1,DRDY,NMOD,NMOD,1,1)
        CALL LCICMA ( DRBDP,NB,NP,NB,NP,1,1,DRDY,NMOD,NMOD,1,NB+1)
        CALL LCICMA ( DRPDB,NP,NB,NP,NB,1,1,DRDY,NMOD,NMOD,NB+1,1)
        CALL LCICMA ( DRPDP,NP,NP,NP,NP,1,1,DRDY,NMOD,NMOD,NB+1,NB+1)
C
C-- 1.2. INITIALISATION R = ( -RB , -RP )
C
        CALL LCPSVN ( NB, MUN, RB, R)
        CALL LCPSVN ( NP, MUN, RP, R(NB+1))
C
C-- 2. RESOLUTION DU SYSTEME LINEAIRE DRDY(DY).DDY = -R(DY)
C
        IF(CPLAN)THEN
           R(3) = ZERO
           DO 110 I  = 1 , NR
              DRDY(I,3) = ZERO
              DRDY(3,I) = ZERO
  110      CONTINUE
           DRDY(3,3) = UN
        ENDIF
C
        TRANS=' '
        KSTOP='S'
        CALL MGAUSS ( TRANS,KSTOP,DRDY , R , NMOD , NR , 1, DET, IRET)
        CALL LCEQVN ( NB , R , DBETA )
        CALL LCEQVN ( NP , R(NB+1) , DP )
C        
        END

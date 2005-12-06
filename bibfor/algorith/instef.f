      SUBROUTINE INSTEF ( NMAT,MATERF,SIGD,SIGF,VIND,VINF,
     1  ETATF, EPSD, DEPS, DSDE, JFIS1, NVI, MOD )
        IMPLICIT REAL*8 (A-H,O-Z)
C       -----------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 06/04/2004   AUTEUR DURAND C.DURAND 
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
C       -----------------------------------------------------------
C       NADAI_B :  TEST FISSURATION BETON A T+DT
C
C       IN  SIGD   :  CONTRAINTE A T
C       IN  SIGF   :  CONTRAINTE A T+DT (INTEGRATION ELASTIQUE SUR DT)
C       IN  EPSD   :  DEFORMATION A T
C       IN  DEPS   :  INCREMENT DE DEFORMATION TOTALE
C       IN  VIND   :  VARIABLES INTERNES A T
C       IN  NMAT   :  DIMENSION MATER
C       IN  MATERF :  COEFFICIENTS MATERIAU A T+DT
C       IN  NVI    :  NB VARIABLES INTERNES
C       IN  MOD    :  MODELISATION
C       OUT JFIS1  :  INDICATEUR DE FISSURATION (0 = NON, 1 = OUI)
C       OUT DSDE   :  MATRICE TANGENTE (BETON FISSURE)
C       OUT ETATF  :  ETAT ELASTIQUE OU PLASTIQUE (FISSURE)
C       OUT VINF   :  VARIABLES INTERNES A T+DT
C       OUT SIGF   :  CONTRAINTE A T+DT
C       -----------------------------------------------------------
        INTEGER       NMAT , NDT , NDI , NVI, JFIS1 ,LFISU
        REAL*8        VIND(*), VINF(*)
        CHARACTER*7   ETATF
        CHARACTER*8   MOD
C
        REAL*8        E0 , NU
        REAL*8        HOOKF(6,6) , MATERF(NMAT,2) , DSDE(6,6)
        REAL*8        SIGF(6) , SIGD(6) , DSIG(6) , EPSD(6) , DEPS(6)
        REAL*8        EPSR(6) , STRN(6) , SIGM(6) , SIGR(6) , SIGFT(6)
        REAL*8        SCT , SEUIL  , SEQF
C       ------------------------------------------------------------
        COMMON /TDIM/   NDT , NDI
C       ------------------------------------------------------------
C
        SCT = 0.D0
        JFIS1   = INT(VIND(NVI-1))
        CALL LCOPLI  ( 'ISOTROPE' , MOD , MATERF(1,1) , HOOKF )
        CALL LCPRMV ( HOOKF ,   DEPS , DSIG )
        CALL LCEQVN ( 6 , SIGD , SIGR )
        CALL LCEQVN ( 6 , DSIG , SIGM )
        CALL LCEQVN ( 6 , EPSD , EPSR )
        CALL LCEQVN ( 6 , DEPS , STRN )
C       ------------------------------------------------------------
        ETATF = 'ELASTIC'
       IF ( JFIS1 .EQ. 1 ) THEN
C
C   LE BETON EST DEJA FISSURE A L INSTANT T
C
        ETATF = 'PLASTIC'
        CALL INSVAR (EPSR, STRN, SIGR, SIGM, VIND, NVI,
     1       NMAT,MATERF, JFIS1)
        CALL INSFIS (EPSR,STRN,SIGR,SIGM,SIGF,VIND,VINF,DSDE,JFIS1,SCT,
     1       NMAT,MATERF,MOD)
C
       ELSE
C
        CALL INSNAT ( SIGF, NMAT, MATERF, SEQF , SEUIL )
C
        IF ( SEUIL .GT. 0.D0 ) THEN
C
           CALL INSSCT (SIGR, SIGM, VIND, SCT, NMAT, MATERF,LFISU)
C
           IF ( LFISU .EQ. 1 ) THEN
C
C   LE BETON FISSURE A L INSTANT T+DT
C
             ETATF = 'PLASTIC'
             CALL INSVAR (EPSR, STRN, SIGR, SIGM, VIND, NVI,
     1            NMAT,MATERF, JFIS1)
             CALL INSFIS (EPSR,STRN,SIGR,SIGM,SIGF,VIND,VINF,DSDE,
     1            JFIS1,SCT,NMAT,MATERF,MOD)
C
           ENDIF
        ENDIF
C
       ENDIF
      END

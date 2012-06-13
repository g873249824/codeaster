      SUBROUTINE RUNGE6( IPIF, DELTAT, TPGP, TPGM, HPGM, HPGP, ERR)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      INTEGER             IPIF
      REAL*8              DELTAT, TPGP, TPGM, HPGM, HPGP, ERR
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C     CALCUL DE h+ PAR RUNGE-KUTTA6
C     RESOLUTION DE DH/DT = f(HYDR,TEMP)
C ----------------------------------------------------------------------
C IN  IPIF  : POINTEUR DANS LE MATERIAU CODE (FONCTION OU NAPPE)
C IN  DELTAT  : PAS DE TEMPS
C IN  TPGP : TEMP A ITERATION NEWTON COURANTE
C IN  TPGM : TEMP A ITERATION PRECEDENTE
C IN  HPGM : HYDR A ITERATION PRECEDENTE
C OUT HPGP  : RESULTAT DE L'INTEGRATION HYDR � ITERATION NEWTON COURANTE
C OUT ERR : ERREUR ABSOLUE
C ----------------------------------------------------------------------
C
C
C
      REAL*8       F1,F2,F3,F4,F5,F6, VALPA(2)
      REAL*8       K1,K2,K3,K4,K5,K6, HPGPE
      REAL*8       A2,A3,A4,A5,A6
      REAL*8       B21,B31,B32,B41,B42,B43
      REAL*8       B51,B52,B53,B54
      REAL*8       B61,B62,B63
      REAL*8       B64,B65,C1,C2
      REAL*8       C3,C4,C5,C6
      REAL*8       CE1,CE2,CE3
      REAL*8       CE4,CE5,CE6
      CHARACTER*24 NOMPA(2)
C ----------------------------------------------------------------------
C DEFINITION DES COEFFICIENTS cf: numerical recipes
      A2=2.D-1
      A3=3.D-1
      A4=6.D-1
      A5=1.D0
      A6=8.75D-1
      B21=2.D-1
      B31=3.D0/40.D0
      B32=9.D0/40.D0
      B41=3.D-1
      B42=-9.D-1
      B43=1.2D0
      B51=-11.D0/54.D0
      B52=2.5D0
      B53=-70.D0/27.D0
      B54=35.D0/27.D0
      B61=1631.D0/55296.D0
      B62=175.D0/512.D0
      B63=575.D0/13824.D0
      B64=44275.D0/110592.D0
      B65=253.D0/4096.D0
      C1=37.D0/378.D0
      C2=0.D0
      C3=250.D0/621.D0
      C4=125.D0/594.D0
      C5=0.D0
      C6=512.D0/1771.D0
      CE1=20825.D0/27648.D0
      CE2=0.D0
      CE3=18575.D0/48384.D0
      CE4=13525.D0/55296.D0
      CE5=277.D0/14336.D0
      CE6=2.5D-1
C CALCUL DE K1
      VALPA(1)=HPGM
      VALPA(2)=TPGM
      NOMPA(1)='HYDR'
      NOMPA(2)='TEMP'
      CALL FOINTA(IPIF,2,NOMPA,VALPA,F1)
      K1= DELTAT*F1
C CALCUL DE K2
      VALPA(1)=HPGM+K1*B21
      VALPA(2)=TPGM+(TPGP-TPGM)*A2
      NOMPA(1)='HYDR'
      NOMPA(2)='TEMP'
      CALL FOINTA(IPIF,2,NOMPA,VALPA,F2)
      K2= DELTAT*F2
C CALCUL DE K3
      VALPA(1)=HPGM+B31*K1+B32*K2
      VALPA(2)=TPGM+(TPGP-TPGM)*A3
      NOMPA(1)='HYDR'
      NOMPA(2)='TEMP'
      CALL FOINTA(IPIF,2,NOMPA,VALPA,F3)
      K3= DELTAT*F3     
C CALCUL DE K4
      VALPA(1)=HPGM+B41*K1+B42*K2+B43*K3
      VALPA(2)=TPGM+(TPGP-TPGM)*A4
      NOMPA(1)='HYDR'
      NOMPA(2)='TEMP'
      CALL FOINTA(IPIF,2,NOMPA,VALPA,F4)
      K4= DELTAT*F4    
C CALCUL DE K5
      VALPA(1)=HPGM+B51*K1+B52*K2+B53*K3+B54*K4
      VALPA(2)=TPGM+(TPGP-TPGM)*A5
      NOMPA(1)='HYDR'
      NOMPA(2)='TEMP'
      CALL FOINTA(IPIF,2,NOMPA,VALPA,F5)
      K5= DELTAT*F5     
C CALCUL DE K6
      VALPA(1)=HPGM+B61*K1+B62*K2+B63*K3+B64*K4+B65*K5
      VALPA(2)=TPGM+(TPGP-TPGM)*A6
      NOMPA(1)='HYDR'
      NOMPA(2)='TEMP'
      CALL FOINTA(IPIF,2,NOMPA,VALPA,F6)
      K6= DELTAT*F6     
C CALCUL DE HPGP
      HPGP=HPGM+C1*K1+C2*K2+C3*K3+C4*K4+C5*K5+C6*K6
C--------------------
C 
C CALCUL DE L ERREUR
      HPGPE=HPGM+CE1*K1+CE2*K2+CE3*K3+
     &      CE4*K4+CE5*K5+CE6*K6
      ERR=ABS(HPGP-HPGPE)
      END

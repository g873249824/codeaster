      SUBROUTINE EDROTG (VIP,X,RLAG,DVIDA)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/07/2003   AUTEUR ADBHHVV V.CANO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ADBHHVV V.CANO
    
      IMPLICIT NONE  
      REAL*8         VIP(12),X,RLAG,DVIDA(0:3,0:3)       
      
C ***************************************************************
C *       INTEGRATION DE LA LOI DE ROUSSELIER NON LOCAL         *
C * CALCUL DE LA DERIVEE DES VARIABLES P0 ET PGRAD PAR RAPPORT  *
C * AUX CHAMP P0 = B0*P ET P-GRADIENT = B-GRADIENT*P            *
C * AVEC P VECTEUR DU CHAMPS AUX NOEUDS                         *

C IN  VIP    : VARIABLES INTERNES A L'INSTANT ACTUEL
C IN  X      : = TRE - TRETR
C IN  AGRTR  : 
C IN  S      :
C IN  RLAG   : PARAMETRE DE PENALISATION DU LAGRANGIEN AUGMENTE
C OUT DVIDA  : DERIVEE DE P0 ET PGRAD/ AUX CHAMPS AUX NOEUDS

      INTEGER ITEMAX, JPROLP, JVALEP, NBVALP
      REAL*8  YOUNG,NU,MU,K,SIGY
      REAL*8  SIG1,D,F0,FCR,ACCE
      REAL*8  FONC,EQETR,PM,RPM,PENTEM,PENTE,PREC
      REAL*8  C1,C2,C3,C4(3),LB,LC
      COMMON /EDROU/ YOUNG,NU,MU,K,SIGY,
     &               SIG1,D,F0,FCR,ACCE,
     &               FONC,EQETR,PM,RPM,PENTEM,PENTE,PREC,
     &               C1,C2,C3,C4,LB,LC,
     &               ITEMAX, JPROLP, JVALEP, NBVALP

      INTEGER I,J1
      REAL*8  COEFF1,COEFF2

      DO 10 I=0,3
       DO 20 J1=0,3
        DVIDA(I,J1)=0.D0
 20    CONTINUE
 10   CONTINUE     

C 1 - CAS ELASTIQUE

      IF (VIP(12).EQ.0.D0) THEN
       COEFF1=0.D0
       COEFF2=1.D0
      ENDIF     

C 2 - CAS GENERAL

      IF (VIP(12).EQ.1.D0) THEN
       COEFF1=(1.D0+K*X/SIG1)/FONC
       COEFF2=FONC*K*EXP(-2.D0*K*X/SIG1)+(PENTE+C1+3.D0*MU)*COEFF1
      ENDIF

C 3 - CAS PARTICULIER

      IF (VIP(12).EQ.2.D0) THEN
       COEFF1=(1.D0+K*X/SIG1)/FONC
       COEFF2=FONC*K*EXP(-2.D0*K*X/SIG1)+(PENTE+C1)*COEFF1
      ENDIF
            
      DVIDA(0,0)=C1*COEFF1/COEFF2
      DVIDA(1,1)=RLAG/(1.D0+RLAG)
      DVIDA(2,2)=RLAG/(1.D0+RLAG)
      DVIDA(3,3)=RLAG/(1.D0+RLAG)
      
      END

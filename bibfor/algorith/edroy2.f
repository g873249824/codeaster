      REAL*8 FUNCTION EDROY2 (YMIN)

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
      REAL*8   YMIN

C *********************************************************************
C *        INTEGRATION DE LA LOI DE ROUSSELIER NON LOCAL              *
C *    RESOLUTION DE SEUIL(Y)=0 QUAND S(0)<0 AVEC S(YMIN)=0           *
C *    PAR UNE METHODE DE NEWTON AVEC BORNES CONTROLEES ET DICHOTOMIE *
C *     - LA BORNE INFERIEURE EST YINF=YMIN                           *
C *     - LA BORNE SUPERIEURE EST TELLE QUE:                          *
C *       YSUP*EXP(YSUP)                                              *
C *       =K*FONC*(2*EQTR*ALF1/3+ALF2*NAGRTR/(3*MU*LB))/SIG1          *
C *********************************************************************

C IN  YMIN   : MINORANT DE LA SOLUTION ( S(YM)=0 )

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

      INTEGER ITER
      REAL*8  S,SEUIL, DSEUIL
      REAL*8  T, Y, DP, YINF, YSUP
      REAL*8  LCROTY
      
C 1 - CALCUL DES BORNES
C     LCROTY RESOUD UNE EQUATION DU TYPE Y*EXP(Y)=CONSTANTE

      YINF = YMIN
      CALL EDROFG(YINF, DP, S, SEUIL, DSEUIL)      
      
      T    = 2.D0*EQETR/3.D0
      YSUP = LCROTY(T*K*FONC/SIG1, PREC, ITEMAX)
      CALL EDROFG(YSUP, DP, S, SEUIL, DSEUIL)
      
      
C 2 - RESOLUTION PAR UNE METHODE DE NEWTON ENTRE LES BORNES

      Y = YSUP
      DO 10 ITER = 1, ITEMAX
       CALL EDROFG(Y, DP, S, SEUIL, DSEUIL)
       IF (SEUIL.GE.0.D0) YINF = Y
       IF (SEUIL.LE.0.D0) YSUP = Y        
       IF ( ABS(SEUIL)/SIGY .LE. PREC ) GOTO 100
       Y = Y - SEUIL/DSEUIL
       IF (Y.LE.YINF .OR. Y.GE.YSUP)  Y=(YINF+YSUP)/2
 10   CONTINUE
      CALL UTMESS('F','ROUSSELIER EDROY2','ITER_INTE_MAXI INSUFFISANT')

 100  CONTINUE
      EDROY2 = Y
      END 

      REAL*8 FUNCTION EDROY1 ()

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

C ********************************************************************
C *       INTEGRATION DE LA LOI DE ROUSSELIER NON LOCAL              *
C *  CALCUL DE BORNES INF ET SUP DE LA FONCTION SEUIL(Y) QUAND S(0)>0*
C *  ET RESOLUTION DE SEUIL(Y)=0                                     *
C *  PAR UNE METHODE DE NEWTON AVEC BORNES CONTROLEES ET DICHOTOMIE  *
C *  - LA BORNE INFERIEURE EST OBTENUE EN RESOLVANT                  *
C *    UNE EQUATION DU TYPE :                                        *
C *    SIEQ-R(PM+DPINF)=3*MUTILD*DPINF       => ON EN DEDUIT DPINF   *
C *    AVEC SIEQ=2*MU*ALF(1)*EQETR/ALF(3)+                           *
C *              ALF(2)*NAGRTR/(LB*ALF(3))-C1*PM+C2                  *
C *          MUTILD=YOUNTILD/(2*(1+NUTILD))                          *
C *          NUTILD=NU ET YOUNTILD=2*(1+NU)*(C1+ALF(4)/ALF(3))/3     *
C *    YINF*EXP(YINF)=K*FONC*DPINF/SIG1      => ON EN DEDUIT YINF    *
C *  - LA BORNE SUPERIEURE EST TELLE QUE:                            *
C *    YSUP*EXP(YSUP) =                                              *
C *    K*FONC*(2*MU*ALF(1)*EQTR+ALF(2)*                              *
C *    NAGRTR/LB-ALF(3)*S(YINF))/ALF(4)*SIG1                         *
C ********************************************************************

C OUT  Y   : VALEUR DE Y TEL QUE SEUIL(Y)=0

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
      REAL*8  SIEQ,YOUN,SEUIL, DSEUIL, S
      REAL*8  Y,DP,YINF,YSUP,T,RP,AIRE
      REAL*8  R8BID, LCROTY
      
C 1 - CALCUL DU MINORANT

      IF (2.D0*MU*EQETR-RPM.LE.0.D0) THEN      
        YINF = 0
      ELSE

C RESOLUTION DE L'EQUATION SANS LE TERME DE TRACE
C LCROTY RESOUD UNE EQUATION DU TYPE Y*EXP(Y)=CONSTANTE

        SIEQ=2.D0*MU*EQETR-C1*PM+C2
        YOUN =2.D0*(1.D0+NU)*(C1+3.D0*MU)/3.D0
        
        CALL RCFONC('E','TRACTION',JPROLP,JVALEP,NBVALP,R8BID,YOUN,
     &                      NU,PM,RP,PENTE,AIRE,SIEQ,DP)
     
        YINF = LCROTY(DP*K*FONC/SIG1, PREC, ITEMAX)
      END IF

C 2 - CALCUL DU MAJORANT
C LCROTY RESOUD UNE EQUATION DU TYPE Y*EXP(Y)=CONSTANTE
      
      CALL EDROFG (YINF, DP, S, SEUIL, DSEUIL)
      T=(2.D0*MU*EQETR-S)/3.D0*MU
      YSUP =  LCROTY(T*K*FONC/SIG1, PREC, ITEMAX)
      
C 3 - RESOLUTION PAR UNE METHODE DE NEWTON ENTRE LES BORNES
      
      Y = YINF
      IF ((Y.EQ.0.D0).AND.(ABS(SEUIL)/SIGY .LE. PREC )) THEN
       Y=YSUP
       CALL EDROFG (YSUP, DP, S, SEUIL, DSEUIL)
      ENDIF
      DO 10 ITER = 1, ITEMAX        
        IF ( ABS(SEUIL)/SIGY .LE. PREC ) GOTO 100
        
        Y = Y - SEUIL/DSEUIL
        IF (Y.LE.YINF .OR. Y.GE.YSUP)  Y=(YINF+YSUP)/2
        
        CALL EDROFG (Y, DP, S, SEUIL, DSEUIL)
        
        IF (SEUIL.GE.0) YINF = Y
        IF (SEUIL.LE.0) YSUP = Y
       
 10   CONTINUE
      CALL UTMESS('F','ROUSSELIER EDROY1','ITER_INTE_MAXI INSUFFISANT')


 100  CONTINUE
      EDROY1 = Y
      END 

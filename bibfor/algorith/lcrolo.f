      SUBROUTINE LCROLO (NDIM,IMATE,OPTION,COMPOR,CARCRI,TM,TP,TREF, 
     &                    FM,DF,VIM,VIP,SIGP,DSIGDF,IRET)
     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/02/2002   AUTEUR ADBHHVV V.CANO 
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
C RESPONSABLE ADBHHVV V.CANO

      IMPLICIT NONE
      INTEGER            NDIM,IMATE,IRET
      CHARACTER*16      OPTION,COMPOR(3)
      REAL*8             CARCRI(3)
      REAL*8             TM,TP,TREF
      REAL*8             FM(3,3),DF(3,3),VIM(9)
      REAL*8             VIP(9),SIGP(*),DSIGDF(6,3,3)

C......................................................................
C       INTEGRATION DE LA LOI DE ROUSSELIER LOCAL
C   EN GRANDES DEFORMATIONS DE TYPE NOUVELLE FORMULATION DE SIMO-MIEHE
C......................................................................
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  IMATE   : ADRESSE DU MATERIAU CODE
C IN  OPTION  : OPTION DE CALCUL
C IN  COMPOR  : COMPORTEMENT
C IN  CARCRI  : PARAM7TRES POUR L INTEGRATION DE LA LOI DE COMMPORTEMENT
C                CARCRI(1) = NOMBRE D ITERATIONS
C                CARCRI(3) = PRECISION SUR LA CONVERGENCE
C IN  TM      : TEMPERATURE A L'INSTANT PRECEDENT
C IN  TP      : TEMPERATURE A L'INSTANT DU CALCUL
C IN  TREF    : TEMPERATURE DE REFERENCE
C IN  FM      : GRADIENT DE LA TRANSFORMATION A L INSTANT PRECEDENT
C IN  DF      : INCREMENT DU GRADIENT DE LA TRANSFORMATION
C IN  VIM     : VARIABLES INTERNES A L INSTANT DU CALCUL PRECEDENT
C         VIM(1)   = P (DEFORMATION PLASTIQUE CUMULEE)
C         VIM(2)   = POROSITE
C         VIM(3:8) = DEFORMATION ELASTIQUE EULERIENNE EE = (ID-BE)/2)
C         VIM(9)   = INDICATEUR DE PLASTICITE
C                  = 0 SOLUTION ELASTIQUE
C                  = 1 SOLUTION PLASTIQUE
C                  = 2 SOLUTION PLASTIQUE SINGULIERE
C OUT VIP     : VARIABLES INTERNES A L'INSTANT ACTUEL
C OUT SIGP    : CONTRAINTE A L INSTANT ACTUEL
C OUT DSIGDF  : DERIVEE DE SIGMA PAR RAPPORT A DF
C OUT IRET    : CODE RETOUR SUR L INTEGRATION DE LA LDC
C               SI LA FONCTION FONC = D*POROM*EXP(-K*TRETR/SIG1) 
C               EST TROP GRANDE OU TROP PETITE ON REDECOUPE GLOBALEMENT 
C               LE PAS DE TEMPS
C
C          ATTENTION LES TENSEURS ET MATRICES SONT RANGES DANS
C          L'ORDRE :  XX,YY,ZZ,XY,XZ,YZ
C.......................................................................

      INTEGER ITEMAX, JPROLP, JVALEP, NBVALP
      REAL*8  YOUNG,NU,MU,K,SIGY,ALPHA
      REAL*8  SIG1,D,F0,FCR,ACCE
      REAL*8  FONC,EQETR,PM,RPM,PREC
      COMMON /LCROU/ YOUNG,NU,MU,K,SIGY,ALPHA,
     &               SIG1,D,F0,FCR,ACCE,
     &               FONC,EQETR,PM,RPM,PREC,
     &               ITEMAX, JPROLP, JVALEP, NBVALP

      INTEGER I,J1,K1,INDICE
      REAL*8  INFINI, R8GAEM,PETIT,R8PREM
      REAL*8  JM,DJ,J
      REAL*8  EM(6),ETR(6),TRETR,TREP,DVETR(6)
      REAL*8  DTEMPE,TROISK,LAMBDA,DEUXMU
      REAL*8  SP(6),EP(6),TAUP(6)
      REAL*8  Y,YM,X,SEUIL,DSEUIL,S,DP
      REAL*8  DETRDF(6,3,3)
      REAL*8  KR(6),PDTSCA(6)
      REAL*8  LCROY1, LCROY2, LCROYI
      INTEGER    IND(3,3)
      DATA        KR/1.D0,1.D0,1.D0,0.D0,0.D0,0.D0/
      DATA        PDTSCA/1.D0,1.D0,1.D0,2.D0,2.D0,2.D0/
      DATA        IND/1,4,5,
     &                4,2,6,
     &                5,6,3/
                   
C 1 - RECUPERATION DES CARACTERISTIQUES DU MATERIAU 
C     ET DES CARACTERISTIQUES DE L INTEGRATION

      ITEMAX = NINT(CARCRI(1))
      PREC   = CARCRI(3)

      PM     = VIM(1)
      CALL LCROMA(IMATE, TP)
            
      IF (VIM(2) .LT. F0)  VIM(2) = F0
      
      TROISK=3.D0*K
      LAMBDA = YOUNG*NU / ((1.D0+NU)*(1.D0-2.D0*NU))
      DEUXMU = 2.D0*MU
      
C 2 - CALCUL DU JACOBIEN J

      JM=FM(1,1)*(FM(2,2)*FM(3,3)-FM(2,3)*FM(3,2))
     &  -FM(2,1)*(FM(1,2)*FM(3,3)-FM(1,3)*FM(3,2))
     &  +FM(3,1)*(FM(1,2)*FM(2,3)-FM(1,3)*FM(2,2))

      DJ=DF(1,1)*(DF(2,2)*DF(3,3)-DF(2,3)*DF(3,2))
     &  -DF(2,1)*(DF(1,2)*DF(3,3)-DF(1,3)*DF(3,2))
     &  +DF(3,1)*(DF(1,2)*DF(2,3)-DF(1,3)*DF(2,2))

      J=JM*DJ
      
C 3 - CALCUL CONCERNANT LA DEFORMATION ELASTIQUE ETR 
C 3.1 - APPEL DE LA ROUTINE CLETDR QUI CALCULE 
C       ETR(IJ)=(ID(IJ)-DF(IK)*DF(JK))/2+DF(IK)*EM(KP)*DF(JP) 
C       ET LA DERIVE DE ETR PAR RAPPORT A DF

      CALL R8COPY(6, VIM(3),1, EM, 1)
      CALL CLETDR (DF,EM,OPTION,ETR,DETRDF)
                    
C 3.2 - CALCUL DE LA TRACE - DEVIATEUR ET EQUIVALENT DE ETR         
      
      TRETR=ETR(1)+ETR(2)+ETR(3)
      EQETR=0.D0
      DO 10 I=1,6
       DVETR(I)=ETR(I)-KR(I)*TRETR/3.D0
       EQETR=EQETR+PDTSCA(I)*(DVETR(I)**2.D0)
 10   CONTINUE
      EQETR=SQRT(1.5D0*EQETR)

C 4 - CALCUL DE LA FONCTION FONC ET TEST
      
      INFINI = R8GAEM()
      PETIT  = R8PREM()
      DTEMPE=TP-TREF
      FONC = D*VIM(2)*EXP(-K*TRETR/SIG1)*EXP(-3.D0*K*ALPHA*DTEMPE/SIG1)
      IF ((FONC.GE.INFINI).OR.(FONC.LE.PETIT)) THEN
       IRET = 1
       GOTO 999
      ENDIF

C 5 - INTEGRATION DE LA LOI DE COMPORTEMENT 
C     PAR METHODE DE NEWTON AVEC BORNES CONTROLEES ET DICHOTOMIE
C  RESOLUTION DES EQATIONS:
C  - SI SEUIL(0)<0 => LA SOLUTION EST ELASTIQUE SINON
C  - SI S(0)>0     => LA SOLUTION EST PLASTIQUE ET REGULIERE
C                     ON RESOUD SEUIL(Y)=0
C  - SI S(0)<0     => ON RESOUD S(YS)=0 
C                     YS EST SOLUTION SINGULIERE SI DP>2*EQ(DVE-DVETR)/3
C  - SINON ON RESOUD SEUIL(Y)=0 POUR Y>YS   
C  AVEC  SEUIL(Y)= 2*MU*EQETR-S(Y)-3*MU*DP(Y)
C        Y       = K*X/SIG1
C        X       = TRE-TRETR
C        DP      = (Y*SIG1/K)*EXP(Y)/FONC
C        S(Y)    = -SIG1*FONC*EXP(-Y)+R(PM+DP)
     
      IF(OPTION(1:9).EQ.'RAPH_MECA'.OR.
     &   OPTION(1:9).EQ.'FULL_MECA') THEN

C 5.1 - EXAMEN DE LA SOLUTION ELASTIQUE (Y=0)
C       LCROFG = CALCUL DU SEUIL ET DE SA DERIVEE 
C                IN : Y - OUT : DP,S,SEUIL,DSEUIL

       Y = 0
       CALL LCROFG (Y, DP, S, SEUIL, DSEUIL)
       IF (SEUIL.LE.0.D0) THEN
        INDICE=0
        GOTO 600
       ENDIF 

C 5.2 - RESOLUTION SEUIL(Y)=0 QUAND S(0)>0
C       CALCUL DE Y PUIS DU DP CORRESPONDANT
 
       IF (S .GT. 0) THEN
        Y = LCROY1()
        CALL LCROFG (Y, DP, S, SEUIL, DSEUIL)
        INDICE = 1
        GOTO 600
       END IF

C 5.3 - EXAMEN DE LA SOLUTION SINGULIERE ( S(0)<0 )
C 5.3.1 - RESOLUTION S(Y)=0
C         CALCUL DE Y PUIS DU DP CORRESPONDANT     

       Y = LCROYI()
       CALL LCROFG (Y, DP, S, SEUIL, DSEUIL)

C 5.3.2 - CONDITION POUR SOLUTION SINGULIERE        
      
       IF ( 2*EQETR/3.D0-DP .LE. 0 ) THEN
        INDICE=2
        GOTO 600
       END IF
       YM = Y

C 5.4 - RESOLUTION SEUIL(Y)=0 QUAND S(0)<0 : ON A S(YM)=0
C       CALCUL DE Y PUIS DU DP CORRESPONDANT

       Y = LCROY2(YM)
       CALL LCROFG (Y, DP, S, SEUIL, DSEUIL)
       INDICE=1
     
 600   CONTINUE

C FIN DE LA RESOLUTION

C 6 - CALCUL DES VARIABLES INTERNES EN T+

       X      = SIG1*Y/K
       VIP(1) = PM+DP       
       VIP(2) = 1.D0-(1.D0-VIM(2))*EXP(-X)
       IF (VIP(2).GE.FCR) THEN
        VIP(2) = 1.D0-(1.D0-VIM(2))*EXP(-ACCE*X)
       ENDIF
       VIP(9) = INDICE
       IF (INDICE .EQ. 2) THEN
        DO 55 I=1,6
         VIP(2+I)=KR(I)*(X+TRETR)/3.D0
 55     CONTINUE       
       ELSE
        IF(EQETR.LE.0.D0) THEN
         DO 56 I=1,6
          VIP(2+I)=DVETR(I)+KR(I)*(X+TRETR)/3.D0
 56      CONTINUE
        ELSE
         DO 60 I=1,6
          VIP(2+I)=DVETR(I)*(1.D0-3.D0*DP/(2.D0*EQETR))
     &           +KR(I)*(X+TRETR)/3.D0
 60      CONTINUE
        ENDIF
       ENDIF

C 7 - CALCUL DES CONTRAINTES EN T+

       TREP=VIP(3)+VIP(4)+VIP(5)
       DO 65 I=1,6
        EP(I)=VIP(2+I)
        SP(I) = -DEUXMU*EP(I) - LAMBDA*TREP*KR(I) 
     &       -  TROISK*ALPHA*(TP-TREF)*KR(I)
 65    CONTINUE
      
       DO 70 I=1,3
        DO 75 J1=1,3
         TAUP(IND(I,J1))=SP(IND(I,J1))
         DO 80 K1=1,3
          TAUP(IND(I,J1))=TAUP(IND(I,J1))
     &      -2.D0*SP(IND(I,K1))*EP(IND(K1,J1))
 80      CONTINUE
 75     CONTINUE
 70    CONTINUE
 
       DO 85 I=1,2*NDIM
        SIGP(I)=TAUP(I)/J
 85    CONTINUE
      ENDIF
                   
C 8 - CALCUL DE LA MATRICE TANGENTE

      IF(OPTION(1:14).EQ.'RIGI_MECA_TANG'.OR.
     &  OPTION(1:9) .EQ.'FULL_MECA') THEN
      
       CALL LCROTG (OPTION,IMATE,TM,TP,TREF,J,JM,DF,VIP,VIM,
     &              DETRDF,DSIGDF)
      
      ENDIF
 999  CONTINUE      
      END

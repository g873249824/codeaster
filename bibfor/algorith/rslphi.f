      SUBROUTINE RSLPHI(LOI,IMAT,TEMPF,TROISK,TROIMU,DEPSMO,RIGDMO,
     &       RIELEQ,PI,D,S1,ANN,THETA,ACC,F,DF,SIG0,EPS0,MEXPO,DT,
     &       PHI,PHIP,RIGEQ,RIGM,P,OVERFL)
      IMPLICIT NONE
C       ======================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 08/08/2002   AUTEUR CIBHHLV L.VIVAN 
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
C TOLE CRP_21
C       ======================================================
C       CALCUL DE LA FONCTION A ANNULER ET SA DERIVE POUR
C          CALCULER L'INCREMENT DF POUR LA LOI DE ROUSSELIER
C          PHI(DF)=RIGEQ(DF)-R(P(DF))+D*S1*F(DF)*EXP(RIGM(DF)/S1)=0 
C
C       IN  IMAT   :  ADRESSE DU MATERIAU CODE
C           TEMPF  :  TEMPERATURE
C           TROISK :  ELASTICITE : PARTIE MOYENNE
C           TROIMU :  ELASTICITE : 2/3*PARTIE DEVIATORIQUE
C           DEPSMO :  INCREMENT DEFORMATION : PARTIE MOYENNE
C           RIGDMO :  CONTRAINTE REDUITE INITIALE : PARTIE MOYENNE
C           RIELEQ :  (SIGFDV/RHO+2MU*DEPSDV)     : PARTIE EQUIVALENTE
C           PI     :  PLASTICITE CUMULE INITIALE
C           F      :  INCONNU (POROSITE)
C           DF     :  INCREMENT D INCONNU
C           DT     :  INTERVALLE DE TEMPS DT
C       OUT PHI    :  FONCTION A ANNULE
C           PHIP   :  DERIVE DE PHI / INCONNU
C           RIGEQ  :  CONTRAINTE EQUIVALENTE 
C           RIGM   :  CONTRAINTE MOYENNE 
C           P      :  PLASTICITE CUMULE 
C       -------------------------------------------------------------
       INTEGER       IMAT
C
       CHARACTER*16  LOI
C
       REAL*8        TEMPF, TROISK, TROIMU, DEUX, COEFFA, DT
       REAL*8        RIELEQ, RIGEQ, RIGM, DEPSMO, RIGDMO, COEFFB
       REAL*8        PI, P, DP, F, DF, PHI, PHIP, D, S1, DISCRI
       REAL*8        RP, DRDP, D13, UN, UNMF, UNEX, DUNEX
       REAL*8        DRIGM, DDP, ACC, EXPO, DEXPO,PTHETA
       REAL*8        COEFFC, THETA, FTHETA , FTOT, ANN, ZERO
       REAL*8        SIG0, EPS0, MEXPO, EXPLUS, PUISS
       REAL*8        SEUIL, DSEUIL, DPUISS, ASINH, LV1, LV2, LV3
C
       LOGICAL       OVERFL
C
       PARAMETER       ( UN     = 1.D0  ) 
       PARAMETER       ( ZERO   = 0.D0  ) 
       PARAMETER       ( DEUX   = 2.D0  )
       PARAMETER       ( D13    = .33333333333333D0 )
C
C      -------------------------------------------------------------
C   
       FTHETA = F - (UN - THETA)*DF
       UNMF = (UN-FTHETA)
C
C ----- CALCUL DE RIGM ET DRIGM/DDF---------------
       RIGM  =  RIGDMO + TROISK*THETA*(DEPSMO - D13*DF/UNMF/ACC)
       DRIGM = -TROISK*D13*THETA*(UNMF+THETA*DF)/(UNMF**2)/ACC
       EXPO  =  D*EXP(RIGM/S1)       
       DEXPO =  EXPO*(DRIGM/S1)
       UNEX  =  UNMF*EXPO*ACC
       DUNEX = (-THETA*EXPO + UNMF*DEXPO)*ACC
C 
C ----- CALCUL DE DP ET DDP/DDF-----------
C ----- ABSENCE DE GERMINATION---------------      
       IF (ANN.EQ.ZERO) THEN
         DP  = DF/(FTHETA*UNEX)
         DDP = (UN - DF*DUNEX/UNEX -DF*THETA/FTHETA)/(FTHETA*UNEX)
C ----- AN NON NUL---------------
       ELSE
         COEFFA = DEUX*ANN*THETA
         COEFFB = FTHETA + ANN*PI 
         COEFFC  = DF/UNEX
         DISCRI  = COEFFB**2 + DEUX*COEFFA*COEFFC
         DP=(-COEFFB+SQRT(DISCRI))/COEFFA
         DDP=((UN-DF*DUNEX/UNEX )/UNEX -THETA*DP)/(COEFFA*DP+COEFFB)
       ENDIF
       P = PI+DP
       PTHETA= PI +THETA*DP
C --- RESTONS DANS LES LIMITES DU RAISONNABLE ----
       IF (P .GT. 1.D100) THEN
         OVERFL = .TRUE.
         GOTO 9999
       ELSE
         OVERFL = .FALSE.
       ENDIF
C
C ----- CALCUL DE RIGEQ ---------------
       RIGEQ = RIELEQ - TROIMU*THETA*DP
C
C ----- CALCUL DE R(P) ET DR/DP(P) ----
       CALL RSLISO (IMAT, TEMPF, PTHETA, RP, DRDP)
C
       FTOT = FTHETA + ANN*PTHETA
C
C ----- CALCUL DE PHI ----------------- 
C
           PHI  = RIGEQ - RP + S1*FTOT*EXPO

C
C ----- CALCUL DE DPHI/DDF ------------- 
C
           PHIP  = S1*(FTOT*DEXPO + (THETA + ANN*THETA*DDP)*EXPO)
     &             -(TROIMU+DRDP)*THETA*DDP

C
       IF (LOI(1:10).EQ.'ROUSS_VISC') THEN
          SEUIL = PHI
          DSEUIL = PHIP
C          PUISS = (DP/(DT*EPS0))**(UN/MEXPO)
C          DPUISS = ( (DP/(DT*EPS0))**(UN/MEXPO-UN) )/( MEXPO*DT*EPS0 )
          IF ( DP .EQ. 0.D0 ) THEN
             PUISS  = 0.D0
             DPUISS = 0.D0
          ELSE
             LV1 = DP / (DT*EPS0)
             LV2 = UN / MEXPO - UN
             LV3 = MEXPO * DT * EPS0
             PUISS = ( LV1 )**(UN/MEXPO)
             DPUISS = ( LV1**LV2 ) / LV3
          ENDIF
C
          ASINH = LOG(PUISS + SQRT(UN + PUISS**2))     
          PHI = SEUIL - SIG0*ASINH
          PHIP = DSEUIL - SIG0*DDP*DPUISS/SQRT(UN+PUISS**2)
       END IF     
C
C ----- ET C EST FINI -------------
 9999  CONTINUE
        END

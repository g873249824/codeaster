      SUBROUTINE FGDVIL(TPS,S,TEMP,FLUPHI,A,B,CTPS,ENER,
     &                  F1,FP1,FS1,F2,
     &                  FP2,FS2,G1,DG1DS,G2,DG2DS)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/03/2004   AUTEUR MABBAS M.ABBAS 
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
C
      IMPLICIT NONE
      REAL*8 TPS,S,TEMP,FLUPHI,A,B,CTPS,ENER
      REAL*8 F1,FP1,FS1,F2
      REAL*8 FP2,FS2,G1,DG1DS,G2,DG2DS
C
CDEB
C---------------------------------------------------------------
C     CALCUL DES FONCTIONS F1,G1,F2,G2 ET DE LEURS DERIVEES
C---------------------------------------------------------------
C IN  TPS   :R: TEMPS
C     S     :R: CONTRAINTE EQUIVALENTE SIGMA
C     TEMP  :R: TEMPERATURE DU POINT CONSIDERE
C     FLUPHI:R: PARAMETRE FLUX_PHI
C     A     :R: PARAMETRE A
C     B     :R: PARAMETRE B
C     CTPS  :R: PARAMETRE CSTE_TPS
C     ENER  :R: PARAMETRE ENER_ACT
C OUT F1    :R: VALEUR DE F1(TPS)
C     FP1   :R: VALEUR DE F'1(TPS)
C     FS1   :R: VALEUR DE F"1(TPS)
C     F2    :R: VALEUR DE F2(TPS)
C     FP2   :R: VALEUR DE F'2(TPS)
C     FS2   :R: VALEUR DE F"2(TPS)
C     G1    :R: VALEUR DE G1(SIGMA,T)
C     DG1DS :R: VALEUR DE DG1/DSIGMA(SIGMA,T)
C     G2    :R: VALEUR DE G2(SIGMA,T)
C     DG2DS :R: VALEUR DE DG2/DSIGMA(SIGMA,T)
C---------------------------------------------------------------
C     CETTE ROUTINE CALCULE LES FONCTIONS F1,G1,F2,G2 DANS :
C
C            EV = F1(TPS)*G1(S,T) + F2(TPS)*G2(S,T)
C
C      ET LEURS DERIVEES F'1,F"1,DG1/DSIGMA,F'2,F"2,DG2/DSIGMA
C---------------------------------------------------------------
CFIN
C
      REAL*8 R3R2,NRJACT
C
C----CONSTANTES
      R3R2 = SQRT(3.D0/2.D0)
      R3R2 = 1.D0
      
      NRJACT = ENER
C
C----CALCUL DE F1,FP1,FS1---------------------------------------
C

      IF ((1+(CTPS*TPS*FLUPHI)).LE.0.D0) THEN 
         CALL UTMESS('F','FGDVIL_1','ERREUR LOG NEGATIF OU NUL')
      ENDIF

      F1 = LOG(1+CTPS*TPS*FLUPHI)
      FP1= CTPS*FLUPHI / (1+CTPS*TPS*FLUPHI)
      FS1= -(CTPS*FLUPHI*CTPS*FLUPHI) / 
     &            ((1+CTPS*TPS*FLUPHI)*(1+CTPS*TPS*FLUPHI))
      FS1 = -FP1*FP1
      
      
C
C----CALCUL DE F2,FP2,FS2---------------------------------------
C
      F2 = TPS*FLUPHI
      FP2= FLUPHI
      FS2= 0.D0
C
C----CALCUL DE G1,DG1DS-----------------------------------------
C
      G1 = A*EXP(-NRJACT/(TEMP+273.15D0))*S*R3R2
      DG1DS = A*EXP(-NRJACT/(TEMP+273.15D0))*R3R2
C
C----CALCUL DE G2,DG2DS-----------------------------------------
C
      G2 = B*EXP(-NRJACT/(TEMP+273.15D0))*S*R3R2
      DG2DS = B*EXP(-NRJACT/(TEMP+273.15D0))*R3R2      

299   CONTINUE
      END

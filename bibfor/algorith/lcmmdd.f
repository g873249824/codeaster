      SUBROUTINE LCMMDD(TAUS,COEFT,IFA,NMAT,NBCOMM,IS,NBSYS,HSR,
     &    VIND,DY,DT,RP,DALPHA,DGAMMA,DP,IRET)
C     ----------------------------------------------------------------
      IMPLICIT NONE
      INTEGER IFA,NMAT,NBCOMM(NMAT,3),IRET
      INTEGER IFL,IS,IR,NBSYS
      REAL*8 TAUS,COEFT(NMAT),DGAMMA,DP,VIND(*),DALPHA 
      REAL*8 RP,SGNS,HSR(5,24,24),DY(12),DT
      REAL*8 N,GAMMA0,R8MIEM,RMIN,ALPHAR(12),R8MAEM
      REAL*8 TAUF,ALPHAM(12),TERME,RMAX,HS,SOMS1,SOMS2,SOMS3
C     ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/07/2010   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
C TOLE CRP_21
C RESPONSABLE PROIX J-M.PROIX
C ======================================================================
C  COMPORTEMENT MONOCRISTALLIN : ECOULEMENT (VISCO)PLASTIQUE
C  INTEGRATION DE LA LOI MONOCRISTALLINE DD-CFC. CALCUL DE DALPHA DGAMMA
C       IN  TAUS    :  SCISSION REDUITE
C           COEFT   :  PARAMETRES MATERIAU
C           IFA     :  NUMERO DE FAMILLE
C           CISA2   :  COEF DE CISAILLEMENT MU
C           NMAT    :  NOMBRE MAXI DE MATERIAUX
C           NBCOMM  :  NOMBRE DE COEF MATERIAU PAR FAMILLE
C           NBSYS   :  NOMBRE DE SYSTEMES DE GLISSEMENT
C           HSR     :  Hsr 
C           VIND    :  tous les variables internes instant precedent 
C           DT      :  INTERVALLE DE TEMPS EVENTULLEMENT REDECOUPE
C           YD      :  
C           DY      :  
C     OUT:
C           DALPHA  :  VARIABLE densite de dislocation
C           DGAMMA  :  DEF PLAS
C           IRET    :  CODE RETOUR
C ======================================================================
      
      IFL=NBCOMM(IFA,1)
      RMIN=R8MIEM()
      RMAX=LOG(R8MAEM())
      TAUF  =COEFT(IFL+1)
      GAMMA0=COEFT(IFL+2)
      N     =COEFT(IFL+5)
      
C initialisation des arguments en sortie      
      DGAMMA=0.D0
      DALPHA=0.D0      
      DP=0.D0      
      IRET=0
C     on resout en alpha=rho*b**2      
C     ECOULEMENT CALCUL DE DGAMMA,DP     
      IF (ABS(TAUS).GT.RMIN) THEN
         SGNS=TAUS/ABS(TAUS)
         TERME=ABS(TAUS)/(TAUF+RP)
C        ECOULEMENT AVEC SEUIL
         IF  (TERME.GE.1.D0) THEN
            IF (N*LOG(TERME).LT.RMAX) THEN
               DP=GAMMA0*DT*( ABS(TAUS)/(TAUF+RP) )**N
               DP=DP-GAMMA0*DT
               DGAMMA=DP*SGNS
            ELSE
               IRET=1
               GOTO 9999
            ENDIF
         ELSE
            GOTO 9999
         ENDIF
      ENDIF
      
C CALCUL DE RHO_POINT=DALPHA

      DO 55 IR=1,NBSYS
         ALPHAM(IR)=VIND(3*(IR-1)+1)
         ALPHAR(IR)=ALPHAM(IR)+DY(IR)
 55   CONTINUE

      CALL LCMMDH(COEFT,IFA,NMAT,NBCOMM,ALPHAR,HSR,NBSYS,IS,
     &            HS,SOMS1,SOMS2,SOMS3)
      
      DALPHA=HS*DP
 9999 CONTINUE
      END

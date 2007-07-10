      SUBROUTINE SATUVG(VG,PC,SAT,DSDPC)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/07/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C SATUVG : CALCUL DE LA SATURATION PAR VAN-GENUCHTEN + REGULARISATION
C DROITE ET GAUCHE
      IMPLICIT NONE
C
C IN
      REAL*8 VG(5),PC
C OUT      
      REAL*8 SAT,DSDPC
C       
      REAL*8 SATUMA
      REAL*8 N,M,PR,SMAX,SR,S1MAX,DELTA,PCMAX,DPCMAX,DPCMIN
      REAL*8 USN,USM,X0,Y0,Y0P,Y1,A1,B1,C1,SMIN,S1MIN,AR,BR,PCMIN
      REAL*8 BIDON

      N    = VG(1)
      PR   = VG(2)
      SR   = VG(3)
      SMAX = VG(4)
      SATUMA = VG(5)
      M=1.D0-1.D0/N
      USN=1.D0/N
      USM=1.D0/M
C      
      S1MAX=(SMAX-SR)/(1.D0-SR)
C      
C FONCTION PROLONGATION A GAUCHE DE S(PC) (S > SMAX)
      CALL PCAPVG(SR,PR,USM,USN,S1MAX,PCMAX,DPCMAX,BIDON)
      CALL REGUH1(PCMAX,SMAX,1.D0/DPCMAX,B1,C1)
C
      S1MIN=1.D0-SMAX
      SMIN=SR+(1.D0-SR)*S1MIN
      X0=SMIN
C FONCTION PROLONGATION A DROITE DE S(PC) (S < SMIN)
      CALL PCAPVG(SR,PR,USM,USN,S1MIN,PCMIN,DPCMIN,BIDON)
      CALL REGUP1(X0,PCMIN,DPCMIN,AR,BR)
C
C CALCUL DE S(PC) :
C      
      IF ( (PC.GT.PCMAX).AND.(PC.LT.PCMIN)) THEN
C      
       CALL SATFVG(SR,PR,N,M,PC,SAT,DSDPC)
C       
      ELSE IF(PC.LE.PCMAX) THEN
C      
        SAT=1.D0-B1/(C1-PC)
        DSDPC=-B1/((C1-PC)**2.D0)
C        
      ELSE IF(PC.GE.PCMIN) THEN
C      
       SAT=(PC-BR)/AR
       DSDPC=1.D0/AR
C      
      ENDIF 
      SAT=SAT*SATUMA

      
      END

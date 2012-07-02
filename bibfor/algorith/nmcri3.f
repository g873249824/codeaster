      FUNCTION NMCRI3(DEPSV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
      IMPLICIT NONE
C
C     ARGUMENTS:
C     ----------
      REAL*8 NMCRI3,DEPSV
C ----------------------------------------------------------------------
C    BUT:  EVALUER LA FONCTION DONT ON CHERCHE LE ZERO
C          POUR LA LOI DE FLUAGE DU LMAB
C
C     IN:  DEPSV  : ACCROISSEMENT DE DEFORMATION VISQUEUSE
C    OUT:  NMCRI3 : VALEUR DU CRITERE  DE CONVERGENCE DE L'EQUATION NON
C                   LINEAIRE A RESOUDRE
C                   (DONT ON CHERCHE LE ZERO)
C
C ----------------------------------------------------------------------
      REAL*8 COELMA(12),EPSV,DEPST,SIG,X,X1,X2,DX,DX1,DX2,DELTAT
      REAL*8 XM,XN,DEPSI0,P,P1,P2,XM0,RM0,Y0,X0,YSAT,B
      REAL*8 Y,F1,F2,YY,E,SIGSIG,DEPTHE,DEPGRD,IER
C
C----- COMMONS NECESSAIRES A LMAB UNIAXIALE
C      COMMONS COMMUNS A NMCRI3 ET NMLMAB

      COMMON/RCONM3/COELMA,EPSV,DEPST,SIG,X,X1,X2,DX,DX1,DX2,DELTAT,E,
     &              SIGSIG,DEPTHE,DEPGRD,IER
C
C ----------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      REAL*8 ARGSH ,GRAND ,PREC ,R8GAEM ,R8PREM 
C-----------------------------------------------------------------------
      PREC = R8PREM()
      GRAND = R8GAEM()
      XM    = COELMA(1)
      XN    = (1.D0/COELMA(2))
      DEPSI0= COELMA(3)
      P     = COELMA(4)
      P1    = COELMA(5)
      P2    = COELMA(6)
      XM0   = COELMA(7)
      RM0   = COELMA(8)
C      XM1   = COELMA(9)
C      RM1   = COELMA(10)
      X0    = COELMA(9)
      Y0    = COELMA(10)
      YSAT  = COELMA(11)
      B     = COELMA(12)
C
      YY   = YSAT + (Y0-YSAT)*EXP(-B*(EPSV+DEPSV))
      DX2  = P2*( SIGSIG*YY - X2)*DEPSV/(1.D0 + P2*DEPSV)
      DX1  = P1*( SIGSIG*YY - ( X1 - X2 - DX2))*DEPSV/(1.D0 + P1*DEPSV)
C
      Y    = (DEPSV/(DEPSI0*DELTAT))**XN
C
      F1   = SIG + E*(DEPST-SIGSIG*DEPSV-DEPTHE-DEPGRD) -
     &       XM*SIGSIG*LOG(Y+SQRT(1.D0+Y**2)) - X
C      F2   = P*( SIGSIG*YY - ( X + F1 - ( X1 + DX1)))*DEPSV
C     &     - DELTAT * RM0*((X+F1)/ABS(X+F1))*(ABS(X+F1)/X0)**XM0
C     &     - DELTAT * RM1*((X+F1)/ABS(X+F1))*(ABS(X+F1)/X0)**XM1
      ARGSH = (ABS(X+F1)/X0)**XM0

      IF (ARGSH.GT.(0.9D0 * LOG(GRAND))) THEN
         IER=1.0D0
      ELSE
         IER=0.D0
         IF (ABS(X+F1).LT.PREC) THEN
            F2 = P*( SIGSIG*YY - ( X + F1 - ( X1 + DX1)))*DEPSV
         ELSE
            F2 = P*( SIGSIG*YY - ( X + F1 - ( X1 + DX1)))*DEPSV
     &     - DELTAT * RM0*((X+F1)/ABS(X+F1))*SINH((ABS(X+F1)/X0)**XM0)
         ENDIF
C
         DX   = F1
C
         NMCRI3    = SIGSIG*(F2 - F1)
      ENDIF
C
      END

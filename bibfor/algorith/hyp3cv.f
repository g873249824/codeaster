      SUBROUTINE HYP3CV(C11,C22,C33,C12,C13,C23,
     &                  K,
     &                  SV)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/02/2006   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 2005 UCBL LYON1 - T. BARANGER     WWW.CODE-ASTER.ORG
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
           
      REAL*8 C11
      REAL*8 C22
      REAL*8 C33
      REAL*8 C12
      REAL*8 C13
      REAL*8 C23
      REAL*8 K      
      REAL*8 SV(6)
C-----------------------------------------------------------------------
C
C     LOI DE COMPORTEMENT HYPERELASTIQUE - 3D
C     CALCUL DES CONTRAINTES - PARTIE VOLUMIQUE
C
C IN  C11,C22,C33,C12,C13,C23: ELONGATIONS
C IN  K     : MODULE DE COMPRESSIBILITE
C OUT SV    : CONTRAINTES VOLUMIQUES
C-----------------------------------------------------------------------
C
      REAL*8 GRD(6)
      REAL*8 T1,T3,T5,T7,TEMP
      REAL*8 T10,T13,T15,T16
C
C-----------------------------------------------------------------------
C
      T1   = C11*C22
      T3   = C23**2
      T5   = C12**2
      T7   = C12*C13
      T10  = C13**2
      TEMP =  T1*C33-C11*T3-T5*C33+2.D0*T7*C23-T10*C22
      
      IF ((TEMP.LE.0.D0)) THEN
        CALL UTMESS('F','HYP3CV',
     &  'ZERO ELONGATION FOR HYPERELASTIC MATERIAL')
      ENDIF 
           
      T13  = SQRT(TEMP)
      T15  = K*(T13-1.D0)
      T16  = 1.D0/T13
            
      GRD(1) = T15*T16*(C22*C33-T3)/2.D0
      GRD(2) = T15*T16*(C11*C33-T10)/2.D0
      GRD(3) = T15*T16*(T1-T5)/2.D0
      GRD(4) = T15*T16*(-2.D0*C12*C33+2.D0*C13*C23)/2.D0
      GRD(5) = T15*T16*(2.D0*C12*C23-2.D0*C13*C22)/2.D0
      GRD(6) = T15*T16*(-2.D0*C11*C23+2.D0*T7)/2.D0
      
      SV(1) = 2.D0*GRD(1)
      SV(2) = 2.D0*GRD(2)
      SV(3) = 2.D0*GRD(3)
      SV(4) = 2.D0*GRD(4)
      SV(5) = 2.D0*GRD(5)
      SV(6) = 2.D0*GRD(6)
 
      END

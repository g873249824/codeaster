        SUBROUTINE HUJDRC (K,MATER,SIG,VIN,PST)
        IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 17/02/2009   AUTEUR FOUCAULT A.FOUCAULT 
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
C   -------------------------------------------------------------------
C   CALCUL DE PRODUIT SCALAIRE ENTRE LA NORME DES MECANISMES CYCLIQUES 
C   DEVIATOIRES ET DES VECTEURS DE RAYONS ISSUS VARIABLES D'HISTOIRE
C   ET LA POSITION ACTUELLE DANS LE PLAN DEVIATOIRE K.
C
C   IN  K      :  PLAN DE PROJECTION (K = 1 A 3)  
C       MATER  :  COEFFICIENTS MATERIAU A T+DT
C       VIN    :  VARIABLES INTERNES  A T
C       SIG    :  CONTRAINTE A T+DT
C
C   OUT PST    : PRODUIT SCALAIRE ENTRE LA NORME DE LA SURFACE ET DR
C       SEUIL  : SEUIL DE LA SURFACE DE CHARGE ANTERIEURE 
C   -------------------------------------------------------------------
        INTEGER NDT, NDI, I, K
        REAL*8  MATER(22,2), SIG(6), VIN(*)
        REAL*8  B, PCO, BETA, PC, EPSVPM, PTRAC
        REAL*8  UN, ZERO, R8MAEM
        REAL*8  P, Q, M, PHI, DEGR, SIGD(3), REFM(2)
        REAL*8  POSF(3), REF(2), NORM(2), PST, TOLE1
       
        PARAMETER     ( DEGR  = 0.0174532925199D0 )
       
        COMMON /TDIM/   NDT , NDI

        DATA      UN, ZERO, TOLE1  /1.D0, 0.D0, 1.D-6/

        B      = MATER(4,2)
        PCO    = MATER(7,2)
        BETA   = MATER(2,2)
        EPSVPM = VIN(23)
        PHI    = MATER(5,2)
        M      = SIN(DEGR*PHI)
        PTRAC  = MATER(21,2)
        
        PC     = PCO*EXP(-BETA*EPSVPM)
        
        CALL HUJPRJ(K,SIG,SIGD,P,Q)
        
        P = P -PTRAC
        
        DO 5 I = 1, 3
          IF(Q.GT.TOLE1)THEN
            POSF(I) = SIGD(I)/(M*P*(UN-B*LOG(P/PC)))
          ELSE
            POSF(I) = ZERO
          ENDIF
  5     CONTINUE        
        NORM(1) = VIN(4*K+7)
        NORM(2) = VIN(4*K+8)
        REF(1)  = VIN(4*K+5)
        REF(2)  = VIN(4*K+6)

        PST = 2.D0*NORM(1)*(POSF(1)-REF(1))+NORM(2)*(POSF(3)-REF(2))

        END

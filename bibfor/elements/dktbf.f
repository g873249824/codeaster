      SUBROUTINE DKTBF  ( INT , R , BF )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 11/03/98   AUTEUR CIBHHLV L.VIVAN 
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER  INT
      REAL*8   R(*)
      REAL*8   BF(3,9)
C        ORDRE DES COMPOSANTES POUR BF :
C        DEFORMATIONS : KXX, KYY, KXY   (REP. INTRINSEQUE DE L'ELEMENT)
C        DEPLACEMENTS : DZ, DRY, -DRX   (REP. INTRINSEQUE DE L'ELEMENT)
C     ------------------------------------------------------------------
C     MATRICE B(3,9) AU POINT QSI ETA POUR L'ELEMENT DKT (FLEXION)
C     ------------------------------------------------------------------
      REAL*8  VJ11 , VJ12 , VJ21 , VJ22
      REAL*8  QSI , ETA , LMQ , LME
      REAL*8  L4,L5,L6 , C4,C5,C6 , S4,S5,S6
      REAL*8  CU4,CU5,CU6 , SU4,SU5,SU6 , CS4,CS5,CS6
      REAL*8  CL4,CL5,CL6 , SL4,SL5,SL6
      REAL*8  BXQ(9) , BYQ(9) , BXE(9) , BYE(9)
C
C     ------------------ PARAMETRAGE TRIANGLE --------------------------
      INTEGER NPG , NC , NNO
      INTEGER LJACO,LTOR,LQSI,LETA,LWGT,LXYC,LCOTE,LCOS,LSIN
               PARAMETER (NPG   = 3)
               PARAMETER (NNO   = 3)
               PARAMETER (NC    = 3)
               PARAMETER (LJACO = 2)
               PARAMETER (LTOR  = LJACO + 4)
               PARAMETER (LQSI  = LTOR  + 1)
               PARAMETER (LETA  = LQSI  + NPG + NNO )
               PARAMETER (LWGT  = LETA  + NPG + NNO )
               PARAMETER (LXYC  = LWGT  + NPG)
               PARAMETER (LCOTE = LXYC  + 2*NC)
               PARAMETER (LCOS  = LCOTE + NC)
               PARAMETER (LSIN  = LCOS  + NC)
C     ------------------------------------------------------------------
      QSI = R(LQSI+INT-1)
      ETA = R(LETA+INT-1)
      VJ11 = R(LJACO)
      VJ12 = R(LJACO+1)
      VJ21 = R(LJACO+2)
      VJ22 = R(LJACO+3)
      C4   = R(LCOS)
      C5   = R(LCOS+1)
      C6   = R(LCOS+2)
      S4   = R(LSIN)
      S5   = R(LSIN+1)
      S6   = R(LSIN+2)
      L4   = R(LCOTE)
      L5   = R(LCOTE+1)
      L6   = R(LCOTE+2)
C
      CU4 = 3.D0 * C4 * C4
      CU5 = 3.D0 * C5 * C5
      CU6 = 3.D0 * C6 * C6
      SU4 = 3.D0 * S4 * S4
      SU5 = 3.D0 * S5 * S5
      SU6 = 3.D0 * S6 * S6
      CS4 = 3.D0 * C4 * S4
      CS5 = 3.D0 * C5 * S5
      CS6 = 3.D0 * C6 * S6
      CL4 = 6.D0 * C4 / L4
      CL5 = 6.D0 * C5 / L5
      CL6 = 6.D0 * C6 / L6
      SL4 = 6.D0 * S4 / L4
      SL5 = 6.D0 * S5 / L5
      SL6 = 6.D0 * S6 / L6
      LMQ = 1.D0 - 2.D0 * QSI - ETA
      LME = 1.D0 - QSI - 2.D0 * ETA
C
C     ------ DERIVEE DE BETAX(I) / QSI ------
      BXQ(1) =          LMQ * CL4 + ETA * CL6
      BXQ(2) = - 1.D0 - LMQ * CU4 + ETA * CU6
      BXQ(3) =        - LMQ * CS4 + ETA * CS6
      BXQ(4) =        - LMQ * CL4 + ETA * CL5
      BXQ(5) =   1.D0 - LMQ * CU4 - ETA * CU5
      BXQ(6) =        - LMQ * CS4 - ETA * CS5
      BXQ(7) =        - ETA * CL6 - ETA * CL5
      BXQ(8) =          ETA * CU6 - ETA * CU5
      BXQ(9) =          ETA * CS6 - ETA * CS5
C     ------ DERIVEE DE BETAY(I) / QSI ------
      BYQ(1) =          LMQ * SL4 + ETA * SL6
      BYQ(2) =  BXQ(3)
      BYQ(3) = - 1.D0 - LMQ * SU4 + ETA * SU6
      BYQ(4) =        - LMQ * SL4 + ETA * SL5
      BYQ(5) =  BXQ(6)
      BYQ(6) =   1.D0 - LMQ * SU4 - ETA * SU5
      BYQ(7) =        - ETA * SL6 - ETA * SL5
      BYQ(8) =  BXQ(9)
      BYQ(9) =          ETA * SU6 - ETA * SU5
C     ------ DERIVEE DE BETAX(I) / ETA ------
      BXE(1) =        - LME * CL6 - QSI * CL4
      BXE(2) = - 1.D0 - LME * CU6 + QSI * CU4
      BXE(3) =        - LME * CS6 + QSI * CS4
      BXE(4) =          QSI * CL4 + QSI * CL5
      BXE(5) =          QSI * CU4 - QSI * CU5
      BXE(6) =          QSI * CS4 - QSI * CS5
      BXE(7) =          LME * CL6 - QSI * CL5
      BXE(8) =   1.D0 - LME * CU6 - QSI * CU5
      BXE(9) =        - LME * CS6 - QSI * CS5
C     ------ DERIVEE DE BETAY(I) / ETA ------
      BYE(1) =        - LME * SL6 - QSI * SL4
      BYE(2) =  BXE(3)
      BYE(3) = - 1.D0 - LME * SU6 + QSI * SU4
      BYE(4) =          QSI * SL4 + QSI * SL5
      BYE(5) =  BXE(6)
      BYE(6) =          QSI * SU4 - QSI * SU5
      BYE(7) =          LME * SL6 - QSI * SL5
      BYE(8) =  BXE(9)
      BYE(9) =   1.D0 - LME * SU6 - QSI * SU5
C
C     --------------------- CALCUL DE B -------------------------------
      DO 100 I = 1, 9
        BF(1,I) = VJ11*BXQ(I) + VJ12*BXE(I)
        BF(2,I) = VJ21*BYQ(I) + VJ22*BYE(I)
        BF(3,I) = VJ11*BYQ(I) + VJ12*BYE(I) + VJ21*BXQ(I) + VJ22*BXE(I)
  100 CONTINUE
      END

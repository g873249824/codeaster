      SUBROUTINE DSXHFT ( DF , R , HFT2 )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 07/01/98   AUTEUR CIBHHLB L.BOURHRARA 
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
      REAL*8   DF(3,3)
      REAL*8   R(*)
      REAL*8   HFT2(2,6)
C     -----------------------------------------------------------------
C     MATRICE PRODUIT HF.T2(2,6)
C     -----------------------------------------------------------------
C
      REAL*8  VJ11 , VJ12 , VJ21 , VJ22
      REAL*8  HF(2,6)
      REAL*8  T2(3,3)
C
C     ------------------ PARAMETRAGE -----------------------------------
      INTEGER    LJACO
                 PARAMETER (LJACO = 2)
C     ---------------------------------------------------------------
      VJ11 = R(LJACO)
      VJ12 = R(LJACO+1)
      VJ21 = R(LJACO+2)
      VJ22 = R(LJACO+3)
C
      HF(1,1) =        DF(1,1)
      HF(1,2) =        DF(3,3)
      HF(1,3) = 2.D0 * DF(1,3)
      HF(1,4) =        DF(1,3)
      HF(1,5) =        DF(2,3)
      HF(1,6) = DF(1,2) + DF(3,3)
      HF(2,1) =        DF(1,3)
      HF(2,2) =        DF(2,3)
      HF(2,3) = DF(1,2) + DF(3,3)
      HF(2,4) =        DF(3,3)
      HF(2,5) =        DF(2,2)
      HF(2,6) = 2.D0 * DF(2,3)
C
      T2(1,1) =        VJ11 * VJ11
      T2(1,2) =        VJ12 * VJ12
      T2(1,3) = 2.D0 * VJ11 * VJ12
      T2(2,1) =        VJ21 * VJ21
      T2(2,2) =        VJ22 * VJ22
      T2(2,3) = 2.D0 * VJ21 * VJ22
      T2(3,1) =        VJ11 * VJ21
      T2(3,2) =        VJ12 * VJ22
      T2(3,3) = VJ11 * VJ22 + VJ12 * VJ21
C
      DO 100 K = 1 , 12
         HFT2(K,1) = 0.D0
 100  CONTINUE
      DO 110 J = 1, 3
            DO 110 K = 1, 3
               HFT2(1,J)   = HFT2(1,J)   + HF(1,K)   * T2(K,J)
               HFT2(1,J+3) = HFT2(1,J+3) + HF(1,K+3) * T2(K,J)
               HFT2(2,J)   = HFT2(2,J)   + HF(2,K)   * T2(K,J)
               HFT2(2,J+3) = HFT2(2,J+3) + HF(2,K+3) * T2(K,J)
 110  CONTINUE
      END

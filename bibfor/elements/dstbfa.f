      SUBROUTINE DSTBFA ( QSI, ETA , R , BFA )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 03/04/2000   AUTEUR CIBHHGB G.BERTRAND 
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
      REAL*8   QSI, ETA
      REAL*8   R(*)
      REAL*8   BFA(3,3)
C     ----------------------------------------------------
C     MATRICE BFA(3,3) AU POINT QSI ETA POUR L'ELEMENT DST
C     ----------------------------------------------------
C
      REAL*8  VJ11 , VJ12 , VJ21 , VJ22
      REAL*8  LMQ , LME
      REAL*8  C4,C5,C6 , S4,S5,S6
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
      LMQ = 1.D0 - 2.D0 * QSI - ETA
      LME = 1.D0 - QSI - 2.D0 * ETA
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
C
      BFA(1,1) = 4.D0*( VJ11*LMQ - VJ12*QSI)*C4
      BFA(1,2) = 4.D0*( VJ11*ETA + VJ12*QSI)*C5
      BFA(1,3) = 4.D0*(-VJ11*ETA + VJ12*LME)*C6
      BFA(2,1) = 4.D0*( VJ21*LMQ - VJ22*QSI)*S4
      BFA(2,2) = 4.D0*( VJ21*ETA + VJ22*QSI)*S5
      BFA(2,3) = 4.D0*(-VJ21*ETA + VJ22*LME)*S6
      BFA(3,1) = 4.D0*(LMQ*(VJ21*C4 + VJ11*S4)-QSI*(VJ22*C4 + VJ12*S4))
      BFA(3,2) = 4.D0*(ETA*(VJ21*C5 + VJ11*S5)+QSI*(VJ22*C5 + VJ12*S5))
      BFA(3,3) =-4.D0*(ETA*(VJ21*C6 + VJ11*S6)-LME*(VJ22*C6 + VJ12*S6))
      END

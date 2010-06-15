      SUBROUTINE GDCLCO(E,TAU)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/02/2007   AUTEUR MICHEL S.MICHEL 
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

      IMPLICIT NONE
      REAL*8 E(6),TAU(6)
C ----------------------------------------------------------------------
C       INTEGRATION DES LOIS EN GRANDES DEFORMATIONS CANO-LORENTZ
C   CALCUL DES CONTRAINTES A PARTIR DE LA DEFORMATION THERMO-ELASTIQUE
C ----------------------------------------------------------------------
C IN  E       DEFORMATION ELASTIQUE  
C OUT TAU     CONTRAINTE DE KIRCHHOFF
C ----------------------------------------------------------------------
C  COMMON GRANDES DEFORMATIONS CANO-LORENTZ

      INTEGER IND1(6),IND2(6)
      REAL*8  KR(6),RAC2,RC(6)
      REAL*8  LAMBDA,MU,DEUXMU,UNK,TROISK,COTHER
      REAL*8  JM,DJ,JP,DJDF(3,3)
      REAL*8  ETR(6),DVETR(6),EQETR,TRETR,DETRDF(6,3,3)
      REAL*8  DTAUDE(6,6)

      COMMON /GDCLC/
     &          IND1,IND2,KR,RAC2,RC,
     &          LAMBDA,MU,DEUXMU,UNK,TROISK,COTHER,
     &          JM,DJ,JP,DJDF,
     &          ETR,DVETR,EQETR,TRETR,DETRDF,
     &          DTAUDE
C ----------------------------------------------------------------------
C ----------------------------------------------------------------------

      INTEGER IJ
      REAL*8  E2(6),TRE
C ----------------------------------------------------------------------



C    CALCUL DE E.E
      E2(1) = E(1)*E(1)      + E(4)*E(4)/2.D0 + E(5)*E(5)/2.D0
      E2(2) = E(4)*E(4)/2.D0 + E(2)*E(2)      + E(6)*E(6)/2.D0
      E2(3) = E(5)*E(5)/2.D0 + E(6)*E(6)/2.D0 + E(3)*E(3)
      E2(4) = E(1)*E(4)      + E(4)*E(2)      + E(5)*E(6)/RAC2
      E2(5) = E(1)*E(5)      + E(4)*E(6)/RAC2 + E(5)*E(3)
      E2(6) = E(4)*E(5)/RAC2 + E(2)*E(6)      + E(6)*E(3)

C    CALCUL DE TAU
      TRE   = E(1)+E(2)+E(3)
      DO 10 IJ = 1,6
        TAU(IJ) = (LAMBDA*TRE+COTHER)*(2*E(IJ)  - KR(IJ))
     &            + DEUXMU             *(2*E2(IJ) - E(IJ))
 10   CONTINUE

      END

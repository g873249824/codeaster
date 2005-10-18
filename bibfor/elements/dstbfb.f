      SUBROUTINE DSTBFB ( JACOB , BFB )
      IMPLICIT  NONE
      REAL*8    JACOB(*), BFB(3,9)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/10/2005   AUTEUR CIBHHLV L.VIVAN 
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
C     ------------------------------------------------------------------
C     MATRICE BFB(3,9) POUR L'ELEMENT DST
C     ------------------------------------------------------------------
      INTEGER  K
      REAL*8  VJ11 , VJ12 , VJ21 , VJ22
C     ------------------------------------------------------------------
      VJ11 = JACOB(1)
      VJ12 = JACOB(2)
      VJ21 = JACOB(3)
      VJ22 = JACOB(4)
C
      DO 100 K = 1 , 27
         BFB(K,1) = 0.D0
 100  CONTINUE
      BFB(1,2) = - VJ11 - VJ12
      BFB(1,5) =   VJ11
      BFB(1,8) =   VJ12
      BFB(2,3) = - VJ21 - VJ22
      BFB(2,6) =   VJ21
      BFB(2,9) =   VJ22
      BFB(3,2) = - VJ21 - VJ22
      BFB(3,3) = - VJ11 - VJ12
      BFB(3,5) =   VJ21
      BFB(3,6) =   VJ11
      BFB(3,8) =   VJ22
      BFB(3,9) =   VJ12
C
      END

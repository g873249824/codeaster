        SUBROUTINE LCPRSC ( X , Y , P )
      IMPLICIT NONE
C       ----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C       ----------------------------------------------------------------
C       PRODUIT SCALAIRE DE 2 VECTEURS P = <X Y>
C       UTILISABLE COMME PRODUIT TENSORIEL CONTRACTE 2 FOIS A CONDITION
C       QUE LES TENSEURS SOIT REPRESENTES SOUS FORME DE VECTEURS V :
C       V = ( V1 V2 V3 SQRT(2)*V12 SQRT(2)*V13 SQRT(2)*V23 )
C       IN  X      :  VECTEUR
C       IN  Y      :  VECTEUR
C       OUT P      :  SCALAIRE RESULTAT
C       ----------------------------------------------------------------
        INTEGER         N , ND
        REAL*8  X(6),   Y(6),   P
        COMMON /TDIM/   N , ND
C-----------------------------------------------------------------------
      INTEGER I 
C-----------------------------------------------------------------------
        P = 0.D0
        DO 1 I = 1 , N
        P = P + X(I)*Y(I)
 1      CONTINUE
        END

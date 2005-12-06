      SUBROUTINE PROVE3(A,B,C,N)
C ----------------------------------------------------------------------
C             PRODUIT VECTORIEL DE AB ET AC EN DIMENSION 3
C ----------------------------------------------------------------------
C VARIABLES EN ENTREE
C REAL*8     A(3) : POINT A
C REAL*8     B(3) : POINT B
C REAL*8     C(3) : POINT C
C
C VARIABLE EN SORTIE
C REAL*8     N(3) : AB PRODUIT VECTORIEL AC
C ----------------------------------------------------------------------
      
      IMPLICIT NONE

C --- VARIABLES
      REAL*8  A(3),B(3),C(3),N(3)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 08/11/2004   AUTEUR DURAND C.DURAND 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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

      N(1) = (B(2)-A(2))*(C(3)-A(3))-(B(3)-A(3))*(C(2)-A(2))
      N(2) = (B(3)-A(3))*(C(1)-A(1))-(B(1)-A(1))*(C(3)-A(3))
      N(3) = (B(1)-A(1))*(C(2)-A(2))-(B(2)-A(2))*(C(1)-A(1))
      
      END

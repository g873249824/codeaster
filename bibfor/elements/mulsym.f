      SUBROUTINE MULSYM(U22,A3,V22,R3)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 01/12/2003   AUTEUR KOECHLIN P.KOECHLIN 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
      IMPLICIT NONE
C
      REAL*8      U22(2,2),    A3(3),    V22(2,2)
      REAL*8      X22(2,2),   A22(2,2),    R3(3)
C
C CALCUL DU PRODUIT U22.A3.V22 A ETANT DONNEE SOUS FORME DE VECTEUR
C
C           A3(1) = A_XX
C           A3(2) = A_YY
C           A3(3) = A_XY
C
C CONSTRUCTION DE LA MATRICE SYMETRIQUE DE A
C
      A22(1,1) = A3(1)
      A22(2,2) = A3(2)
      A22(1,2) = A3(3)
      A22(2,1) = A3(3)
C
      CALL PMAT(2,A22,V22,X22)
      CALL PMAT(2,U22,X22,A22)
C
      R3(1) = A22(1,1) 
      R3(2) = A22(2,2)
      R3(3) = A22(1,2)
C
      END 

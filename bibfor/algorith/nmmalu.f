      SUBROUTINE NMMALU(NNO,AXI,R,VFF,DFDI,LIJ)

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

      LOGICAL GRAND, AXI
      INTEGER NNO,LIJ(3,3)
      REAL*8  DFDI(NNO,4),VFF(NNO),R

C ----------------------------------------------------------------------
C                     CALCUL DE LA MATRICE L :  GRAD(U) = L.U
C
C IN  NNO     : NOMBRE DE NOEUDS
C IN  AXI     : .TRUE. SI AXISYMETRIQUE
C IN  R       : RAYON AU POINT DE GAUSS CONSIDERE (UTILE EN AXI)
C IN  VFF     : FONCTIONS DE FORME AU POINT DE GAUSS CONSIDERE
C VAR DFDI    : IN  : DERIVEE DES FONCTIONS DE FORME 
C               OUT : MATRICE L (AVEC LIJ)
C                --> DDL (N,I) ET VAR J  -> DFDI(N,LIJ(I,J))
C OUT LIJ     : INDIRECTION POUR ACCEDER A L
C ----------------------------------------------------------------------


C    CAS 2D OU 3D STANDARD
      IF (.NOT. AXI) THEN
        LIJ(1,1) = 1
        LIJ(1,2) = 2
        LIJ(1,3) = 3
        LIJ(2,1) = 1
        LIJ(2,2) = 2
        LIJ(2,3) = 3
        LIJ(3,1) = 1
        LIJ(3,2) = 2
        LIJ(3,3) = 3
        GOTO 9999
      END IF
      
C CAS AXISYMETRIQUE
      LIJ(1,1) = 1
      LIJ(1,2) = 2
      LIJ(1,3) = 4
      LIJ(2,1) = 1
      LIJ(2,2) = 2
      LIJ(2,3) = 4
      LIJ(3,1) = 4
      LIJ(3,2) = 4
      LIJ(3,3) = 3

C    TERME EN N/R : DERIVATION 3,3
      CALL DCOPY(NNO,VFF,1,DFDI(1,3),1)
      CALL DSCAL(NNO,1/R,DFDI(1,3),1)
      
C    TERME NUL : DERIVATION 1,3  2,3  3,1  3,2
      CALL R8INIR(NNO,0.D0,DFDI(1,4),1)

 9999 CONTINUE
      END

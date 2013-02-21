      SUBROUTINE NMEPSI(NDIM,NNO,AXI,GRAND,VFF,R,DFDI,DEPL,F,EPS)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/02/2013   AUTEUR SFAYOLLE S.FAYOLLE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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

      LOGICAL AXI,GRAND
      INTEGER NDIM,NNO
      REAL*8  VFF(NNO),R,DFDI(NNO,NDIM),DEPL(NDIM,NNO),F(3,3),EPS(6)
C ----------------------------------------------------------------------
C                     CALCUL DES DEFORMATIONS
C
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  NNO     : NOMBRE DE NOEUDS
C IN  AXI     : .TRUE. SI AXISYMETRIQUE
C IN  GRAND   : .TRUE.  --> CALCUL DE F(3,3)
C               .FALSE. --> CALCUL DE EPS(6)
C IN  VFF     : VALEURS DES FONCTIONS DE FORME (POINT DE GAUSS COURANT)
C IN  R       : RAYON DU POINT COURANT (EN AXI)
C IN  DFDI    : DERIVEE DES FONCTIONS DE FORME (POINT DE GAUSS COURANT)
C IN  DEPL    : DEPLACEMENTS NODAUX
C OUT F       : GRADIENT DE LA TRANSFORMATION F(3,3) : SI GRAND=.TRUE.
C OUT EPS     : DEFORMATIONS LINEARISEES EPS(6)      : SI GRAND=.FALSE.
C ----------------------------------------------------------------------

      INTEGER I,J
      REAL*8  GRAD(3,3),UR,R2,KRON(3,3),DDOT
      DATA KRON/1.D0,0.D0,0.D0, 0.D0,1.D0,0.D0, 0.D0,0.D0,1.D0/
C ----------------------------------------------------------------------

C - INITIALISATION

      R2 = SQRT(2.D0)/2.D0
      CALL R8INIR(9,0.D0,GRAD,1)


C - CALCUL DES GRADIENT : GRAD(U)

      DO 10 I = 1,NDIM
        DO 20 J = 1,NDIM
          GRAD(I,J) = DDOT(NNO,DFDI(1,J),1,DEPL(I,1),NDIM)
 20     CONTINUE
 10   CONTINUE


C - CALCUL DU DEPLACEMENT RADIAL
      IF (AXI) UR=DDOT(NNO,VFF,1,DEPL,NDIM)


C - CALCUL DU GRADIENT DE LA TRANSFORMATION F

      CALL DCOPY(9,KRON,1,F,1)
      IF (GRAND) THEN
        CALL DAXPY(9,1.D0,GRAD,1,F,1)
        IF (AXI) F(3,3) = F(3,3) + UR/R
      END IF


C - CALCUL DES DEFORMATIONS LINEARISEES EPS

      IF (.NOT. GRAND) THEN
        EPS(1) = GRAD(1,1)
        EPS(2) = GRAD(2,2)
        EPS(3) = 0.D0
        EPS(4) = R2*(GRAD(1,2)+GRAD(2,1))

        IF (AXI) EPS(3) = UR/R

        IF (NDIM.EQ.3) THEN
          EPS(3) = GRAD(3,3)
          EPS(5) = R2*(GRAD(1,3)+GRAD(3,1))
          EPS(6) = R2*(GRAD(2,3)+GRAD(3,2))
        END IF
      END IF

      END

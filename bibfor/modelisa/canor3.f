      SUBROUTINE CANOR3(COOR,A,B,C)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
      REAL*8 COOR(3,*),A,B,C,X1,X2,X3,Y1,Y2,Y3,Z1,Z2,Z3,X12,Y12,Z12
      REAL*8 X13,Y13,Z13,NORME
      REAL*8 VALR(10)
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      X1=COOR(1,1)
      X2=COOR(1,2)
      X3=COOR(1,3)
      Y1=COOR(2,1)
      Y2=COOR(2,2)
      Y3=COOR(2,3)
      Z1=COOR(3,1)
      Z2=COOR(3,2)
      Z3=COOR(3,3)
      X12=X2-X1
      Y12=Y2-Y1
      Z12=Z2-Z1
      X13=X3-X1
      Y13=Y3-Y1
      Z13=Z3-Z1
      A=Y12*Z13-Y13*Z12
      B=X13*Z12-X12*Z13
      C=X12*Y13-X13*Y12
      NORME  =SQRT(A*A+B*B+C*C)
      IF (NORME.GT.0) THEN
         A=A/NORME
         B=B/NORME
         C=C/NORME
      ELSE
         VALR (1) = X1
         VALR (2) = Y1
         VALR (3) = Z1
         VALR (4) = X2
         VALR (5) = Y2
         VALR (6) = Z2
         VALR (7) = X3
         VALR (8) = Y3
         VALR (9) = Z3
         VALR (10) = NORME
         CALL U2MESG('F', 'MODELISA8_53',0,' ',0,0,10,VALR)
      END IF
      END

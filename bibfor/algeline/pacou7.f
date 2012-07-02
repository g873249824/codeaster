      SUBROUTINE PACOU7 ( A, N, D, B )
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C
C ARGUMENTS
C ---------
      INCLUDE 'jeveux.h'
      INTEGER N
      REAL*8 A(N,*), B(*), D(*)
C ---------------------------------------------------------------------
C
C-----------------------------------------------------------------------
      INTEGER I ,J 
      REAL*8 SUM 
C-----------------------------------------------------------------------
      B(N) = B(N) / D(N)
C
      DO 12 I = N-1, 1, -1
C
         SUM = 0.0D0
         DO 11 J = I+1, N
            SUM = SUM + A(I,J)*B(J)
   11    CONTINUE
C
         B(I) = (B(I)-SUM) / D(I)
C
   12 CONTINUE
C
      END

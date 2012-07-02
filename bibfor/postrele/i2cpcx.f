      SUBROUTINE I2CPCX(EPSI,T1,T2,C1,C2,NT,NC)
      IMPLICIT NONE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF POSTRELE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      INTEGER NC,NT,C1(*),C2(*)
      REAL*8  EPSI,T1(*),T2(*)
C
      INTEGER A,D,I
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      A  = 0
      D  = 1
      I  = 1
      NC = 0
C
      DO 10, I = 1, NT-1, 1
C
         IF ( ABS(T1(I+1) - T2(I)) .GE. EPSI ) THEN
C
            NC     = NC + 1
            A      = I
            C1(NC) = D
            C2(NC) = A
            D      = A + 1
C
         ENDIF
C
10    CONTINUE
C
      NC     = NC + 1
      C1(NC) = D
      C2(NC) = NT
C
      END

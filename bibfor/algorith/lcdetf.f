      SUBROUTINE LCDETF(NDIM,FR,DET)
      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/06/2011   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      REAL*8 FR(3,3),DET
      INTEGER NDIM
C     ----------------------------------------------------------------

C     DETERMINANT DE LA MATRICE FR 
      IF (NDIM.EQ.3) THEN
         DET =  FR(1,1)*(FR(2,2)*FR(3,3)-FR(2,3)*FR(3,2))
     &        - FR(2,1)*(FR(1,2)*FR(3,3)-FR(1,3)*FR(3,2))
     &        + FR(3,1)*(FR(1,2)*FR(2,3)-FR(1,3)*FR(2,2))
      ELSEIF (NDIM.EQ.2) THEN
         DET =  FR(3,3)*(FR(1,1)*FR(2,2)-FR(1,2)*FR(2,1))
      ELSE
         CALL ASSERT(.FALSE.)
      ENDIF
      
      END

      SUBROUTINE ORISH8(COOR,PS)
      IMPLICIT   NONE
      INTEGER NBNO,NBNOFA,J,I
      REAL*8 COOR(24),PS
      REAL*8 VEC1(3),VEC2(3),VEC3(3),VECT(3)

C.======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/09/2003   AUTEUR JMBHH01 J.M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2003  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ORISH1  --  VERIFIE SI LA NORMALE A LA PREMIER FACE : 12 VECT 13
C                 EST RENTRANTE POUR UNE MAILLE HEXA8
C   ARGUMENT       E/S  TYPE         ROLE
C    COOR         IN    R         COORDONNEES DES 8 NOEUDS
C    PS           OUT   R         PRODUIT SCALAIRE : SI >0, NORMALE 
C                                 RENTRANTE.
C
C.======================================================================

C VECTEURS 12 14 et 15
      DO 100 J = 1,3
        VEC1(J) = COOR(3+J) - COOR(J)
        VEC2(J) = COOR(9+J) - COOR(J)
        VECT(J) = COOR(12+J) - COOR(J)
  100 CONTINUE
C CALCUL DU PRODUIT VECTORIEL 12 X 14
      CALL PROVEC(VEC1,VEC2,VEC3)

C  VEC3= PRODUIT VECTORIEL 12 X 14 EST IL DANS LA DIRECTION DE 15
      CALL PSCAL(3,VEC3,VECT,PS)

      END

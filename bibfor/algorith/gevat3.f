      REAL*8 FUNCTION GEVAT3 ( A, WMOY, DELTA )
      IMPLICIT NONE
      REAL*8   A, WMOY, DELTA
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/07/2002   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C  GENERATEUR DE VARIABLE ALEATOIRE DU MODELE PROBABILISTE 
C  PARAMETRIQUE EN UTILISANT UNE INFORMATION SUR L'INVERSE (TYPE 3).
C
C  LA PROCEDURE EST DUE AU PROFESSEUR CHRISTIAN SOIZE (2001).
C
C  A     : BORNE INFERIEURE DU SUPPORT DE LA LOI DE PROBABILITE DE 
C          LA VARIABLE ALEATOIRE W.
C  WMOY  : VALEUR MOYENNE DE LA VARIABLE ALEATOIRE W.
C  DELTA : INDICE DE VARIATION  DE LA VARIABLE ALEATOIRE W.
C ----------------------------------------------------------------------
      REAL*8   ALPHA, X, GAMDEV, V 
C
      IF (WMOY.LE.A) THEN
         CALL UTDEBM('F','GEVAT3',' WMOY < A ')
         CALL UTIMPR('L','   WMOY = ', 1, WMOY )
         CALL UTIMPR('L','   A    = ', 1, A )
         CALL UTFINM
      ENDIF
C
      IF (DELTA.LE.0) THEN
         CALL UTDEBM('F','GEVAT3',' DELTA EST NEGATIF OU NUL ')
         CALL UTIMPR('L','   DELTA = = ', 1, DELTA )
         CALL UTFINM
      ENDIF
C
      V = WMOY-A
      ALPHA = 1/DELTA**2
      X = GAMDEV(ALPHA)
      GEVAT3 = A + V*(DELTA**2)*X
C
      END

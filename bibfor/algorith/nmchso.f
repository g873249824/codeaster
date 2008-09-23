      SUBROUTINE NMCHSO(CHAPIN,TYCHAP,TYPSOL,NOMVAR,CHAPOU)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*19 CHAPIN(*),CHAPOU(*)
      CHARACTER*6  TYCHAP,TYPSOL
      CHARACTER*19 NOMVAR      
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
C
C CHANGE LE NOM D'UNE VARIABLE DANS UN VECTEUR CHAPEAU
C
C ----------------------------------------------------------------------
C
C
C IN  CHAPIN : VARIABLE CHAPEAU ENTRANTE
C IN  TYCHAP : TYPE DE VARIABLE CHAPEAU
C                MEELEM - NOMS DES MATR_ELEM
C                MEASSE - NOMS DES MATR_ASSE
C                VEELEM - NOMS DES VECT_ELEM
C                VEASSE - NOMS DES VECT_ASSE
C                SOLALG - NOMS DES CHAM_NO SOLUTION
C IN  TYPSOL : TYPE DE VARIABLE A REMPLACER
C IN  NOMVAR : NOM DE LA VARIABLE
C OUT CHAPOU : VARIABLE CHAPEAU SORTANTE
C      
C ----------------------------------------------------------------------
C
      INTEGER      INDEX,I,NMCHAI,NMAX
C      
C ----------------------------------------------------------------------
C
      INDEX = NMCHAI(TYCHAP,TYPSOL)
      
      
      IF (TYCHAP.EQ.'MEELEM') THEN
        NMAX = 20
      ELSEIF (TYCHAP.EQ.'VEELEM') THEN
        NMAX = 30  
      ELSEIF (TYCHAP.EQ.'MEASSE') THEN
        NMAX = 8    
      ELSEIF (TYCHAP.EQ.'VEASSE') THEN
        NMAX = 40          
      ELSEIF (TYCHAP.EQ.'SOLALG') THEN
        NMAX = 24          
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF  
          
C
C --- INITIALISATION DES NOMS
C
      DO 11 I = 1,NMAX 
        CHAPOU(I) = CHAPIN(I)          
   11 CONTINUE      
C
C --- REMPLACEMENT
C
      CHAPOU(INDEX) = NOMVAR      
C
      END

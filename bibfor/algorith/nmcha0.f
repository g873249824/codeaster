      SUBROUTINE NMCHA0(TYCHAP,TYVARZ,NOVARZ,VACHAP)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*19  VACHAP(*)
      CHARACTER*6   TYCHAP
      CHARACTER*(*) TYVARZ,NOVARZ   
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
C
C CREATION D'UNE VARIABLE CHAPEAU
C
C ----------------------------------------------------------------------
C
C
C OUT VACHAP : VARIABLE CHAPEAU
C IN  TYCHAP : TYPE DE VARIABLE CHAPEAU
C                MEELEM - NOMS DES MATR_ELEM
C                MEASSE - NOMS DES MATR_ASSE
C                VEELEM - NOMS DES VECT_ELEM
C                VEASSE - NOMS DES VECT_ASSE
C                SOLALG - NOMS DES CHAM_NO SOLUTIONS
C                VALINC - VALEURS SOLUTION INCREMENTALE
C IN  TYVARI : TYPE DE LA VARIABLE 
C               SI 'ALLINI' ALORS INITIALISE A BLANC
C IN  NOVARI : NOM DE LA VARIABLE
C      
C ----------------------------------------------------------------------
C
      CHARACTER*19 K19BLA
      INTEGER      I,NBVAR
      INTEGER      INDEX
      CHARACTER*6  TYVARI
      CHARACTER*19 NOVARI
C      
C ----------------------------------------------------------------------
C 
      K19BLA = ' '
      TYVARI = TYVARZ
      NOVARI = NOVARZ   
C        
      CALL NMCHAI(TYCHAP,'LONMAX',NBVAR )
C 
      IF (TYVARI.EQ.'ALLINI') THEN
        DO 12 I = 1,NBVAR
          VACHAP(I) = K19BLA          
   12   CONTINUE        
      ELSE
        CALL NMCHAI(TYCHAP,TYVARI,INDEX)
        IF ((INDEX.LE.0).OR.(INDEX.GT.NBVAR)) THEN
          CALL ASSERT(.FALSE.)
        ELSE
          VACHAP(INDEX) = NOVARI  
        ENDIF
      
      ENDIF
C
      END

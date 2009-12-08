      CHARACTER*19 FUNCTION NMCHEX(VACHAP,TYCHAP,TYVARI)
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
      CHARACTER*19  VACHAP(*)
      CHARACTER*6   TYCHAP
      CHARACTER*6   TYVARI      
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
C
C RECUPERATION NOM DE LA VARIABLE DANS UNE VARIABLE CHAPEAU
C      
C ----------------------------------------------------------------------
C
C     
C IN  VACHAP : VARIABLE CHAPEAU
C IN  TYCHAP : TYPE DE VARIABLE CHAPEAU
C                MEELEM - NOMS DES MATR_ELEM
C                MEASSE - NOMS DES MATR_ASSE
C                VEELEM - NOMS DES VECT_ELEM
C                VEASSE - NOMS DES VECT_ASSE
C                SOLALG - NOMS DES CHAM_NO SOLUTIONS
C IN  TYVARI : TYPE DE LA VARIABLE 
C OUT NMCHEX : NOM DE LA VARIABLE
C
C ----------------------------------------------------------------------
C
      INTEGER NMCHAI,INDEX
C
C ----------------------------------------------------------------------
C
      INDEX  = NMCHAI(TYCHAP,TYVARI)
      NMCHEX = VACHAP(INDEX)
C
      END

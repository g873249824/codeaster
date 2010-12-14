      SUBROUTINE NMXMA3(FONACT,LISCHA,SOLVEU,NUMEDD,NBMATR,
     &                  LTYPMA,LOPTMA,LCALME,LASSME,MEELEM,
     &                  MEASSE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/12/2010   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2010  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INTEGER       NBMATR    
      CHARACTER*6   LTYPMA(20)
      CHARACTER*16  LOPTMA(20)
      LOGICAL       LCALME(20),LASSME(20)       
      CHARACTER*19  LISCHA,SOLVEU
      CHARACTER*24  NUMEDD
      CHARACTER*19  MEELEM(*),MEASSE(*)
      INTEGER       FONACT(*)          
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
C
C CALCUL ET ASSEMBLAGE DES MATR_ELEM DE LA LISTE
C
C VERSION SIMPLIFIEE - NE FAIT QUE L'ASSEMBLAGE
C UTILISEZ NMXMAT
C      
C ----------------------------------------------------------------------
C
C
C IN  NUMEDD : NUME_DDL
C IN  LISCHA : LISTE DES CHARGES
C IN  SOLVEU : SOLVEUR
C IN  PREMIE : SI PREMIER INSTANT DE CALCUL
C IN  NBMATR : NOMBRE DE MATR_ELEM DANS LA LISTE
C IN  LTYPMA : LISTE DES NOMS DES MATR_ELEM
C IN  LOPTMA : LISTE DES OPTIONS DES MATR_ASSE
C IN  LASSME : SI MATR_ELEM A ASSEMBLER
C IN  LCALME : SI MATR_ELEM A CALCULER
C      
C ----------------------------------------------------------------------
C
      CALL ASSERT(.FALSE.)
C
      END

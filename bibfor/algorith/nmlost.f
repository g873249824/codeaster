      SUBROUTINE NMLOST(SDTIME)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.         
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24  SDTIME
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C TEMPS PERDU (A CAUSE DECOUPE PAS DE TEMPS)
C      
C ----------------------------------------------------------------------
C
C
C IN  SDTIME : SD TIMER
C
C
C
C
      REAL*8       TIME
C      
C ----------------------------------------------------------------------
C      
      CALL JEMARQ()
C
C --- TEMPS PASSE DANS LE PAS
C
      CALL NMTIMR(SDTIME,'TEMPS_PHASE','P',TIME)
C
C --- SAUVEGARDE TEMPS GASPILLE
C
      CALL NMRTIM(SDTIME,'PAS_LOST'   ,TIME)
C
      CALL JEDEMA()
      END

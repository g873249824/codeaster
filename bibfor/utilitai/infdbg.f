      SUBROUTINE INFDBG(OPTIOZ,IFM,NIV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 13/03/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2007  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT      NONE
      CHARACTER*(*) OPTIOZ
      INTEGER       IFM,NIV
C      
C ----------------------------------------------------------------------
C
C ROUTINE POUR AFFICHAGE INFOS DEBUG
C
C ----------------------------------------------------------------------
C
C
C IN  OPTION : OPTION DE DEBUGGAGE
C                'CONTACT': DEBUG POUR LE CONTACT
C OUT IFM    : UNITE D'IMPRESSION
C OUT NIV    : NIVEAU D'IMPRESSION  
C
C ----------------------------------------------------------------------
C
      CHARACTER*16 OPTION
C
C ----------------------------------------------------------------------
C
      OPTION = OPTIOZ     
C
      IF (OPTION(1:7).EQ.'CONTACT') THEN
        CALL INFNIV(IFM,NIV)
        NIV = 2
      ELSE
        CALL INFNIV(IFM,NIV)
      ENDIF


      END

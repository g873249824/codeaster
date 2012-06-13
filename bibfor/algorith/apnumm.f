      SUBROUTINE APNUMM(SDAPPA,POSMA ,NUMMA )
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
      IMPLICIT      NONE
      INCLUDE 'jeveux.h'
      CHARACTER*19  SDAPPA
      INTEGER       POSMA ,NUMMA 
C      
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT (UTILITAIRE)
C
C NUMERO ABSOLU DE LA MAILLE
C
C ----------------------------------------------------------------------
C
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C IN  POSMA  : POSITION DE LA MAILLE DANS LES SD
C OUT NUMMA  : NUMERO ABSOLU DE LA MAILLE DANS LE MAILLAGE
C
C
C
C
      CHARACTER*24 DEFICO
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()    
C
C --- NOM SD DEFINITION CONTACT
C
      CALL APNOMK(SDAPPA,'DEFICO',DEFICO)
C
C --- REPONSE
C
      CALL CFNUMM(DEFICO,1     ,POSMA ,NUMMA )        
C
      CALL JEDEMA()
C 
      END

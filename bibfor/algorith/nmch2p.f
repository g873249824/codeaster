      SUBROUTINE NMCH2P(SOLALG)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 15/04/2013   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
      IMPLICIT     NONE
      CHARACTER*19 SOLALG(*)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATION)
C
C CREATION DES VARIABLES CHAPEAUX - SOLALG
C
C ----------------------------------------------------------------------
C
C
C OUT SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C
C ----------------------------------------------------------------------
C
      CHARACTER*19 DEPOLD,DDEPLA,DEPDEL,DEPPR1,DEPPR2
      CHARACTER*19 VITOLD,DVITLA,VITDEL,VITPR1,VITPR2
      CHARACTER*19 ACCOLD,DACCLA,ACCDEL,ACCPR1,ACCPR2
      CHARACTER*19 DEPSO1,DEPSO2
C
      DATA DEPDEL,DDEPLA    /'&&NMCH2P.DEPDEL','&&NMCH2P.DDEPLA'/
      DATA DEPOLD           /'&&NMCH2P.DEPOLD'/
      DATA DEPPR1,DEPPR2    /'&&NMCH2P.DEPPR1','&&NMCH2P.DEPPR2'/
      DATA VITDEL,DVITLA    /'&&NMCH2P.VITDEL','&&NMCH2P.DVITLA'/
      DATA VITOLD           /'&&NMCH2P.VITOLD'/
      DATA VITPR1,VITPR2    /'&&NMCH2P.VITPR1','&&NMCH2P.VITPR2'/
      DATA ACCDEL,DACCLA    /'&&NMCH2P.ACCDEL','&&NMCH2P.DACCLA'/
      DATA ACCOLD           /'&&NMCH2P.ACCOLD'/
      DATA ACCPR1,ACCPR2    /'&&NMCH2P.ACCPR1','&&NMCH2P.ACCPR2'/
      DATA DEPSO1,DEPSO2    /'&&NMCH2P.DEPSO1','&&NMCH2P.DEPSO2'/
C
C ----------------------------------------------------------------------
C
      CALL NMCHA0('SOLALG','ALLINI',' ',SOLALG)
      CALL NMCHA0('SOLALG','DDEPLA',DDEPLA,SOLALG)
      CALL NMCHA0('SOLALG','DEPDEL',DEPDEL,SOLALG)
      CALL NMCHA0('SOLALG','DEPPR1',DEPPR1,SOLALG)
      CALL NMCHA0('SOLALG','DEPPR2',DEPPR2,SOLALG)
      CALL NMCHA0('SOLALG','DEPOLD',DEPOLD,SOLALG)
      CALL NMCHA0('SOLALG','DVITLA',DVITLA,SOLALG)
      CALL NMCHA0('SOLALG','VITDEL',VITDEL,SOLALG)
      CALL NMCHA0('SOLALG','VITPR1',VITPR1,SOLALG)
      CALL NMCHA0('SOLALG','VITPR2',VITPR2,SOLALG)
      CALL NMCHA0('SOLALG','VITOLD',VITOLD,SOLALG)
      CALL NMCHA0('SOLALG','DACCLA',DACCLA,SOLALG)
      CALL NMCHA0('SOLALG','ACCDEL',ACCDEL,SOLALG)
      CALL NMCHA0('SOLALG','ACCPR1',ACCPR1,SOLALG)
      CALL NMCHA0('SOLALG','ACCPR2',ACCPR2,SOLALG)
      CALL NMCHA0('SOLALG','ACCOLD',ACCOLD,SOLALG)
      CALL NMCHA0('SOLALG','DEPSO1',DEPSO1,SOLALG)
      CALL NMCHA0('SOLALG','DEPSO2',DEPSO2,SOLALG)
C
      END

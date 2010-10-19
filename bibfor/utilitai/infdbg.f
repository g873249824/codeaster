      SUBROUTINE INFDBG(OPTIOZ,IFM,NIV)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 19/10/2010   AUTEUR DESOZA T.DESOZA 
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
      CHARACTER*16  CZCONT,CZMECA,CZPILO,CZFACT,CZAPPA,K16B
      COMMON /CZDBG/CZCONT,CZMECA,CZPILO,CZFACT,CZAPPA
C ----------------------------------------------------------------------
C
C ROUTINE POUR AFFICHAGE INFOS DEBUG
C
C POUR L'INSTANT, ON DECONNECTE (FICHE 10620 DU REX)
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
        IF(CZCONT.NE.'CONTACT')NIV=1
      ELSEIF (OPTION.EQ.'XFEM') THEN
        CALL INFNIV(IFM,NIV) 
      ELSEIF (OPTION.EQ.'MECA_NON_LINE' .OR.
     &        OPTION.EQ.'MECANONLINE') THEN
        CALL INFNIV(IFM,NIV)   
        IF(CZMECA.NE.'MECA_NON_LINE')NIV=1
      ELSEIF (OPTION.EQ.'PRE_CALCUL') THEN
        CALL INFNIV(IFM,NIV) 
        NIV = 1                
      ELSEIF (OPTION.EQ.'PILOTE') THEN
        CALL INFNIV(IFM,NIV)
        IF(CZPILO.NE.'PILOTE')NIV=1
      ELSEIF (OPTION(1:6).EQ.'FACTOR') THEN
        CALL INFNIV(IFM,NIV)
        IF(CZFACT.NE.'FACTORISATION')NIV=1
      ELSEIF (OPTION.EQ.'APPARIEMENT') THEN
        CALL INFNIV(IFM,NIV)
        IF(CZAPPA.NE.'APPARIEMENT')NIV=1
      ELSE
        CALL INFNIV(IFM,NIV)
      ENDIF
      
      


      END

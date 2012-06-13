      SUBROUTINE APINFI(SDAPPA,QUESTZ,IP    ,VALI  )
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
      IMPLICIT     NONE
      INCLUDE 'jeveux.h'
      CHARACTER*19  SDAPPA
      INTEGER       IP 
      INTEGER       VALI 
      CHARACTER*(*) QUESTZ
C      
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT (UTILITAIRE)
C
C INTERROGATION DE LA SDAPPA - ENTIER
C
C ----------------------------------------------------------------------
C
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C IN  QUESTI : QUESTION
C              'APPARI_TYPE'     TYPE D'APPARIEMENT (ND, MAILLE, ETC)
C              'APPARI_ENTITE'   NUMERO D'ENTITE APPARIEE
C              'APPARI_ZONE'     ZONE SUPPORT DU POINT
C              'APPARI_MAILLE'   MAILLE SUPPORT DU POINT
C              'APPARI_NOEUD'    NOEUD SUPPORT DU POINT
C IN  IP     : INDICE DU POINT
C OUT VALI   : REPONSE A LA QUESTION 
C
C
C
C
      INTEGER      IFM,NIV
      CHARACTER*24 APPAR
      INTEGER      JAPPA
      CHARACTER*16 QUESTI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('APPARIEMENT',IFM,NIV)     
C
C --- ACCES SDAPPA
C
      APPAR  = SDAPPA(1:19)//'.APPA'
C
C --- INITIALISATIONS
C
      VALI   = 0
      QUESTI = QUESTZ
C
C --- QUESTION
C
      IF (QUESTI.EQ.'APPARI_TYPE') THEN
        CALL JEVEUO(APPAR ,'L',JAPPA )
        VALI  = ZI(JAPPA+4*(IP-1)+1-1)
      ELSEIF (QUESTI.EQ.'APPARI_ENTITE') THEN 
        CALL JEVEUO(APPAR ,'L',JAPPA )  
        VALI  = ZI(JAPPA+4*(IP-1)+2-1)        
      ELSEIF (QUESTI.EQ.'APPARI_ZONE') THEN 
        CALL JEVEUO(APPAR ,'L',JAPPA )  
        VALI  = ZI(JAPPA+4*(IP-1)+3-1)                 
      ELSEIF (QUESTI.EQ.'APPARI_MAILLE') THEN 
        CALL JEVEUO(APPAR ,'L',JAPPA )  
        VALI  = ZI(JAPPA+4*(IP-1)+4-1)     
      ELSE    
        CALL ASSERT(.FALSE.)
      ENDIF             
C
      CALL JEDEMA()
C 
      END

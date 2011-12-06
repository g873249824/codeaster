      SUBROUTINE APNOMK(SDAPPA,QUESTI,RNOMSD)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/09/2010   AUTEUR ABBAS M.ABBAS 
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
      IMPLICIT     NONE
      CHARACTER*19  SDAPPA
      CHARACTER*(*) QUESTI
      CHARACTER*24  RNOMSD
C      
C ----------------------------------------------------------------------
C
C ROUTINE APPARIEMENT (UTILITAIRE)
C
C ROUTINE D'INTERROGATION DE LA SD NOMSD
C
C ----------------------------------------------------------------------
C
C
C IN  SDAPPA : NOM DE LA SD APPARIEMENT
C IN  QUISTI : QUEL NOM DE SD
C               'NEWGEO' - OBJET GEOMETRIE ACTUALISEE
C               'NOMA'   - OBJET MAILLAGE
C               'DEFICO' - OBJET DEFINTION DU CONTACT               
C OUT RNOMSD : NOM DE LA SD INTERROGEE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*24 NOMSD
      INTEGER      JNOMSD

C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      RNOMSD = ' '         
C
C --- ACCES SDAPPA
C  
      NOMSD  = SDAPPA(1:19)//'.NOSD'
      CALL JEVEUO(NOMSD ,'L',JNOMSD)
C
C --- REPONSE
C
      IF (QUESTI(1:4).EQ.'NOMA') THEN
        RNOMSD = ZK24(JNOMSD+1 -1)
      
      ELSEIF (QUESTI(1:6).EQ.'NEWGEO') THEN
        RNOMSD = ZK24(JNOMSD+2 -1)
      
      ELSEIF(QUESTI(1:6).EQ.'DEFICO') THEN
        RNOMSD = ZK24(JNOMSD+3 -1)
      
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF     
C
      CALL JEDEMA()
C 
      END

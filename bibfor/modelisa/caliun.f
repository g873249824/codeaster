      SUBROUTINE CALIUN(CHARZ ,NOMAZ ,NOMOZ )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
      CHARACTER*(*) CHARZ
      CHARACTER*(*) NOMAZ
      CHARACTER*(*) NOMOZ
C     
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT 
C
C TRAITEMENT DE LIAISON_UNILATERALE DANS DEFI_CONTACT
C      
C ----------------------------------------------------------------------
C
C
C IN  CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
C IN  NOMA   : NOM DU MAILLAGE
C IN  NOMO   : NOM DU MODELE
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      CHARACTER*8  CHAR,NOMA,NOMO   
      CHARACTER*16 MOTFAC
      INTEGER      IFORM
      INTEGER      NZOCU,NNOCU,NTCMP
      CHARACTER*24 NOLINO,NOPONO
      CHARACTER*24 LISNOE,POINOE
      CHARACTER*24 NBGDCU,COEFCU,COMPCU,MULTCU
      CHARACTER*24 DEFICU,DEFICO
      CHARACTER*24 PARACI,PARACR,NDIMCU
      INTEGER      JPARCI,JPARCR,JDIM  
      INTEGER      CFMMVD,ZPARI,ZPARR  
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      NOMO   = NOMOZ(1:8)
      CHAR   = CHARZ
      NOMA   = NOMAZ
      IFORM  = 4
      MOTFAC = 'ZONE'  
      DEFICO = CHAR(1:8)//'.CONTACT'
      DEFICU = CHAR(1:8)//'.UNILATE'               
C
C --- RECUPERATION DU NOMBRE D'OCCURENCES
C
      CALL GETFAC(MOTFAC,NZOCU )
C
      IF (NZOCU.EQ.0) THEN 
        GOTO 999
      ENDIF
C
C --- CREATION SD PARAMETRES GENERAUX (NE DEPENDANT PAS DE LA ZONE)
C
      PARACI = DEFICO(1:16)//'.PARACI'
      ZPARI  = CFMMVD('ZPARI')
      CALL WKVECT(PARACI,'G V I',ZPARI      ,JPARCI)
      PARACR = DEFICO(1:16)//'.PARACR'
      ZPARR  = CFMMVD('ZPARR')
      CALL WKVECT(PARACR,'G V R',ZPARR      ,JPARCR) 
      ZI(JPARCI+4-1) = IFORM   
C       
      NDIMCU = DEFICU(1:16)//'.NDIMCU'
      CALL WKVECT(NDIMCU,'G V I',2          ,JDIM  )        
C
C --- RECUPERATION CARACTERISTIQUES ELEMENTAIRES
C 
      NBGDCU = '&&CALIUN.NBGDCU' 
      COMPCU = '&&CARAUN.COMPCU'
      MULTCU = '&&CARAUN.MULTCU'
      COEFCU = '&&CARAUN.COEFCU'              
      CALL CARAUN(CHAR  ,MOTFAC,NZOCU ,NBGDCU,COEFCU,
     &            COMPCU,MULTCU,NTCMP )
C     
C --- EXTRACTION DES NOEUDS    
C  
      NOPONO = '&&CALIUN.PONOEU'
      NOLINO = '&&CALIUN.LINOEU'
      CALL LISTUN(NOMA  ,MOTFAC,NZOCU ,NOPONO,NNOCU ,
     &            NOLINO)
C
C --- ELIMINATION DES NOEUDS 
C      SUPPRESSION DES DOUBLONS ENTRE MAILLE, GROUP_MA, NOEUD,GROUP_NO
C      SUPPRESSION DES NOEUDS DEFINIS DANS SANS_NOEUD ET SANS_GROUP_NO
C
      LISNOE = '&&CALIUN.LISNOE'
      POINOE = '&&CALIUN.POINOE'      
      CALL ELIMUN(NOMA  ,NOMO  ,MOTFAC,NZOCU ,NBGDCU,
     &            COMPCU,NOPONO,NOLINO,LISNOE,POINOE,
     &            NNOCU )               
C
C --- ELIMINATION DES COMPOSANTES ET CREATION FINALE DES SD
C       
      CALL CREAUN(CHAR  ,NOMA  ,NOMO  ,NZOCU ,NNOCU ,
     &            LISNOE,POINOE,NBGDCU,COEFCU,COMPCU,
     &            MULTCU)
C
C --- AFFICHAGE DES INFORMATIONS                 
C
      CALL SURFUN(CHAR,NOMA)
C
C --- MENAGE
C        
      CALL JEDETR(NOLINO) 
      CALL JEDETR(NOPONO)
      CALL JEDETR(LISNOE) 
      CALL JEDETR(POINOE)      
      CALL JEDETR(NBGDCU) 
      CALL JEDETR(COEFCU) 
      CALL JEDETR(COMPCU) 
      CALL JEDETR(MULTCU)                       
C
 999  CONTINUE
C
      CALL JEDEMA()
C
      END

      SUBROUTINE XMELEM(NOMA  ,MODELE,DEFICO,RESOCO)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      CHARACTER*8   MODELE,NOMA
      CHARACTER*24  RESOCO,DEFICO
C 
C ----------------------------------------------------------------------
C
C ROUTINE XFEM (METHODE XFEM - CREATION CHAM_ELEM)
C
C CREATION DES CHAM_ELEM
C      
C ----------------------------------------------------------------------
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  MODELE : NOM DU MODELE
C IN  RESOCO : SD CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER       IFM,NIV  
      CHARACTER*19  LIGREL   
      CHARACTER*19  XDONCO,XINDCO,XSEUCO,XMEMCO,XGLISS  
      INTEGER       NFISS,JNFIS      
      INTEGER       NFISMX
      PARAMETER    (NFISMX=100)        
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('XFEM',IFM,NIV)    
C
C --- AFFICHAGE
C      
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<XFEM  > CREATION DES CHAM_ELEM' 
      ENDIF   
C 
C --- INITIALISATIONS
C
      LIGREL = MODELE//'.MODELE'
C
C --- NOMBRE DE FISSURES
C
      CALL JEVEUO(MODELE//'.NFIS','L',JNFIS)
      NFISS  = ZI(JNFIS)  
      IF (NFISS .GT. NFISMX) THEN
        CALL U2MESI('F', 'XFEM_2', 1, NFISMX)
      ENDIF  
      IF (NFISS .LE. 0) THEN
        CALL U2MESS('F', 'XFEM_3')
      ENDIF       
C      
C --- CREATION DU CHAM_ELEM PINDCOI (STATUT DU CONTACT)
C --- CREATION DU CHAM_ELEM PMEMCON (MEMOIRE DU CONTACT)
C 
      XINDCO = RESOCO(1:14)//'.XFIN'
      XMEMCO = RESOCO(1:14)//'.XMEM'      
      CALL XMELE1(NOMA  ,MODELE,DEFICO,LIGREL,NFISS ,
     &            XINDCO,XMEMCO)
C
C --- CREATION DU CHAM_ELEM PDONCO (DONNEES DU CONTACT)
C
      XDONCO = RESOCO(1:14)//'.XFDO'
      CALL XMELE2(NOMA  ,MODELE,DEFICO,LIGREL,NFISS ,
     &            XDONCO)
C
C --- CREATION DU CHAM_ELEM PSEUIL (SEUIL DE FROTTEMENT DE TRESCA)
C
      XSEUCO = RESOCO(1:14)//'.XFSE'
      CALL XMELE3(NOMA  ,MODELE,DEFICO,LIGREL,NFISS ,
     &            XSEUCO) 
C
C --- CREATION DU CHAM_ELEM PGLISS (GLISSIERE)
C
      XGLISS = RESOCO(1:14)//'.XFGL'
      CALL XMELE4(NOMA  ,MODELE,DEFICO,LIGREL,NFISS ,
     &            XGLISS)     
C
      CALL JEDEMA()
C   
      END

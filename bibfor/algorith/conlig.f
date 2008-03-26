      SUBROUTINE CONLIG(NOMA  ,MODELE,NUMEDD,DEFICO,RESOCO,
     &                  LISCHA,SOLVEU,MATASS,INST  ,SDDYNA,
     &                  VALMOI,VALPLU,DEPALG,MEELEM,MEASSE)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C TOLE CRP_21
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*8  NOMA
      CHARACTER*19 LISCHA,SOLVEU,MATASS
      CHARACTER*19 SDDYNA
      CHARACTER*24 MODELE,NUMEDD
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*24 VALMOI(8),VALPLU(8),DEPALG(8)
      CHARACTER*19 MEELEM(8)
      CHARACTER*19 MEASSE(8)
      REAL*8       INST(*)
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODE CONTINUE - CREATION OBJETS)
C
C CREATION DES OBJETS ELEMENTAIRES:
C  - LIGREL/CARTE PUIS NUME_DDL
C  - MATRICE MASSE
C      
C ----------------------------------------------------------------------
C
C
C IN  NEQ    : NOMBRE D'EQUATION DU MODELE
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  LISCHA : L_CHARGES CONTENANT LES CHARGES APPLIQUEES
C IN  SOLVEU : OBJET SOLVEUR
C IN  MATASS : MATRICE DE RIGIDITE GLOBALE
C IN  DEPMOI : CHAM_NO DES DEPLACEMENTS A L'INSTANT PRECEDENT
C IN  DEPPLU : CHAM_NO DES DEPLACEMENTS A L'INSTANT COURANT
C IN  MODELE : NOM DU MODELE
C IN  NUMEDD : NOM DU NUME_DDL
C IN  DEPDEL : INCREMENT DE DEPLACEMENT CUMULE
C IN  DDEPLA : DIRECTION DE DESCENTE
C IN  MEMASS : OBJET MATR_ELEM POUR MATRICES ELEMENTAIRES DE MASSE
C IN  MASSE  : MATRICE MASSE ASSEMBLEE
C IN  ACCMOI : CHAM_NO DES ACCELERATIONS A L'INSTANT PRECEDENT
C IN  VITMOI : CHAM_NO DES VITESSES A L'INSTANT PRECEDENT
C IN  ACCPLU : CHAM_NO DES ACCELERATIONS A L'INSTANT COURANT
C IN  VITPLU : CHAM_NO DES VITESSES A L'INSTANT COURANT
C IN  INST   : PARAMETRES D'INSTANT POUR LA DYNAMIQUE
C IN  SDDYNA : SD DEDIEE A LA DYNAMIQUE
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
      INTEGER      JDEPDE,JDDEPL,NEQ
      INTEGER      IFM,NIV  
      LOGICAL      NDYNLO 
      CHARACTER*24 VITINI,ACCINI,DDEPLA,DEPDEL 
      CHARACTER*24 DEPMOI,VITMOI,ACCMOI
      CHARACTER*24 DEPPLU,VITPLU,ACCPLU
      CHARACTER*24 K24BID  
      CHARACTER*8  K8BID
      CHARACTER*19 MASSE,MEMASS
C      
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV)       
C
C --- AFFICHAGE
C      
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> CREATION ET INITIALISATION'//
     &        ' DES OBJETS POUR LE CONTACT' 
      ENDIF 
C
C --- DECOMPACTION DES VARIABLES CHAPEAUX
C       
      CALL DESAGG(VALMOI,DEPMOI,K24BID,K24BID,K24BID,
     &            VITMOI,ACCMOI,K24BID,K24BID)
      CALL DESAGG(VALPLU,DEPPLU,K24BID,K24BID,K24BID,
     &            VITPLU,ACCPLU,K24BID,K24BID) 
      CALL DESAGG(DEPALG,DDEPLA,DEPDEL,K24BID,K24BID,
     &            K24BID,K24BID,K24BID,K24BID)  
      CALL JELIRA(DEPMOI(1:19)//'.VALE','LONMAX',NEQ,K8BID)  
      MASSE  = MEASSE(3) 
      MEMASS = MEELEM(3)         
C
C --- INITIALISATION DES CHAMPS DE DEPLACEMENT
C 
      CALL COPISD('CHAMP_GD','V',DEPMOI,DEPPLU)    
      CALL JEVEUO(DEPDEL(1:19)//'.VALE','E',JDEPDE)
      CALL JEVEUO(DDEPLA(1:19)//'.VALE','E',JDDEPL)
      CALL ZZZERO(NEQ,JDEPDE)
      CALL ZZZERO(NEQ,JDDEPL) 
C
C --- AFIN QUE LE VECTEUR DES FORCES D'INERTIE NE SOIT PAS MODIFIE AU
C --- COURS DE LA BOUCLE DES CONTRAINTES ACTIVES PAR L'APPEL A OP0070
C --- ON LE DUPLIQUE ET ON UTILISE CETTE COPIE FIXE (VITINI,ACCINI)
C 
      VITINI = RESOCO(1:14)//'.VITI'
      ACCINI = RESOCO(1:14)//'.ACCI'
      IF (NDYNLO(SDDYNA,'DYNAMIQUE')) THEN
        CALL COPISD('CHAMP_GD','V',VITINI,VITPLU)
        CALL COPISD('CHAMP_GD','V',ACCINI,ACCPLU)        
      END IF       
C
C --- CREATION DU LIGREL DES ELEMENTS DE CONTACT
C
      CALL MMLIGR(NOMA  ,DEFICO,RESOCO)
C
C --- CREATION DE LA CARTE CONTENANT LES INFOS DE CONTACT
C
      CALL MMCART(NOMA  ,DEFICO,RESOCO,INST  )
C
C --- CREATION DU NOUVEAU NUME_DDL POUR LES ELEMENTS DE CONTACT 
C   
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> CREATION DU NUME_DDL DES'//
     &        ' ELEMENTS DE CONTACT' 
      ENDIF    
      CALL NUMER3(MODELE,LISCHA,SOLVEU,NUMEDD)
C      
C --- ASSEMBLAGE DE LA MATRICE DE MASSE
C   
      IF (NDYNLO(SDDYNA,'IMPLICITE')) THEN
        CALL ASMAMA(MEMASS,' ',NUMEDD,SOLVEU,LISCHA,
     &              MASSE)
        CALL MTDSCR(MASSE)
      ENDIF 
C
C --- CREATION DES MATRICES ELEMENTAIRES ET VECTEURS DES FORCES
C --- ELEMENTAIRES POUR LES ELEMENTS DE CONTACT
C      
      CALL DETRSD('MATR_ASSE',MATASS)
      CALL MMCMEM('PREDICTION',
     &            NOMA  ,MODELE,DEFICO,RESOCO,DEPMOI,
     &            DEPDEL,VITMOI,VITPLU,ACCMOI)
C
      CALL JEDEMA()
      END

      SUBROUTINE RECHNO(NOMA  ,IZONE ,NEWGEO,DEFICO,RESOCO,
     &                  IESCL0,NFESCL)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/10/2008   AUTEUR DESOZA T.DESOZA 
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
C RESPONSABLE ABBAS M.ABBAS
C TOLE CRP_20
C
      IMPLICIT     NONE
      INTEGER      IZONE
      CHARACTER*24 NEWGEO
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO
      INTEGER      IESCL0     
      CHARACTER*8  NOMA
      INTEGER      NFESCL
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT - NODAL)
C
C RECHERCHE POUR CHAQUE NOEUD ESCLAVE LE NOEUD MAITRE LE PLUS 
C PROCHE ET REALISE L'APPARIEMENT (ECRITURE DE LA RELATION CINEMATIQUE)
C
C ----------------------------------------------------------------------
C
C
C NB: LES NOTIONS DE "MAITRE" ET
C D'"ESCLAVE" SONT FICTIVES ICI : ON PREND COMME SURFACE ESCLAVE
C CELLE QUI A LE MOINS DE NOEUDS POUR AVOIR PLUS DE CHANCES D'AVOIR
C UN APPARIEMENT INJECTIF.
C
C
C IN  NOMA   : NOM DU MAILLAGE
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT
C IN  NEWGEO : GEOMETRIE ACTUALISEE EN TENANT COMPTE DU CHAMP DE
C              DEPLACEMENTS COURANT
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C IN  IESCL0 : INDICE DU PREMIER NOEUD ESCLAVE A EXAMINER
C OUT NFESCL : NOMBRE DE NOEUDS ESCLAVES DE LA ZONE
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
      INTEGER      CFDISI
      CHARACTER*24 NDIMCO,TANINI
      INTEGER      JDIM,JTGINI
      INTEGER      TYPALF,FROT3D,IBID
      INTEGER      NESMAX,NDIMG,NBNOE,NBNOM
      INTEGER      NBDDLE,NBDDLM,NBDDLT
      INTEGER      POSNOE,POSNOM,NUMNOM
      INTEGER      ISURFE,ISURFM,SUPPOK
      INTEGER      JDECE,JDECM,KE,IESCL,I,CODRET
      REAL*8       JEU,NOOR,R8PREM
      CHARACTER*24 K24BLA,K24BID 
      REAL*8       COORDE(3),COORDM(3)
      LOGICAL      DIRAPP,LBID
      REAL*8       DIR(3),TOLEAP         
      REAL*8       COEF(30),COFX(30),COFY(30),COEFNO(1)  
      REAL*8       NORM(3),TAU1(3),TAU2(3),TAU1M(3),TAU2M(3) 
      INTEGER      DDL(30) 
      INTEGER      IFM,NIV  
      CHARACTER*8  K8BID,NOMNOE,NOMNOM
      CHARACTER*4  TYPNOE
      REAL*8       R8BID
      INTEGER      VALI(3)
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()      
      CALL INFDBG('CONTACT',IFM,NIV)    
C   
C --- AFFICHAGE
C 
      VALI(1) = IZONE
      CALL CFIMPD(IFM   ,NIV  ,'RECHNO',1, 
     &            VALI  ,R8BID,K8BID)       
C
C --- INFOS SUR LA CHARGE DE CONTACT
C
      CALL CFDISC(DEFICO,RESOCO(1:14),IBID,TYPALF,FROT3D,IBID)
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      NDIMCO = DEFICO(1:16)//'.NDIMCO'    
      TANINI = DEFICO(1:16)//'.TANINI'      
C    
      CALL JEVEUO(NDIMCO,'E',JDIM  )
      CALL JEVEUO(TANINI,'L',JTGINI)         
C
C --- INITIALISATION DE VARIABLES
C      
      K24BLA = ' '
C
C --- OPTIONS SUR LA ZONE DE CONTACT
C            
      CALL MMINFP(IZONE ,DEFICO,K24BLA,'TYPE_APPA'        ,
     &            IBID  ,DIR   ,K24BID,DIRAPP) 
      CALL MMINFP(IZONE ,DEFICO,K24BLA,'TOLE_APPA',
     &            IBID  ,TOLEAP,K24BID,LBID  )                     
C
C --- NOMBRE MAXIMUM DE NOEUDS ESCLAVES ET DIMENSION DU PROBLEME
C
      NESMAX = CFDISI(DEFICO,'NESMAX'     ,IZONE)
      NDIMG  = CFDISI(DEFICO,'NDIM'       ,IZONE)           
C
C --- NUMEROS DES SURFACES MAITRE ET ESCLAVE
C
      CALL CFZONE(DEFICO,IZONE ,'ESCL',ISURFE)
      CALL CFZONE(DEFICO,IZONE ,'MAIT',ISURFM)
C
C --- NOMBRE DE NOEUDS DES SURFACES
C
      CALL CFNBSF(DEFICO,ISURFE,'NOEU',NBNOE ,JDECE )
      CALL CFNBSF(DEFICO,ISURFM,'NOEU',NBNOM ,JDECM )
C
C --- IL FAUT QUE LA SURFACE ESCLAVE SOIT CELLE AVEC LE MOINS DE NOEUDS
C
      IF (NBNOM.LT.NBNOE) THEN    
        VALI(1) = IZONE
        VALI(2) = NBNOM
        VALI(3) = NBNOE
        CALL U2MESG('F','CONTACT3_30',0,K24BID,3,VALI,0,0.D0)
      END IF
C
C --- NOMBRE DE NOEUDS ESCLAVES DE LA ZONE A PRIORI
C
      ZI(JDIM+8+IZONE) = NBNOE  
C
C --- PREMIER NOEUD ESCLAVE DE LA ZONE
C
      IESCL    = IESCL0                
C
C --- APPARIEMENT PAR METHODE "BRUTE FORCE"
C --- DOUBLE BOUCLE SUR LES NOEUDS
C
      DO 50 KE = 1,NBNOE
C
C --- POSITION DANS CONTNO DU NOEUD DE LA SURFACE ESCLAVE
C
        POSNOE  = JDECE + KE      
C
C --- ON ELIMINE LE NOEUD SI INTERDIT COMME ESCLAVE
C
        CALL CFELSN(NOMA  ,DEFICO,RESOCO,IZONE,POSNOE,
     &              SUPPOK)
C
C --- SINON ON CHERCHE LE NOEUD MAITRE APPARIE
C     
        IF (SUPPOK.EQ.0) THEN  
C
C --- CARACTERISTIQUES DU NOEUD ESCLAVE
C     
          CALL CFCARN(NOMA  ,DEFICO,RESOCO,NEWGEO,POSNOE,
     &                NBDDLE,COORDE,TYPNOE,NOMNOE)        
          IF (TYPNOE.NE.'ESCL') THEN
            CALL ASSERT(.FALSE.)
          ENDIF        
C
C --- RECHERCHE DU NOEUD MAITRE LE PLUS PROCHE 
C
          CALL MMREND(DEFICO,NEWGEO,ISURFM,COORDE,TOLEAP,
     &                DIRAPP,DIR   ,POSNOM)   
          CALL CFPOSM(NOMA  ,DEFICO,'NOEU',1     ,POSNOM,
     &                NUMNOM,CODRET)
          IF (CODRET.LT.0) THEN
            CALL ASSERT(.FALSE.) 
          ENDIF      
          IF (POSNOM.EQ.POSNOE) THEN
            CALL ASSERT(.FALSE.)
          ENDIF
C
C --- CARACTERISTIQUES DU NOEUD MAITRE
C     
          CALL CFCARN(NOMA  ,DEFICO,RESOCO,NEWGEO,POSNOM,
     &                NBDDLM,COORDM,TYPNOE,NOMNOM)            
          IF (TYPNOE.NE.'MAIT') THEN
            CALL ASSERT(.FALSE.)
          ENDIF
C
C --- TANGENTES AU NOEUD MAITRE
C
          DO 10 I = 1,3
            TAU1M(I) = ZR(JTGINI+6*(POSNOM-1)+I-1)   
            TAU2M(I) = ZR(JTGINI+6*(POSNOM-1)+3+I-1)
 10       CONTINUE            
C          
C --- RE-DEFINITION BASE TANGENTE SUIVANT OPTIONS    
C
          CALL CFTANR(NOMA  ,NDIMG ,DEFICO,IZONE ,POSNOE,
     &                'NOEU',POSNOM,NUMNOM,R8BID ,R8BID ,
     &                TAU1M ,TAU2M ,TAU1  ,TAU2  )     
C
C --- CALCUL DE LA NORMALE INTERIEURE
C
          CALL MMNORM(NDIMG ,TAU1  ,TAU2  ,NORM  ,NOOR)
          IF (NOOR.LE.R8PREM()) THEN
            CALL U2MESK('F','CONTACT3_26',1,NOMNOE)
          ENDIF                        
C
C --- CALCUL DU JEU 
C
          CALL CFNEWJ(NDIMG ,COORDE,COORDM,NORM  ,JEU)       
C
C --- COEFFICIENT DE LA RELATION LINEAIRE SUR NOEUD MAITRE
C      
          COEFNO(1) = - 1.D0  
          NBNOM     = 1
C
C --- CALCULE LES COEFFICIENTS DES RELATIONS LINEAIRES ET DONNE LES 
C --- NUMEROS DES DDL ASSOCIES
C        
          CALL CFCOEF(NDIMG ,DEFICO,RESOCO,NBDDLE,NBNOM ,
     &                POSNOM,COEFNO,POSNOE,NORM  ,TAU1  ,
     &                TAU2  ,COEF  ,COFX  ,COFY  ,NBDDLT,
     &                DDL)              
C
C --- STOCKAGE PARAMETRES DE L'APPARIEMENT 
C     
          CALL CFPARN(RESOCO,POSNOE,POSNOM,IESCL)
C
C --- AJOUT DE LA LIAISON NODALE
C
          CALL CFADDM(DEFICO,RESOCO,TYPALF,FROT3D,POSNOE,
     &                IESCL ,NESMAX,NORM  ,TAU1  ,TAU2  ,
     &                COEF  ,COFX  ,COFY  ,JEU   ,NBNOM ,
     &                POSNOM,NBDDLT,DDL)
C
C --- NOEUD ESCLAVE SUIVANT
C
          IESCL = IESCL + 1             
C              
        ENDIF
   50 CONTINUE
C
C
C --- NOMBRE DE NOEUDS ESCLAVES SUR LA ZONE
C
      NFESCL = IESCL - IESCL0         
C
      CALL JEDEMA()

      END

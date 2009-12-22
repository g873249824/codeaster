      SUBROUTINE RECHNO(NOMA  ,IZONE ,NEWGEO,DEFICO,RESOCO,
     &                  ILIDEB,NZLIAI)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 22/12/2009   AUTEUR ABBAS M.ABBAS 
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
      CHARACTER*8  NOMA      
      CHARACTER*24 DEFICO,RESOCO,NEWGEO
      INTEGER      ILIDEB,NZLIAI 
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
C IN  ILIDEB : INDICE DE LA PREMIERE LIAISON POUR LA ZONE
C OUT NZLIAI : NOMBRE FINAL DE LIAISONS SUR LA ZONE 
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
      CHARACTER*24 TGNOEU
      INTEGER      JTGNOE
      INTEGER      NTNOE,NDIM,NBNOE,NBNOM
      INTEGER      NBDDLE,NBDDLM
      INTEGER      POSNOE,POSNOM,POSAPP,NUMNOE,NUMNOM
      INTEGER      ISURFE,ISURFM,SUPPOK,TYPAPP
      INTEGER      JDECE,JDECM,INOE,ILIAI,I,CODRET
      REAL*8       MMINFR,JEU,NOOR,R8PREM
      REAL*8       COORDE(3),COORDM(3),COEFNO(9)
      LOGICAL      MMINFL,DIRAPP
      LOGICAL      CFDISL,LCTFD,LCTF3D
      REAL*8       DIR(3),TOLEAP          
      REAL*8       NORM(3),TAU1(3),TAU2(3),TAU1M(3),TAU2M(3)  
      INTEGER      IFM,NIV  
      CHARACTER*8  NOMNOE,NOMNOM
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
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> APPARIEMENT NODAL POUR ZONE ',
     &                 IZONE 
      ENDIF     
C
C --- INITIALISATIONS
C        
      DIR(1) = 0.D0
      DIR(2) = 0.D0
      DIR(3) = 0.D0        
C
C --- INFOS SUR LA CHARGE DE CONTACT
C      
      LCTFD  = CFDISL(DEFICO,'FROT_DISCRET')
      LCTF3D = CFDISL(DEFICO,'FROT_3D'     )
C
C --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
C
      TGNOEU = RESOCO(1:14)//'.TGNOEU'
      CALL JEVEUO(TGNOEU,'L',JTGNOE)            
C
C --- OPTIONS SUR LA ZONE DE CONTACT
C  
      DIRAPP = MMINFL(DEFICO,'TYPE_APPA_FIXE',IZONE ) 
      IF (DIRAPP) THEN
        DIR(1) = MMINFR(DEFICO,'TYPE_APPA_DIRX',IZONE)
        DIR(2) = MMINFR(DEFICO,'TYPE_APPA_DIRY',IZONE)      
        DIR(3) = MMINFR(DEFICO,'TYPE_APPA_DIRZ',IZONE) 
      ENDIF             
      TOLEAP = MMINFR(DEFICO,'TOLE_APPA',IZONE ) 
C
C --- NOMBRE TOTAL DE NOEUDS ESCLAVES ET DIMENSION DU PROBLEME
C
      NTNOE  = CFDISI(DEFICO,'NTNOE' )
      NDIM   = CFDISI(DEFICO,'NDIM'  )       
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
        CALL U2MESI('F','CONTACT3_30',3,VALI)
      END IF
C
C --- PREMIERE LIAISON DE LA ZONE
C
      ILIAI  = ILIDEB
C
C --- BOUCLE SUR LES NOEUDS ESCLAVES
C
      DO 50 INOE = 1,NBNOE
C
C --- POSITION ET NUMERO DU NOEUD ESCLAVE
C
        POSNOE  = JDECE + INOE   
        CALL CFPOSM(NOMA  ,DEFICO,'NOEU',1     ,POSNOE,
     &              NUMNOE,CODRET)
        IF (CODRET.LT.0) THEN
          CALL ASSERT(.FALSE.) 
        ENDIF           
C
C --- ON ELIMINE LE NOEUD SI INTERDIT COMME ESCLAVE (SANS_NOEUD)
C
        CALL CFMMEX(DEFICO,'CONT',IZONE ,NUMNOE,SUPPOK)
        IF (SUPPOK.EQ.1) THEN 
          TYPAPP = -1
          GOTO 65
        ENDIF 
C
C --- CARACTERISTIQUES DU NOEUD ESCLAVE
C     
        CALL CFCARN(NOMA  ,DEFICO,RESOCO,NEWGEO,POSNOE,
     &              NBDDLE,COORDE,TYPNOE,NOMNOE)        
        IF (TYPNOE.NE.'ESCL') THEN
          CALL ASSERT(.FALSE.)
        ENDIF       
C
C --- RECHERCHE DU NOEUD MAITRE LE PLUS PROCHE 
C
        CALL MMREND(DEFICO,NEWGEO,ISURFM,COORDE,TOLEAP,
     &              DIRAPP,DIR   ,POSNOM)
        IF (POSNOM.EQ.POSNOE) THEN
          CALL ASSERT(.FALSE.)
        ENDIF
C
C --- SI NOEUD MAITRE PROCHE N'EXISTE PAS (TOLE_APPA)
C
        IF (POSNOM.EQ.0) THEN 
          TYPAPP = -2
          GOTO 65
        ENDIF 
C
C --- CARACTERISTIQUES DU NOEUD MAITRE
C     
        CALL CFCARN(NOMA  ,DEFICO,RESOCO,NEWGEO,POSNOM,
     &              NBDDLM,COORDM,TYPNOE,NOMNOM)   
        CALL CFPOSM(NOMA  ,DEFICO,'NOEU',1     ,POSNOM,
     &              NUMNOM,CODRET)              
        IF (CODRET.LT.0) THEN
          CALL ASSERT(.FALSE.)
        ENDIF 
        IF (TYPNOE.NE.'MAIT') THEN
          CALL ASSERT(.FALSE.)
        ENDIF
C
C --- TANGENTES AU NOEUD MAITRE
C
        DO 10 I = 1,3
          TAU1M(I) = ZR(JTGNOE+6*(POSNOM-1)+I-1)   
          TAU2M(I) = ZR(JTGNOE+6*(POSNOM-1)+3+I-1)
 10     CONTINUE             
C          
C --- RE-DEFINITION BASE TANGENTE SUIVANT OPTIONS    
C
        CALL CFTANR(NOMA  ,NDIM  ,DEFICO,RESOCO,IZONE ,
     &              POSNOE,'NOEU',POSNOM,NUMNOM,R8BID ,
     &              R8BID ,TAU1M ,TAU2M ,TAU1  ,TAU2  )     
C
C --- CALCUL DE LA NORMALE INTERIEURE
C
        CALL MMNORM(NDIM ,TAU1  ,TAU2  ,NORM  ,NOOR)
        IF (NOOR.LE.R8PREM()) THEN
          CALL U2MESK('F','CONTACT3_26',1,NOMNOE)
        ENDIF                        
C
C --- CALCUL DU JEU 
C
        CALL CFNEWJ(NDIM ,COORDE,COORDM,NORM  ,JEU)       
C
C --- COEFFICIENT DE LA RELATION LINEAIRE SUR NOEUD MAITRE
C       
        COEFNO(1) = - 1.D0
        NBNOM     = 1             
C
C --- PARAMETRES DE L'APPARIEMENT 
C     
        POSAPP = -POSNOM
        TYPAPP = 1
C
C --- AJOUT DE LA LIAISON NODALE
C
        CALL CFADDM(RESOCO,NTNOE ,LCTFD ,LCTF3D,POSNOE,
     &              ILIAI ,NDIM  ,NBDDLE,NBNOM ,POSNOM,
     &              COEFNO,TAU1  ,TAU2  ,NORM  ,JEU   )
C
   65   CONTINUE
C
C --- STOCKAGE PARAMETRES DE L'APPARIEMENT 
C    
        CALL CFPARM(NOMA  ,DEFICO,RESOCO,ILIAI ,TYPAPP,
     &              POSNOE,POSNOM,POSAPP)
C
C --- LIAISON SUIVANTE
C     
        IF (TYPAPP.EQ.1) THEN
          ILIAI  = ILIAI + 1                   
          NZLIAI = NZLIAI + 1          
        ENDIF 
   50 CONTINUE      
C
      CALL JEDEMA()

      END

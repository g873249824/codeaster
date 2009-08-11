      SUBROUTINE CFMXME(NOMA  ,FONACT,NUMEDD,SDDYNA,DEFICO,
     &                  RESOCO)
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/08/2009   AUTEUR DESOZA T.DESOZA 
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
      IMPLICIT NONE
      CHARACTER*24 DEFICO,RESOCO
      CHARACTER*8  NOMA
      LOGICAL      FONACT(*)
      CHARACTER*24 NUMEDD
      CHARACTER*19 SDDYNA
C      
C ----------------------------------------------------------------------
C
C ROUTINE CONTACT (TOUTES METHODES - SD)
C
C CREATION SD DE RESOLUTION
C      
C ----------------------------------------------------------------------
C     
C
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  NUMEDD : NUME_DDL DE LA MATRICE TANGENTE GLOBALE
C IN  SDDYNA : SD DYNAMIQUE
C IN  NOMA   : NOM DU MAILLAGE
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
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
      INTEGER      CFMMVD
      INTEGER      ZDIAG
      PARAMETER    (ZDIAG=10)
      INTEGER      IFM,NIV
      CHARACTER*8  K8BID
      INTEGER      IRET,NEQ,NTPC
      CHARACTER*24 VECNOD,VECNOX,VECNOY,VECNOZ
      INTEGER      JVECNO,JVECNX,JVECNY,JVECNZ
      CHARACTER*24 MBOUCL,MELEME,MDECOL,CLREAC,CIREAC,CRNUDD
      INTEGER      JMBOUC,JMELEM,JMDECO,JCLREA,JCIREA,JCRNUD
      LOGICAL      LCTCD,LCTCC,LXFCM,LCONT,ISFONC
      LOGICAL      NDYNLO,LDYNA
      CHARACTER*24 AUTOC1,AUTOC2
      CHARACTER*24 VITINI,ACCINI
      CHARACTER*24 ECPDON,TFOR
      INTEGER      JECPD ,JTFOR
      CHARACTER*24 JEUCON,ETATCT
      INTEGER             JETAT
      INTEGER             ZETAT
      CHARACTER*24 DIAGI,DIAGT,MAXDEP
      INTEGER      JDIAGI,JDIAGT,JMAXDE  
      CHARACTER*24 CTPREM
      INTEGER      JPREM    
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('CONTACT',IFM,NIV) 
C
C --- INITIALISATIONS
C
      CALL DISMOI('F','NB_EQUA',NUMEDD,'NUME_DDL',NEQ,K8BID,IRET)
C
C --- FONCTIONNALITES ACTIVEES
C
      LCTCC  = ISFONC(FONACT,'CONT_CONTINU')
      LCTCD  = ISFONC(FONACT,'CONT_DISCRET') 
      LXFCM  = ISFONC(FONACT,'CONT_XFEM')
      LCONT  = ISFONC(FONACT,'CONTACT')
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')        
      IF (.NOT.LCONT) THEN
        GOTO 999
      ENDIF       
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<CONTACT> CREATION SD DE RESOLUTION' 
      ENDIF 
C
C --- CONTACT DISCRET
C    
      IF (LCTCD) THEN
C 
C --- PARAMETRES DE REACTUALISATION GEOMETRIQUE
C CIREAC(1) = NOMBRE DE REACTUALISATION GEOMETRIQUE A EFFECTUER
C                     / -1 SI AUTOMATIQUE
C                     /  0 SI PAS DE REACTUALISATION
C                     /  N REACTUALISATIONS
C CIREAC(2) = NOMBRE DE REACTUALISATIONS GEOMETRIQUES EFFECTUEES
C CLREAC(1) = TRUE  SI REACTUALISATION A FAIRE
C CLREAC(2) = TRUE  SI ATTENTE POINT FIXE CONTACT
C        
        AUTOC1 = RESOCO(1:14)//'.REA1'
        AUTOC2 = RESOCO(1:14)//'.REA2'
        CALL VTCREB(AUTOC1,NUMEDD,'V','R',NEQ)
        CALL VTCREB(AUTOC2,NUMEDD,'V','R',NEQ)      
        CLREAC = RESOCO(1:14)//'.REAL'
        CALL WKVECT(CLREAC,'V V L',4,JCLREA)
        ZL(JCLREA+1-1) = .FALSE.
        ZL(JCLREA+2-1) = .FALSE.
        ZL(JCLREA+4-1) = .FALSE.
        CIREAC = RESOCO(1:14)//'.REAI'
        CALL WKVECT(CIREAC,'V V I',2,JCIREA)    
        MAXDEP = RESOCO(1:14)//'.MAXD'  
        CALL WKVECT(MAXDEP,'V V R',1,JMAXDE) 
        ZR(JMAXDE) = -1.D0 
C
C --- ARGUMENT POUR PREMIERE UTILISATION DU CONTACT OU NON
C
        CTPREM = RESOCO(1:14)//'.PREM'
        CALL WKVECT(CTPREM,'V V L',1,JPREM)
        ZL(JPREM) = .TRUE.            
      ENDIF          
C
C --- CONTACT CONTINU
C 
      IF (LCTCC) THEN
C
C --- CREATION DES STRUCTURES DE DONNEES POUR LA
C --- GESTION AUTOMATIQUE DES RELATIONS REDONDANTES
C       
        VECNOD = RESOCO(1:14)//'.VECNOD'
        VECNOX = RESOCO(1:14)//'.VECNOX'
        VECNOY = RESOCO(1:14)//'.VECNOY'
        VECNOZ = RESOCO(1:14)//'.VECNOZ'       
        CALL WKVECT(VECNOD,'V V I',2*NEQ,JVECNO)
        CALL WKVECT(VECNOX,'V V I',  NEQ,JVECNX)
        CALL WKVECT(VECNOY,'V V I',  NEQ,JVECNY)
        CALL WKVECT(VECNOZ,'V V I',  NEQ,JVECNZ)      
C
C --- CREATION DES CARTES D'USURE
C
        CALL MMUSUC(NOMA  ,DEFICO,RESOCO)              
C
C --- CREATION NOMS DES MATR_ELEM ET VECT_ELEM CONTACT
C
        MELEME = RESOCO(1:14)//'.MELEM'
        CALL WKVECT(MELEME,'V V K8',2,JMELEM)  
        ZK8(JMELEM+1-1) = '&&CFMMEL'
        ZK8(JMELEM+2-1) = '&&CFMVEL'              
C
C --- CREATION INDICATEUR DE DECOLLEMENT DANS COMPLIANCE
C
        MDECOL = RESOCO(1:14)//'.MDECOL'
        CALL WKVECT(MDECOL,'V V L',1,JMDECO)  
        ZL(JMDECO+1-1) = .FALSE. 
C
C --- VECTEUR POUR LA DYNAMIQUE A L INSTANT MOINS
C --- UTILE UNIQUEMENT AFIN D ARCHIVER LE DERNIER INSTANT CALCULE
C --- SI PLANTE POUR LE NOUVEAU PAS DE TEMPS DANS
C --- LES ITERATIONS DE NEWTON
C
        VITINI = RESOCO(1:14)//'.VITI'
        ACCINI = RESOCO(1:14)//'.ACCI'
        CALL VTCREB(VITINI,NUMEDD,'V','R',NEQ)
        CALL VTCREB(ACCINI,NUMEDD,'V','R',NEQ)      
C
C --- FORMULATION DU CONTACT (DEPLACEMENT/VITESSE)
C      
        IF (LDYNA) THEN 
          TFOR = SDDYNA(1:15)//'.TYPE_FOR'      
          CALL JEVEUO(TFOR,'E',JTFOR) 
          ECPDON = DEFICO(1:16)//'.ECPDON'
          CALL JEVEUO(ECPDON,'L',JECPD)
          ZI(JTFOR+2-1) = ZI(JECPD+6)
        ENDIF   
C
C --- LOGICAL POUR DECIDER DE REFAIRE LE NUME_DDL OU NON
C
        CRNUDD = RESOCO(1:14)//'.NUDD'   
        CALL WKVECT(CRNUDD,'V V L',1,JCRNUD)  
        ZL(JCRNUD) = .TRUE.
C
C --- OBJET DE SAUVEGARDE DE L ETAT DE CONTACT
C
        IF (.NOT.LXFCM) THEN
          JEUCON = DEFICO(1:16)//'.JEUCON'
          CALL JELIRA(JEUCON,'LONMAX',NTPC,K8BID)
          ZETAT  = CFMMVD('ZETAT')
          ETATCT = RESOCO(1:14)//'.ETATCT'
          CALL WKVECT(ETATCT,'V V R',ZETAT*NTPC,JETAT)
        ENDIF
      ENDIF   
C
C --- VECTEURS DE DIAGNOSTIC
C
      DIAGI  = RESOCO(1:14)//'.DIAG.ITER'
      CALL WKVECT(DIAGI,'V V I',ZDIAG,JDIAGI)
      DIAGT  = RESOCO(1:14)//'.DIAG.TIME'
      CALL WKVECT(DIAGT,'V V R',ZDIAG,JDIAGT)
C
C --- CREATION DES COMPTEURS DE BOUCLE
C
      MBOUCL = RESOCO(1:14)//'.MBOUCL'
      CALL WKVECT(MBOUCL,'V V I',3,JMBOUC)         
C
 999  CONTINUE                 
C
      CALL JEDEMA()      
      END

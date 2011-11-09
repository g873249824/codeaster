      SUBROUTINE CFINIT(MAILLA,FONACT,DEFICO,RESOCO,NUMINS,
     &                  SDDYNA,SDDISC,VALINC)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 09/11/2011   AUTEUR MACOCCO K.MACOCCO 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*8  MAILLA
      CHARACTER*24 DEFICO,RESOCO
      INTEGER      NUMINS
      INTEGER      FONACT(*)
      CHARACTER*19 VALINC(*)
      CHARACTER*19 SDDYNA
      CHARACTER*19 SDDISC
C      
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATION CONTACT)
C
C INITIALISATION DES PARAMETRES DE CONTACT POUR LE NOUVEAU PAS DE
C TEMPS
C
C ----------------------------------------------------------------------
C
C
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  DEFICO : SD DEFINITION DU CONTACT
C IN  RESOCO : SD RESOLUTION DU CONTACT
C IN  SDDYNA : SD DYNAMIQUE 
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  NUMINS : NUMERO INSTANT COURANT
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
      INTEGER      NTPC,IPC,INCRUN
      LOGICAL      LREAC(3)
      CHARACTER*24 CLREAC
      INTEGER      JCLREA
      INTEGER      CFMMVD,CFDISI
      CHARACTER*24 AUTOC1,AUTOC2 
      CHARACTER*24 TABFIN,ETATCT
      INTEGER      JTABF ,JETAT
      INTEGER      ZTABF ,ZETAT      
      LOGICAL      ISFONC,NDYNLO,LDYNA
      LOGICAL      CFDISL,LELTC,LCTCD,LTFCM,LCTCC,LXFCM
      CHARACTER*19 DEPMOI,VITPLU,ACCPLU,XSEUCO,XSEUCP
      CHARACTER*19 XINDCO,XMEMCO,XINDCP,XMEMCP      
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ() 
C
C --- INITIALISATIONS
C
      INCRUN = 0
C 
C --- FONCTIONNALITES ACTIVEES
C     
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
      LCTCD  = ISFONC(FONACT,'CONT_DISCRET')
      LCTCC  = ISFONC(FONACT,'CONT_CONTINU')      
      LELTC  = ISFONC(FONACT,'ELT_CONTACT')
      LTFCM  = CFDISL(DEFICO,'CONT_XFEM_GG') 
      LXFCM  = ISFONC(FONACT,'CONT_XFEM')    
C
C --- DECOMPACTION VARIABLES CHAPEAUX
C       
      CALL NMCHEX(VALINC,'VALINC','DEPMOI',DEPMOI)
      CALL NMCHEX(VALINC,'VALINC','VITPLU',VITPLU)
      CALL NMCHEX(VALINC,'VALINC','ACCPLU',ACCPLU)    
C      
      IF (LCTCD) THEN 
C
C ----- ACCES OBJETS
C          
        AUTOC1 = RESOCO(1:14)//'.REA1'
        AUTOC2 = RESOCO(1:14)//'.REA2'
        CLREAC = RESOCO(1:14)//'.REAL'             
        CALL JEVEUO(CLREAC,'E',JCLREA)     
C 
C ----- PARAMETRES DE REACTUALISATION GEOMETRIQUE
C  
        LREAC(1) = .TRUE.
        LREAC(2) = .FALSE.
        LREAC(3) = .TRUE.
        IF (CFDISL(DEFICO,'REAC_GEOM_SANS')) THEN
          IF (NUMINS.NE.1) THEN
            LREAC(1) = .FALSE.
            LREAC(3) = .FALSE.
          ENDIF
        ENDIF        
C 
C ----- INITIALISATION DES VECTEURS POUR REAC_GEOM
C       
        CALL VTZERO(AUTOC1)
        CALL VTZERO(AUTOC2)
C
C ----- SAUVEGARDE
C        
        ZL(JCLREA-1+1) = LREAC(1)
        ZL(JCLREA-1+2) = LREAC(2)
        ZL(JCLREA-1+3) = LREAC(3)
      ENDIF 
C          
      IF (LELTC) THEN
C
C ----- MISE A ZERO LAGRANGIENS POUR CONTACT CONTINU (LAMBDA TOTAUX)
C 
        IF (LTFCM) THEN
          CALL XMISZL(DEPMOI,DEFICO,MAILLA)
        ELSEIF (LCTCC) THEN
          CALL MISAZL(DEPMOI,DEFICO)  
          IF (LDYNA) THEN
            CALL MISAZL(ACCPLU,DEFICO)
            CALL MISAZL(VITPLU,DEFICO)
          ENDIF
        ENDIF
C
C ----- MISE A ZERO L'ETAT DU PREMIER INSTANT (EN CAS DE REDECOUPAGE)
C
        IF (NUMINS.EQ.1) THEN
          CALL DIBCLE(SDDISC,'PREMIE','E',INCRUN)
        ENDIF
C
C ----- RETABLISSEMENT DE L ETAT DE CONTACT DU DERNIER PAS CONVERGE
C ----- POUR PERMETTRE LE REDECOUPAGE (CF. MMMRES)
C
        IF (.NOT.LXFCM) THEN
          TABFIN = RESOCO(1:14)//'.TABFIN'
          ETATCT = RESOCO(1:14)//'.ETATCT'
          CALL JEVEUO(TABFIN,'E',JTABF)
          ZTABF  = CFMMVD('ZTABF')
          CALL JEVEUO(ETATCT,'L',JETAT)
          ZETAT  = CFMMVD('ZETAT')
          NTPC   = CFDISI(DEFICO,'NTPC'     )
          DO 100 IPC = 1,NTPC
            ZR(JTABF+ZTABF*(IPC-1)+22) = ZR(JETAT-1+ZETAT*(IPC-1)+1)
            ZR(JTABF+ZTABF*(IPC-1)+16) = ZR(JETAT-1+ZETAT*(IPC-1)+2)
            ZR(JTABF+ZTABF*(IPC-1)+23) = ZR(JETAT-1+ZETAT*(IPC-1)+3)
            ZR(JTABF+ZTABF*(IPC-1)+17) = ZR(JETAT-1+ZETAT*(IPC-1)+4)
  100     CONTINUE
         ELSE
           XINDCO = RESOCO(1:14)//'.XFIN'
           XMEMCO = RESOCO(1:14)//'.XMEM'    
           XINDCP = RESOCO(1:14)//'.XFIP'
           XMEMCP = RESOCO(1:14)//'.XMEP'
           XSEUCO = RESOCO(1:14)//'.XFSE'
           XSEUCP = RESOCO(1:14)//'.XFSP'           
           CALL COPISD('CHAMP_GD','V',XINDCP,XINDCO) 
           CALL COPISD('CHAMP_GD','V',XMEMCP,XMEMCO)
           CALL COPISD('CHAMP_GD','V',XSEUCP,XSEUCO)
         ENDIF
      ENDIF
                         
C 
      CALL JEDEMA()

      END

      SUBROUTINE NDLECT(MODELE,MATE  ,LISCHA,SDDYNA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/09/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT NONE   
      CHARACTER*19 SDDYNA
      CHARACTER*24 MODELE,MATE
      CHARACTER*19 LISCHA      
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (INITIALISATION)
C
C LECTURE DES OPERANDES DYNAMIQUES ET REMPLISSAGE DE SDDYNA
C      
C ----------------------------------------------------------------------
C
C
C IN  MODELE : NOM DU MODELE
C IN  MATE   : NOM DU CHAMP DE MATERIAU
C IN  LISCHA : SD L_CHARGES
C IN  SDDYNA : SD DYNAMIQUE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      REAL*8        UNDEMI,UN,QUATRE
      PARAMETER     (UNDEMI = 0.5D0,UN   = 1.D0)
      PARAMETER     (QUATRE = 4.D0 )
C      
      INTEGER       NBMODE,NMODAM,NREAVI,NONDP
      INTEGER       IRET,IBID,IRET2,I
      INTEGER       JCHAR,JINF
      INTEGER       N1,N2,NCHAR,NBMG,NRV,NBEXCI
      CHARACTER*24  TSCH ,PSCH ,LOSD ,NOSD ,TFOR ,MUAP    
      INTEGER       JTSCH,JPSCH,JLOSD,JNOSD,JTFOR,JMUAP
      CHARACTER*24  TCHA ,NCHA ,VEOL ,VAOL
      INTEGER       JTCHA,JNCHA,JVEOL,JVAOL       
      CHARACTER*8   K8BID, LICMP(3),REP,NOMCHA
      CHARACTER*8   REP1,REP2,REP3,REP4
      CHARACTER*24  CHARGE,INFOCH   
      CHARACTER*16  SCHEMA,KFORM,K16BID,NOMCMD
      CHARACTER*24  TEXTE,STADYN,SDAMMO
      CHARACTER*24  CHGRFL,CHONDP
      INTEGER       IFORM
      INTEGER       IFM,NIV
      REAL*8        ALPHA ,BETA  ,GAMMA ,THETA ,PHI     
      REAL*8        RCMP(3)
      COMPLEX*16    C16BID
      LOGICAL       NDYNLO,LMUAP,LAMMO
      LOGICAL       LAMOR,LONDE ,LIMPED,LDYNA,LEXPL
      CHARACTER*24  VECENT     
      INTEGER       JVECEN      
C      
      CHARACTER*19  VEFSDO,VEFINT,VEDIDO,VESSTF
      CHARACTER*19  VEFEDO,VEONDP,VEDIDI,VELAPL
C       
      CHARACTER*19  CNFEDO,CNFSDO,CNDIDI,CNFINT
      CHARACTER*19  CNDIDO,CNCINE
      CHARACTER*19  CNONDP,CNLAPL 
      CHARACTER*19  CNSSTF,CNGRFL 
C      
      CHARACTER*24  DEPENT,VITENT,ACCENT    
      
C
      DATA CNFEDO,CNFSDO    /'&&NDLECT.CNFEDO','&&NDLECT.CNFSDO'/ 
      DATA CNDIDO,CNDIDI    /'&&NDLECT.CNDIDO','&&NDLECT.CNDIDI'/
      DATA CNFINT           /'&&NDLECT.CNFINT'/
      DATA CNONDP,CNLAPL    /'&&NDLECT.CNONDP','&&NDLECT.CNLAPL'/
      DATA CNCINE,CNSSTF    /'&&NDLECT.CNCINE','&&NDLECT.CNSSTF'/  
      DATA CNGRFL           /'&&NDLECT.CNGRFL'/  
C
      DATA VEFEDO,VEFSDO    /'&&NDLECT.VEFEDO','&&NDLECT.VEFSDO'/ 
      DATA VEDIDO,VEDIDI    /'&&NDLECT.VEDIDO','&&NDLECT.VEDIDI'/
      DATA VEFINT           /'&&NDLECT.VEFINT'/
      DATA VEONDP,VELAPL    /'&&NDLECT.VEONDP','&&NDLECT.VELAPL'/
      DATA VESSTF           /'&&NDLECT.VESSTF'/
C
      DATA DEPENT  /'&&OP0070.DEPENT'/      
      DATA VITENT  /'&&OP0070.VITENT'/      
      DATA ACCENT  /'&&OP0070.ACCENT'/               
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)             
C
C --- OPERATEUR APPELANT (STATIQUE OU DYNAMIQUE)
C      
      CALL GETRES(K8BID ,K16BID,NOMCMD)
C
C --- LECTURE DONNEES DYNAMIQUE
C      
      LDYNA   = NDYNLO(SDDYNA,'DYNAMIQUE')
      IF (LDYNA) THEN      
        IF (NIV.GE.2) THEN
          WRITE (IFM,*) '<MECANONLINE> ... REMPLISSAGE SD DYNAMIQUE' 
        ENDIF
      ELSE
        GOTO 999  
      ENDIF
C
C --- INITIALISATIONS
C           
      CHARGE = LISCHA(1:19)//'.LCHA'
      INFOCH = LISCHA(1:19)//'.INFC'             
C
C --- ACCES AUX OBJETS DE LA SD SDDYNA
C
      TSCH = SDDYNA(1:15)//'.TYPE_SCH'
      TFOR = SDDYNA(1:15)//'.TYPE_FOR'
      PSCH = SDDYNA(1:15)//'.PARA_SCH'
      LOSD = SDDYNA(1:15)//'.INFO_SD'
      NOSD = SDDYNA(1:15)//'.NOM_SD'
      TCHA = SDDYNA(1:15)//'.TYPE_CHA'
      NCHA = SDDYNA(1:15)//'.NBRE_CHA'  
      VEOL = SDDYNA(1:15)//'.VEEL_OLD'  
      VAOL = SDDYNA(1:15)//'.VEAS_OLD'            
      MUAP = SDDYNA(1:15)//'.MULT_APP' 
      CALL JEVEUO(TSCH,'E',JTSCH)        
      CALL JEVEUO(TFOR,'E',JTFOR) 
      CALL JEVEUO(PSCH,'E',JPSCH)
      CALL JEVEUO(LOSD,'E',JLOSD)
      CALL JEVEUO(NOSD,'E',JNOSD) 
      CALL JEVEUO(TCHA,'E',JTCHA)
      CALL JEVEUO(NCHA,'E',JNCHA)  
      CALL JEVEUO(VEOL,'E',JVEOL)
      CALL JEVEUO(VAOL,'E',JVAOL)         
      CALL JEVEUO(MUAP,'E',JMUAP)               
C
C --- EXISTENCE D'AMORTISSEMENT RAYLEIGH
C
      LAMOR = .FALSE.
      CALL DISMOI('F','EXI_AMOR_ALPHA',MATE,'CHAM_MATER',IBID,REP1,IBID)
      CALL DISMOI('F','EXI_AMOR_BETA' ,MATE,'CHAM_MATER',IBID,REP2,IBID)
      CALL DISMOI('F','EXI_AMOR_NOR'  ,MATE,'CHAM_MATER',IBID,REP3,IBID)
      CALL DISMOI('F','EXI_AMOR_TAN'  ,MATE,'CHAM_MATER',IBID,REP4,IBID)
      IF ((REP1(1:3).EQ.'OUI').OR.
     &    (REP2(1:3).EQ.'OUI').OR.
     &    (REP3(1:3).EQ.'OUI').OR.
     &    (REP4(1:3).EQ.'OUI')) THEN  
        LAMOR = .TRUE.
      ENDIF
C  
      IF ((REP1(1:3).EQ.'OUI').OR.
     &    (REP2(1:3).EQ.'OUI')) THEN
        CALL U2MESS('I','MECANONLINE5_7')       
      ENDIF
      ZL(JLOSD+1-1) = LAMOR               
C
C --- PARAMETRES DU SCHEMA TEMPS
C
      CALL GETVTX('SCHEMA_TEMPS','SCHEMA',1,1,1,SCHEMA,IRET)
C      
      IF (SCHEMA(1:9).EQ.'DIFF_CENT')THEN
        BETA   = 0.D0
        GAMMA  = 0.5D0
        PHI    = 0.5D0
        ZK16(JTSCH+7-1) = 'DIFF_CENTREE'
      ELSEIF (SCHEMA(1:7).EQ.'TCHAMWA')THEN
        BETA   = 0.D0
        GAMMA  = 0.5D0
        CALL GETVR8('SCHEMA_TEMPS','PHI',1,1,1,PHI,N1)
        ZK16(JTSCH+8-1) = 'TCHAMWA'
      ELSEIF (SCHEMA(1:7).EQ.'NEWMARK')THEN
        CALL GETVR8('SCHEMA_TEMPS','BETA',1,1,1,BETA,N1)
        CALL GETVR8('SCHEMA_TEMPS','GAMMA',1,1,1,GAMMA,N1)
        PHI    = 0.5D0
        ZK16(JTSCH+2-1) = 'NEWMARK'
      ELSEIF (SCHEMA(1:13).EQ.'THETA_METHODE')THEN
        CALL GETVR8('SCHEMA_TEMPS','THETA',1,1,1,THETA,N2)
        ZK16(JTSCH+4-1) = 'THETA_METHODE'
        PHI    = 0.5D0
      ELSEIF (SCHEMA(1:3).EQ.'HHT')THEN
        CALL GETVR8('SCHEMA_TEMPS','ALPHA',1,1,1,ALPHA,N1)
        CALL GETVTX('SCHEMA_TEMPS','MODI_EQUI',1,1,1,REP,N1)
        IF ( REP(1:3) .EQ. 'NON' ) THEN 
           ZK16(JTSCH+3-1) = 'HHT'
        ELSE
           ZK16(JTSCH+5-1) = 'HHT_COMPLET'
        ENDIF
        PHI   = UNDEMI
        BETA  = (UN-ALPHA)* (UN-ALPHA)/QUATRE
        GAMMA = UNDEMI - ALPHA
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      ZR(JPSCH+1-1) = BETA
      ZR(JPSCH+2-1) = GAMMA
      ZR(JPSCH+3-1) = PHI
      ZR(JPSCH+4-1) = THETA         
C
C --- TYPE DE SCHEMA
C
      LEXPL =  NDYNLO(SDDYNA,'EXPLICITE')           
C
C --- TYPE DE FORMULATION
C
      CALL GETVTX('SCHEMA_TEMPS','FORMULATION',1,1,1,KFORM,N1)
      IF (KFORM(1:11).EQ.'DEPLACEMENT')THEN
        IFORM  = 1
      ELSEIF (KFORM(1:7).EQ.'VITESSE')THEN
        IFORM  = 2
      ELSEIF (KFORM(1:12).EQ.'ACCELERATION')THEN
        IFORM  = 3
      ENDIF
      ZI(JTFOR+1-1) = IFORM   
C
C --- INCOMPATIBILITES SCHEMA/FORMULATION/PARAMETRES
C      
      IF ((NDYNLO(SDDYNA,'NEWMARK')).OR.
     &    (NDYNLO(SDDYNA,'HHT_COMPLET')).OR.
     &    (NDYNLO(SDDYNA,'HHT'))) THEN
        IF (BETA.EQ.0.D0) THEN
          CALL U2MESS('F','MECANONLINE5_9')
        ENDIF         
        IF (IFORM.EQ.2) THEN
          CALL U2MESS('F','MECANONLINE5_11')
        ENDIF         
      ENDIF 
      IF (NDYNLO(SDDYNA,'THETA_METHODE')) THEN       
        IF (IFORM.EQ.3) THEN
          CALL U2MESS('F','MECANONLINE5_12')
        ENDIF         
      ENDIF                 
      IF (LEXPL) THEN
        IF (IFORM.NE.3) THEN
          CALL U2MESS('F','MECANONLINE5_10')
        ENDIF  
      ENDIF
C
C --- VECTEURS DE DEPL/VITE/ACCE D'ENTRAINEMENT
C --- MULTI-APPUI OU IMPE_ABSO OU DIS_CHOC
C
      VECENT = SDDYNA(1:15)//'.VECENT'
      CALL WKVECT(VECENT,'V V K24',3,JVECEN)
      ZK24(JVECEN+1-1) = DEPENT
      ZK24(JVECEN+2-1) = VITENT
      ZK24(JVECEN+3-1) = ACCENT 
C
C --- MASSE DIAGONALE POUR SCHEMAS EXPLICITES
C
      ZL(JLOSD+4-1) = .FALSE.
      IF (LEXPL) THEN
        CALL GETVTX(' ','MASS_DIAG',1,1,1,TEXTE,N1)
        IF (TEXTE(1:3).EQ.'OUI') THEN
          ZL(JLOSD+4-1) = .TRUE.
        ENDIF  
      ENDIF 
C
C --- PROJECTION MODALE POUR SCHEMAS EXPLICITES
C      
      ZL(JLOSD+5-1) = .FALSE.
      ZL(JLOSD+9-1) = .FALSE.
      IF (LEXPL)THEN
        CALL GETFAC('PROJ_MODAL',IRET)
        IF (IRET.GT.0)THEN
          ZL(JLOSD+5-1)   = .TRUE.
          ZK24(JNOSD+3-1) = SDDYNA(1:15)//'.PRM'
          CALL MXMOAM(SDDYNA)
          CALL GETVID('PROJ_MODAL','MASS_GENE',1,1,1,K8BID,NBMG)
          ZL(JLOSD+9-1)   = NBMG.NE.0          
        ENDIF  
      ENDIF          
C
C --- SCHEMA MULTIPAS: VECT_* SAUVEGARDES PAS PRECEDENT
C
      IF ((ZK16(JTSCH+5-1)(1:11).EQ.'HHT_COMPLET').OR.
     &      ( ZK16(JTSCH+4-1)(1:13).EQ.'THETA_METHODE')) THEN
        ZK24(JVEOL+1-1)  = VEFEDO
        ZK24(JVEOL+2-1)  = VEFSDO     
        ZK24(JVEOL+3-1)  = VEDIDO
        ZK24(JVEOL+4-1)  = VEDIDI 
        ZK24(JVEOL+5-1)  = VEFINT
        ZK24(JVEOL+6-1)  = VEONDP     
        ZK24(JVEOL+7-1)  = VELAPL
        ZK24(JVEOL+8-1)  = VESSTF   
        ZK24(JVAOL+1-1)  = CNFEDO
        ZK24(JVAOL+2-1)  = CNFSDO     
        ZK24(JVAOL+3-1)  = CNDIDO
        ZK24(JVAOL+4-1)  = CNDIDI 
        ZK24(JVAOL+5-1)  = CNFINT
        ZK24(JVAOL+6-1)  = CNONDP     
        ZK24(JVAOL+7-1)  = CNLAPL
        ZK24(JVAOL+8-1)  = CNSSTF 
        ZK24(JVAOL+9-1)  = CNCINE 
        ZK24(JVAOL+10-1) = CNGRFL      
      ENDIF        
C
C --- CARTE STADYN POUR POUTRES
C       
      STADYN = '&&OP0070.STA_DYN'
      ZK24(JNOSD+4-1) = STADYN
      LICMP(1) = 'STAOUDYN'
      LICMP(2) = 'ALFNMK'
      LICMP(3) = 'DELNMK'
      RCMP(1)  = UN
      RCMP(2)  = BETA
      RCMP(3)  = GAMMA
      CALL JEDETR(STADYN)
      CALL MECACT('V',STADYN,'MODELE',MODELE(1:8)//'.MODELE',
     &            'STAOUDYN',3,LICMP,IBID,RCMP,C16BID,K8BID)
C
C --- MODE MULTI-APPUI
C
      CALL GETVID(' ','MODE_STAT',1,1,1,K8BID,NBMODE)   
      LMUAP = NBMODE.GT.0    
      IF (LMUAP) THEN
        CALL NMMUAP(SDDYNA)
      END IF
      ZL(JLOSD+2-1)   = LMUAP       
C
C --- AMORTISSEMENT MODAL
C
      CALL GETFAC('AMOR_MODAL',NMODAM)
      LAMMO = NMODAM.GT.0
      IF (LAMMO) THEN
        SDAMMO          = SDDYNA(1:15)//'.AMO'      
        CALL NMMOAM(SDAMMO)
        NREAVI          = 0
C        
C --- REACTUALISATION DE L'AMORT A CHAQUE ITERATION ?
C
        CALL GETVTX('AMOR_MODAL','REAC_VITE',1,1,1,K8BID,NRV)
        IF (K8BID.EQ.'OUI') NREAVI = 1        
      ELSE
        SDAMMO          = ' '
        NREAVI          = 0
      END IF
      ZL(JLOSD+3-1)   = LAMMO
      ZL(JLOSD+12-1)  = NREAVI.GT.0
      ZK24(JNOSD+2-1) = SDAMMO      
C
C --- VERIFICATION DE LA PRESENCE D'ELEMENTS AVEC 'IMPE_ABSO'
C
      CALL NMIMPE(MODELE,LIMPED)
      ZL(JLOSD+6-1)   = LIMPED   
C
C --- NOMBRE DE CHARGEMENTS
C      
      CALL GETFAC('EXCIT',NBEXCI)
      ZI(JNCHA+2-1)   = NBEXCI
C
C --- TEST DE LA PRESENCE DE CHARGES DE TYPE 'ONDE_PLANE'
C
      CALL NMONDP(LISCHA,LONDE,CHONDP,NONDP)
      ZL(JLOSD+7-1)   = LONDE
      ZI(JNCHA+2-1)   = NONDP
      ZK24(JTCHA+1-1) = CHONDP
C
C --- TEST DE LA PRESENCE DE CHARGES DE TYPE 'FORCE_FLUIDE'
C
      CHGRFL = '&&OP0070.GRAPPE_FLUIDE  '
      ZL(JLOSD+8-1)   = .FALSE.
      CALL JEEXIN(CHARGE,IRET  )
      IF ( IRET .NE. 0 ) THEN
        CALL JEVEUO ( INFOCH, 'L', JINF  )
        CALL JEVEUO ( CHARGE, 'L', JCHAR )
        NCHAR = ZI(JINF)
        DO 10 I = 1, NCHAR
          NOMCHA = ZK24(JCHAR+I-1)(1:8)
          CALL JEEXIN ( NOMCHA//'.CHME.GRFLU.LINO', IRET2 )
          IF ( IRET2 .NE. 0 ) THEN
            CALL GFLECT(NOMCHA,CHGRFL)
            ZL(JLOSD+8-1)   = .TRUE.
          ENDIF
  10    CONTINUE
      ENDIF
      ZK24(JTCHA+2-1) = CHGRFL    
C       
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE> ... '//
     &                'FONCTIONNALITES ACTIVEES EN DYNAMIQUE '
     
        IF (NDYNLO(SDDYNA,'IMPLICITE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... SCHEMA IMPLICITE'
        ENDIF
        IF (NDYNLO(SDDYNA,'EXPLICITE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... SCHEMA EXPLICITE'
        ENDIF     
     
        IF (NDYNLO(SDDYNA,'MAT_AMORT')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... MATRICE AMORTISSEMENT'
        ENDIF
        IF (NDYNLO(SDDYNA,'MULTI_APPUI')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... MULTI APPUI'
        ENDIF  
        IF (NDYNLO(SDDYNA,'AMOR_MODAL')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... AMORTISSEMENT MODAL'
        ENDIF      
        IF (NDYNLO(SDDYNA,'MASS_DIAG')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... MATRICE MASSE DIAGONALE'
        ENDIF 
        IF (NDYNLO(SDDYNA,'PROJ_MODAL')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... PROJECTION MODALE'
        ENDIF         
        IF (NDYNLO(SDDYNA,'IMPE_ABSO')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... ELEMENTS D''IMPEDANCE'
        ENDIF         
        IF (NDYNLO(SDDYNA,'ONDE_PLANE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CHARGEMENT ONDES PLANES'
        ENDIF         
        IF (NDYNLO(SDDYNA,'FORCE_FLUIDE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CHARGEMENT GRAPPE FLUIDE'
        ENDIF 
        IF (NDYNLO(SDDYNA,'EXPL_GENE')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... CALCUL EXPLICITE EN MODAL'
        ENDIF         
        IF (NDYNLO(SDDYNA,'NREAVI')) THEN
          WRITE (IFM,*) '<MECANONLINE> ...... REAC. VITE'
        ENDIF                 
      
                                           
      ENDIF      
C
  999 CONTINUE      
C
      CALL JEDEMA()

      END

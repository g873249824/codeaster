      SUBROUTINE MERIMO(BASE  ,MODELE,CARELE,MATE  ,COMREF,
     &                  COMPOR,LISCHA,CARCRI,DEPDEL,POUGD ,
     &                  STADYN,DEPENT,VITENT,VALMOI,VALPLU,
     &                  OPTIOZ,MERIGI,RESIDU,VEDIRI,ITERAT,
     &                  TABRET)
C
C MODIF ALGORITH  DATE 03/09/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C TOLE CRP_20
C TOLE CRP_21
      IMPLICIT NONE
      INTEGER       ITERAT
      LOGICAL       TABRET(0:10)
      CHARACTER*(*) MATE,OPTIOZ
      CHARACTER*1   BASE
      CHARACTER*19  LISCHA,MATN
      CHARACTER*24  MODELE,CARELE,COMPOR,COMREF
      CHARACTER*24  CARCRI,DEPDEL,STADYN,MERIGI,RESIDU
      CHARACTER*24  VEDIRI,DEPENT,VITENT
      CHARACTER*24  VALMOI,VALPLU,POUGD
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C CALCUL DES MATRICES ELEMENTAIRES DE RIGIDITE
C ET DES VECTEURS ELEMENTAIRES DES FORCES INTERNES
C      
C ----------------------------------------------------------------------
C
C
C IN  BASE    : BASE 'V' OU 'G' OU SONT CREES LES OBJETS EN SORTIE
C IN  MODELE  : NOM DU MODELE
C IN  LISCHA  : SD L_CHARGES
C IN  CARELE  : CARACTERISTIQUES DES POUTRES ET COQUES
C IN  MATE    : CHAMP DE MATERIAU CODE
C IN  COMPOR  : TYPE DE RELATION DE COMPORTEMENT
C IN  CARCRI  : CARTE DES CRITERES DE CONVERGENCE LOCAUX
C IN  DEPDEL  : CHAM_NO DE L'INCREMENT DE DEPLAC. DEPUIS T-
C IN  DDEPLA  : CHAM_NO DE L'INCREMENT DE DEPLAC. DEPUIS T-
C IN  DEPKM1  : CHAM_NO DE DEPLACEMENTS A L'ITERATION PRECEDENTE
C IN  VITKM1  : CHAM_NO DE VITESSES     A L'ITERATION PRECEDENTE
C IN  ACCKM1  : CHAM_NO D'ACCELERATIONS A L'ITERATION PRECEDENTE
C IN  VITPLU  : CHAM_NO DE VITESSES     A L'ITERATION ACTUELLE
C IN  ACCPLU  : CHAM_NO D'ACCELERATIONS A L'ITERATION ACTUELLE
C IN  ROMKM1  : VECTEURS-ROTATION ENTRE T- ET L'ITER. PRECE.
C IN  ROMK    : VECTEURS-ROTATION ENTRE T- ET L'ITER. ACTUE.
C IN  STADYN  : CARTE INDIQUANT SI STATIQUE OU EN DYNAMIQUE
C IN  OPTION  : OPTION DEMANDEE
C IN  ITERAT  : NUMERO D'ITERATION INTERNE
C IN  VALMOI  : ETAT EN T-
C IN  VALPLU  : ETAT EN T+
C IN  COMREF  : VALEURS DE REF DES VAR DE COMMANDE (TREF, ...)
C OUT MERIGI  : MATRICES ELEMENTAIRES DE RIGIDITE
C OUT RESIDU  : VECTEURS ELEMENTAIRES DES FORCES INTERIEURES
C OUT VEDIRI  : VECTEURS ELEMENTAIRES BT.LAMBDA
C OUT TABRET  : TABLEAU RESUMANT LES CODES RETOURS DU TE
C                    TABRET(0) = .TRUE. UN CODE RETOUR NON NUL EXISTE
C                    TABRET(I) = .TRUE. CODE RETOUR I RENCONTRE
C                                SINON .FALSE.
C                    I VALANT DE 1 A 10
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
      INTEGER      NBOUT,NBIN
      PARAMETER    (NBOUT=7, NBIN=50)
      CHARACTER*8  LPAOUT(NBOUT),LPAIN(NBIN)
      CHARACTER*19 LCHOUT(NBOUT),LCHIN(NBIN)
C
      INTEGER IAREFE,NBSS,JDIR,IBID
      INTEGER NCHAR,JCHAR,JINF,ICHA,JMER,JRES,IRET,IER
      INTEGER NBRES,NDIR,NBRIG,NUMDI
      REAL*8       ITER
      LOGICAL      EXIGEO,EXICAR
      COMPLEX*16   CBID
      CHARACTER*16 OPTINT
      CHARACTER*8  K8BID,NOMCHA,VECEL,MATEL,DIREL
      CHARACTER*24 CHGEOM,CHCARA(15),CHITER,CHPESA
      CHARACTER*24 DEPMOI,SIGMOI,VARMOI,COMMOI
      CHARACTER*24 DEPPLU,SIGPLU,VARPLU,COMPLU
      CHARACTER*24 INSMOI,VRCMOI
      CHARACTER*24 INSPLU,VRCPLU
      CHARACTER*24 VRCREF
      CHARACTER*24 VARMOJ,CODRET,CACO3D
      CHARACTER*24 DDEPLA,DEPKM1,VITKM1,ACCKM1
      CHARACTER*24 VITPLU,ACCPLU,ROMKM1,ROMK
      CHARACTER*24 K24BID,LIGRMO,LIGRCH
      CHARACTER*19 PINTTO,CNSETO,HEAVTO,LONCHA,BASLOC,LSN,LST
      CHARACTER*16 OPTION
      LOGICAL      DEBUG
      INTEGER      IFM,NIV,IFMDBG,NIVDBG       
C
      DATA VECEL,MATEL,DIREL/'&&RESIDU','&&MEMRIG','&&DIRICH'/
      DATA VARMOJ/'&&MERIMO.VARMOJ'/
      DATA CODRET/'&&MERIMO.CODE_RETOUR'/
      DATA CACO3D/'&&MERIMO.CARA_ROTA_FICTIF'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
      CALL INFDBG('PRE_CALCUL',IFMDBG,NIVDBG) 
C
C --- INITIALISATIONS
C       
      OPTION = OPTIOZ
      IF (NIVDBG.GE.2) THEN
        DEBUG  = .TRUE.
      ELSE
        DEBUG  = .FALSE.
      ENDIF   
C
C --- INITIALISATION DES CHAMPS POUR CALCUL
C
      CALL INICAL(NBIN  ,LPAIN ,LCHIN ,
     &            NBOUT ,LPAOUT,LCHOUT)       
C
C --- CADRE X-FEM
C
      CALL JEEXIN(MODELE(1:8)//'.FISS',IER)
      IF (IER.NE.0) THEN
        PINTTO = MODELE(1:8)//'.TOPOSE.PIN'
        CNSETO = MODELE(1:8)//'.TOPOSE.CNS'
        HEAVTO = MODELE(1:8)//'.TOPOSE.HEA'
        LONCHA = MODELE(1:8)//'.TOPOSE.LON'
        BASLOC = MODELE(1:8)//'.BASLOC'
        LSN    = MODELE(1:8)//'.LNNO'
        LST    = MODELE(1:8)//'.LTNO'
      ELSE
        PINTTO = '&&MERIMO.PINTTO.BID'
        CNSETO = '&&MERIMO.CNSETO.BID'
        HEAVTO = '&&MERIMO.HEAVTO.BID'
        LONCHA = '&&MERIMO.LONCHA.BID'
        BASLOC = '&&MERIMO.BASLOC.BID'
        LSN    = '&&MERIMO.LNNO.BID'
        LST    = '&&MERIMO.LTNO.BID'
      ENDIF

C --- LECTURE DE L'ETAT EN T- ET T+
      CALL DESAGG(VALMOI,DEPMOI,SIGMOI,VARMOI,COMMOI,K24BID,K24BID,
     &            K24BID,K24BID)
      CALL DESAGG(VALPLU,DEPPLU,SIGPLU,VARPLU,COMPLU,K24BID,K24BID,
     &            K24BID,K24BID)

C --- LECTURE DES INFOS PROPRES AUX POUTRES GRANDES DEFORMATIONS
      CALL DESAGG(POUGD,DEPKM1,VITKM1,ACCKM1,VITPLU,ACCPLU,ROMKM1,ROMK,
     &            DDEPLA)

C --- LECTURE DES VARIABLES DE COMMANDE EN T- ET T+ ET VAL. DE REF
      CALL NMVCEX('TOUT',COMMOI,VRCMOI)
      CALL NMVCEX('INST',COMMOI,INSMOI)

      CALL NMVCEX('TOUT',COMPLU,VRCPLU)
      CALL NMVCEX('INST',COMPLU,INSPLU)

      CALL NMVCEX('TOUT',COMREF,VRCREF)
C
C --- VARIABLES INTERNES ISSUES DE L'ITERATION PRECEDENTE
C     (CELLES ISSUES DU LAGRANGIEN AUGMENTE EN NON LOCAL)
C     A CAUSE DES POUTRES GD -> AUSSI POUR RIGI_MECA_TANG
C     ET DONC ON PREVOIT LE CAS OU VARPLU N'EXISTE PAS ENCORE
      CALL EXISD('CHAMP_GD',VARPLU(1:19),IRET)
      IF (IRET.NE.0) THEN
        CALL COPISD('CHAMP_GD','V',VARPLU(1:19),VARMOJ(1:19))
      ELSE
        CALL COPISD('CHAMP_GD','V',VARMOI(1:19),VARMOJ(1:19))
      END IF

      LIGRMO = MODELE(1:8)//'.MODELE'
C
C --- CREATION DU CHAM_ELEM_S POUR ETENDRE LE CHAM_ELEM DE VARI_R
C    
      CALL EXISD('CHAM_ELEM_S',COMPOR,IRET)
      IF (IRET.EQ.0) CALL CESVAR(CARELE,COMPOR,LIGRMO,COMPOR)
      CALL COPISD('CHAM_ELEM_S',BASE,COMPOR,VARPLU)
      CALL COPISD('CHAM_ELEM_S',BASE,COMPOR,SIGPLU)


      CALL JEEXIN(MERIGI,IRET)
      IF (IRET.EQ.0) THEN
        MERIGI = MATEL//'.LISTE_RESU'
        CALL MEMARE(BASE,MATEL,MODELE(1:8),MATE,CARELE,'RIGI_MECA')
C --- NECESSAIRE POUR LA PRISE EN COMPTE DE MACRO-ELEMENT STATIQUE
        CALL DISMOI('F','NB_SS_ACTI',MODELE,'MODELE',NBSS,K8BID,IBID)
        IF (NBSS.NE.0) THEN
          CALL JEVEUO(MATEL//'.REFE_RESU','E',IAREFE)
          ZK24(IAREFE-1+3) (1:3) = 'OUI'
        ENDIF
C --- FIN MACRO-ELEMENT STATIQUE
        CALL WKVECT(MERIGI,BASE//' V K24',2,JMER)
      ELSE
        CALL JEVEUO(MERIGI,'E',JMER)
      END IF
      CALL JEECRA(MERIGI,'LONUTI',0,K8BID)

      CALL JEEXIN(LISCHA//'.LCHA',IRET)
      IF (IRET.EQ.0) THEN
        NCHAR = 0
      ELSE
        CALL JELIRA(LISCHA//'.LCHA','LONMAX',NCHAR,K8BID)
      END IF
      CALL JEEXIN(RESIDU,IRET)
      IF (IRET.EQ.0) THEN
        RESIDU = VECEL//'.LISTE_RESU'
        CALL MEMARE(BASE,VECEL,MODELE(1:8),MATE,CARELE,'CHAR_MECA')
        CALL WKVECT(RESIDU,BASE//' V K24',NCHAR+1,JRES)
      ELSE
        CALL JEVEUO(RESIDU,'E',JRES)
      END IF
      CALL JEECRA(RESIDU,'LONUTI',0,K8BID)

      CALL JEEXIN(VEDIRI,IRET)
      IF (IRET.EQ.0) THEN
        VEDIRI = DIREL//'.LISTE_RESU'
        CALL MEMARE(BASE,DIREL,MODELE(1:8),MATE,CARELE,'CHAR_MECA')
        CALL WKVECT(VEDIRI,BASE//' V K24',NCHAR,JDIR)
      ELSE
        CALL JEVEUO(VEDIRI,'E',JDIR)
      END IF
      CALL JEECRA(VEDIRI,'LONUTI',0,K8BID)

      LPAOUT(1) = 'PMATUUR'
      LCHOUT(1) = MATEL//'.ME001'
      LPAOUT(2) = 'PMATUNS'
      LCHOUT(2) = MATEL//'.ME002'
      LPAOUT(3) = 'PVECTUR'
      LCHOUT(3) = VECEL//'.RE001'
      LPAOUT(4) = 'PCONTPR'
      LCHOUT(4) = SIGPLU
      LPAOUT(5) = 'PVARIPR'
      LCHOUT(5) = VARPLU
      LPAOUT(6) = 'PCODRET'
      LCHOUT(6) = CODRET
      LPAOUT(7) = 'PCACO3D'
      LCHOUT(7) = CACO3D

      CALL JEVEUO(LISCHA//'.LCHA','L',JCHAR)
      NOMCHA = ZK24(JCHAR) (1:8)
      CALL MEGEOM(MODELE,NOMCHA,EXIGEO,CHGEOM)

C --- CHAMP DE CARACTERISTIQUES ELEMENTAIRES
      CALL MECARA(CARELE(1:8),EXICAR,CHCARA)

C --- NUMERO DE L'ITERATION
      CHITER = '&&MERIMO.CH_ITERAT'
      ITER = ITERAT
      CALL MECACT('V',CHITER,'MODELE',MODELE(1:8)//'.MODELE','NEUT_R',1,
     &            'X1',IBID,ITER,CBID,K8BID)

C
      CHPESA = ' '
      CALL MECHPE(NCHAR,ZK24(JCHAR),CHPESA)
C
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM

      LPAIN(2) = 'PMATERC'
      LCHIN(2) = MATE
      LPAIN(50) = 'PMATERN'
      CALL ASSERT(MATE(9:18).EQ.'.MATE_CODE')
      MATN=MATE(1:8)//'.MATN_CODE'
      LCHIN(50) = MATN

      LPAIN(3) = 'PCONTMR'
      LCHIN(3) = SIGMOI
      LPAIN(4) = 'PVARIMR'
      LCHIN(4) = VARMOI
      LPAIN(5) = 'PCOMPOR'
      LCHIN(5) = COMPOR
      LPAIN(6) = 'PDEPLMR'
      LCHIN(6) = DEPMOI
      LPAIN(7) = 'PDEPLPR'
      LCHIN(7) = DEPDEL
      LPAIN(8) = 'PCACABL'
      LCHIN(8) = CHCARA(10)

      LPAIN(9) = 'PINSTMR'
      LCHIN(9) = INSMOI
      LPAIN(10) = 'PINSTPR'
      LCHIN(10) = INSPLU
      LPAIN(11) = 'PCARCRI'
      LCHIN(11) = CARCRI
      LPAIN(12) = ' '
      LCHIN(12) = ' '
      LPAIN(13) = ' '
      LCHIN(13) = ' '
      LPAIN(14) = 'PCAGNPO'
      LCHIN(14) = CHCARA(6)
      LPAIN(15) = 'PCAORIE'
      LCHIN(15) = CHCARA(1)
      LPAIN(16) = 'PCADISK'
      LCHIN(16) = CHCARA(2)
      LPAIN(17) = 'PCACOQU'
      LCHIN(17) = CHCARA(7)
      LPAIN(18) = 'PITERAT'
      LCHIN(18) = CHITER
      LPAIN(19) = 'PDDEPLA'
      LCHIN(19) = DDEPLA
      LPAIN(20) = 'PDEPKM1'
      LCHIN(20) = DEPKM1
      LPAIN(21) = 'PVITKM1'
      LCHIN(21) = VITKM1
      LPAIN(22) = 'PACCKM1'
      LCHIN(22) = ACCKM1
      LPAIN(23) = 'PVITPLU'
      LCHIN(23) = VITPLU
      LPAIN(24) = 'PACCPLU'
      LCHIN(24) = ACCPLU
      LPAIN(25) = 'PROMKM1'
      LCHIN(25) = ROMKM1
      LPAIN(26) = 'PROMK'
      LCHIN(26) = ROMK
      LPAIN(27) = 'PSTADYN'
      LCHIN(27) = STADYN
      LPAIN(28) = 'PVARIMP'
      LCHIN(28) = VARMOJ
      LPAIN(29) = 'PCAGNBA'
      LCHIN(29) = CHCARA(11)
      LPAIN(30) = 'PCAMASS'
      LCHIN(30) = CHCARA(12)
      LPAIN(31) = 'PCAGEPO'
      LCHIN(31) = CHCARA(5)
      LPAIN(32) = 'PDEPENT'
      LCHIN(32) = DEPENT
      LPAIN(33) = 'PVITENT'
      LCHIN(33) = VITENT
      LPAIN(34) = 'PVARCMR'
      LCHIN(34) = VRCMOI
      LPAIN(35) = 'PVARCPR'
      LCHIN(35) = VRCPLU
      LPAIN(36) = 'PNBSP_I'
      LCHIN(36) = CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(37) = 'PFIBRES'
      LCHIN(37) = CHCARA(1) (1:8)//'.CAFIBR'
      LPAIN(38) = ' '
      LCHIN(38) = ' '
      LPAIN(39) = ' '
      LCHIN(39) = ' '
      LPAIN(40) = 'PVARCRR'
      LCHIN(40) = VRCREF
      LPAIN(41) = 'PPESANR'
      LCHIN(41) = CHPESA
      LPAIN(42) = 'PPINTTO'
      LCHIN(42) = PINTTO
      LPAIN(43) = 'PHEAVTO'
      LCHIN(43) = HEAVTO
      LPAIN(44) = 'PLONCHA'
      LCHIN(44) = LONCHA
      LPAIN(45) = 'PCNSETO'
      LCHIN(45) = CNSETO
      LPAIN(46) = 'PBASLOR'
      LCHIN(46) = BASLOC
      LPAIN(47) = 'PCACO3D'
      LCHIN(47) = CACO3D
      LPAIN(48) = 'PLSN'
      LCHIN(48) = LSN
      LPAIN(49) = 'PLST'
      LCHIN(49) = LST

      NBRES = 0

      IF (OPTION(1:9).EQ.'FULL_MECA') THEN
        CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,
     &                                NBOUT,LCHOUT,LPAOUT,BASE)
C
        IF (DEBUG) THEN
          CALL DBGCAL(OPTION,IFMDBG,
     &                NBIN  ,LPAIN ,LCHIN ,
     &                NBOUT ,LPAOUT,LCHOUT)
        ENDIF   
C	   
        ZK24(JMER  ) = LCHOUT(1)
        ZK24(JMER+1) = LCHOUT(2)
        NBRIG = 2
        CALL JEECRA(MERIGI,'LONUTI',NBRIG,K8BID)
        NBRES = 1
        ZK24(JRES+NBRES-1) = LCHOUT(3)
        CALL JEECRA(RESIDU,'LONUTI',NBRES,K8BID)
        CALL NMIRET(LCHOUT(6),TABRET)

      ELSE IF (OPTION(1:10).EQ.'RIGI_MECA ') THEN
        CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,
     &                                NBOUT,LCHOUT,LPAOUT,BASE)
C
        IF (DEBUG) THEN
          CALL DBGCAL(OPTION,IFMDBG,
     &                NBIN  ,LPAIN ,LCHIN ,
     &                NBOUT ,LPAOUT,LCHOUT)
        ENDIF   
C	     
        ZK24(JMER  ) = LCHOUT(1)
        ZK24(JMER+1) = LCHOUT(2)
        NBRIG = 2
        CALL JEECRA(MERIGI,'LONUTI',NBRIG,K8BID)

      ELSE IF (OPTION(1:10).EQ.'RIGI_MECA_') THEN
        CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,
     &                                NBOUT,LCHOUT,LPAOUT,BASE)
C
        IF (DEBUG) THEN
          CALL DBGCAL(OPTION,IFMDBG,
     &                NBIN  ,LPAIN ,LCHIN ,
     &                NBOUT ,LPAOUT,LCHOUT)
        ENDIF   
C	     
        ZK24(JMER  ) = LCHOUT(1)
        ZK24(JMER+1) = LCHOUT(2)
        NBRIG = 2
        CALL JEECRA(MERIGI,'LONUTI',NBRIG,K8BID)

      ELSE IF (OPTION(1:9).EQ.'RAPH_MECA') THEN
        CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,
     &                                NBOUT,LCHOUT,LPAOUT,BASE)
        NBRES = 1
        ZK24(JRES+NBRES-1) = LCHOUT(3)
        CALL JEECRA(RESIDU,'LONUTI',NBRES,K8BID)
        CALL NMIRET(LCHOUT(6),TABRET)

      ELSE
        CALL U2MESS('F','ALGORITH3_61')
      END IF

C --- CALCUL DU RESIDU PARTIEL : F_INT + BT.LAMBDA

      IF (OPTION(1:4).EQ.'FULL' .OR. OPTION(1:4).EQ.'RAPH') THEN
        OPTINT = 'MECA_BTLA_R'
        IF (NCHAR.EQ.0) GO TO 20
        CALL JEVEUO(LISCHA//'.LCHA','L',JCHAR)
        CALL JEVEUO(LISCHA//'.INFC','L',JINF)
        NDIR = 0
        DO 10 ICHA = 1,NCHAR
          NUMDI = ZI(JINF+ICHA)
          IF (NUMDI.GT.0) THEN
            NOMCHA = ZK24(JCHAR+ICHA-1) (1:8)
            LIGRCH = NOMCHA//'.CHME.LIGRE'
            LPAIN(1) = 'PDDLMUR'
            LCHIN(1) = NOMCHA//'.CHME.CMULT'
            LPAIN(2) = 'PLAGRAR'
            LCHIN(2) = DEPPLU
            LPAOUT(1) = 'PVECTUR'
            LCHOUT(1) = DIREL//'.RE'
            CALL CODENT(NBRES+1,'D0',LCHOUT(1) (12:15))
            CALL CALCUL('S',OPTINT,LIGRCH,2,LCHIN,LPAIN,
     &                                    1,LCHOUT,LPAOUT,BASE)
C
            IF (DEBUG) THEN
              CALL DBGCAL(OPTION,IFMDBG,
     &                    NBIN  ,LPAIN ,LCHIN ,
     &                    NBOUT ,LPAOUT,LCHOUT)
            ENDIF   
C	     
            NBRES = NBRES + 1
            ZK24(JRES+NBRES-1) = LCHOUT(1)
            NDIR = NDIR + 1
            ZK24(JDIR+NDIR-1) = LCHOUT(1)
          END IF
   10   CONTINUE
        CALL JEECRA(RESIDU,'LONUTI',NBRES,K8BID)
        CALL JEECRA(VEDIRI,'LONUTI',NDIR,K8BID)
      END IF

   20 CONTINUE
      CALL JEDEMA()
      END

      SUBROUTINE MERIMO(MODELE,CARELE,MATE,COMREF,COMPOR,LISCHA,CARCRI,
     &                  DEPDEL,POUGD,STADYN,DEPENT,VITENT,VALMOI,VALPLU,
     &                  OPTIOZ,MERIGI,RESIDU,VEDIRI,ITERAT,TABRET)

C MODIF ALGORITH  DATE 11/02/2003   AUTEUR PBADEL P.BADEL 
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
C RESPONSABLE PBADEL P.BADEL
C TOLE CRP_20

      IMPLICIT NONE

      INTEGER ITERAT
      LOGICAL TABRET(0:10)
      CHARACTER*(*) MATE,OPTIOZ
      CHARACTER*16 OPTION
      CHARACTER*19 LISCHA
      CHARACTER*24 MODELE,CARELE,COMPOR,COMREF
      CHARACTER*24 CARCRI,DEPDEL,STADYN,MERIGI,RESIDU
      CHARACTER*24 VEDIRI,DEPENT,VITENT
      CHARACTER*24 VALMOI,VALPLU,POUGD
C ----------------------------------------------------------------------
C     CALCUL DES MATRICES ELEMENTAIRES DES ELEMENTS DU MODELE ET DES
C     TERMES ELEMENTAIRES DU RESIDU

C IN       MODELE  : NOM DU MODELE
C IN       LISCHA  : SD L_CHARGES
C IN       CARELE  : CARACTERISTIQUES DES POUTRES ET COQUES
C IN       MATE    : CHAMP DE MATERIAU CODE
C IN       COMPOR  : TYPE DE RELATION DE COMPORTEMENT
C IN       CARCRI  : CARTE DES CRITERES DE CONVERGENCE LOCAUX
C IN       DEPDEL  : CHAM_NO DE L'INCREMENT DE DEPLAC. DEPUIS T-
C IN       DDEPLA  : CHAM_NO DE L'INCREMENT DE DEPLAC. DEPUIS T-
C IN       DEPKM1  : CHAM_NO DE DEPLACEMENTS A L'ITERATION PRECEDENTE
C IN       VITKM1  : CHAM_NO DE VITESSES     A L'ITERATION PRECEDENTE
C IN       ACCKM1  : CHAM_NO D'ACCELERATIONS A L'ITERATION PRECEDENTE
C IN       VITPLU  : CHAM_NO DE VITESSES     A L'ITERATION ACTUELLE
C IN       ACCPLU  : CHAM_NO D'ACCELERATIONS A L'ITERATION ACTUELLE
C IN       ROMKM1  : VECTEURS-ROTATION ENTRE T- ET L'ITER. PRECE.
C IN       ROMK    : VECTEURS-ROTATION ENTRE T- ET L'ITER. ACTUE.
C IN       STADYN  : CARTE INDIQUANT SI STATIQUE OU EN DYNAMIQUE
C IN       OPTION  : OPTION DEMANDEE
C IN       ITERAT  : NUMERO D'ITERATION INTERNE
C IN/JXIN  VALMOI  : ETAT EN T-
C IN/JXVAR VALPLU  : ETAT EN T+
C IN       COMREF  : VALEURS DE REF DES VAR DE COMMANDE (TREF, ...)
C OUT      MERIGI  : MATRICES ELEMENTAIRES DE RIGIDITE
C OUT      RESIDU  : VECTEURS ELEMENTAIRES DES FORCES INTERIEURES
C OUT      VEDIRI  : VECTEURS ELEMENTAIRES BT.LAMBDA
C OUT      TABRET  : TABLEAU RESUMANT LES CODES RETOURS DU TE
C                    TABRET(0) = .TRUE. UN CODE RETOUR NON NUL EXISTE
C                    TABRET(I) = .TRUE. CODE RETOUR I RENCONTRE
C                                SINON .FALSE.
C                    I VALANT DE 1 A 10

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      INTEGER NCHAR,JCHAR,JINF,ICHA,JMER,JRES,IRET
      INTEGER JCOM,JDIR,IBID
      INTEGER NBRES,NDIR,NBRIG,NUMDI
      REAL*8 ITER
      CHARACTER*8 LPAOUT(6),LPAIN(46),K8BID,NOMCHA,NOMGD
      CHARACTER*16 OPTINT
      CHARACTER*24 LIGRMO,LIGRCH,LCHOUT(6),LCHIN(46)
      CHARACTER*24 CHGEOM,CHCARA(15),CHITER
      CHARACTER*24 DEPMOI,SIGMOI,VARMOI,COMMOI
      CHARACTER*24 DEPPLU,SIGPLU,VARPLU,COMPLU
      CHARACTER*24 TEMMOI,HYDMOI,SECMOI,PHAMOI,EPAMOI,INSMOI,IRRMOI
      CHARACTER*24 TEMPLU,HYDPLU,SECPLU,PHAPLU,EPAPLU,INSPLU,IRRPLU
      CHARACTER*24 TEMREF
      CHARACTER*24 VARMOJ,CODRET
      CHARACTER*24 DDEPLA,DEPKM1,VITKM1,ACCKM1
      CHARACTER*24 VITPLU,ACCPLU,ROMKM1,ROMK
      CHARACTER*24 K24BID
      LOGICAL EXIGEO,EXICAR
      COMPLEX*16 CBID
      CHARACTER*8 VECEL,MATEL,DIREL

      DATA VECEL,MATEL,DIREL/'&&RESIDU','&&MEMRIG','&&DIRICH'/
      DATA VARMOJ/'&&MERIMO.VARMOJ'/
      DATA CODRET/'&&MERIMO.CODE_RETOUR'/

      CALL JEMARQ()
      OPTION = OPTIOZ

C    LECTURE DE L'ETAT EN T- ET T+
      CALL DESAGG(VALMOI,DEPMOI,SIGMOI,VARMOI,COMMOI,K24BID,K24BID,
     &            K24BID,K24BID)
      CALL DESAGG(VALPLU,DEPPLU,SIGPLU,VARPLU,COMPLU,K24BID,K24BID,
     &            K24BID,K24BID)

C    LECTURE DES INFOS PROPRES AUX POUTRES GRANDES DEFORMATIONS
      CALL DESAGG(POUGD,DEPKM1,VITKM1,ACCKM1,VITPLU,ACCPLU,ROMKM1,ROMK,
     &            DDEPLA)


C    LECTURE DES VARIABLES DE COMMANDE EN T- ET T+ ET VAL. DE REF
      CALL NMVCEX('TEMP',COMMOI,TEMMOI)
      CALL NMVCEX('HYDR',COMMOI,HYDMOI)
      CALL NMVCEX('IRRA',COMMOI,IRRMOI)
      CALL NMVCEX('SECH',COMMOI,SECMOI)
      CALL NMVCEX('EPAN',COMMOI,EPAMOI)
      CALL NMVCEX('PHAS',COMMOI,PHAMOI)
      CALL NMVCEX('INST',COMMOI,INSMOI)

      CALL NMVCEX('TEMP',COMPLU,TEMPLU)
      CALL NMVCEX('HYDR',COMPLU,HYDPLU)
      CALL NMVCEX('IRRA',COMPLU,IRRPLU)
      CALL NMVCEX('SECH',COMPLU,SECPLU)
      CALL NMVCEX('EPAN',COMPLU,EPAPLU)
      CALL NMVCEX('PHAS',COMPLU,PHAPLU)
      CALL NMVCEX('INST',COMPLU,INSPLU)

      CALL NMVCEX('TEMP',COMREF,TEMREF)


C    VARIABLES INTERNES ISSUES DE L'ITERATION PRECEDENTE
C    (CELLES ISSUES DU LAGRANGIEN AUGMENTE EN NON LOCAL)
C    A CAUSE DES POUTRES GD -> AUSSI POUR RIGI_MECA_TANG
C    ET DONC ON PREVOIT LE CAS OU VARPLU N'EXISTE PAS ENCORE
      CALL EXISD('CHAMP_GD',VARPLU(1:19),IRET)
      IF (IRET.NE.0) THEN
        CALL COPISD('CHAMP_GD','V',VARPLU(1:19),VARMOJ(1:19))
      ELSE
        CALL COPISD('CHAMP_GD','V',VARMOI(1:19),VARMOJ(1:19))
      END IF


      LIGRMO = MODELE(1:8)//'.MODELE'


C     CREATION DU CHAM_ELEM_S POUR ETENDRE LE CHAM_ELEM DE VARI_R:
C     ------------------------------------------------------------
      CALL EXISD('CHAM_ELEM_S',COMPOR,IRET)
      IF (IRET.EQ.0) CALL CESVAR(CARELE,COMPOR,LIGRMO,COMPOR)
      CALL COPISD('CHAM_ELEM_S','V',COMPOR,VARPLU)
      CALL COPISD('CHAM_ELEM_S','V',COMPOR,SIGPLU)


      CALL JEEXIN(MERIGI,IRET)
      IF (IRET.EQ.0) THEN
        MERIGI = MATEL//'.LISTE_RESU'
        CALL MEMARE('V',MATEL,MODELE(1:8),MATE,CARELE,'RIGI_MECA')
        CALL WKVECT(MERIGI,'V V K24',2,JMER)
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
        CALL MEMARE('V',VECEL,MODELE(1:8),MATE,CARELE,'CHAR_MECA')
        CALL WKVECT(RESIDU,'V V K24',NCHAR+1,JRES)
      ELSE
        CALL JEVEUO(RESIDU,'E',JRES)
      END IF
      CALL JEECRA(RESIDU,'LONUTI',0,K8BID)

      CALL JEEXIN(VEDIRI,IRET)
      IF (IRET.EQ.0) THEN
        VEDIRI = DIREL//'.LISTE_RESU'
        CALL MEMARE('V',DIREL,MODELE(1:8),MATE,CARELE,'CHAR_MECA')
        CALL WKVECT(VEDIRI,'V V K24',NCHAR,JDIR)
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

      CALL JEVEUO(LISCHA//'.LCHA','L',JCHAR)
      NOMCHA = ZK24(JCHAR) (1:8)
      CALL MEGEOM(MODELE,NOMCHA,EXIGEO,CHGEOM)

C    CHAMP DE CARACTERISTIQUES ELEMENTAIRES
      CALL MECARA(CARELE(1:8),EXICAR,CHCARA)

C    NUMERO DE L'ITERATION
      CHITER = '&&MERIMO.CH_ITERAT'
      ITER = ITERAT
      CALL MECACT('V',CHITER,'MODELE',MODELE(1:8)//'.MODELE','NEUT_R',1,
     &            'X1',IBID,ITER,CBID,K8BID)

      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PMATERC'
      LCHIN(2) = MATE
      LPAIN(3) = 'PTEMPMR'
      LCHIN(3) = TEMMOI
      LPAIN(4) = 'PCONTMR'
      LCHIN(4) = SIGMOI
      LPAIN(5) = 'PVARIMR'
      LCHIN(5) = VARMOI
      LPAIN(6) = 'PCOMPOR'
      LCHIN(6) = COMPOR
      LPAIN(7) = 'PDEPLMR'
      LCHIN(7) = DEPMOI
      LPAIN(8) = 'PDEPLPR'
      LCHIN(8) = DEPDEL
      LPAIN(9) = 'PCACABL'
      LCHIN(9) = CHCARA(10)
C     -- ON TESTE LA NATURE DU CHAMP DE TEMPERATURE :
      CALL DISMOI('F','NOM_GD',TEMPLU,'CHAMP',IBID,NOMGD,IRET)
      IF (NOMGD.EQ.'TEMP_R') THEN
        LPAIN(10) = 'PTEMPPR'
      ELSE IF (NOMGD.EQ.'TEMP_F') THEN
        LPAIN(10) = 'PTEMPEF'
        LPAIN(3) = ' '
      ELSE
        CALL UTMESS('F','MERIMO','GRANDEUR INCONNUE.')
      END IF
      LCHIN(10) = TEMPLU
      LPAIN(11) = 'PTEREF'
      LCHIN(11) = TEMREF
      LPAIN(12) = 'PINSTMR'
      LCHIN(12) = INSMOI
      LPAIN(13) = 'PINSTPR'
      LCHIN(13) = INSPLU
      LPAIN(14) = 'PCARCRI'
      LCHIN(14) = CARCRI
      LPAIN(15) = 'PPHASMR'
      LCHIN(15) = PHAMOI
      LPAIN(16) = 'PPHASPR'
      LCHIN(16) = PHAPLU
      LPAIN(17) = 'PCAGNPO'
      LCHIN(17) = CHCARA(6)
      LPAIN(18) = 'PCAORIE'
      LCHIN(18) = CHCARA(1)
      LPAIN(19) = 'PCADISK'
      LCHIN(19) = CHCARA(2)
      LPAIN(20) = 'PCACOQU'
      LCHIN(20) = CHCARA(7)
      LPAIN(21) = 'PITERAT'
      LCHIN(21) = CHITER
      LPAIN(22) = 'PDDEPLA'
      LCHIN(22) = DDEPLA
      LPAIN(23) = 'PDEPKM1'
      LCHIN(23) = DEPKM1
      LPAIN(24) = 'PVITKM1'
      LCHIN(24) = VITKM1
      LPAIN(25) = 'PACCKM1'
      LCHIN(25) = ACCKM1
      LPAIN(26) = 'PVITPLU'
      LCHIN(26) = VITPLU
      LPAIN(27) = 'PACCPLU'
      LCHIN(27) = ACCPLU
      LPAIN(28) = 'PROMKM1'
      LCHIN(28) = ROMKM1
      LPAIN(29) = 'PROMK'
      LCHIN(29) = ROMK
      LPAIN(30) = 'PSTADYN'
      LCHIN(30) = STADYN
      LPAIN(31) = 'PVARIMP'
      LCHIN(31) = VARMOJ
      LPAIN(32) = 'PCAGNBA'
      LCHIN(32) = CHCARA(11)
      LPAIN(33) = 'PCAMASS'
      LCHIN(33) = CHCARA(12)
      LPAIN(34) = 'PCAGEPO'
      LCHIN(34) = CHCARA(5)
      LPAIN(35) = 'PHYDRPR'
      LCHIN(35) = HYDPLU
      LPAIN(36) = 'PSECHPR'
      LCHIN(36) = SECPLU
      LPAIN(37) = 'PHYDRMR'
      LCHIN(37) = HYDMOI
      LPAIN(38) = 'PSECHMR'
      LCHIN(38) = SECMOI
      LPAIN(39) = 'PDEFAMR'
      LCHIN(39) = EPAMOI
      LPAIN(40) = 'PDEFAPR'
      LCHIN(40) = EPAPLU
      LPAIN(41) = 'PDEPENT'
      LCHIN(41) = DEPENT
      LPAIN(42) = 'PVITENT'
      LCHIN(42) = VITENT
      LPAIN(43) = 'PIRRAMR'
      LCHIN(43) = IRRMOI
      LPAIN(44) = 'PIRRAPR'
      LCHIN(44) = IRRPLU
      LPAIN(45) = 'PNBSP_I'
      LCHIN(45) = CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(46) = 'PFIBRES'
      LCHIN(46) = CHCARA(1) (1:8)//'.CAFIBR'


      NBRES = 0

      IF (OPTION(1:9).EQ.'FULL_MECA') THEN
       CALL CALCUL('S',OPTION,LIGRMO,46,LCHIN,LPAIN,6,LCHOUT,LPAOUT,'V')
        ZK24(JMER) = LCHOUT(1)
        ZK24(JMER+1) = LCHOUT(2)
        NBRIG = 2
        CALL JEECRA(MERIGI,'LONUTI',NBRIG,K8BID)
        NBRES = 1
        ZK24(JRES+NBRES-1) = LCHOUT(3)
        CALL JEECRA(RESIDU,'LONUTI',NBRES,K8BID)
        CALL NMIRET(LCHOUT(6),TABRET)

      ELSE IF (OPTION(1:10).EQ.'RIGI_MECA ') THEN
        IF (NOMGD.EQ.'TEMP_R') LPAIN(10) = 'PTEMPER'
        LPAIN(13) = 'PTEMPSR'
       CALL CALCUL('S',OPTION,LIGRMO,46,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
        ZK24(JMER) = LCHOUT(1)
        ZK24(JMER+1) = LCHOUT(2)
        NBRIG = 2
        CALL JEECRA(MERIGI,'LONUTI',NBRIG,K8BID)

      ELSE IF (OPTION(1:14).EQ.'RIGI_MECA_TANG') THEN
       CALL CALCUL('S',OPTION,LIGRMO,46,LCHIN,LPAIN,5,LCHOUT,LPAOUT,'V')
        ZK24(JMER) = LCHOUT(1)
        ZK24(JMER+1) = LCHOUT(2)
        NBRIG = 2
        CALL JEECRA(MERIGI,'LONUTI',NBRIG,K8BID)

      ELSE IF (OPTION(1:9).EQ.'RAPH_MECA') THEN
        CALL CALCUL('S',OPTION,LIGRMO,46,LCHIN,LPAIN,4,
     &              LCHOUT(3),LPAOUT(3),'V')
        NBRES = 1
        ZK24(JRES+NBRES-1) = LCHOUT(3)
        CALL JEECRA(RESIDU,'LONUTI',NBRES,K8BID)
        CALL NMIRET(LCHOUT(6),TABRET)

      ELSE
        CALL UTMESS('F','MERIMO','OPTION NON PREVUE')
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
        CALL CALCUL('S',OPTINT,LIGRCH,2,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')
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

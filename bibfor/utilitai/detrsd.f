      SUBROUTINE DETRSD(TYPESD,NOMSD)
      IMPLICIT   NONE
      CHARACTER*(*) TYPESD,NOMSD
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 23/10/2006   AUTEUR VABHHTS J.PELLET 
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
C TOLE CRP_20
C RESPONSABLE                            VABHHTS J.PELLET
C ----------------------------------------------------------------------
C  BUT : DETRUIRE UNE STRUCTURE DE DONNEE DONT ON CONNAIT LE TYPE
C  ATTENTION : QUAND ON UTILISE TYPESD=' ', ON APPELLE LA ROUTINE JEDETC
C              QUI EST TRES COUTEUSE EN CPU.
C  IN   TYPESD : TYPE DE LA STRUCTURE DE DONNEE A DETRUIRE
C          'NUME_DDL'     'PROF_CHNO'    'MLTF'
C          'MATR_ASSE'    'VECT_ASSE'    'MATR_ASSE_GENE'
C          'MATR_ELEM'    'VECT_ELEM'
C          'VARI_COM'     'FONCTION' (POUR LES FONCTIONS OU NAPPES)
C          'TABLE'        'DEFI_CONT'    'RESO_CONT'
C          'SOLVEUR'      'CORRESP_2_MAILLA'
C          'CHAM_NO_S'    'CHAM_ELEM_S'
C          'CHAM_NO'      'CHAM_ELEM'  'CARTE'
C          'CHAMP' (CHAPEAU AUX CHAM_NO/CHAM_ELEM/CARTE/RESUELEM)
C          'CHAMP_GD' (CHAPEAU DESUET AUX CHAM_NO/CHAM_ELEM/...)
C          'RESULTAT'  'LIGREL'  'NUAGE'  'MAILLAGE'
C          (OU ' ' QUAND ON NE CONNAIT PAS LE TYPE).
C       NOMSD   : NOM DE LA STRUCTURE DE DONNEES A DETRUIRE
C          NUME_DDL(K14),MATR_ASSE(K19),VECT_ASSE(K19)
C          CHAMP(K19),MATR_ELEM(K8),VECT_ELEM(K8),VARI_COM(K14)
C          DEFI_CONT(K16),RESO_CONT(K14),TABLE(K19)
C          CHAM_NO(K19),CHAM_NO_S(K19),CHAM_ELEM(K19),CHAM_ELEM_S(K19)

C     RESULTAT:
C     ON DETRUIT TOUS LES OBJETS JEVEUX CORRESPONDANT A CES CONCEPTS.
C ----------------------------------------------------------------------
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER IRET,IAD,LONG,I,NBCH,ILIRES,IBID,NBSD,IFETS,ILIMPI,IDD,
     &        IFETM,IFETN,IFETC
      CHARACTER*1 K1BID
      CHARACTER*8 MATEL,MAILLA,MUMPS,K8BID
      CHARACTER*14 NU,RESOCO,COM
      CHARACTER*16 DEFICO,TYP2SD,CORRES
      CHARACTER*19 CHAMP,MATAS,TABLE,SOLVEU,CNS,CES,CNO,CEL,FNC
      CHARACTER*19 LIGREL,CARTE,NUAGE,LIGRET,MLTF,STOCK,K19B
      CHARACTER*24 K24B
      LOGICAL LFETI

C -DEB------------------------------------------------------------------

      CALL JEMARQ()
      TYP2SD = TYPESD

C     ------------------------------------------------------------------
      IF (TYP2SD.EQ.' ') THEN
C     -----------------------
C       TYPE_SD INCONNU => CALL JEDETC => COUT CPU IMPORTANT + DANGER
        CALL JEDETC(' ',NOMSD,1)

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'CHAM_NO_S') THEN
C     ------------------------------------
        CNS = NOMSD
        CALL JEDETR(CNS//'.CNSD')
        CALL JEDETR(CNS//'.CNSK')
        CALL JEDETR(CNS//'.CNSC')
        CALL JEDETR(CNS//'.CNSL')
        CALL JEDETR(CNS//'.CNSV')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'CHAM_ELEM_S') THEN
C     --------------------------------------
        CES = NOMSD
        CALL JEDETR(CES//'.CESD')
        CALL JEDETR(CES//'.CESK')
        CALL JEDETR(CES//'.CESC')
        CALL JEDETR(CES//'.CESL')
        CALL JEDETR(CES//'.CESV')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'CORRESP_2_MAILLA') THEN
C     -------------------------------------------
        CORRES = NOMSD
        CALL JEDETR(CORRES//'.PJEF_NO')
        CALL JEDETR(CORRES//'.PJEF_NU')
        CALL JEDETR(CORRES//'.PJEF_NB')
        CALL JEDETR(CORRES//'.PJEF_M1')
        CALL JEDETR(CORRES//'.PJEF_CF')
        CALL JEDETR(CORRES//'.PJEF_TR')

C     ------------------------------------------------------------------
      ELSE IF (TYPESD.EQ.'FONCTION') THEN
C     -----------------------------------
        FNC = NOMSD
        CALL JEDETR(FNC//'.PARA')
        CALL JEDETR(FNC//'.PROL')
        CALL JEDETR(FNC//'.VALE')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'SOLVEUR') THEN
C     ----------------------------------
        SOLVEU = NOMSD
        CALL JEDETR(SOLVEU//'.SLVI')
        CALL JEDETR(SOLVEU//'.SLVK')
        CALL JEDETR(SOLVEU//'.SLVR')

C DESTRUCTION DE LA LISTE DE SD SOLVEUR LOCAUX SI FETI
        K24B = SOLVEU//'.FETS'
        CALL JEEXIN(K24B,IRET)
C FETI OR NOT ?
        IF (IRET.GT.0) THEN
          LFETI = .TRUE.

        ELSE
          LFETI = .FALSE.
        END IF

        IF (LFETI) THEN
          CALL JELIRA(K24B,'LONMAX',NBSD,K8BID)
          CALL JEVEUO(K24B,'L',IFETS)
          CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
          DO 10 IDD = 1,NBSD
            IF (ZI(ILIMPI+IDD).EQ.1) THEN
              K19B = ZK24(IFETS+IDD-1) (1:19)
              CALL DETRS2('SOLVEUR',K19B)
            END IF

   10     CONTINUE
          CALL JEDETR(K24B)
        END IF
C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'LIGREL') THEN
C     ----------------------------------
        LIGREL = NOMSD
        CALL JEDETR(LIGREL//'.LGNS')
        CALL JEDETR(LIGREL//'.LIEL')
        CALL JEDETR(LIGREL//'.NEMA')
        CALL JEDETR(LIGREL//'.NOMA')
        CALL JEDETR(LIGREL//'.NBNO')
        CALL JEDETR(LIGREL//'.PRNM')
        CALL JEDETR(LIGREL//'.PRNS')
        CALL JEDETR(LIGREL//'.REPE')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'LIGRET') THEN
C     ----------------------------------
        LIGRET = NOMSD
        CALL JEDETR(LIGRET//'.APMA')
        CALL JEDETR(LIGRET//'.APNO')
        CALL JEDETR(LIGRET//'.LIMA')
        CALL JEDETR(LIGRET//'.LINO')
        CALL JEDETR(LIGRET//'.LITY')
        CALL JEDETR(LIGRET//'.MATA')
        CALL JEDETR(LIGRET//'.MODE')
        CALL JEDETR(LIGRET//'.NBMA')
        CALL JEDETR(LIGRET//'.NOMA')
        CALL JEDETR(LIGRET//'.PHEN')
        CALL JEDETR(LIGRET//'.POMA')
        CALL JEDETR(LIGRET//'.PONO')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'MAILLAGE') THEN
C     ----------------------------------
        MAILLA = NOMSD
        CALL DETRS2('CHAM_NO',MAILLA//'.COORDO')
        CALL JEDETR(MAILLA//'           .LTNS')
        CALL JEDETR(MAILLA//'           .LTNT')
        CALL JEDETR(MAILLA//'           .TITR')
        CALL JEDETR(MAILLA//'.CONNEX')
        CALL JEDETR(MAILLA//'.DIME')
        CALL JEDETR(MAILLA//'.GROUPEMA')
        CALL JEDETR(MAILLA//'.GROUPENO')
        CALL JEDETR(MAILLA//'.NOMACR')
        CALL JEDETR(MAILLA//'.NOMMAI')
        CALL JEDETR(MAILLA//'.NOMNOE')
        CALL JEDETR(MAILLA//'.PARA_R')
        CALL JEDETR(MAILLA//'.SUPMAIL')
        CALL JEDETR(MAILLA//'.TYPL')
        CALL JEDETR(MAILLA//'.TYPMAIL')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'NUAGE') THEN
C     ----------------------------------
        NUAGE = NOMSD
        CALL JEDETR(NUAGE//'.NUAI')
        CALL JEDETR(NUAGE//'.NUAX')
        CALL JEDETR(NUAGE//'.NUAV')
        CALL JEDETR(NUAGE//'.NUAL')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'TABLE') THEN
C     --------------------------------
        TABLE = NOMSD
        CALL JEEXIN(TABLE//'.TBLP',IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(TABLE//'.TBLP','L',IAD)
          CALL JELIRA(TABLE//'.TBLP','LONMAX',LONG,K1BID)
          DO 20,I = 1,LONG
            CALL JEDETR(ZK24(IAD-1+I))
   20     CONTINUE
          CALL JEDETR(TABLE//'.TBLP')
          CALL JEDETR(TABLE//'.TBNP')
          CALL JEDETR(TABLE//'.TBBA')
        END IF

        CALL JEEXIN(TABLE//'.TITR',IRET)
        IF (IRET.NE.0) CALL JEDETR(TABLE//'.TITR')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'MATR_ASSE_GENE' .OR.
     &         TYP2SD.EQ.'MATR_ASSE') THEN
C     ---------------------------------------
        MATAS = NOMSD

C       -- DESTRUCTION DE L'EVENTUELLE INSTANCE MUMPS :
        CALL JEEXIN(MATAS//'.REFA',IRET)
        IF (IRET.GT.0) THEN
          CALL DISMOI('F','EST_MUMPS',MATAS,'MATR_ASSE',IBID,MUMPS,IBID)
          IF (MUMPS.EQ.'OUI') THEN
            CALL AMUMPS('DETR_MAT',' ',MATAS,' ',' ',' ',IBID)
          END IF

        END IF

        CALL JEDETR(MATAS//'.DESC')
        CALL JEDETR(MATAS//'.COND')
        CALL JEDETR(MATAS//'.CONL')
        CALL JEDETR(MATAS//'.JDRF')
        CALL JEDETR(MATAS//'.JDDC')
        CALL JEDETR(MATAS//'.JDFF')
        CALL JEDETR(MATAS//'.JDHF')
        CALL JEDETR(MATAS//'.JDPM')
        CALL JEDETR(MATAS//'.JDES')
        CALL JEDETR(MATAS//'.JDVL')
        CALL JEDETR(MATAS//'.LILI')
        CALL JEDETR(MATAS//'.LIME')
        CALL JEDETR(MATAS//'.REFA')
        CALL JEDETR(MATAS//'.TMP1')
        CALL JEDETR(MATAS//'.TMP2')
        CALL JEDETR(MATAS//'.VALM')
        CALL JEDETR(MATAS//'.UALF')
        CALL JEDETR(MATAS//'.VALF')
        CALL JEDETR(MATAS//'.WALF')
        CALL JEDETR(MATAS//'.CCID')
        CALL JEDETR(MATAS//'.CCLL')
        CALL JEDETR(MATAS//'.CCJJ')
        CALL JEDETR(MATAS//'.CCVA')
        CALL JEDETR(MATAS//'.&TRA')
        CALL JEDETR(MATAS//'.&VDI')

C FETI OR NOT ?
        K24B = MATAS//'.FETM'
        CALL JEEXIN(K24B,IRET)
        IF (IRET.GT.0) THEN
          LFETI = .TRUE.

        ELSE
          LFETI = .FALSE.
        END IF

        IF (LFETI) THEN
          CALL JEDETR(MATAS//'.FETF')
          CALL JEDETR(MATAS//'.FETP')
          CALL JEDETR(MATAS//'.FETR')

          CALL JELIRA(K24B,'LONMAX',NBSD,K8BID)
          CALL JEVEUO(K24B,'L',IFETM)
          CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
          DO 30 IDD = 1,NBSD
            IF (ZI(ILIMPI+IDD).EQ.1) THEN
              K19B = ZK24(IFETM+IDD-1) (1:19)
              CALL DETRS2('MATR_ASSE',K19B)
            END IF

   30     CONTINUE
          CALL JEDETR(K24B)
        END IF

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'CHAM_NO') THEN
C     ----------------------------------
        CNO = NOMSD

        CALL JEDETR(CNO//'.DESC')
        CALL JEDETR(CNO//'.REFE')
        CALL JEDETR(CNO//'.VALE')
C FETI OR NOT ?
        K24B = CNO//'.FETC'
        CALL JEEXIN(K24B,IRET)
        IF (IRET.GT.0) THEN
          LFETI = .TRUE.

        ELSE
          LFETI = .FALSE.
        END IF

        IF (LFETI) THEN
          CALL JELIRA(K24B,'LONMAX',NBSD,K8BID)
          CALL JEVEUO(K24B,'L',IFETC)
          CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
          DO 40 IDD = 1,NBSD
            IF (ZI(ILIMPI+IDD).EQ.1) THEN
              K19B = ZK24(IFETC+IDD-1) (1:19)
              CALL DETRS2('CHAM_NO',K19B)
            END IF

   40     CONTINUE
          CALL JEDETR(K24B)
        END IF
C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'CARTE') THEN
C     ----------------------------------
        CARTE = NOMSD
        CALL JEDETR(CARTE//'.DESC')
        CALL JEDETR(CARTE//'.VALE')
        CALL JEDETR(CARTE//'.NOMA')
        CALL JEDETR(CARTE//'.NOLI')
        CALL JEDETR(CARTE//'.LIMA')
        CALL JEDETR(CARTE//'.PTMA')
        CALL JEDETR(CARTE//'.PTMS')
        CALL JEDETR(CARTE//'.NCMP')
        CALL JEDETR(CARTE//'.VALV')
C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'PROF_CHNO') THEN
C     ------------------------------------
        CNO = NOMSD
        CALL JEDETR(CNO//'.DEEQ')
        CALL JEDETR(CNO//'.LILI')
        CALL JEDETR(CNO//'.LPRN')
        CALL JEDETR(CNO//'.NUEQ')
        CALL JEDETR(CNO//'.PRNO')

      ELSE IF (TYP2SD.EQ.'NUME_EQUA') THEN
C     ------------------------------------
        CNO = NOMSD
        CALL DETRS2('PROF_CHNO',CNO)
        CALL JEDETR(CNO//'.DELG')
        CALL JEDETR(CNO//'.NEQU')
        CALL JEDETR(CNO//'.REFN')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'CHAM_ELEM') THEN
C     ------------------------------------
        CEL = NOMSD
        CALL JEDETR(CEL//'.CELD')
        CALL JEDETR(CEL//'.CELK')
        CALL JEDETR(CEL//'.CELV')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'MLTF') THEN
C     -----------------------------------
        MLTF = NOMSD
        CALL JEDETR(MLTF//'.GLOB')
        CALL JEDETR(MLTF//'.LOCL')
        CALL JEDETR(MLTF//'.ADNT')
        CALL JEDETR(MLTF//'.PNTI')
        CALL JEDETR(MLTF//'.DESC')
        CALL JEDETR(MLTF//'.DIAG')
        CALL JEDETR(MLTF//'.ADRE')
        CALL JEDETR(MLTF//'.SUPN')
        CALL JEDETR(MLTF//'.PARE')
        CALL JEDETR(MLTF//'.FILS')
        CALL JEDETR(MLTF//'.FRER')
        CALL JEDETR(MLTF//'.LGSN')
        CALL JEDETR(MLTF//'.LFRN')
        CALL JEDETR(MLTF//'.NBAS')
        CALL JEDETR(MLTF//'.DEBF')
        CALL JEDETR(MLTF//'.DEFS')
        CALL JEDETR(MLTF//'.ADPI')
        CALL JEDETR(MLTF//'.ANCI')
        CALL JEDETR(MLTF//'.NBLI')
        CALL JEDETR(MLTF//'.LGBL')
        CALL JEDETR(MLTF//'.NCBL')
        CALL JEDETR(MLTF//'.DECA')
        CALL JEDETR(MLTF//'.NOUV')
        CALL JEDETR(MLTF//'.SEQU')
        CALL JEDETR(MLTF//'.RENU')


C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'STOCKAGE') THEN
C     -----------------------------------
        STOCK = NOMSD
        CALL JEDETR(STOCK//'.SCBL')
        CALL JEDETR(STOCK//'.SCDI')
        CALL JEDETR(STOCK//'.SCDE')
        CALL JEDETR(STOCK//'.SCHC')
        CALL JEDETR(STOCK//'.SCIB')

        CALL JEDETR(STOCK//'.SMDI')
        CALL JEDETR(STOCK//'.SMDE')
        CALL JEDETR(STOCK//'.SMHC')


C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'STOC_LCIEL') THEN
C     -----------------------------------
        STOCK = NOMSD
        CALL JEDETR(STOCK//'.SCBL')
        CALL JEDETR(STOCK//'.SCDI')
        CALL JEDETR(STOCK//'.SCDE')
        CALL JEDETR(STOCK//'.SCHC')
        CALL JEDETR(STOCK//'.SCIB')


C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'STOC_MORSE') THEN
C     -----------------------------------
        STOCK = NOMSD
        CALL JEDETR(STOCK//'.SMDI')
        CALL JEDETR(STOCK//'.SMDE')
        CALL JEDETR(STOCK//'.SMHC')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'NUME_DDL') THEN
C     -----------------------------------
        NU = NOMSD
        CALL DETRS2('NUME_EQUA',NU//'.NUME')
        CALL DETRS2('MLTF',NU//'.MLTF')
        CALL DETRS2('STOCKAGE',NU//'.SLCS')
        CALL DETRS2('STOCKAGE',NU//'.SMOS')
        CALL JEDETR(NU//'.NSLV')

        CALL JEDETR(NU//'.DERLI')
        CALL JEDETR(NU//'.EXISTE')
        CALL JEDETR(NU//'.NUM2')
        CALL JEDETR(NU//'.NUM21')
        CALL JEDETR(NU//'.LSUIVE')
        CALL JEDETR(NU//'.PSUIVE')
        CALL JEDETR(NU//'.VSUIVE')
        CALL JEDETR(NU//'.OLDN')
        CALL JEDETR(NU//'.NEWN')

C FETI OR NOT ?
        K24B = NU//'.FETN'
        CALL JEEXIN(K24B,IRET)
        IF (IRET.GT.0) THEN
          LFETI = .TRUE.

        ELSE
          LFETI = .FALSE.
        END IF

        IF (LFETI) THEN
          CALL JELIRA(K24B,'LONMAX',NBSD,K8BID)
          CALL JEVEUO(K24B,'L',IFETN)
          CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
          DO 50 IDD = 1,NBSD
            IF (ZI(ILIMPI+IDD).EQ.1) THEN
              K19B = ZK24(IFETN+IDD-1) (1:19)
C RECURSIVITE DE SECOND NIVEAU SUR DETRSD
              CALL DETRS2('NUME_DDL',K19B(1:14))
            END IF

   50     CONTINUE
          CALL JEDETR(K24B)
        END IF
C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'VARI_COM') THEN
C     -------------------------------------
        COM = NOMSD
        CALL ASSDE1(COM//'.TEMP')
        CALL ASSDE1(COM//'.HYDR')
        CALL ASSDE1(COM//'.SECH')
        CALL ASSDE1(COM//'.PHAS')
        CALL ASSDE1(COM//'.EPAN')
        CALL ASSDE1(COM//'.INST')
        CALL ASSDE1(COM//'.TOUT')
        CALL JEDETR(COM//'.EXISTENCE')

C     ------------------------------------------------------------------
      ELSE IF ((TYP2SD.EQ.'CHAMP') .OR. (TYP2SD.EQ.'CHAMP_GD')) THEN
C     ---------------------------------------
C       POUR LES CARTE, CHAM_NO, CHAM_ELEM, ET RESU_ELEM :
        CHAMP = NOMSD
        CALL ASSDE1(CHAMP)

C     ------------------------------------------------------------------
      ELSE IF ((TYP2SD.EQ.'MATR_ELEM') .OR.
     &         (TYP2SD.EQ.'VECT_ELEM')) THEN
C     ---------------------------------------
        MATEL = NOMSD
        CALL JEDETR(MATEL//'.REFE_RESU')
        CALL JEEXIN(MATEL//'.LISTE_RESU',IRET)
        IF (IRET.LE.0) GO TO 70
        CALL JELIRA(MATEL//'.LISTE_RESU','LONUTI',NBCH,K1BID)
        CALL JEVEUO(MATEL//'.LISTE_RESU','L',ILIRES)
        DO 60,I = 1,NBCH
          CALL ASSDE1(ZK24(ILIRES-1+I) (1:19))
   60   CONTINUE
        CALL JEDETR(MATEL//'.LISTE_RESU')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'DEFI_CONT') THEN
C     ------------------------------------
        DEFICO = NOMSD
        CALL JEDETR(DEFICO//'.METHCO')
        CALL JEDETR(DEFICO//'.PZONECO')
        CALL JEDETR(DEFICO//'.MAILCO')
        CALL JEDETR(DEFICO//'.PSUMACO')
        CALL JEDETR(DEFICO//'.MANOCO')
        CALL JEDETR(DEFICO//'.PMANOCO')
        CALL JEDETR(DEFICO//'.MAMACO')
        CALL JEDETR(DEFICO//'.PMAMACO')
        CALL JEDETR(DEFICO//'.NOEUCO')
        CALL JEDETR(DEFICO//'.PSUNOCO')
        CALL JEDETR(DEFICO//'.NOMACO')
        CALL JEDETR(DEFICO//'.PNOMACO')
        CALL JEDETR(DEFICO//'.NDIMCO')
        CALL JEDETR(DEFICO//'.DDLCO')
        CALL JEDETR(DEFICO//'.MAESCL')
        CALL JEDETR(DEFICO//'.TABFIN')
        CALL JEDETR(DEFICO//'.CARACF')
        CALL JEDETR(DEFICO//'.ECPDON')
C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'RESO_CONT') THEN
C     ------------------------------------
        RESOCO = NOMSD
        CALL JEDETR(RESOCO//'.APPARI')
        CALL JEDETR(RESOCO//'.APMEMO')
        CALL JEDETR(RESOCO//'.APPOIN')
        CALL JEDETR(RESOCO//'.NORINI')
        CALL JEDETR(RESOCO//'.NORMCO')
        CALL JEDETR(RESOCO//'.TANGCO')
        CALL JEDETR(RESOCO//'.APNOEU')
        CALL JEDETR(RESOCO//'.APDDL')
        CALL JEDETR(RESOCO//'.APCOEF')
        CALL JEDETR(RESOCO//'.APCOFR')
        CALL JEDETR(RESOCO//'.APJEU')
        CALL JEDETR(RESOCO//'.APJEFX')
        CALL JEDETR(RESOCO//'.APJEFY')
        CALL JEDETR(RESOCO//'.APREAC')
        CALL JEDETR(RESOCO//'.COCO')
        CALL JEDETR(RESOCO//'.LIAC')
        CALL JEDETR(RESOCO//'.LIOT')
        CALL JEDETR(RESOCO//'.MU')
        CALL JEDETR(RESOCO//'.COEFMU')
        CALL JEDETR(RESOCO//'.ATMU')
        CALL JEDETR(RESOCO//'.AFMU')
        CALL JEDETR(RESOCO//'.DEL0')
        CALL JEDETR(RESOCO//'.DELT')
        CALL JEDETR(RESOCO//'.CM1A')
        CALL JEDETR(RESOCO//'.CM2A')
        CALL JEDETR(RESOCO//'.CM3A')

        CALL DETRS2('MATR_ASSE',RESOCO//'.MATR')
        CALL DETRS2('STOCKAGE',RESOCO//'.SLCS')

C     ------------------------------------------------------------------
      ELSE IF (TYP2SD.EQ.'RESULTAT') THEN
C     -----------------------------------
        CNS = NOMSD
        CALL JEEXIN(CNS//'.DESC',IRET)
        IF (IRET.GT.0) CALL RSDLSD(NOMSD)

C     ------------------------------------------------------------------
      ELSE
        CALL U2MESK('F','UTILITAI_47',1,TYP2SD)
      END IF

   70 CONTINUE
      CALL JEDEMA()
      END

      SUBROUTINE OP0041()
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/01/2013   AUTEUR LADIER A.LADIER 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C TOLE CRP_20
C
      IMPLICIT NONE
C
C ----------------------------------------------------------------------
C
C OPERATEUR DEFI_FISS_XFEM
C
C INITIALISATION DES CHAMPS NECESSAIRES A XFEM
C        - LEVEL-SETS
C        - GRADIENTS DES LEVEL-SETS
C        - MAILLES ENRICHIES DE LA ZONE FISSURE
C        - POINTS DU FOND DE FISSURE
C
C ----------------------------------------------------------------------
C
C N.B.: TOUTE MODIFICATION EFFECTUE APRES LE CALCUL DES LEVEL SETS &
C        LEURS GRADIENT DOIT ETRE REPERCUTEE DANS OP0010 : PROPA_XFEM
C        (MIS A PART L'APPEL A SDCONX A LA FIN)
C
C CONCEPT SORTANT: FISS DE TYPE FISS_XFEM
C
C     CONDENU DE LA SD FISS_XFEM
C         FISS//'.GROUP_MA_ENRI'
C         FISS//'.GROUP_NO_ENRI'
C         FISS//'.LTNO'
C         FISS//'.LNNO'
C         FISS//'.GRLTNO'
C         FISS//'.GRLNNO'
C         FISS//'.MAILFISS.HEAV'
C         FISS//'.MAILFISS.CTIP'
C         FISS//'.MAILFISS.HECT'
C         FISS//'.MAILFISS.MAFOND'
C         FISS//'.FONDFISS'
C         FISS//'.FONDMULT'
C         FISS//'.BASLOC'
C         FISS//'.BASFOND'
C         FISS//'.INFO'
C         FISS//'.MODELE'
C
      INCLUDE 'jeveux.h'
      INTEGER      IFM,NIV,IBID,MXVAL,IRET
      INTEGER      ME1,ME2,ME3,IADRMA,ME4
      INTEGER      NDIM,JINFO,JMOD
      REAL*8       NOEUD(3),VECT1(3),VECT2(3),A,B,R,R8MAEM,DISTMA
      CHARACTER*8  FISS,NOMO,NFONF,NFONG,MAFIS,FONFIS,NOMA,METH,GRIAUX,
     &             MAIAUX
      CHARACTER*8  COTE,NCHAM,CHADIS,KBID
      CHARACTER*16 K16BID,GEOFIS,TYPDIS,CORRES
      CHARACTER*19 CNSLT,CNSLN,GRLT,GRLN,CNSEN,CNSENR,CNSLJ
      CHARACTER*19 CNSLTG,CNSLNG,GRLTG,GRLNG
      CHARACTER*19 LTNO,LNNO,GRLTNO,GRLNNO,STNOR,STNO,INFO,
     &             LTNOFA,LNNOFA,GRLTFA,GRLNFA
      CHARACTER*24 LISMAE,LISNOE
      LOGICAL      GRILLE,LDMAX
      CHARACTER*8  FISGRI
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFMAJ()
      CALL INFDBG('XFEM',IFM,NIV)
C
C --- NOM DU CONCEPT FISSURE
C
      CALL GETRES(FISS,K16BID,K16BID)
C
C --- NOM DU MODELE
C
      CALL GETVID(' ','MODELE',1,IARG,1,NOMO,IBID)
      CALL WKVECT(FISS//'.MODELE','G V K8' ,1,JMOD)
      ZK8(JMOD-1+1)=NOMO
C
C --- NOM DU MAILLAGE ATTACHE AU MODELE
C
      CALL JEVEUO(NOMO(1:8)//'.MODELE    .LGRF','L',IADRMA)
      NOMA  = ZK8(IADRMA)

C
C --- DIMENSION DU PROBLEME
      CALL DISMOI('F','DIM_GEOM',NOMA,'MAILLAGE',NDIM,KBID,IRET)

C     CHECK IF THE USER WANTS TO USE AN AUXILIARY GRID
      CALL GETVID(' ','MODELE_GRILLE',1,IARG,1,GRIAUX,IRET)
      IF (IRET.GT.0) THEN
C        YES
         GRILLE = .TRUE.
         WRITE(IFM,900)GRIAUX

C        RETREIVE THE MESH ATTACHED TO THE AUXILIARY GRID
         CALL JEVEUO(GRIAUX(1:8)//'.MODELE    .LGRF','L',IADRMA)
         MAIAUX  = ZK8(IADRMA)

C        CHECK IF THE MESH ASSOCIATED TO THE MODEL IS A SD_GRILLE
         CALL JEEXIN(MAIAUX//'.GRLI',IBID)
         IF (IBID.EQ.0) CALL U2MESK('F','XFEM2_95',1,MAIAUX)

C        THE GRID AND MODEL DIMENSIONS MUST BE THE SAME
         CALL DISMOI('F','DIM_GEOM',MAIAUX,'MAILLAGE',IBID,KBID,IRET)
         IF(IBID.NE.NDIM) CALL U2MESS('F','XFEM2_58')

C        STORE THE AUXILIARY GRID MODEL ON WHICH THE CRACK WILL BE
C        DEFINED
         CALL WKVECT(FISS(1:8)//'.GRI.MODELE','G V K8' ,1,JMOD)
         ZK8(JMOD-1+1)=GRIAUX
      ELSE
         GRILLE = .FALSE.
      ENDIF

C     CHECK IF THE USER HAS GIVEN THE CRACK FROM WHICH THE GRID MUST
C     BE COPIED
      CALL GETVID(' ','FISS_GRILLE',1,IARG,1,FISGRI,IRET)
      IF (IRET.GT.0) THEN
C        YES, THE GRID INFOS ARE DUPLICATED FOR THE NEW CRACK.
C        CHECK IF A GRID IS ASSOCIATED TO THE GIVEN CRACK.
         CALL JEEXIN(FISGRI//'.GRI.MODELE',IBID)
         IF (IBID.EQ.0) CALL U2MESS('F','XFEM_68')

         CALL JEDUPO(FISGRI//'.GRI.MODELE','G',
     &               FISS(1:8)//'.GRI.MODELE',.FALSE.)
         CALL COPISD('CHAMP','G',FISGRI//'.GRI.LNNO',
     &                           FISS(1:8)//'.GRI.LNNO')
         CALL COPISD('CHAMP','G',FISGRI//'.GRI.GRLNNO',
     &                           FISS(1:8)//'.GRI.GRLNNO')

         CALL JEEXIN(FISGRI//'.GRI.LTNO  .REFE',IBID)
         IF (IBID.GT.0) THEN
            CALL COPISD('CHAMP','G',FISGRI//'.GRI.LTNO',
     &                              FISS(1:8)//'.GRI.LTNO')
            CALL COPISD('CHAMP','G',FISGRI//'.GRI.GRLTNO',
     &                              FISS(1:8)//'.GRI.GRLTNO')
         ENDIF

         CALL JEEXIN(FISGRI//'.PRO.RAYON_TORE',IBID)
         IF (IBID.GT.0) THEN
            CALL JEDUPO(FISGRI//'.PRO.RAYON_TORE','G',
     &                  FISS(1:8)//'.PRO.RAYON_TORE',.FALSE.)
            CALL JEDUPO(FISGRI//'.PRO.NOEUD_TORE','G',
     &                  FISS(1:8)//'.PRO.NOEUD_TORE',.FALSE.)
         ENDIF

         GRILLE=.FALSE.
         WRITE(IFM,*)'  LA GRILLE AUXILIAIRE UTILISEE POUR LA FISSURE ',
     &                FISGRI
         WRITE(IFM,*)'  EST UTILISEE AUSSI POUR LA NOUVELLE FISSURE ',
     &                FISS
         WRITE(IFM,*)'  ET LES LEVEL SETS DEFINIES SUR CETTE GRILLE ONT'
     &               //' ETE PRESERVEES.'
      ENDIF

C --- OJBET INFORMATIONS : TYPE_DISCONT, CHAM_DISCONT ET TYPE_FOND
      INFO = FISS//'.INFO'
      CALL WKVECT(INFO,'G V K16',3,JINFO)
C     TYPE DE DISCONTINUITE : FISSURE OU INTERFACE
      CALL GETVTX(' ','TYPE_DISCONTINUITE',1,IARG,1,TYPDIS,IBID)
C     CHAMP DISCONTINU : DEPLACEMENTS OU CONTRAINTES
      CALL GETVTX(' ','CHAM_DISCONTINUITE',1,IARG,1,CHADIS,IBID)
      ZK16(JINFO-1+1) = TYPDIS
      ZK16(JINFO-1+2) = CHADIS
      ZK16(JINFO-1+3) = '      '

C
C --- MOT-CLEFS DEFINITION FISSURE
C
      CALL GETVID('DEFI_FISS','FONC_LT',1,IARG,1,NFONF,IBID)
      CALL GETVID('DEFI_FISS','FONC_LN',1,IARG,1,NFONG,ME1)
      IF (ME1.EQ.1.AND.IBID.EQ.0.AND.TYPDIS.EQ.'FISSURE')
     &                            CALL U2MESK('F','XFEM_24',1,'FONC_LT')
      IF (ME1.EQ.1.AND.IBID.EQ.1.AND.TYPDIS.EQ.'INTERFACE')
     &                            CALL U2MESK('A','XFEM_25',1,'FONC_LT')

      CALL GETVTX('DEFI_FISS','GROUP_MA_FISS',1,IARG,1,MAFIS,ME2)
      CALL GETVTX('DEFI_FISS','GROUP_MA_FOND',1,IARG,1,FONFIS,IBID)
      IF (ME2.EQ.1.AND.IBID.EQ.0.AND.TYPDIS.EQ.'FISSURE')
     &                      CALL U2MESK('F','XFEM_24',1,'GROUP_MA_FOND')
      IF (ME2.EQ.1.AND.IBID.EQ.1.AND.TYPDIS.EQ.'INTERFACE')
     &                      CALL U2MESK('A','XFEM_25',1,'GROUP_MA_FOND')

      MXVAL = 0
      CALL GETVTX('DEFI_FISS','FORM_FISS',1,IARG,MXVAL,GEOFIS,ME3)

      CALL GETVID('DEFI_FISS','CHAM_NO_LSN',1,IARG,1,NCHAM,ME4)
      CALL GETVID('DEFI_FISS','CHAM_NO_LST',1,IARG,1,NCHAM,IBID)
      IF (ME4.EQ.1.AND.IBID.EQ.0.AND.TYPDIS.EQ.'FISSURE')
     &                       CALL U2MESK('F','XFEM_24',1,'CHAM_NO_LST')
      IF (ME4.EQ.1.AND.IBID.EQ.1.AND.TYPDIS.EQ.'INTERFACE')
     &                       CALL U2MESK('A','XFEM_25',1,'CHAM_NO_LST')

      IF (ME3.EQ.-1) THEN
        CALL GETVTX('DEFI_FISS','FORM_FISS',1,IARG,1,GEOFIS,ME3)
        CALL GETVR8('DEFI_FISS','RAYON_CONGE',1,IARG,1,R,IBID)
        IF (GEOFIS.EQ.'ELLIPSE'  .OR.
     &      GEOFIS.EQ.'RECTANGLE'.OR.
     &      GEOFIS.EQ.'CYLINDRE') THEN
          CALL GETVR8('DEFI_FISS','DEMI_GRAND_AXE',1,IARG,1,A,IBID)
          CALL GETVR8('DEFI_FISS','DEMI_PETIT_AXE',1,IARG,1,B,IBID)
          CALL GETVR8('DEFI_FISS','CENTRE',1,IARG,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','VECT_X',1,IARG,3,VECT1,IBID)
          CALL GETVR8('DEFI_FISS','VECT_Y',1,IARG,3,VECT2,IBID)
          CALL GETVTX('DEFI_FISS','COTE_FISS',1,IARG,1,COTE,IBID)
        ELSEIF (GEOFIS.EQ.'DEMI_PLAN') THEN
          CALL GETVR8('DEFI_FISS','PFON'   ,1,IARG,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','NORMALE',1,IARG,3,VECT1,IBID)
          CALL GETVR8('DEFI_FISS','DTAN'   ,1,IARG,3,VECT2,IBID)
        ELSEIF (GEOFIS.EQ.'SEGMENT') THEN
          CALL GETVR8('DEFI_FISS','PFON_ORIG',1,IARG,3,VECT1,IBID)
          CALL GETVR8('DEFI_FISS','PFON_EXTR',1,IARG,3,VECT2,IBID)
        ELSEIF (GEOFIS.EQ.'DEMI_DROITE') THEN
          CALL GETVR8('DEFI_FISS','PFON',1,IARG,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','DTAN',1,IARG,3,VECT1,IBID)
        ELSEIF (GEOFIS.EQ.'DROITE') THEN
          CALL GETVR8('DEFI_FISS','POINT',1,IARG,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','DTAN' ,1,IARG,3,VECT1,IBID)
        ELSEIF (GEOFIS.EQ.'ENTAILLE') THEN
          CALL GETVR8('DEFI_FISS','DEMI_LONGUEUR',1,IARG,1,A,IBID)
          CALL GETVR8('DEFI_FISS','CENTRE',1,IARG,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','VECT_X',1,IARG,3,VECT1,IBID)
          CALL GETVR8('DEFI_FISS','VECT_Y',1,IARG,3,VECT2,IBID)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF

      ENDIF
C
C --- STOCKAGE DES DONNEES ORIENTATION FOND DE FISSURE
C     ON ENRICHI LA SD FISS_XFEM DE
C         FISS//'.CARAFOND'
C
      IF (TYPDIS.EQ.'FISSURE') THEN
        CALL XLORIE(FISS)
      ENDIF
C
C --- RECUPERATION DES GROUP_MA_ENRI ET GROUP_NO_ENRI
C     ON ENRICHI LA SD FISS_XFEM DE
C         FISS//'.GROUP_MA_ENRI'
C         FISS//'.GROUP_NO_ENRI'
C
      LISMAE = '&&OP0041.LISTE_MA_ENRICH'
      LISNOE = '&&OP0041.LISTE_NO_ENRICH'
      CALL XLENRI(NOMA  ,FISS  ,LISMAE,LISNOE)
C
C-----------------------------------------------------------------------
C     CALCUL DES LEVEL-SETS
C
C     ON ENRICHI LA SD FISS_XFEM DE
C         FISS//'.LTNO'
C         FISS//'.LNNO'
C
C-----------------------------------------------------------------------
C
      CNSLT  = '&&OP0041.CNSLT'
      CNSLN  = '&&OP0041.CNSLN'
      CALL CNSCRE(NOMA,'NEUT_R',1,'X1','V',CNSLT)
      CALL CNSCRE(NOMA,'NEUT_R',1,'X1','V',CNSLN)
      IF (ME1.EQ.1) THEN
        METH = 'FONCTION'
      ELSEIF (ME2.EQ.1) THEN
        METH = 'GROUP_MA'
      ELSEIF (ME3.EQ.1) THEN
        METH='GEOMETRI'
      ELSEIF (ME4.EQ.1)THEN
        METH='CHAMP'
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL XINILS(NOMA,KBID,.FALSE.,NDIM,METH,NFONF,NFONG,GEOFIS,
     &            A,B,R,NOEUD,COTE,VECT1,VECT2,CNSLT,CNSLN)
C
C --- CREATION DES CHAM_NO DES LEVEL-SETS
C
      LTNO   = FISS(1:8)//'.LTNO'
      LNNO   = FISS(1:8)//'.LNNO'
      CALL CNSCNO(CNSLT,' ','NON','G',LTNO,'F',IBID)
      CALL CNSCNO(CNSLN,' ','NON','G',LNNO,'F',IBID)
C
      IF (NIV.GE.3) THEN
        CALL IMPRSD('CHAMP',LTNO,IFM,'FISSURE.LTNO=')
        CALL IMPRSD('CHAMP',LNNO,IFM,'FISSURE.LNNO=')
      END IF

C-----------------------------------------------------------------------
C     CALCULATE THE LEVEL SETS ON THE AUXILIARY GRID
C-----------------------------------------------------------------------

      IF (GRILLE) THEN

         CNSLTG  = '&&OP0041.CNSLTG'
         CNSLNG  = '&&OP0041.CNSLNG'
         CALL CNSCRE(MAIAUX,'NEUT_R',1,'X1','V',CNSLTG)
         CALL CNSCRE(MAIAUX,'NEUT_R',1,'X1','V',CNSLNG)

         IF (METH(1:5).NE.'CHAMP') THEN
C           THE SAME METHOD "METH" IS USED
            CALL XINILS(NOMA,MAIAUX,GRILLE,NDIM,METH,NFONF,NFONG,GEOFIS,
     &                  A,B,R,NOEUD,COTE,VECT1,VECT2,CNSLTG,CNSLNG)
         ELSE
C           IF THE CHAMP_NO_S HAVE BEEN GIVEN, THEY ARE PROJECTED TO THE
C           AUXILIARY GRID. NO OTHER CALCULATIONS ARE POSSIBLE.
            IF (TYPDIS.NE.'INTERFACE') THEN
               WRITE(IFM,*)'  LES LEVEL SETS DONNEES SONT PROJETEES SUR'
     &                   //' LA GRILLE AUXILIAIRE.'
            ELSE
               WRITE(IFM,*)'  LA LEVEL SET NORMALE DONNEE EST PROJETEE'
     &                   //' SUR LA GRILLE AUXILIAIRE.'
            ENDIF

            LDMAX = .FALSE.
            DISTMA = R8MAEM()
            CORRES = '&&OP0041.CORRES'

C           CREATE THE "CONNECTION" TABLE BETWEEN THE PHYSICAL MESH AND
C           THE AUXILIARY GRID
            IF (NDIM.EQ.2) THEN
               CALL PJ2DCO('TOUT',NOMA,MAIAUX,IBID,IBID,IBID,
     &                     IBID,' ',' ',CORRES,LDMAX,DISTMA)
            ELSE
               CALL PJ3DCO('TOUT',NOMA,MAIAUX,IBID,IBID,IBID,
     &                     IBID,' ',' ',CORRES,LDMAX,DISTMA)
            ENDIF

C           PROJECT THE NORMAL LEVEL SET
            CALL CNSPRJ(CNSLN,CORRES,'G',CNSLNG,IBID)
            CALL ASSERT(IBID.EQ.0)
C           PROJECT THE TANGENTIAL LEVEL SET
            CALL CNSPRJ(CNSLT,CORRES,'G',CNSLTG,IBID)
            CALL ASSERT(IBID.EQ.0)

         ENDIF

C
C --- CREATION DES CHAM_NO DES LEVEL-SETS
C
         LTNOFA = FISS(1:8)//'.GRI.LTNO'
         LNNOFA = FISS(1:8)//'.GRI.LNNO'
         CALL CNSCNO(CNSLNG,' ','NON','G',LNNOFA,'F',IBID)
         CALL CNSCNO(CNSLTG,' ','NON','G',LTNOFA,'F',IBID)
C
         IF (NIV.GE.3) THEN
            CALL IMPRSD('CHAMP',LNNOFA,IFM,'FISSURE.GRI.LNNO=')
            CALL IMPRSD('CHAMP',LTNOFA,IFM,'FISSURE.GRI.LTNO=')
         END IF

      ENDIF

C
C-----------------------------------------------------------------------
C     CALCUL DES GRADIENTS DES LEVEL-SETS
C
C     ON ENRICHI LA SD FISS_XFEM DE
C         FISS//'.GRLTNO'
C         FISS//'.GRLNNO'
C
C-----------------------------------------------------------------------
C
      GRLT   = '&&OP0041.GRLT'
      GRLN   = '&&OP0041.GRLN'
C
      CALL XGRALS(NOMO,NOMA,LNNO,LTNO,GRLT,GRLN)
C
C --- CREATION DES CHAM_NO DES GRADIENTS DES LEVEL-SETS
C
      GRLTNO = FISS(1:8)//'.GRLTNO'
      GRLNNO = FISS(1:8)//'.GRLNNO'
      CALL CNSCNO( GRLT,' ','NON','G',GRLTNO,'F',IBID)
      CALL CNSCNO( GRLN,' ','NON','G',GRLNNO,'F',IBID)
C
      IF (NIV.GE.2) THEN
        CALL IMPRSD('CHAMP',GRLTNO,IFM,'FISSURE.GRLTNO=')
        CALL IMPRSD('CHAMP',GRLNNO,IFM,'FISSURE.GRLNNO=')
      END IF

C-----------------------------------------------------------------------
C     CALCULATE THE GRADIENTS OF THE LEVEL SETS ON THE AUXILIARY GRID
C-----------------------------------------------------------------------

      IF (GRILLE) THEN

         GRLTG   = '&&OP0041.GRLTG'
         GRLNG   = '&&OP0041.GRLNG'
C
         CALL XGRALS(GRIAUX,MAIAUX,LNNOFA,LTNOFA,GRLTG,GRLNG)

C
C --- CREATION DES CHAM_NO DES GRADIENTS DES LEVEL-SETS
C
         GRLTFA = FISS(1:8)//'.GRI.GRLTNO'
         GRLNFA = FISS(1:8)//'.GRI.GRLNNO'
         CALL CNSCNO( GRLTG,' ','NON','G',GRLTFA,'F',IBID)
         CALL CNSCNO( GRLNG,' ','NON','G',GRLNFA,'F',IBID)
C
         IF (NIV.GE.2) THEN
           CALL IMPRSD('CHAMP',GRLTFA,IFM,'FISSURE.GRI.GRLTNO=')
           CALL IMPRSD('CHAMP',GRLNFA,IFM,'FISSURE.GRI.GRLNNO=')
         END IF

         CALL DETRSD('CHAM_NO_S',CNSLTG)
         CALL DETRSD('CHAM_NO_S',CNSLNG)
         CALL DETRSD('CHAM_NO_S',GRLTG)
         CALL DETRSD('CHAM_NO_S',GRLNG)

      ENDIF

C
C-----------------------------------------------------------------------
C     CALCUL DE L'ENRICHISSEMENT, DES POINTS DU FOND DE FISSURE
C
C     ON ENRICHI LA SD FISS_XFEM DE
C         FISS//'.MAILFISS.HEAV'
C         FISS//'.MAILFISS.CTIP'
C         FISS//'.MAILFISS.HECT'
C         FISS//'.MAILFISS.MAFOND'
C         FISS//'.FONDFISS'
C         FISS//'.FONDMULT'
C
C-----------------------------------------------------------------------
C
C
C --- RECUPERATION EVENTUELLE DES FISSURES DE JONCTION
C
      CNSLJ = '&&OP0041.CNSLJ'
      CALL GETVID('JONCTION','FISSURE'  ,1,IARG,0,KBID,ME1)
      IF (ME1.LT.0) THEN
        CALL XINLSJ(NOMA,NDIM,FISS,ME1,CNSLJ)
      ENDIF

      CNSEN  = '&&OP0041.CNSEN'
      CNSENR = '&&OP0041.CNSENR'
C
      CALL XENRCH(NOMO,NOMA,CNSLT,CNSLN,CNSLJ,CNSEN,CNSENR,
     &              NDIM,FISS,LISMAE,LISNOE)
C
C --- CREATION DU CHAM_NO POUR LE STATUT DES NOEUDS
C
      STNO   = FISS(1:8)//'.STNO'
      CALL CNSCNO(CNSEN ,' ','NON','G',STNO,'F',IBID)
      IF (NIV.GE.3) THEN
        CALL IMPRSD('CHAMP',STNO,IFM,'FISSURE.STNO=')
      ENDIF
C
C --- CREATION DU CHAM_NO POUR LA VISUALISATION
C
      STNOR  = FISS(1:8)//'.STNOR'
      CALL CNSCNO(CNSENR,' ','NON','G',STNOR,'F',IBID)
C
C-----------------------------------------------------------------------
C     CALCUL DE LA BASE LOCALE AU FOND DE FISSURE
C
C     ON ENRICHI LA SD FISS_XFEM DE
C         FISS//'.BASLOC'
C
C-----------------------------------------------------------------------
C
      CALL XBASLO(NOMA  ,FISS  ,GRLT  ,GRLN  , NDIM)

C --- MENAGE
C
      CALL DETRSD('CHAM_NO_S',CNSLT)
      CALL DETRSD('CHAM_NO_S',CNSLN)
      CALL DETRSD('CHAM_NO_S',GRLT)
      CALL DETRSD('CHAM_NO_S',GRLN)
      CALL DETRSD('CHAM_NO_S',CNSEN)
      CALL DETRSD('CHAM_NO_S',CNSENR)
      CALL JEDETR(LISMAE)
      CALL JEDETR(LISNOE)
C
900   FORMAT('    LA GRILLE ',A8,' A ETE ASSOCIEE A LA FISSURE')
C
      CALL JEDEMA()
      END

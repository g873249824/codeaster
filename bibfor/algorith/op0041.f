      SUBROUTINE OP0041(IER)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/08/2009   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      INTEGER           IER
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
C OUT IER   : CODE RETOUR ERREUR COMMANDE
C               IER = 0 => TOUT S'EST BIEN PASSE
C               IER > 0 => NOMBRE D'ERREURS RENCONTREES
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
C         FISS//'.MAILFISS .INDIC'
C         FISS//'.MAILFISS  .HEAV'
C         FISS//'.MAILFISS  .CTIP'
C         FISS//'.MAILFISS  .HECT'
C         FISS//'.FONDFISS'
C         FISS//'.FONDMULT'
C         FISS//'.BASLOC'
C         FISS//'.BASFOND'
C         FISS//'.INFO'
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IFM,NIV,IBID,MXVAL
      INTEGER      ME1,ME2,ME3,IADRMA,ME4
      INTEGER      NDIM,JDIME,JINFO
      REAL*8       NOEUD(3),VECT1(3),VECT2(3),A,B
      CHARACTER*8  FISS,NOMO,NFONF,NFONG,MAFIS,FONFIS,NOMA,METH
      CHARACTER*8  COTE,NCHAM,CHADIS
      CHARACTER*16 K16BID,GEOFIS,TYPDIS
      CHARACTER*19 CNSLT,CNSLN,GRLT,GRLN,CNSEN,CNSENR
      CHARACTER*19 LTNO,LNNO,GRLTNO,GRLNNO,STNOR,STNO,INFO
      CHARACTER*24 LISMAE,LISNOE
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
      CALL GETVID(' ','MODELE',1,1,1,NOMO,IBID)

C
C --- NOM DU MAILLAGE ATTACHE AU MODELE
C
      CALL JEVEUO(NOMO(1:8)//'.MODELE    .LGRF','L',IADRMA)
      NOMA  = ZK8(IADRMA)
C
C --- DIMENSION DU PROBLEME
C
      CALL JEVEUO(NOMA//'.DIME','L',JDIME)
      NDIM  = ZI(JDIME-1+6)
      IF ((NDIM.LT.2).OR.(NDIM.GT.3)) THEN
        CALL U2MESS('F','XFEM_18')
      ENDIF

C --- OJBET INFORMATIONS : TYPE_DISCONT ET CHAM_DISCONT
      INFO = FISS//'.INFO'
      CALL WKVECT(INFO,'G V K16',2,JINFO)
C     TYPE DE DISCONTINUITE : FISSURE OU INTERFACE
      CALL GETVTX(' ','TYPE_DISCONTINUITE',1,1,1,TYPDIS,IBID)
C     CHAMP DISCONTINU : DEPLACEMENTS OU CONTRAINTES
      CALL GETVTX(' ','CHAM_DISCONTINUITE',1,1,1,CHADIS,IBID)
      ZK16(JINFO-1+1) = TYPDIS
      ZK16(JINFO-1+2) = CHADIS
C
C --- MOT-CLEFS DEFINITION FISSURE
C
      CALL GETVID('DEFI_FISS','FONC_LT',1,1,1,NFONF,IBID)
      CALL GETVID('DEFI_FISS','FONC_LN',1,1,1,NFONG,ME1)
      IF (ME1.EQ.1.AND.IBID.EQ.0.AND.TYPDIS.EQ.'FISSURE') 
     &                            CALL U2MESK('F','XFEM_24',1,'FONC_LT')
      IF (ME1.EQ.1.AND.IBID.EQ.1.AND.TYPDIS.EQ.'INTERFACE')
     &                            CALL U2MESK('A','XFEM_25',1,'FONC_LT')

      CALL GETVTX('DEFI_FISS','GROUP_MA_FISS',1,1,1,MAFIS,ME2)
      CALL GETVTX('DEFI_FISS','GROUP_MA_FOND',1,1,1,FONFIS,IBID)
      IF (ME2.EQ.1.AND.IBID.EQ.0.AND.TYPDIS.EQ.'FISSURE') 
     &                      CALL U2MESK('F','XFEM_24',1,'GROUP_MA_FOND')
      IF (ME2.EQ.1.AND.IBID.EQ.1.AND.TYPDIS.EQ.'INTERFACE')
     &                      CALL U2MESK('A','XFEM_25',1,'GROUP_MA_FOND')

      MXVAL = 0
      CALL GETVTX('DEFI_FISS','FORM_FISS',1,1,MXVAL,GEOFIS,ME3)

      CALL GETVID('DEFI_FISS','CHAM_NO_LSN',1,1,1,NCHAM,ME4)
      CALL GETVID('DEFI_FISS','CHAM_NO_LST',1,1,1,NCHAM,IBID)
      IF (ME4.EQ.1.AND.IBID.EQ.0.AND.TYPDIS.EQ.'FISSURE') 
     &                       CALL U2MESK('F','XFEM_24',1,'CHAM_NO_LST')
      IF (ME4.EQ.1.AND.IBID.EQ.1.AND.TYPDIS.EQ.'INTERFACE')
     &                       CALL U2MESK('A','XFEM_25',1,'CHAM_NO_LST')

      IF (ME3.EQ.-1) THEN
        CALL GETVTX('DEFI_FISS','FORM_FISS',1,1,1,GEOFIS,ME3)
        IF (GEOFIS.EQ.'ELLIPSE') THEN
          CALL ASSERT(NDIM.EQ.3)
          CALL GETVR8('DEFI_FISS','DEMI_GRAND_AXE',1,1,1,A,IBID)
          CALL GETVR8('DEFI_FISS','DEMI_PETIT_AXE',1,1,1,B,IBID)
          CALL GETVR8('DEFI_FISS','CENTRE',1,1,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','VECT_X',1,1,3,VECT1,IBID)
          CALL GETVR8('DEFI_FISS','VECT_Y',1,1,3,VECT2,IBID)
          CALL GETVTX('DEFI_FISS','COTE_FISS',1,1,1,COTE,IBID)
        ELSEIF (GEOFIS.EQ.'CYLINDRE') THEN
          CALL ASSERT(NDIM.EQ.3)
          CALL GETVR8('DEFI_FISS','DEMI_GRAND_AXE',1,1,1,A,IBID)
          CALL GETVR8('DEFI_FISS','DEMI_PETIT_AXE',1,1,1,B,IBID)
          CALL GETVR8('DEFI_FISS','CENTRE',1,1,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','VECT_X',1,1,3,VECT1,IBID)
          CALL GETVR8('DEFI_FISS','VECT_Y',1,1,3,VECT2,IBID)
        ELSEIF (GEOFIS.EQ.'DEMI_PLAN') THEN
          CALL ASSERT(NDIM.EQ.3)
          CALL GETVR8('DEFI_FISS','PFON'   ,1,1,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','NORMALE',1,1,3,VECT1,IBID)
          CALL GETVR8('DEFI_FISS','DTAN'   ,1,1,3,VECT2,IBID)
        ELSEIF (GEOFIS.EQ.'SEGMENT') THEN
          CALL ASSERT(NDIM.EQ.2)
          CALL GETVR8('DEFI_FISS','PFON_ORIG',1,1,3,VECT1,IBID)
          CALL GETVR8('DEFI_FISS','PFON_EXTR',1,1,3,VECT2,IBID)
        ELSEIF (GEOFIS.EQ.'DEMI_DROITE') THEN
          CALL ASSERT(NDIM.EQ.2)
          CALL GETVR8('DEFI_FISS','PFON',1,1,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','DTAN',1,1,3,VECT1,IBID)
        ELSEIF (GEOFIS.EQ.'DROITE') THEN      
          CALL ASSERT(NDIM.EQ.2)
          CALL GETVR8('DEFI_FISS','POINT',1,1,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','DTAN' ,1,1,3,VECT1,IBID)
        ELSEIF (GEOFIS.EQ.'INCLUSION') THEN
          CALL ASSERT(NDIM.EQ.2)
          CALL GETVR8('DEFI_FISS','DEMI_GRAND_AXE',1,1,1,A,IBID)
          CALL GETVR8('DEFI_FISS','DEMI_PETIT_AXE',1,1,1,B,IBID)
          CALL GETVR8('DEFI_FISS','CENTRE',1,1,3,NOEUD,IBID)
          CALL GETVR8('DEFI_FISS','VECT_X',1,1,3,VECT1,IBID)
          CALL GETVR8('DEFI_FISS','VECT_Y',1,1,3,VECT2,IBID)
        ENDIF
      ENDIF
C
C --- STOCKAGE DES DONNEES ORIENTATION FOND DE FISSURE
C     ON ENRICHI LA SD FISS_XFEM DE
C         FISS//'.CARAFOND'
C
      IF (TYPDIS.EQ.'FISSURE') THEN
        CALL XLORIE(FISS,NDIM,GEOFIS,A,NOEUD,VECT1,VECT2)
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
      CALL XINILS(IFM,NOMA,METH,NFONF,NFONG,GEOFIS,
     &            A,B,NOEUD,COTE,VECT1,VECT2,CNSLT,CNSLN)
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
      CALL XGRALS(IFM,NOMO,NOMA,FISS,GRLT,GRLN)
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
C
C-----------------------------------------------------------------------
C     CALCUL DE L'ENRICHISSEMENT, DES POINTS DU FOND DE FISSURE
C
C     ON ENRICHI LA SD FISS_XFEM DE
C         FISS//'.MAILFISS .INDIC'
C         FISS//'.MAILFISS  .HEAV'
C         FISS//'.MAILFISS  .CTIP'
C         FISS//'.MAILFISS  .HECT'
C         FISS//'.FONDFISS'
C         FISS//'.FONDMULT'
C
C-----------------------------------------------------------------------
C
      CNSEN  = '&&OP0041.CNSEN'
      CNSENR = '&&OP0041.CNSENR'
C
      CALL XENRCH(NOMO,NOMA,CNSLT,CNSLN,CNSEN,CNSENR,
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
      CALL XBASLO(NOMO  ,NOMA  ,FISS  ,GRLT  ,GRLN  , NDIM)

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
      CALL JEDEMA()
      END

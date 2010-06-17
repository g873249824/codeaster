      SUBROUTINE MERIMP(MODELE,CARELE,MATE  ,COMREF,
     &                  COMPOR,LISCHA,CARCRI,ITERAT,SDDYNA,
     &                  VALINC,SOLALG,CACO3D,NBIN  ,LPAIN ,
     &                  LCHIN)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/06/2010   AUTEUR CARON A.CARON 
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
      INTEGER       ITERAT
      CHARACTER*(*) MATE
      CHARACTER*19  LISCHA,SDDYNA,SOLALG(*)
      CHARACTER*24  MODELE,CARELE,COMPOR,COMREF
      CHARACTER*24  CARCRI,CACO3D
      CHARACTER*19  VALINC(*)
      INTEGER       NBIN
      CHARACTER*8   LPAIN(NBIN)
      CHARACTER*19  LCHIN(NBIN)
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (UTILITAIRE)
C
C PREPARATION DES CHAMPS D'ENTREE POUR RIGIDITE TANGENTE (MERIMO)
C
C ----------------------------------------------------------------------
C
C
C IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
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
      INTEGER      IBID
      INTEGER      NCHAR,JCHAR,IRET,IER
      LOGICAL      EXIGEO,EXICAR
      COMPLEX*16   C16BID
      CHARACTER*8  K8BID,NOMCHA
      CHARACTER*24 CHGEOM,CHCARA(18),CHITER,CHPESA
      CHARACTER*19 DEPENT,VITENT
      CHARACTER*19 DEPMOI,SIGMOI,VARMOI,COMMOI
      CHARACTER*19 DEPPLU,SIGPLU,VARPLU,COMPLU
      CHARACTER*19 INSMOI,VRCMOI
      CHARACTER*19 INSPLU,VRCPLU
      CHARACTER*24 VRCREF
      CHARACTER*24 VARMOJ
      CHARACTER*19 DEPKM1,VITKM1,ACCKM1
      CHARACTER*19 VITPLU,ACCPLU,ROMKM1,ROMK
      CHARACTER*24 LIGRMO
      CHARACTER*19 DDEPLA,DEPDEL,K19BLA
      CHARACTER*19 PINTTO,CNSETO,HEAVTO,LONCHA,BASLOC,LSN,LST,STANO
      CHARACTER*19 STADYN,PMILTO
      LOGICAL      NDYNLO,LDYNA
      INTEGER      IFM,NIV
      REAL*8       ITER
C
      DATA VARMOJ/'&&MERIMO.VARMOJ'/
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- INITIALISATIONS
C
      LIGRMO = MODELE(1:8)//'.MODELE'
      CHITER = '&&MERIMO.CH_ITERAT'
      CHPESA = ' '
      CALL ASSERT(MATE(9:18).EQ.'.MATE_CODE')
      K19BLA = ' '
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE')
C
C --- ACCES AUX CHARGEMENTS
C
      CALL JEEXIN(LISCHA(1:19)//'.LCHA',IRET)
      IF (IRET.EQ.0) THEN
        NCHAR = 0
      ELSE
        CALL JELIRA(LISCHA(1:19)//'.LCHA','LONMAX',NCHAR,K8BID)
      END IF
      CALL JEVEUO(LISCHA(1:19)//'.LCHA','L',JCHAR)
      NOMCHA = ZK24(JCHAR) (1:8)
C
C --- DECOMPACTION VARIABLES CHAPEAUX
C
      CALL NMCHEX(VALINC,'VALINC','DEPKM1',DEPKM1)
      CALL NMCHEX(VALINC,'VALINC','VITKM1',VITKM1)
      CALL NMCHEX(VALINC,'VALINC','ACCKM1',ACCKM1)
      CALL NMCHEX(VALINC,'VALINC','ROMKM1',ROMKM1)
      CALL NMCHEX(VALINC,'VALINC','ROMK  ',ROMK  )
      CALL NMCHEX(VALINC,'VALINC','DEPPLU',DEPPLU)
      CALL NMCHEX(VALINC,'VALINC','VITPLU',VITPLU)
      CALL NMCHEX(VALINC,'VALINC','ACCPLU',ACCPLU)
      CALL NMCHEX(VALINC,'VALINC','SIGPLU',SIGPLU)
      CALL NMCHEX(VALINC,'VALINC','VARPLU',VARPLU)
      CALL NMCHEX(VALINC,'VALINC','COMPLU',COMPLU)
      CALL NMCHEX(VALINC,'VALINC','DEPMOI',DEPMOI)            
      CALL NMCHEX(VALINC,'VALINC','SIGMOI',SIGMOI)      
      CALL NMCHEX(VALINC,'VALINC','VARMOI',VARMOI)
      CALL NMCHEX(VALINC,'VALINC','COMMOI',COMMOI)
      CALL NMCHEX(SOLALG,'SOLALG','DEPDEL',DEPDEL)
      CALL NMCHEX(SOLALG,'SOLALG','DDEPLA',DDEPLA)
C
C --- ACCES AUX OBJETS DE LA SD SDDYNA
C
      IF (LDYNA)THEN
        CALL NDYNKK(SDDYNA,'DEPENT',DEPENT)
        CALL NDYNKK(SDDYNA,'VITENT',VITENT)
        CALL NDYNKK(SDDYNA,'STADYN',STADYN)
      ELSE
        DEPENT = K19BLA
        VITENT = K19BLA
        STADYN = K19BLA
      ENDIF
C
C --- CADRE X-FEM
C
      CALL EXIXFE(MODELE,IER)
      IF (IER.NE.0) THEN
        PINTTO = MODELE(1:8)//'.TOPOSE.PIN'
        CNSETO = MODELE(1:8)//'.TOPOSE.CNS'
        HEAVTO = MODELE(1:8)//'.TOPOSE.HEA'
        LONCHA = MODELE(1:8)//'.TOPOSE.LON'
        PMILTO = MODELE(1:8)//'.TOPOSE.PMI'
        BASLOC = MODELE(1:8)//'.BASLOC'
        LSN    = MODELE(1:8)//'.LNNO'
        LST    = MODELE(1:8)//'.LTNO'
        STANO  = MODELE(1:8)//'.STNO'
      ELSE
        PINTTO = '&&MERIMO.PINTTO.BID'
        CNSETO = '&&MERIMO.CNSETO.BID'
        HEAVTO = '&&MERIMO.HEAVTO.BID'
        LONCHA = '&&MERIMO.LONCHA.BID'
        BASLOC = '&&MERIMO.BASLOC.BID'
        PMILTO = '&&MERIMO.PMILTO.BID'
        LSN    = '&&MERIMO.LNNO.BID'
        LST    = '&&MERIMO.LTNO.BID'
        STANO  = '&&MERIMO.STNO.BID'
      ENDIF
C
C --- LECTURE DES VARIABLES DE COMMANDE EN T- ET T+ ET VAL. DE REF
C
      CALL NMVCEX('TOUT',COMMOI,VRCMOI)
      CALL NMVCEX('INST',COMMOI,INSMOI)
      CALL NMVCEX('TOUT',COMPLU,VRCPLU)
      CALL NMVCEX('INST',COMPLU,INSPLU)
      CALL NMVCEX('TOUT',COMREF,VRCREF)
C
C --- VARIABLES INTERNES ISSUES DE L'ITERATION PRECEDENTE
C
      CALL EXISD('CHAMP_GD',VARPLU(1:19),IRET)
      IF (IRET.NE.0) THEN
        CALL COPISD('CHAMP_GD','V',VARPLU(1:19),VARMOJ(1:19))
      ELSE
        CALL COPISD('CHAMP_GD','V',VARMOI(1:19),VARMOJ(1:19))
      END IF
C
C --- CREATION DU CHAM_ELEM_S POUR ETENDRE LE CHAM_ELEM DE VARI_R
C
      CALL EXISD('CHAM_ELEM_S',COMPOR,IRET)
      IF (IRET.EQ.0) CALL CESVAR(CARELE,COMPOR,LIGRMO,COMPOR)
      CALL COPISD('CHAM_ELEM_S','V',COMPOR,VARPLU)
      CALL COPISD('CHAM_ELEM_S','V',COMPOR,SIGPLU)
C
C --- CHAMP DE GEOMETRIE
C
      CALL MEGEOM(MODELE,NOMCHA,EXIGEO,CHGEOM)
C
C --- CHAMP DE CARACTERISTIQUES ELEMENTAIRES
C
      CALL MECARA(CARELE(1:8),EXICAR,CHCARA)
C
C --- CHAMP POUR NUMERO DE L'ITERATION
C
      ITER   = ITERAT
      CALL MECACT('V'   ,CHITER,'MODELE',LIGRMO,'NEUT_R',
     &            1     ,'X1'   ,IBID   ,ITER   ,C16BID ,
     &            K8BID)
C
C --- CHAMP DE PESANTEUR
C
      CALL MECHPE(NCHAR,ZK24(JCHAR),CHPESA)
C
C --- REMPLISSAGE DES CHAMPS D'ENTREE
C
      LPAIN(1)  = 'PGEOMER'
      LCHIN(1)  = CHGEOM(1:19)
      LPAIN(2)  = 'PMATERC'
      LCHIN(2)  = MATE
      LPAIN(3)  = 'PCONTMR'
      LCHIN(3)  = SIGMOI(1:19)
      LPAIN(4)  = 'PVARIMR'
      LCHIN(4)  = VARMOI(1:19)
      LPAIN(5)  = 'PCOMPOR'
      LCHIN(5)  = COMPOR(1:19)
      LPAIN(6)  = 'PDEPLMR'
      LCHIN(6)  = DEPMOI(1:19)
      LPAIN(7)  = 'PDEPLPR'
      LCHIN(7)  = DEPDEL(1:19)
      LPAIN(8)  = 'PCACABL'
      LCHIN(8)  = CHCARA(10)(1:19)
      LPAIN(9)  = 'PINSTMR'
      LCHIN(9)  = INSMOI(1:19)
      LPAIN(10) = 'PINSTPR'
      LCHIN(10) = INSPLU(1:19)
      LPAIN(11) = 'PCARCRI'
      LCHIN(11) = CARCRI(1:19)
      LPAIN(12) = ' '
      LCHIN(12) = ' '
      LPAIN(13) = ' '
      LCHIN(13) = ' '
      LPAIN(14) = 'PCAGNPO'
      LCHIN(14) = CHCARA(6)(1:19)
      LPAIN(15) = 'PCAORIE'
      LCHIN(15) = CHCARA(1)(1:19)
      LPAIN(16) = 'PCADISK'
      LCHIN(16) = CHCARA(2)(1:19)
      LPAIN(17) = 'PCACOQU'
      LCHIN(17) = CHCARA(7)(1:19)
      LPAIN(18) = 'PITERAT'
      LCHIN(18) = CHITER(1:19)
      LPAIN(19) = 'PDDEPLA'
      LCHIN(19) = DDEPLA(1:19)
      LPAIN(20) = 'PDEPKM1'
      LCHIN(20) = DEPKM1(1:19)
      LPAIN(21) = 'PVITKM1'
      LCHIN(21) = VITKM1(1:19)
      LPAIN(22) = 'PACCKM1'
      LCHIN(22) = ACCKM1(1:19)
      LPAIN(23) = 'PVITPLU'
      LCHIN(23) = VITPLU(1:19)
      LPAIN(24) = 'PACCPLU'
      LCHIN(24) = ACCPLU(1:19)
      LPAIN(25) = 'PROMKM1'
      LCHIN(25) = ROMKM1(1:19)
      LPAIN(26) = 'PROMK'
      LCHIN(26) = ROMK(1:19)
      LPAIN(27) = 'PSTADYN'
      LCHIN(27) = STADYN(1:19)
      LPAIN(28) = 'PVARIMP'
      LCHIN(28) = VARMOJ(1:19)
      LPAIN(29) = 'PCAGNBA'
      LCHIN(29) = CHCARA(11)(1:19)
      LPAIN(30) = 'PCAMASS'
      LCHIN(30) = CHCARA(12)(1:19)
      LPAIN(31) = 'PCAGEPO'
      LCHIN(31) = CHCARA(5)(1:19)
      LPAIN(32) = 'PDEPENT'
      LCHIN(32) = DEPENT(1:19)
      LPAIN(33) = 'PVITENT'
      LCHIN(33) = VITENT(1:19)
      LPAIN(34) = 'PVARCMR'
      LCHIN(34) = VRCMOI(1:19)
      LPAIN(35) = 'PVARCPR'
      LCHIN(35) = VRCPLU(1:19)
      LPAIN(36) = 'PNBSP_I'
      LCHIN(36) = CHCARA(16)(1:19)
      LPAIN(37) = 'PFIBRES'
      LCHIN(37) = CHCARA(17)(1:19)
      LPAIN(38) = 'PCINFDI'
      LCHIN(38) = CHCARA(15)(1:19)
      LPAIN(39) = ' '
      LCHIN(39) = ' '
      LPAIN(40) = 'PVARCRR'
      LCHIN(40) = VRCREF(1:19)
      LPAIN(41) = 'PPESANR'
      LCHIN(41) = CHPESA(1:19)
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
      LCHIN(47) = CACO3D(1:19)
      LPAIN(48) = 'PLSN'
      LCHIN(48) = LSN
      LPAIN(49) = 'PLST'
      LCHIN(49) = LST
      LPAIN(50) = ' '
      LCHIN(50) = ' '
      LPAIN(51) = 'PSTANO'
      LCHIN(51) = STANO
      LPAIN(52) = 'PCAARPO'
      LCHIN(52) = CHCARA(9)(1:19)
      LPAIN(53) = 'PPMILTO'
      LCHIN(53) = PMILTO
C
      CALL JEDEMA()
      END

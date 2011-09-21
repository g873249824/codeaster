      SUBROUTINE OP0018()
      IMPLICIT NONE
C RESPONSABLE PELLET J.PELLET
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 21/09/2011   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C TOLE CRP_20
C     ------------------------------------------------------------------

C                   AFFE_MODELE

C     ------------------------------------------------------------------
C        REMARQUES ET RESTRICTIONS D UTILISATION

C       LES SEULES VERIFICATIONS FAITES ( FAUX=EXIT ), PORTENT SUR:
C       - L AFFECTATION D ELEMENTS FINIS A TOUTES LES MAILLES DEMANDEES
C       - L AFFECTATION D ELEMENTS FINIS A TOUS LES NOEUDS DEMANDES
C       - L AFFECTATION D ELEMENTS FINIS SUR UNE MAILLE AU MOINS
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNOM,JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER VALI(4),D1,D2
      CHARACTER*4 KIOC,CDIM
      CHARACTER*8 NOMA,NOMU,K8B,VERIF(2),EXIVF,BEVOIS
      CHARACTER*8 TYPEMA
      CHARACTER*16 K16BID
      CHARACTER*16 CONCEP,CMD,PHENOM,MODELI,LMODEL(10)
      CHARACTER*19 LIGREL
      CHARACTER*24 NOMMAI,NOMNOE,TYPMAI,GRPNOE,GRPMAI,TMPDEF
      CHARACTER*24 CPTNEM,CPTNBN,CPTLIE,CPTMAI,CPTNOE
      CHARACTER*32 PHEMOD
      LOGICAL LMAIL,LNOEU,LAXIS
      INTEGER I,I2D,I3D,IBID,ICO,IDIM,IDIM2,IFM,II,IMODEL,IMODL
      INTEGER IOC,J,JDEF,JDGM,JDGN,JDLI,JDMA,JDMA2,JDNB
      INTEGER JLGRF,JDNO,JDNW,JDPM,JDTM,JMUT,JMUT2,JNUT,JTMDIM
      INTEGER LONLIE,LONNEM,NBGREL,NBGRMA,NBGRNO,NBMAAF,NBMAIL
      INTEGER NBMPAF,NBMPCF,NBNOAF,NBNOEU,NBNPAF,NBNPCF,NBOC
      INTEGER NBOC2,NBV,NDGM,NDGN,NDMA,NDMAX,NDMAX1,NDMAX2,NDNO
      INTEGER NGM,NGN,NIV,NMA,NMGREL,NMO,NNO,NPH,NTO,NTYPOI,NUGREL
      INTEGER NUMAIL,NUMNOE,NUMSUP,NUMVEC,NUTYPE,NUTYPM,IDIM3
      INTEGER      IARG
C     ------------------------------------------------------------------


      CALL JEMARQ()

      LMAIL=.FALSE.
      LNOEU=.FALSE.
      LAXIS=.FALSE.

C     RECUPERATION DU NIVEAU D'IMPRESSION
C     -----------------------------------
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)

C ---   INITIALISATION DU NB D'ERREUR


C ---   RECUPERATION DES ARGUMENTS  DE LA COMMANDE

      CALL GETRES(NOMU,CONCEP,CMD)
      LIGREL=NOMU//'.MODELE'

C - MAILLAGE

      CALL GETVID(' ','MAILLAGE',1,IARG,1,NOMA,NBV)
      IF (NBV.EQ.0) CALL GETVID(' ','GRILLE',1,IARG,1,NOMA,NBV)

C - VERIF

      CALL GETVTX(' ','VERIF',1,IARG,2,VERIF,NBV)

C - GRANDEURS CARACTERISTIQUES

      K16BID='GRANDEUR_CARA'
      CALL GETFAC(K16BID,NBOC)
      IF (NBOC.GT.0) THEN
        CALL CETUCR(K16BID,NOMU)
      ENDIF

C - AFFE

      NDGM=0
      NDGN=0
      NDMA=0
      NDNO=0

      CALL GETFAC('AFFE',NBOC)
      CALL GETFAC('AFFE_SOUS_STRUC',NBOC2)

      DO 10 IOC=1,NBOC
        CALL CODENT(IOC,'G',KIOC)

        CALL GETVTX('AFFE','TOUT',IOC,IARG,0,K8B,NTO)
        CALL GETVEM(NOMA,'GROUP_MA','AFFE','GROUP_MA',IOC,IARG,0,K8B,
     &              NGM)
        CALL GETVEM(NOMA,'GROUP_NO','AFFE','GROUP_NO',IOC,IARG,0,K8B,
     &              NGN)
        CALL GETVEM(NOMA,'MAILLE','AFFE','MAILLE',IOC,IARG,0,K8B,NMA)
        CALL GETVEM(NOMA,'NOEUD','AFFE','NOEUD',IOC,IARG,0,K8B,NNO)


        NDGM=MAX(NDGM,-NGM)
        NDGN=MAX(NDGN,-NGN)
        NDMA=MAX(NDMA,-NMA)
        NDNO=MAX(NDNO,-NNO)
   10 CONTINUE

      NDMAX1=MAX(NDGM,NDGN)
      NDMAX2=MAX(NDMA,NDNO)
      NDMAX=MAX(NDMAX1,NDMAX2)
      IF (NDMAX.LE.0)NDMAX=1




C       -- ON TRAITE CE QUI EST COMMUN AUX MODELES AVEC ELEMENTS
C                           ET AUX MODELES AVEC SOUS-STRUCTURES
C       ---------------------------------------------------------------
      CPTNBN=NOMU//'.MODELE    .NBNO'
      CALL WKVECT(NOMU//'.MODELE    .LGRF','G V K8',2,JLGRF)
      CALL WKVECT(CPTNBN,'G V I',1,JDNB)
      ZK8(JLGRF)=NOMA
      ZI(JDNB)=0

C       -- RECHERCHE DU PHENOMENE :
      IF (NBOC.GT.0) THEN
        CALL GETVTX('AFFE','PHENOMENE',1,IARG,1,PHENOM,IBID)
      ELSEIF (NBOC2.GT.0) THEN
        CALL GETVTX('AFFE_SOUS_STRUC','PHENOMENE',1,IARG,1,PHENOM,IBID)
      ENDIF
      CALL JEECRA(NOMU//'.MODELE    .LGRF','DOCU',IBID,PHENOM(1:4))

C       -- S'IL N'Y A PAS D'ELEMENTS ON SAUTE QUELQUES ETAPES:
      IF (NBOC.EQ.0)GOTO 190

C       MODELE AVEC ELEMENTS:
C ---   RECUPERATION DES NOMS JEVEUX DU CONCEPT MAILLAGE

      NOMMAI=NOMA//'.NOMMAI'
      NOMNOE=NOMA//'.NOMNOE'
      TYPMAI=NOMA//'.TYPMAIL'
      GRPNOE=NOMA//'.GROUPENO'
      GRPMAI=NOMA//'.GROUPEMA'

C ---   CONSTRUCTION DES NOMS JEVEUX DU CONCEPT MODELE

      TMPDEF=NOMU//'.DEF'
      CALL WKVECT(TMPDEF,'V V K8',NDMAX,JDEF)

      CPTMAI=NOMU//'.MAILLE'
      CPTNOE=NOMU//'.NOEUD'
      CPTLIE=NOMU//'.MODELE    .LIEL'
      CPTNEM=NOMU//'.MODELE    .NEMA'

C     --  CREATION DES VECTEURS TAMPONS MAILLES ET NOEUDS
      CALL JELIRA(NOMMAI,'NOMMAX',NBMAIL,K8B)
      CALL JELIRA(NOMNOE,'NOMMAX',NBNOEU,K8B)
      CALL JEVEUO(TYPMAI,'L',JDTM)

      CALL WKVECT(CPTMAI,'G V I',NBMAIL,JDMA)
      CALL WKVECT(CPTNOE,'G V I',NBNOEU,JDNO)
      CALL WKVECT('&&OP0018.MAILLE','V V I',NBMAIL,JMUT)
      CALL WKVECT('&&OP0018.MAILLE2','V V I',NBMAIL,JMUT2)
      CALL WKVECT('&&OP0018.MAILLE3','V V I',NBMAIL,JDMA2)
      CALL WKVECT('&&OP0018.NOEUD','V V I',NBNOEU,JNUT)
      CALL JENONU(JEXNOM('&CATA.TM.NOMTM','POI1'),NTYPOI)
      CALL JEVEUO('&CATA.TM.TMDIM','L',JTMDIM)



      DO 110 IOC=1,NBOC
        CALL GETVTX('AFFE','PHENOMENE',IOC,IARG,1,PHENOM,NPH)
        CALL GETVTX('AFFE','MODELISATION',IOC,IARG,10,LMODEL,NMO)
        CALL ASSERT(NMO.GT.0)
        D2=-99
        CALL JERAZO(TMPDEF,NDMAX,1)
        CALL JERAZO('&&OP0018.MAILLE2',NBMAIL,1)
        CALL JERAZO('&&OP0018.MAILLE3',NBMAIL,1)

C       -- RAPPEL : LES MOTS CLES TOUT,GROUP_MA,... S'EXCLUENT
        CALL GETVTX('AFFE','TOUT',IOC,IARG,0,K8B,NTO)
        CALL GETVEM(NOMA,'GROUP_MA','AFFE','GROUP_MA',IOC,IARG,NDMAX,
     &              ZK8(JDEF),NGM)
        CALL GETVEM(NOMA,'MAILLE','AFFE','MAILLE',IOC,IARG,NDMAX,
     &              ZK8(JDEF),
     &              NMA)
        CALL GETVEM(NOMA,'GROUP_NO','AFFE','GROUP_NO',IOC,IARG,NDMAX,
     &              ZK8(JDEF),NGN)
        CALL GETVEM(NOMA,'NOEUD','AFFE','NOEUD',IOC,IARG,NDMAX,
     &              ZK8(JDEF),
     &              NNO)

        DO 90 IMODEL=1,NMO
          MODELI=LMODEL(IMODEL)
          CALL JENONU(JEXNOM('&CATA.'//PHENOM(1:13)//'.MODL',MODELI),
     &                IMODL)
          CALL JEVEUO(JEXNUM('&CATA.'//PHENOM,IMODL),'L',JDPM)

          PHEMOD=PHENOM//MODELI
          CALL DISMOI('F','DIM_TOPO',PHEMOD,'PHEN_MODE',D1,K8B,IBID)
          IF (D2.EQ.-99) THEN
            D2=D1
          ELSE
            IF (D2.NE.D1) CALL U2MESS('F','MODELISA5_51')
          ENDIF

          IF (MODELI(1:4).EQ.'AXIS' .OR.
     &        MODELI.EQ.'COQUE_AXIS')LAXIS=.TRUE.

          IF (NTO.NE.0) THEN
            LMAIL=.TRUE.
            DO 20 NUMAIL=1,NBMAIL
              NUTYPM=ZI(JDTM+NUMAIL-1)
              IF (ZI(JDPM+NUTYPM-1).GT.0) THEN
                ZI(JDMA+NUMAIL-1)=ZI(JDPM+NUTYPM-1)
                ZI(JDMA2+NUMAIL-1)=ZI(JDPM+NUTYPM-1)
              ENDIF
              ZI(JMUT+NUMAIL-1)=1
              IF (ZI(JTMDIM-1+NUTYPM).EQ.D2)ZI(JMUT2+NUMAIL-1)=1
   20       CONTINUE
          ENDIF

          IF (NGM.NE.0) THEN
            LMAIL=.TRUE.
            DO 40 I=1,NGM
              CALL JEVEUO(JEXNOM(GRPMAI,ZK8(JDEF+I-1)),'L',JDGM)
              CALL JELIRA(JEXNOM(GRPMAI,ZK8(JDEF+I-1)),'LONUTI',NBGRMA,
     &                    K8B)
              DO 30 J=1,NBGRMA
                NUMAIL=ZI(JDGM+J-1)
                NUTYPM=ZI(JDTM+NUMAIL-1)
                IF (ZI(JDPM+NUTYPM-1).GT.0) THEN
                  ZI(JDMA+NUMAIL-1)=ZI(JDPM+NUTYPM-1)
                  ZI(JDMA2+NUMAIL-1)=ZI(JDPM+NUTYPM-1)
                ENDIF
                ZI(JMUT+NUMAIL-1)=1
                IF (ZI(JTMDIM-1+NUTYPM).EQ.D2)ZI(JMUT2+NUMAIL-1)=1
   30         CONTINUE
   40       CONTINUE
          ENDIF

          IF (NMA.NE.0) THEN
            LMAIL=.TRUE.
            DO 50 I=1,NMA
              CALL JENONU(JEXNOM(NOMMAI,ZK8(JDEF+I-1)),NUMAIL)
              NUTYPM=ZI(JDTM+NUMAIL-1)
              IF (ZI(JDPM+NUTYPM-1).GT.0) THEN
                ZI(JDMA+NUMAIL-1)=ZI(JDPM+NUTYPM-1)
                ZI(JDMA2+NUMAIL-1)=ZI(JDPM+NUTYPM-1)
              ENDIF
              ZI(JMUT+NUMAIL-1)=1
              IF (ZI(JTMDIM-1+NUTYPM).EQ.D2)ZI(JMUT2+NUMAIL-1)=1
   50       CONTINUE
          ENDIF

          IF (NGN.NE.0) THEN
            LNOEU=.TRUE.
            DO 70 I=1,NGN
              CALL JEVEUO(JEXNOM(GRPNOE,ZK8(JDEF+I-1)),'L',JDGN)
              CALL JELIRA(JEXNOM(GRPNOE,ZK8(JDEF+I-1)),'LONUTI',NBGRNO,
     &                    K8B)
              DO 60 J=1,NBGRNO
                NUMNOE=ZI(JDGN+J-1)
                IF (ZI(JDPM+NTYPOI-1).GT.0)ZI(JDNO+NUMNOE-1)=ZI(JDPM+
     &              NTYPOI-1)
                ZI(JNUT+NUMNOE-1)=1
   60         CONTINUE
   70       CONTINUE
          ENDIF

          IF (NNO.NE.0) THEN
            LNOEU=.TRUE.
            DO 80 I=1,NNO
              CALL JENONU(JEXNOM(NOMNOE,ZK8(JDEF+I-1)),NUMNOE)
              IF (ZI(JDPM+NTYPOI-1).GT.0)ZI(JDNO+NUMNOE-1)=ZI(JDPM+
     &            NTYPOI-1)
              ZI(JNUT+NUMNOE-1)=1
   80       CONTINUE
          ENDIF

   90   CONTINUE

C       -- ON VERIFIE QU'A CHAQUE OCCURENCE DE AFFE, LES MAILLES
C          "PRINCIPALES" ONT BIEN ETE AFFECTEES PAR DES ELEMENTS
C          (PB DES MODELISATIONS A "TROUS") :
C          ------------------------------------------------------
        ICO=0
        DO 100 NUMAIL=1,NBMAIL
          IF ((ZI(JMUT2+NUMAIL-1).EQ.1) .AND.
     &        ZI(JDMA2+NUMAIL-1).EQ.0)ICO=ICO+1
  100   CONTINUE
        IF (ICO.GT.0) THEN
          VALI(1)=IOC
          VALI(2)=ICO
          VALI(3)=D2
          CALL U2MESG('A','MODELISA8_70',0,' ',3,VALI,0,0.D0)
        ENDIF
  110 CONTINUE


C --- VERIFICATION QUE LES MAILLES "UTILISATEUR" ONT ETE AFFECTEES
      NBMPCF=0
      NBMPAF=0
      DO 120 I=1,NBMAIL
        IF (ZI(JMUT+I-1).EQ.1) THEN
          IF (ZI(JDMA+I-1).EQ.0) THEN
            NBMPAF=NBMPAF+1
            CALL JENUNO(JEXNUM(NOMMAI,I),K8B)
            NUTYPM=ZI(JDTM+I-1)
            CALL JENUNO(JEXNUM('&CATA.TM.NOMTM',NUTYPM),TYPEMA)
            IF (NIV.EQ.2) THEN
              WRITE (IFM,*)'  MAILLE QUE L''ON N''A PAS PU AFFEC',
     &          'TER: ',K8B,' DE TYPE: ',TYPEMA
            ENDIF
          ENDIF
        ELSE
          NBMPCF=NBMPCF+1
        ENDIF
  120 CONTINUE

C --- VERIFICATION QUE LES NOEUDS "UTILISATEUR" ONT ETE AFFECTES
      NBNPCF=0
      NBNPAF=0
      DO 130 I=1,NBNOEU
        IF (ZI(JNUT+I-1).EQ.1) THEN
          IF (ZI(JDNO+I-1).EQ.0) THEN
            NBNPAF=NBNPAF+1
            CALL JENUNO(JEXNUM(NOMNOE,I),K8B)
            IF (NIV.EQ.2) THEN
              WRITE (IFM,*)'  NOEUD QUE L''ON N''A PAS PU AFFEC',
     &          'TER: ',K8B
            ENDIF
          ENDIF
        ELSE
          NBNPCF=NBNPCF+1
        ENDIF
  130 CONTINUE

C ---   DIMENSIONNEMENT DES OBJETS LIEL ET NEMA
      NBMAAF=0
      NBNOAF=0
      NUTYPE=0
      NBGREL=0

      DO 140 I=1,NBMAIL
        IF (ZI(JDMA+I-1).NE.0) THEN
          NBMAAF=NBMAAF+1
          IF (ZI(JDMA+I-1).NE.NUTYPE) THEN
            NUTYPE=ZI(JDMA+I-1)
            NBGREL=NBGREL+1
          ENDIF
        ENDIF
  140 CONTINUE


      IF (LMAIL) THEN
        II=NBMAAF+NBMPAF
        WRITE (IFM,9000)NBMAIL,NOMA,II,NBMAAF
      ENDIF

      IF (NBMAAF.EQ.0) THEN
        CALL U2MESK('F','MODELISA5_52',1,NOMA)
      ENDIF

      NUTYPE=0

      DO 150 I=1,NBNOEU
        IF (ZI(JDNO+I-1).NE.0) THEN
          NBNOAF=NBNOAF+1
          IF (ZI(JDNO+I-1).NE.NUTYPE) THEN
            NUTYPE=ZI(JDNO+I-1)
            NBGREL=NBGREL+1
          ENDIF
        ENDIF
  150 CONTINUE


      IF (LNOEU) THEN
        II=NBNOAF+NBNPAF
        WRITE (IFM,9010)NBNOEU,NOMA,II,NBNOAF
      ENDIF

      LONLIE=NBGREL+NBMAAF+NBNOAF
      LONNEM=NBNOAF*2


C ---   CREATION DES OBJETS DU CONCEPT MODELE

C -     OBJET LIEL
      CALL JECREC(CPTLIE,'G V I','NU','CONTIG','VARIABLE',NBGREL)
      CALL JEECRA(CPTLIE,'LONT',LONLIE,' ')
      CALL JEVEUO(CPTLIE,'E',JDLI)

C -     OBJET NEMA
      IF (NBNOAF.NE.0) THEN
        CALL JECREC(CPTNEM,'G V I','NU','CONTIG','VARIABLE',NBNOAF)
        CALL JEECRA(CPTNEM,'LONT',LONNEM,' ')
        CALL JEVEUO(CPTNEM,'E',JDNW)
      ENDIF

C ---   STOCKAGE DES GROUPES ELEMENTS DANS LIEL
      NUTYPE=0
      NUGREL=0
      NMGREL=0
      NUMVEC=0

      DO 160 NUMAIL=1,NBMAIL
        IF (ZI(JDMA+NUMAIL-1).NE.0) THEN
          IF (ZI(JDMA+NUMAIL-1).NE.NUTYPE .AND. NUTYPE.NE.0) THEN
            NUGREL=NUGREL+1
            NMGREL=NMGREL+1
            NUMVEC=NUMVEC+1
            ZI(JDLI+NUMVEC-1)=NUTYPE
            CALL JECROC(JEXNUM(CPTLIE,NUGREL))
            CALL JEECRA(JEXNUM(CPTLIE,NUGREL),'LONMAX',NMGREL,' ')
            NMGREL=0
          ENDIF
          NMGREL=NMGREL+1
          NUMVEC=NUMVEC+1
          ZI(JDLI+NUMVEC-1)=NUMAIL
          NUTYPE=ZI(JDMA+NUMAIL-1)
        ENDIF
        IF (NUMAIL.EQ.NBMAIL .AND. NMGREL.NE.0) THEN
          NUGREL=NUGREL+1
          NMGREL=NMGREL+1
          NUMVEC=NUMVEC+1
          ZI(JDLI+NUMVEC-1)=NUTYPE
          CALL JECROC(JEXNUM(CPTLIE,NUGREL))
          CALL JEECRA(JEXNUM(CPTLIE,NUGREL),'LONMAX',NMGREL,' ')
        ENDIF
  160 CONTINUE

      NUTYPE=0
      NUMSUP=0
      NMGREL=0

      DO 170 NUMNOE=1,NBNOEU
        IF (ZI(JDNO+NUMNOE-1).NE.0) THEN
          IF (ZI(JDNO+NUMNOE-1).NE.NUTYPE .AND. NUTYPE.NE.0) THEN
            NUGREL=NUGREL+1
            NMGREL=NMGREL+1
            NUMVEC=NUMVEC+1
            ZI(JDLI+NUMVEC-1)=NUTYPE
            CALL JECROC(JEXNUM(CPTLIE,NUGREL))
            CALL JEECRA(JEXNUM(CPTLIE,NUGREL),'LONMAX',NMGREL,' ')
            NMGREL=0
          ENDIF
          NMGREL=NMGREL+1
          NUMVEC=NUMVEC+1
          NUMSUP=NUMSUP+1
          ZI(JDLI+NUMVEC-1)=-NUMSUP
          NUTYPE=ZI(JDNO+NUMNOE-1)
        ENDIF
        IF (NUMNOE.EQ.NBNOEU .AND. NMGREL.NE.0) THEN
          NUGREL=NUGREL+1
          NMGREL=NMGREL+1
          NUMVEC=NUMVEC+1
          ZI(JDLI+NUMVEC-1)=NUTYPE
          CALL JECROC(JEXNUM(CPTLIE,NUGREL))
          CALL JEECRA(JEXNUM(CPTLIE,NUGREL),'LONMAX',NMGREL,' ')
        ENDIF
  170 CONTINUE

C ---   STOCKAGE DES NOUVELLES MAILLES DANS NEMA

      IF (NBNOAF.NE.0) THEN
        NUMVEC=0
        NUMSUP=0
        DO 180 NUMNOE=1,NBNOEU
          IF (ZI(JDNO+NUMNOE-1).NE.0) THEN
            ZI(JDNW+NUMVEC)=NUMNOE
            ZI(JDNW+NUMVEC+1)=NTYPOI
            NUMVEC=NUMVEC+2
            NUMSUP=NUMSUP+1
            CALL JECROC(JEXNUM(CPTNEM,NUMSUP))
            CALL JEECRA(JEXNUM(CPTNEM,NUMSUP),'LONMAX',2,' ')
          ENDIF
  180   CONTINUE
      ENDIF

  190 CONTINUE

C --- PRISE EN COMPTE DES SOUS-STRUCTURES (MOT CLEF AFFE_SOUS_STRUC):
      CALL SSAFMO(NOMU)


C       ---   ADAPTATION DE LA TAILLE DES GRELS
C       ----------------------------------------
      CALL ADALIG(LIGREL)

C     --- CREATION DE LA CORRESPONDANCE MAILLE --> (IGREL,IM)
C     -------------------------------------------------------
      CALL CORMGI('G',LIGREL)

C     ---   INITIALISATION DES ELEMENTS POUR CE LIGREL
C     -------------------------------------------------
      CALL INITEL(LIGREL)

C     ---   IMPRESSION DES ELEMENTS FINIS AFFECTES :
C     -------------------------------------------------
      CALL W18IMP(LIGREL,NOMA,NOMU)


C     --- VERIFICATION DE LA DIMENSION DES TYPE_ELEM DU MODELE
C     ----------------------------------------------------------
      CALL DISMOI('F','DIM_GEOM',NOMU,'MODELE',IDIM,K8B,IBID)
      IF (IDIM.GT.3) THEN
        IDIM2=0
        CALL U2MESS('A','MODELISA4_4')
      ELSE
        IDIM2=3
        IDIM3=3
        CALL DISMOI('F','Z_CST',NOMA,'MAILLAGE',IBID,CDIM,IBID)
        IF (CDIM.EQ.'OUI') THEN
          IDIM2=2
          CALL DISMOI('F','Z_ZERO',NOMA,'MAILLAGE',IBID,CDIM,IBID)
          IF (CDIM.EQ.'OUI') IDIM3=2
        ENDIF

        IF ((IDIM.EQ.3) .AND. (IDIM2.EQ.2)) THEN
C         -- LES ELEMENTS DE COQUE PEUVENT EXISTER DAS LE PLAN Z=CSTE :
        ELSEIF ((IDIM.EQ.2) .AND. (IDIM2.EQ.3)) THEN
C         -- DANGER : MODELE 2D SUR UN MAILLAGE COOR_3D
          CALL U2MESS('A','MODELISA5_53')
        ELSEIF ((IDIM.EQ.2) .AND. (IDIM2.EQ.2).AND. (IDIM3.EQ.3)) THEN
C         -- BIZARRE : MODELE 2D SUR UN MAILLAGE Z=CSTE /= 0.
          CALL U2MESS('A','MODELISA5_58')
        ENDIF
      ENDIF


C     --- VERIFICATION DU FAIT QUE POUR UN MAILLAGE 2D ON NE PEUT
C     ---- AVOIR A LA FOIS DES ELEMENTS DISCRETS 2D ET 3D :
C     ---------------------------------------------------
      CALL MODEXI(NOMU,'DIS_',I3D)
      CALL MODEXI(NOMU,'2D_DIS_',I2D)
      IF (IDIM2.EQ.2 .AND. I3D.EQ.1 .AND. I2D.EQ.1) THEN
        CALL U2MESS('F','MODELISA5_54')
      ENDIF


C     ---   VERIFICATION DES X > 0 POUR L'AXIS
C     -------------------------------------------------
      IF (LAXIS) THEN
        CALL TAXIS(NOMA,ZI(JDMA),NBMAIL)
      ENDIF


C     -- AJOUT EVENTUEL DE LA SD_PARTITION  :
C     ---------------------------------------------------
      CALL AJLIPA(NOMU,'G')


C     -- POUR LES VOLUMES FINIS, CREATION DU VOISINAGE :
C     ---------------------------------------------------
      CALL DISMOI('F','EXI_VF',LIGREL,'LIGREL',IBID,EXIVF,IBID)
C
C     -- SCHEMAS NON VF AYANT BESOIN D'UN VOISINAGE :
C     ---------------------------------------------------
      CALL DISMOI('F','BESOIN_VOISIN',LIGREL,'LIGREL',IBID,BEVOIS,IBID)
C

      IF ((BEVOIS.EQ.'OUI').OR.(EXIVF.EQ.'OUI')) CALL CREVGE(NOMA)
C
C     -- ON VERIFIE QUE LA GEOMETRIE DES MAILLES
C        N'EST PAS TROP CHAHUTEE :
C     ---------------------------------------------------
      CALL GETVTX(' ','VERI_JACOBIEN',1,IARG,1,VERIF,NBV)
      IF (VERIF(1).EQ.'OUI') CALL CALCUL('C','VERI_JACOBIEN',LIGREL,1,
     &                            NOMA//'.COORDO','PGEOMER',1,
     &                            '&&OP0018.CODRET','PCODRET','V','OUI')



      CALL JEDEMA()

 9000 FORMAT (/,' SUR LES ',I12,' MAILLES DU MAILLAGE ',A8,/,'    ON A',
     &       ' DEMANDE L''AFFECTATION DE ',I12,/,'    ON A PU EN AFFEC',
     &       'TER           ',I12)
 9010 FORMAT (/,' SUR LES ',I12,' NOEUDS  DU MAILLAGE ',A8,/,'    ON A',
     &       ' DEMANDE L''AFFECTATION DE ',I12,/,'    ON A PU EN AFFEC',
     &       'TER           ',I12)
      END

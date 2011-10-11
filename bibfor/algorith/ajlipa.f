      SUBROUTINE AJLIPA(NOMO,BASE)
      IMPLICIT   NONE
      CHARACTER*(*) NOMO
      CHARACTER*1 BASE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/10/2011   AUTEUR DESOZA T.DESOZA 
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
C RESPONSABLE PELLET J.PELLET
C ----------------------------------------------------------------------
C  BUT :
C     CREATION D'UNE SD_PARTITION DANS UN MODELE
C  REMARQUES :
C     * LA SD N'EST CREEE QUE DANS LE CAS DU PARALLELISME MPI DISTRIBUE
C     * IL FAUT APPELER CETTE ROUTINE APRES ADALIG SI CETTE DERNIERE
C       EST APPELEE (CAS DE OP0018)
C ----------------------------------------------------------------------

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32,JEXATR
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32 JEXNUM
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      CHARACTER*8 MODELE,PARTIT,MA,KBID,MOPART,VALK(3)
      CHARACTER*19 LIGR19,SDFETI
      CHARACTER*24 K24B,KDIS

      INTEGER I,RANG,NBPROC,IFM,NIV,IBID,JLGRF,NBSD,NBMA,JMAIL,IERD
      INTEGER IDD,NBMASD,I2,NMPP,NMP0,NMP0AF,ICO,NBPRO1,KRANG,NMP1,IEXI
      INTEGER ICOBIS,JFDIM,DIST0,JNUMSD,JPARSD,JFETA,VALI(3),NBMAMO,IMA
      INTEGER IGR,JNUGSD,JNOLIG,NBGREL,JREPE,JFREF
      INTEGER NUMAIL,IALIEL,ILLIEL,NBELEM,IEL,NBELGR,NBSMA

      LOGICAL PLEIN0

      REAL*8 RBID
      INTEGER      IARG

C     NUMAIL(IGR,IEL)=NUMERO DE LA MAILLE ASSOCIEE A L'ELEMENT IEL
      NUMAIL(IGR,IEL)=ZI(IALIEL-1+ZI(ILLIEL-1+IGR)-1+IEL)
      DATA K24B /' '/

C-----------------------------------------------------------------------

      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)

C ----------------------------------------------------------------------
C
C     VERIFICATIONS ET INITIALISATIONS
C
C ----------------------------------------------------------------------

      MODELE = NOMO
      LIGR19 = MODELE//'.MODELE'
      CALL JEVEUO(LIGR19//'.LGRF','E',JLGRF)

C     -- S'IL N'Y A PAS D'ELEMENTS FINIS DANS LE MODELE :
C     ---------------------------------------------------
      CALL JEEXIN(LIGR19//'.LIEL',IEXI)
      IF (IEXI.EQ.0) GOTO 99

      CALL JELIRA(LIGR19//'.LIEL','NUTIOC',NBGREL,KBID)
      CALL JEVEUO(LIGR19//'.LIEL','L',IALIEL)
      CALL JEVEUO(JEXATR(LIGR19//'.LIEL','LONCUM'),'L',ILLIEL)
      CALL JEVEUO(LIGR19//'.REPE','L',JREPE)

C     -- S'IL EXISTE DEJA UNE PARTITION, ON LA DETRUIT :
C     --------------------------------------------------
      PARTIT = ZK8(JLGRF-1+2)
      IF (PARTIT.NE.' ') THEN
        CALL DETRSD('PARTITION',PARTIT)
        ZK8(JLGRF-1+2) = ' '
      ENDIF

C     -- S'IL N'A QU'UN SEUL PROC, IL N'Y A RIEN A FAIRE :
C     ----------------------------------------------------
      NBPROC = 1
      RANG   = 0
      CALL MPICM0(RANG,NBPROC)
      IF (NBPROC.LE.1) GOTO 99

C     -- SI LE MODELE N'A PAS DE MAILLES, IL N'Y A RIEN A FAIRE :
C     -----------------------------------------------------------
      CALL JEEXIN(MODELE//'.MAILLE',IEXI)
      IF (IEXI.EQ.0) GOTO 99

C     -- SI L'UTILISATEUR NE VEUT PAS DE DISTRIBUTION DES CALCULS,
C        IL N'Y A RIEN A FAIRE :
C     ------------------------------------------------------------
      CALL GETVTX('PARTITION','PARALLELISME',1,IARG,1,KDIS,IBID)
      IF (KDIS.EQ.'CENTRALISE') GOTO 99

C     -- EN DISTRIBUE, LES SOUS-STRUCTURES SONT INTERDITES :
C     ------------------------------------------------------
      CALL DISMOI('F','NOM_MAILLA',MODELE,'MODELE',IBID,MA,IERD)
      CALL DISMOI('F','NB_SM_MAILLA',MA,'MAILLAGE',NBSMA,KBID,IERD)
      IF (NBSMA.GT.0) THEN
        CALL U2MESS('F','ALGORITH16_91')
      ENDIF

C ----------------------------------------------------------------------
C
C     LECTURE DES MOT-CLES ET VERIFICATIONS SUPPLEMENTAIRES
C     CREATION DE LA SD
C
C ----------------------------------------------------------------------

      DIST0 = 0
      SDFETI = ' '
      CALL GCNCON('_',PARTIT)
      ZK8(JLGRF-1+2) = PARTIT

C     ALLOCATION DE L'OBJET 'SD_PARTITION.NUPROC.MAILLE' :
C     ----------------------------------------------------
      CALL JEVEUO(MODELE//'.MAILLE','L',JMAIL)
      CALL JELIRA(MODELE//'.MAILLE','LONMAX',NBMA,K24B)
      CALL WKVECT(PARTIT//'.NUPROC.MAILLE',BASE//' V I',NBMA+1,JNUMSD)
      ZI(JNUMSD-1+NBMA+1) = NBPROC

C     NBMAMO : NBRE DE MAILLES DU MODELE
      NBMAMO = 0
      DO 10 IMA = 1,NBMA
        ZI(JNUMSD-1+IMA) = -999
        IF (ZI(JMAIL-1+IMA).NE.0)NBMAMO = NBMAMO+1
   10 CONTINUE

C     -- RECUPERATIONS DES MOT-CLES :
C     -------------------------------

      IF (KDIS.EQ.'SOUS_DOMAINE') THEN
        CALL GETVIS('PARTITION','CHARGE_PROC0_SD',1,IARG,1,DIST0,IBID)
        CALL GETVID('PARTITION','PARTITION',1,IARG,1,SDFETI,IBID)
      ELSEIF (KDIS(1:4).EQ.'MAIL') THEN
        CALL GETVIS('PARTITION','CHARGE_PROC0_MA',1,IARG,1,DIST0,IBID)
      ENDIF

C     -- VERIFICATION POUR LE CAS DU PARTITIONNEMENT EN SOUS-DOMAINES : 
C     -----------------------------------------------------------------
      IF (KDIS.EQ.'SOUS_DOMAINE') THEN
        CALL JEVEUO(SDFETI//'.FREF','L',JFREF)
        MOPART = ZK8(JFREF-1+1)
        IF (MODELE.NE.MOPART) THEN
          VALK(1) = SDFETI(1:8)
          VALK(2) = MODELE
          VALK(3) = MOPART
          CALL U2MESK('F','ALGORITH17_17',3,VALK)
        ENDIF
      ENDIF

C     -- VERIFICATIONS SUR LE NOMBRE DE MAILLES OU DE SOUS-DOMAINES :
C        PAR RAPPORT AU NOMBRE DE PROCESSEURS
C     ---------------------------------------------------------------
      IF (KDIS.EQ.'SOUS_DOMAINE') THEN
        CALL JEVEUO(SDFETI//'.FDIM','L',JFDIM)
        NBSD = ZI(JFDIM-1+1)
C       IL FAUT AU MOINS UN SD PAR PROC HORS PROC0
        IF (((NBSD-DIST0).LT.(NBPROC-1)) .AND. (DIST0.GT.0)) THEN
          CALL U2MESS('F','ALGORITH16_99')
        ENDIF
        IF ((NBSD.LT.NBPROC) .AND. (DIST0.EQ.0)) THEN
          VALI(1) = NBSD
          VALI(2) = NBPROC
          CALL U2MESI('F','ALGORITH17_1',2,VALI)
        ENDIF
      ELSEIF (KDIS(1:4).EQ.'MAIL') THEN
C       IL FAUT AU MOINS UNE MAILLE PAR PROC
        IF (NBMAMO.LT.NBPROC) THEN
          VALI(1) = NBMAMO
          VALI(2) = NBPROC
          CALL U2MESI('F','ALGORITH16_93',2,VALI)
        ENDIF
      ELSEIF (KDIS.EQ.'GROUP_ELEM') THEN
C       IL FAUT AU MOINS UN GREL PAR PROC
        IF (NBGREL.LT.NBPROC) THEN
          VALI(1) = NBGREL
          VALI(2) = NBPROC
          CALL U2MESI('F','ALGORITH16_97',2,VALI)
        ENDIF
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

C ----------------------------------------------------------------------
C
C     REMPLISSAGE DE LA SD
C
C ----------------------------------------------------------------------

      IF (KDIS.EQ.'SOUS_DOMAINE') THEN
C     --------------------------------
        CALL WKVECT('&&AJLIPA.PARTITION.SD','V V I',NBSD,JPARSD)
        CALL SDPART(NBSD  ,DIST0 ,ZI(JPARSD))
        DO 30 IDD = 1,NBSD
          IF (ZI(JPARSD-1+IDD).EQ.1) THEN
            CALL JEVEUO(JEXNUM(SDFETI//'.FETA',IDD),'L',JFETA)
            CALL JELIRA(JEXNUM(SDFETI//'.FETA',IDD),'LONMAX',NBMASD,
     &                  K24B)
            DO 20 I = 1,NBMASD
              I2 = ZI(JFETA-1+I)
              IF (ZI(JNUMSD-1+I2).NE.-999) THEN
C               -- MAILLE COMMUNE A PLUSIEURS SOUS-DOMAINES
                VALI(1) = I2
                CALL U2MESI('F','ALGORITH16_98',1,VALI)
              ELSE
                ZI(JNUMSD-1+I2) = RANG
              ENDIF
   20       CONTINUE
          ENDIF
   30   CONTINUE
        CALL MPICM1('MPI_MAX','I',NBMA,ZI(JNUMSD),RBID)
        CALL JEDETR('&&AJLIPA.PARTITION.SD')

      ELSEIF (KDIS.EQ.'MAIL_DISPERSE') THEN
C     -------------------------------------
C       -- LE PROC 0 A UNE CHARGE DIFFERENTE DES AUTRES (DIST0) :
C       NMPP NBRE DE MAILLES PAR PROC (A LA LOUCHE)
        NMPP = MAX(1,NBMAMO/NBPROC)
C       NMP0 NBRE DE MAILLES AFFECTEES AU PROC0 (A LA LOUCHE)
        NMP0 = (DIST0*NMPP)/100

C       -- AFFECTATION DES MAILLES AUX DIFFERENTS PROCS :
        NMP0AF = 0
        ICO = 0
        NBPRO1 = NBPROC
        PLEIN0 = .FALSE.
        DO 40,IMA = 1,NBMA
          IF (ZI(JMAIL-1+IMA).EQ.0)GOTO 40
          ICO = ICO+1
          KRANG = MOD(ICO,NBPRO1)
          IF (PLEIN0)KRANG = KRANG+1
          IF (KRANG.EQ.0)NMP0AF = NMP0AF+1
          ZI(JNUMSD-1+IMA) = KRANG
          IF (NMP0AF.EQ.NMP0) THEN
            PLEIN0 = .TRUE.
            NBPRO1 = NBPROC-1
          ENDIF
   40   CONTINUE

      ELSEIF (KDIS.EQ.'GROUP_ELEM') THEN
C     ----------------------------------
        CALL WKVECT(PARTIT//'.NUPROC.GREL',BASE//' V I',NBGREL,JNUGSD)
        CALL WKVECT(PARTIT//'.NUPROC.LIGREL',BASE//' V K24',1,JNOLIG)
        ZK24(JNOLIG-1+1) = LIGR19
        DO 42,IGR = 1,NBGREL
          ZI(JNUGSD-1+IGR) = MOD(IGR,NBPROC)
   42   CONTINUE

C       -- AFFECTATION DES MAILLES AUX DIFFERENTS PROCS :
        DO 41,IMA = 1,NBMA
          IF (ZI(JMAIL-1+IMA).EQ.0)GOTO 41
          IGR = ZI(JREPE-1+2*(IMA-1)+1)
          KRANG = ZI(JNUGSD-1+IGR)
          ZI(JNUMSD-1+IMA) = KRANG
   41   CONTINUE

C       -- ON NE PEUT PAS "SAUTER" 1 GREL DANS CALCUL SI
C          CELUI-CI CONTIENT DES MAILLES TARDIVES
C          => ON MODIFIE .NUPROC.GREL :
        DO 43,IGR = 1,NBGREL
           NBELGR = NBELEM(LIGR19,IGR)
           DO 44 IEL = 1,NBELGR
             IMA = NUMAIL(IGR,IEL)
             IF (IMA.LT.0) THEN
               ZI(JNUGSD-1+IGR) = -1
               GOTO 43
             ENDIF
   44      CONTINUE
   43   CONTINUE

      ELSEIF (KDIS.EQ.'MAIL_CONTIGU') THEN
C       ----------------------------------
C       NMP0 NBRE DE MAILLES AFFECTEES AU PROC0 :
        NMPP = MAX(1,NBMAMO/NBPROC)
        NMP0 = (DIST0*NMPP)/100
        NMP1 = ((NBMAMO-NMP0)/(NBPROC-1))+1

C       -- AFFECTATION DES MAILLES AUX DIFFERENTS PROCS :
C          ON AFFECTE LES 1ERES MAILLES AU PROC0 PUIS LES AUTRES
C          AUX AUTRES PROCS.
        NMPP = NMP0
        KRANG = 0
        ICO = 0
        DO 50,IMA = 1,NBMA
          IF (ZI(JMAIL-1+IMA).EQ.0)GOTO 50
          ICO = ICO+1
C         -- ON CHANGE DE PROC :
          IF (ICO.GT.NMPP) THEN
            ICO = 1
            NMPP = NMP1
            KRANG = KRANG+1
          ENDIF
          ZI(JNUMSD-1+IMA) = KRANG
   50   CONTINUE

C       -- ON VERIFIE QUE TOUTES LES MAILLES SONT DISTRIBUEES :
        ICO = 0
        ICOBIS = 0
        DO 60 I = 1,NBMA
          IF (ZI(JNUMSD-1+I).GE.0)ICO = ICO+1
          IF (ZI(JNUMSD-1+I).EQ.RANG)ICOBIS = ICOBIS+1
   60   CONTINUE
        CALL ASSERT(ICO.EQ.NBMAMO)
      
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF


   99 CONTINUE

      CALL JEDEMA()
      END

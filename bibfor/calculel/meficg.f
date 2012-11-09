      SUBROUTINE MEFICG(OPTIOZ,RESULT,MODELE,DEPLA ,THETA ,
     &                  MATE  ,NCHAR ,LCHAR ,SYMECH,FONDF ,
     &                  NOEUD ,TIME  ,IORD  ,PULS  ,NBPRUP,
     &                  NOPRUP,LMELAS,NOMCAS,COMPOR)
      IMPLICIT NONE

      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNOM
      CHARACTER*8 MODELE,LCHAR(*),FONDF,RESULT,SYMECH
      CHARACTER*8 NOEUD
      CHARACTER*16 OPTIOZ,NOPRUP(*),NOMCAS
      CHARACTER*24 DEPLA,MATE,THETA,COMPOR
      REAL*8 TIME,PULS
      INTEGER IORD,NCHAR,NBPRUP
      LOGICAL LMELAS
C ......................................................................
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 09/11/2012   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRS_1404
C TOLE CRP_21
C     - FONCTION REALISEE:   CALCUL DES COEFFICIENTS D'INTENSITE DE
C                            CONTRAINTES K1 ET K2 EN 2D

C IN   OPTION  --> CALC_K_G   (SI CHARGES REELLES)
C              --> CALC_K_G_F (SI CHARGES FONCTIONS)
C              --> CALC_K_X   (SI FISSURE X-FEM)
C IN   RESULT  --> NOM UTILISATEUR DU RESULTAT ET TABLE
C IN   MODELE  --> NOM DU MODELE
C IN   DEPLA   --> CHAMPS DE DEPLACEMENT
C IN   THETA   --> CHAMP THETA
C IN   MATE    --> CHAMP DE MATERIAUX
C IN   NCHAR   --> NOMBRE DE CHARGES
C IN   LCHAR   --> LISTE DES CHARGES
C IN   SYMECH  --> SYMETRIE DU CHARGEMENT
C IN   FONDF   --> FOND DE FISSURE
C IN   NOEUD   --> NOM DU NOEUD DU FOND
C IN   EXTIM   --> VRAI SI L'INSTANT EST DONNE
C IN   TIME    --> INSTANT DE CALCUL
C IN   IORD    --> NUMERO D'ORDRE DE LA SD
C IN   NBPRUP   --> NOMBRE DE PARAMETRES RUPTURE DANS LA TABLE
C IN   NOPRUP   --> NOMS DES PARAMETRES RUPTURE
C IN   LMELAS   --> TRUE SI LE TYPE DE LA SD RESULTAT = MULT_ELAS
C IN   NOMCAS   --> NOM DU CAS DE CHARGE SI LMELAS
C ......................................................................
C CORPS DU PROGRAMME
C TOLE CRP_21

      INTEGER      NBINMX,NBOUMX
      PARAMETER   (NBINMX=50,NBOUMX=1)
      CHARACTER*8  LPAIN(NBINMX),LPAOUT(NBOUMX)
      CHARACTER*24 LCHIN(NBINMX),LCHOUT(NBOUMX)

      INTEGER      I,IBID,IFIC,INORMA,INIT,IFM,NIV,JNOR,VALI(2),JBASFO
      INTEGER      IADRMA,IADRFF,ICOODE,IADRCO,IADRNO,NEXCI
      INTEGER      LOBJ2,NDIMTE,NUNOFF,NDIM,NCHIN,IER,IXFEM,JFOND,NUMFON
      INTEGER      IRET
      REAL*8       FIC(5),RCMP(4),VAL(5)
      INTEGER      MXSTAC
      COMPLEX*16   CBID
      LOGICAL      EXIGEO,FONC,EPSI
      PARAMETER   (MXSTAC=1000)
      CHARACTER*2  CODRET
      CHARACTER*8  NOMA,FOND,LICMP(4),TYPMO,FISS, MOSAIN
      CHARACTER*8  K8BID
      CHARACTER*16 OPTION,OPTIO2,VALK
      CHARACTER*19 CF1D2D,CHPRES,CHROTA,CHPESA,CHVOLU,CF2D3D,CHEPSI
      CHARACTER*19 CHVREF,CHVARC
      CHARACTER*19 BASEFO
      CHARACTER*19 BASLOC,PINTTO,CNSETO,HEAVTO,LONCHA,LNNO,LTNO,PMILTO
      CHARACTER*19 PINTER,AINTER,CFACE,LONGCO,BASECO
      CHARACTER*24 CHGEOM,CHFOND
      CHARACTER*24 LIGRMO,NOMNO,NORMA
      CHARACTER*24 OBJ1,OBJ2,COORD,COORN,CHTIME
      CHARACTER*24 PAVOLU,PA1D2D,PAPRES,CHPULS,CHSIGI

      CHARACTER*1 K1BID
      INTEGER      IARG
      DATA CHVARC/'&&MEFICG.CH_VARC_R'/
      DATA CHVREF/'&&MEFICG.CHVREF'/


      CALL JEMARQ()

C     VERIF QUE LES TABLEAUX LOCAUX DYNAMIQUES NE SONT PAS TROP GRANDS
C     (VOIR CRS 1404)
      CALL ASSERT(NCHAR.LE.MXSTAC)

      CALL INFNIV(IFM,NIV)
      OPTION = OPTIOZ
      IF (OPTIOZ .EQ. 'CALC_K_X') OPTION = 'CALC_K_G'

C- RECUPERATION DU CHAMP GEOMETRIQUE

      CALL MEGEOM(MODELE,' ',EXIGEO,CHGEOM)
      NOMA = CHGEOM(1:8)

C- RECUPERATION DE L'ETAT INITIAL (NON TRAITE DANS CETTE OPTION)

      CALL GETVID('COMP_INCR','SIGM_INIT',1,IARG,1,CHSIGI,INIT)
      IF (INIT.NE.0) THEN
        VALK='CALC_K_G'
        CALL U2MESK('F','RUPTURE1_13',1,VALK)
      END IF


C- RECUPERATION (S'ILS EXISTENT) DES CHAMP DE TEMPERATURES (T,TREF)
      CALL VRCINS(MODELE,MATE,'BIDON',TIME,CHVARC,CODRET)
      CALL VRCREF(MODELE,MATE(1:8),'BIDON   ',CHVREF(1:19))

C - TRAITEMENT DES CHARGES

      CHVOLU = '&&MEFICG.VOLU'
      CF1D2D = '&&MEFICG.1D2D'
      CF2D3D = '&&MEFICG.2D3D'
      CHPRES = '&&MEFICG.PRES'
      CHEPSI = '&&MEFICG.EPSI'
      CHPESA = '&&MEFICG.PESA'
      CHROTA = '&&MEFICG.ROTA'
      CALL GCHARG(MODELE,NCHAR,LCHAR,CHVOLU,CF1D2D,CF2D3D,CHPRES,CHEPSI,
     &            CHPESA,CHROTA,FONC,EPSI,TIME,IORD)
      IF (FONC) THEN
        PAVOLU = 'PFFVOLU'
        PA1D2D = 'PFF1D2D'
        PAPRES = 'PPRESSF'
        IF (OPTION.EQ.'CALC_DK_DG_E') THEN
          OPTION = 'CALC_DK_DG_E_F'
        ELSE IF (OPTION.EQ.'CALC_DK_DG_FORC') THEN
          OPTION = 'CALC_DK_DG_FORCF'
        ELSE
          OPTION = 'CALC_K_G_F'
        END IF
        OPTIO2 = 'CALC_K_G_F'

      ELSEIF (OPTION .EQ. 'K_G_MODA') THEN
        CALL GETFAC('EXCIT',NEXCI)

        IF (NEXCI.EQ.0) THEN
C           CALL U2MESS('A','RUPTURE1_50')
           PAVOLU = 'PFRVOLU'
           PA1D2D = 'PFR1D2D'
           PAPRES = 'PPRESSR'
           CALL MEFOR0 ( MODELE, CHVOLU, .FALSE. )
           CALL MEFOR0 ( MODELE, CF1D2D, .FALSE. )
           CALL MEPRES ( MODELE, CHPRES, .FALSE. )
           OPTIO2 = 'K_G_MODA'
       ENDIF

      ELSE
        PAVOLU = 'PFRVOLU'
        PA1D2D = 'PFR1D2D'
        PAPRES = 'PPRESSR'
        OPTIO2 = 'CALC_K_G'
      END IF
C
C OBJET DECRIVANT LE MAILLAGE

      OBJ1 = MODELE//'.MODELE    .LGRF'
      CALL JEVEUO(OBJ1,'L',IADRMA)
      NOMA = ZK8(IADRMA)
      NOMNO = NOMA//'.NOMNOE'
      COORN = NOMA//'.COORDO    .VALE'
      COORD = NOMA//'.COORDO    .DESC'
      CALL JEVEUO(COORN,'L',IADRCO)
      CALL JEVEUO(COORD,'L',ICOODE)
      NDIM = -ZI(ICOODE-1+2)

C
C     CAS X-FEM
C     MOSAIN = MODELE ISSU DE AFFE_MODELE
      CALL GETVID ( 'THETA','FISSURE', 1,IARG,1, FISS, IXFEM )
      IF (IXFEM.GT.0) THEN
        CALL DISMOI('F','NOM_MODELE',FISS,'FISS_XFEM',IBID,MOSAIN,IER)
        CALL DISMOI('F','MODELISATION',MOSAIN,'MODELE',IBID,TYPMO,IER)
      ELSE
        CALL DISMOI('F','MODELISATION',MODELE,'MODELE',IBID,TYPMO,IER)
      ENDIF
C
C     OBJET CONTENANT LES NOEUDS DU FOND DE FISSURE
      IF (IXFEM.EQ.0) THEN
        FOND = FONDF(1:8)
        OBJ2 = FOND//'.FOND.NOEU'
        CALL JELIRA(OBJ2,'LONMAX',LOBJ2,K1BID)
        IF (LOBJ2.NE.1) THEN
          CALL U2MESS('F','RUPTURE1_10')
        END IF
        CALL JEVEUO(OBJ2,'L',IADRNO)
        CALL JENONU(JEXNOM(NOMNO,ZK8(IADRNO)),NUNOFF)

C       OBJET CONTENANT LA BASE LOCALE AU FOND DE FISSURE
C       SI L'OBJET NORMALE EXISTE, ON LE PREND
C       SINON, ON PREND BASEFOND
        NORMA = FOND//'.NORMALE'
        CALL JEEXIN(NORMA,IRET)
        IF (IRET.NE.0) THEN
          CALL JEVEUO(NORMA,'L',INORMA)
          RCMP(3) = ZR(INORMA-1+1)
          RCMP(4) = ZR(INORMA-1+2)
        ELSEIF (IRET.EQ.0) THEN
          BASEFO = FOND//'.BASEFOND'
          CALL JEVEUO(BASEFO,'L',JBASFO)
C         ATTENTION, ON NE SE SERT PAS DU VECTEUR NORMAL DE BASEFOND
C         MAIS ON FAIT TOURNER DE 90 DEGRES LE VECTEUR DE PROPA
          RCMP(3) = -ZR(JBASFO-1+4)
          RCMP(4) = ZR(JBASFO-1+3)
        END IF
      ENDIF


C     CREATION OBJET CONTENANT COORDONNEES DU NOEUD DE FOND
C     DE FISSURE ET LA NORMALE A LA FISSURE
      CHFOND = '&&MEFICG.FOND'
      CALL WKVECT(CHFOND,'V V R8',4,IADRFF)

      LICMP(1) = 'XA'
      LICMP(2) = 'YA'
      LICMP(3) = 'XNORM'
      LICMP(4) = 'YNORM'
      IF (IXFEM.EQ.0) THEN
        RCMP(1) = ZR(IADRCO+NDIM* (NUNOFF-1))
        RCMP(2) = ZR(IADRCO+NDIM* (NUNOFF-1)+1)
      ELSE
        CALL JEVEUO(FISS//'.FONDFISS','L',JFOND)
        CALL GETVIS('THETA','NUME_FOND',1,IARG,1,NUMFON,IBID)
        RCMP(1) = ZR(JFOND-1+4*(NUMFON-1)+1)
        RCMP(2) = ZR(JFOND-1+4*(NUMFON-1)+2)
        CALL JEVEUO(FISS//'.BASEFOND','L',JNOR)
        RCMP(3) =  -ZR(JNOR-1+4*(NUMFON-1)+4)
        RCMP(4) =  ZR(JNOR-1+4*(NUMFON-1)+3)
        WRITE(IFM,*)'   '
        WRITE(IFM,*)'    TRAITEMENT DU FOND DE FISSURE NUMERO ',NUMFON
        WRITE(IFM,*)'    NOMME ',NOEUD
        WRITE(IFM,*)'    DE COORDONNEES',RCMP(1),RCMP(2)
        WRITE(IFM,*)'    LA NORMALE A LA FISSURE EN CE POINT EST ',
     &                                              RCMP(3),RCMP(4)
      ENDIF
      ZR(IADRFF)   = RCMP(1)
      ZR(IADRFF+1) = RCMP(2)
      ZR(IADRFF+2) = RCMP(3)
      ZR(IADRFF+3) = RCMP(4)

      CALL MECACT('V',CHFOND,'MAILLA',NOMA,'FISS_R',4,LICMP,IBID,RCMP,
     &            CBID,' ')


C --- RECUPERATION DES DONNEES XFEM (TOPOSE)
      PINTTO = MODELE//'.TOPOSE.PIN'
      CNSETO = MODELE//'.TOPOSE.CNS'
      HEAVTO = MODELE//'.TOPOSE.HEA'
      LONCHA = MODELE//'.TOPOSE.LON'
      PMILTO = MODELE//'.TOPOSE.PMI'
C     ON NE PREND PAS LES LSN ET LST DU MODELE
C     CAR LES CHAMPS DU MODELE SONT DEFINIS QUE AUTOUR DE LA FISSURE
C     OR ON A BESOIN DE LSN ET LST MEME POUR LES �L�MENTS CLASSIQUES
      LNNO   = FISS//'.LNNO'
      LTNO   = FISS//'.LTNO'
      BASLOC = FISS//'.BASLOC'

C --- RECUPERATION DES DONNEES XFEM (TOPOFAC)
      PINTER = MODELE//'.TOPOFAC.OE'
      AINTER = MODELE//'.TOPOFAC.AI'
      CFACE  = MODELE//'.TOPOFAC.CF'
      LONGCO = MODELE//'.TOPOFAC.LO'
      BASECO = MODELE//'.TOPOFAC.BA'

      NDIMTE = 5
      CALL WKVECT('&&MEFICG.VALG','V V R8',NDIMTE,IFIC)
      LPAOUT(1) = 'PGTHETA'
      LCHOUT(1) = '&&FICGELE'

      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PDEPLAR'
      LCHIN(2) = DEPLA
      LPAIN(3) = 'PTHETAR'
      LCHIN(3) = THETA
      LPAIN(4) = 'PMATERC'
      LCHIN(4) = MATE
      LPAIN(5) = 'PVARCPR'
      LCHIN(5) = CHVARC
      LPAIN(6) = 'PVARCRR'
      LCHIN(6) = CHVREF
      LPAIN(7) = PAVOLU(1:8)
      LCHIN(7) = CHVOLU
      LPAIN(8) = PA1D2D(1:8)
      LCHIN(8) = CF1D2D
      LPAIN(9) = PAPRES(1:8)
      LCHIN(9) = CHPRES
      LPAIN(10) = 'PPESANR'
      LCHIN(10) = CHPESA
      LPAIN(11) = 'PROTATR'
      LCHIN(11) = CHROTA
      LPAIN(12) = 'PFISSR'
      LCHIN(12) = CHFOND

      LPAIN(13) = 'PBASLOR'
      LCHIN(13) = BASLOC
      LPAIN(14) = 'PPINTTO'
      LCHIN(14) = PINTTO
      LPAIN(15) = 'PCNSETO'
      LCHIN(15) = CNSETO
      LPAIN(16) = 'PHEAVTO'
      LCHIN(16) = HEAVTO
      LPAIN(17) = 'PLONCHA'
      LCHIN(17) = LONCHA
      LPAIN(18) = 'PLSN'
      LCHIN(18) = LNNO
      LPAIN(19) = 'PLST'
      LCHIN(19) = LTNO

      LPAIN(20) = 'PCOMPOR'
      LCHIN(20) = COMPOR

      LPAIN(21) = 'PPMILTO'
      LCHIN(21) = PMILTO

      LPAIN(22) = 'PPINTER'
      LCHIN(22) = PINTER
      LPAIN(23) = 'PAINTER'
      LCHIN(23) = AINTER
      LPAIN(24) = 'PCFACE'
      LCHIN(24) = CFACE
      LPAIN(25) = 'PLONGCO'
      LCHIN(25) = LONGCO
      LPAIN(26) = 'PBASECO'
      LCHIN(26) = BASECO

      LIGRMO = MODELE//'.MODELE'
      NCHIN = 26
      CHTIME = '&&MEFICG.CH_INST_R'
      IF (OPTION.EQ.'CALC_K_G_F'    .OR.
     &    OPTION.EQ.'CALC_DK_DG_E_F'.OR.
     &    OPTION.EQ.'CALC_DK_DG_FORCF') THEN
        CALL MECACT('V',CHTIME,'MODELE',LIGRMO,'INST_R  ',1,'INST   ',
     &              IBID,TIME,CBID,K8BID)
        LPAIN(NCHIN+1) = 'PTEMPSR'
        LCHIN(NCHIN+1) = CHTIME
        NCHIN = NCHIN + 1
      END IF
C
      IF (OPTION.EQ.'K_G_MODA') THEN
        CHPULS = '&&MEFICG.PULS'
        CALL MECACT('V',CHPULS,'MODELE',LIGRMO,'FREQ_R  ',1,
     &            'FREQ   ',IBID,PULS,CBID,' ')
        NCHIN = NCHIN + 1
        LPAIN(NCHIN) = 'PPULPRO'
        LCHIN(NCHIN) = CHPULS
      END IF
C
      CALL CALCUL('S',OPTIO2,LIGRMO,NCHIN,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &            'V','OUI')

C  SOMMATION DES FIC ET G ELEMENTAIRES

      CALL MESOMM(LCHOUT(1),5,IBID,FIC,CBID,0,IBID)

      DO 20 I = 1,5
        ZR(IFIC+I-1) = FIC(I)
   20 CONTINUE

      IF (TYPMO(1:4) .EQ. 'AXIS') THEN
        DO 21 I = 1,5
          ZR(IFIC+I-1) =  ZR(IFIC+I-1)/RCMP(1)
   21   CONTINUE
      END IF

      IF (SYMECH.EQ.'OUI') THEN
        ZR(IFIC) = 2.D0*ZR(IFIC)
        ZR(IFIC+1) = 2.D0*ZR(IFIC+1)
        ZR(IFIC+2) = 0.D0
        ZR(IFIC+3) = 2.D0*ZR(IFIC+3)
        ZR(IFIC+4) = 0.D0
      END IF

C IMPRESSION DE K1,K2,G ET ECRITURE DANS LA TABLE RESU

      IF (NIV.GE.2) THEN
        CALL IMPFIC(ZR(IFIC),ZK8(IADRNO),RCMP,IFM,IXFEM)
      END IF

      IF ((IXFEM.NE.0) .AND. (OPTION(1:8).EQ.'CALC_K_G') ) THEN
        VALI(1) = NUMFON
        VALI(2) = IORD
      ELSE
        VALI(1) = IORD
      ENDIF
      IF((OPTION .EQ. 'K_G_MODA') . OR. (LMELAS) )THEN
        VAL(1) = ZR(IFIC)
        VAL(2) = ZR(IFIC+3)
        VAL(3) = ZR(IFIC+4)
        VAL(4) = ZR(IFIC+1)*ZR(IFIC+1) + ZR(IFIC+2)*ZR(IFIC+2)
      ELSE
        VAL(1) = TIME
        VAL(2) = ZR(IFIC)
        VAL(3) = ZR(IFIC+3)
        VAL(4) = ZR(IFIC+4)
        VAL(5) = ZR(IFIC+1)*ZR(IFIC+1) + ZR(IFIC+2)*ZR(IFIC+2)
      ENDIF

      IF(LMELAS)THEN
        CALL TBAJLI(RESULT,NBPRUP,NOPRUP,VALI,VAL,CBID,NOMCAS,0)
      ELSE
        CALL TBAJLI(RESULT,NBPRUP,NOPRUP,VALI,VAL,CBID,K8BID,0)
      ENDIF

      CALL DETRSD('CHAMP_GD',CHTIME)
      CALL DETRSD('CHAMP_GD',CHVOLU)
      CALL DETRSD('CHAMP_GD',CF1D2D)
      CALL DETRSD('CHAMP_GD',CF2D3D)
      CALL DETRSD('CHAMP_GD',CHPRES)
      CALL DETRSD('CHAMP_GD',CHEPSI)
      CALL DETRSD('CHAMP_GD',CHPESA)
      CALL DETRSD('CHAMP_GD',CHROTA)
      CALL JEDETR('&&MEFICG.VALG')
      CALL JEDETR('&&MEFICG.FOND')

      CALL JEDEMA()
      END

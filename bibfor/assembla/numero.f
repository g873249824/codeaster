      SUBROUTINE NUMERO(NUPOSS,MODELZ,INFCHZ,SOLVEU,BASE,NU)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 08/10/2007   AUTEUR PELLET J.PELLET 
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
C ----------------------------------------------------------------------
C IN  K14  NUPOSS  : NOM D'UN NUME_DDL CANDIDAT (OU ' ')
C                    SI NUPOSS != ' ', ON  REGARDE SI LE PROF_CHNO
C                    DE NUPOSS EST CONVENABLE.
C                    (POUR EVITER DE CREER SYTEMATIQUEMENT 1 PROF_CHNO)
C IN  K8   MODELE  : NOM DU MODELE
C IN  K19  INFCHA  : NOM DE L'OBJET DE TYPE INFCHA
C IN  K19  SOLVEU  : NOM DE L'OBJET DE TYPE SOLVEUR
C IN  K2   BASE    : BASE(1:1) : BASE POUR CREER LE NUME_DDL
C                    (SAUF LE NUME_EQUA)
C                  : BASE(2:2) : BASE POUR CREER LE NUME_EQUA
C VAR/JXOUT K14 NU : NOM DU NUME_DDL.
C                    SI NUPOSS !=' ', NU PEUT ETRE MODIFIE (NU=NUPOSS)
C----------------------------------------------------------------------
C RESPONSABLE VABHHTS J.PELLET
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      CHARACTER*(*) MODELZ,SOLVEU,INFCHZ
      CHARACTER*(*) NU,NUPOSS
      CHARACTER*2 BASE

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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

C DECLARATION VARIABLES LOCALES
      INTEGER      NCHAR,NBLIG,IRET,JCHAR,JLLIGR,K,JTYPCH,ISLVK,IDIME,
     &             I,ILIMA,NBMA,NBSD,IFM,NIV,IBID,ISOLFS,IREFE,IDEEQ,
     &             IFETN,NEQUA,NBPB,NCHARF,L,IVLIGR,INUEQ,IFEL1,
     &             LDEEQG,IINF,IFCPU,IDD,JMULT,
     &             NBPROC,RANG,ILIMPI,NIVMPI,NBCHAT,IFFCC,NEQUAG,NBI2,
     &             IFETI,IAUX,INO,ICMP,IMULT,VALI(2),IER
      REAL*8       TEMPS(6),RBID
      CHARACTER*1  K1
      CHARACTER*3  VERIF
      CHARACTER*8  MOLOC,NOMCHA,K8BID,METHOD,NOMSD,MODELE
      CHARACTER*14 NUPOSB,NOMFE2
      CHARACTER*16 PHENO
      CHARACTER*19 INFCHA,LIGRSD,LIGRCF
      CHARACTER*24 LCHARG,LLIGR,NOMLIG,SDFETI,NOMSDA,K24B,K24CF,
     &             KSOLVF,LLIGRS,INFOFE,NOOBJ,K24MUL
      CHARACTER*32 JEXNUM
      LOGICAL      LFETI,LFETIC,LCF

C RECUPERATION ET MAJ DU NIVEAU D'IMPRESSION
      CALL INFNIV(IFM,NIV)
C-----------------------------------------------------------------------
C CONSTRUCTION D'UN OBJET JEVEUX CONTENANT LA LISTE DES CHARGES ET
C LE NOM DU MODELE DE CALCUL
C-----------------------------------------------------------------------
      CALL JEMARQ()
      LIGRCF='&&OP0070.RESOC.LIGR'
      K24CF='&&NUMERO.FETI.CONTACT'
      CALL JEEXIN(LIGRCF//'.LIEL',IRET)
      IF (IRET.EQ.0) THEN
        LCF=.FALSE.
      ELSE
        LCF=.TRUE.
      ENDIF
      INFCHA = INFCHZ
      MODELE = MODELZ
      LCHARG = INFCHA//'.LCHA'
      NCHAR = 0
      CALL JEEXIN(LCHARG,IRET)
      IF (IRET.NE.0) THEN
        CALL JELIRA(LCHARG,'LONMAX',NCHAR,K8BID)
        CALL JEVEUO(LCHARG,'L',JCHAR)
      ENDIF
      LLIGR = '&&NUMERO.LISTE_LIGREL'

C     LISTE AUGMENTEE POUR L'EVENTUEL LIGRCF
      IF (LCF) THEN
        CALL WKVECT(LLIGR,'V V K24',NCHAR+2,JLLIGR)
      ELSE
        CALL WKVECT(LLIGR,'V V K24',NCHAR+1,JLLIGR)
      ENDIF
      NBLIG = 0
C     ON INSERE LE LIGREL DE MODELE
      CALL JEEXIN(MODELE//'.MODELE    .NBNO',IRET)
      IF (IRET.GT.0) THEN
        ZK24(JLLIGR) = MODELE(1:8)//'.MODELE'
        NBLIG = NBLIG + 1
      ENDIF
C     PUIS LES CHARGES A MAILLES ET/OU A NOEUDS TARDIFS
      DO 10 K = 1,NCHAR
        NOMCHA = ZK24(JCHAR+K-1)
        CALL JEEXIN(NOMCHA(1:8)//'.TYPE',IER)
        IF (IER.GT.0) THEN
          CALL JEVEUO(NOMCHA(1:8)//'.TYPE','L',JTYPCH)
          NOMLIG = NOMCHA(1:8)//'.CH'//ZK8(JTYPCH) (1:2)//'.LIGRE.LIEL'
          CALL JEEXIN(NOMLIG,IRET)
        ELSE
          IRET=0
        ENDIF
        IF (IRET.GT.0) THEN
          ZK24(JLLIGR+NBLIG) = NOMLIG(1:19)
          NBLIG = NBLIG + 1
        ENDIF
   10 CONTINUE
C     PUIS EVENTUELLEMENT LE LIGREL DE CONTACT CONTINUE
C     C'EST IL ME SEMBLE MIEUX ICI QUE CACHE AU FOND DE NULILI.F
      IF (LCF) THEN
        ZK24(JLLIGR+NBLIG) =LIGRCF
        NBLIG = NBLIG + 1
      ENDIF
      CALL JEECRA(LLIGR,'LONUTI',NBLIG,K8BID)

C SOLVEUR FETI ?
      CALL JEVEUO(SOLVEU(1:19)//'.SLVK','L',ISLVK)
      METHOD=ZK24(ISLVK)
      NIVMPI=1
      LFETIC=.FALSE.
      IF (METHOD(1:4).EQ.'FETI') THEN
        LFETI=.TRUE.
        NUPOSB=' '
        CALL JEVEUO('&FETI.FINF','L',IINF)
        INFOFE=ZK24(IINF)
        IF (INFOFE(11:11).EQ.'T') LFETIC=.TRUE.
      ELSE
        LFETI=.FALSE.
        INFOFE='FFFFFFFFFFFFFFFFFFFFFFFF'
      ENDIF

C CALCUL TEMPS
      IF ((NIV.GE.2).OR.(LFETIC)) THEN
        CALL UTTCPU(50,'INIT ',6,TEMPS)
        CALL UTTCPU(50,'DEBUT',6,TEMPS)
      ENDIF
C --------------------------------------------------------------
C CREATION ET REMPLISSAGE DE LA SD NUME_DDL "MAITRE"
C --------------------------------------------------------------

      CALL NUMER2(NUPOSS,NBLIG,ZK24(JLLIGR),' ',SOLVEU,BASE,NU,NEQUAG)

      IF ((NIV.GE.2).OR.(LFETIC)) THEN
        CALL UTTCPU(50,'FIN  ',6,TEMPS)
        IF (NIV.GE.2) WRITE(IFM,'(A44,D11.4,D11.4)')
     &    'TEMPS CPU/SYS FACT SYMB                   : ',TEMPS(5),
     &     TEMPS(6)
        IF (LFETIC) THEN
          CALL JEVEUO('&FETI.INFO.CPU.FACS','E',IFCPU)
          ZR(IFCPU)=TEMPS(5)+TEMPS(6)
        ENDIF
      ENDIF
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      IF (LFETI) THEN

C STRUCTURE DE DONNEES DE TYPE SD_FETI
        SDFETI=' '
        SDFETI(1:8)=ZK24(ISLVK+5)
        VERIF=ZK24(ISLVK+2)

C MONITORING
        IF (INFOFE(1:1).EQ.'T')
     &    WRITE(IFM,*)'<FETI/NUMERO> DOMAINE GLOBAL ',NU(1:14)
        IF (INFOFE(2:2).EQ.'T')
     &    CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,NU(1:14),1,' ')

C VERIFICATION COHERENCE SD_FETI AVEC PARAMETRAGE OPERATEUR
        CALL JEVEUO(SDFETI(1:19)//'.FREF','L',IREFE)
        CALL JELIRA(SDFETI(1:19)//'.FREF','LONMAX',NCHARF,K8BID)
        NCHARF=NCHARF-1
        NBPB=0
        IF (ZK8(IREFE).NE.MODELE) NBPB=NBPB+1
        DO 17 K=1,NCHAR
          NOMCHA=ZK24(JCHAR+K-1)(1:8)
          DO 15 L=1,NCHARF
            IF (NOMCHA.EQ.ZK8(IREFE+L)) GOTO 17
   15     CONTINUE
          NBPB=NBPB+1
   17   CONTINUE
        DO 19 L=1,NCHARF
          NOMCHA=ZK8(IREFE+L)
          DO 18 K=1,NCHAR
            IF (NOMCHA.EQ.ZK24(JCHAR+K-1)(1:8)) GOTO 19
   18     CONTINUE
          NBPB=NBPB+1
   19   CONTINUE
        IF (VERIF.EQ.'OUI') THEN
          K1='F'
        ELSE
          K1='A'
        ENDIF
        IF (NBPB.NE.0) THEN
          VALI(1)=NBPB
          CALL U2MESI(K1,'ASSEMBLA_68',1,VALI)
        ENDIF
C RECHERCHE DU PHENOMENE POUR LES NOUVEAUX LIGRELS DE SOUS-DOMAINE
C CF DISMPH.F
        CALL DISMOI('F','PHENOMENE',MODELE,'MODELE',IBID,PHENO,IRET)
        MOLOC=' '
        IF (PHENO(1:9).EQ.'MECANIQUE') THEN
          MOLOC='DDL_MECA'
        ELSE IF (PHENO(1:9).EQ.'THERMIQUE') THEN
          MOLOC='DDL_THER'
        ELSE IF (PHENO(1:9).EQ.'ACOUSTIQU') THEN
          MOLOC='DDL_ACOU'
        ELSE
          CALL U2MESS('F','ASSEMBLA_32')
        ENDIF
        IF (INFOFE(1:1).EQ.'T') THEN
          WRITE(IFM,*)
          WRITE (IFM,*)'<FETI/NUMERO> PHENOMENE ',PHENO,MOLOC
          WRITE(IFM,*)
        ENDIF


C PREPARATION BOUCLE SUR LES SOUS-DOMAINES
        CALL JEVEUO(SDFETI(1:19)//'.FDIM','L',IDIME)
        NBSD=ZI(IDIME)
C K24CF: OBJET JEVEUX STOCKANT LES NOMS DES LIGRELS DE MODELE POUR NE
C  PAS LES RECONSTRUIRE A CHAQUE PASSE DU CONTACT CONTINUE
C ON EN PROFITE POUR DETRUIRE LES LIGRELS DE CONTACT PROJETES SI ON EST
C AU MOINS A LA 3IEME PASSE (LIGRCF.FEL1 EXISTE) + TOUS LES .FEL
C ANNEXES. SINON ON VA GASPILLER DE LA MEMOIRE ET EPUISER LE COMPTEUR
C DE GCNCON.
        IF (LCF) THEN
          CALL JEVEUO(K24CF,'E',IFFCC)
          CALL JEEXIN(LIGRCF(1:19)//'.FEL1',IRET)
          IF (IRET.NE.0) THEN
            CALL JEVEUO(LIGRCF(1:19)//'.FEL1','L',IFEL1)
            DO 35 IDD=1,NBSD
              K24B=ZK24(IFEL1+IDD-1)
              IF ((K24B.NE.' ').AND.(K24B(1:19).NE.LIGRCF(1:19)))
     &          CALL DETRSD('LIGREL',K24B)
   35       CONTINUE
            CALL JEDETR(LIGRCF(1:19)//'.FEL1')
            CALL JEDETR(LIGRCF(1:19)//'.FEL2')
            CALL JEDETR(LIGRCF(1:19)//'.FEL4')
          ENDIF
        ELSE
          CALL WKVECT(K24CF,'V V K24',NBSD,IFFCC)
        ENDIF
        NOMSDA=SDFETI(1:19)//'.FETA'
C ADRESSE DANS L'OBJET JEVEUX SOLVEUR.FETS DES NOMS DES OBJETS
C JEVEUX REPRESENTANT LES SOLVEURS LOCAUX
        CALL JEVEUO(SOLVEU(1:19)//'.FETS','L',ISOLFS)

C CONSTITUTION OBJET STOCKAGE.FETN
        CALL WKVECT(NU(1:14)//'.FETN',BASE(1:1)//' V K24',NBSD,IFETN)
C OBJET JEVEUX FETI & MPI
        CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
C APPEL MPI POUR DETERMINER LE NOMBRE DE PROCESSEURS
        IF (INFOFE(10:10).EQ.'T') THEN
          NIVMPI=2
        ELSE
          NIVMPI=1
        ENDIF
        CALL FETMPI(3,NBSD,IFM,NIVMPI,RANG,NBPROC,K24B,K24B,K24B,RBID)
C========================================
C BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
        DO 30 I=1,NBSD
          IF (ZI(ILIMPI+I).EQ.1) THEN

            IF ((NIV.GE.2).OR.(LFETIC)) THEN
              CALL UTTCPU(50,'INIT ',6,TEMPS)
              CALL UTTCPU(50,'DEBUT',6,TEMPS)
            ENDIF
            CALL JEMARQ()
            CALL JEVEUO(JEXNUM(NOMSDA,I),'L',ILIMA)
            CALL JELIRA(JEXNUM(NOMSDA,I),'LONMAX',NBMA,K8BID)

C OBJET TEMPORAIRE CONTENANT LES NOMS DES MAILLES DU SD I
            CALL JENUNO(JEXNUM(NOMSDA,I),NOMSD)

            IF (.NOT.LCF) THEN
C CAS SANS CONTACT OU CONTACT PREMIERE PASSE
C CREATION DU LIGREL TEMPORAIRE ASSOCIE AU SOUS-DOMAINE
C LES 16 PREMIERS CHARACTERES SONT OBLIGEATOIRES COMPTE-TENU DES
C PRE-REQUIS DES ROUTINES DE CONSTRUCTION DU NUM_DDL.
C NOUVELLE CONVENTION POUR LES LIGRELS FILS, GESTION DE NOMS
C ALEATOIRES
              CALL GCNCON('.',K8BID)
              K8BID(1:2)='&F'
              LIGRSD=K8BID//'.MODELE   '
              CALL EXLIM1(ZI(ILIMA),NBMA,MODELE,'V',LIGRSD)
              ZK24(IFFCC+I-1)=LIGRSD
            ELSE
              LIGRSD=ZK24(IFFCC+I-1)
            ENDIF
C DETECTION DES LIGRELS DE CHARGES CONCERNES PAR CE SOUS-DOMAINE
C ET REMPLISSAGE DE LA LISTE DE LIGRELS AD HOC POUR NUEFFE VIA
C NUMER2.F
            LLIGRS='&&NUMERO.LIGREL_SD'
            CALL EXLIM2(SDFETI,NOMSD,LLIGRS,LIGRSD,NBCHAT,I,NBSD,INFOFE,
     &                  NBPROC,LIGRCF)
            CALL JEVEUO(LLIGRS,'L',IVLIGR)

C --------------------------------------------------------------
C CREATION ET REMPLISSAGE DE LA SD NUME_DDL "ESCLAVE" LIEE A
C CHAQUE SOUS-DOMAINE
C --------------------------------------------------------------
C CREATION DU NUME_DDL ASSOCIE AU SOUS-DOMAINE
C         DETERMINATION DU NOM DU NUME_DDL  ASSOCIE AU SOUS-DOMAINE
            NOOBJ ='12345678.00000.NUME.PRNO'
            CALL GNOMSD(NOOBJ,10,14)
            NOMFE2=NOOBJ(1:14)
            KSOLVF = ZK24(ISOLFS+I-1)

            CALL NUMER2(NUPOSB,NBCHAT,ZK24(IVLIGR),MOLOC,KSOLVF,BASE,
     &                  NOMFE2,NEQUA)
            CALL JEDETR(LLIGRS)

C REMPLISSAGE OBJET NU.FETN
            ZK24(IFETN+I-1)=NOMFE2

C MONITORING
            IF (INFOFE(1:1).EQ.'T')
     &        WRITE(IFM,*)'<FETI/NUMERO> SD ',I,' ',NOMFE2
            IF (INFOFE(2:2).EQ.'T')
     &        CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,NOMFE2,1,' ')
            IF ((NIV.GE.2).OR.(LFETIC)) THEN
              CALL UTTCPU(50,'FIN  ',6,TEMPS)
              IF (NIV.GE.2) WRITE(IFM,'(A44,D11.4,D14.4)')
     &          'TEMPS CPU/SYS FACT SYMB                   : ',TEMPS(5),
     &          TEMPS(6)
              IF (LFETIC) ZR(IFCPU+I)=TEMPS(5)+TEMPS(6)
            ENDIF
            CALL JEDEMA()

          ENDIF
   30   CONTINUE
C========================================
C FIN BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================

C FIN DE IF METHOD='FETI'
      ENDIF
C-----------------------------------------------------------------------
C PRE-REMPLISSAGE DE L'OBJET '&&FETI.MULT' QUI EST LE PENDANT FETI DU
C .CONL. IL SERT A TENIR COMPTE DE LA MULTIPLICITE DES NOEUDS D'INTERFA
C CE LORS DE LA RECONSTRUCTION DU CHAMP SOLUTION.
C ATTENTION, ON NE TIENT COMPTE QUE DES DDLS PHYSIQUES JUSQU'A 6.
C SI LCF=.TRUE., CONTACT METHODE CONTINUE, ON RECALCULE LE NUM_DDL MAIS
C ON NE CHANGE PAS L'ORDRE DES INCONNUES. C'EST JUSTE LE STOCKAGE QUI
C CHANGE, DONC PAS BESOIN DE REFAIRE CET OBJET
      IF ((LFETI).AND.(.NOT.LCF)) THEN
        K24MUL='&&FETI.MULT'
C ON TESTE AU CAS OU
        CALL JEEXIN(K24MUL,IRET)
        IF (IRET.NE.0) CALL JEDETR(K24MUL)
        CALL WKVECT(K24MUL,'V V I',NEQUAG,JMULT)
        NEQUAG=NEQUAG-1
        CALL JEVEUO(NU(1:14)//'.NUME.DEEQ','L',IDEEQ)
        CALL JEVEUO(SDFETI(1:19)//'.FETI','L',IFETI)
C NOMBRE DE LAGRANGE D'INTERFACE
        NBI2=ZI(IDIME+1)
        DO 50 K=0,NEQUAG
          INO=ZI(IDEEQ+2*K)
          ICMP=ZI(IDEEQ+2*K+1)
          IMULT=1
          IF ((INO*ICMP.GT.0).AND.(ICMP.LE.6)) THEN
            DO 48 I=1,NBI2
              IAUX=IFETI+4*(I-1)
              IF (INO.EQ.ZI(IAUX)) THEN
                IMULT=ZI(IAUX+1)
                GOTO 49
              ENDIF
   48       CONTINUE
   49       CONTINUE
          ENDIF
          ZI(JMULT+K)=IMULT
   50   CONTINUE
      ENDIF
C APPEL MPI POUR DETERMINER LE RANG DU PROCESSEUR
      CALL FETMPI(2,NBSD,IFM,NIVMPI,RANG,NBPROC,K24B,K24B,K24B,RBID)
      IF ((LFETI).AND.(RANG.EQ.0)) THEN
C POUR EVITER QUE LA RECONSTRUCTION DU CHAMP GLOBAL SOIT FAUSSE DANS
C FETRIN OU ON TRAVAILLE DIRECTEMENT SUR LES .VALE (GLOBAL ET LOCAUX)
C TEST DE L'OBJET .NUEQ DU PROF_CHNO DU NUME_DDL. POUR FETI IL DOIT
C ETRE EGALE A L'IDENTITE (EN THERORIE CE PB SE PRESENTE QUE POUR LA
C SOUS-STRUCTURATION QUI EST ILLICITE AVEC FETI, MAIS ON NE SAIT JAMAIS)
        K24B=NU(1:14)//'.NUME.NUEQ'
        CALL JEVEUO(K24B,'L',INUEQ)
        CALL JELIRA(K24B,'LONMAX',LDEEQG,K8BID)
        DO 40 I=1,LDEEQG
          IBID=ZI(INUEQ+I-1)
          IF (IBID.NE.I) THEN
            VALI(1)=I
            VALI(2)=IBID
            CALL U2MESI('F','ASSEMBLA_67',2,VALI)
          ENDIF
   40   CONTINUE
      ENDIF
      CALL JEDETR(LLIGR)
      CALL JEDEMA()
      END

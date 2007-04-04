      SUBROUTINE ASSMAM(BASE,MATAS,NBMAT,TLIMAT,LICOEF,NU,MOTCLE,TYPE)

C  ATTENTION : CETTE ROUTINE NE DOIT PAS ETRE APPELLEE DIRECTEMENT :
C              IL FAUT APPELER SON "CHAPEAU" : ASMATR.

      IMPLICIT REAL*8 (A-H,O-Z)

      CHARACTER*(*) BASE,MATAS,TLIMAT(*),NU
      INTEGER NBMAT,TYPE
      REAL*8 LICOEF(*)
      CHARACTER*4 MOTCLE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 04/04/2007   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     ASSEMBLAGE MORSE AVEC PRECONDITIONNEMENT DES MATR_ELEM DE MAILLES
C     "LAGRANGE" PAR -(MAX(!A(I,I)!)+MIN(!A(I,I)!))/2
C-----------------------------------------------------------------------
C --- DESCRIPTION DES PARAMETRES
C INT K* BASE   : BASE SUR LAQUELLE ON VEUT CREER LA MATR_ASSE
C OUT K* MATAS  :L'OBJET MATAS DE TYPE MATR_ASSE EST CREE ET REMPLI
C IN  K* MATAS  : NOM DE L'OBJET DE TYPE MATR_ASSE A CREER
C IN  I  NBMAT  : NOMBRE DE MAT_ELE  DE LA LISTE TLIMAT
C IN  K* TLIMAT : LISTE DES MAT_ELE
C IN  I  LICOEF : LISTE DES COEFFICIENTS MULTIPLICATEURS DES MAT_ELE
C IN  K* NU     : NOM DU NUMERO_DDL
C IN  K4 MOTCLE : 'ZERO' OU 'CUMU'
C                 'ZERO':SI UN OBJET DE NOM MATAS ET DE TYPE
C                        MATR_ASSE EXISTE ON L'ECRASE
C                 'CUMU':SI UN OBJET DE NOM MATAS ET DE TYPE
C                        MATR_ASSE EXISTE ON L'ENRICHI
C IN  I   TYPE  : TYPE DES MATRICES ELEMENTAIRES A ASSEMBLEES
C                          1 --> REELLES
C                          2 --> COMPLEXES

C  SI IL EXISTE UN OBJET '&&POIDS_MAILLE' VR CONTENANT
C  DES PONDERATIONS POUR CHAQUE MAILLE, ON S'EN SERT.
C-----------------------------------------------------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16,OPTIO,OPTIO2
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C-----------------------------------------------------------------------
      CHARACTER*1 BASE1,TYPSCA,K1BID
      CHARACTER*8 MATEL,K8BID,NOGDCO,NOGDSI,MA,EXIELE,MA2,MO,MO2,NOMACR
      CHARACTER*11 K11B
      CHARACTER*14 NUDEV,K14B,NUM2
      CHARACTER*19 MATDEV,K19B
      CHARACTER*24 K24PRN,KNULIL,KMALIL,KREFA,RESU,NOMLI,KSMHC,KSMDI,
     &             KVALM,KSMDE,KTMP1,KTMP2,KCONL,METHOD,SDFETI,K24B,
     &             NOMLOG,NOMLID,INFOFE,KMAREF
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
      INTEGER NMALIL,IMO,ILAGR,ILIMO,NBNO,EPDMS,JPDMS,NBEC,NLILI,NBREFN,
     &        NBSD,IFETM,IDD,IFETN,IDIME,ILIGRP,GD,NEC,IINF,DIGDEL,
     &        ILIGRT,ILIGRB,IRET1,ILIGRC,IFEL1,IFEL2,IFEL3,ADMODL,
     &        LCMODL,IFCPU,IBID,IFM,NIV,ILIMPI,IFEL4,IFEL5,IRET2,IRET3,
     &        IAUX1,JFEL4,IAUX2,IAUX3,IAUX4,COMPT,MOD
      REAL*8 R,RINF,RSUP,TEMPS(6),DII,DII2,DII3
      LOGICAL CUMUL,ACREER,LFETI,LLIMO,LLICH,LLICHD,IDDOK,LFEL2,LLICHP,
     &        LFETIC,LBID,LGOTO
      INTEGER KTERM,NZ,JSMDI,NSMDI,JSMHC,NSMHC,N,JCOL,ILIG,IDEEQ,INO,
     &        NBI,IFETI,NBIDD,IFETJ,ITEST,NBI4,JVAL1

C-----------------------------------------------------------------------
C     FONCTIONS FORMULES :
C-----------------------------------------------------------------------
      INTEGER ZZCONX,ZZLIEL,ZZNGEL,ZZNSUP,ZZNELG
      INTEGER ZZNEMA,ZZPRNO,POSDD2,NUMLOC
      PARAMETER (NBECMX=10)
      INTEGER ICODLA(NBECMX),ICODGE(NBECMX)

      ZZCONX(IMAIL,J) = ZI(ICONX1-1+ZI(ICONX2+IMAIL-1)+J-1)
      ZZLIEL(ILI,IGREL,J) = ZI(ZI(IADLIE+3* (ILI-1)+1)-1+
     &                      ZI(ZI(IADLIE+3* (ILI-1)+2)+IGREL-1)+J-1)
      ZZNGEL(ILI) = ZI(IADLIE+3* (ILI-1))
      ZZNSUP(ILI,IEL) = ZI(ZI(IADNEM+3* (ILI-1)+2)+IEL) -
     &                  ZI(ZI(IADNEM+3* (ILI-1)+2)+IEL-1) - 1
      ZZNELG(ILI,IGREL) = ZI(ZI(IADLIE+3* (ILI-1)+2)+IGREL) -
     &                    ZI(ZI(IADLIE+3* (ILI-1)+2)+IGREL-1) - 1
      ZZNEMA(ILI,IEL,J) = ZI(ZI(IADNEM+3* (ILI-1)+1)-1+
     &                    ZI(ZI(IADNEM+3* (ILI-1)+2)+IEL-1)+J-1)
      ZZPRNO(ILI,NUNOEL,L) = ZI(IDPRN1-1+ZI(IDPRN2+ILI-1)+
     &                       (NUNOEL-1)* (NEC+2)+L-1)
      NUMLOC(KNO,K) = ZI(IANULO-1+2* (KNO-1)+K)
      POSDD2(KNO,KDDL) = ZI(IAPSDL-1+NMXCMP* (KNO-1)+KDDL)
C----------------------------------------------------------------------
      CALL JEMARQ()

      CALL JEDBG2(IDBGAV,0)
      CALL INFNIV(IFM,NIV)
      BASE1 = BASE
      MATDEV = MATAS
      NUDEV = NU
C     CALL CHEKSD(NU,'sd_nume_ddl',IRET)
      INFOFE = 'FFFFFFFFFFFFFFFFFFFFFFFF'

C---- GESTION DES DONNEES D'ENTREE
      IF (MOTCLE(1:4).EQ.'ZERO') THEN
        ACREER = .TRUE.

      ELSE IF (MOTCLE(1:4).EQ.'CUMU') THEN
        ACREER = .FALSE.

      ELSE
        CALL ASSERT(.FALSE.)
      END IF

C --- TEST POUR SAVOIR SI LE SOLVEUR EST DE TYPE FETI
C --- NUME_DDL ET DONC MATR_ASSE ETENDU, OUI OU NON ?
      CALL JELIRA(NUDEV(1:14)//'.NUME.REFN','LONMAX',NBREFN,K8BID)
      IF ((NBREFN.NE.4) .AND. (NIV.GE.2)) THEN
        WRITE (IFM,*) '<FETI/ASSMAM> NUME_DDL/MATR_ASSE NON ETENDU '//
     &    'POUR FETI ',NUDEV(1:14)//'.NUME.REFN'
        METHOD = 'XXXX'
        SDFETI = 'XXXX'

      ELSE
        CALL JEVEUO(NUDEV(1:14)//'.NUME.REFN','L',IREFN)
        METHOD = ZK24(IREFN+2)
        SDFETI = ZK24(IREFN+3)
      END IF

      LFETI = .FALSE.
      LFETIC = .FALSE.
      NBSD = 0
      IF (METHOD(1:4).EQ.'FETI') THEN
        LFETI = .TRUE.
        CALL JEVEUO(SDFETI(1:19)//'.FDIM','L',IDIME)
        NBSD = ZI(IDIME)
        CALL JEVEUO(NUDEV//'.FETN','L',IFETN)
        IF (.NOT.ACREER) CALL JEVEUO(MATDEV//'.FETM','L',IFETM)
        CALL JEVEUO('&FETI.FINF','L',IINF)
        INFOFE = ZK24(IINF)
        IF (INFOFE(11:11).EQ.'T') LFETIC = .TRUE.
        CALL JEVEUO('&FETI.LISTE.SD.MPI','L',ILIMPI)
C PREPARATION DE DONNEES AUXILIAIRES POUR TEST
        CALL FETTSD(INFOFE,IBID,IBID,IBID,SDFETI(1:19),K24B,IBID,IBID,
     &              IBID,IFM,LBID,IBID,IBID,IBID,K19B,2,LBID)
      ENDIF

      CALL DISMOI('F','NOM_MODELE',NUDEV,'NUME_DDL',IBID,MO,IERD)
      CALL DISMOI('F','NB_NO_MAILLA',MO,'MODELE',NM,K8BID,IER)
      CALL DISMOI('F','EXI_ELEM',MO,'MODELE',IBID,EXIELE,IERD)
      CALL DISMOI('F','NB_SM_MAILLA',MO,'MODELE',NBSMA,K8BID,IERD)
      CALL DISMOI('F','NOM_MAILLA',MO,'MODELE',IBID,MA,IERD)
      CALL DISMOI('F','NOM_MAILLA',NUDEV,'NUME_DDL',IBID,MA2,IERD)
      CALL ASSERT(MA.EQ.MA2)
      CALL DISMOI('F','NB_NO_SS_MAX',MA,'MAILLAGE',NBNOSS,K8BID,IERD)
      CALL DISMOI('F','NOM_GD',NUDEV,'NUME_DDL',IBID,NOGDCO,IERD)
      CALL DISMOI('F','NOM_GD_SI',NOGDCO,'GRANDEUR',IBID,NOGDSI,IERD)
      CALL DISMOI('F','NB_CMP_MAX',NOGDSI,'GRANDEUR',NMXCMP,K8BID,IERD)
      CALL DISMOI('F','NUM_GD_SI',NOGDSI,'GRANDEUR',NUGD,K8BID,IERD)
      NEC = NBEC(NUGD)
      CALL JEVEUO(JEXATR('&CATA.TE.MODELOC','LONCUM'),'L',LCMODL)
      CALL JEVEUO(JEXNUM('&CATA.TE.MODELOC',1),'L',ADMODL)

C     -- TEST EXISTENCE &&POIDS_MAILLE
C     ---------------------------------
      CALL JEEXIN('&&POIDS_MAILLE',EPDMS)
      IF (EPDMS.GT.0) CALL JEVEUO('&&POIDS_MAILLE','L',JPDMS)


C     -- ALLOCATION DES OBJETS .NUMLOC ET .POSDDL:
C     ----------------------------------------------
C     50 EST SUPPOSE ETRE LE + GD NOMBRE DE NOEUDS D'UNE MAILLE
C        STANDARD (JUSQU'A PRESENT : 27 (HEXA27))
      NBNOMX = MAX(NBNOSS,50)
      CALL WKVECT('&&ASSMAM.NUMLOC','V V I',2*NBNOMX,IANULO)
      CALL WKVECT('&&ASSMAM.POSDDL','V V I',NBNOMX*NMXCMP,IAPSDL)


C     -- ZERO OU CUMU :
C     -----------------
      IF (MOTCLE(1:4).EQ.'ZERO') THEN
        CUMUL = .FALSE.

      ELSE IF (MOTCLE(1:4).EQ.'CUMU') THEN
        CUMUL = .TRUE.

      ELSE
        CALL U2MESK('F','ASSEMBLA_3',1,MOTCLE)
      END IF


      DO 10 I = 1,NBECMX
        ICODLA(I) = 0
        ICODGE(I) = 0
   10 CONTINUE


C     -- ON MET QUELQUES OBJETS EN MEMOIRE :
C     --------------------------------------
      CALL JEEXIN(MA//'.CONNEX',IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(MA//'.CONNEX','L',ICONX1)
        CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',ICONX2)
      END IF

      CALL JEVEUO(NUDEV//'.NUME.NUEQ','L',IANUEQ)
      CALL JEEXIN(MA//'.NOMACR',IRET)
      IF (IRET.GT.0) CALL JEVEUO(MA//'.NOMACR','L',IANMCR)
      CALL JEVEUO(JEXNOM('&CATA.GD.NOMCMP',NOGDSI),'L',IANCMP)
      CALL JELIRA(JEXNOM('&CATA.GD.NOMCMP',NOGDSI),'LONMAX',LGNCMP,
     &            K8BID)
      ICMP = INDIK8(ZK8(IANCMP),'LAGR',1,LGNCMP)
      IF (ICMP.GT.0) THEN
        JEC = (ICMP-1)/30 + 1
        ICODLA(JEC) = 2** (ICMP- (JEC-1)*30)
      END IF


      IF (MOTCLE(1:4).EQ.'ZERO') THEN
        ACREER = .TRUE.

      ELSE IF (MOTCLE(1:4).EQ.'CUMU') THEN
        ACREER = .FALSE.

      ELSE
        CALL ASSERT(.FALSE.)
      END IF

      IF (ACREER) THEN
        CALL DETRSD('MATR_ASSE',MATDEV)

      ELSE
C========================================
C BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
C IDD=0 --> DOMAINE GLOBAL/ IDD=I --> IEME SOUS-DOMAINE
        DO 20 IDD = 0,NBSD

C TRAVAIL PREALABLE POUR DETERMINER SI ON EFFECTUE LA BOUCLE SUIVANT
C LE SOLVEUR (FETI OU NON), LE TYPE DE RESOLUTION (PARALLELE OU
C SEQUENTIELLE) ET L'ADEQUATION "RANG DU PROCESSEUR-NUMERO DU SD"
          IF (.NOT.LFETI) THEN
            IDDOK = .TRUE.

          ELSE
            IF (ZI(ILIMPI+IDD).EQ.1) THEN
              IDDOK = .TRUE.

            ELSE
              IDDOK = .FALSE.
            END IF

          END IF

          IF (IDDOK) THEN
            IF (IDD.NE.0) THEN
C---- MATR_ASSE ESCLAVE LIEE AU SOUS-DOMAINE IDD
              KMAREF = ZK24(IFETM+IDD-1) (1:19)//'.REFA'
              K14B = ZK24(IFETN+IDD-1) (1:14)

            ELSE
C---- MATR_ASSE MAITRE LIEE AU DOMAINE GLOBAL
              K14B = NUDEV(1:14)
              KMAREF = MATDEV//'.REFA'
            END IF

            CALL JEVEUO(KMAREF,'L',JREFA)
            CALL ASSERT(ZK24(JREFA-1+2) (1:14).EQ.K14B)
            CALL JEDETR(KMAREF(1:19)//'.LIME')
            CALL JEDETR(KMAREF(1:19)//'.JDRF')
            CALL JEDETR(KMAREF(1:19)//'.JDDC')
            CALL JEDETR(KMAREF(1:19)//'.JDFF')
            CALL JEDETR(KMAREF(1:19)//'.JDHF')
            CALL JEDETR(KMAREF(1:19)//'.JDPM')
            CALL JEDETR(KMAREF(1:19)//'.JDES')
            CALL JEDETR(KMAREF(1:19)//'.JDVL')
            CALL JEDETR(KMAREF)
          END IF

   20   CONTINUE
      END IF

C---- RECOPIE DE LA LISTE DES MAT_ELE DANS 1 OBJET JEVEUX DONT ON
C     GARDE L'ADRESSE DANS LE COMMON /CADMAT/
      CALL WKVECT(MATDEV//'.LIME',BASE1//' V K8 ',NBMAT,ILIMAT)
      DO 30 I = 1,NBMAT
        ZK8(ILIMAT+I-1) = TLIMAT(I)
   30 CONTINUE

C---- NOMS DES PRINCIPAUX OBJETS JEVEUX LIES A MATAS

      KMALIL = MATDEV//'.LILI'

C---- CALCUL D UN REPERTOIRE,TEMPORAIRE, MATDEV.LILI A PARTIR DE LA
C     LISTE DE MATRICES ELEMENTAIRES MATDEV.LIME
      CALL CRELIL(NBMAT,ILIMAT,KMALIL,'V','&MAILLA',MATDEV(1:19),IBID,
     &            MA,IBID,IBID,ILIMO,NLILI,NBELM)
      CALL JEVEUO(MATDEV(1:19)//'.ADLI','E',IADLIE)
      CALL JEVEUO(MATDEV(1:19)//'.ADNE','E',IADNEM)

      NCMP = NMXCMP


C---- NMALIL= NOMBRE DE NOM DU REPERTOIRE MATDEV.LILI DE NOM KMALIL
C     ILIMO = NUMERO DU 1ER LIGREL DE MODELE DE KMALIL
      NMALIL = NLILI

C---- ON SUPPOSE QUE LE NOM '&MAILLA' EST LE PREMIER DU REPERTOIRE
C     NU.LILI CE QUI EST VRAI CF S.P. CRELIL

      IF (LFETI) THEN
C STOCKE &&//NOMPRO(1:6)//'_M.' POUR COHERENCE AVEC L'EXISTANT
        K11B = MATDEV(1:11)
        NOMLOG = '&FETI.MAILLE.NUMSD'
        CALL JEVEUO(NOMLOG,'L',ILIGRP)
        ILIGRP = ILIGRP - 1
C CONSTITUTION DE L'OBJET JEVEUX MATDEV.FETM COMPLEMENTAIRE
        IF (ACREER) CALL WKVECT(MATDEV//'.FETM',BASE1//' V K24',NBSD,
     &                          IFETM)
        CALL JEVEUO('&FETI.INFO.CPU.ASSE','E',IFCPU)
      END IF

C========================================
C BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
C IDD=0 --> DOMAINE GLOBAL/ IDD=I --> IEME SOUS-DOMAINE
      DO 370 IDD = 0,NBSD

C TRAVAIL PREALABLE POUR DETERMINER SI ON EFFECTUE LA BOUCLE SUIVANT
C LE SOLVEUR (FETI OU NON), LE TYPE DE RESOLUTION (PARALLELE OU
C SEQUENTIELLE) ET L'ADEQUATION "RANG DU PROCESSEUR-NUMERO DU SD"
        IF (.NOT.LFETI) THEN
          IDDOK = .TRUE.

        ELSE
          IF (ZI(ILIMPI+IDD).EQ.1) THEN
            IDDOK = .TRUE.

          ELSE
            IDDOK = .FALSE.
          END IF

        END IF

        IF (IDDOK) THEN

C ATTENTION SI FETI LIBERATION MEMOIRE PREVUE EN FIN DE BOUCLE
          IF (LFETI) CALL JEMARQ()
C CALCUL TEMPS
          IF ((NIV.GE.2) .OR. (LFETIC)) THEN
            CALL UTTCPU(90,'INIT ',6,TEMPS)
            CALL UTTCPU(90,'DEBUT',6,TEMPS)
          END IF
C---- RECUPERATION DE PRNO/LILI/SMHC/SMDI/DESC
          IF (IDD.EQ.0) THEN
C SI DOMAINE GLOBAL FETI
            IF (LFETI) THEN
              K24PRN = NUDEV//'.NUME.PRNO'

            ELSE
C SI NON FETI
              K24PRN = NUDEV//'.NUME.PRNO'
              KNULIL = NUDEV//'.NUME.LILI'
              KSMHC = NUDEV//'.SMOS.SMHC'
              KSMDI = NUDEV//'.SMOS.SMDI'
              KSMDE = NUDEV//'.SMOS.SMDE'
            END IF

          ELSE IF (IDD.GT.0) THEN
C SI SOUS-DOMAINE FETI
            K14B = ZK24(IFETN+IDD-1) (1:14)
            K24PRN = K14B//'.NUME.PRNO'
            KNULIL = K14B//'.NUME.LILI'
            KSMHC = K14B//'.SMOS.SMHC'
            KSMDI = K14B//'.SMOS.SMDI'
            KSMDE = K14B//'.SMOS.SMDE'
          END IF

          IF ((.NOT.LFETI) .OR. (IDD.GT.0)) THEN
C SI SOUS-DOMAINE FETI OU NON FETI
            CALL JEVEUO(KSMHC,'L',JSMHC)
            CALL JEVEUO(KSMDI,'L',JSMDI)
            CALL JEVEUO(K24PRN,'L',IDPRN1)
            CALL JEVEUO(JEXATR(K24PRN,'LONCUM'),'L',IDPRN2)
          END IF

C---- CREATION ET REMPLISSAGE DE REFA
          IF (IDD.EQ.0) THEN
C SI NON FETI OU FETI DOMAINE GLOBAL
            KREFA = MATDEV//'.REFA'
C SI NON FETI
            IF (.NOT.LFETI) KVALM = MATDEV//'.VALM'

          ELSE
C SI SOUS-DOMAINE FETI NOUVEAU
            IF (ACREER) THEN
              CALL GCNCON('.',K8BID)
              K8BID(1:1) = 'F'
              K19B = K11B//K8BID
              ZK24(IFETM+IDD-1) = K19B

            ELSE
              K19B = ZK24(IFETM+IDD-1) (1:19)
            END IF

            KREFA = K19B//'.REFA'
            KVALM = K19B//'.VALM'
C RECUPERATION DANS LE .NUME.REFN DU NOM DE LA METHODE
            CALL JEVEUO(K14B//'.NUME.REFN','L',IREFN)
            METHOD = ZK24(IREFN+2)
            SDFETI = ZK24(IREFN+3)
          END IF

          CALL WKVECT(KREFA,BASE1//' V K24',10,JREFA)
          ZK24(JREFA-1+1) = MA
          ZK24(JREFA-1+2) = K24PRN(1:14)
          ZK24(JREFA-1+8) = 'ASSE'
          ZK24(JREFA-1+9) = 'MS'
          ZK24(JREFA-1+10) = 'NOEU'
C MAJ DU .REFA(4) EN FIN DE BOUCLE SUR LES SOUS-DOMAINES SI
C NON DOMAINE GLOBAL FETI
          IF (METHOD(1:4).EQ.'FETI') THEN
            ZK24(JREFA-1+5) = 'FETI'
            ZK24(JREFA-1+6) = SDFETI
          END IF

C SI FETI ET DOMAINE GLOBAL ON ENREGISTRE QUE LE .REFA
          IF ((LFETI) .AND. (IDD.EQ.0)) GO TO 360

C---- CREATION DE 2 OBJETS VOLATILS POUR ACCELERER CHARGER:
C---- TMP1 : (1:NBLC) INDIQUE LE NOMBRE DE REELS
C            S'INJECTANT DANS 1 BLOC
C---- TMP2 : (1:2*DIM(MATR_ELEM)) POSITION RELATIVE DANS LES BLOCS
C            POUR LE I-EME REEL DE LA MATRICE ELEM :
C     TMP2(2*(I-1)+1) --> NUMERO DU BLOC OU S'INJECTE I.
C     TMP2(2*(I-1)+2) --> POSITION DANS LE BLOC DU REEL I.

          KTMP1 = KVALM(1:19)//'.TMP1           '
          KTMP2 = KVALM(1:19)//'.TMP2           '
          CALL JEEXIN(KTMP1,IRET)
          CALL JEVEUO(KSMDE,'L',JSMDE)
          NEQU = ZI(JSMDE-1+1)
          ITBLOC = ZI(JSMDE-1+2)
          CALL ASSERT(ZI(JSMDE-1+3).EQ.1)
          NBLC = 1
          IF (IRET.LE.0) THEN
            CALL JECREO(KTMP1,' V V I')
            CALL JEECRA(KTMP1,'LONMAX',NBLC,' ')
          END IF

          CALL JEVEUO(KTMP1,'E',IATMP1)

C---- ALLOCATION VALM EN R OU C SUIVANT TYPE
          IF (ACREER) THEN
            IF (TYPE.EQ.1) THEN
              CALL JECREC(KVALM,BASE1//' V R','NU','DISPERSE',
     &                    'CONSTANT',NBLC)

            ELSE IF (TYPE.EQ.2) THEN
              CALL JECREC(KVALM,BASE1//' V C','NU','DISPERSE',
     &                    'CONSTANT',NBLC)

            ELSE
              CALL U2MESS('F','ASSEMBLA_4')
            END IF

            CALL JEECRA(KVALM,'LONMAX',ITBLOC,' ')
            DO 40 I = 1,NBLC
              CALL JECROC(JEXNUM(KVALM,I))
   40       CONTINUE

          ELSE
            IF (.NOT.CUMUL) THEN
C         -- REMISE A ZERO DE .VALM :
              DO 50 I = 1,NBLC
                CALL JERAZO(JEXNUM(KVALM,I),ITBLOC,1)
                CALL JELIBE(JEXNUM(KVALM,I))
   50         CONTINUE
            END IF

          END IF

C---- CALCUL DE VALM
C     ON COMMENCE PAR ASSEMBLER SUR LE MODELE
          IMO = 1
          RINF = R8MAEM()
          RSUP = -1.D0
          COEF = +1.D0
   60     CONTINUE


C --- REMPLISSAGE DE .VALM
C ===========================================================

C==========================
C BOUCLE SUR LES MATR_ELEM
C==========================
C     POUR LES MATRICES MORSE : IL N'Y A QU'1 BLOC. ON LE MET EN MEMOIRE
          CALL JEVEUO(JEXNUM(KVALM,1),'E',JVAL1)

C PREPARATION DE DONNEES AUXILIAIRES POUR TEST
          LGOTO=.FALSE.
          K24B(1:14)=NUDEV
          CALL FETTSD(INFOFE,IDD,IBID,IBID,SDFETI(1:19),K24B,IFETN,
     &                JVAL1,IBID,IFM,LBID,IBID,IBID,IBID,K19B,3,LGOTO)
          IF (LGOTO) GOTO 9999

          ILONG = 0
          DO 330 IMAT = 1,NBMAT
            MATEL = ZK8(ILIMAT+IMAT-1)
            CALL DISMOI('F','NOM_MODELE',MATEL,'MATR_ELEM',IBID,MO2,
     &                  IERD)
            CALL DISMOI('F','SUR_OPTION',MATEL,'MATR_ELEM',IBID,OPTIO,
     &                  IERD)

            IF (IMAT.EQ.1) THEN
              OPTIO2 = OPTIO

            ELSE
              IF (OPTIO2.NE.OPTIO) OPTIO2 = '&&MELANGE'
            END IF

            IF (MO2.NE.MO) CALL U2MESS('F','ASSEMBLA_5')
            IF (IMO.NE.1) GO TO 150


C         -- TRAITEMENT DES SOUS-STRUCTURES :
C         -----------------------------------
            CALL DISMOI('F','NB_SS_ACTI',MATEL,'MATR_ELEM',NBSSA,K8BID,
     &                  IERD)

            IF (NBSSA.GT.0) THEN
              CALL JEVEUO(MO//'.SSSA','L',IASSSA)

              CALL SSVALM('DEBUT',OPTIO,MO,MA,IMA,IDRESL,NCMPEL)

              DO 140,IMA = 1,NBSMA
                IF (ZI(IASSSA-1+IMA).EQ.0) GO TO 140

                CALL JEVEUO(JEXNUM(MA//'.SUPMAIL',IMA),'L',IAMAIL)
                CALL JELIRA(JEXNUM(MA//'.SUPMAIL',IMA),'LONMAX',NNOE,
     &                      K8BID)

                IREEL = 0
                R = LICOEF(IMAT)

                CALL SSVALM(' ',OPTIO,MO,MA,IMA,IDRESL,NCMPEL)
                IF (NCMPEL.GT.ILONG) THEN
                  ILONG = NCMPEL
                  CALL JEDETR(KTMP2)
                  CALL WKVECT(KTMP2,' V V I',2*ILONG,IATMP2)
                END IF

                NOMACR = ZK8(IANMCR-1+IMA)
                CALL DISMOI('F','NOM_NUME_DDL',NOMACR,'MACR_ELEM_STAT',
     &                      IBID,NUM2,IERD)
                CALL JEVEUO(NOMACR//'.CONX','L',IACONX)
                CALL JEVEUO(JEXNUM(NUM2//'.NUME.PRNO',1),'L',IAPROL)

                DO 130 K1 = 1,NNOE
                  N1 = ZI(IAMAIL-1+K1)
                  IF (N1.GT.NM) THEN
                    DO 70 IEC = 1,NBECMX
                      ICODGE(IEC) = ICODLA(IEC)
   70               CONTINUE

                  ELSE
                    INOLD = ZI(IACONX-1+3* (K1-1)+2)
                    DO 80 IEC = 1,NEC
                      ICODGE(IEC) = ZI(IAPROL-1+ (NEC+2)* (INOLD-1)+2+
     &                              IEC)
   80               CONTINUE
                  END IF

                  IAD1 = ZZPRNO(1,N1,1)
                  CALL CORDD2(IDPRN1,IDPRN2,1,ICODGE,NEC,NCMP,N1,NDDL1,
     &                        ZI(IAPSDL-1+NMXCMP* (K1-1)+1))
                  ZI(IANULO-1+2* (K1-1)+1) = IAD1
                  ZI(IANULO-1+2* (K1-1)+2) = NDDL1
                  DO 120 I1 = 1,NDDL1
                    DO 100 K2 = 1,K1 - 1
                      IAD2 = NUMLOC(K2,1)
                      NDDL2 = NUMLOC(K2,2)
                      DO 90 I2 = 1,NDDL2
                        IAD11 = ZI(IANUEQ-1+IAD1+POSDD2(K1,I1)-1)
                        IAD21 = ZI(IANUEQ-1+IAD2+POSDD2(K2,I2)-1)
                        IF (IAD11.LE.IAD21) THEN
                          IADLI = IAD11
                          IADCO = IAD21

                        ELSE
                          IADLI = IAD21
                          IADCO = IAD11
                        END IF

                        CALL ASRETM(IATMP2,IREEL,JSMHC,JSMDI,IADLI,
     &                              IADCO)
   90                 CONTINUE
  100               CONTINUE
                    K2 = K1
                    IAD2 = NUMLOC(K2,1)
                    NDDL2 = NUMLOC(K2,2)
                    DO 110 I2 = 1,I1
                      IAD11 = ZI(IANUEQ-1+IAD1+POSDD2(K1,I1)-1)
                      IAD21 = ZI(IANUEQ-1+IAD2+POSDD2(K2,I2)-1)
                      IF (IAD11.LE.IAD21) THEN
                        IADLI = IAD11
                        IADCO = IAD21

                      ELSE
                        IADLI = IAD21
                        IADCO = IAD11
                      END IF

                      CALL ASRETM(IATMP2,IREEL,JSMHC,JSMDI,IADLI,IADCO)
  110               CONTINUE
  120             CONTINUE
  130           CONTINUE
C         ---- POUR FINIR, ON RECOPIE EFFECTIVEMENT LES TERMES:
                ZI(IATMP1) = 1
                IF (TYPE.EQ.1) CALL ASCOPR(IATMP1,IATMP2,IREEL,IDRESL,
     &                                     NBLC,KVALM,R,1,JVAL1)
                IF (TYPE.EQ.2) CALL ASCOPC(IATMP1,IATMP2,IREEL,IDRESL,
     &                                     NBLC,KVALM,R,1,JVAL1)
  140         CONTINUE
              CALL SSVALM('FIN',OPTIO,MO,MA,IMA,IDRESL,NCMPEL)
            END IF


C         -- TRAITEMENT DES ELEMENTS FINIS CLASSIQUES
C         -----------------------------------------------------------
  150       CONTINUE
            CALL JEEXIN(MATEL//'.LISTE_RESU',IRET)
            IF (IRET.GT.0) THEN
              CALL JEVEUO(MATEL//'.LISTE_RESU','L',IDLRES)
              CALL JELIRA(MATEL//'.LISTE_RESU','LONUTI ',NBRESU,K1BID)

C==========================
C BOUCLE SUR LES RESU_ELEM
C==========================
              DO 320 IRESU = 1,NBRESU
                RESU = ZK24(IDLRES+IRESU-1)
                CALL JEEXIN(RESU(1:19)//'.DESC',IER)
                IF (IER.EQ.0) GO TO 320

                CALL JEVEUO(RESU(1:19)//'.NOLI','L',IAD)
C NOM DU LIGREL GLOBAL
                NOMLI = ZK24(IAD)

C--------- POUR FETI & LIGREL TARDIF: DEBUT
C PAR DEFAUT LIGREL DE MODELE
                LLIMO = .TRUE.
                LLICH = .FALSE.
                LLICHD = .FALSE.
                LLICHP = .FALSE.
C RECHERCHE D'OBJET TEMPORAIRE SI FETI
                IF ((LFETI) .AND. (IDD.NE.0)) THEN
                  NOMLOG = NOMLI(1:19)//'.FEL1'
                  CALL JEEXIN(NOMLOG,IRET1)
                  IF (IRET1.NE.0) THEN
C LIGREL DE CHARGE A MAILLES TARDIVES
                    CALL JEVEUO(NOMLOG,'L',IFEL1)
                    LLICH = .TRUE.
                    LLIMO = .FALSE.
                    IF (ZK24(IFEL1-1+IDD).EQ.' ') THEN
C LIGREL NE CONCERNANT PAS LE SOUS-DOMAINE IDD
                      GO TO 320

                    ELSE
                      CALL JEEXIN(NOMLI(1:19)//'.FEL2',IRET2)
                      IF (IRET2.NE.0) THEN
C LIGREL DE CHARGE A MAILLES TARDIVES DUPLIQUEES DE FILS NOMLID
C DDL_IMPO, FORCE_NODALE...
                        LLICHD = .TRUE.
C VRAI NOM DU LIGREL DUPLIQUE CONTENU DANS PROF_CHNO.LILI LOCAL
                        NOMLID = ZK24(IFEL1-1+IDD)
                        CALL JEVEUO(NOMLI(1:19)//'.FEL2','L',IFEL2)
                        CALL JEEXIN(NOMLI(1:19)//'.FEL3',IRET3)
                        IF (IRET3.NE.0) THEN
                          CALL JEVEUO(NOMLI(1:19)//'.FEL3','L',IFEL3)
C LIGREL DE CHARGE A NOEUDS TARDIFS DUPLIQUES (DDL_IMPO...)
                          LLICHP = .TRUE.

                        ELSE
C PAS DE NOEUD TARDIF DUPLIQUE (FORCE_NODALE)
                          LLICHP = .FALSE.
                        END IF

                        CALL JEEXIN(NOMLI(1:19)//'.FEL4',IRET3)
                        IF (IRET3.NE.0) CALL JEVEUO(NOMLI(1:19)//
     &                                       '.FEL4','L',IFEL4)
                        CALL JEEXIN(NOMLI(1:19)//'.FEL5',IRET3)
                        IF (IRET3.NE.0) CALL JEVEUO(NOMLI(1:19)//
     &                                       '.FEL5','L',IFEL5)

                      ELSE
C LIGREL DE CHARGE NON DUPLIQUE
                        LLICHD = .FALSE.
                      END IF

                    END IF

                  ELSE
C LIGREL DE MODELE
                    LLIMO = .TRUE.
                  END IF

                END IF
C--------- POUR FETI & LIGREL TARDIF: FIN

C ILIMA: INDICE DANS LIST_RESU (GLOBAL) DES MATR_ELEM.LILI DU NOMLI
C ILINU: INDICE DANS PROF_CHNO.LILI (GLOBAL OU LOCAL) DU NOMLI
                CALL JENONU(JEXNOM(KMALIL,NOMLI),ILIMA)
                IF (LLICHD) THEN
                  CALL JENONU(JEXNOM(KNULIL,NOMLID),ILINU)

                ELSE
                  CALL JENONU(JEXNOM(KNULIL,NOMLI),ILINU)
                END IF

C MONITORING
                IF ((INFOFE(5:5).EQ.'T') .AND. (LFETI)) WRITE (IFM,
     &              *) '<FETI/ASSMAM> IMO',IMO,'ILIMO',ILIMO,'ILIMA',
     &              ILIMA
                IF ((IMO.EQ.1) .AND. (ILIMA.NE.ILIMO)) GO TO 320
                IF ((IMO.EQ.0) .AND. (ILIMA.EQ.ILIMO)) GO TO 320
                CALL DISMOI('F','TYPE_SCA',RESU,'RESUELEM',IBID,TYPSCA,
     &                      IERD)

C==========================
C BOUCLE SUR LES GRELS DU LIGREL GLOBAL NOMLI/ILIMA
C==========================
                DO 310 IGR = 1,ZZNGEL(ILIMA)
                  CALL JEVEUO(RESU(1:19)//'.DESC','L',IADESC)
                  MODE = ZI(IADESC+IGR+1)
                  IF (MODE.GT.0) THEN
                    NNOE = NBNO(MODE)
                    NCMPEL = DIGDEL(MODE)
C NOMBRE D'ELEMENTS DU GREL IGR DU LIGREL NOMLI/ILIMA
                    NEL = ZZNELG(ILIMA,IGR)
                    CALL JEVEUO(JEXNUM(RESU(1:19)//'.RESL',IGR),'L',
     &                          IDRESL)
                    IF (NCMPEL.GT.ILONG) THEN
                      ILONG = NCMPEL
                      CALL JEEXIN(KTMP2,IRET2)
                      IF (IRET2.GT.0) CALL JEDETR(KTMP2)
                      CALL WKVECT(KTMP2,' V V I',2*ILONG,IATMP2)
                    END IF

C==========================
C BOUCLE SUR LES ELEMENTS DU GREL IGR
C==========================
                    DO 300 IEL = 1,NEL
                      IREEL = 0
                      ILAGR = 0
                      R = LICOEF(IMAT)
C NUMA : NUMERO DE LA MAILLE
                      NUMA = ZZLIEL(ILIMA,IGR,IEL)

C MONITORING
                      IF ((INFOFE(5:5).EQ.'T') .AND. (LFETI)) THEN
                        WRITE (IFM,*) '<FETI/ASSMAM>','IDD',IDD,
     &                    'LIGREL',NOMLI,'ILIMA',ILIMA
                        WRITE (IFM,*) 'IGR',IGR,'IEL',IEL,'NUMA',NUMA
                        IF (LLIMO) WRITE (IFM,*) '.LOGI',
     &                      ZI(ILIGRP+ABS(NUMA))
                        IF (LLICH) THEN
                          IF (LLICHD) THEN
                            WRITE (IFM,*) 'LIGREL DE CHARGE TARDIF '//
     &                        'DUPLIQUE DE FILS ',NOMLID

                          ELSE
                            WRITE (IFM,*)
     &                        'LIGREL DE CHARGE TARDIF INITIAL'
                          END IF

                        END IF

                      END IF
C SI ON EST DANS UN CALCUL FETI SUR UN SOUS-DOMAINE, ON SE POSE LA
C QUESTION DE L'APPARTENANCE DE LA MAILLE NUMA AU SOUS-DOMAINE IDD
                      IF (LFETI) THEN
                        IF (NUMA.GT.0) THEN
                          IF (LLICH) CALL U2MESS('F','ASSEMBLA_6')
C ELLE APPARTIENT AU GREL IGR DU LIGREL PHYSIQUE ILIMA
                          IF (ZI(ILIGRP+NUMA).NE.IDD) GO TO 300

                        ELSE
C ELLE APPARTIENT AU GREL IGR DU LIGREL TARDIF ILIMA
                          IF (LLIMO) CALL U2MESS('F','ASSEMBLA_7')
                        END IF

                      END IF

C---- LIGREL DE MODELE:
C--------------------
                      IF (NUMA.GT.0) THEN
                        IF (EPDMS.GT.0) R = R*ZR(JPDMS-1+NUMA)
                        DO 200 K1 = 1,NNOE
                          N1 = ZZCONX(NUMA,K1)
                          IAD1 = ZZPRNO(1,N1,1)
                          CALL CORDDL(ADMODL,LCMODL,IDPRN1,IDPRN2,1,
     &                                MODE,NEC,NCMP,N1,K1,NDDL1,
     &                                ZI(IAPSDL-1+NMXCMP* (K1-1)+1))
                          ZI(IANULO-1+2* (K1-1)+1) = IAD1
                          ZI(IANULO-1+2* (K1-1)+2) = NDDL1
                          DO 190 I1 = 1,NDDL1
                            DO 170 K2 = 1,K1 - 1
                              IAD2 = NUMLOC(K2,1)
                              NDDL2 = NUMLOC(K2,2)
                              DO 160 I2 = 1,NDDL2
                                IAD11 = ZI(IANUEQ-1+IAD1+POSDD2(K1,I1)-
     &                                  1)
                                IAD21 = ZI(IANUEQ-1+IAD2+POSDD2(K2,I2)-
     &                                  1)
                                IF (IAD11.LE.IAD21) THEN
                                  IADLI = IAD11
                                  IADCO = IAD21

                                ELSE
                                  IADLI = IAD21
                                  IADCO = IAD11
                                END IF

                                CALL ASRETM(IATMP2,IREEL,JSMHC,JSMDI,
     &                                      IADLI,IADCO)
  160                         CONTINUE
  170                       CONTINUE
                            K2 = K1
                            IAD2 = NUMLOC(K2,1)
                            NDDL2 = NUMLOC(K2,2)
                            DO 180 I2 = 1,I1
                              IAD11 = ZI(IANUEQ-1+IAD1+POSDD2(K1,I1)-1)
                              IAD21 = ZI(IANUEQ-1+IAD2+POSDD2(K2,I2)-1)
                              IF (IAD11.LE.IAD21) THEN
                                IADLI = IAD11
                                IADCO = IAD21

                              ELSE
                                IADLI = IAD21
                                IADCO = IAD11
                              END IF

                              CALL ASRETM(IATMP2,IREEL,JSMHC,JSMDI,
     &                                    IADLI,IADCO)
  180                       CONTINUE
  190                     CONTINUE
  200                   CONTINUE

                      ELSE

C---- LIGREL TARDIF:
C-------------------

C---- CONDITIONNEMENT DES LAGRANGE
C---- SI MAILLE A 3 NOEUDS ET SI ON N'EST PAS SUR LE MODELE ALORS :
C---- ILAGR = 1 POSSIBILITE DE NOEUDS DE LAGRANGE DANS LA MAILLE
                        IF ((NNOE.EQ.3) .AND. (IMO.EQ.0)) ILAGR = 1
                        NUMA = -NUMA

C--------- POUR FETI & LIGREL TARDIF: DEBUT
C SI POUR FETI, MAILLE TARDIVE DUPLIQUEE, ON SE POSE LA QUESTION DE
C L'APPARTENANCE DE CETTE MAILLE TARDIVE AU SOUS-DOMAINE IDD VIA
C L'OBJET .FEL2 (C'EST LE PENDANT DE &FETI.MAILLE.NUMSD POUR LES
C MAILLES DU MODELE)
                        IF (LLICHD) THEN
C LFEL2=.TRUE. ON ASSEMBLE LES CONTRIBUTIONS DE CETTE MAILLE TARDIVE
C LFEL2=.FALSE. ON LA SAUTE
                          LFEL2 = .FALSE.
                          IAUX1 = ZI(IFEL2+2* (NUMA-1)+1)
C C'EST UNE MAILLE TARDIVE NON SITUEE SUR UNE INTERFACE
                          IF (IAUX1.GT.0) THEN
C ELLE CONCERNE LE SD, ON L'ASSEMBLE
                            IF (IAUX1.EQ.IDD) LFEL2 = .TRUE.
C C'EST UNE MAILLE TRADIVE SITUEE SUR UNE INTERFACE, DONC PARTAGEE
C ENTRE PLUSIEURS SOUS-DOMAINES
                          ELSE IF (IAUX1.LT.0) THEN
                            COMPT = 0
                            IAUX2 = (ZI(IFEL4)/3) - 1
                            DO 210 JFEL4 = 0,IAUX2
                              IAUX3 = IFEL4 + 3*JFEL4 + 3
                              IF (ZI(IAUX3).EQ.NUMA) THEN
                                COMPT = COMPT + 1
                                IF (ZI(IAUX3-1).EQ.IDD) THEN
C ELLE CONCERNE LE SD, ON L'ASSEMBLE
                                  LFEL2 = .TRUE.
                                  GO TO 220

                                END IF
C ON A LU TOUTES LES VALEURS POSSIBLES, ON SORT DE LA BOUCLE
                                IF (COMPT.EQ.-IAUX1) GO TO 220
                              END IF

  210                       CONTINUE
  220                       CONTINUE
                          END IF
C ON SAUTE LA CONTRIBUTION
                          IF (.NOT.LFEL2) GO TO 300
                        END IF
C--------- POUR FETI & LIGREL TARDIF: FIN

C N1 : NBRE DE NOEUDS DE LA MAILLE NUMA
                        N1 = ZZNSUP(ILIMA,NUMA)
                        DO 290 K1 = 1,NNOE
C N1 : INDICE DU NOEUDS DS LE .NEMA DU LIGREL DE CHARGE GLOBAL OU LOCAL
                          N1 = ZZNEMA(ILIMA,NUMA,K1)
C NOEUD TARDIF
                          IF (N1.LT.0) THEN
                            N1 = -N1

C--------- POUR FETI & LIGREL TARDIF: DEBUT
C SI POUR FETI, NOEUD TARDIF DUPLIQUE, VERITABLE N1 DANS LE LIGREL DUPL
                            IF (LLICHP) THEN
                              IAUX1 = ZI(IFEL3+2* (N1-1)+1)
                              IF (IAUX1.GT.0) THEN
C C'EST UN NOEUD TARDIF LIE A UN DDL PHYSIQUE NON SUR L'INTERFACE
                                N1 = -ZI(IFEL3+2* (N1-1))

                              ELSE IF (IAUX1.LT.0) THEN
C C'EST UN NOEUD TARDIF LIE A UN DDL PHYSIQUE DE L'INTERFACE
                                IAUX2 = (ZI(IFEL5)/3) - 1
                                DO 230 JFEL4 = 0,IAUX2
                                  IAUX3 = IFEL5 + 3*JFEL4 + 3
                                  IF (ZI(IAUX3).EQ.N1) THEN
                                    IF (ZI(IAUX3-1).EQ.IDD) THEN
C VOICI SON NUMERO LOCAL CONCERNANT LE SD
                                      N1 = -ZI(IAUX3-2)
                                      GO TO 240

                                    END IF

                                  END IF

  230                           CONTINUE
  240                           CONTINUE
                              END IF

                            END IF
C--------- POUR FETI & LIGREL TARDIF: FIN

C NUMERO D'EQUATION DU PREMIER DDL DE N1
                            IAD1 = ZZPRNO(ILINU,N1,1)
                            CALL CORDDL(ADMODL,LCMODL,IDPRN1,IDPRN2,
     &                                  ILINU,MODE,NEC,NCMP,N1,K1,NDDL1,
     &                                  ZI(IAPSDL-1+NMXCMP* (K1-1)+1))

C---- SI NOEUD LAGR ( ILAGR=1,NDDL1=1,N1<0,NUMA<0 ) ALORS CONL(IAD1)=R
C---- ET POUR TOUTE LA MATRICE ELEMENTAIRE ON POSE R = COEF*LICOEF(IMAT)
                            IF ((ILAGR.EQ.1) .AND. (NDDL1.EQ.1)) THEN
                              R = COEF*LICOEF(IMAT)
                              ZR(IDCONL-1+ZI(IANUEQ-1+IAD1)) = R
                            END IF

                          ELSE
C NOEUD PHYSIQUE
                            IAD1 = ZZPRNO(1,N1,1)
                            CALL CORDDL(ADMODL,LCMODL,IDPRN1,IDPRN2,1,
     &                                  MODE,NEC,NCMP,N1,K1,NDDL1,
     &                                  ZI(IAPSDL-1+NMXCMP* (K1-1)+1))
                          END IF

                          ZI(IANULO-1+2* (K1-1)+1) = IAD1
                          ZI(IANULO-1+2* (K1-1)+2) = NDDL1
                          DO 280 I1 = 1,NDDL1
                            DO 260 K2 = 1,K1 - 1
                              IAD2 = NUMLOC(K2,1)
                              NDDL2 = NUMLOC(K2,2)
                              DO 250 I2 = 1,NDDL2
                                IAD11 = ZI(IANUEQ-1+IAD1+POSDD2(K1,I1)-
     &                                  1)
                                IAD21 = ZI(IANUEQ-1+IAD2+POSDD2(K2,I2)-
     &                                  1)
                                IF (IAD11.LE.IAD21) THEN
                                  IADLI = IAD11
                                  IADCO = IAD21

                                ELSE
                                  IADLI = IAD21
                                  IADCO = IAD11
                                END IF

                                CALL ASRETM(IATMP2,IREEL,JSMHC,JSMDI,
     &                                      IADLI,IADCO)
  250                         CONTINUE
  260                       CONTINUE
                            K2 = K1
                            IAD2 = NUMLOC(K2,1)
                            NDDL2 = NUMLOC(K2,2)
                            DO 270 I2 = 1,I1
                              IAD11 = ZI(IANUEQ-1+IAD1+POSDD2(K1,I1)-1)
                              IAD21 = ZI(IANUEQ-1+IAD2+POSDD2(K2,I2)-1)
                              IF (IAD11.LE.IAD21) THEN
                                IADLI = IAD11
                                IADCO = IAD21

                              ELSE
                                IADLI = IAD21
                                IADCO = IAD11
                              END IF

                              CALL ASRETM(IATMP2,IREEL,JSMHC,JSMDI,
     &                                    IADLI,IADCO)
  270                       CONTINUE
  280                     CONTINUE
  290                   CONTINUE
                      END IF
C---- POUR FINIR, ON RECOPIE EFFECTIVEMENT LES TERMES:
C     (IREEL CONTIENT LE NOMBRE DE REELS A TRAITER)
                      ZI(IATMP1) = 1
                      IF (TYPE.EQ.1) THEN
                        CALL ASCOPR(IATMP1,IATMP2,IREEL,
     &                              IDRESL+NCMPEL* (IEL-1),NBLC,KVALM,R,
     &                              1,JVAL1)

                      ELSE IF (TYPE.EQ.2) THEN
                        IF (TYPSCA.EQ.'R') THEN
                          CALL ASCOPN(IATMP1,IATMP2,IREEL,
     &                                IDRESL+NCMPEL* (IEL-1),NBLC,KVALM,
     &                                R,1,JVAL1)

                        ELSE IF (TYPSCA.EQ.'C') THEN
                          CALL ASCOPC(IATMP1,IATMP2,IREEL,
     &                                IDRESL+NCMPEL* (IEL-1),NBLC,KVALM,
     &                                R,1,JVAL1)
                        END IF

                      END IF

  300               CONTINUE
                    CALL JELIBE(JEXNUM(RESU(1:19)//'.RESL',IGR))
                  END IF

  310           CONTINUE
  320         CONTINUE
            END IF

  330     CONTINUE
 9999     CONTINUE
          IF (IMO.EQ.1) THEN

C---- SI ON VIENT DE TRAITER LE MODELE
            CALL JEVEUO(JEXNUM(KVALM,1),'L',IDV)
            DO 340 I = 1,NEQU
              IDI = ZI(JSMDI+I-1)
              IF (TYPE.EQ.1) R = ABS(ZR(IDV-1+IDI))
              IF (TYPE.EQ.2) R = ABS(ZC(IDV-1+IDI))
              IF ((R.NE.0.D0) .AND. (R.LT.RINF)) RINF = R
              IF ((R.NE.0.D0) .AND. (R.GT.RSUP)) RSUP = R
  340       CONTINUE
            CALL JELIBE(JEXNUM(KVALM,1))
            COEF = (RSUP+RINF)/2.D0
            IF (RINF.GE.R8MAEM()) COEF = RSUP/2.D0
            IF (NIV.EQ.2) WRITE (IFM,9000) COEF
            IMO = 0
C---- CREATION DE L'OBJET .CONL EN OPTION RIGI SI AU MOINS UNE CHARGE
            IF (NMALIL.GT.2) THEN
              KCONL = KREFA(1:19)//'.CONL'
              CALL JEDETR(KCONL)
              CALL WKVECT(KCONL,BASE1//' V R',NEQU,IDCONL)
              DO 350 I = 1,NEQU
                ZR(IDCONL-1+I) = 1.D0
  350         CONTINUE
            END IF

            GO TO 60

          END IF

C     -- MISE A JOUR DE REFA(4)
          CALL JEVEUO(KREFA,'E',JREFA)
          IF (ACREER) THEN
            ZK24(JREFA-1+4) = OPTIO2

          ELSE
            IF (ZK24(JREFA-1+4).NE.OPTIO2) ZK24(JREFA-1+4) = '&&MELANGE'
          END IF

          CALL JEDETR(KTMP1)
          CALL JEDETR(KTMP2)

C MONITORING
  360     CONTINUE
          IF (LFETI .AND. (INFOFE(1:1).EQ.'T')) THEN
            IF (IDD.EQ.0) THEN
              WRITE (IFM,*) '<FETI/ASSMAM> DOMAINE GLOBAL',KREFA(1:19)

            ELSE
              WRITE (IFM,*) '<FETI/ASSMAM> SD: ',IDD,' ',KREFA(1:19)
            END IF

            WRITE (IFM,9000) COEF
          END IF

          IF ((INFOFE(3:3).EQ.'T') .AND. (IDD.NE.0)) CALL UTIMSD(IFM,2,
     &        .FALSE.,.TRUE.,MATDEV,1,' ')
          IF ((INFOFE(3:3).EQ.'T') .AND. (IDD.EQ.NBSD)) CALL UTIMSD(IFM,
     &        2,.FALSE.,.TRUE.,MATDEV(1:19),1,' ')

          IF ((NIV.GE.2) .OR. (LFETIC)) THEN
            CALL UTTCPU(90,'FIN  ',6,TEMPS)
            IF (NIV.GE.2) WRITE (IFM,'(A44,D11.4,D11.4)')
     &          'TEMPS CPU/SYS ASSEMBLAGE M                : ',TEMPS(5),
     &          TEMPS(6)
            IF (LFETIC) ZR(IFCPU+IDD) = ZR(IFCPU+IDD) + TEMPS(5) +
     &                                  TEMPS(6)
          END IF


C EVENTUELLE ECRITURE DANS FICHIER SI FETI ET INFO_FETI(14:14)='T'
          K24B(1:14)=NUDEV
          CALL FETTSD(INFOFE,IDD,IBID,IBID,SDFETI(1:19),K24B,IFETN,
     &                JVAL1,IBID,IFM,LBID,IBID,IBID,IBID,K19B,6,LBID)

          IF (LFETI) CALL JEDEMA()
     
C========================================
C FIN BOUCLE SUR LES SOUS-DOMAINES + IF MPI:
C========================================
        END IF

  370 CONTINUE

      CALL JEDETR(MATDEV//'.ADNE')
      CALL JEDETR(MATDEV//'.ADLI')
      CALL JEDETR('&&ASSMAM.NUMLOC')
      CALL JEDETR('&&ASSMAM.POSDDL')

      CALL JEDBG2(IBID,IDBGAV)
      CALL JEDEMA()
C     CALL CHEKSD(MATDEV,'sd_matr_asse',IRET)
 9000 FORMAT (1P,'COEFFICIENT DE CONDITIONNEMENT DES LAGRANGES',E12.5)
      END

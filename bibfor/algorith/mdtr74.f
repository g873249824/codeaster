      SUBROUTINE MDTR74(NOMRES)
      IMPLICIT NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 18/12/2012   AUTEUR SELLENET N.SELLENET 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================

C     BUT: CALCUL TRANSITOIRE PAR DYNA_TRAN_MODAL DANS LE CAS OU LES
C          MATRICES ET VECTEURS PROVIENNENT D'UNE PROJECTION SUR :
C              - MODE_MECA
C              - MODE_GENE
C              - BASE_MODALE

C TOLE CRP_20
C ----------------------------------------------------------------------




      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNOM
      CHARACTER*1  NIV,K1BID
      CHARACTER*4  K4BID(3)
      CHARACTER*8  K8B,K8VAR,NOMRES,MASGEN,RIGGEN,AMOGEN,GYOGEN
      CHARACTER*8  BASEMO,MATASS,VECGEN,MONMOT,LISTAM,TYPFLU,NOMBM
      CHARACTER*8  RIGASS,MAILLA,RESGEN,BAMO1,BAMO2,RGYGEN
      CHARACTER*14 NUMDDL,NUMGEM,NUMGEK,NUMGEC,NUMGEG,K14B
      CHARACTER*16 TYPBAS,TYPBA2,METHOD
      CHARACTER*19 LISARC,NOMSTM,NOMSTK,NOMSTG,MASSE
      CHARACTER*24 NUMK24,NUMM24,NUMC24,LISINS,NOMNOE,TYPEBA
      CHARACTER*24 VALK(3)
      CHARACTER*19 MARIG
      LOGICAL      LAMOR,LFLU
      INTEGER      KREF,ITYPFL,NEXCIT,NEXCIR,NTOTEX
      INTEGER      VALI(3),JVEC,JVECR,J1,J2
      REAL*8       R8B,XLAMBD,ACRIT,AGENE
      REAL*8       VALR(3)
      REAL*8       DT,DTS,DTU,DTMAX
      REAL*8       RAD
      CHARACTER*19 FONCT
      CHARACTER*8  FK(2),DFK(2),FONCV,FONCA,FONCP

C  COUPLAGE EDYOS/FISSURE
C =>
      REAL*8        VROTAT,DTSTO,TCF,ANGINI

      INTEGER       NBEDYO,UNITPA
      INTEGER       INFO
C
C     COMMON
C     ======
      INTEGER       NBPAL, NBRFIS
C
      INTEGER       IADRI
      CHARACTER*24  NPAL
C
      LOGICAL       PRDEFF
      INTEGER      IARG

C =<

C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      INTEGER I ,IAM ,IAMOG ,IB ,IBID ,ICOUPL ,IDIFF
      INTEGER IE ,IER ,IFIMP ,IFM ,IG ,IINDIC ,IM
      INTEGER INDIC ,IOC ,IPARCH ,IPTCHO ,IRE ,IRET ,IRFIMP
      INTEGER NG1,NG2,NNG1,NNG0,NNG2,JREFAG,JSCDEG,JGYOG,JRGYG
      INTEGER ISOUPL ,ITEMAX ,ITRANS ,ITRLOC ,IVCHOC ,IVECI1 ,IVECR1
      INTEGER IVECR2 ,IVECR3 ,IVECR4 ,IVECR5 ,JABSC ,JACCS ,JAMO1
      INTEGER JAMO2 ,JAMOG ,JARCH ,JBASE ,JBASF ,JCODIM ,JCOEFM
      INTEGER JDCHO ,JDEP0 ,JDEPL ,JDEPS ,JDESC ,JDFK ,JDRIF
      INTEGER JFCHO ,JFK ,JFOND ,JFONV ,JGR ,JIADVE ,JICHO
      INTEGER JIDESC ,JINST ,JINTI ,JINUMO ,JLOCF ,JMASG ,JNOACC
      INTEGER JNODEP ,JNOEC ,JNOMFO ,JNOVIT ,JORDR ,JPARC ,JPARD
      INTEGER JPASS ,JPHIE ,JPOIDS ,JPSDEL ,JPSID ,JPUL2 ,JPULS
      INTEGER JRAIG ,JRANC ,JREDC ,JREDD ,JREDE ,JREFA ,JREFAC
      INTEGER JREVC ,JREVD
      INTEGER JREFAK ,JREFAM ,JREVI ,JRHOE ,JSCDEK ,JSCDEM ,JVCHO
      INTEGER JVIT0 ,JVITS ,LAMRE ,LIRES ,LLNEQU ,LMAT ,LNOE
      INTEGER LPROFV ,LPROL ,N ,N1 ,N2 ,NA ,NBAMOR
      INTEGER NBCHO1 ,NBCHOC ,NBEXIT ,NBF ,NBFLAM ,NBFV ,NBM0
      INTEGER NBMD ,NBMG ,NBMOD2 ,NBMODE ,NBMP ,NBNLI ,NBPAS
      INTEGER NBREDE ,NBRETR ,NBREVI ,NBSAUV ,NBSISM ,NBSTOC ,NBSTOK
      INTEGER NBSTOM ,NEQ ,NGR ,NM ,NMP  ,NR
      INTEGER NTERM ,NTS ,NUMVIF ,NV
      REAL*8 CRIT ,DEUX ,DTARCH ,EPS ,OMEG2 ,PREC ,R8DGRD
      REAL*8 R8PREM ,SEUIL ,TFEXM ,TFIN ,TINIT ,TS ,VGAP

C-----------------------------------------------------------------------
      DATA K14B/'              '/
      CALL JEMARQ()
      DEUX = 2.D0
C-----------------------------------------------------------------------


      IBID = 0
      JRANC = 1
      JPARC = 1
      JNOEC = 1
      JREDE = 1
      JPARD = 1
      JFOND = 1
      JREVI = 1
      JFONV = 1
      JDEPL = 1
      JCOEFM = 1
      JIADVE = 1
      JINUMO = 1
      JIDESC = 1
      JNODEP = 1
      JNOVIT = 1
      JNOMFO = 1
      JPSDEL = 1
      JPSID = 1
      MONMOT = 'NON'
      LISINS = ' '
      PRDEFF = .TRUE.
      CALL INFNIV(IFM,INFO)

      RAD = R8DGRD()

      LAMOR = .FALSE.
      LFLU = .FALSE.
C     --- RECUPERATION DES ARGUMENTS DE LA COMMANDE ---

      CALL GETVTX('SCHEMA_TEMPS','SCHEMA',1,IARG,1,METHOD,N1)
      CALL GETVIS('PARA_LAME_FLUI','NMAX_ITER',1,IARG,1,ITEMAX,N1)
      CALL GETVR8('PARA_LAME_FLUI','RESI_RELA',1,IARG,1,PREC,N1)
      CALL GETVR8('PARA_LAME_FLUI','LAMBDA',1,IARG,1,XLAMBD,N1)
      CALL GETFAC('EXCIT',NEXCIT)
      CALL GETFAC('EXCIT_RESU',NEXCIR)

C     --- RECUPERATION DES MATRICES PROJETEES ---

      CALL GETVID(' ','MATR_MASS',0,IARG,1,MASGEN,NM)
      CALL GETVID(' ','MATR_RIGI',0,IARG,1,RIGGEN,NR)
      CALL GETVID(' ','MATR_AMOR',0,IARG,1,AMOGEN,NA)
      IF (NEXCIT.NE.0) THEN
        CALL WKVECT('&&MDTR74.NOMVEC','V V K8',NEXCIT,JVEC)
        DO 10 I = 1,NEXCIT
          CALL GETVID('EXCIT','VECT_ASSE_GENE',I,IARG,1,VECGEN,NV)
          ZK8(JVEC-1+I) = VECGEN
10      CONTINUE
      END IF
      IF (NEXCIR.NE.0) THEN
        CALL WKVECT('&&MDTR74.NOMVER','V V K8',NEXCIR,JVECR)
        DO 11 I = 1,NEXCIR
          CALL GETVID('EXCIT_RESU','RESULTAT',I,IARG,1,RESGEN,NV)
          ZK8(JVECR-1+I) = RESGEN
C ------- VERIF : LA BASE DE MODES ASSOCIEE EST CELLE DES MATRICES GENE
          CALL JEVEUO(MASGEN//'           .REFA','L',J1)
          BAMO1=ZK24(J1-1+1)(1:8)
          CALL JEVEUO(RESGEN//'           .REFD','L',J2)
          BAMO2=ZK24(J2-1+5)(1:8)
          IF (BAMO1.NE.BAMO2) THEN
            CALL U2MESG('F','ALGORITH17_18',0,K8B,1,I,0,R8B)
          ENDIF
11      CONTINUE
      END IF
      IF (NA.EQ.0) LAMOR = .TRUE.

C     --- RECUPERATION DE LA NUMEROTATION GENERALISEE DE M, K

      CALL JEVEUO(MASGEN//'           .REFA','L',JREFAM)
      NUMGEM = ZK24(JREFAM-1+2)(1:14)
      NOMSTM = NUMGEM//'.SLCS'
      CALL JEVEUO(NOMSTM//'.SCDE','L',JSCDEM)
      NBSTOM = ZI(JSCDEM-1+1)*ZI(JSCDEM-1+4)
C
      CALL JEVEUO(RIGGEN//'           .REFA','L',JREFAK)
      NUMGEK = ZK24(JREFAK-1+2)(1:14)
      NOMSTK = NUMGEK//'.SLCS'
      CALL JEVEUO(NOMSTK//'.SCDE','L',JSCDEK)
      NBSTOK = ZI(JSCDEK-1+1)*ZI(JSCDEK-1+4)

C     --- RECUPERATION DE LA BASE MODALE ET NOMBRE DE MODES ---

      CALL JEVEUO(MASGEN//'           .DESC','L',JDESC)
      NBMODE = ZI(JDESC+1)
      BASEMO = ZK24(JREFAM-1+1)(1:8)
      CALL JEVEUO(BASEMO//'           .REFD','L',JDRIF)
      RIGASS = ZK24(JDRIF) (1:8)
C------------on recupere le type de base modale---------
      TYPEBA=ZK24(JDRIF+6)
C-------------------------------------------------------
      MARIG = '&&MDTR74.RIGI'
      CALL COPISD('MATR_ASSE','V',RIGASS,MARIG)
      CALL JEEXIN(MARIG//'.REFA',IER)
      IF (IER.EQ.0) CALL WKVECT(MARIG//'.REFA','V V K24',11,JREFA)
      CALL JEVEUO(MARIG//'.REFA','E',JREFA)
      ZK24(JREFA-1+7)='&&OP0074.SOLVEUR'

      CALL GETTCO(BASEMO,TYPBAS)
      CALL MTDSCR(MASGEN)
      CALL JEVEUO(MASGEN//'           .&INT','L',LMAT)
      NTERM = ZI(LMAT+14)
      TYPBA2 = TYPBAS
C
      IF ((TYPBAS.EQ.'MODE_MECA'.AND.NTERM.GT.NBMODE).OR.
     &    (TYPBAS.EQ.'MODE_GENE'.AND.NTERM.GT.NBMODE)) THEN
         TYPBAS = 'BASE_MODA'
      ENDIF
C
      IF (TYPEBA(1:).NE.' '.AND.NTERM.EQ.NBMODE) THEN
         TYPBAS = 'MODE_MECA'
C
      ELSEIF (TYPEBA(1:).NE.' '.AND.NTERM.GT.NBMODE) THEN
         TYPBAS = 'BASE_MODA'
      ENDIF
C
      NBSTOC = NBMODE

      IF (TYPBA2(1:9).EQ.'MODE_MECA'.AND.TYPEBA(1:1).EQ.' ') THEN
        MATASS = ZK24(JDRIF) (1:8)
        CALL DISMOI('F','NOM_MAILLA',MATASS,'MATR_ASSE',IBID,MAILLA,IE)
        CALL DISMOI('F','NOM_NUME_DDL',MATASS,'MATR_ASSE',IB,NUMDDL,IE)
        CALL DISMOI('F','NB_EQUA',MATASS,'MATR_ASSE',NEQ,K8B,IE)
        NBMOD2 = NBMODE
C
      ELSE IF (TYPEBA(1:1).NE.' ') THEN
        NUMDDL = ZK24(JDRIF+3) (1:14)
        CALL DISMOI('F','NOM_MAILLA',NUMDDL,'NUME_DDL',IB,MAILLA,IE)
        CALL DISMOI('F','NB_EQUA'   ,NUMDDL,'NUME_DDL',NEQ,K8B,IE)
        NBMOD2 = NBMODE
      ELSE IF (TYPBA2(1:9).EQ.'MODE_GENE') THEN
        MATASS = ZK24(JDRIF) (1:8)
        CALL JEVEUO(MATASS//'           .REFA','L',JREFA)
        NUMDDL = ZK24(JREFA-1+2)(1:14)
        CALL DISMOI('F','NOM_MAILLA',NUMDDL,'NUME_DDL',IB,MAILLA,IE)
        CALL JEVEUO(NUMDDL//'.NUME.NEQU','L',LLNEQU)
        NEQ = ZI(LLNEQU)
        NBMOD2 = NBMODE
      ELSE
        CALL U2MESS('F','ALGORITH5_65')
      END IF

C     --- RECOPIE DES MATRICES DANS DES VECTEURS DE TRAVAIL ---

      CALL WKVECT('&&MDTR74.MASSEGEN','V V R',NBSTOM,JMASG)
      CALL WKVECT('&&MDTR74.RAIDEGEN','V V R',NBSTOK,JRAIG)
      CALL WKVECT('&&MDTR74.AMORTGEN','V V R',NBSTOC,JAMO1)
      CALL WKVECT('&&MDTR74.PULSATIO','V V R',NBMODE,JPULS)
      CALL WKVECT('&&MDTR74.PULSAT2','V V R',NBMODE,JPUL2)
      NUMM24(1:14) = NUMGEM
      NUMK24(1:14) = NUMGEK
      CALL EXTDIA(MASGEN,NUMM24,0,ZR(JMASG))
      CALL EXTDIA(RIGGEN,NUMK24,0,ZR(JRAIG))

C     --- RECOPIE DES MODES DU CONCEPT RESULTAT DANS UN VECTEUR ---

      CALL WKVECT('&&MDTR74.BASEMODE','V V R',NBMODE*NEQ,JBASE)
C
      IF (TYPEBA(1:1).EQ.' ') THEN
        CALL COPMOD(BASEMO,'DEPL',NEQ,NUMDDL,NBMODE,ZR(JBASE))
      ELSE
        CALL COPMO2(BASEMO,NEQ,NUMDDL,NBMODE,ZR(JBASE))
      ENDIF
      DO 20 I = 0,NBMODE - 1
        OMEG2 = ABS(ZR(JRAIG+I)/ZR(JMASG+I))
        ZR(JPULS+I) = SQRT(OMEG2)
        ZR(JPUL2+I) = OMEG2
   20 CONTINUE

C     --- RECUPERATION DE L AMORTISSEMENT ---

C     ... RECUPERATION D'UNE LISTE D'AMORTISSEMENTS REDUITS ...

      IF (LAMOR) THEN

        AMOGEN = '&&AMORT'
        CALL GETVR8('AMOR_MODAL','AMOR_REDUIT',1,IARG,0,R8B,N1)
        CALL GETVID('AMOR_MODAL','LIST_AMOR',1,IARG,0,K8B,N2)
        IF (N1.NE.0 .OR. N2.NE.0) THEN
          IF (N1.NE.0) THEN
            NBAMOR = -N1
          ELSE
            CALL GETVID('AMOR_MODAL','LIST_AMOR',1,IARG,1,LISTAM,N)
            CALL JELIRA(LISTAM//'           .VALE','LONMAX',NBAMOR,K8B)
          END IF
          IF (NBAMOR.GT.NBMODE) THEN

            VALI (1) = NBMODE
            VALI (2) = NBAMOR
            VALI (3) = NBMODE
            VALK (1) = 'PREMIERS COEFFICIENTS'
            CALL U2MESG('A','ALGORITH16_18',1,VALK,3,VALI,0,0.D0)
            CALL WKVECT('&&MDTR74.AMORTI','V V R8',NBMODE,JAMOG)
            IF (N1.NE.0) THEN
              CALL GETVR8('AMOR_MODAL','AMOR_REDUIT',1,IARG,NBMODE,
     &                    ZR(JAMOG),N)
            ELSE
              CALL JEVEUO(LISTAM//'           .VALE','L',IAMOG)
              DO 30 IAM = 1,NBMODE
                ZR(JAMOG+IAM-1) = ZR(IAMOG+IAM-1)
   30         CONTINUE
            END IF
          ELSE IF (NBAMOR.LT.NBMODE) THEN

            CALL WKVECT('&&MDTR74.AMORTI','V V R8',NBAMOR,JAMOG)
            IF (N1.NE.0) THEN
              CALL GETVR8('AMOR_MODAL','AMOR_REDUIT',1,IARG,NBAMOR,
     &                     ZR(JAMOG),N)
            ELSE
              CALL JEVEUO(LISTAM//'           .VALE','L',IAMOG)
              DO 40 IAM = 1,NBAMOR
                ZR(JAMOG+IAM-1) = ZR(IAMOG+IAM-1)
   40         CONTINUE
            END IF
            IDIFF = NBMODE - NBAMOR
            VALI (1) = IDIFF
            VALI (2) = NBMODE
            VALI (3) = IDIFF
            CALL U2MESI('I','ALGORITH16_19',3,VALI)
            CALL WKVECT('&&MDTR74.AMORTI2','V V R8',NBMODE,JAMO2)
            DO 50 IAM = 1,NBAMOR
              ZR(JAMO2+IAM-1) = ZR(JAMOG+IAM-1)
   50       CONTINUE
            DO 60 IAM = NBAMOR + 1,NBMODE
              ZR(JAMO2+IAM-1) = ZR(JAMOG+NBAMOR-1)
   60       CONTINUE
            JAMOG = JAMO2
          ELSE IF (NBAMOR.EQ.NBMODE) THEN

            CALL WKVECT('&&MDTR74.AMORTI','V V R8',NBAMOR,JAMOG)
            IF (N1.NE.0) THEN
              CALL GETVR8('AMOR_MODAL','AMOR_REDUIT',1,IARG,NBAMOR,
     &                    ZR(JAMOG),N)
            ELSE
              CALL JEVEUO(LISTAM//'           .VALE','L',IAMOG)
              DO 70 IAM = 1,NBAMOR
                ZR(JAMOG+IAM-1) = ZR(IAMOG+IAM-1)
   70         CONTINUE
            END IF
          END IF
        ELSE
          CALL WKVECT('&&MDTR74.AMORTI','V V R8',NBMODE,JAMOG)
          DO 80 IM = 1,NBMODE
C            IF (TYPBA2(1:9).NE.'MODE_STAT'.AND.
C     &          TYPBA2(1:9).NE.'BASE_MODA') THEN
            IF (TYPEBA(1:1).EQ.' ') THEN
              CALL RSADPA(BASEMO,'L',1,'AMOR_REDUIT',IM,0,LAMRE,K8B)
              ZR(JAMOG+IM-1) = ZR(LAMRE)
            ELSE
              ZR(JAMOG+IM-1) = 0.D0
            ENDIF
   80     CONTINUE
        END IF
        AMOGEN = '        '

      END IF

C     ... RECUPERATION D'UNE MATRICE D'AMORTISSEMENTS DIMENSIONNELS ...

      IF (.NOT.LAMOR) THEN

C        RECUP NUMEROTATION GENE DE MATRICE AMORTISSEMENT
        CALL JEVEUO(AMOGEN//'           .REFA','L',JREFAC)
        NUMGEC = ZK24(JREFAC-1+2)(1:14)
        NUMC24(1:14) = NUMGEC
        CALL EXTDIA(AMOGEN,NUMC24,0,ZR(JAMO1))
        DO 90 I = 1,NBMOD2
          ACRIT = DEUX*SQRT(ABS(ZR(JMASG+I-1)*ZR(JRAIG+I-1)))
          AGENE = ZR(JAMO1+I-1)
          IF (AGENE.GT.ACRIT) THEN
            VALI (1) = I
            VALR (1) = AGENE
            VALR (2) = ACRIT
            VALK (1) = ' '
            CALL U2MESG('A','ALGORITH16_20',1,VALK,1,VALI,2,VALR)
          END IF
   90   CONTINUE
C        PROBLEME POSSIBLE DU JEVEUO SUR UNE COLLECTION
        CALL WKVECT('&&MDTR74.AMORTI','V V R8',NBMODE*NBMODE,JAMOG)
             CALL COPMAT(AMOGEN,NUMGEC,ZR(JAMOG))

      END IF
      VROTAT = 0.D0
      CALL GETVTX(' ','VITESSE_VARIABLE',1,IARG,1,K8VAR,N1)
      CALL WKVECT('&&MDTR74.GYROSC','V V R8',NBMODE*NBMODE,JGYOG)
      CALL WKVECT('&&MDTR74.RIGYRO','V V R8',NBMODE*NBMODE,JRGYG)
      IF (K8VAR.EQ.'OUI') THEN
        CALL GETVID(' ','VITE_ROTA' ,I,IARG,1,FONCV,NNG1)
        CALL GETVID(' ','ACCE_ROTA' ,I,IARG,1,FONCA,NNG2)
        CALL GETVID(' ','MATR_GYRO',0,IARG,1,GYOGEN,NG1)
        CALL GETVID(' ','MATR_RIGY',0,IARG,1,RGYGEN,NG2)
        CALL JEVEUO(GYOGEN//'           .REFA','L',JREFAG)
        NUMGEG = ZK24(JREFAG-1+2)(1:14)
        NOMSTG = NUMGEG//'.SLCS'
        CALL JEVEUO(NOMSTG//'.SCDE','L',JSCDEG)
        CALL COPMAT(GYOGEN,NUMGEG,ZR(JGYOG))
        IF (NG2.NE.0) THEN
          CALL COPMAT(RGYGEN,NUMGEG,ZR(JRGYG))
        ENDIF
      ELSE
        CALL GETVR8(' ','VITE_ROTA',1,IARG,1,VROTAT,N1)
      END IF
C
C     --- VERIFICATION DES DONNEES GENERALISEES ---
C
      CALL MDGENE(BASEMO,NBMODE,K14B,MASGEN,RIGGEN,AMOGEN,NEXCIT,JVEC,
     &            IRET)
      IF (IRET.NE.0) GO TO 120

      IF (METHOD.EQ.'ITMI') THEN
C        --- DONNEES ITMI ---
        CALL JEDETR('&&MDTR74.PULSATIO')
        CALL JEDETR('&&MDTR74.MASSEGEN')
        CALL JEDETR('&&MDTR74.AMORTGEN')
        CALL JEDETR('&&MDTR74.BASEMODE')
        CALL JEDETR('&&MDTR74.AMORTI')
C--- ET POUR GAGNER DE LA PLACE
        CALL JEDETR('&&MDTR74.PULSAT2')
        NBMODE = 0
        CALL MDITMI(TYPFLU,NOMBM,ICOUPL,NBM0,NBMODE,NBMD,
     &           VGAP,ITRANS,EPS,TS, NTS,ITYPFL)
        CALL JEVEUO('&&MDITMI.PULSATIO','L'    ,JPULS)
        CALL JEVEUO('&&MDITMI.MASSEGEN','L'    ,JMASG)
        CALL JEVEUO('&&MDITMI.AMORTI'  ,'L'    ,JAMOG)
        CALL JEVEUO('&&MDITMI.AMORTGEN','L'    ,JAMO1)
        CALL JEVEUO('&&MDITMI.BASEMODE','L'    ,JBASE)
        CALL JEVEUO('&&MDITMI.LOCFL0'  ,'L'    ,JLOCF)
        CALL GETVIS( 'SCHEMA_TEMPS','NUME_VITE_FLUI',1,IARG,1,NUMVIF,N1)
        CALL GETVIS ( 'SCHEMA_TEMPS','NB_MODE_FLUI',1,IARG,1,NBMP,NMP)
        IF (ITYPFL.EQ.1) THEN
          CALL JEVEUO('&&MDITMI.TEMP.IRES'  ,'L'   ,LIRES )
          CALL JEVEUO('&&MDITMI.TEMP.PROFV' ,'L'   ,LPROFV)
          CALL JEVEUO('&&MDITMI.TEMP.RHOE'  ,'L'   ,JRHOE )
          CALL JEVEUO('&&MDITMI.TEMP.BASEFL','L'   ,JBASF )
          CALL JEVEUO('&&MDITMI.TEMP.PHIE'  ,'L'   ,JPHIE )
          CALL JEVEUO('&&MDITMI.TEMP.ABSCV' ,'L'   ,JABSC )
         IVECI1 = LIRES
         IVECR1 = LPROFV
         IVECR2 = JRHOE
         IVECR3 = JBASF
         IVECR4 = JPHIE
         IVECR5 = JABSC
        END IF
        IF(ITYPFL.EQ.2) THEN
          CALL JEVEUO('&&MDITMI.TEMP.CODIM' ,'L'  ,JCODIM)
          CALL JEVEUO('&&MDITMI.TEMP.POIDS' ,'L'  ,JPOIDS)
          CALL JEVEUO('&&MDITMI.TEMP.PHIE'  ,'L'  ,JPHIE )
         IVECI1= 1
         IVECR1= JMASG
         IVECR2 = JCODIM
         IVECR3 = JPOIDS
         IVECR4  = JPHIE
         IVECR5= 1
         END IF
      END IF
C
C     --- RECUPERATION DES PARAMETRES D'EXCITATION
C
      NTOTEX = NEXCIT + NEXCIR*NBMODE
      JNOACC=1
      IF (NTOTEX.NE.0) THEN
        CALL WKVECT('&&MDTR74.COEFM','V V R8',NTOTEX,JCOEFM)
        CALL WKVECT('&&MDTR74.IADVEC','V V IS',NTOTEX,JIADVE)
        CALL WKVECT('&&MDTR74.INUMOR','V V IS',NTOTEX,JINUMO)
        CALL WKVECT('&&MDTR74.IDESCF','V V IS',NTOTEX,JIDESC)
        CALL WKVECT('&&MDTR74.NOMFON','V V K8',2*NTOTEX,JNOMFO)
        CALL WKVECT(NOMRES//'           .FDEP','G V K8',2*NTOTEX,JNODEP)
        CALL WKVECT(NOMRES//'           .FVIT','G V K8',2*NTOTEX,JNOVIT)
        CALL WKVECT(NOMRES//'           .FACC','G V K8',2*NTOTEX,JNOACC)
C
        CALL MDRECF(NEXCIT,NEXCIR,ZI(JIDESC),ZK8(JNOMFO),ZR(JCOEFM),
     &              ZI(JIADVE),ZI(JINUMO),ZK8(JNODEP),ZK8(JNOVIT),
     &              ZK8(JNOACC),NEQ,TYPBA2,BASEMO,NBMODE,
     &              ZR(JRAIG),MONMOT,NOMRES)
        CALL JEEXIN(NOMRES//'           .IPSD',IRET)
        IF ( IRET.NE.0 )
     &    CALL JEVEUO(NOMRES//'           .IPSD','E',JPSDEL)

        IF (METHOD.EQ.'ITMI') THEN
          NBF = 0
          DO 100 I = 1,NTOTEX
            CALL JELIRA(ZK8(JNOMFO-1+I)//'           .VALE','LONMAX',
     &                  NBFV,K8B)
            NBFV = NBFV/2
            NBF = MAX(NBF,NBFV)
  100     CONTINUE
        END IF
      END IF
C
C     --- CHOC  ET  ANTI_SISM ---
C
      CALL GETFAC ( 'ANTI_SISM', NBSISM )
      CALL GETFAC ( 'FLAMBAGE' , NBFLAM )
      CALL GETFAC ( 'CHOC'     , NBCHO1 )
C
      NBCHOC = 0
      DO 200 IOC = 1, NBCHO1
        CALL GETVTX ( 'CHOC', 'MAILLE', IOC,IARG,0, K8B, N1 )
        IF ( N1 .NE. 0 ) THEN
          NBCHOC = NBCHOC - N1
        ELSE
          CALL GETVTX ( 'CHOC', 'GROUP_MA', IOC,IARG,0, K8B, N2 )
          IF ( N2 .NE. 0 ) THEN
            NGR = -N2
            CALL WKVECT('&&MDTR74.GROUP_MA','V V K24',NGR,JGR)
            CALL GETVTX ('CHOC','GROUP_MA',IOC,IARG,NGR,
     &                   ZK24(JGR), N2 )
            DO 210 IG = 0, NGR-1
              CALL JELIRA(JEXNOM(MAILLA//'.GROUPEMA',ZK24(JGR+IG)),
     &                                           'LONMAX',NBMG,K8B)
              NBCHOC = NBCHOC + NBMG
 210        CONTINUE
            CALL JEDETR('&&MDTR74.GROUP_MA')
          ELSE
            NBCHOC = NBCHOC + 1
          END IF
        END IF
 200  CONTINUE
C
      NBNLI = NBCHOC + NBSISM + NBFLAM
C
C     --- COUPLAGE EDYOS ---
C =>
      NBEDYO = 0
      CALL GETFAC ( 'COUPLAGE_EDYOS', NBEDYO )
      NBPAL = 0
      DTSTO = 0.D0
      TCF = 0.D0
      IF ( NBEDYO .NE. 0 ) THEN
        CALL GETFAC ( 'PALIER_EDYOS', NBEDYO )
        IF ( NBEDYO .NE. 0 ) THEN
C Lecture des donnees paliers
          CALL GETVIS('PALIER_EDYOS','UNITE',1,IARG,1,UNITPA,N1)
          IF ( N1 .NE. 0 ) THEN
            CALL LECDON(.TRUE.,UNITPA,PRDEFF)
          ELSE
            CALL LECDON(.FALSE.,0,PRDEFF)
          ENDIF
          CALL GETVR8('COUPLAGE_EDYOS','PAS_TPS_EDYOS',1,IARG,1,
     &                 DTSTO,N1)
        ELSE
          CALL U2MESS('F','EDYOS_48')
        ENDIF
C  Recuperation du nombre de paliers
        NPAL='N_PAL'
        CALL JEVEUO(NPAL,'L',IADRI)
        NBPAL=ZI(IADRI)
        NBNLI = NBNLI + NBPAL
      ENDIF
C =<
C
C     --- NON LINEARITE DE ROTOR FISSURE ---
C =>
      NBRFIS = 0
      ANGINI = 0.D0
      CALL GETFAC ( 'ROTOR_FISS', NBRFIS )
      IF (NBRFIS.NE.0) THEN
         IF (METHOD.NE.'EULER') CALL U2MESS('F','ALGORITH5_80')
         NBNLI = NBNLI + NBRFIS
         CALL WKVECT('&&MDTR74.FK','V V K8',2*NBRFIS,JFK)
         CALL WKVECT('&&MDTR74.DFK','V V K8',2*NBRFIS,JDFK)
         DO 600 IOC = 1, NBRFIS
           CALL GETVID('ROTOR_FISS','K_PHI' ,IOC,IARG,1,FONCT,N1)
           FK(1) = FONCT(1:8)
           CALL JEVEUO(FONCT//'.PROL','L',LPROL)
           FK(2) = ZK24(LPROL)(1:8)
           CALL GETVID('ROTOR_FISS','DK_DPHI' ,IOC,IARG,1,FONCT,N1)
           DFK(1) = FONCT(1:8)
           CALL JEVEUO(FONCT//'.PROL','L',LPROL)
           DFK(2) = ZK24(LPROL)(1:8)
           IF (K8VAR.EQ.'OUI') THEN
             CALL GETVID('ROTOR_FISS','ANGL_ROTA',IOC,IARG,1,FONCP,NNG0)
           ELSE
             CALL GETVR8('ROTOR_FISS','ANGL_INIT',IOC,IARG,1,ANGINI,N1)
             ANGINI=ANGINI*RAD
           ENDIF
 600     CONTINUE
      ENDIF
C =<
      JINTI=1
      IF (NBNLI.NE.0) THEN
        CALL WKVECT('&&MDTR74.RANG_CHOC','V V I ',NBNLI*5,JRANC)
        CALL WKVECT('&&MDTR74.DEPL','V V R8',NBNLI*6*NBMODE,JDEPL)
        CALL WKVECT('&&MDTR74.PARA_CHOC','V V R8',NBNLI*52,JPARC)
        CALL WKVECT('&&MDTR74.NOEU_CHOC','V V K8',NBNLI*9,JNOEC)
        CALL WKVECT('&&MDTR74.INTI_CHOC','V V K8',NBNLI,JINTI)
        IF (NTOTEX.NE.0) THEN
          NBEXIT = NTOTEX
          CALL WKVECT('&&MDTR74.PSID','V V R8',NBNLI*6*NTOTEX,JPSID)
        ELSE
          NBEXIT = 1
        END IF
      CALL MDCHOC(NBNLI,NBCHOC,NBFLAM,NBSISM,NBRFIS,
     &              NBPAL,ZI(JRANC),ZR(JDEPL),
     &              ZR(JPARC),ZK8(JNOEC),ZK8(JINTI),ZR(JPSDEL),
     &              ZR(JPSID),NUMDDL,
     &              NBMODE,ZR(JPULS),ZR(JMASG),LAMOR,ZR(JAMOG),
     &              ZR(JBASE),NEQ,NBEXIT,INFO,LFLU,MONMOT,IRET)
        IF (IRET.NE.0) GO TO 120
        CALL GETFAC('VERI_CHOC',IVCHOC)
        IF (IVCHOC.NE.0) THEN
          CALL WKVECT('&&MDTR74.FIMPO','V V R8',NEQ,IFIMP)
          CALL WKVECT('&&MDTR74.RFIMPO','V V R8',NEQ,IRFIMP)
          CALL WKVECT('&&MDTR74.PTCHOC','V V R8',NEQ,IPTCHO)
          IF (INFO.EQ.2) THEN
            CALL WKVECT('&&MDTR74.SOUPL','V V R8',NBMODE,ISOUPL)
            CALL WKVECT('&&MDTR74.TRLOC','V V R8',NBMODE,ITRLOC)
            CALL WKVECT('&&MDTR74.INDIC','V V I',NBMODE,IINDIC)
          ELSE
            ITRLOC = 1
            ISOUPL = 1
            IINDIC = 1
          END IF
          NBNLI = NBNLI - NBPAL
          CALL CRICHO(NBMODE,ZR(JRAIG),NBNLI,ZR(JPARC),
     &                ZK8(JNOEC),INFO,ZR(IFIMP),ZR(IRFIMP),
     &                ZR(ITRLOC),ZR(ISOUPL),ZI(IINDIC),NEQ,ZR(JBASE),
     &                SEUIL,MARIG,NBNLI)
          NBNLI = NBNLI + NBPAL
          CALL GETVR8('VERI_CHOC','SEUIL',1,IARG,1,CRIT,N1)
          IF (SEUIL.GT.CRIT) THEN
            NIV = 'A'
            CALL GETVTX('VERI_CHOC','STOP_CRITERE',1,IARG,1,K8B,N1)
            IF (K8B.EQ.'OUI') NIV = 'F'
            VALR (1) = SEUIL
            CALL U2MESG('I','ALGORITH16_21',0,' ',0,0,1,VALR)
            CALL U2MESS(NIV,'ALGORITH5_66')
          END IF
        END IF
      END IF
C
C     --- RELATION EFFORT DEPLACEMENT ---
C
      CALL GETFAC('RELA_EFFO_DEPL',NBREDE)
      CALL GETFAC('RELA_TRANSIS',NBRETR)
      NBREDE = NBREDE + NBRETR
C     RELA_TRANSIS CORRESPOND A L'ANCIEN RELA_EFFO_DEPL TEL QU'IL ETAIT
C     UTILISE JUSQU'EN VERSION 4 ET CONSERVE POUR COMPATIBILITE.
C     A PARTIR DE LA VERSION 5 RELA_EFFO_DEPL FONCTIONNE COMME
C     RELA_EFFO_VITE.
      IF (NBREDE.NE.0) THEN
        CALL WKVECT('&&MDTR74.DPLR','V V R8',NBREDE*6*NBMODE,JREDE)
        CALL WKVECT('&&MDTR74.PARA_REDE','V V R8',NBREDE*2,JPARD)
        CALL WKVECT('&&MDTR74.FONC_REDE','V V K8',NBREDE*4,JFOND)
C        ON UTILISE UNE NOUVELLE VALEUR DE FONC_REDE POUR DISTINGUER
C        LES DEUX MOT-CLES FACTEURS
        DO 110 I = 1,NBREDE
          IF (I.LE.NBRETR) THEN
            ZK8(JFOND+3*NBREDE+I-1) = 'TRANSIS '
          ELSE
            ZK8(JFOND+3*NBREDE+I-1) = 'DEPL    '
          END IF
  110   CONTINUE
        CALL MDREDE(NUMDDL,NBREDE,NBMODE,ZR(JBASE),NEQ,ZR(JREDE),
     &              ZR(JPARD),ZK8(JFOND),IRET)
        IF (IRET.NE.0) GO TO 120
      END IF
C
C     --- RELATION EFFORT VITESSE ---
C
      CALL GETFAC('RELA_EFFO_VITE',NBREVI)
      IF (NBREVI.NE.0) THEN
        CALL WKVECT('&&MDTR74.DPLV','V V R8',NBREVI*6*NBMODE,JREVI)
        CALL WKVECT('&&MDTR74.FONC_REVI','V V K8',NBREVI*3,JFONV)
        CALL MDREVI(NUMDDL,NBREVI,NBMODE,ZR(JBASE),NEQ,ZR(JREVI),
     &              ZK8(JFONV),IRET)
        IF (IRET.NE.0) GO TO 120
      END IF

C     --- DESTRUCTION DU VECTEUR BASE MODALE (POUR FAIRE DE LA PLACE)

      CALL JEDETR('&&MDTR74.BASEMODE')

C     --- VERIFICATION DU PAS DE TEMPS ---

      CALL MDPTEM(NBMODE,ZR(JMASG),ZR(JPULS),NBNLI,ZR(JDEPL),
     & ZR(JPARC),ZK8(JNOEC),DT,DTS,DTU,DTMAX,TINIT,TFIN,NBPAS,
     & INFO,IRET,LISINS)
C
C     --- COUPLAGE EDYOS ---
C =>
      IF ( NBEDYO .NE. 0 ) THEN
        CALL INICOU(NBPAS,TINIT,TFIN,DT,DTSTO,VROTAT)
        TCF = TINIT
      ENDIF
C <=
      IF (METHOD.EQ.'ITMI') THEN
        TFEXM = TFIN - TINIT
        IF (NTS.EQ.0) TS = TFEXM
      END IF
      IF (IRET.NE.0) GO TO 120

C     --- ARCHIVAGE ---

      IF (METHOD(1:5).EQ.'ADAPT' .OR. METHOD.EQ.'ITMI') THEN
        CALL GETVIS('ARCHIVAGE','PAS_ARCH',1,IARG,1,IPARCH,N1)
        IF (N1.EQ.0) IPARCH = 1
        IF (METHOD(1:5).EQ.'ADAPT') THEN
          DTARCH = DTMAX*IPARCH
          NBSAUV = INT((TFIN-TINIT)/DTARCH) + 1
          IF ((TFIN - (TINIT+(NBSAUV-1)*DTARCH)).GE.R8PREM()) THEN
             NBSAUV=NBSAUV+1
          END IF
        ELSE IF (METHOD.EQ.'ITMI') THEN
C       DANS LE CAS ITMI, NBSAUV NE SERA CONNU QUE DANS MDITM2
          NBSAUV = 0
        END IF
C
      ELSE
        LISARC = '&&MDTR74.ARCHIVAGE'
        K8B = ' '
        CALL DYARCH(NBPAS,LISINS,LISARC,NBSAUV,0,IBID,K8B)
        CALL JEVEUO(LISARC,'E',JARCH)
      END IF

      IF (TYPBAS(1:9).EQ.'BASE_MODA'.AND.METHOD.NE.'DEVOGE') THEN
        CALL COPMAT(MASGEN,NUMGEM,ZR(JMASG))
        CALL COPMAT(RIGGEN,NUMGEK,ZR(JRAIG))
C        CALL TRLDS(ZR(JMASG),NBMODE,NBMODE,IRET)
      END IF

C     --- ALLOCATION DES VECTEURS DE SORTIE ---
C
      CALL MDALLO(NOMRES,BASEMO,MASGEN,RIGGEN,AMOGEN,NBMODE,DT,NBSAUV,
     &            NBNLI,ZK8(JNOEC),ZK8(JINTI),NBREDE,ZK8(JFOND),NBREVI,
     &            ZK8(JFONV),JDEPS,JVITS,JACCS,JPASS,JORDR,JINST,
     &            JFCHO,JDCHO,JVCHO,JICHO,JREDC,JREDD,JREVC,JREVD,
     &            METHOD,IBID,K4BID,'TRAN')
C
      IF (INFO.EQ.1 .OR. INFO.EQ.2) THEN
        VALK (1) = TYPBAS(1:9)
        VALK (2) = METHOD
        VALK (3) = BASEMO
        VALI (1) = NEQ
        VALI (2) = NBMODE
        CALL U2MESG('I','ALGORITH16_22',3,VALK,2,VALI,0,0.D0)
        IF (METHOD(1:5).EQ.'ADAPT') THEN
          VALR (1) = DT
          VALI (1) = NBSAUV
          CALL U2MESG('I','ALGORITH16_23',0,' ',1,VALI,1,VALR)
        ELSE IF (METHOD.EQ.'ITMI') THEN
          VALI (1) = NUMVIF
          VALI (2) = NBMODE
          VALI (3) = NBM0
          VALR (1) = VGAP
          VALR (2) = DT
          VALR (3) = TFEXM
          CALL U2MESG('I','ALGORITH16_24',0,' ',3,VALI,3,VALR)
          IF (ITRANS.NE.0) THEN
            VALR(1) = EPS
            CALL U2MESG('I','ALGORITH16_78',0,' ',0,0,1,VALR)
          ENDIF
          IF (ICOUPL.NE.0) THEN
            VALI (1) = NBMP
            CALL U2MESG('I','ALGORITH16_79',0,' ',1,VALI,0,0.D0)
          ENDIF
          VALI (1) = IPARCH
          CALL U2MESG('I','ALGORITH16_25',0,' ',1,VALI,0,0.D0)
        ELSE
          VALR (1) = DT
          VALI (1) = NBPAS
          VALI (2) = NBSAUV
          CALL U2MESG('I','ALGORITH16_26',0,' ',2,VALI,1,VALR)
        END IF
        IF (NBCHOC.NE.0) THEN
          VALI (1) = NBCHOC
          CALL U2MESG('I','ALGORITH16_80',0,' ',1,VALI,0,0.D0)
        ENDIF
        IF (NBSISM.NE.0) THEN
          VALI (1) = NBSISM
          CALL U2MESG('I','ALGORITH16_81',0,' ',1,VALI,0,0.D0)
        ENDIF
        IF (NBFLAM.NE.0) THEN
          VALI (1) = NBFLAM
          CALL U2MESG('I','ALGORITH16_82',0,' ',1,VALI,0,0.D0)
        ENDIF
       IF (NBREDE.NE.0) THEN
          VALI (1) = NBREDE
          CALL U2MESG('I','ALGORITH16_83',0,' ',1,VALI,0,0.D0)
        ENDIF
        IF (NBREVI.NE.0) THEN
          VALI (1) = NBREVI
          CALL U2MESG('I','ALGORITH16_84',0,' ',1,VALI,0,0.D0)
        ENDIF
      END IF

      IF (METHOD.EQ.'EULER') THEN
        CALL MDEUL1(NBPAS,DT,NBMODE,ZR(JPULS),ZR(JPUL2),ZR(JMASG),IBID,
     &              ZR(JRAIG),IBID,ZR(JRGYG),LAMOR,ZR(JAMOG),IBID,
     &              ZR(JGYOG),FONCV,FONCA,TYPBAS,BASEMO,
     &              TINIT,ZI(JARCH),NBSAUV,ITEMAX,PREC,XLAMBD,LFLU,
     &              NBNLI,ZI(JRANC),ZR(JDEPL),ZR(JPARC),ZK8(JNOEC),
     &              NBREDE,ZR(JREDE),ZR(JPARD),ZK8(JFOND),NBREVI,
     &              ZR(JREVI),ZK8(JFONV),ZR(JDEPS),ZR(JVITS),ZR(JACCS),
     &              ZI(JORDR),ZR(JINST),ZR(JFCHO),ZR(JDCHO),ZR(JVCHO),
     &              ZI(JICHO),ZI(JREDC),ZR(JREDD),ZI(JREVC),ZR(JREVD),
     &              ZR(JCOEFM),ZI(JIADVE),
     &              ZI(JINUMO),ZI(JIDESC),ZK8(JNODEP),ZK8(JNOVIT),
     &              ZK8(JNOACC),ZK8(JNOMFO),ZR(JPSID),MONMOT,
     &              NBRFIS,FK,DFK,ANGINI,FONCP,
     &              NBPAL,DTSTO,TCF,VROTAT,PRDEFF,NOMRES,NTOTEX,
     &              ZR(JPASS))

      ELSE IF (METHOD(1:5).EQ.'ADAPT') THEN
        CALL MDADAP(DT,DTMAX,NBMODE,ZR(JPULS),ZR(JPUL2),ZR(JMASG),
     &              IBID,
     &              ZR(JRAIG),IBID,LAMOR,ZR(JAMOG),IBID,TYPBAS,BASEMO,
     &              TINIT,TFIN,DTARCH,NBSAUV,ITEMAX,PREC,XLAMBD,LFLU,
     &              NBNLI,ZI(JRANC),ZR(JDEPL),ZR(JPARC),ZK8(JNOEC),
     &              NBREDE,ZR(JREDE),ZR(JPARD),ZK8(JFOND),NBREVI,
     &              ZR(JREVI),ZK8(JFONV),ZR(JDEPS),ZR(JVITS),ZR(JACCS),
     &              ZR(JPASS),ZI(JORDR),ZR(JINST),ZR(JFCHO),ZR(JDCHO),
     &              ZR(JVCHO),ZI(JICHO),ZI(JREDC),ZR(JREDD),ZR(JCOEFM),
     &              ZI(JIADVE),ZI(JINUMO),ZI(JIDESC),ZK8(JNODEP),
     &              ZK8(JNOVIT),ZK8(JNOACC),ZK8(JNOMFO),ZR(JPSID),
     &              MONMOT,
     &              NBPAL,DTSTO,TCF,VROTAT,PRDEFF,METHOD,NOMRES,NTOTEX,
     &              ZI(JREVC),ZR(JREVD))
      ELSE IF (METHOD.EQ.'NEWMARK') THEN
        CALL MDNEWM(NBPAS,DT,NBMODE,ZR(JPULS),ZR(JPUL2),ZR(JMASG),
     &              ZR(JRAIG),ZR(JRGYG),LAMOR,ZR(JAMOG),ZR(JGYOG),FONCV,
     &              FONCA,TYPBAS,BASEMO,TINIT,ZI(JARCH),ZR(JDEPS),
     &              ZR(JVITS),ZR(JACCS),ZI(JORDR),ZR(JINST),NOMRES,
     &              NTOTEX,ZI(JIDESC),ZK8(JNOMFO),ZR(JCOEFM),
     &              ZI(JIADVE),ZI(JINUMO),ZR(JPASS))

      ELSE IF (METHOD.EQ.'DEVOGE') THEN
        CALL MDDEVO(NBPAS,DT,NBMODE,ZR(JPULS),ZR(JPUL2),ZR(JMASG),
     &              ZR(JAMOG),BASEMO,TINIT,
     &              ZI(JARCH),NBSAUV,NBNLI,ZI(JRANC),ZR(JDEPL),
     &              ZR(JPARC),ZK8(JNOEC),NBREDE,ZR(JREDE),ZR(JPARD),
     &              ZK8(JFOND),NBREVI,ZR(JREVI),ZK8(JFONV),ZR(JDEPS),
     &              ZR(JVITS),ZR(JACCS),ZI(JORDR),ZR(JINST),ZR(JFCHO),
     &              ZR(JDCHO),ZR(JVCHO),ZI(JICHO),ZI(JREDC),ZR(JREDD),
     &              ZR(JCOEFM),ZI(JIADVE),ZI(JINUMO),ZI(JIDESC),
     &              ZK8(JNODEP),ZK8(JNOVIT),ZK8(JNOACC),ZK8(JNOMFO),
     &              ZR(JPSID),MONMOT,NOMRES,NTOTEX,ZR(JPASS),
     &              ZI(JREVC),ZR(JREVD))
       ENDIF
C     --- IMPRESSION DES RESULTATS DE CHOC DANS TOUS LES CAS
C     --- SAUF ITMI POUR ITMI ON IMPRIME DANS MDITM2
      IF (METHOD.NE.'ITMI' .AND. NBNLI.NE.0) THEN
CCC      IF (NBNLI.NE.0) THEN
        CALL MDICHO(NOMRES,NBSAUV,ZR(JINST),ZR(JFCHO),ZR(JDCHO),
     &              ZR(JVCHO),NBNLI,NBCHOC,ZR(JPARC),ZK8(JNOEC))
      END IF
      IF (METHOD.EQ.'ITMI') THEN
C
C        --- CONDITIONS INITIALES ---
C
        CALL WKVECT('&&MDITMI.DEPL_0','V V R8',NBMODE,JDEP0)
        CALL WKVECT('&&MDITMI.VITE_0','V V R8',NBMODE,JVIT0)
        CALL MDINIT(NOMBM,NBMODE,0,ZR(JDEP0),ZR(JVIT0),R8B,
     &              IRET, TINIT)
        IF (IRET.NE.0) GO TO 120
C
C --- 1.4.NOMBRE DE POINTS DE DISCRETISATION DU TUBE
C
        CALL JEVEUO ( BASEMO//'           .REFD' , 'L', KREF )
        MASSE = ZK24(KREF+1)(1:19)
        CALL MTDSCR ( MASSE )
C
C
        CALL DISMOI('F','NOM_MAILLA'  ,MASSE,'MATR_ASSE',IBID,MAILLA,
     &              IRE)
C        --- RECUPERATION DU NOMBRE DE NOEUDS DU MAILLAGE
C
        NOMNOE = MAILLA//'.NOMNOE'
        CALL JELIRA(NOMNOE,'NOMUTI',LNOE,K1BID)
        INDIC = LNOE
C
        CALL MDITM1(NBMODE,NBMD,NBMP,NBNLI,INDIC,NBF,INFO,ITRANS,
     &              EPS,ICOUPL,TYPFLU,ZI(IVECI1),ZL(JLOCF),DT,TFEXM,TS,
     &              IPARCH,NTOTEX,ZK8(JNOMFO),ZI(JINUMO),ZR(JMASG),
     &              ZR(JAMO1),ZR(JPULS),ZR(IVECR3),ZR(JDEPL),ZR(JPARC),
     &              ZK8(JNOEC),ZK8(JINTI),ZR(IVECR5),ZR(IVECR1),
     &              ZR(IVECR2),VGAP,ZR(IVECR4),NBCHOC,ZR(JDEP0),
     &              ZR(JVIT0),ZR(JAMOG),NBSAUV)
      END IF
C
  120 CONTINUE
C      CALL JEDETC('V','&&',1)
      IF (IRET.NE.0) CALL U2MESS('F','ALGORITH5_24')
C
      CALL JEDEMA()
      END

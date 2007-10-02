      SUBROUTINE SSDT74(NOMRES,NOMCMD)
      IMPLICIT REAL*8 (A-H,O-Z)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 02/10/2007   AUTEUR PELLET J.PELLET 
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

C     BUT: SOUS-STRUCTURATION DYNAMIQUE TRANSITOIRE
C          CALCUL TRANSITOIRE PAR DYNA_TRAN_MODAL EN SOUS-STRUCTURATION

C ----------------------------------------------------------------------

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

C     ----- FIN COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER DESCR,DESCM,DESCA
      INTEGER VALI(3)
      REAL*8 XLAMBD,ACRIT,AGENE
      REAL*8 VALR(2)
      CHARACTER*1 K1BID
      CHARACTER*8 K8B,KBID,NOMRES,METHOD,MASGEN,RIGGEN,AMOGEN,MONMOT
      CHARACTER*8 BASEMO,MODGEN,MASTEM,AMOTEM,VECGEN
      CHARACTER*14 NUMGEN
      CHARACTER*16 NOMCMD,TYPBAS
      CHARACTER*19 RAID,MASS,AMOR,LISARC
      CHARACTER*24 NUMG24,LISINS
      CHARACTER*24 VALK(2)
      LOGICAL LAMOR,LFLU,LPSTO

C-----------------------------------------------------------------------
      DATA K8B/'        '/
      DATA MASTEM/'MASSTEMP'/
      DATA AMOTEM/'AMORTEMP'/
      CALL JEMARQ()
      DEUX = 2.D0
      LPSTO = .FALSE.
      LFLU = .FALSE.
C-----------------------------------------------------------------------

      JINTI = 1
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
      LAMOR = .FALSE.
      LISINS = ' '
      CALL INFNIV(IFM,INFO)

C     --- VERIFICATION DES DONNEES UTILISATEUR EN FONCTION DES LIMITES
C     --- DU CALCUL TRANSITOIRE PAR SOUS-STRUCTURATION

      CALL LIMSST(NOMCMD)

C     --- RECUPERATION DES ARGUMENTS DE LA COMMANDE ---

      CALL GETVTX(' ','METHODE',0,1,1,METHOD,N1)
      CALL GETVIS(' ','NMAX_ITER',0,1,1,ITEMAX,N1)
      CALL GETVR8(' ','RESI_RELA',0,1,1,PREC,N1)
      CALL GETVR8(' ','LAMBDA',0,1,1,XLAMBD,N1)
      CALL GETFAC('EXCIT',NEXCIT)
      NBCHOC = 0
      NBREDE = 0
      NBREVI = 0

C     --- RECUPERATION DES MATRICES PROJETEES ---

      CALL GETVID(' ','MASS_GENE',0,1,1,MASGEN,NM)
      CALL GETVID(' ','RIGI_GENE',0,1,1,RIGGEN,NR)
      CALL GETVID(' ','AMOR_GENE',0,1,1,AMOGEN,NAMOR)
      IF (NEXCIT.NE.0) THEN
        CALL WKVECT('&&SSDT74.NOMVEC','V V K8',NEXCIT,JVEC)
        DO 10 I = 1,NEXCIT
          CALL GETVID('EXCIT','VECT_GENE',I,1,1,VECGEN,NV)
          ZK8(JVEC-1+I) = VECGEN
   10   CONTINUE
      END IF

C     --- NUMEROTATION GENERALISEE ET NOMBRE DE MODES ---

      CALL JEVEUO(MASGEN//'           .REFA','L',JREFA)
      NUMGEN = ZK24(JREFA-1+2)(1:14)
      CALL JEVEUO(NUMGEN//'.NUME.REFN','L',JREFA)
      MODGEN = ZK24(JREFA-1+1)
      CALL GETTCO(MODGEN,TYPBAS)
      CALL JELIRA(MODGEN//'      .MODG.SSNO','NOMMAX',NBSST,K1BID)
      NBMODE = 0
      NBMODY = 0
      DO 20 K = 1,NBSST
        KBID = '        '
        CALL MGUTDM(MODGEN,KBID,K,'NOM_BASE_MODALE',IBID,BASEMO)
        CALL BMNBMD(BASEMO,'TOUT',NBBAS)
        NBMODE = NBMODE + NBBAS
        CALL BMNBMD(BASEMO,'MODE',NBBAS)
        NBMODY = NBMODY + NBBAS
   20 CONTINUE
      NBMOST = NBMODE - NBMODY
      CALL JEVEUO(NUMGEN//'.SLCS.SCDE','L',JSCDE)
      NEQGEN = ZI(JSCDE-1+1)

C     --- RECOPIE DES GRANDEURS GENERALISEES ---

      CALL WKVECT('&&SSDT74.MASSEGEN','V V R',NEQGEN,JMASG)
      CALL WKVECT('&&SSDT74.RAIDEGEN','V V R',NEQGEN,JRAIG)
      CALL WKVECT('&&SSDT74.AMORTGEN','V V R',NEQGEN,JAMOG)
      CALL WKVECT('&&SSDT74.PULSATIO','V V R',NEQGEN,JPULS)
      CALL WKVECT('&&SSDT74.PULSAT2','V V R',NEQGEN,JPUL2)
      NUMG24(1:14) = NUMGEN
      CALL EXTDIA(MASGEN,NUMG24,1,ZR(JMASG))
      CALL EXTDIA(RIGGEN,NUMG24,1,ZR(JRAIG))

      DO 31 K = 1,NEQGEN
         ZR(JPULS+K-1) = 0
         ZR(JPUL2+K-1) = 0
   31 CONTINUE
      NBMODI = 0
      DO 30 K = 1,NBSST
        KBID = '        '
        CALL MGUTDM(MODGEN,KBID,K,'NOM_BASE_MODALE',IBID,BASEMO)
        CALL BMNBMD(BASEMO,'MODE',NBBAS)
        DO 33 I = 1,NBBAS
         OMEG2 = ABS(ZR(JRAIG+NBMODI+I-1)/ZR(JMASG+NBMODI+I-1))
         ZR(JPULS+NBMODI+I-1) = SQRT(OMEG2)
         ZR(JPUL2+NBMODI+I-1) = OMEG2
   33   CONTINUE
        CALL BMNBMD(BASEMO,'TOUT',NBBAS)
        NBMODI = NBMODI + NBBAS
   30 CONTINUE

      IF (NAMOR.NE.0) THEN
        CALL EXTDIA(AMOGEN,NUMG24,1,ZR(JAMOG))
        DO 40 I = 1,NEQGEN
          IF (ZR(JPULS+I-1).GT.R8PREM()) THEN
            ACRIT = DEUX*SQRT(ZR(JMASG+I-1)*ZR(JRAIG+I-1))
            AGENE = ZR(JAMOG+I-1)
            IF (AGENE.GT.ACRIT) THEN
              VALI (1) = I
              VALR (1) = AGENE
              VALR (2) = ACRIT
              VALK (1) = ' '
              CALL U2MESG('A','ALGORITH16_38',1,VALK,1,VALI,2,VALR)
            END IF
          END IF
   40   CONTINUE
      END IF

C     --- VERIFICATION DES DONNEES GENERALISEES ---

      IF (NAMOR.EQ.0) AMOGEN = K8B
      CALL MDGENE(K8B,NBMODE,NUMGEN,MASGEN,RIGGEN,AMOGEN,NEXCIT,JVEC,
     &            IRET)
      IF (IRET.NE.0) GO TO 60

C     --- RECUPERATION DES PARAMETRES D'EXCITATION

      NEQ = 0
      IF (NEXCIT.NE.0) THEN
        CALL WKVECT('&&SSDT74.COEFM','V V R8',NEXCIT,JCOEFM)
        CALL WKVECT('&&SSDT74.IADVEC','V V IS',NEXCIT,JIADVE)
        CALL WKVECT('&&SSDT74.INUMOR','V V IS',NEXCIT,JINUMO)
        CALL WKVECT('&&SSDT74.IDESCF','V V IS',NEXCIT,JIDESC)
        CALL WKVECT('&&SSDT74.NOMFON','V V K8',2*NEXCIT,JNOMFO)
        CALL WKVECT(NOMRES//'           .FDEP','G V K8',2*NEXCIT,JNODEP)
        CALL WKVECT(NOMRES//'           .FVIT','G V K8',2*NEXCIT,JNOVIT)
        CALL WKVECT(NOMRES//'           .FACC','G V K8',2*NEXCIT,JNOACC)
        CALL MDRECF(NEXCIT,ZI(JIDESC),ZK8(JNOMFO),ZR(JCOEFM),ZI(JIADVE),
     &              ZI(JINUMO),ZK8(JNODEP),ZK8(JNOVIT),ZK8(JNOACC),
     &              ZR(JPSDEL),NEQ,TYPBAS,BASEMO,NBMODY,ZR(JRAIG),
     &              MONMOT)
      END IF

C     --- VERIFICATION DU PAS DE TEMPS ---

      CALL MDPTEM(NEQGEN,ZR(JMASG),ZR(JRAIG),ZR(JPULS),NBCHOC,ZR(JDEPL),
     &            ZR(JPARC),ZK8(JNOEC),DT,TINIT,TFIN,NBPAS,INFO,IRET)
      IF (IRET.NE.0) GO TO 60

C     --- ARCHIVAGE ---
      IF (METHOD.EQ.'ADAPT') THEN
        CALL GETVIS('ARCHIVAGE','PAS_ARCH',1,1,1,IPARCH,N1)
        IF (N1.EQ.0) IPARCH = 1
        DTARCH = DT*IPARCH
        NBSAUV = NINT((TFIN-TINIT)/DTARCH) + 2
        LPSTO = .TRUE.
      ELSE
        LISARC = '&&SSDT74.ARCHIVAGE'
        CALL DYARCH(NBPAS,LISINS,LISARC,NBSAUV,0,IBID,K8B)
        CALL JEVEUO(LISARC,'E',JARCH)
      END IF

C     --- AJOUT DES "LAGRANGE" DANS LA MATRICE DE MASSE ---

      CALL AJLAGR(RIGGEN,MASGEN,MASTEM)

C     --- TRAITEMENT DE LA MATRICE D'AMORTISSEMENT ---

      IF (NAMOR.NE.0) THEN
        CALL AJLAGR(RIGGEN,AMOGEN,AMOTEM)

C ----- ON MODIFIE LE CONDITIONNEMENT POUR RENDRE CRITIQUE
C ----- L'AMORTISSEMENT ASSOCIE AUX "LAGRANGE"

        CALL JEVEUO(AMOTEM//'           .CONL','E',JCONL)
        DO 50 I = 1,NEQGEN
          ZR(JCONL-1+I) = ZR(JCONL-1+I)/DEUX
   50   CONTINUE
      END IF

C     --- RECUPERATION DES DESCRIPTEURS DES MATRICES ---

      RAID = RIGGEN//'           '
      MASS = MASTEM//'           '
      IF (NAMOR.NE.0) AMOR = AMOTEM//'           '

      CALL MTDSCR(RAID)
      CALL JEVEUO(RAID(1:19)//'.&INT','E',DESCR)
      CALL MTDSCR(MASS)
      CALL JEVEUO(MASS(1:19)//'.&INT','E',DESCM)
      IF (NAMOR.NE.0) THEN
        CALL MTDSCR(AMOR)
        CALL JEVEUO(AMOR(1:19)//'.&INT','E',DESCA)
      ELSE
        DESCA = 0
      END IF

C     --- ALLOCATION DES VECTEURS DE SORTIE ---

      IF (NAMOR.EQ.0) AMOGEN = K8B
      CALL MDALLO(NOMRES,NUMGEN,MASGEN,RIGGEN,AMOGEN,NEQGEN,DT,NBSAUV,
     &            NBCHOC,ZK8(JNOEC),ZK8(JINTI),NBREDE,ZK8(JFOND),NBREVI,
     &            JDEPS,JVITS,JACCS,JPASS,JORDR,JINST,JFCHO,JDCHO,JVCHO,
     &            JADCHO,JREDC,JREDD,LPSTO,METHOD)

      IF (INFO.EQ.1 .OR. INFO.EQ.2) THEN
        VALK (1) = NUMGEN
        VALK (2) = METHOD
        VALI (1) = NEQGEN
        VALI (2) = NBMODY
        VALI (3) = NBMOST
        CALL U2MESG('I+','ALGORITH16_39',2,VALK,3,VALI,0,0.D0)
        IF (METHOD.EQ.'ADAPT') THEN
          VALR (1) = DT
          CALL U2MESG('I+','ALGORITH16_40',0,' ',0,0,1,VALR)
        ELSE
          VALR (1) = DT
          VALI (1) = NBPAS
          CALL U2MESG('I+','ALGORITH16_41',0,' ',1,VALI,1,VALR)
        END IF
        VALI (1) = NBSAUV
        CALL U2MESG('I+','ALGORITH16_42',0,' ',1,VALI,0,0.D0)
        IF (NBCHOC.NE.0) THEN
          VALI(1) = NBCHOC
          CALL U2MESG('I+','ALGORITH16_80',0,' ',1,VALI,0,0.D0)
        ENDIF
        IF (NBREDE.NE.0) THEN
          VALI(1) = NBREDE
          CALL U2MESG('I+','ALGORITH16_83',0,' ',1,VALI,0,0.D0)
        ENDIF
        IF (NBREVI.NE.0) THEN
          VALI(1) = NBREVI
          CALL U2MESG('I+','ALGORITH16_84',0,' ',1,VALI,0,0.D0)
        ENDIF
        CALL U2MESG('I','ALGORITH16_43',0,' ',0,0,0,0.D0)
      END IF

      IF (METHOD.EQ.'EULER') THEN
        CALL MDEUL1(NBPAS,DT,NEQGEN,ZR(JPULS),ZR(JPUL2),ZR(JMASG),DESCM,
     &              ZR(JRAIG),DESCR,LAMOR,ZR(JAMOG),DESCA,TYPBAS,K8B,
     &              TINIT,ZI(JARCH),NBSAUV,ITEMAX,PREC,XLAMBD,LFLU,
     &              NBCHOC,ZI(JRANC),ZR(JDEPL),ZR(JPARC),ZK8(JNOEC),
     &              NBREDE,ZR(JREDE),ZR(JPARD),ZK8(JFOND),NBREVI,
     &              ZR(JREVI),ZK8(JFONV),ZR(JDEPS),ZR(JVITS),ZR(JACCS),
     &              ZI(JORDR),ZR(JINST),ZR(JFCHO),ZR(JDCHO),ZR(JVCHO),
     &              ZI(JADCHO),ZI(JREDC),ZR(JREDD),ZR(JCOEFM),
     &              ZI(JIADVE),ZI(JINUMO),ZI(JIDESC),ZK8(JNODEP),
     &              ZK8(JNOVIT),ZK8(JNOACC),ZK8(JNOMFO),ZR(JPSID),
     &              MONMOT,NOMRES)

      ELSE IF (METHOD.EQ.'ADAPT') THEN
        CALL MDADAP(DT,NEQGEN,ZR(JPULS),ZR(JPUL2),ZR(JMASG),DESCM,
     &              ZR(JRAIG),DESCR,LAMOR,ZR(JAMOG),DESCA,TYPBAS,K8B,
     &              TINIT,TFIN,DTARCH,NBSAUV,ITEMAX,PREC,XLAMBD,LFLU,
     &              NBCHOC,ZI(JRANC),ZR(JDEPL),ZR(JPARC),ZK8(JNOEC),
     &              NBREDE,ZR(JREDE),ZR(JPARD),ZK8(JFOND),NBREVI,
     &              ZR(JREVI),ZK8(JFONV),ZR(JDEPS),ZR(JVITS),ZR(JACCS),
     &              ZR(JPASS),ZI(JORDR),ZR(JINST),ZR(JFCHO),ZR(JDCHO),
     &              ZR(JVCHO),ZI(JADCHO),ZI(JREDC),ZR(JREDD),ZR(JCOEFM),
     &              ZI(JIADVE),ZI(JINUMO),ZI(JIDESC),ZK8(JNODEP),
     &              ZK8(JNOVIT),ZK8(JNOACC),ZK8(JNOMFO),ZR(JPSID),
     &              MONMOT,NOMRES)

      END IF

      CALL TITRE

   60 CONTINUE
      CALL JEDETC('V','&&SSDT74',1)
      IF (IRET.NE.0) CALL U2MESS('F','ALGORITH5_24')

      IF (NAMOR.NE.0) THEN
        CALL JEDETR(AMOTEM//'           .UALF')
        CALL JEDETR(AMOTEM//'           .VALM')
        CALL JEDETR(AMOTEM//'           .REFA')
        CALL JEDETR(AMOTEM//'           .CONL')
        CALL JEDETR(AMOTEM//'           .LIME')
      END IF
      CALL JEDETR(MASTEM//'           .UALF')
      CALL JEDETR(MASTEM//'           .VALM')
      CALL JEDETR(MASTEM//'           .REFA')
      CALL JEDETR(MASTEM//'           .CONL')
      CALL JEDETR(MASTEM//'           .LIME')
      IF (NEXCIT.NE.0) CALL JEDETR('&&SSDT74.NOMVEC')

      CALL JEDEMA()
      END

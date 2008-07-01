      SUBROUTINE OP0175(IER)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER IER
C ----------------------------------------------------------------------
C MODIF CALCULEL  DATE 30/06/2008   AUTEUR PELLET J.PELLET 
C TOLE CRP_20
C     COMMANDE :  POST_ZAC
C        METHODE ZARKA-CASIER
C ----------------------------------------------------------------------
C     ----- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
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
      CHARACTER*32 JEXNUM,JEXNOM
C     ----- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='OP0175')
C    DIMAKI = DIMENSION MAX DE LA LISTE DES RELMATIONS KIT
      INTEGER NCMPMA,DIMAKI
      PARAMETER (DIMAKI=9)
      PARAMETER (NCMPMA=7+DIMAKI)

      INTEGER NBPASE
      INTEGER TYPESE
      CHARACTER*1 BASE,K1BID
      CHARACTER*2 CODRET
      CHARACTER*4 CTYP
      CHARACTER*8 RESULT,RESUEL,RESUEP,CARA,CRIT
      CHARACTER*8 NOPASE
      CHARACTER*8 NOMA,K8BID, BLAN8
      CHARACTER*8 NOMGRD,NOMCMP(NCMPMA),LPAIN(1),LPAOUT(2)
      CHARACTER*16 K16BID,OPTION,CONCEP
      CHARACTER*19 KNUME,KCHA
      CHARACTER*24 CHAMGD(6),CHRESU(6)
      CHARACTER*24 CHGEOM,CHCARA(15),CHVARC,CHVREF,CHTIM,CHTIMP,CHTIP
      CHARACTER*24 CHHARM,MATE,LIGREL,MODELE,CARELE,CHVZAC
      CHARACTER*24 CHTZAC
      CHARACTER*24 ALPHA0,ALPHAL,EPSINI(4)
      CHARACTER*24 FOMULT,CHARGE,INFOCH,NUMEDD
      CHARACTER*24 K24BID
      CHARACTER*24 LCHIN(1),LCHOUT(2),CHDEPL,CHSIGM
      CHARACTER*24 VALMOI(8),VALPLU(8),POUGD(8)
      CHARACTER*24 DUMMY(6)
      REAL*8 VADAP,TOTVAD,TIME,TIMEP,INSTPL,TPZAC
      LOGICAL EXITIM,TABRET(0:10),EXIRRA,EXCORR,EXEPSA,EXSECH,EXTEMP
      LOGICAL EXHYDR,EXMET1,EXMET2,LBID
      INTEGER IBID,JCELV,LONG
      COMPLEX*16 CBID
C    POUR LA PARTIE LOI DE COMPORTEMENT ZAC
      INTEGER JDIDO,JZAC
      REAL*8 INSTAM,INSTAP,RBID
      CHARACTER*13 INPSCO
      CHARACTER*19 LISCHA,SOLVEU
      CHARACTER*19 MATASS,MAPREC
      CHARACTER*24 COMPOR,CARCRI,DEPMOI,DEPPLU,DEPDEL
      CHARACTER*24 SIGMOI,SIGPLU,VARMOI,VARPLU,CNCINE
      CHARACTER*24 COMMOI,COMPLU,COMREF
      CHARACTER*24 MEDIRI,MERIGI,K24BLA
      CHARACTER*24 VEDIDO,VADIDO,CNDIDO
      CHARACTER*24 CNZAC,VERESI,VEDIRI,NOOJB
      DATA CHTZAC/'&&OP0175.CHTZAC'/
      DATA ALPHA0,ALPHAL/'&&ALPHA0','&&ALPHAL'/
      DATA EPSINI/'&&EPSMOY','&&EPSINF','&&EPSSU1','&&EPSSU2'/
      DATA CHTIM,CHTIP,CHTIMP/'&&OP0175.TIM','&&OP0175.TIP',
     &     '&&OP0175.TIMP'/
      DATA DUMMY/'&&OP0175.DUM1','&&OP0175.DUM2','&&OP0175.DUM3',
     &     '&&OP0175.DUM4','&&OP0175.DUM5','&&OP0175.DUM6'/
      DATA K8BID,K24BID/2*' '/
C    POUR LA PARTIE LOI DE COMPORTEMENT ZAC
      DATA LISCHA/'&&OP0175.LISCHA'/
      DATA COMPOR/'&&OP0175.COMPOR'/
      DATA CARCRI/'&&OP0175.CRITERE'/
      DATA SOLVEU/'&&OP0175.SOLVEUR'/
      DATA NOMGRD/'COMPOR  '/
      DATA NOMCMP/'RELCOM  ','NBVARI  ','DEFORM  ','INCELA  ','C_PLAN',
     &     'XXXX1','XXXX2','KIT1','KIT2    ','KIT3    ','KIT4    ',
     &     'KIT5    ','KIT6    ','KIT7    ','KIT8    ','KIT9    '/
      DATA SIGMOI,VARMOI/'&&OP0175.SIGMOI','&&OP0175.VARMOI'/
      DATA SIGPLU,VARPLU/'&&OP0175.SIGPLU','&&OP0175.VARPLU'/
      DATA COMMOI,COMPLU/'&&OP0175.COMOI','&&OP0175.COPLU'/
      DATA COMREF/'&&OP0175.COREF'/
      DATA DEPMOI,DEPPLU/'&&OP0175.DEPMOI','&&OP0175.DEPPLU'/
      DATA DEPDEL,CNCINE/'&&OP0175.DEPDEL','&&OP0175.CNCINE'/
      DATA MERIGI/'&&MEMRIG           .RELR'/
      DATA MEDIRI/'&&MEDIRI           .RELR'/
      DATA CNDIDO/'&&OP0175.CNDIDO'/
      DATA VEDIDO/'&&VEDIDO           .RELR'/
      DATA CNZAC/'&&OP0175.CNZAC'/
      DATA VERESI/'&&RESIDU           .RELR'/
      DATA VEDIRI/'&&DIRICH           .RELR'/

      DATA MATASS,MAPREC/'&&OP0175.MATASS','&&OP0175.MAPREC'/
      DATA K24BLA/' '/
      DATA TYPESE/0/
C ----------------------------------------------------------------------
      CALL JEMARQ()
      CALL INFMAJ()

C               1234567890123456789
      BLAN8  = '        '

C               12   345678   90123
      INPSCO = '&&'//NOMPRO//'_PSCO'
      NBPASE = 0

C     INITIALISATION DES NOMS DES CHAMPS A "BLANC" POUR APPEL A CALCUL:
      DO 10,I = 1,6
        CHAMGD(I) = K24BID
        CHRESU(I) = DUMMY(I)
   10 CONTINUE

      CHGEOM = K24BID
      MATE = K24BID
      CHVARC = '&&OP0175.CHVARC'
      CHVZAC = '&&OP0175.CHVZAC'
      CHVREF = '&&OP0175.CHVREF'
      BASE = 'G'
      NBRES = 3
      MODELE = ' '
C     =============================================================
C     (1) RECUPERATION DES ARGUMENTS DE LA COMMANDE
C     =============================================================
      CALL GETRES(RESULT,CONCEP,K16BID)
      CALL RSCRSD(RESULT,'MULT_ELAS',NBRES)
      CALL GETVID(' ','EVOL_NOLI',1,1,1,RESUEP,N0)
      CALL GETVID(' ','EVOL_ELAS',1,1,1,RESUEL,N1)
C   LISTE D'INSTANTS DE L'EVOL_ELAS
      KNUME = '&&OP0175.NU_ORDR_EL'
      CALL GETVR8(' ','PRECISION',1,1,1,PREC,NP)
      CALL GETVTX(' ','CRITERE',1,1,1,CRIT,NC)
      CALL JEVEUO(RESUEL//'           .INST','L',INSTL)
      EXITIM = .TRUE.
      CALL RSUTNU(RESUEL,' ',1,KNUME,NBORDL,PREC,CRIT,IRET)
      CALL JEVEUO(KNUME,'L',JORDL)
C   LISTE D'INSTANTS DE L'EVOL_NOLI
      IF (N0.NE.0) THEN
        CALL GETVR8(' ','INST_MAX',1,1,1,INSTPL,NP)
        CALL RSORAC(RESUEP,'INST',IBID,INSTPL,K8BID,CBID,PREC,CRIT,
     &              NUMPLA,1,N2)
      END IF
      KCHA = '&&OP0175.CHARGES'
      CALL MEDOM1(MODELE(1:8),MATE,CARA,KCHA,NCHAR,CTYP,RESULT,1)
      IF (NCHAR.NE.0 .AND. CTYP.NE.'MECA') CALL U2MESS('F','CALCULEL2_98
     &')
      CALL JEVEUO(KCHA,'E',JCHA)
      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IB,LIGREL,IE)
      CALL MECHAM(OPTION,MODELE,NCHAR,ZK8(JCHA),CARA,0,CHGEOM,CHCARA,
     &            CHHARM,IRET)
      IF (IRET.NE.0) GO TO 130
      NOMA = CHGEOM(1:8)


C  TEMPERATURE POUR LES CARACTERISTIQUES MATERIAUX UTILISES
C  DANS LA METHODE ZAC ET CREATION D'UNE CARTE CONSTANTE
      CALL GETVR8(' ','TEMP_ZAC',1,1,1,TPZAC,NZ)
      CALL MECACT('V',CHTZAC,'MODELE',LIGREL,'TEMP_R',1,'TEMP',IBID,
     &            TPZAC,CBID,K8BID)


C  VERIFICATION SUR LES VARIABLES DE COMMANDES


C ON S ASSURE QUE SEUL LA TEMPERATURE PEUT ETRE PRESENTE
C COMME VARIABLE DE COMMANDE

      CALL NMVCD2('IRRA',MATE,EXIRRA,LBID)
      CALL NMVCD2('CORR',MATE,EXCORR,LBID)
      CALL NMVCD2('EPSA',MATE,EXEPSA,LBID)
      CALL NMVCD2('SECH',MATE,EXSECH,LBID)
      CALL NMVCD2('HYDR',MATE,EXHYDR,LBID)
      CALL NMVCD2('M_ACIER',MATE,EXMET1,LBID)
      CALL NMVCD2('M_ZIRC',MATE,EXMET2,LBID)

      IF (EXIRRA.OR.EXCORR.OR.EXEPSA.OR.EXSECH.OR.
     &    EXHYDR.OR.EXMET1.OR.EXMET2) THEN
        CALL U2MESS ('F','PREPOST5_9')
      ENDIF


C     =============================================================
C     (2) CALCUL DE L'ETAT INITIAL ALPHA ZERO
C     =============================================================
      OPTION = 'ALPH_ELGA_ZAC'
C     METHODE ZAC - ETAPE 1 : CALCUL DU ALPHA ZERO
      IEL = 0
      IF (N0.NE.0) THEN
C       LE CALCUL ELASTOPLASTIQUE EST DONNE
        TIME = INSTPL
        IORDR = NUMPLA
        CALL RSEXCH(RESUEP,'DEPL',IORDR,CHAMGD(1),IRET)
        CALL RSEXCH(RESUEP,'SIEF_ELGA',IORDR,CHAMGD(3),IRET)
        DO 20 I = 1,NBORDL
          IF (ABS(TIME-ZR(INSTL+I-1)).LT.PREC) THEN
            IEL = 1
            CALL RSEXCH(RESUEL,'DEPL',I,CHAMGD(2),IRET)
          END IF
   20   CONTINUE
        IF (IEL.EQ.0) THEN
          CALL U2MESS('F','CALCULEL4_48')
        END IF
      ELSE
C       PAS DE DONNEE ELASTOPLASTIQUE
        CHAMGD(1) = K24BID
        CHAMGD(3) = K24BID
        IORDR = ZI(JORDL)
        TIME = ZR(INSTL+IORDR-1)
        CALL RSEXCH(RESUEL,'DEPL',IORDR,CHAMGD(2),IRET)
      END IF
      IF (IRET.GT.0) CALL U2MESS('F','CALCULEL4_49')
      CHRESU(1) = ALPHA0
      CALL RSEXCH(RESULT,'ALPH0_ELGA_EPSP',1,CHRESU(1),IRET)
      IF (EXITIM) THEN
        CALL MECACT('V',CHTIM,'MODELE',MODELE(1:8)//'.MODELE','INST_R',
     &              1,'INST',IBID,TIME,CBID,K8BID)
      ELSE
        TIME = 0.D0
      END IF
C     CALCUL DU ALPHA0
      CALL VRCINS(MODELE,MATE,' ',TIME,CHVARC(1:19),CODRET)
C CREATION DU CHAMP DE VARIABLE DE COMMANDE RESTREINT A LA TEMPERATURE
C AYANT COMME VALEUR LA VALEUR TPZAC FOURNIE PAR L UTILISATEUR
      CALL NMVCD2('TEMP',MATE,EXTEMP,LBID)
      IF (EXTEMP) THEN
        CALL COPISD('CHAMP','V',CHVARC,CHVZAC)
        CALL JELIRA(CHVZAC(1:19)//'.CELV','LONMAX',LONG,K1BID)
        CALL JEVEUO(CHVZAC(1:19)//'.CELV','L',JCELV)
        DO 25 I=1,LONG
          ZR(JCELV-1+I)=TPZAC
25      CONTINUE
      ENDIF
C -----------------------
      CALL VRCREF(MODELE(1:8),MATE(1:8),'        ',CHVREF(1:19))
      CALL MECALZ(OPTION,CHAMGD,CHGEOM,MATE,CHVARC,CHVREF,CHTIM,
     &            ZK8(JCHA),CHRESU,LIGREL,BASE)
      CALL RSNOCH(RESULT,'ALPH0_ELGA_EPSP',1,' ')
C     ============================================================
C     (3)- CALCUL DE LA PROJECTION DE ALPHA ZERO SUR LES CONVEXES
C     CALCUL DES DEFORMATIONS INITIALES (EPSILON-INI MOY-INF-SUP)
C     ============================================================
      OPTION = 'PROJ_ALPH_ZAC'
      CHAMGD(1) = ALPHA0
      CALL COPISD('CHAMP','V',CHRESU(1) (1:19),CHAMGD(1) (1:19))
      DO 30 I = 1,NBRES
        CHRESU(I) = DUMMY(I)
   30 CONTINUE
      CALL RSEXCH(RESULT,'VARI_ELGA_ZAC',1,CHRESU(4),IRET)
      CHRESU(5) = ALPHAL
C   INSTAN = 1 : PREMIERE ETAPE - TEST EXISTENCE INTERSECTION
C                COMMUNE A TOUTES LES SPHERES POUR CAS NON RADIAL
C   METHODE ZAC - ETAPE 2 : LA SITUATION A L''ETAT LIMITE
      TOTVAD = 0.D0
C    BOUCLE SUR L'ENSEMBLE DES CONVEXES DEUX A DEUX
      DO 50 I = 1,NBORDL - 1
        DO 40 J = I + 1,NBORDL
          IORDRM = ZI(JORDL+I-1)
          IORDRP = ZI(JORDL+J-1)
          CALL RSEXCH(RESUEL,'SIEF_ELGA_DEPL',IORDRM,CHAMGD(2),IRET)
          IF (IRET.GT.0) CALL U2MESS('F','CALCULEL4_50')
          CALL RSEXCH(RESUEL,'SIEF_ELGA_DEPL',IORDRP,CHAMGD(3),IRET)
          IF (IRET.GT.0) CALL U2MESS('F','CALCULEL4_50')
          TIME = ZR(INSTL+IORDRP-1)
          TIMEP = 1.D0
          CALL MECACT('V',CHTIMP,'MODELE',MODELE(1:8)//'.MODELE',
     &                'INST_R',1,'INST',IBID,TIMEP,CBID,K8BID)
          CALL VRCREF(MODELE(1:8),MATE(1:8),'        ',CHVREF(1:19))
          CALL MECALZ(OPTION,CHAMGD,CHGEOM,MATE,CHTZAC,CHVREF,CHTIMP,
     &                ZK8(JCHA),CHRESU,LIGREL,BASE)
          CALL MESOMM(CHRESU(4),1,IBID,VADAP,CBID,0,IBID)
          TOTVAD = TOTVAD + VADAP
          IF (VADAP.NE.0.D0 .AND. NBORDL.GT.2) THEN
            CALL U2MESS('S','CALCULEL4_51')
            GO TO 130
          END IF
   40   CONTINUE
   50 CONTINUE
      IF (TOTVAD.NE.0.D0) THEN
C     METHODE ZAC - SITUATION A L ETAT LIMITE : ACCOMMODATION
        NBAMPL = 4
        NBALPH = 3
      ELSE
C     METHODE ZAC - SITUATION A L ETAT LIMITE : ADAPTATION
        NBAMPL = 1
        NBALPH = 1
      END IF
      DO 60 IORD = 1,NBALPH
        CALL RSEXCH(RESULT,'ALPHP_ELGA_ALPH0',IORD,CHRESU(IORD),IRET)
   60 CONTINUE
      DO 70 I = 1,NBALPH
        EPSINI(I) = CHRESU(I)
   70 CONTINUE
      CALL RSNOCH(RESULT,'VARI_ELGA_ZAC',1,' ')
C     METHODE ZAC - ETAPE 3 : PROJECTION DU ALPHA ZERO
      IF (NBORDL.GT.2) THEN
C       CAS NON RADIAL : ON BOUCLE SUR LES N SPHERES POUR LA PROJECTION
        NPROJ = NBORDL
      ELSE
        NPROJ = NBORDL - 1
      END IF
C  CALCUL DE LA PROJECTION DE ALPHA0 SUR LES N SPHERES
      DO 80 I = 1,NPROJ
        IORDRM = ZI(JORDL+I-1)
        IF (I.EQ.NBORDL) THEN
          IORDRP = ZI(JORDL)
        ELSE
          IORDRP = ZI(JORDL+I)
        END IF
        CALL RSEXCH(RESUEL,'SIEF_ELGA_DEPL',IORDRM,CHAMGD(2),IRET)
        IF (IRET.GT.0) CALL U2MESS('F','CALCULEL4_50')
        CALL RSEXCH(RESUEL,'SIEF_ELGA_DEPL',IORDRP,CHAMGD(3),IRET)
        IF (IRET.GT.0) CALL U2MESS('F','CALCULEL4_50')
        TIME = ZR(INSTL+IORDRP-1)
        TIMEP = 2.D0
        CALL MECACT('V',CHTIMP,'MODELE',MODELE(1:8)//'.MODELE','INST_R',
     &              1,'INST',IBID,TIMEP,CBID,K8BID)
        CALL VRCREF(MODELE(1:8),MATE(1:8),'        ',CHVREF(1:19))
        CALL MECALZ(OPTION,CHAMGD,CHGEOM,MATE,CHTZAC,CHVREF,CHTIMP,
     &              ZK8(JCHA),CHRESU,LIGREL,BASE)
        CALL COPISD('CHAMP','V',CHRESU(5) (1:19),CHAMGD(1) (1:19))
   80 CONTINUE
      CHAMGD(1) = CHRESU(5)
      DO 90 IORD = 1,NBALPH
        CALL RSNOCH(RESULT,'ALPHP_ELGA_ALPH0',IORD,' ')
   90 CONTINUE
C     METHODE ZAC - ETAPE 4 : RESOLUTION DES PROBLEMES ELASTIQUES
C     =================================================
C     (4) RESOLUTION DES PROBLEMES ELASTIQUES HOMOGENES
C     AVEC DEFORMATIONS INITIALES
C     =================================================
C -- SD L_CHARGES
      CALL NMDOME(MODELE,MATE,CARELE,LISCHA,NBPASE,INPSCO,BLAN8,IBID)
      CHARGE = LISCHA//'.LCHA'
      INFOCH = LISCHA//'.INFC'
      FOMULT = LISCHA//'.FCHA'
C -- CREATION DE LA CARTE RELATION DE COMPORTEMENT ZAC
      NBVARI = 1
      NBVARM = 1
      CALL ALCART('V',COMPOR,NOMA,NOMGRD)
      CALL JEVEUO(COMPOR(1:19)//'.NCMP','E',JNCMP)
      DO 100,I = 1,NCMPMA
        ZK8(JNCMP-1+I) = NOMCMP(I)
  100 CONTINUE
      CALL JEVEUO(COMPOR(1:19)//'.VALV','E',JVALV)
      NBCOU = 0
      NBSEC = 0
      ZK16(JVALV-1+1) = 'ZAC'
      ZK16(JVALV-1+4) = 'COMP_ELAS'
      WRITE (ZK16(JVALV-1+2),'(I16)') NBVARI
      WRITE (ZK16(JVALV-1+5),'(I16)') NBVARM
      WRITE (ZK16(JVALV-1+6),'(I3)') NBCOU
      WRITE (ZK16(JVALV-1+7),'(I3)') NBSEC
      DO 110,I = 1,DIMAKI
        ZK16(JVALV-1+7+I) = ' '
  110 CONTINUE
      ZK16(JVALV-1+3) = 'PETIT'
      CALL NOCART(COMPOR,1,K8BID,'NOM',0,K8BID,IBID,K8BID,NCMPMA)
C -- PARAMETRES DONNES APRES LE MOT-CLE FACTEUR SOLVEUR
      CALL WKVECT(SOLVEU(1:19)//'.SLVK','V V K24',11,ISLVK)
      CALL WKVECT(SOLVEU(1:19)//'.SLVR','V V R',4,ISLVR)
      CALL WKVECT(SOLVEU(1:19)//'.SLVI','V V I',6,ISLVI)
      ZK24(ISLVK) = 'LDLT'
      ZK24(ISLVK+1) = 'SANS'
      ZK24(ISLVK+2) = 'NON'
      ZK24(ISLVK+3) = 'RCMK'
      ZR(ISLVR) = 0.D0
      ZR(ISLVR+1) = 1.D-6
      ZR(ISLVR+2) = 400.D0
      ZI(ISLVI) = 0
      ZI(ISLVI+1) = 0
C -- CRITERES DE CONVERGENCE LOCAUX
      CALL JENONU(JEXNOM('&CATA.GD.NOMGD','CARCRI'),NUMGD)
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',NUMGD),'L',JACMP)
      CALL JELIRA(JEXNUM('&CATA.GD.NOMCMP',NUMGD),'LONMAX',NCMP,K1BID)
      CALL WKVECT('&&OP0175.TRAVR','V V R8',NCMP,IRCMP)
      ZR(IRCMP) = 10
      ZR(IRCMP+1) = 0.D0
      ZR(IRCMP+5) = 0.D0
      ZR(IRCMP+2) = 1.D-6
      ZR(IRCMP+3) = 1.D0
      ZR(IRCMP+4) = 0
      CALL MECACT('V',CARCRI,'MODELE',LIGREL,'CARCRI',NCMP,ZK8(JACMP),
     &            IBID,ZR(IRCMP),CBID,K8BID)

C -- NUME_DDL
      NUMEDD = '12345678.NUMED'
      NOOJB='12345678.00000.NUME.PRNO'
      CALL GNOMSD ( NOOJB,10,14 )
      NUMEDD=NOOJB(1:14)
      CALL NUMERO(' ',MODELE,LISCHA,SOLVEU,'VG',NUMEDD)

      CALL VTCREB(DEPMOI,NUMEDD,'V','R',NEQ)

C    INSTANTS T- = 0, T+ = 1
      INSTAM = 0.D0
      INSTAP = 1.D0
      CALL MECACT('V',CHTIM,'MODELE',MODELE(1:8)//'.MODELE','INST_R',1,
     &            'INST',IBID,INSTAM,CBID,K8BID)
      CALL NMVCAF('INST',CHTIM,.TRUE.,COMMOI)
      CALL MECACT('V',CHTIP,'MODELE',MODELE(1:8)//'.MODELE','INST_R',1,
     &            'INST',IBID,INSTAP,CBID,K8BID)
      CALL NMVCAF('INST',CHTIP,.TRUE.,COMPLU)
      CALL NMVCAF('TOUT',CHVZAC,.TRUE.,COMMOI)
      CALL NMVCAF('TOUT',CHVZAC,.TRUE.,COMPLU)

C -- ETAT INITIAL NUL
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = NOMA//'.COORDO'
      LPAOUT(1) = 'PVARI_R'
      LCHOUT(1) = VARMOI
      LPAOUT(2) = 'PSIEF_R'
      LCHOUT(2) = SIGMOI
      CALL COPISD('CHAM_ELEM_S','V',COMPOR,VARMOI)
      OPTION = 'TOU_INI_ELGA'
      CALL CALCUL('S',OPTION,LIGREL,1,LCHIN,LPAIN,2,LCHOUT,LPAOUT,'V')
C    DEPLACEMENTS
      CALL VTCREB(DEPDEL,NUMEDD,'V','R',NEQ)
      CALL VTCREB(DEPPLU,NUMEDD,'V','R',NEQ)
C    VARIABLES AGGLOMEREES POUR MERIMO
      CALL AGGLOM(DEPMOI,SIGMOI,VARMOI,COMMOI,K24BLA,K24BLA,K24BLA,
     &            K24BLA,4,VALMOI)
      CALL AGGLOM(DEPPLU,SIGPLU,VARPLU,COMPLU,K24BLA,K24BLA,K24BLA,
     &            K24BLA,4,VALPLU)
      CALL AGGLOM(K24BLA,K24BLA,K24BLA,K24BLA,K24BLA,K24BLA,K24BLA,
     &            K24BLA,8,POUGD)
C -- CONSTRUCTION DE LA MATRICE TANGENTE (IDENTIQUE A CHAQUE IORD)
C    RIGIDITE ASSOCIEE AUX LAGRANGE
      CALL MEDIM2(MODELE,LISCHA,MEDIRI)
C    RIGIDITE MATERIAU (ELASTIQUE)
      OPTION = 'RIGI_MECA_TANG'
      CALL MERIM2(MODELE,CARELE,MATE,COMREF,COMPOR,LISCHA,CARCRI,DEPDEL,
     &            POUGD,K24BLA,K24BLA,K24BLA,VALMOI,VALPLU,OPTION,
     &            MERIGI,K24BLA,K24BLA,1,TABRET)
C    ASSEMBLAGE ET FACTORISATION
      CALL ASASM2(MERIGI,MEDIRI,NUMEDD,MATASS,SOLVEU,LISCHA)
      CALL PRERES(SOLVEU,'V',IRET,MAPREC,MATASS)
      CALL MTDSCR(MATASS)
C -- CONSTRUCTION DU SECOND MEMBRE DE DIRICHLET
      VADIDO = '&&VADIDO'
C    DEPLACEMENTS IMPOSES DONNES
      CALL VEDIME(MODELE,CHARGE,INFOCH,INSTAP,'R',TYPESE,NOPASE,VEDIDO)
      CALL ASASVE(VEDIDO,NUMEDD,'R',VADIDO)
      CALL ASCOVA('D',VADIDO,FOMULT,'INST',INSTAP,'R',CNDIDO)
C    CONDITIONS CINEMATIQUES IMPOSEES (INACTIF -> CNCINE EST NUL)
      CALL VTCREB(CNCINE,NUMEDD,'V','R',NEQ)
C ----------------------------------
C --- BOUCLE SUR LES NUMEROS D'ORDRE
C ----------------------------------
      NUMORD = 0
      DO 120 IORD = 1,NBAMPL
        NUMORD = NUMORD + 1
        IF (IORD.EQ.4) NUMORD = 3
C -- SECOND MEMBRE ZAC
        IF (IORD.EQ.4) THEN
          CHRESU(NUMORD) = EPSINI(NUMORD+1)
        ELSE
          CHRESU(NUMORD) = EPSINI(NUMORD)
        END IF
        CALL VECZAC(MODELE,NUMEDD,MATE,CHVZAC,CHRESU(NUMORD),CNZAC)
C -- RESOLUTION
        CALL JEVEUO(CNZAC(1:19)//'.VALE','E',JZAC)
        CALL JEVEUO(CNDIDO(1:19)//'.VALE','L',JDIDO)
        CALL DAXPY(NEQ,1.D0,ZR(JDIDO),1,ZR(JZAC),1)
        CALL RESOUD(MATASS,MAPREC,CNZAC,SOLVEU,CNCINE,'V',DEPDEL,' ',
     &              0,RBID,CBID)
C -- MISE A JOUR DES DEPLACEMENTS
        CALL COPISD('CHAMP','V',DEPDEL,DEPPLU)
C -- CALCUL DES CONTRAINTES
        OPTION = 'RAPH_MECA'
        CALL MERIM2(MODELE,CARELE,MATE,COMREF,COMPOR,LISCHA,CARCRI,
     &              DEPDEL,POUGD,K24BLA,K24BLA,K24BLA,VALMOI,VALPLU,
     &              OPTION,MERIGI,VERESI,VEDIRI,1,TABRET)
C -- ARCHIVAGE
        CALL RSEXCH(RESULT,'DEPL',NUMORD,CHDEPL,IRET)
        CALL COPISD('CHAMP','G',DEPPLU(1:19),CHDEPL(1:19))
        CALL RSNOCH(RESULT,'DEPL',NUMORD,' ')
        CALL RSEXCH(RESULT,'SIEF_ELGA',NUMORD,CHSIGM,IRET)
        CALL COPISD('CHAMP','G',SIGPLU(1:19),CHSIGM(1:19))
        CALL RSNOCH(RESULT,'SIEF_ELGA',NUMORD,' ')
C --- CALCUL DES AMPLITUDES DE CONTRAINTES ET DEFORM.PLASTIQUES
C     METHODE ZAC - ETAPE 5 : VALEURS MOYENNES ET AMPLITUDES
        CALL RSEXCH(RESULT,'DEPL',NUMORD,CHAMGD(1),IRET)
        IF (IORD.EQ.4) THEN
          CHAMGD(2) = EPSINI(NUMORD+1)
        ELSE
          CHAMGD(2) = EPSINI(NUMORD)
        END IF
        IORDRM = ZI(JORDL)
        IORDRP = ZI(JORDL+NBORDL-1)
        CALL RSEXCH(RESUEL,'SIEF_ELGA_DEPL',IORDRM,CHAMGD(3),IRET)
        CALL RSEXCH(RESUEL,'SIEF_ELGA_DEPL',IORDRP,CHAMGD(4),IRET)
        CALL RSEXCH(RESULT,'SIGM_ELNO_ZAC',NUMORD,CHRESU(1),IRET)
        CALL RSEXCH(RESULT,'EPSP_ELNO_ZAC',NUMORD,CHRESU(2),IRET)
        IF (IORD.EQ.3) THEN
          CHRESU(3) = EPSINI(NUMORD+1)
        ELSE
          CHRESU(3) = DUMMY(3)
        END IF
        TIME = DBLE(IORD)
        CALL MECACT('V',CHTIM,'MODELE',MODELE(1:8)//'.MODELE','INST_R',
     &              1,'INST',IBID,TIME,CBID,K8BID)
        OPTION = 'AMPL_ELNO_ZAC'
C       CALCUL DES AMPLITUDES ET VALEURS MOYENNES A L'ETAT LMITE
        CALL MECALZ(OPTION,CHAMGD,CHGEOM,MATE,CHTZAC,CHVREF,CHTIM,
     &              ZK8(JCHA),CHRESU,LIGREL,BASE)
        CALL RSNOCH(RESULT,'SIGM_ELNO_ZAC',NUMORD,' ')
        CALL RSNOCH(RESULT,'EPSP_ELNO_ZAC',NUMORD,' ')
        CALL RSADPA(RESULT,'E',1,'NOM_CAS',NUMORD,0,LCAS,K8BID)
        IF (NUMORD.EQ.1) THEN
          ZK16(LCAS) = 'VALEUR  MOYENNE'
        ELSE IF (NUMORD.EQ.2) THEN
          ZK16(LCAS) = 'AMPLITUDE I'
        ELSE IF (NUMORD.EQ.3) THEN
          ZK16(LCAS) = 'AMPLITUDE S'
        END IF
  120 CONTINUE
  130 CONTINUE

      CALL JEDETC('G','&&OP0175',1)
      CALL JEDETC('G','&&ALPHAL',1)
      CALL JEDETC('G','&&EPSSU2',1)

      CALL JEDEMA()
      END

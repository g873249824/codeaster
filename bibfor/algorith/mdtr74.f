      SUBROUTINE MDTR74(NOMRES,NOMCMD)
      IMPLICIT REAL*8 (A-H,O-Z)
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 21/07/2003   AUTEUR NICOLAS O.NICOLAS 
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

C     BUT: CALCUL TRANSITOIRE PAR DYNA_TRAN_MODAL DANS LE CAS OU LES
C          MATRICES ET VECTEURS PROVIENNENT D'UNE PROJECTION SUR :
C              - MODE_MECA
C              - MODE_GENE
C              - BASE_MODALE

C TOLE CRP_20
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

C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------

      CHARACTER*1  NIV,K1BID
      CHARACTER*8  K8B,NOMRES,METHOD,MASGEN,RIGGEN,AMOGEN,BASEMO
      CHARACTER*8  MATASS,VECGEN,MONMOT,LISTAM,TYPFLU,NOMBM,MATR
      CHARACTER*8  RIGASS,MAILLA
      CHARACTER*14 NUMDDL,NUMGEM,NUMGEK,NUMGEC,K14B
      CHARACTER*16 NOMCMD,TYPBAS,TYPBA2
      CHARACTER*19 LISARC,NOMSTM,NOMSTK,MASSE
      CHARACTER*24 NUMK24,NUMM24,NUMC24,LISINS,NOMNOE
      CHARACTER*24 MARIG
      LOGICAL      LAMOR,LFLU,LPSTO
      INTEGER      KREF,ITYPFL,KINST
      REAL*8       R8B,XLAMBD,ACRIT,AGENE,TOTO

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
      CALL INFNIV(IFM,INFO)

      LAMOR = .FALSE.
      LFLU = .FALSE.
      LPSTO = .FALSE.

C     --- RECUPERATION DES ARGUMENTS DE LA COMMANDE ---

      CALL GETVTX(' ','METHODE',0,1,1,METHOD,N1)
      CALL GETVIS(' ','NMAX_ITER',0,1,1,ITEMAX,N1)
      CALL GETVR8(' ','RESI_RELA',0,1,1,PREC,N1)
      CALL GETVR8(' ','LAMBDA',0,1,1,XLAMBD,N1)
      CALL GETFAC('EXCIT',NEXCIT)

C     --- RECUPERATION DES MATRICES PROJETEES ---

      CALL GETVID(' ','MASS_GENE',0,1,1,MASGEN,NM)
      CALL GETVID(' ','RIGI_GENE',0,1,1,RIGGEN,NR)
      CALL GETVID(' ','AMOR_GENE',0,1,1,AMOGEN,NA)
      IF (NEXCIT.NE.0) THEN
        CALL WKVECT('&&MDTR74.NOMVEC','V V K8',NEXCIT,JVEC)
        DO 10 I = 1,NEXCIT
          CALL GETVID('EXCIT','VECT_GENE',I,1,1,VECGEN,NV)
          ZK8(JVEC-1+I) = VECGEN
   10   CONTINUE
      END IF
      IF (NA.EQ.0) LAMOR = .TRUE.

C     --- RECUPERATION DE LA NUMEROTATION GENERALISEE DE M, K

      CALL JEVEUO(MASGEN//'           .REFA','L',JREFE)
      NUMGEM = ZK24(JREFE+1) (1:14)
      NOMSTM = NUMGEM//'.SLCS'
      CALL JEVEUO(NOMSTM//'.DESC','L',JDESCM)
      NBSTOM = ZI(JDESCM)*ZI(JDESCM+3)

      CALL JEVEUO(RIGGEN//'           .REFA','L',JREFK)
      NUMGEK = ZK24(JREFK+1) (1:14)
      NOMSTK = NUMGEK//'.SLCS'
      CALL JEVEUO(NOMSTK//'.DESC','L',JDESCK)
      NBSTOK = ZI(JDESCK)*ZI(JDESCK+3)

C     --- RECUPERATION DE LA BASE MODALE ET NOMBRE DE MODES ---

      CALL JEVEUO(MASGEN//'           .DESC','L',JDESC)
      NBMODE = ZI(JDESC+1)
      BASEMO = ZK24(JREFE) (1:8)
      CALL JEVEUO(BASEMO//'           .REFE','L',JDRIF)
      RIGASS = ZK24(JDRIF+2) (1:8)
      MARIG = '&&MDTR74.RIGI'
      CALL COPISD('MATR_ASSE','V',RIGASS,MARIG)
      CALL GETTCO(BASEMO,TYPBAS)
      CALL MTDSCR(MASGEN)
      CALL JEVEUO(MASGEN//'           .&INT','L',LMAT)
      NTERM = ZI(LMAT+14)
      TYPBA2 = TYPBAS
      IF ((TYPBAS.EQ.'MODE_MECA'.AND.NTERM.GT.NBMODE).OR.
     +    (TYPBAS.EQ.'MODE_STAT'.AND.NTERM.GT.NBMODE)) THEN 
         TYPBAS = 'BASE_MODA'
      ENDIF           

      NBSTOC = NBMODE

      IF ((TYPBA2(1:9).EQ.'MODE_MECA').OR.
     +    (TYPBA2(1:9).EQ.'MODE_STAT')) THEN
        MATASS = ZK24(JDRIF) (1:8)
        CALL DISMOI('F','NOM_NUME_DDL',MATASS,'MATR_ASSE',IB,NUMDDL,IE)
        CALL DISMOI('F','NB_EQUA',MATASS,'MATR_ASSE',NEQ,K8B,IE)
        NBMOD2 = NBMODE
      ELSE IF (TYPBA2(1:9).EQ.'BASE_MODA') THEN
        NUMDDL = ZK24(JDRIF+1) (1:14)
        CALL DISMOI('F','NB_EQUA',NUMDDL,'NUME_DDL',NEQ,K8B,IE)
        NBMOD2 = NBMODE
      ELSE IF (TYPBA2(1:9).EQ.'MODE_GENE') THEN
        MATASS = ZK24(JDRIF) (1:8)
        CALL JEVEUO(MATASS//'           .REFA','L',LLREFE)
        NUMDDL = ZK24(LLREFE+1)
        CALL JEVEUO(NUMDDL//'.NUME.NEQU','L',LLNEQU)
        NEQ = ZI(LLNEQU)
        NBMOD2 = NBMODE
      ELSE
        CALL UTMESS('F',NOMCMD,'TYPE DE BASE INCONNU.')
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
      CALL COPMOD(BASEMO,'DEPL',NEQ,NUMDDL,NBMODE,ZR(JBASE))
      DO 20 I = 0,NBMODE - 1
        OMEG2 = ABS(ZR(JRAIG+I)/ZR(JMASG+I))
        ZR(JPULS+I) = SQRT(OMEG2)
        ZR(JPUL2+I) = OMEG2
   20 CONTINUE

C     --- RECUPERATION DE L AMORTISSEMENT ---

C     ... RECUPERATION D'UNE LISTE D'AMORTISSEMENTS REDUITS ...

      IF (LAMOR) THEN

        AMOGEN = '&&AMORT'
        CALL GETVR8(' ','AMOR_REDUIT',0,1,0,R8B,N1)
        CALL GETVID(' ','LIST_AMOR',0,1,0,K8B,N2)
        IF (N1.NE.0 .OR. N2.NE.0) THEN
          IF (N1.NE.0) THEN
            NBAMOR = -N1
          ELSE
            CALL GETVID(' ','LIST_AMOR',0,1,1,LISTAM,N)
            CALL JELIRA(LISTAM//'           .VALE','LONMAX',NBAMOR,K8B)
          END IF
          IF (NBAMOR.GT.NBMODE) THEN

            CALL UTDEBM('A',NOMCMD,
     &              'LE NOMBRE D''AMORTISSEMENTS REDUITS EST TROP GRAND'
     &                  )
            CALL UTIMPI('L','LE NOMBRE DE MODES PROPRES VAUT ',1,NBMODE)
            CALL UTIMPI('L','ET LE NOMBRE DE COEFFICIENTS : ',1,NBAMOR)
            CALL UTIMPI('L','ON NE GARDE DONC QUE LES ',1,NBMODE)
            CALL UTIMPK('S',' ',1,'PREMIERS COEFFICIENTS')
            CALL UTFINM()
            CALL WKVECT('&&MDTR74.AMORTI','V V R8',NBMODE,JAMOG)
            IF (N1.NE.0) THEN
              CALL GETVR8(' ','AMOR_REDUIT',0,1,NBMODE,ZR(JAMOG),N)
            ELSE
              CALL JEVEUO(LISTAM//'           .VALE','L',IAMOG)
              DO 30 IAM = 1,NBMODE
                ZR(JAMOG+IAM-1) = ZR(IAMOG+IAM-1)
   30         CONTINUE
            END IF
          ELSE IF (NBAMOR.LT.NBMODE) THEN

            CALL WKVECT('&&MDTR74.AMORTI','V V R8',NBAMOR,JAMOG)
            IF (N1.NE.0) THEN
              CALL GETVR8(' ','AMOR_REDUIT',0,1,NBAMOR,ZR(JAMOG),N)
            ELSE
              CALL JEVEUO(LISTAM//'           .VALE','L',IAMOG)
              DO 40 IAM = 1,NBAMOR
                ZR(JAMOG+IAM-1) = ZR(IAMOG+IAM-1)
   40         CONTINUE
            END IF
            IDIFF = NBMODE - NBAMOR
            CALL UTDEBM('I',NOMCMD,
     &             'LE NOMBRE D''AMORTISSEMENTS REDUITS EST INSUFFISANT'
     &                  )
            CALL UTIMPI('L','IL EN MANQUE : ',1,IDIFF)
            CALL UTIMPI('L','CAR LE NOMBRE DE MODES VAUT : ',1,NBMODE)
            CALL UTIMPI('L','ON RAJOUTE ',1,IDIFF)
            CALL UTIMPK('S',' ',1,'AMORTISSEMENTS REDUITS AVEC LA')
            CALL UTIMPK('S',' ',1,'VALEUR DU DERNIER MODE PROPRE')
            CALL UTFINM()
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
              CALL GETVR8(' ','AMOR_REDUIT',0,1,NBAMOR,ZR(JAMOG),N)
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
            IF (TYPBA2(1:9).NE.'MODE_STAT') THEN
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
        CALL JEVEUO(AMOGEN//'           .REFA','L',JREFC)
        NUMGEC = ZK24(JREFC+1) (1:14)
        NUMC24(1:14) = NUMGEC
        CALL EXTDIA(AMOGEN,NUMC24,0,ZR(JAMO1))
        DO 90 I = 1,NBMOD2
          ACRIT = DEUX*SQRT(ABS(ZR(JMASG+I-1)*ZR(JRAIG+I-1)))
          AGENE = ZR(JAMO1+I-1)
          IF (AGENE.GT.ACRIT) THEN
            CALL UTDEBM('A','MDTR74','!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
            CALL UTIMPI('L','MODE DYNAMIQUE           : ',1,I)
            CALL UTIMPR('L','AMORTISSEMENT TROP GRAND : ',1,AGENE)
            CALL UTIMPR('L','AMORTISSEMENT CRITIQUE   : ',1,ACRIT)
            CALL UTIMPK('L','PROBLEMES DE CONVERGENCE POSSIBLES',1,' ')
            CALL UTFINM()
          END IF
   90   CONTINUE
C        PROBLEME POSSIBLE DU JEVEUO SUR UNE COLLECTION
        CALL WKVECT('&&MDTR74.AMORTI','V V R8',NBMODE*NBMODE,JAMOG)
        CALL COPMAT(AMOGEN,NUMGEC,ZR(JAMOG))
      END IF

C     --- VERIFICATION DES DONNEES GENERALISEES ---

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
        CALL MDITMI(NOMCMD,TYPFLU,NOMBM,ICOUPL,NBM0,NBMODE,NBMD,
     &           VGAP,ITRANS,EPS,TS, NTS,ITYPFL)
        CALL JEVEUO('&&MDITMI.PULSATIO','L'    ,JPULS)
        CALL JEVEUO('&&MDITMI.MASSEGEN','L'    ,JMASG)
        CALL JEVEUO('&&MDITMI.AMORTI'  ,'L'    ,JAMOG)
        CALL JEVEUO('&&MDITMI.AMORTGEN','L'    ,JAMO1)
        CALL JEVEUO('&&MDITMI.BASEMODE','L'    ,JBASE)
        CALL JEVEUO('&&MDITMI.LOCFL0'  ,'L'    ,JLOCF)
        CALL GETVIS( ' ', 'NUME_VITE_FLUI', 0,1,1, NUMVIF, N1 )
        CALL GETVIS ( ' ', 'NB_MODE_FLUI' , 0,1,1, NBMP  , NMP )
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

C     --- RECUPERATION DES PARAMETRES D'EXCITATION

      NPSDEL = NEXCIT*NEQ
      IF (NEXCIT.NE.0) THEN
        CALL WKVECT('&&MDTR74.COEFM','V V R8',NEXCIT,JCOEFM)
        CALL WKVECT('&&MDTR74.IADVEC','V V IS',NEXCIT,JIADVE)
        CALL WKVECT('&&MDTR74.INUMOR','V V IS',NEXCIT,JINUMO)
        CALL WKVECT('&&MDTR74.IDESCF','V V IS',NEXCIT,JIDESC)
        CALL WKVECT('&&MDTR74.NOMFON','V V K8',2*NEXCIT,JNOMFO)
        CALL WKVECT(NOMRES//'           .FDEP','G V K8',2*NEXCIT,JNODEP)
        CALL WKVECT(NOMRES//'           .FVIT','G V K8',2*NEXCIT,JNOVIT)
        CALL WKVECT(NOMRES//'           .FACC','G V K8',2*NEXCIT,JNOACC)
        IF (NEQ.NE.0) THEN
C          ---  CREATION DES TAB DE FONCTION POUR XS ET X'S
          CALL WKVECT(NOMRES//'           .IPSD','G V R8',NPSDEL,JPSDEL)
        END IF
        CALL MDRECF(NEXCIT,ZI(JIDESC),ZK8(JNOMFO),ZR(JCOEFM),ZI(JIADVE),
     &              ZI(JINUMO),ZK8(JNODEP),ZK8(JNOVIT),ZK8(JNOACC),
     &              ZR(JPSDEL),NEQ,TYPBA2,BASEMO,NBMODE,ZR(JRAIG),
     &              MONMOT)
        IF (METHOD.EQ.'ITMI') THEN
          NBF = 0
          DO 100 I = 1,NEXCIT
            CALL JELIRA(ZK8(JNOMFO-1+I)//'           .VALE','LONMAX',
     &                  NBFV,K8B)
            NBFV = NBFV/2
            NBF = MAX(NBF,NBFV)
  100     CONTINUE
        END IF
      END IF

C     --- CHOC  ET  ANTI_SISM ---

      CALL GETFAC('CHOC',NBCHOC)
      CALL GETFAC('ANTI_SISM',NBSISM)
      CALL GETFAC('FLAMBAGE',NBFLAM)
      NBNLI = NBCHOC + NBSISM + NBFLAM
      IF (NBNLI.NE.0) THEN
        CALL WKVECT('&&MDTR74.RANG_CHOC','V V I ',NBNLI*5,JRANC)
        CALL WKVECT('&&MDTR74.DEPL','V V R8',NBNLI*6*NBMODE,JDEPL)
        CALL WKVECT('&&MDTR74.PARA_CHOC','V V R8',NBNLI*51,JPARC)
        CALL WKVECT('&&MDTR74.NOEU_CHOC','V V K8',NBNLI*9,JNOEC)
        CALL WKVECT('&&MDTR74.INTI_CHOC','V V K8',NBNLI,JINTI)
        IF (NEXCIT.NE.0) THEN
          NBEXIT = NEXCIT
          CALL WKVECT('&&MDTR74.PSID','V V R8',NBNLI*6*NEXCIT,JPSID)
        ELSE
          NBEXIT = 1
        END IF
        CALL MDCHOC(NBNLI,NBCHOC,NBFLAM,ZI(JRANC),ZR(JDEPL),ZR(JPARC),
     &              ZK8(JNOEC),ZK8(JINTI),ZR(JPSDEL),ZR(JPSID),NUMDDL,
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
          CALL CRICHO(NBMODE,ZR(JRAIG),NBNLI,ZR(JDEPL),ZR(JPARC),
     &                ZK8(JNOEC),INFO,ZR(IFIMP),ZR(IRFIMP),ZR(IPTCHO),
     &                ZR(ITRLOC),ZR(ISOUPL),ZI(IINDIC),NEQ,ZR(JBASE),
     &                SEUIL,MARIG,NBNLI)
          CALL GETVR8('VERI_CHOC','SEUIL',1,1,1,CRIT,N1)
          IF (SEUIL.GT.CRIT) THEN
            NIV = 'A'
            CALL GETVTX('VERI_CHOC','STOP_CRITERE',1,1,1,K8B,N1)
            IF (K8B.EQ.'OUI') NIV = 'F'
            CALL UTDEBM('I',NOMCMD,'!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
            CALL UTIMPR('L',' TAUX DE SOUPLESSE NEGLIGEE :',1,SEUIL)
            CALL UTFINM()
            CALL UTMESS(NIV,NOMCMD,
     &        'LE TAUX DE SOUPLESSE NEGLIGEE EST SUPERIEUR AU SEUIL.'
     &                  )
          END IF
        END IF
      END IF

C     --- RELATION EFFORT DEPLACEMENT ---

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

C     --- RELATION EFFORT VITESSE ---

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

      CALL MDPTEM(NBMODE,ZR(JMASG),ZR(JRAIG),ZR(JPULS),NBNLI,ZR(JDEPL),
     &            ZR(JPARC),ZK8(JNOEC),DT,TINIT,TFIN,NBPAS,INFO,IRET)
      IF (METHOD.EQ.'ITMI') THEN
        TFEXM = TFIN - TINIT
        IF (NTS.EQ.0) TS = TFEXM
      END IF
      IF (IRET.NE.0) GO TO 120

C     --- ARCHIVAGE ---

      IF (METHOD.EQ.'ADAPT' .OR. METHOD.EQ.'ITMI') THEN
        CALL GETVIS('ARCHIVAGE','PAS_ARCH',1,1,1,IPARCH,N1)
        IF (N1.EQ.0) IPARCH = 1
        IF (METHOD.EQ.'ADAPT') THEN
          DTARCH = DT*IPARCH
          NBSAUV = INT((TFIN-TINIT)/DTARCH) + 2
        ELSE IF (METHOD.EQ.'ITMI') THEN
C       DANS LE CAS ITMI, NBSAUV NE SERA CONNU QUE DANS MDITM2
          NBSAUV = 0
        END IF

        LPSTO = .TRUE.
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
C        IF (IRET.NE.0) CALL UTMESS('F',NOMCMD,
C     &                   'LA MATRICE MASSE GENERALISEE EST SINGULIERE.'
C     &                             )
      END IF     

C     --- ALLOCATION DES VECTEURS DE SORTIE ---

      CALL MDALLO(NOMRES,BASEMO,MASGEN,RIGGEN,AMOGEN,NBMODE,DT,NBSAUV,
     &            NBNLI,ZK8(JNOEC),ZK8(JINTI),NBREDE,ZK8(JFOND),NBREVI,
     &            JDEPS,JVITS,JACCS,JPASS,JORDR,JINST,JFCHO,JDCHO,JVCHO,
     &            JICHO,JREDC,JREDD,LPSTO,METHOD)

      IF (INFO.EQ.1 .OR. INFO.EQ.2) THEN
        CALL UTDEBM('I','----------------------------------------------'
     &              ,' ')
        CALL UTIMPK('L','       CALCUL PAR SUPERPOSITION MODALE',0,' ')
        CALL UTIMPK('L','----------------------------------------------'
     &              ,0,' ')
        CALL UTIMPK('L','! LA BASE DE PROJECTION EST UN',1,TYPBAS(1:9))
        CALL UTIMPI('L','! LE NB D''EQUATIONS EST          :',1,NEQ)
        CALL UTIMPK('L','! LA METHODE UTILISEE EST        :',1,METHOD)
        CALL UTIMPK('L','! LA BASE UTILISEE EST           :',1,BASEMO)
        CALL UTIMPI('L','! LE NB DE VECTEURS DE BASE EST  : ',1,NBMODE)
        IF (METHOD.EQ.'ADAPT') THEN
          CALL UTIMPR('L','! LE PAS DE TEMPS INITIAL EST  :',1,DT)
          CALL UTIMPI('L','! LE NB DE PAS D''ARCHIVE EST     : ',1,
     &                NBSAUV)
        ELSE IF (METHOD.EQ.'ITMI') THEN
          CALL UTIMPI('L','! NUME_VITE_FLUI                 : ',1,
     &                NUMVIF)
          CALL UTIMPR('L','! VITESSE GAP                    : ',1,VGAP)
          CALL UTIMPI('L','! LE NB DE MODES DE BASE_FLUI    : ',1,
     &                NBMODE)
          CALL UTIMPI('L','! LE NB TOTAL DE MODES DE LA BASE: ',1,NBM0)
          CALL UTIMPR('L','! LE PAS DE TEMPS INITIAL EST    : ',1,DT)
          CALL UTIMPR('L','! DUREE DE L''EXCITATION          : ',1,
     &                TFEXM)
          IF (ITRANS.NE.0) CALL UTIMPR('L',
     &                             '! PRECISION DU TRANSITOIRE       : '
     &                                 ,1,EPS)
          IF (ICOUPL.NE.0) CALL UTIMPI('L',
     &                             '! COUPLAGE TEMPOREL AVEC NB MODES: '
     &                                 ,1,NBMP)
          CALL UTIMPI('L','! LE NB DE PAS D''ARCHIVE EST     : ',1,
     &                IPARCH)
        ELSE
          CALL UTIMPR('L','! LE PAS DE TEMPS DU CALCUL EST  :',1,DT)
          CALL UTIMPI('L','! LE NB DE PAS DE CALCUL EST     : ',1,NBPAS)
          CALL UTIMPI('L','! LE NB DE PAS D''ARCHIVE EST     : ',1,
     &                NBSAUV)
        END IF
        IF (NBCHOC.NE.0) CALL UTIMPI('L',
     &                            '! LE NOMBRE DE LIEU(X) DE CHOC EST: '
     &                               ,1,NBCHOC)
        IF (NBSISM.NE.0) CALL UTIMPI('L',
     &                           '! LE NBRE DE DISPO ANTI SISMIQUE EST:'
     &                               ,1,NBSISM)
        IF (NBFLAM.NE.0) CALL UTIMPI('L',
     &               '! LE NBRE DE LIEU(X) DE CHOC AVEC FLAMBEMENT EST:'
     &                               ,1,NBFLAM)
        IF (NBREDE.NE.0) CALL UTIMPI('L',
     &                             '! LE NOMBRE DE RELA_EFFO_DEPL EST: '
     &                               ,1,NBREDE)
        IF (NBREVI.NE.0) CALL UTIMPI('L',
     &                             '! LE NOMBRE DE RELA_EFFO_VITE EST: '
     &                               ,1,NBREVI)
        CALL UTIMPK('L','----------------------------------------------'
     &              ,0,' ')
        CALL UTFINM()
      END IF

      IF (METHOD.EQ.'EULER') THEN
        CALL MDEUL1(NBPAS,DT,NBMODE,ZR(JPULS),ZR(JPUL2),ZR(JMASG),IBID,
     &              ZR(JRAIG),IBID,LAMOR,ZR(JAMOG),IBID,TYPBAS,BASEMO,
     &              TINIT,ZI(JARCH),NBSAUV,ITEMAX,PREC,XLAMBD,LFLU,
     &              NBNLI,ZI(JRANC),ZR(JDEPL),ZR(JPARC),ZK8(JNOEC),
     &              NBREDE,ZR(JREDE),ZR(JPARD),ZK8(JFOND),NBREVI,
     &              ZR(JREVI),ZK8(JFONV),ZR(JDEPS),ZR(JVITS),ZR(JACCS),
     &              ZI(JORDR),ZR(JINST),ZR(JFCHO),ZR(JDCHO),ZR(JVCHO),
     &              ZI(JICHO),ZI(JREDC),ZR(JREDD),ZR(JCOEFM),ZI(JIADVE),
     &              ZI(JINUMO),ZI(JIDESC),ZK8(JNODEP),ZK8(JNOVIT),
     &              ZK8(JNOACC),ZK8(JNOMFO),ZR(JPSID),MONMOT,NOMRES)

      ELSE IF (METHOD.EQ.'ADAPT') THEN
        CALL MDADAP(DT,NBMODE,ZR(JPULS),ZR(JPUL2),ZR(JMASG),IBID,
     &              ZR(JRAIG),IBID,LAMOR,ZR(JAMOG),IBID,TYPBAS,BASEMO,
     &              TINIT,TFIN,DTARCH,NBSAUV,ITEMAX,PREC,XLAMBD,LFLU,
     &              NBNLI,ZI(JRANC),ZR(JDEPL),ZR(JPARC),ZK8(JNOEC),
     &              NBREDE,ZR(JREDE),ZR(JPARD),ZK8(JFOND),NBREVI,
     &              ZR(JREVI),ZK8(JFONV),ZR(JDEPS),ZR(JVITS),ZR(JACCS),
     &              ZR(JPASS),ZI(JORDR),ZR(JINST),ZR(JFCHO),ZR(JDCHO),
     &              ZR(JVCHO),ZI(JICHO),ZI(JREDC),ZR(JREDD),ZR(JCOEFM),
     &              ZI(JIADVE),ZI(JINUMO),ZI(JIDESC),ZK8(JNODEP),
     &              ZK8(JNOVIT),ZK8(JNOACC),ZK8(JNOMFO),ZR(JPSID),
     &              MONMOT,NOMRES)

      ELSE IF (METHOD.EQ.'NEWMARK') THEN
        CALL MDNEWM(NBPAS,DT,NBMODE,ZR(JPULS),ZR(JPUL2),ZR(JMASG),
     &              ZR(JRAIG),LAMOR,ZR(JAMOG),TYPBAS,BASEMO,TINIT,
     &              ZI(JARCH),ZR(JDEPS),ZR(JVITS),ZR(JACCS),ZI(JORDR),
     &              ZR(JINST),NOMRES)

      ELSE IF (METHOD.EQ.'DEVOGE') THEN
        CALL MDDEVO(NBPAS,DT,NBMODE,ZR(JPULS),ZR(JPUL2),ZR(JMASG),
     &              ZR(JRAIG),LAMOR,ZR(JAMOG),TYPBAS,BASEMO,TINIT,
     &              ZI(JARCH),NBSAUV,NBNLI,ZI(JRANC),ZR(JDEPL),
     &              ZR(JPARC),ZK8(JNOEC),NBREDE,ZR(JREDE),ZR(JPARD),
     &              ZK8(JFOND),NBREVI,ZR(JREVI),ZK8(JFONV),ZR(JDEPS),
     &              ZR(JVITS),ZR(JACCS),ZI(JORDR),ZR(JINST),ZR(JFCHO),
     &              ZR(JDCHO),ZR(JVCHO),ZI(JICHO),ZI(JREDC),ZR(JREDD),
     &              ZR(JCOEFM),ZI(JIADVE),ZI(JINUMO),ZI(JIDESC),
     &              ZK8(JNODEP),ZK8(JNOVIT),ZK8(JNOACC),ZK8(JNOMFO),
     &              ZR(JPSID),MONMOT,NOMRES)
       ENDIF
C     --- IMPRESSION DES RESULTATS DE CHOC DANS TOUS LES CAS 
C     --- SAUF ITMI POUR ITMI ON IMPRIME DANS MDITM2
      IF (METHOD.NE.'ITMI' .AND. NBNLI.NE.0) THEN
CCC      IF (NBNLI.NE.0) THEN
        CALL MDICHO(NOMRES,NBSAUV,ZR(JINST),ZR(JFCHO),ZR(JDCHO),
     &              ZR(JVCHO),NBNLI,NBCHOC,NBSISM,ZR(JPARC),ZK8(JNOEC))
      END IF
      IF (METHOD.EQ.'ITMI') THEN

C        --- CONDITIONS INITIALES ---

        CALL WKVECT('&&MDITMI.DEPL_0','V V R8',NBMODE,JDEP0)
        CALL WKVECT('&&MDITMI.VITE_0','V V R8',NBMODE,JVIT0)
        CALL MDINIT(NOMBM,NBMODE,0,ZR(JDEP0),ZR(JVIT0),R8B,IRET)
        IF (IRET.NE.0) GO TO 120

C --- 1.4.NOMBRE DE POINTS DE DISCRETISATION DU TUBE
C
      CALL JEVEUO ( BASEMO//'           .REFE' , 'L', KREF )
      MASSE = ZK24(KREF  )
      CALL MTDSCR ( MASSE )
C
      CALL DISMOI('F','NOM_MAILLA'  ,MASSE,'MATR_ASSE',IBID,MAILLA,IRE)
C        --- RECUPERATION DU NOMBRE DE NOEUDS DU MAILLAGE
C
      NOMNOE = MAILLA//'.NOMNOE'
      CALL JELIRA(NOMNOE,'NOMUTI',LNOE,K1BID)
      INDIC = LNOE

        CALL MDITM1(NBMODE,NBMD,NBMP,NBNLI,INDIC,NBF,INFO,ITRANS,
     &              EPS,ICOUPL,TYPFLU,ZI(IVECI1),ZL(JLOCF),DT,TFEXM,TS,
     &              IPARCH,NEXCIT,ZK8(JNOMFO),ZI(JINUMO),ZR(JMASG),
     &              ZR(JAMO1),ZR(JPULS),ZR(IVECR3),ZR(JDEPL),ZR(JPARC),
     &              ZK8(JNOEC),ZK8(JINTI),ZR(IVECR5),ZR(IVECR1),
     &              ZR(IVECR2),VGAP,ZR(IVECR4),NBCHOC,ZR(JDEP0),
     &              ZR(JVIT0),ZR(JAMOG),NBSAUV)
      END IF

  120 CONTINUE
      CALL JEDETC('V','&&',1)
      IF (IRET.NE.0) CALL UTMESS('F',NOMCMD,'DONNEES ERRONEES.')

      CALL JEDEMA()
      END

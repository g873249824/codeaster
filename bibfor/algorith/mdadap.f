      SUBROUTINE MDADAP (DTI,DTMAX,NEQGEN,PULSAT,PULSA2,
     &                   MASGEN,DESCM,RIGGEN,DESCR,LAMOR,AMOGEN,
     &                   DESCA,TYPBAS,BASEMO,TINIT,TFIN,DTARCH,NBSAUV,
     &                   ITEMAX,PREC,XLAMBD,LFLU,
     &                   NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &                   NBREDE,DPLRED,PARRED,FONRED,
     &                   NBREVI,DPLREV,FONREV,
     &                   DEPSTO,VITSTO,ACCSTO,PASSTO,IORSTO,TEMSTO,
     &                   FCHOST,DCHOST,VCHOST, ICHOST,
     &                   IREDST,DREDST,
     &                   COEFM,LIAD,INUMOR,IDESCF,
     &                   NOFDEP,NOFVIT,NOFACC,NOMFON,PSIDEL,MONMOT,
     &                   NBPAL,DTSTO,TCF,VROTAT,PRDEFF,METHOD,
     &                   NOMRES)
C
      IMPLICIT     REAL*8 (A-H,O-Z)
C
      INTEGER      IORSTO(*),IREDST(*),ITEMAX,DESCM,DESCR,DESCA,
     &             LOGCHO(NBCHOC,*),ICHOST(*)
      REAL*8       PULSAT(*),PULSA2(*),MASGEN(*),RIGGEN(*),AMOGEN(*),
     &             PARCHO(*),PARRED(*),DEPSTO(*),VITSTO(*),ACCSTO(*),
     &             PASSTO(*),TEMSTO(*),FCHOST(*),DCHOST(*),VCHOST(*),
     &             DREDST(*),PREC,EPSI,DPLMOD(NBCHOC,NEQGEN,*),
     &             DPLREV(*),DPLRED(*)
      REAL*8       DTI,DTMAX
      REAL*8       DT,DTSTO,TCF,VROTAT
      CHARACTER*8  BASEMO,NOECHO(NBCHOC,*),FONRED(*),FONREV(*),VVAR
      CHARACTER*8  NOMRES,MONMOT
      CHARACTER*16 TYPBAS,METHOD
      LOGICAL      LAMOR,LFLU,LPSTO,PRDEFF
C
      REAL*8       COEFM(*),PSIDEL(*)
      INTEGER      LIAD(*),INUMOR(*),IDESCF(*)
      INTEGER      NBPAL,IBID
      CHARACTER*8  NOFDEP(*),NOFVIT(*),NOFACC(*),NOMFON(*)
C
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/05/2011   AUTEUR NISTOR I.NISTOR 
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C TOLE CRP_4 CRP_20 CRP_21 CRS_512
C
C     DIFFERENCES CENTREES AVEC PAS ADAPTATIF
C     ------------------------------------------------------------------
C IN  : DTI    : PAS DE TEMPS INITIAL (ET MAXIMUM)
C IN  : NEQGEN : NOMBRE DE MODES
C IN  : PULSAT : PULSATIONS MODALES
C IN  : PULSA2 : PULSATIONS MODALES AU CARREES
C IN  : MASGEN : MASSES GENERALISEES ( TYPBAS = 'MODE_MECA' )
C                MATRICE DE MASSE GENERALISEE ( TYPBAS = 'BASE_MODA' )
C IN  : DESCM  : DESCRIPTEUR DE LA MATRICE DE MASSE
C IN  : RIGGEN : RAIDEURS GENERALISES ( TYPBAS = 'MODE_MECA' )
C                MATRICE DE RAIDEUR GENERALISE ( TYPBAS = 'BASE_MODA' )
C IN  : DESCR  : DESCRIPTEUR DE LA MATRICE DE RIGIDITE
C IN  : LAMOR  : AMORTISSEMENT SOUS FORME D'UNE LISTE DE REELS
C IN  : AMOGEN : AMORTISSEMENTS REDUITS ( LAMOR = .TRUE. )
C                MATRICE D'AMORTISSEMENT ( LAMOR = .FALSE. )
C IN  : DESCA  : DESCRIPTEUR DE LA MATRICE D'AMORTISSEMENT
C IN  : TYPBAS : TYPE DE LA BASE ('MODE_MECA' 'BASE_MODA' 'MODELE_GENE')
C IN  : BASEMO : NOM K8 DE LA BASE MODALE DE PROJECTION
C IN  : TINIT  : TEMPS INITIAL
C IN  : TFIN   : TEMPS FINAL
C IN  : DTARCH : PAS D'ARCHIVAGE
C IN  : NBSAUV : NOMBRE DE PAS ARCHIVES
C IN  : ITEMAX : NOMBRE D'ITERATIONS MAXIMUM POUR TROUVER L'ACCELERATION
C IN  : PREC   : RESIDU RELATIF POUR TESTER LA CONVERGENCE DE L'ACCE.
C IN  : XLAMBD : MULTIPLICATEUR POUR RENDRE CONTRACTANTES LES ITERATIONS
C IN  : LFLU   : LOGIQUE INDIQUANT LA PRESENCE DE FORCES DE LAME FLUIDE
C IN  : NBCHOC : NOMBRE DE NOEUDS DE CHOC
C IN  : LOGCHO : INDICATEUR D'ADHERENCE ET DE FORCE FLUIDE
C IN  : DPLMOD : TABLEAU DES DEPL MODAUX AUX NOEUDS DE CHOC
C IN  : PARCHO : TABLEAU DES PARAMETRES DE CHOC
C IN  : NOECHO : TABLEAU DES NOMS DES NOEUDS DE CHOC
C IN  : NBREDE : NOMBRE DE RELATION EFFORT DEPLACEMENT (RED)
C IN  : DPLRED : TABLEAU DES DEPLACEMENTS MODAUX AUX NOEUDS DE RED
C IN  : PARRED : TABLEAU DES PARAMETRES DE RED
C IN  : FONRED : TABLEAU DES FONCTIONS AUX NOEUDS DE RED
C IN  : NBREVI : NOMBRE DE RELATION EFFORT VITESSE (REV)
C IN  : DPLREV : TABLEAU DES DEPLACEMENTS MODAUX AUX NOEUDS DE REV
C IN  : FONREV : TABLEAU DES FONCTIONS AUX NOEUDS DE REV
C IN  : LIAD   : LISTE DES ADRESSES DES VECTEURS CHARGEMENT
C IN  : NOFDEP : NOM DE LA FONCTION DEPL_IMPO
C IN  : NOFVIT : NOM DE LA FONCTION VITE_IMPO
C IN  : PSIDEL : TABLEAU DE VALEURS DE PSI*DELTA
C IN  : MONMOT : = OUI SI MULTI-APPUIS
C ----------------------------------------------------------------------
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16             ZK16
      CHARACTER*24                      ZK24
      CHARACTER*32                               ZK32
      CHARACTER*80                                        ZK80
      COMMON  /KVARJE/ ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C
C     ----- FIN COMMUNS NORMALISES  JEVEUX  ----------------------------
C
      REAL*8        TPS1(4)
      REAL*8        VALR(3), CONV,RINT1,RINT2, VALR2(2)
      INTEGER       VALI(2)
      CHARACTER*8   TRAN
      CHARACTER*19  MAMASS,SOLVEU,MATPRE
C
      INTEGER       II
      INTEGER       PALMAX
      PARAMETER (PALMAX=20)
      INTEGER       IADRK,IAPP, ETAUSR
      INTEGER       DIMNAS
      PARAMETER     (DIMNAS=8)  
      CHARACTER*3   FINPAL(PALMAX)
      CHARACTER*6   TYPAL(PALMAX)
      CHARACTER*8   CNPAL(PALMAX)
      CHARACTER*24  CPAL
C
      CALL JEMARQ()
C            
      ZERO = 0.D0
      DEUX = 2.D0
      JCHOR = 1
      JREDR = 1
      JREDI = 1
      JVINT = 1
      IPAS  = 0
      ISTO1 = 0
      ISTO2 = 0
      ISTO3 = 0
      NPAS  = 0
      NBACC = 0
      CONV = 1.D0
      II = 1
      LPSTO = .TRUE.
      NBMOD1 = NEQGEN - 1
      NBSCHO = NBSAUV * 3 * NBCHOC
      EPSI = R8PREM()
      DO 111 IAPP = 1,PALMAX
        TYPAL(IAPP)='      '
        FINPAL(IAPP)='   '
        CNPAL(IAPP)=' '
 111  CONTINUE
C
      IF ( LAMOR ) THEN
        DO 100 IM = 1,NEQGEN
          AMOGEN(IM) = DEUX * AMOGEN(IM) * PULSAT(IM)
 100    CONTINUE
      ENDIF
C
C     --- RECUPERATION DES PARAMETRES D'ADAPTATION DU PAS
C
      CALL WKVECT('&&MDADAP.VMIN','V V R8',NEQGEN,JVMIN)
      CALL RECPAR(NEQGEN,DTI,DTMAX,ZR(JVMIN),VVAR,CMP,CDP,
     &            DTMIN,NPER,NRMAX)
C
C     --- FACTORISATION DE LA MATRICE MASSE ---
C
      IF (TYPBAS.EQ.'BASE_MODA') THEN
        CALL WKVECT('&&MDADAP.MASS','V V R8',NEQGEN*NEQGEN,JMASS)
        CALL DCOPY(NEQGEN*NEQGEN,MASGEN,1,ZR(JMASS),1)
        CALL TRLDS(ZR(JMASS),NEQGEN,NEQGEN,IRET)
        IF (IRET.NE.0) THEN
          CALL U2MESS('F','ALGORITH5_22')
        ENDIF
        CALL DCOPY(NEQGEN*NEQGEN,MASGEN,1,ZR(JMASS),1)
      ELSEIF (TYPBAS.EQ.'MODELE_GENE     ') THEN
        MAMASS=ZK24(ZI(DESCM+1))
        CALL DISMOI('F','SOLVEUR',MAMASS,'MATR_ASSE',IBID,
     &              SOLVEU,IBID)
        CALL ASSERT(SOLVEU.EQ.'&&OP0074.SOLVEUR')
        MATPRE='&&OP0074.BIDON'
C
C       ISTOP MIS A 1 POUR NE PAS ARRETER L'EXECUTION EN CAS
C       DE MATRICE SINGULIERE (MODES STATIQUES)
        CALL JEVEUO(SOLVEU//'.SLVI','E',JSLVI)
        ISTOAV=ZI(JSLVI-1+3)
        ZI(JSLVI-1+3)=1
        CALL PRERES(SOLVEU,'V',IRET,MATPRE,MAMASS,IBID,-9999)
C       -- ON RETABLIT ISTOP
        ZI(JSLVI-1+3)=ISTOAV
      ELSE
        CALL WKVECT('&&MDADAP.MASS','V V R8',NEQGEN,JMASS)
        CALL DCOPY(NEQGEN,MASGEN,1,ZR(JMASS),1)
        IF (NBCHOC.NE.0) THEN
         IF (LFLU) THEN
C
C        CALCUL DE LA MATRICE DIAGONALE POUR LES NOEUDS DE LAME FLUIDE
C
         CALL WKVECT('&&MDADAP.PHI2','V V R8',NEQGEN*NBCHOC,JPHI2)
C
C        CALCUL DES MATRICES M' PAR NOEUD DE CHOC FLUIDE
C
          DO 51 ICHO = 1,NBCHOC
          DO 51 IM = 1,NEQGEN
            ZR(JPHI2+IM-1+(ICHO-1)*NEQGEN) = 0.D0
            IF (LOGCHO(ICHO,2).EQ.1) THEN
              IF (NOECHO(ICHO,9)(1:2) .EQ. 'BI') THEN
                DO 52 JM = 1,3
                  XX = DPLMOD(ICHO,IM,JM) - DPLMOD(ICHO,IM,JM+3)
                  ZR(JPHI2+IM-1+(ICHO-1)*NEQGEN) =
     &            ZR(JPHI2+IM-1+(ICHO-1)*NEQGEN) +
     &            XLAMBD*XX**2
 52             CONTINUE
              ELSE
                DO 50 JM = 1,3
                  ZR(JPHI2+IM-1+(ICHO-1)*NEQGEN) =
     &            ZR(JPHI2+IM-1+(ICHO-1)*NEQGEN) +
     &            XLAMBD*DPLMOD(ICHO,IM,JM)**2
 50             CONTINUE
              ENDIF
            ENDIF
 51       CONTINUE
         ENDIF
        ENDIF
      ENDIF
C
C     --- VECTEURS DE TRAVAIL ---
C
      CALL WKVECT('&&MDADAP.DEPL','V V R8',NEQGEN,JDEPL)
      CALL WKVECT('&&MDADAP.DEP2','V V R8',NEQGEN,JDEP2)
      CALL WKVECT('&&MDADAP.VITE','V V R8',NEQGEN,JVITE)
      CALL WKVECT('&&MDADAP.VIT2','V V R8',NEQGEN,JVIT2)
      CALL WKVECT('&&MDADAP.VIP1','V V R8',NEQGEN,JVIP1)
      CALL WKVECT('&&MDADAP.VIP2','V V R8',NEQGEN,JVIP2)
      CALL WKVECT('&&MDADAP.ACCE','V V R8',NEQGEN,JACCE)
      CALL WKVECT('&&MDADAP.ACC2','V V R8',NEQGEN,JACC2)
      CALL WKVECT('&&MDADAP.TRA1','V V R8',NEQGEN,JTRA1)
      CALL WKVECT('&&MDADAP.FEXT','V V R8',NEQGEN,JFEXT)
      IF (LFLU) THEN
        CALL WKVECT('&&MDADAP.FEXTI','V V R8',NEQGEN,JFEXTI)
        CALL WKVECT('&&MDADAP.ACCGEN1','V V R8',NEQGEN,JACGI1)
        CALL WKVECT('&&MDADAP.ACCGEN2','V V R8',NEQGEN,JACGI2)
        CALL WKVECT('&&MDADAP.PULSAI','V V R8',NEQGEN,JPULS)
        CALL WKVECT('&&MDADAP.AMOGEI','V V R8',NEQGEN,JAMOGI)
        CALL DCOPY(NEQGEN,PULSA2,1,ZR(JPULS),1)
        CALL DCOPY(NEQGEN,AMOGEN,1,ZR(JAMOGI),1)
      ENDIF
      IF (NBCHOC.NE.0 .AND. NBPAL.EQ.0 ) THEN
         CALL WKVECT('&&MDADAP.SCHOR','V V R8',NBCHOC*14,JCHOR)
         CALL WKVECT('&&MDADAP.SCHO2','V V R8',NBCHOC*14,JCHO2)
C        INITIALISATION POUR LE FLAMBAGE
         CALL JEVEUO(NOMRES//'           .VINT','E',JVINT)
         CALL R8INIR(NBCHOC,0.D0,ZR(JVINT),1)
      ENDIF
      IF (NBREDE.NE.0) THEN
         CALL WKVECT('&&MDADAP.SREDR','V V R8',NBREDE,JREDR)
         CALL WKVECT('&&MDADAP.SREDI','V V I' ,NBREDE,JREDI)
      ENDIF
C
C     --- CONDITIONS INITIALES ---
C
      CALL MDINIT(BASEMO,NEQGEN,NBCHOC,ZR(JDEPL),ZR(JVITE),
     &            ZR(JVINT),IRET,TINIT)
      IF (IRET.NE.0) GOTO 9999
      CALL DCOPY(NEQGEN,ZR(JVITE),1,ZR(JVIP1),1)
      DT2 = DTI
      DT1 = ZERO
      IF (NBCHOC.GT.0.AND.NBPAL.EQ.0) THEN
         CALL DCOPY(NBCHOC,ZR(JVINT),1,ZR(JCHOR+13*NBCHOC),1)
      ENDIF
C
C     --- FORCES EXTERIEURES ---
C
      CALL GETFAC('EXCIT',NBEXCI)
      IF (NBEXCI.NE.0) THEN
         CALL MDFEX2 (TINIT,NEQGEN,NBEXCI,IDESCF,NOMFON,COEFM,LIAD,
     &                INUMOR,ZR(JFEXT))
      ENDIF
C
C    COUPLAGE AVEC EDYOS
C
      IF (NBPAL .GT. 0 ) THEN
        CPAL='C_PAL'
C     RECUPERATION DES DONNEES SUR LES PALIERS 
C     -------------------------------------------------     
        CALL JEVEUO(CPAL,'L',IADRK)
        DO 21 IAPP=1,NBPAL
          TYPAL(IAPP)=ZK8(IADRK+(IAPP-1))(1:6)
          FINPAL(IAPP)=ZK8(IADRK+(IAPP-1)+PALMAX)(1:3)
          CNPAL(IAPP)=ZK8(IADRK+(IAPP-1)+2*PALMAX)(1:DIMNAS)
  21    CONTINUE
      ENDIF
      IF (NBPAL.NE.0) NBCHOC = 0
C
C    FIN COUPLAGE AVEC EDYOS
C
      IF (LFLU) THEN
C
C     --- CONTRIBUTION DES FORCES NON LINEAIRES ---
C         CAS DES FORCES DE LAME FLUIDE
C
        CALL MDFNLI(NEQGEN,ZR(JDEPL),ZR(JVITE),
     &            ZR(JACCE),ZR(JFEXT),ZR(JMASS),ZR(JPHI2),
     &            ZR(JPULS),ZR(JAMOGI),
     &            NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,ZR(JCHOR),
     &            NBREDE,DPLRED,PARRED,FONRED,ZR(JREDR),ZI(JREDI),
     &            NBREVI,DPLREV,FONREV,
     &            TINIT,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT,
     &            1,0,DT,DTSTO,TCF,VROTAT,
     &            TYPAL, FINPAL,CNPAL,PRDEFF,CONV)
        IF(CONV.LE.0.D0) CALL U2MESS('I','EDYOS_47')
C
C     --- ACCELERATIONS GENERALISEES INITIALES ---
C
        CALL MDACCE(TYPBAS,NEQGEN,ZR(JPULS),ZR(JMASS),DESCM,
     &              RIGGEN,DESCR,ZR(JFEXT),LAMOR,ZR(JAMOGI),DESCA,
     &              ZR(JTRA1),ZR(JDEPL),ZR(JVITE),ZR(JACCE))
      ELSE
C
C       CAS CLASSIQUE
C
        CALL MDFNLI(NEQGEN,ZR(JDEPL),ZR(JVITE),
     &            ZR(JACCE),ZR(JFEXT),MASGEN,R8BID1,
     &            PULSA2,AMOGEN,
     &            NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,ZR(JCHOR),
     &            NBREDE,DPLRED,PARRED,FONRED,ZR(JREDR),ZI(JREDI),
     &            NBREVI,DPLREV,FONREV,
     &            TINIT,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT,
     &            1,NBPAL,DT2,DTSTO,TCF,VROTAT,
     &            TYPAL, FINPAL,CNPAL,PRDEFF,CONV)
        IF(CONV.LE.0.D0) CALL U2MESS('I','EDYOS_47')
    
C
C     --- ACCELERATIONS GENERALISEES INITIALES ---
C
        CALL MDACCE(TYPBAS,NEQGEN,PULSA2,MASGEN,DESCM,RIGGEN,
     &              DESCR,ZR(JFEXT),LAMOR,AMOGEN,DESCA,ZR(JTRA1),
     &              ZR(JDEPL),ZR(JVITE),ZR(JACCE))
C
      ENDIF
C
C     --- ARCHIVAGE DONNEES INITIALES ---
C
      TARCHI = TINIT
      CALL MDARCH(ISTO1,0,TINIT,DT2,NEQGEN,
     &            ZR(JDEPL),ZR(JVITE),ZR(JACCE),
     &            ISTO2,NBCHOC,ZR(JCHOR),NBSCHO, ISTO3,NBREDE,ZR(JREDR),
     &            ZI(JREDI), DEPSTO,VITSTO,ACCSTO,PASSTO,LPSTO,IORSTO,
     &            TEMSTO,FCHOST,DCHOST,VCHOST, ICHOST,
     &            ZR(JVINT),IREDST,DREDST )
C
      TEMPS = TINIT
      TCF = TEMPS + DT2
      TARCH = TINIT+ DTARCH
      CALL UTTCPU('CPU.MDADAP','INIT',' ')
      IVERI = 0
      NBPASC = 1
C
C     --- BOUCLE TEMPORELLE ---
C
 30   CONTINUE
      IF(TEMPS .LT. TFIN) THEN
C       DO 30 WHILE(TEMPS .LT. TFIN)
C
         IF (IVERI.EQ.0) THEN
           CALL UTTCPU('CPU.MDADAP', 'DEBUT',' ')
         ELSE
           IF (MOD(IVERI,NBPASC).EQ.0) THEN
             CALL UTTCPU('CPU.MDADAP', 'DEBUT',' ')
           ENDIF
         ENDIF
C
         ERR = 100.D0
         NR = 0
C        --- DERNIER PAS DE TEMPS ? ---
C
         IF(TEMPS+DT2 .GT. TFIN) DT2 = TFIN-TEMPS
C         DO 29 WHILE(ERR .GT. 1. .AND. NR .LT. NRMAX)
 29      CONTINUE
         IF(ERR .GT. 1.D0 .AND. NR .LT. NRMAX) THEN
C
            PAS1 = (DT1+DT2)*0.5D0
            PAS2 = DT2*0.5D0
C  MODIFICATION POUR ADAPT ORDRE1
            IF ((DT1.LE.1.D-13).AND.(METHOD.EQ.'ADAPT_ORDRE1')) PAS1=DT2
C
            DO 40 IM = 0,NBMOD1
C              --- VITESSES GENERALISEES ---
               ZR(JVIT2+IM) = ZR(JVITE+IM) + ZR(JACCE+IM) * PAS1
C              --- DEPLACEMENTS GENERALISES ---
               ZR(JDEP2+IM) = ZR(JDEPL+IM) + ( DT2 * ZR(JVIT2+IM) )
C              --- PREDICTEUR DE LA VITESSE ---
               IF (METHOD .EQ. 'ADAPT_ORDRE2') THEN
                 ZR(JVIP2+IM) = ZR(JVIT2+IM) + PAS2 * ZR(JACCE+IM)
               ELSE
C  MODIFICATION POUR ADAPT ORDRE1
                 ZR(JVIP2+IM) = ZR(JVIT2+IM)
               ENDIF
 40         CONTINUE
C
C
C        --- FORCES EXTERIEURES ---
C
         DO 20 IF = 0,NEQGEN-1
            ZR(JFEXT+IF) = ZERO
 20      CONTINUE
         IF (NBEXCI.NE.0) THEN
            R8VAL = TEMPS+DT2
            CALL MDFEX2(R8VAL,NEQGEN,NBEXCI,IDESCF,NOMFON,COEFM,LIAD,
     &                  INUMOR,ZR(JFEXT))
         ENDIF
C
         IF (LFLU) THEN
C           ------------------------------------------------------
C           ITERATIONS IMPLICITES POUR OBTENIR L'ACCELERATION DANS
C           LE CAS DE FORCE DE LAME FLUIDE
C           ------------------------------------------------------
            XNORM = 0.D0
            XREF = 0.D0
            CALL DCOPY(NEQGEN,ZR(JACCE),1,ZR(JACGI1),1)
            NBACC = NBACC + 1
            R8VAL = TEMPS + DT2
            DO 5 ITER=1,ITEMAX
C
C             REMISE A JOUR DE LA MASSE, PULSATION CARRE
C             DE L'AMORTISSEMENT MODAL ET DE LA FORCE EXT
C
              CALL DCOPY(NEQGEN,MASGEN,1,ZR(JMASS),1)
              CALL DCOPY(NEQGEN,PULSA2,1,ZR(JPULS),1)
              CALL DCOPY(NEQGEN,AMOGEN,1,ZR(JAMOGI),1)
              CALL DCOPY(NEQGEN,ZR(JFEXT),1,ZR(JFEXTI),1)
C
C           --- CONTRIBUTION DES FORCES NON LINEAIRES ---
C
              II = II + 1
              CALL MDFNLI(NEQGEN,ZR(JDEP2),ZR(JVIP2),
     &                  ZR(JACGI1),ZR(JFEXTI),ZR(JMASS),ZR(JPHI2),
     &                  ZR(JPULS),ZR(JAMOGI),
     &                  NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &                  ZR(JCHO2), NBREDE,DPLRED,PARRED,FONRED,
     &                  ZR(JREDR),ZI(JREDI), NBREVI,DPLREV,FONREV,
     &                  R8VAL,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT,
     &                  II,NBPAL,DT2,DTSTO,TCF,
     &                  VROTAT,TYPAL, FINPAL,CNPAL,PRDEFF,CONV)
              IF(CONV.LE.0.D0) CALL U2MESS('I','EDYOS_47')
     
C
C           --- ACCELERATIONS GENERALISEES ---
C
              CALL MDACCE(TYPBAS,NEQGEN,ZR(JPULS),ZR(JMASS),
     &                    DESCM,RIGGEN,DESCR,ZR(JFEXTI),LAMOR,
     &                    ZR(JAMOGI),DESCA,ZR(JTRA1),ZR(JDEP2),
     &                    ZR(JVIP2),ZR(JACGI2))
              XNORM = 0.D0
              XREF = 0.D0
              DO 15 IM =1,NEQGEN
                 XNORM = XNORM + (ZR(JACGI2+IM-1)-ZR(JACGI1+IM-1))**2
                 XREF = XREF + ZR(JACGI2+IM-1)**2
 15           CONTINUE
              CALL DCOPY(NEQGEN,ZR(JACGI2),1,ZR(JACGI1),1)
C             TEST DE CONVERGENCE
              IF (XNORM.LE.PREC*XREF) GOTO 25
 5          CONTINUE
C
C           NON CONVERGENCE
C
            VALI (1) = ITEMAX
            VALR (1) = XNORM/XREF
            VALR (2) = TEMPS
            CALL U2MESG('F','ALGORITH15_99',0,' ',1,VALI,2,VALR)
C
 25         CONTINUE
            CALL DCOPY(NEQGEN,ZR(JACGI2),1,ZR(JACC2),1)
C
            ELSE
C
C             CALCUL CLASSIQUE FORCES NON-LINEAIRES ET ACCELERATIONS
C
C
C             --- CONTRIBUTION DES FORCES NON LINEAIRES ---
C
              R8VAL = TEMPS + DT2
              II = II + 1
              CALL MDFNLI(NEQGEN,ZR(JDEP2),ZR(JVIP2),
     &                  ZR(JACCE),ZR(JFEXT),R8BID2,R8BID3,R8BID4,
     &                  R8BID5,NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &                  ZR(JCHO2), NBREDE,DPLRED,PARRED,FONRED,
     &                  ZR(JREDR),ZI(JREDI), NBREVI,DPLREV,FONREV,
     &                  R8VAL,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT,
     &                  II,NBPAL,DT2,DTSTO,TCF,
     &                  VROTAT,TYPAL, FINPAL,CNPAL,PRDEFF,CONV)
              IF(CONV.LE.0.D0) CALL U2MESS('I','EDYOS_47')
     
C
C             --- ACCELERATIONS GENERALISEES ---
C
              NBACC = NBACC + 1
              CALL MDACCE(TYPBAS,NEQGEN,PULSA2,MASGEN,DESCM,
     &                    RIGGEN,DESCR,ZR(JFEXT),LAMOR,AMOGEN,
     &                    DESCA,ZR(JTRA1),ZR(JDEP2),ZR(JVIP2),
     &                    ZR(JACC2))
C
            ENDIF
C
C           --- CALCUL DE L'ERREUR ---
C
             CALL FRQAPP(DT2,NEQGEN,ZR(JDEPL),ZR(JDEP2),
     &              ZR(JACCE),ZR(JACC2),ZR(JVMIN),FREQ)
             ERR = NPER * FREQ * DT2
C
C           --- REDUCTION DU PAS DE TEMPS ---
C
            IF((ERR .GT. 1.D0).OR.(CONV .LE. 0.D0)) DT2 = DT2/CDP
            IF (DT2.LE.DTMIN .AND. ABS(TFIN-(TEMPS+DT2)).GT.EPSI) THEN
              CALL U2MESS('F','ALGORITH5_23')
            ENDIF
C
            NR = NR + 1
C 29         CONTINUE
C           LES DEUX LIGNES SUIVANTES SIMULENT LE WHILE - CONTINUE
            GOTO 29
            ENDIF
            IF (ERR .GT. 1.D0 .AND. NR .EQ. NRMAX) THEN
              VALR2(1) = TEMPS
              VALR2(2) = DT
              CALL U2MESG('A','DYNAMIQUE_18',0,' ',1,NR,2,VALR2)
            ENDIF
C
            DT1 = DT2
            TEMP2 = TEMPS + DT2
            TCF = TEMP2 + DT2
C
C           --- AUGMENTATION DU PAS SI ERREUR TROP FAIBLE ---
C
            IF((ERR .LT. 0.75D0) .AND. (CONV .GT. 0.D0)) THEN
              IF(NPAS .EQ. 5) THEN
                DT2 = CMP*DT2
                DT2 = MIN(DT2,DTMAX)
                NPAS = 4
              ENDIF
              NPAS = NPAS + 1
            ELSE
                NPAS = 0
            ENDIF
            IF(TEMPS+DT2 .GT. TFIN) DT2 = TFIN-TEMPS
C
            IPAS  = IPAS + 1
C
C           --- ARCHIVAGE ---
C
            IF(TEMPS .LE. TARCH .AND. TEMP2 .GE. TARCH) THEN
              ISTO1 = ISTO1+1
              IF((TEMP2-TARCH).LE.(TARCH-TEMPS)) THEN
                TARCHI = TEMP2
                CALL MDARCH(ISTO1,IPAS,TEMP2,DT2,NEQGEN,
     &                     ZR(JDEP2),ZR(JVIP2),ZR(JACC2),ISTO2,
     &                     NBCHOC,ZR(JCHO2),NBSCHO,
     &                     ISTO3,NBREDE,ZR(JREDR),ZI(JREDI),
     &                     DEPSTO,VITSTO,ACCSTO,PASSTO,LPSTO,IORSTO,
     &                     TEMSTO,FCHOST,DCHOST,VCHOST, ICHOST,
     &                     ZR(JVINT),IREDST,DREDST )
              ELSE
                TARCHI = TEMPS
                CALL MDARCH(ISTO1,IPAS-1,TEMPS,DT2,NEQGEN,
     &                     ZR(JDEPL),ZR(JVIP1),ZR(JACCE),ISTO2,
     &                     NBCHOC,ZR(JCHOR),NBSCHO,
     &                     ISTO3,NBREDE,ZR(JREDR),ZI(JREDI),
     &                     DEPSTO,VITSTO,ACCSTO,PASSTO,LPSTO,IORSTO,
     &                     TEMSTO,FCHOST,DCHOST,VCHOST, ICHOST,
     &                     ZR(JVINT),IREDST,DREDST )
              ENDIF
                TARCH = TARCH + DTARCH
            ENDIF
C
C           --- CALCUL DE VMIN ---
C
            IF(VVAR(1:4) .EQ. 'NORM') THEN
              TMP = ZERO
              DO 28 IV = 0,NBMOD1
                 TMP = TMP+ZR(JVIT2+IV)**2
 28           CONTINUE
              TMP = SQRT(TMP)*0.01D0
              DO 27 IV = 0,NBMOD1
                 ZR(JVMIN+IV) = TMP
 27           CONTINUE
            ELSEIF(VVAR(1:4) .EQ. 'MAXI') THEN
              DO 26 IV = 0,NBMOD1
              RINT1 = ZR(JVIT2+IV)*0.01D0
              RINT2 = ABS(RINT1)
              RINT1 = ZR(JVMIN+IV)
              ZR(JVMIN+IV) = MAX(RINT1,RINT2)
 26           CONTINUE
            ENDIF
C
C           --- MISE A JOUR ---
C
            TEMPS = TEMP2
            CALL DCOPY(NEQGEN,ZR(JDEP2),1,ZR(JDEPL),1)
            CALL DCOPY(NEQGEN,ZR(JVIT2),1,ZR(JVITE),1)
            CALL DCOPY(NEQGEN,ZR(JVIP2),1,ZR(JVIP1),1)
            CALL DCOPY(NEQGEN,ZR(JACC2),1,ZR(JACCE),1)
            IF (NBCHOC.NE.0) CALL DCOPY(14 ,ZR(JCHO2),1,ZR(JCHOR),1)
C
C        --- TEST SI LE TEMPS RESTANT EST SUFFISANT POUR CONTINUER ---
C       ON FIXE UN TEMPS MOYEN PAR PAS A UN MINIMUM DE 0.001 S
C       ACTIF POUR LA VERSION SOLARIS
C
          TINF = 1.D9
          RINT1 = 1.D-3
          IF (IVERI.EQ.0) THEN
            CALL UTTCPU('CPU.MDADAP', 'FIN',' ')
            CALL UTTCPR('CPU.MDADAP',4, TPS1)
            TJOB = MIN(TINF,TPS1(1))
            TMOY = MAX(TPS1(4),RINT1)
            NBPASC = INT(1.D-02 * (TJOB/TMOY)) + 1
          ELSE
            IF (MOD(IVERI,NBPASC).EQ.0) THEN
              CALL UTTCPU('CPU.MDADAP', 'FIN',' ')
              CALL UTTCPR('CPU.MDADAP',4, TPS1)
              TJOB = MIN(TINF,TPS1(1))
              IF (TPS1(1).LE.MAX(TJOB/100.D0,15.D0)) THEN
               GOTO 31
              ENDIF
              TMOY = MAX(TPS1(4),RINT1)
              NBPASC = INT(1.D-02 * (TJOB/TMOY)) + 1
            ENDIF
          ENDIF
          IVERI = IVERI + 1
C
          GOTO 30
          ENDIF
C 30      CONTINUE
C
 31   CONTINUE
C
      IF(NBSAUV .GT. (ISTO1+1)) THEN
        ISTO1 = ISTO1 + 1
            TARCHI = TEMPS
            CALL MDARCH(ISTO1,IPAS,TEMPS,DT2,NEQGEN,ZR(JDEP2),ZR(JVIP2),
     &                     ZR(JACC2), ISTO2,NBCHOC,ZR(JCHOR),NBSCHO,
     &                     ISTO3,NBREDE,ZR(JREDR),ZI(JREDI),
     &                     DEPSTO,VITSTO,ACCSTO,PASSTO,LPSTO,IORSTO,
     &                     TEMSTO,FCHOST,DCHOST,VCHOST, ICHOST,
     &                     ZR(JVINT),IREDST,DREDST )
      GOTO 31
      ENDIF
C
      VALI (1) = IPAS
      VALI (2) = NBACC
      CALL U2MESG('I','ALGORITH16_1',0,' ',2,VALI,0,0.D0)
C
C --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
C
      IF ( ETAUSR().EQ.1 ) THEN
         CALL SIGUSR()
      ENDIF
C
      IF (TPS1(1).LE.MAX(TJOB/100.D0,15.D0)) THEN
        IF (NOMRES.EQ.'&&OP0074') THEN
C       --- CAS D'UNE POURSUITE ---
           CALL GETVID('ETAT_INIT','RESULTAT',1,1,1,TRAN,NDT)
           IF (NDT.NE.0) CALL RESU74(TRAN,NOMRES)
        ENDIF
        CALL MDSIZE (NOMRES,ISTO1,NEQGEN,LPSTO,NBCHOC,NBREDE)
                VALI (1) = IPAS
                VALI (2) = ISTO1
                VALR (1) = TARCHI
                VALR (2) = TPS1(4)
                VALR (3) = TPS1(1)
                CALL UTEXCM(28,'ALGORITH16_77',0,' ',2,VALI,3,VALR)
      ENDIF
C
 9999 CONTINUE
      CALL JEDETR('&&MDADAP.DEPL')
      CALL JEDETR('&&MDADAP.DEP2')
      CALL JEDETR('&&MDADAP.VITE')
      CALL JEDETR('&&MDADAP.VIT2')
      CALL JEDETR('&&MDADAP.VIP1')
      CALL JEDETR('&&MDADAP.VIP2')
      CALL JEDETR('&&MDADAP.ACCE')
      CALL JEDETR('&&MDADAP.ACC2')
      CALL JEDETR('&&MDADAP.TRA1')
      CALL JEDETR('&&MDADAP.FEXT')
      CALL JEDETR('&&MDADAP.MASS')
      CALL JEDETR('&&MDADAP.VMIN')
      IF (LFLU) THEN
         CALL JEDETR('&&MDADAP.FEXTI')
         CALL JEDETR('&&MDADAP.ACCGEN1')
         CALL JEDETR('&&MDADAP.ACCGEN2')
         CALL JEDETR('&&MDADAP.PULSAI')
         CALL JEDETR('&&MDADAP.AMOGEI')
         CALL JEDETR('&&MDADAP.PHI2')
      ENDIF
      IF (NBCHOC.NE.0) THEN
         CALL JEDETR('&&MDADAP.SCHOR')
         CALL JEDETR('&&MDADAP.SCHO2')
      ENDIF
      IF (NBREDE.NE.0) THEN
         CALL JEDETR('&&MDADAP.SREDR')
         CALL JEDETR('&&MDADAP.SREDI')
      ENDIF
      IF (IRET.NE.0)
     &   CALL U2MESS('F','ALGORITH5_24')
C
      CALL JEDEMA()
      END

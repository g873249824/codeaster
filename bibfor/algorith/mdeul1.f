      SUBROUTINE MDEUL1 (NBPAS,DT,NEQGEN,PULSAT,PULSA2,
     &                   MASGEN,DESCMM,RIGGEN,DESCMR,RGYGEN,LAMOR,
     &                   AMOGEN,DESCMA,GYOGEN,FONCV,FONCA,
     &                   TYPBAS,BASEMO,TINIT,IPARCH,NBSAUV,
     &                   ITEMAX,PREC,XLAMBD,LFLU,
     &                   NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &                   NBREDE,DPLRED,PARRED,FONRED,
     &                   NBREVI,DPLREV,FONREV,
     &                   DEPSTO,VITSTO,ACCSTO,IORSTO,TEMSTO,
     &                   FCHOST,DCHOST,VCHOST,ICHOST,
     &                   IREDST,DREDST,
     &                   COEFM,LIAD,INUMOR,IDESCF,
     &                   NOFDEP,NOFVIT,NOFACC,NOMFON,PSIDEL,MONMOT,
     &                   NBRFIS,FK,DFK,ANGINI,FONCP,
     &                   NBPAL,DTSTO,TCF,VROTAT,PRDEFF,
     &                   NOMRES,NBEXCI)
C
      IMPLICIT NONE
C
      INCLUDE 'jeveux.h'
      INTEGER      IORSTO(*),IREDST(*),ITEMAX,DESCMM,DESCMR,DESCMA,
     &             IPARCH(*),LOGCHO(NBCHOC,*),ICHOST(*),IBID
      REAL*8       PULSAT(*),PULSA2(*),MASGEN(*),RIGGEN(*),AMOGEN(*),
     &             GYOGEN(*),RGYGEN(*),
     &             PARCHO(*),PARRED(*),DEPSTO(*),VITSTO(*),ACCSTO(*),
     &             TEMSTO(*),FCHOST(*),DCHOST(*),VCHOST(*),DREDST(*),
     &             PREC,RBID,DPLMOD(NBCHOC,NEQGEN,*),
     &             DPLRED(*),DPLREV(*)
      REAL*8       DT,DTSTO,TCF,VROTAT,ANGINI
      CHARACTER*8  BASEMO,NOECHO(NBCHOC,*),FONRED(*),FONREV(*)
      CHARACTER*8  NOMRES,MONMOT
      CHARACTER*16 TYPBAS
      LOGICAL      LAMOR,LFLU,LPSTO,PRDEFF
C
      REAL*8       COEFM(*),PSIDEL(*)
      INTEGER      LIAD(*),INUMOR(*),IDESCF(*)
      INTEGER      NBPAL,NBRFIS
      CHARACTER*8  NOFDEP(*),NOFVIT(*),NOFACC(*),NOMFON(*)
      CHARACTER*8  FK(2),DFK(2),FONCV,FONCA,FONCP
C
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 07/08/2012   AUTEUR TORKHANI M.TORKHANI 
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
C TOLE CRP_4 CRP_20 CRP_21 CRS_512
C
C     ALGORITHME EULER D'ORDRE 1 OPTION LAME FLUIDE
C     ------------------------------------------------------------------
C IN  : NBPAS  : NOMBRE DE PAS
C IN  : DT     : PAS DE TEMPS
C IN  : NEQGEN : NOMBRE DE MODES
C IN  : PULSAT : PULSATIONS MODALES
C IN  : PULSA2 : PULSATIONS MODALES AU CARREES
C IN  : MASGEN : MASSES GENERALISEES ( TYPBAS = 'MODE_MECA' )
C                MATRICE DE MASSE GENERALISEE ( TYPBAS = 'BASE_MODA' )
C IN  : DESCMM : DESCRIPTEUR DE LA MATRICE DE MASSE
C IN  : RIGGEN : RAIDEURS GENERALISES ( TYPBAS = 'MODE_MECA' )
C                MATRICE DE RAIDEUR GENERALISE ( TYPBAS = 'BASE_MODA' )
C IN  : DESCMR : DESCRIPTEUR DE LA MATRICE DE RIGIDITE
C IN  : LAMOR  : AMORTISSEMENT SOUS FORME D'UNE LISTE DE REELS
C IN  : AMOGEN : AMORTISSEMENTS REDUITS ( LAMOR = .TRUE. )
C                MATRICE D'AMORTISSEMENT ( LAMOR = .FALSE. )
C IN  : DESCMA : DESCRIPTEUR DE LA MATRICE D'AMORTISSEMENT
C IN  : TYPBAS : TYPE DE LA BASE ('MODE_MECA' 'BASE_MODA' 'MODELE_GENE')
C IN  : BASEMO : NOM K8 DE LA BASE MODALE DE PROJECTION SI C'EST UN
C                MODE MECA K8BID LORS D'UN CALCUL PAR SOUS_STUCTURATION
C IN  : TINIT  : TEMPS INITIAL
C IN  : IPARCH : VECTEUR DES PAS D'ARCHIVAGE
C IN  : NBSAUV : NOMBRE DE PAS ARCHIVE
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
C IN  : NBEXCI : NBRE D'EXCITATIONS (SOUS LE MC EXCIT ET EXCIT_RESU)
C ----------------------------------------------------------------------
C
C
C
C
      REAL*8       TPS1(4), RINT1, RINT2, CONV
      REAL*8       VALR(3)
      INTEGER      VALI(2), NBCONV, NBMXCV, N1
      CHARACTER*8  TRAN, K8B
      CHARACTER*19 MATPRE, MATASM
C     ------------------------------------------------------------------
      INTEGER       ETAUSR
C
      INTEGER       PALMAX
C-----------------------------------------------------------------------
      INTEGER I ,IARCHI ,ICHO ,IF ,IM ,IRET, ISTO1, IER, IND 
      INTEGER ISTO2 ,ISTO3 ,ITER ,JACCE ,JACCGI ,JAMOGI ,JCHOR 
      INTEGER JDEPL ,JFEXT ,JFEXTI ,JM ,JMASS ,JPHI2 ,JPULS 
      INTEGER JREDI ,JREDR ,JTRA1 ,JVINT ,JVITE ,N100 ,NBCHOC 
      INTEGER NBEXCI ,NBMOD1 ,NBPAS ,NBREDE ,NBREVI ,NBSAUV ,NBSCHO 
      INTEGER NDT ,NEQGEN, JAMGY, JRIGY
      REAL*8 DEUX ,R8BID1 ,R8BID2 ,R8BID3 ,R8BID4 ,R8BID5 ,TARCHI 
      REAL*8 TEMPS ,TINIT ,XLAMBD ,XNORM ,XREF ,XX ,ZERO 

C-----------------------------------------------------------------------
      PARAMETER (PALMAX=20)
      INTEGER       IADRK,IAPP
      INTEGER       DIMNAS
      PARAMETER     (DIMNAS=8)  
      CHARACTER*3   FINPAL(PALMAX)
      CHARACTER*6   TYPAL(PALMAX)
      CHARACTER*8   CNPAL(PALMAX)
      CHARACTER*24  CPAL
      INTEGER       IARG
      REAL*8        FSAUV(PALMAX,3),VROT,AROT,VROTIN,AROTIN
C
C
      CALL JEMARQ()
      ZERO = 0.D0
      RBID = ZERO
      DEUX = 2.D0
      JCHOR = 1
      JREDR = 1
      JREDI = 1
      JVINT = 1
      ISTO1 = 0
      ISTO2 = 0
      ISTO3 = 0
      LPSTO = .FALSE.
      NBMOD1 = NEQGEN - 1
      NBSCHO = NBSAUV * 3 * NBCHOC
C  COUPLAGE EDYOS : CONVERGENCE EDYOS :
      CONV = 1.D0
      NBCONV = 0
C  COUPLAGE EDYOS : NOMBRE MAXIMAL DE TENTATIVES DE REPRISE DES DONNEES
C  PRECEDENTES EN CAS DE NON-CONVERGENCE EDYOS :
      NBMXCV = 10
      
      DO 111 IAPP = 1,PALMAX
        TYPAL(IAPP)='      '
        FINPAL(IAPP)='   '
        CNPAL(IAPP)=' '
 111   CONTINUE
C
      CALL WKVECT('&&MDNEWM.AMOGYR','V V R8',NEQGEN*NEQGEN,JAMGY)
      CALL WKVECT('&&MDNEWM.RIGGYR','V V R8',NEQGEN*NEQGEN,JRIGY)
      IF ( LAMOR ) THEN
        DO 100 IM = 1,NEQGEN
          AMOGEN(IM) = DEUX * AMOGEN(IM) * PULSAT(IM)
 100    CONTINUE
      ELSE
        CALL GETVTX(' ','VITESSE_VARIABLE',1,IARG,1,K8B,N1)
        VROTIN = 0.D0
        AROTIN = 0.D0
        IF (K8B.EQ.'OUI') THEN
          CALL FOINTE('F ',FONCV,1,'INST',TINIT,VROTIN,IER)
          CALL FOINTE('F ',FONCA,1,'INST',TINIT,AROTIN,IER)
          DO 113 IM = 1 , NEQGEN
            DO 114 JM = 1 , NEQGEN
              IND = JM + NEQGEN*(IM-1)
              ZR(JAMGY+IND-1) = AMOGEN(IND) + VROTIN * GYOGEN(IND)
              ZR(JRIGY+IND-1) = RIGGEN(IND) + AROTIN * RGYGEN(IND)
 114        CONTINUE
 113      CONTINUE
        ELSE
          DO 117 IM = 1 , NEQGEN
            DO 118 JM = 1 , NEQGEN
              IND = JM + NEQGEN*(IM-1)
              ZR(JAMGY+IND-1) = AMOGEN(IND)
              ZR(JRIGY+IND-1) = RIGGEN(IND)
 118        CONTINUE
 117      CONTINUE
        ENDIF
      ENDIF
C
C     --- FACTORISATION DE LA MATRICE MASSE ---
C
      IF (TYPBAS.EQ.'BASE_MODA') THEN
        CALL WKVECT('&&MDEUL1.MASS','V V R8',NEQGEN*NEQGEN,JMASS)
        CALL DCOPY(NEQGEN*NEQGEN,MASGEN,1,ZR(JMASS),1)
        CALL TRLDS(ZR(JMASS),NEQGEN,NEQGEN,IRET)
        IF (IRET.NE.0) THEN
          CALL U2MESS('F','ALGORITH5_22')
        ENDIF
        CALL DCOPY(NEQGEN*NEQGEN,MASGEN,1,ZR(JMASS),1)
      ELSEIF (TYPBAS.EQ.'MODELE_GENE     ') THEN
        MATPRE='&&MDEUL1.MATPRE'
        MATASM=ZK24(ZI(DESCMM+1))
        CALL PRERES(' ','V',IRET,MATPRE,MATASM,IBID,-9999)
      ELSE
        CALL WKVECT('&&MDEUL1.MASS','V V R8',NEQGEN,JMASS)
        CALL DCOPY(NEQGEN,MASGEN,1,ZR(JMASS),1)
        IF (NBCHOC.NE.0) THEN
         IF (LFLU) THEN
C
C     CALCUL DE LA MATRICE DIAGONALE POUR LES NOEUDS DE LAME FLUIDE
C
          CALL WKVECT('&&MDEUL1.PHI2','V V R8',NEQGEN*NBCHOC,JPHI2)
C
C     CALCUL DES MATRICES M' PAR NOEUD DE CHOC FLUIDE
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
      CALL WKVECT('&&MDEUL1.DEPL','V V R8',NEQGEN,JDEPL)
      CALL WKVECT('&&MDEUL1.VITE','V V R8',NEQGEN,JVITE)
      CALL WKVECT('&&MDEUL1.ACCE','V V R8',NEQGEN,JACCE)
      CALL WKVECT('&&MDEUL1.TRA1','V V R8',NEQGEN,JTRA1)
      CALL WKVECT('&&MDEUL1.FEXT','V V R8',NEQGEN,JFEXT)
      IF (LFLU) THEN
        CALL WKVECT('&&MDEUL1.FEXTI','V V R8',NEQGEN,JFEXTI)
        CALL WKVECT('&&MDEUL1.ACCGENI','V V R8',NEQGEN,JACCGI)
        CALL WKVECT('&&MDEUL1.PULSAI','V V R8',NEQGEN,JPULS)
        CALL WKVECT('&&MDEUL1.AMOGEI','V V R8',NEQGEN,JAMOGI)
        CALL DCOPY(NEQGEN,PULSA2,1,ZR(JPULS),1)
        CALL DCOPY(NEQGEN,AMOGEN,1,ZR(JAMOGI),1)
      ENDIF
      IF (NBCHOC.NE.0 .AND. NBPAL.EQ.0 ) THEN
C      IF (NBCHOC.NE.0  ) THEN
         CALL WKVECT('&&MDEUL1.SCHOR','V V R8',NBCHOC*14,JCHOR)
C        INITIALISATION POUR LE FLAMBAGE
         CALL JEVEUO(NOMRES//'           .VINT','E',JVINT)
         CALL R8INIR(NBCHOC,0.D0,ZR(JVINT),1)
      ENDIF
      IF (NBREDE.NE.0) THEN
         CALL WKVECT('&&MDEUL1.SREDR','V V R8',NBREDE,JREDR)
         CALL WKVECT('&&MDEUL1.SREDI','V V I' ,NBREDE,JREDI)
      ENDIF
C
C     --- CONDITIONS INITIALES ---
C
      CALL MDINIT(BASEMO,NEQGEN,NBCHOC,ZR(JDEPL),ZR(JVITE),ZR(JVINT),
     &            IRET, TINIT)
      IF (IRET.NE.0) GOTO 9999
      IF (NBCHOC.GT.0.AND.NBPAL.EQ.0) THEN
         CALL DCOPY(NBCHOC,ZR(JVINT),1,ZR(JCHOR+13*NBCHOC),1)
      ENDIF
C
C     --- FORCES EXTERIEURES ---
C
      IF (NBEXCI.NE.0) THEN
         CALL MDFEXT (TINIT,R8BID1,NEQGEN,NBEXCI,IDESCF,NOMFON,COEFM,
     &                LIAD,INUMOR,1,ZR(JFEXT))
      ENDIF

      IF (LFLU) THEN


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
     &            NBRFIS,FK,DFK,ANGINI,FONCP,
     &            1,0,DT,DTSTO,TCF,VROTAT,
     &            TYPAL, FINPAL,CNPAL,PRDEFF,CONV,FSAUV)
        IF ((CONV.LE.0.D0) .AND. (NBCONV.GT.NBMXCV)) THEN
          CALL U2MESS('F','EDYOS_46')
        ELSEIF ((CONV.LE.0.D0) .AND. (NBCONV.LE.NBMXCV)) THEN
          NBCONV = NBCONV + 1
        ENDIF

C
C     --- ACCELERATIONS GENERALISEES INITIALES ---
C
        CALL MDACCE(TYPBAS,NEQGEN,ZR(JPULS),ZR(JMASS),DESCMM,
     &              RIGGEN,DESCMR,ZR(JFEXT),LAMOR,ZR(JAMOGI),DESCMA,
     &              ZR(JTRA1),ZR(JDEPL),ZR(JVITE),ZR(JACCE))
      ELSE
C
C   COUPLAGE AVEC EDYOS
C
        IF (NBPAL .GT. 0 ) THEN
          CPAL='C_PAL'
C     RECUPERATION DES DONNEES SUR LES PALIERS 
C     -------------------------------------------------     
          CALL JEVEUO(CPAL,'L',IADRK)
          DO 21 IAPP=1,NBPAL
            FSAUV(IAPP,1)= 0.D0
            FSAUV(IAPP,2)= 0.D0
            FSAUV(IAPP,3)= 0.D0
            TYPAL(IAPP)=ZK8(IADRK+(IAPP-1))(1:6)
            FINPAL(IAPP)=ZK8(IADRK+(IAPP-1)+PALMAX)(1:3)
            CNPAL(IAPP)=ZK8(IADRK+(IAPP-1)+2*PALMAX)(1:DIMNAS)
  21      CONTINUE
        ENDIF
C  FIN COUPLAGE AVEC EDYOS
C
C       CAS CLASSIQUE
C
        IF (NBPAL.NE.0) NBCHOC = 0
        CALL MDFNLI(NEQGEN,ZR(JDEPL),ZR(JVITE),
     &            ZR(JACCE),ZR(JFEXT),MASGEN,R8BID1,
     &            PULSA2,ZR(JAMGY),
     &            NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,ZR(JCHOR),
     &            NBREDE,DPLRED,PARRED,FONRED,ZR(JREDR),ZI(JREDI),
     &            NBREVI,DPLREV,FONREV,
     &            TINIT,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT,
     &            NBRFIS,FK,DFK,ANGINI,FONCP,
     &            1,NBPAL,DT,DTSTO,TCF,VROTAT,
     &            TYPAL, FINPAL,CNPAL,PRDEFF,CONV,FSAUV)
        IF ((CONV.LE.0.D0) .AND. (NBCONV.GT.NBMXCV)) THEN
          CALL U2MESS('F','EDYOS_46')
        ELSEIF ((CONV.LE.0.D0) .AND. (NBCONV.LE.NBMXCV)) THEN
          NBCONV = NBCONV + 1
        ENDIF

C
C     --- ACCELERATIONS GENERALISEES INITIALES ---
C
        CALL MDACCE(TYPBAS,NEQGEN,PULSA2,MASGEN,DESCMM,RIGGEN,
     &              DESCMR,ZR(JFEXT),LAMOR,ZR(JAMGY),DESCMA,ZR(JTRA1),
     &              ZR(JDEPL),ZR(JVITE),ZR(JACCE))
C
      ENDIF
C
C     --- ARCHIVAGE DONNEES INITIALES ---
C
      TARCHI = TINIT
      CALL MDARCH(ISTO1,0,TINIT,RBID,NEQGEN,ZR(JDEPL),ZR(JVITE),
     &            ZR(JACCE),
     &           ISTO2,NBCHOC,ZR(JCHOR),NBSCHO, ISTO3,NBREDE,ZR(JREDR),
     &            ZI(JREDI), DEPSTO,VITSTO,ACCSTO,RBID,LPSTO,IORSTO,
     &            TEMSTO,FCHOST,DCHOST,VCHOST,ICHOST,
     &            ZR(JVINT),IREDST,DREDST )
C
      TEMPS = TINIT + DT
      TCF = TEMPS
      CALL UTTCPU('CPU.MDEUL1','INIT',' ')
      N100 = NBPAS/100 + 1
C
C     --- BOUCLE TEMPORELLE ---
C
      DO 30 I = 1 , NBPAS
C
         IF (MOD(I,N100).EQ.0) CALL UTTCPU('CPU.MDEUL1','DEBUT',' ')
C
         VROT = 0.D0
         AROT = 0.D0
         IF (K8B.EQ.'OUI') THEN
           CALL FOINTE('F ',FONCV,1,'INST',TEMPS,VROT,IER)
           CALL FOINTE('F ',FONCA,1,'INST',TEMPS,AROT,IER)
           DO 115 IM = 1 , NEQGEN
             DO 116 JM = 1 , NEQGEN
               IND = JM + NEQGEN*(IM-1)
               ZR(JAMGY+IND-1) = AMOGEN(IND) + VROT * GYOGEN(IND)
               ZR(JRIGY+IND-1) = RIGGEN(IND) + AROT * RGYGEN(IND)
 116         CONTINUE
 115       CONTINUE
         ELSE
           DO 119 IM = 1 , NEQGEN
             DO 120 JM = 1 , NEQGEN
               IND = JM + NEQGEN*(IM-1)
               ZR(JAMGY+IND-1) = AMOGEN(IND)
               ZR(JRIGY+IND-1) = RIGGEN(IND)
 120         CONTINUE
 119       CONTINUE
         ENDIF
         DO 40 IM = 0,NBMOD1
C           --- VITESSES GENERALISEES ---
            ZR(JVITE+IM) = ZR(JVITE+IM) + ( DT * ZR(JACCE+IM) )
C           --- DEPLACEMENTS GENERALISES ---
            ZR(JDEPL+IM) = ZR(JDEPL+IM) + ( DT * ZR(JVITE+IM) )
 40      CONTINUE
C
C        --- FORCES EXTERIEURES ---
C
         DO 20 IF = 0,NEQGEN-1
            ZR(JFEXT+IF) = ZERO
 20      CONTINUE
         IF (NBEXCI.NE.0) THEN
            CALL MDFEXT(TEMPS,R8BID1,NEQGEN,NBEXCI,IDESCF,NOMFON,COEFM,
     &                  LIAD,INUMOR,1,ZR(JFEXT))
         ENDIF
C
         IF (LFLU) THEN
C        ------------------------------------------------------
C        ITERATIONS IMPLICITES POUR OBTENIR L'ACCELERATION DANS
C        LE CAS DE FORCE DE LAME FLUIDE
C        ------------------------------------------------------
         XNORM = 0.D0
         XREF = 0.D0
         DO 5 ITER=1,ITEMAX
C
C           REMISE A JOUR DE LA MASSE, PULSATION CARRE
C           DE L'AMORTISSEMENT MODAL ET DE LA FORCE EXT
C
            CALL DCOPY(NEQGEN,MASGEN,1,ZR(JMASS),1)
            CALL DCOPY(NEQGEN,PULSA2,1,ZR(JPULS),1)
            CALL DCOPY(NEQGEN,AMOGEN,1,ZR(JAMOGI),1)
            CALL DCOPY(NEQGEN,ZR(JFEXT),1,ZR(JFEXTI),1)
C
C         --- CONTRIBUTION DES FORCES NON LINEAIRES ---
C
            CALL MDFNLI(NEQGEN,ZR(JDEPL),ZR(JVITE),
     &                  ZR(JACCE),ZR(JFEXTI),ZR(JMASS),ZR(JPHI2),
     &                  ZR(JPULS),ZR(JAMOGI),
     &                  NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &                  ZR(JCHOR), NBREDE,DPLRED,PARRED,FONRED,
     &                  ZR(JREDR),ZI(JREDI),NBREVI,DPLREV,FONREV,
     &                  TEMPS,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT,
     &                  NBRFIS,FK,DFK,ANGINI,FONCP,
     &                  (I+1),NBPAL,DT,DTSTO,TCF,VROTAT,
     &                  TYPAL, FINPAL,CNPAL,PRDEFF,CONV,FSAUV)
            IF ((CONV.LE.0.D0) .AND. (NBCONV.GT.NBMXCV)) THEN
              CALL U2MESS('F','EDYOS_46')
            ELSEIF ((CONV.LE.0.D0) .AND. (NBCONV.LE.NBMXCV)) THEN
              NBCONV = NBCONV + 1
            ENDIF
C
C           --- ACCELERATIONS GENERALISEES ---
C
            CALL MDACCE(TYPBAS,NEQGEN,ZR(JPULS),ZR(JMASS),
     &                    DESCMM,RIGGEN,DESCMR,ZR(JFEXTI),LAMOR,
     &                    ZR(JAMOGI),DESCMA,ZR(JTRA1),ZR(JDEPL),
     &                    ZR(JVITE),ZR(JACCGI))
            XNORM = 0.D0
            XREF = 0.D0
            DO 15 IM =1,NEQGEN
               XNORM = XNORM + (ZR(JACCGI+IM-1)-ZR(JACCE+IM-1))**2
               XREF = XREF + ZR(JACCGI+IM-1)**2
 15         CONTINUE
            CALL DCOPY(NEQGEN,ZR(JACCGI),1,ZR(JACCE),1)
C           TEST DE CONVERGENCE
            IF (XNORM.LE.PREC*XREF) GOTO 25
 5       CONTINUE
C
C        NON CONVERGENCE
C
         VALI (1) = ITEMAX
         VALR (1) = XNORM/XREF
         CALL U2MESG('F','ALGORITH16_11',0,' ',1,VALI,1,VALR)
C
 25      CONTINUE
         ELSE
C
C        CALCUL CLASSIQUE FORCES NON-LINEAIRES ET ACCELERATIONS
C
C
C        --- CONTRIBUTION DES FORCES NON LINEAIRES ---
C
         CALL MDFNLI(NEQGEN,ZR(JDEPL),ZR(JVITE),
     &               ZR(JACCE),ZR(JFEXT),R8BID2,R8BID3,R8BID4,
     &               R8BID5,NBCHOC,LOGCHO,DPLMOD,PARCHO,NOECHO,
     &               ZR(JCHOR), NBREDE,DPLRED,PARRED,FONRED,
     &               ZR(JREDR),ZI(JREDI),NBREVI,DPLREV,FONREV,
     &               TEMPS,NOFDEP,NOFVIT,NOFACC,NBEXCI,PSIDEL,MONMOT,
     &               NBRFIS,FK,DFK,ANGINI,FONCP,
     &               (I+1),NBPAL,DT,DTSTO,TCF,VROTAT,
     &               TYPAL, FINPAL,CNPAL,PRDEFF,CONV,FSAUV)
         IF ((CONV.LE.0.D0) .AND. (NBCONV.GT.NBMXCV)) THEN
           CALL U2MESS('F','EDYOS_46')
         ELSEIF ((CONV.LE.0.D0) .AND. (NBCONV.LE.NBMXCV)) THEN
           NBCONV = NBCONV + 1
         ENDIF
C
C        --- ACCELERATIONS GENERALISEES ---
C
         CALL MDACCE(TYPBAS,NEQGEN,PULSA2,MASGEN,DESCMM,
     &               RIGGEN,DESCMR,ZR(JFEXT),LAMOR,ZR(JAMGY),
     &               DESCMA,ZR(JTRA1),ZR(JDEPL),ZR(JVITE),
     &               ZR(JACCE))
C
         ENDIF
C
C        --- ARCHIVAGE ---
C
         IF (IPARCH(I) .EQ. 1) THEN
            IARCHI = I
            TARCHI = TEMPS
            ISTO1 = ISTO1 + 1
            CALL MDARCH(ISTO1,IARCHI,TEMPS,RBID,NEQGEN,ZR(JDEPL),
     &                  ZR(JVITE),ZR(JACCE),ISTO2,NBCHOC,ZR(JCHOR),
     &                  NBSCHO,ISTO3,NBREDE,ZR(JREDR),ZI(JREDI),
     &                  DEPSTO,VITSTO,ACCSTO,RBID,LPSTO,IORSTO,
     &                  TEMSTO,FCHOST,DCHOST,VCHOST,ICHOST,
     &                  ZR(JVINT),IREDST,DREDST)
         ENDIF
C
C        --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1 ---
C
         IF ( ETAUSR().EQ.1 ) THEN
            CALL SIGUSR()
         ENDIF
C
C        --- TEST SI LE TEMPS RESTANT EST SUFFISANT POUR CONTINUER ---
C
         IF (MOD(I,N100).EQ.0) THEN
         CALL UTTCPU('CPU.MDEUL1','FIN',' ')
         CALL UTTCPR('CPU.MDEUL1',4,TPS1)
          RINT1 = 5.D0
          RINT2 = 0.90D0
          IF (MAX(RINT1,N100*TPS1(4)).GT.(RINT2*TPS1(1))) THEN
           CALL MDSIZE (NOMRES,ISTO1,NEQGEN,LPSTO,NBCHOC,NBREDE)
           IF (NOMRES.EQ.'&&OP0074') THEN
C          --- CAS D'UNE POURSUITE ---
              CALL GETVID('ETAT_INIT','RESULTAT',1,IARG,1,TRAN,NDT)
              IF (NDT.NE.0) CALL RESU74(TRAN,NOMRES)
           ENDIF
              VALI (1) = I
              VALI (2) = ISTO1
              VALR (1) = TARCHI
              VALR (2) = TPS1(4)
              VALR (3) = TPS1(1)
              CALL UTEXCM(28,'ALGORITH16_77',0,' ',2,VALI,3,VALR)
           GOTO 9999
          ENDIF
         ENDIF
         TEMPS = TEMPS + DT
         TCF = TEMPS
 30   CONTINUE
C
 9999 CONTINUE
      CALL JEDETR('&&MDEUL1.DEPL')
      CALL JEDETR('&&MDEUL1.VITE')
      CALL JEDETR('&&MDEUL1.ACCE')
      CALL JEDETR('&&MDEUL1.TRA1')
      CALL JEDETR('&&MDEUL1.FEXT')
      CALL JEDETR('&&MDEUL1.MASS')
      IF (LFLU) THEN
        CALL JEDETR('&&MDEUL1.FEXTI')
        CALL JEDETR('&&MDEUL1.ACCGENI')
        CALL JEDETR('&&MDEUL1.PULSAI')
        CALL JEDETR('&&MDEUL1.AMOGEI')
        CALL JEDETR('&&MDEUL1.PHI2')
      ENDIF
      IF (NBCHOC.NE.0) CALL JEDETR('&&MDEUL1.SCHOR')
      IF (NBREDE.NE.0) THEN
         CALL JEDETR('&&MDEUL1.SREDR')
         CALL JEDETR('&&MDEUL1.SREDI')
      ENDIF
      IF (IRET.NE.0)
     &   CALL U2MESS('F','ALGORITH5_24')
C
      CALL JEDEMA()
      END

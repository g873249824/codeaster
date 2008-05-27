      SUBROUTINE OP0045(IER)
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 26/05/2008   AUTEUR BOITEAU O.BOITEAU 
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
C TOLE CRP_20
C        MODE_ITER_SIMULT
C        RECHERCHE DE MODES PAR ITERATION SIMULTANEE EN SOUS-ESPACE 
C        (LANCZOS, JACOBI OU IRA-ARPACK) OU METHODE DE TYPE QR (LAPACK)
C-----------------------------------------------------------------------
C        - POUR LE PROBLEME GENERALISE AUX VALEURS PROPRES :
C                         2
C                        L (M) Y  + (K) Y = 0
C
C          LES MATRICES (C) ET (M) SONT REELLES SYMETRIQUES
C          LA MATRICE (K) EST REELLE OU COMPLEXE SYMETRIQUE
C          LES VALEURS PROPRES ET DES VECTEURS PROPRES SONT REELS
C
C        - POUR LE PROBLEME QUADRATIQUE AUX VALEURS PROPRES :
C                         2
C                        L (M) Y  + L (C) Y + (K) Y = 0
C
C          LES MATRICES (C) ET (M) SONT REELLES SYMETRIQUES
C          LA MATRICE (K) EST REELLE OU COMPLEXE SYMETRIQUE
C          LES VALEURS PROPRES ET DES VECTEURS PROPRES SONT REELS OU
C          COMPLEXES CONJUGUEES OU NON
C-----------------------------------------------------------------------
C
      IMPLICIT NONE

C PARAMETRES D'APPELS
      INTEGER IER

C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8  ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

C VARIABLES LOCALES
      INTEGER       NBPARI, NBPARR, NBPARK, NBPARA, MXDDL
      PARAMETER    ( NBPARI=8 , NBPARR=16 , NBPARK=2, NBPARA=26 )
      PARAMETER    ( MXDDL=1 )
      INTEGER      INDF,ISNNEM,IADX,IMET,I,IADY,IEQ,IERX,IRET,
     &             IADRB,IADZ,IER1,IFM,ITEMAX,IADRH,IBID,IERD,IFREQ
      INTEGER      LMAT(3),LSELEC,LRESID,LDSOR,LAMOR,LBRSS,LMASSE,
     &             LMTPSC,LRESUR,LTYPRI,LWORKD,LAUX,LRAIDE,LSIGN,LVALPR,
     &             LWORKL,LBORCR,LDIAGR,LPR,LRESUI,LSURDR,LVEC,LWORKV,
     &             L,LBORFR,LMF,LPROD,LRESUK,LTYPRE,LXRIG,KQRNR,
     &             LDDL,LMATRA,LONWL,LMET,ITYP,IORDRE,NBVEC2,ICOEF
      INTEGER      NPIVOT,NBVECT,PRIRAM(8),MAXITR,NEQACT,MFREQ,
     &             NBORTO,NFREQ,NITV,NPARR,NBCINE,NEQ,NITQRM,
     &             NBRSS,NITBAT,NIV,NNCRIT,MXRESF,NBLAGR,NPERM,
     &             NITJAC,NNFREQ,NPREC,N1,NSTOC,NCONV,IEXIN,LWORKR,LAUR,
     &             QRN,QRLWOR,IQRN,LQRN,QRAR,QRAI,QRBA,QRVL,KQRN,
     &             QRN2,ILSCAL,IRSCAL,LAUC,LAUL,IHCOL,IADIA,IFIN,
     &             IDEB,J,JBID
      REAL*8       PRORTO,OMEGA2,FMIN,FMAX,RAUX,ALPHA,TOLSOR,
     &             UNDF,R8VIDE,FREQOM,R8PREM,OMEMIN,OMEMAX,OMESHI,
     &             OMECOR,FCORIG,PRECDC,SEUIL,VPINF,PRECSH,TOL,VPMAX,
     &             PRSUDG,RBID,TOLDYN
      COMPLEX*16   SIGMA,CBID
      CHARACTER*1  CTYP,APPR,KTYP,KBID
      CHARACTER*8  MODES,KNEGA,METHOD,ARRET,K8BID
      CHARACTER*16 MODRIG,TYPCON,NOMCMD,OPTIOF,OPTIOV,TYPRES,TYPEQZ
      CHARACTER*19 MASSE,RAIDE,AMOR,MATPSC,MATOPA,VECRIG,NUMEDD
      CHARACTER*24 CBORFR,CBORCR,VALK(2),NOPARA(NBPARA)
      CHARACTER*32 JEXNUM
      LOGICAL      STURM,FLAGE,LQZ,LKR,LC,LTESTQ

C     ------------------------------------------------------------------
      DATA CBORFR / '&&OP0045.BORNE.FREQ.USR ' /
      DATA CBORCR / '&&OP0045.BORNE.CRIT.USR ' /
      DATA  NOPARA /
     &  'NUME_MODE'       , 'ITER_QR'         , 'ITER_BATHE'      ,
     &  'ITER_ARNO'       , 'ITER_JACOBI'     , 'ITER_SEPARE'     ,
     &  'ITER_AJUSTE'     , 'ITER_INVERSE'    ,
     &  'NORME'           , 'METHODE'         ,
     &  'FREQ'            ,
     &  'OMEGA2'          , 'AMOR_REDUIT'     , 'ERREUR'          ,
     &  'MASS_GENE'       , 'RIGI_GENE'       , 'AMOR_GENE'       ,
     &  'MASS_EFFE_DX'    , 'MASS_EFFE_DY'    , 'MASS_EFFE_DZ'    ,
     &  'FACT_PARTICI_DX' , 'FACT_PARTICI_DY' , 'FACT_PARTICI_DZ' ,
     &  'MASS_EFFE_UN_DX' , 'MASS_EFFE_UN_DY' , 'MASS_EFFE_UN_DZ' /
C     ------------------------------------------------------------------

C     ------------------------------------------------------------------
C     -------  LECTURE DES DONNEES  ET PREMIERES VERIFICATION   --------
C     ------------------------------------------------------------------

      CALL JEMARQ()
C ---- TEST POUR VALIDER LE QUADRATIQUE INFORMATIQUEMENT
      LTESTQ=.FALSE.
C      LTESTQ=.TRUE.
      FLAGE = .FALSE.
      NCONV = 0
      UNDF = R8VIDE()
      INDF = ISNNEM()
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
      IF (NIV.EQ.2) THEN
        PRIRAM(1) = 2
        PRIRAM(2) = 2
        PRIRAM(3) = 2
        PRIRAM(4) = 2
        PRIRAM(5) = 0
        PRIRAM(6) = 0
        PRIRAM(7) = 0
        PRIRAM(8) = 2
      ELSE
        DO 5 I = 1,8
          PRIRAM(I) = 0
   5    CONTINUE
      ENDIF
      
C     --- RECUPERATION DU RESULTAT  ---
      CALL GETRES(MODES,TYPCON,NOMCMD)
      
C     --- RECUPERATION DES ARGUMENTS MATRICIELS ---
      CALL GETVID(' ','MATR_A',1,1,1,RAIDE,L)
      CALL GETVID(' ','MATR_B',1,1,1,MASSE,L)
      AMOR = ' '
      CALL GETVID(' ','MATR_C',1,1,1,AMOR,LAMOR)
      IF (LAMOR.EQ.0) THEN
        LC=.FALSE.
      ELSE
        LC=.TRUE.
      ENDIF
      
C     --- TEST DU TYPE (COMPLEXE OU REELLE) DE LA MATRICE DE RAIDEUR ---
      IF (IER.EQ.0) CALL JELIRA(RAIDE//'.VALM','TYPE',IBID,KTYP)
      IF (KTYP.EQ.'R') THEN
        LKR=.TRUE.
      ELSE IF (KTYP.EQ.'C') THEN
        LKR=.FALSE.
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
            
C     --- METHODE DE RESOLUTION CHOISIE ---
C     METHOD : 'TRI_DIAG','JACOBI' OU 'SORENSEN' OU 'QZ'
      CALL GETVTX(' ','METHODE',1,1,1,METHOD,LMET)
      IF (METHOD(1:2).EQ.'QZ') THEN
        LQZ=.TRUE.
      ELSE
        LQZ=.FALSE.
      ENDIF
C     --- TYPE DE CALCUL : DYNAMIQUE OU FLAMBEMENT ---
C     TYPE_RESU : 'DYNAMIQUE' OU 'FLAMBEMENT'
      CALL GETVTX(' ','TYPE_RESU',1,1,1,TYPRES,LTYPRE)

C     --- DETECTION DES MODES DE CORPS RIGIDE ---
C     MODRIG : 'MODE_RIGIDE' OU 'SANS'
      CALL GETVTX(' ','OPTION',1,1,1,MODRIG,LTYPRI)

C     --- OPTION DEMANDEE : BANDE OU PLUS_PETITE OU CENTRE OU TOUT ---
C     OPTIOF : 'BANDE' OU 'CENTRE' OU 'PLUS_PETITE' OU 'TOUT'
      CALL GETVTX('CALC_FREQ','OPTION',1,1,1,OPTIOF,LMF)

C     --- RECUPERATION DES ARGUMENTS CONCERNANT LA FACTORISATION ---
      CALL GETVIS('CALC_FREQ','NPREC_SOLVEUR',1,1,1,NPREC,LPR)

C     --- RECUPERATION DES ARGUMENTS CONCERNANT LE NOMBRE DE SHIFT ---
      CALL GETVIS('CALC_FREQ','NMAX_ITER_SHIFT',1,1,1,NBRSS,LBRSS)

C     --- RECUPERATION NFREQ ---
C     NFREQ : NOMBRE DE MODES DEMANDES
      CALL GETVIS('CALC_FREQ','NMAX_FREQ',1,1,1,NFREQ,L)

C     --- RECUPERATION PARAM ESPACE REDUIT ---
C     NBVECT, NBVEC2 : DIMENSION/COEF MULTIPLICATEUR DE L'ESPACE REDUIT
      NBVECT = 0
      CALL GETVIS('CALC_FREQ','DIM_SOUS_ESPACE',1,1,1,NBVECT,L)
      NBVEC2 = 0
      CALL GETVIS('CALC_FREQ','COEF_DIM_ESPACE',1,1,1,NBVEC2,L)

C     --- RECUPERATION DECALAGE POUR DETERMINER LE SHIFT ---
C     PRECSH : POUR PRE TRAITEMENT
      CALL GETVR8('CALC_FREQ','PREC_SHIFT',1,1,1,PRECSH,L)
C     PRECDC : POUR POST TRAITEMENT
      CALL GETVR8('VERI_MODE','PREC_SHIFT',1,1,1,PRECDC,LMF)

C     --- RECUPERATION PARAM LANCZOS ---
      IF (METHOD .EQ. 'TRI_DIAG') THEN
         CALL GETVIS(' ','NMAX_ITER_ORTHO' ,1,1,1,NBORTO,L)
         CALL GETVR8(' ','PREC_ORTHO'      ,1,1,1,PRORTO,L)
         CALL GETVR8(' ','PREC_LANCZOS'    ,1,1,1,PRSUDG,L)
         CALL GETVIS(' ','NMAX_ITER_QR'    ,1,1,1,NITV,L)
         
C     --- RECUPERATION PARAM JACOBI ---
      ELSE  IF (METHOD .EQ. 'JACOBI') THEN
         CALL GETVIS(' ','NMAX_ITER_BATHE ',1,1,1,ITEMAX,L)
         CALL GETVR8(' ','PREC_BATHE'      ,1,1,1,TOL,L)
         CALL GETVIS(' ','NMAX_ITER_JACOBI',1,1,1,NPERM,L)
         CALL GETVR8(' ','PREC_JACOBI'     ,1,1,1,TOLDYN,L)

C     --- RECUPERATION PARAM SORENSEN ---
       ELSE IF (METHOD .EQ. 'SORENSEN') THEN
         CALL GETVR8(' ','PREC_SOREN',1,1,1,TOLSOR,L)
         CALL GETVIS(' ','NMAX_ITER_SOREN'  ,1,1,1,MAXITR,L)
         CALL GETVR8(' ','PARA_ORTHO_SOREN' ,1,1,1,ALPHA,L)
         RAUX = R8PREM()
         IF ((ALPHA.LT.1.2D0*RAUX).OR.(ALPHA.GT.0.83D0-RAUX))
     &     CALL U2MESS('E','ALGELINE2_64')
C     --- RECUPERATION PARAM QZ ---
      ELSE IF (LQZ) THEN
        CALL GETVTX(' ','TYPE_QZ',1,1,1,TYPEQZ,L)
      ENDIF

C     --- RECUPERATION PARAM MODES RIGIDES ---
C     FCORIG : SEUIL DE FREQUENCE CORPS RIGIDE
      CALL GETVR8('CALC_FREQ','SEUIL_FREQ',1,1,1,FCORIG,L)
      OMECOR = OMEGA2(FCORIG)

C     --- LISTES DES FREQUENCES/CHARGES CRITIQUES ---
      CALL GETVR8('CALC_FREQ','FREQ',1,1,0,RBID,NNFREQ)
      CALL GETVR8('CALC_FREQ','CHAR_CRIT',1,1,0,RBID,NNCRIT)
      IF (NNFREQ.LT.0) THEN
         NNFREQ = -NNFREQ
         CALL WKVECT(CBORFR,' V V R',NNFREQ,LBORFR)
         CALL GETVR8('CALC_FREQ','FREQ',1,1,NNFREQ,ZR(LBORFR),L)
      ELSE
         CALL WKVECT(CBORFR,' V V R',1,LBORFR)
         ZR(LBORFR)=0.D0
      ENDIF
      IF (NNCRIT.LT.0) THEN
         NNCRIT = -NNCRIT
         CALL WKVECT(CBORCR,' V V R',NNCRIT,LBORCR)
         CALL GETVR8('CALC_FREQ','CHAR_CRIT',1,1,NNCRIT,ZR(LBORCR),L)
      ELSE
         CALL WKVECT(CBORCR,' V V R',1,LBORCR)
         ZR(LBORCR)=0.D0
      ENDIF

C     --- APPROCHE (CAS AVEC AMORTISSEMENT) ---
C     UTILISE SI LMAMOR.NE.0 ET SI METHODE.NE.QZ
      CALL GETVTX('CALC_FREQ','APPROCHE',1,1,1,APPR,IBID)

C     --- CONTROLE DE LA COHERENCE OPTION/FREQ OU CHAR_CRIT ---
      IF (TYPRES .EQ. 'DYNAMIQUE') THEN
        CALL VPVOPT(OPTIOF,TYPRES,NNFREQ,ZR(LBORFR),IERX)
      ELSE
        CALL VPVOPT(OPTIOF,TYPRES,NNCRIT,ZR(LBORCR),IERX)
      ENDIF
      
C     ------------------------------------------------------------------
C     --------------------  REGLES D'EXCLUSION   -----------------------
C     ------------------------------------------------------------------

C     --- MODES RIGIDES---
      IF ((MODRIG.EQ.'MODE_RIGIDE').AND.(METHOD.NE.'TRI_DIAG'))
     &  CALL U2MESS('F','ALGELINE2_65')

C       --- AMORTISSEMENT ---
      IF (LC) THEN
         IF (OPTIOF.EQ.'BANDE') CALL U2MESS('F','ALGELINE2_66')
         IF (((APPR.EQ.'I').OR.(APPR.EQ.'C')).AND.(ZR(LBORFR).EQ.0.D0))
     &     CALL U2MESS('F','ALGELINE2_67')
         IF (MODRIG.EQ.'MODE_RIGIDE') CALL U2MESS('F','ALGELINE2_68')
         IF (TYPRES.NE.'DYNAMIQUE') CALL U2MESS('F','ALGELINE2_46')
         IF ((METHOD.EQ.'SORENSEN').AND.(ZR(LBORFR).EQ.0.D0))
     &     CALL U2MESS('F','ALGELINE2_71')
         IF (METHOD(1:6).EQ.'JACOBI') CALL U2MESS('F','ALGELINE5_64')
      ENDIF

C     --- MATRICE K COMPLEXE ---
      IF (.NOT.LKR) THEN
        IF ((METHOD.NE.'SORENSEN').AND.(.NOT.LQZ))
     &    CALL U2MESS('F','ALGELINE2_69')
        IF (OPTIOF.EQ.'BANDE') CALL U2MESS('F','ALGELINE2_66')
        IF (ZR(LBORFR).EQ.0.D0) CALL U2MESS('F','ALGELINE2_70')
      ENDIF

C     --- METHODE QZ ---
      IF (LQZ) THEN
        IF ((TYPEQZ(1:5).EQ.'QZ_QR').AND.((TYPRES(1:10).EQ.'FLAMBEMENT')
     &       .OR.(LC).OR.(.NOT.LKR)))
     &    CALL U2MESS('F','ALGELINE5_60')
      ENDIF
      IF ((OPTIOF.EQ.'TOUT').AND.(.NOT.LQZ))
     &  CALL U2MESS('F','ALGELINE5_65')   

C     --- COMPATIBILITE DES MODES (DONNEES ALTEREES) ---
      CALL EXISD('MATR_ASSE',RAIDE,IBID)
      IF (IBID.NE.0) THEN
        CALL DISMOI('F','NOM_NUME_DDL',RAIDE,'MATR_ASSE',IBID,
     &              NUMEDD,IRET)
      ELSE
        NUMEDD=' '
      ENDIF
      CALL VPCREA(0,MODES,MASSE,AMOR,RAIDE,NUMEDD,IER1)

C     --- VERIFICATION DES "REFE" ---
      CALL VRREFE(MASSE,RAIDE,IRET)
      IF (IRET.GT.0) THEN
        VALK(1) = RAIDE
        VALK(2) = MASSE
        CALL U2MESK('F','ALGELINE2_58', 2 ,VALK)
      ENDIF
      IF (LC) THEN
        CALL VRREFE(RAIDE,AMOR,IRET)
        IF (IRET.GT.0) THEN
          VALK(1) = RAIDE
          VALK(2) = AMOR
          CALL U2MESK('F','ALGELINE2_58', 2 ,VALK)
        ENDIF
      ENDIF

C     ------------------------------------------------------------------
C     ---------------  DDLS LAGRANGE ET DDLS BLOQUES   -----------------
C     ------------------------------------------------------------------

C     --- DESCRIPTEUR DES MATRICES ---
      CALL MTDSCR(MASSE)
      CALL JEVEUO(MASSE(1:19)//'.&INT','E',LMASSE)
      CALL MTDSCR(RAIDE)
      CALL JEVEUO(RAIDE(1:19)//'.&INT','E',LRAIDE)
      IF (LC) THEN
        CALL MTDSCR(AMOR)
        CALL JEVEUO(AMOR(1:19)//'.&INT','E',LAMOR)
      ELSE
        LAMOR=0
      ENDIF

C     --- NOMBRE D'EQUATIONS ---
      NEQ = ZI(LRAIDE+2)
      
C     ------------------------------------------------------------------
C     ----------- DDL : LAGRANGE, BLOQUE PAR AFFE_CHAR_CINE  -----------
C     ------------------------------------------------------------------

      CALL WKVECT('&&OP0045.POSITION.DDL','V V I',NEQ*MXDDL,LDDL)
      CALL WKVECT('&&OP0045.DDL.BLOQ.CINE','V V I',NEQ,LPROD)
      CALL VPDDL(RAIDE, MASSE, NEQ, NBLAGR, NBCINE, NEQACT, ZI(LDDL),
     &           ZI(LPROD), IERD)
      IF (IERD .NE. 0) GOTO 9999

C       -- TRAITEMENTS PARTICULIERS PROPRES A QZ
      IF (LQZ) THEN
        IF (OPTIOF(1:4).EQ.'TOUT') NFREQ = NEQACT
        IF ((TYPEQZ(1:5).EQ.'QZ_QR').AND.(NBLAGR.NE.0))
     &    CALL U2MESS('F','ALGELINE5_60')
      ENDIF     
C     ------------------------------------------------------------------
C     ------------  CONSTRUCTION DE LA MATRICE SHIFTEE   ---------------
C     ------------------------------------------------------------------

C     --- VERIFICATION DES FREQUENCES MIN ET MAX, PASSAGE EN OMEGA2
      IF (TYPRES.EQ.'DYNAMIQUE') THEN
        FMIN = 0.D0
        FMAX = 0.D0
        IF (NNFREQ.GT.0) FMIN = ZR(LBORFR)
        IF (NNFREQ.GT.1) FMAX = ZR(LBORFR+1)
        IF ((LC).AND.(FMIN.LT.0.D0)) THEN
          FMIN = -FMIN
          IF (NIV .GE. 1) THEN
             WRITE(IFM,*)'PROBLEME QUADRATIQUE'
             WRITE(IFM,*)'FREQUENCE DE DECALAGE EST NEGATIVE',
     &               'LES VALEURS PROPRES ETANT CONJUGUEES 2 A 2 '//
     &               'ON PEUT LA PRENDRE POSITIVE. ON LE FAIT !!!'
             WRITE(IFM,*)
           ENDIF
        ENDIF
        OMEMIN = OMEGA2(FMIN)
        OMEMAX = OMEGA2(FMAX)
      ELSE
        OMEMIN = 0.D0
        OMEMAX = 0.D0
        IF (NNCRIT.GT.0) OMEMIN = ZR(LBORCR)
        IF (NNCRIT.GT.1) OMEMAX = ZR(LBORCR+1)
      ENDIF

C     --- ARRET SI PAS DE FREQUENCE DANS L'INTERVALLE DONNE  ---
      CALL GETVTX ( ' ', 'STOP_FREQ_VIDE', 1,1,1, ARRET, N1 )

C     ------------------------------------------------------------------
C     ----  DETETECTION DES MODES DE CORPS RIGIDE                 ------
C     ------------------------------------------------------------------

      LXRIG = 0
      NSTOC = 0
      IF (MODRIG .EQ. 'MODE_RIGIDE') THEN
        VECRIG = '&&OP0045.MODE.RIGID'
        CALL TLDLG2(LRAIDE,NPREC,NSTOC,VECRIG,IBID,KBID)
        IF (NSTOC.NE.0) CALL JEVEUO(VECRIG,'E',LXRIG)
      ENDIF

C     ------------------------------------------------------------------
C     ----  CREATION DE LA MATRICE DYNAMIQUE ET DE SA FACTORISEE  ------
C     ------------------------------------------------------------------
      MATPSC = '&&OP0045.DYN_FAC_R '
      MATOPA = '&&OP0045.DYN_FAC_C '
      OMESHI=0.D0
      SIGMA=(0.D0,0.D0)
      NPIVOT=0      
      IF (.NOT.LC) THEN
C     --- PROBLEME GENERALISE REEL ---
        IF (LKR) THEN
          CALL MTDEFS(MATPSC,RAIDE,'V','R')
          CALL MTDEFS(MATOPA,RAIDE,'V','R')
          CALL MTDSCR(MATPSC)
          CALL JEVEUO(MATPSC(1:19)//'.&INT','E',LMTPSC)
          CALL MTDSCR(MATOPA)
          CALL JEVEUO(MATOPA(1:19)//'.&INT','E',LMATRA)
          CALL VPFOPR(OPTIOF,TYPRES,LMASSE,LRAIDE,LMATRA,OMEMIN,OMEMAX,
     &               OMESHI,NFREQ,NPIVOT,OMECOR,PRECSH,NPREC,NBRSS,
     &               NBLAGR)
          IF (NFREQ.LE.0) THEN
            IF ( ARRET(1:3) .EQ. 'OUI' ) THEN
              CALL UTEXCP(24,'MODAL_1')
            ELSE
              NFREQ = 1
              CALL RSCRSD ( MODES , TYPCON , NFREQ )
              GOTO 999
            ENDIF
          ENDIF
          CALL VPSHIF(LRAIDE,OMESHI,LMASSE,LMTPSC)
        ELSE
C     --- PROBLEME GENERALISE COMPLEXE ---
          CALL VPFOPC(LMASSE,LRAIDE,FMIN,SIGMA,
     &                MATOPA,RAIDE,NPREC)
          CALL JEVEUO(MATOPA(1:19)//'.&INT','L',LMATRA)
        ENDIF
        
      ELSE

C     --- PROBLEME QUADRATIQUE REEL ---
        IF (LKR) THEN
          CALL WPFOPR(LMASSE,LAMOR,LRAIDE,APPR,FMIN,SIGMA,
     &                MATOPA,MATPSC,RAIDE,NPREC)
          CALL JEVEUO(MATOPA(1:19)//'.&INT','L',LMATRA)
          CALL JEEXIN(MATPSC(1:19)//'.&INT',IEXIN)
          IF (IEXIN .EQ. 0) THEN
            LMTPSC = 0
          ELSE
            CALL JEVEUO(MATPSC(1:19)//'.&INT','L',LMTPSC)
          ENDIF
        ELSE
C     --- PROBLEME QUADRATIQUE COMPLEXE ---
          CALL WPFOPC(LMASSE,LAMOR,LRAIDE,FMIN,SIGMA,
     &                MATOPA,RAIDE,NPREC)
          CALL JEVEUO(MATOPA(1:19)//'.&INT','L',LMATRA)
          CALL JEEXIN(MATPSC(1:19)//'.&INT',IEXIN)
          LMTPSC = 0
        ENDIF
      ENDIF
      
C     ------------------------------------------------------------------
C     ----  CORRECTION EVENTUELLE DU NBRE DE MODES DEMANDES NFREQ ------
C     ----  DETERMINATION DE LA DIMENSION DU SOUS ESPACE NBVECT   ------
C     ------------------------------------------------------------------
        
      
      IF (NIV.GE.1) THEN
        WRITE(IFM,*)'INFORMATIONS SUR LE CALCUL DEMANDE:'
        WRITE(IFM,*)'NOMBRE DE MODES RECHERCHES     : ',NFREQ
        WRITE(IFM,*)
      ENDIF

C     --- CORRECTION DU NOMBRE DE FREQUENCES DEMANDEES
      IF (NFREQ.GT.NEQACT) THEN
        NFREQ = NEQACT
        IF (NIV .GE. 1) THEN
          WRITE(IFM,*)'INFORMATIONS SUR LE CALCUL DEMANDE:'
          WRITE(IFM,*)'TROP DE MODES DEMANDES POUR LE NOMBRE '//
     &               'DE DDL ACTIFS, ON EN CALCULERA LE MAXIMUM '//
     &               'A SAVOIR: ',NFREQ
        ENDIF
      ENDIF

C     --- DETERMINATION DE NBVECT (DIMENSION DU SOUS ESPACE) ---
      IF (.NOT.LQZ) THEN
        IF (NIV.GE.1)
     &    WRITE(IFM,*)'LA DIMENSION DE L''ESPACE REDUIT EST : ',NBVECT
        IF (NBVEC2.NE.0) THEN
          ICOEF = NBVEC2
        ELSE
          IF (METHOD.EQ.'JACOBI') THEN
            ICOEF = 2
          ELSE IF (METHOD.EQ.'TRI_DIAG') THEN
            ICOEF = 4
          ELSE IF (METHOD.EQ.'SORENSEN') THEN
            ICOEF = 2
          ENDIF
        ENDIF
        IF (NBVECT.LT.NFREQ) THEN
          IF (METHOD.EQ.'JACOBI') THEN
            NBVECT = MIN(MIN(7+NFREQ,ICOEF*NFREQ),NEQACT)
          ELSE IF (METHOD.EQ.'TRI_DIAG') THEN
            NBVECT = MIN(MAX(7+NFREQ,ICOEF*NFREQ),NEQACT)
          ELSE IF (METHOD.EQ.'SORENSEN') THEN
            NBVECT = MIN(MAX(2+NFREQ,ICOEF*NFREQ),NEQACT)
          ENDIF
          IF (NIV .GE. 1) THEN
            WRITE(IFM,*)'ELLE EST INFERIEURE AU NOMBRE '//
     &                      'DE MODES, ON LA PREND EGALE A ',NBVECT
            WRITE(IFM,*)
          ENDIF
        ELSE
          IF (NBVECT.GT.NEQACT) THEN
            NBVECT = NEQACT
            IF (NIV .GE. 1) THEN
              WRITE(IFM,*) 'ELLE EST SUPERIEURE AU'//
     &       ' NOMBRE DE DDL ACTIFS, ON LA RAMENE A CE NOMBRE ',NBVECT
              WRITE(IFM,*)
            ENDIF
          ENDIF
        ENDIF
      ENDIF

C     --- TRAITEMENT SPECIFIQUE A SORENSEN ---
      IF ((METHOD.EQ.'SORENSEN').AND.(NBVECT-NFREQ.LT.2)) THEN
        IF (NFREQ.GT.(NEQACT+2)) THEN
CC        DIMINUTION FORCEE DE NFREQ
          NFREQ=NEQACT-2
        ENDIF
CC      AUGMENTATION FORCEE DE NBVECT
        NBVECT = NFREQ + 2
      ENDIF

C     --- TRAITEMENT SPECIFIQUE A QZ ---
C     AVEC QZ ON A PAS D'ESPACE DE PROJECTION, IL FAUT DONC AFFECTER
C     NBVECT EN DUR
      IF (LQZ) NBVECT=NEQ
      
C     --- CORRECTION DE NBVECT DANS LE CAS QUADRATIQUE
      IF (LC) THEN
        NBVECT = 2*NBVECT
        NFREQ = 2*NFREQ
        CALL U2MESS('I','ALGELINE2_75')
      ENDIF


C     ------------------------------------------------------------------
C     --------------  ALLOCATION DES ZONES DE TRAVAIL   ----------------
C     ------------------------------------------------------------------

      MXRESF = NFREQ
      CALL WKVECT('&&OP0045.RESU_I','V V I'  ,NBPARI*NBVECT, LRESUI)
      CALL WKVECT('&&OP0045.RESU_R','V V R'  ,NBPARR*NBVECT, LRESUR)
      CALL WKVECT('&&OP0045.RESU_K','V V K24',NBPARK*NBVECT, LRESUK)

C     --- INITIALISATION A UNDEF DE LA STRUCTURE DE DONNEES RESUF ---
      DO 20 IEQ = 1, NBPARR*NBVECT
        ZR(LRESUR+IEQ-1) = UNDF
  20  CONTINUE
      DO 22 IEQ = 1, NBPARI*NBVECT
        ZI(LRESUI+IEQ-1) = INDF
  22  CONTINUE

C     --- CAS GENERALISE REEL ---
      IF ((LKR).AND.(.NOT.LC)) THEN
        CALL WKVECT('&&OP0045.VECTEUR_PROPRE','V V R',NEQ*NBVECT,LVEC)
      ELSE
C     --- CAS GENERALISE COMPLEXE OU QUADRATIQUE REEL ET COMPLEXE ---
        CALL WKVECT('&&OP0045.VECTEUR_PROPRE','V V C',NEQ*NBVECT,LVEC)
      ENDIF

      IF (METHOD .EQ. 'TRI_DIAG') THEN
        CALL WKVECT('&&OP0045.MAT.DIAG'    ,'V V R',NBVECT,LDIAGR)
        CALL WKVECT('&&OP0045.MAT.SUR.DIAG','V V R',NBVECT,LSURDR)
        CALL WKVECT('&&OP0045.SIGNES'      ,'V V R',NBVECT,LSIGN)
        IF (.NOT.LC) THEN
          CALL WKVECT('&&OP0045.MAT.MOD.REDUITE','V V R',
     &                NBVECT*NBVECT,IADZ)
        ELSE
          CALL WKVECT('&&OP0045.VECT.LANCZOS','V V R',NEQ*NBVECT,IADX)
          CALL WKVECT('&&OP0045.VECTY   ','V V R',NEQ*NBVECT,IADY)
          CALL WKVECT('&&OP0045.MAT.MOD.REDUITE','V V R',
     &                2*NBVECT*NBVECT,IADZ)
          CALL WKVECT('&&OP0045.VECT_DEP.H','V V R',NEQ,IADRH)
          CALL WKVECT('&&OP0045.VECT_DEP.B','V V R',NEQ,IADRB)
        ENDIF
      ELSE IF (METHOD .EQ. 'JACOBI') THEN
         CALL WKVECT('&&OP0045.VALPRO','V V R',NBVECT,LVALPR)
      ELSE IF (LQZ) THEN
        QRN = NBVECT
        QRLWOR=8*QRN
        QRN2=QRN*QRN
        IF (TYPEQZ(1:7).EQ.'QZ_EQUI') THEN
          CALL WKVECT('&&OP0045.QRLSCALE.WORK','V V R',QRN,ILSCAL)
          CALL WKVECT('&&OP0045.QRRSCALE.WORK','V V R',QRN,IRSCAL)
        ENDIF
        IF (LKR.AND..NOT.LC) THEN
          CALL WKVECT('&&OP0045.QZ.VALPRO','V V R',QRN,LVALPR)
          CALL WKVECT('&&OP0045.QZ.MATRICEK','V V R',QRN2,IQRN)
          CALL WKVECT('&&OP0045.QZ.MATRICEM','V V R',QRN2,LQRN)
          CALL WKVECT('&&OP0045.QZ.ALPHAR','V V R',QRN,QRAR)
          CALL WKVECT('&&OP0045.QZ.ALPHAI','V V R',QRN,QRAI)
          CALL WKVECT('&&OP0045.QZ.BETA','V V R',QRN,QRBA)
          CALL WKVECT('&&OP0045.QZ.VL','V V R',QRN,QRVL)
          CALL WKVECT('&&OP0045.QZ.WORK','V V R',QRLWOR,KQRN)
        ELSE
          IF (LC)
     &      CALL WKVECT('&&OP0045.VECT.AUC','V V C',QRN2,LAUC)
          CALL WKVECT('&&OP0045.QZ.VALPRO','V V C',QRN,LVALPR)
          CALL WKVECT('&&OP0045.QZ.MATRICEK','V V C',QRN2,IQRN)
          CALL WKVECT('&&OP0045.QZ.MATRICEM','V V C',QRN2,LQRN)
          CALL WKVECT('&&OP0045.QZ.ALPHA','V V C',QRN,QRAR)
          CALL WKVECT('&&OP0045.QZ.BETA','V V C',QRN,QRBA)
          CALL WKVECT('&&OP0045.QZ.VL','V V C',QRN,QRVL)
          CALL WKVECT('&&OP0045.QZ.WORK','V V C',QRLWOR,KQRN)
          CALL WKVECT('&&OP0045.QZ.WORKR','V V R',QRLWOR,KQRNR)
        ENDIF
        CALL JERAZO('&&OP0045.QZ.MATRICEK',QRN2,1)
        CALL JERAZO('&&OP0045.QZ.MATRICEM',QRN2,1)      
      ELSE IF (METHOD .EQ. 'SORENSEN') THEN
        LONWL = 3*NBVECT**2+6*NBVECT
        CALL WKVECT('&&OP0045.SELECT','V V L',NBVECT,LSELEC)
C     --- CAS REEL GENERALISE ---
        IF (LKR.AND.(.NOT.LC)) THEN
          CALL WKVECT('&&OP0045.RESID','V V R',NEQ,LRESID)
          CALL WKVECT('&&OP0045.VECT.WORKD','V V R',3*NEQ,LWORKD)
          CALL WKVECT('&&OP0045.VECT.WORKL','V V R',LONWL,LWORKL)
          CALL WKVECT('&&OP0045.VECT.WORKV','V V R',3*NBVECT,LWORKV)
          CALL WKVECT('&&OP0045.VAL.PRO','V V R',2*(NFREQ+1),LDSOR)
          CALL WKVECT('&&OP0045.VECT.AUX','V V R',NEQ,LAUX)
C     --- CAS COMPLEXE GENERALISE ---
        ELSE IF ((.NOT.LKR).AND.(.NOT.LC)) THEN
          CALL WKVECT('&&OP0045.RESID','V V C',NEQ,LRESID)
          CALL WKVECT('&&OP0045.VECT.WORKD','V V C',3*NEQ,LWORKD)
          CALL WKVECT('&&OP0045.VECT.WORKL','V V C',LONWL,LWORKL)
          CALL WKVECT('&&OP0045.VECT.WORKV','V V C',3*NBVECT,LWORKV)
          CALL WKVECT('&&OP0045.VAL.PRO','V V C',(NFREQ+1),LDSOR)
          CALL WKVECT('&&OP0045.VECT.AUX','V V C',NEQ,LAUX)
          CALL WKVECT('&&OP0045.VECT.AUR','V V R',NBVECT,LWORKR)
C     --- CAS REEL QUADRATIQUE APPROCHE REELLE OU IMAGINAIRE ---
        ELSE IF ((LKR.AND.LC).AND.(APPR.NE.'C')) THEN
          CALL WKVECT('&&OP0045.RESID','V V R',2*NEQ,LRESID)
          CALL WKVECT('&&OP0045.VECT.WORKD','V V R',6*NEQ,LWORKD)
          CALL WKVECT('&&OP0045.VECT.AUX','V V R',2*NEQ,LAUX)
          CALL WKVECT('&&OP0045.VECT.AUC','V V C',2*NEQ*(NBVECT+1),
     &     LAUC)
          CALL WKVECT('&&OP0045.VECT.AUR','V V R',2*NEQ*(NBVECT+1),
     &     LAUR)
          CALL WKVECT('&&OP0045.VECT.AUL','V V C',NEQ*(NBVECT+1),
     &     LAUL)
          CALL WKVECT('&&OP0045.VAL.PR','V V R',NBVECT+1,LDIAGR)
          CALL WKVECT('&&OP0045.VAL.PI','V V R',NBVECT+1,LSURDR)
          CALL WKVECT('&&OP0045.VAL.PRO','V V R',2*(NFREQ+1),LDSOR)
          CALL WKVECT('&&OP0045.VECT.WORKL','V V R',LONWL,LWORKL)
          CALL WKVECT('&&OP0045.VECT.WORKV','V V R',3*NBVECT,LWORKV)
C     --- CAS REEL QUADRATIQUE APPROCHE COMPLEXE ---
        ELSE IF ((LKR.AND.LC).AND.(APPR.EQ.'C')) THEN
          CALL WKVECT('&&OP0045.RESID','V V C',2*NEQ,LRESID)
          CALL WKVECT('&&OP0045.VECT.WORKD','V V C',6*NEQ,LWORKD)
          CALL WKVECT('&&OP0045.VECT.AUX','V V C',2*NEQ,LAUX)
          CALL WKVECT('&&OP0045.VECT.AUC','V V C',2*NEQ*(NBVECT+1),
     &     LAUC)
          CALL WKVECT('&&OP0045.VECT.AUR','V V R',2*NEQ*(NBVECT+1),
     &     LAUR)
          CALL WKVECT('&&OP0045.VECT.WORKL','V V C',LONWL,LWORKL)
          CALL WKVECT('&&OP0045.VECT.WORKV','V V C',3*NBVECT,LWORKV)
          CALL WKVECT('&&OP0045.VAL.PRO','V V C',2*(NFREQ+1),LDSOR)
C     --- CAS COMPLEXE QUADRATIQUE  ---
        ELSEIF ((.NOT.LKR).AND.(LC)) THEN
          CALL WKVECT('&&OP0045.RESID','V V C',2*NEQ,LRESID)
          CALL WKVECT('&&OP0045.VECT.WORKD','V V C',6*NEQ,LWORKD)
          CALL WKVECT('&&OP0045.VECT.WORKL','V V C',LONWL,LWORKL)
          CALL WKVECT('&&OP0045.VECT.WORKV','V V C',3*NBVECT,LWORKV)
          CALL WKVECT('&&OP0045.VAL.PRO','V V C',2*(NFREQ+1),LDSOR)
          CALL WKVECT('&&OP0045.VECT.AUX','V V C',2*NEQ,LAUX)
          CALL WKVECT('&&OP0045.VECT.AUC','V V C',2*NEQ*(NBVECT+1),
     &     LAUC)
          CALL WKVECT('&&OP0045.VECT.AUR','V V R',2*NEQ*(NBVECT+1),
     &     LAUR)
        ELSE
C ---- OPTION ILLICITE
          CALL ASSERT(.FALSE.)
        ENDIF
      ENDIF
      
C TEST POUR SIMULER LE PB GENERALISE KU=LAMBDA*MU VIA LES CHEMINS
C INFORMATIQUE DU PB QUADRATIQUE. ON POSE C=-M ET M=0
C OBJECTIF: VALIDER LE QUADRATIQUE INFORMATIQUEMENT
      IF ((LTESTQ).AND.(LC)) THEN
        CALL JEVEUO(JEXNUM(AMOR(1:19)//'.VALM',1),'L',IBID)
        CALL JEVEUO(JEXNUM(MASSE(1:19)//'.VALM',1),'L',JBID)
        CALL JEVEUO(NUMEDD(1:14)//'.SMOS.SMHC','L',IHCOL)
        CALL JEVEUO(NUMEDD(1:14)//'.SMOS.SMDI','L',IADIA)
        IDEB=1
        DO 35 J = 1,NEQ
          IFIN = ZI(IADIA-1+J)
          DO 34 I = IDEB,IFIN
            ZR(IBID-1+I)=-ZR(JBID-1+I)
            ZR(JBID-1+I)=0.D0
   34     CONTINUE
          IDEB = IFIN+1
   35   CONTINUE
      ENDIF
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
C     -------  CALCUL DES VALEURS PROPRES ET VECTEURS PROPRES   --------
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------

      IF (.NOT.LC) THEN

C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
C     ---------------------  PROBLEME GENERALISE   ---------------------
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------

        IF ((METHOD(1:8).EQ.'SORENSEN').AND.(LKR)) THEN
C     ------------------------------------------------------------------
C     -------  SORENSEN PB GENERALISE REEL   --------
C     ------------------------------------------------------------------
          CALL VPSORN (LMASSE, LMATRA, NEQ, NBVECT, NFREQ, TOLSOR,
     &         ZR(LVEC), ZR(LRESID), ZR(LWORKD), ZR(LWORKL), LONWL,
     &         ZL(LSELEC), ZR(LDSOR), OMESHI, ZR(LAUX), ZR(LWORKV),
     &         ZI(LPROD), ZI(LDDL), NEQACT, MAXITR, IFM, NIV, PRIRAM,
     &         ALPHA, OMECOR, NCONV, FLAGE)
          CALL RECTFR(NCONV, NCONV, OMESHI, NPIVOT, NBLAGR,
     &         ZR(LDSOR), NFREQ+1, ZI(LRESUI), ZR(LRESUR), NFREQ)
          CALL VPBOST (TYPRES, NCONV, NCONV, OMESHI, ZR(LDSOR),
     &         NFREQ+1, VPINF, VPMAX, PRECDC, METHOD, OMECOR, STURM)
          IF (TYPRES .EQ. 'DYNAMIQUE')
     &      CALL VPORDI(1,0,NCONV,ZR(LRESUR+MXRESF),ZR(LVEC),NEQ,
     &                  ZI(LRESUI))
          DO 37 IMET = 1,NCONV
            ZI(LRESUI-1+  MXRESF+IMET) = 0
            ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
            ZR(LRESUR-1+2*MXRESF+IMET) = 0.0D0
            ZK24(LRESUK-1+  MXRESF+IMET) = 'SORENSEN'
 37       CONTINUE
          IF (TYPRES .NE. 'DYNAMIQUE') THEN
            CALL VPORDO(0,0,NCONV,ZR(LRESUR+MXRESF),ZR(LVEC),NEQ)
            DO 38 IMET = 1,NCONV
              ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
              ZI(LRESUI-1+IMET) = IMET
 38         CONTINUE
          ENDIF
          
        ELSE IF ((METHOD(1:8).EQ.'SORENSEN').AND.(.NOT.LKR)) THEN
C     ------------------------------------------------------------------
C     -------  SORENSEN PB GENERALISEE COMPLEXE   --------
C     ------------------------------------------------------------------
          CALL VPSORC (LMASSE, LMATRA, NEQ, NBVECT, NFREQ, TOLSOR,
     &       ZC(LVEC), ZC(LRESID), ZC(LWORKD), ZC(LWORKL), LONWL,
     &       ZL(LSELEC), ZC(LDSOR), SIGMA,
     &       ZC(LAUX), ZC(LWORKV), ZR(LWORKR),
     &       ZI(LPROD), ZI(LDDL), NEQACT, MAXITR, IFM, NIV, PRIRAM,
     &       ALPHA, NCONV, FLAGE)
          NPIVOT = NBLAGR
          CALL RECTFC(NCONV, NCONV, SIGMA, NPIVOT, NBLAGR,
     &       ZC(LDSOR), NFREQ+1, ZI(LRESUI), ZR(LRESUR), NFREQ)
          CALL VPBOSC (TYPRES, NCONV, NCONV, SIGMA, ZC(LDSOR),
     &       NFREQ+1, VPINF, VPMAX, PRECDC, METHOD, OMECOR, STURM)
          DO 377 IMET = 1,NCONV
            ZI(LRESUI-1+  MXRESF+IMET) = 0
            ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
            ZK24(LRESUK-1+  MXRESF+IMET) = 'SORENSEN'
 377      CONTINUE
       
        ELSE IF ((LQZ).AND.(LKR)) THEN
C     ------------------------------------------------------------------
C     -------  QZ PB GENERALISE REEL   --------
C     ------------------------------------------------------------------
          CALL VPQZLA(TYPEQZ, QRN, IQRN, LQRN, QRAR, QRAI, QRBA,
     &         QRVL, LVEC, KQRN, LVALPR, NCONV,
     &         OMECOR, KTYP, KQRNR, NEQACT, ILSCAL, IRSCAL, 
     &         OPTIOF, TYPRES, OMEMIN, OMEMAX, OMESHI, ZI(LPROD), NFREQ,
     &         LMASSE, LRAIDE, LAMOR, NUMEDD, SIGMA)
          CALL RECTFR(NCONV, NCONV, OMESHI, NPIVOT, NBLAGR,
     &         ZR(LVALPR), NFREQ, ZI(LRESUI), ZR(LRESUR), NFREQ)
          CALL VPBOST(TYPRES, NCONV, NCONV, OMESHI, ZR(LVALPR),
     &         NFREQ, VPINF, VPMAX, PRECDC, METHOD, OMECOR, STURM)
          IF (TYPRES .EQ. 'DYNAMIQUE')
     &      CALL VPORDI(1,0,NCONV,ZR(LRESUR+MXRESF),ZR(LVEC),NEQ,
     &                    ZI(LRESUI))
          DO 125 IMET = 1,NCONV
            ZI(LRESUI-1+  MXRESF+IMET) = 0
            ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
            ZR(LRESUR-1+2*MXRESF+IMET) = 0.0D0
            ZK24(LRESUK-1+  MXRESF+IMET) = TYPEQZ
  125     CONTINUE
          IF (TYPRES .NE. 'DYNAMIQUE') THEN
            CALL VPORDO(0,0,NCONV,ZR(LRESUR+MXRESF),ZR(LVEC),NEQ)
              DO 126 IMET = 1,NCONV
                ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
                ZI(LRESUI-1+IMET) = IMET
  126         CONTINUE
          ENDIF

        ELSE IF ((LQZ).AND.(.NOT.LKR)) THEN
C     ------------------------------------------------------------------
C     -------  QZ PB GENERALISE COMPLEXE   --------
C     ------------------------------------------------------------------
          CALL VPQZLA(TYPEQZ, QRN, IQRN, LQRN, QRAR, QRAI, QRBA,
     &         QRVL, LVEC, KQRN, LVALPR, NCONV,
     &         OMECOR, KTYP, KQRNR, NEQACT, ILSCAL, IRSCAL, 
     &         OPTIOF, TYPRES, OMEMIN, OMEMAX, OMESHI, ZI(LPROD), NFREQ,
     &         LMASSE, LRAIDE, LAMOR, NUMEDD, SIGMA)
          NPIVOT = NBLAGR
          CALL RECTFC(NCONV, NCONV, SIGMA, NPIVOT, NBLAGR,
     &         ZC(LVALPR), NFREQ, ZI(LRESUI), ZR(LRESUR), NFREQ)
          CALL VPBOSC(TYPRES, NCONV, NCONV, SIGMA, ZC(LVALPR),
     &         NFREQ, VPINF, VPMAX, PRECDC, METHOD, OMECOR, STURM)
          DO 127 IMET = 1,NCONV
            ZI(LRESUI-1+  MXRESF+IMET) = 0
            ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
            ZK24(LRESUK-1+  MXRESF+IMET) = TYPEQZ
  127     CONTINUE
                  
        ELSE IF (METHOD(1:6).EQ.'JACOBI') THEN
C     ------------------------------------------------------------------
C     -------  JACOBI PB GENERALISE REEL   --------
C     ------------------------------------------------------------------
          CALL SSPACE(LMTPSC,LMATRA,LMASSE,NEQ,NBVECT,NFREQ,ZI(LPROD),
     &             ITEMAX,NPERM,TOL,TOLDYN,ZR(LVEC),ZR(LVALPR),
     &             NITJAC,NITBAT)
          CALL RECTFR(NFREQ,NBVECT,OMESHI,NPIVOT,NBLAGR,
     &                  ZR(LVALPR),NBVECT,ZI(LRESUI),ZR(LRESUR),NFREQ)
          CALL VPBOST(TYPRES,NFREQ,NBVECT,OMESHI,ZR(LVALPR),NBVECT,
     &                  VPINF, VPMAX,PRECDC,METHOD,OMECOR,STURM)
          IF (TYPRES .EQ. 'DYNAMIQUE')
     &      CALL VPORDI (1,0,NFREQ,ZR(LRESUR+MXRESF),ZR(LVEC),NEQ,
     &                  ZI(LRESUI))
          DO 30 IMET = 1,NFREQ
            ZI(LRESUI-1+2*MXRESF+IMET) = NITBAT
            ZI(LRESUI-1+4*MXRESF+IMET) = NITJAC
            ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
            ZR(LRESUR-1+2*MXRESF+IMET) = 0.0D0
            ZK24(LRESUK-1+  MXRESF+IMET) = 'BATHE_WILSON'
 30       CONTINUE
          IF (TYPRES .NE. 'DYNAMIQUE') THEN
            CALL VPORDO(0,0,NFREQ,ZR(LRESUR+MXRESF),ZR(LVEC),NEQ)
            DO 31 IMET = 1,NFREQ
              ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
              ZI(LRESUI-1+IMET) = IMET
 31         CONTINUE
          ENDIF
          
        ELSE IF (METHOD(1:8).EQ.'TRI_DIAG') THEN
C     ------------------------------------------------------------------
C     -------  LANCZOS PB GENERALISE REEL   --------
C     ------------------------------------------------------------------
          IF (NSTOC .GE. NBVECT) CALL U2MESS('A','ALGELINE2_72')
          IF (NSTOC .NE. 0) THEN
            DO 26 I =1, NEQ * NSTOC
              ZR(LVEC + I - 1) = ZR(LXRIG + I -1)
 26         CONTINUE
          ENDIF
          CALL VP2INI(LMTPSC,LMASSE,LMATRA,NEQ,NBVECT,NBORTO,PRORTO,
     &                  ZI(LPROD),ZI(LDDL),ZR(LDIAGR),ZR(LSURDR),
     &                  ZR(LSIGN),ZR(LVEC),PRSUDG,NSTOC,OMESHI)
          CALL VP2TRD('G',NBVECT,ZR(LDIAGR),ZR(LSURDR),ZR(LSIGN),
     &                  ZR(IADZ),NITV,NITQRM)
          CALL VPRECO(NBVECT,NEQ,ZR(IADZ),ZR(LVEC))
          CALL RECTFR(NFREQ,NBVECT,OMESHI,NPIVOT,NBLAGR,
     &                  ZR(LDIAGR),NBVECT,ZI(LRESUI),ZR(LRESUR),NFREQ)
          CALL VPBOST(TYPRES,NFREQ,NBVECT,OMESHI,ZR(LDIAGR),NBVECT,
     &                  VPINF, VPMAX,PRECDC,METHOD,OMECOR,STURM)
          IF (TYPRES .EQ. 'DYNAMIQUE')
     &      CALL VPORDI (1,0,NFREQ,ZR(LRESUR+MXRESF),ZR(LVEC),NEQ,
     &                  ZI(LRESUI))
          DO 32 IMET = 1,NFREQ
            ZI(LRESUI-1+  MXRESF+IMET) = NITQRM
            ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
            ZR(LRESUR-1+2*MXRESF+IMET) = 0.0D0
            ZK24(LRESUK-1+  MXRESF+IMET) = 'LANCZOS'
 32       CONTINUE
          IF (TYPRES .NE. 'DYNAMIQUE') THEN
            CALL VPORDO(0,0,NFREQ,ZR(LRESUR+MXRESF),ZR(LVEC),NEQ)
            DO 33 IMET = 1,NFREQ
              ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
              ZI(LRESUI-1+IMET) = IMET
 33         CONTINUE
          ENDIF
        ENDIF
               
      ELSE

C     ------------------------------------------------------------------
C     ------------------------------------------------------------------
C     ---------------------  PROBLEME QUADRATIQUE   --------------------
C     ------------------------------------------------------------------
C     ------------------------------------------------------------------

        IF (METHOD(1:8).EQ.'TRI_DIAG') THEN        
C     ------------------------------------------------------------------
C     -------  LANCZOS PB QUADRATIQUE   --------
C     ------------------------------------------------------------------
          CALL WP2INI(APPR,LMASSE,LAMOR,LRAIDE,LMATRA,LMTPSC,SIGMA,
     &                  ZR(IADRH),ZR(IADRB),OPTIOF,PRORTO,NBORTO,NBVECT,
     &                  NEQ,ZI(LPROD),ZI(LDDL),ZR(LDIAGR),ZR(LSURDR),
     &                  ZR(LSIGN),ZR(IADX),ZR(IADY))
          CALL VP2TRD('Q',NBVECT,ZR(LDIAGR),ZR(LSURDR),ZR(LSIGN),
     &                  ZR(IADZ),NITV,NITQRM)
          NPIVOT = NBLAGR
          NFREQ  = NFREQ / 2
          CALL WP2VEC(APPR,OPTIOF,NFREQ,NBVECT,NEQ,SIGMA,ZR(IADX),
     &                  ZR(IADY),ZR(IADZ),2*NBVECT,ZR(LSURDR),
     &                  ZR(LDIAGR),ZC(LVEC),MXRESF,
     &                  ZI(LRESUI),ZR(LRESUR),ZI(LPROD))
          DO 36 IMET = 1,NFREQ
            ZI(LRESUI-1+MXRESF+IMET) = NITQRM
            ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
            ZK24(LRESUK-1+MXRESF+IMET) = 'LANCZOS'
 36       CONTINUE

        ELSE IF (LQZ) THEN
C     ------------------------------------------------------------------
C     -------  QZ PB QUADRATIQUE REEL ET COMPLEXE  --------
C     ------------------------------------------------------------------
          CALL VPQZLA(TYPEQZ, QRN, IQRN, LQRN, QRAR, QRAI, QRBA,
     &         QRVL, LVEC, KQRN, LVALPR,
     &         NCONV, OMECOR, KTYP, KQRNR, NEQACT, ILSCAL, IRSCAL, 
     &         OPTIOF, TYPRES, OMEMIN, OMEMAX, OMESHI, ZI(LPROD),
     &         NFREQ, LMASSE, LRAIDE, LAMOR, NUMEDD, SIGMA)
          NFREQ=NFREQ/2
          CALL WP4VEC(NFREQ,NCONV,NEQ,SIGMA,
     &           ZC(LVALPR),ZC(LVEC),MXRESF,
     &           ZI(LRESUI),ZR(LRESUR),ZI(LPROD),ZC(LAUC))
          DO 578 IMET = 1,NFREQ
            ZI(LRESUI-1+MXRESF+IMET) = 0
            ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
            ZK24(LRESUK-1+MXRESF+IMET) = TYPEQZ
 578      CONTINUE
        ELSE IF (METHOD(1:8).EQ.'SORENSEN') THEN
          IF (LKR) THEN
            IF ((APPR.EQ.'R').OR.(APPR.EQ.'I')) THEN
C     ------------------------------------------------------------------
C     -------  SORENSEN PB QUADRATIQUE REEL   --------
C     -------  APPROCHE REELLE OU IMAGINAIRE  --------
C     ------------------------------------------------------------------
              CALL WPSORN (APPR, LMASSE, LAMOR, LMATRA,
     &           NEQ, NBVECT, NFREQ, TOLSOR, ZC(LVEC), ZR(LRESID),
     &           ZR(LWORKD), ZR(LWORKL), LONWL, ZL(LSELEC), ZR(LDSOR),
     &           ZR(LSURDR),ZR(LDIAGR),
     &           SIGMA, ZR(LAUX), ZR(LWORKV), ZI(LPROD), ZI(LDDL),
     &           NEQACT,MAXITR, IFM, NIV, PRIRAM, ALPHA, NCONV, FLAGE,
     &           ZR(LAUR), ZC(LAUC), ZC(LAUL))
              NFREQ = NCONV / 2
              CALL WP3VEC(APPR,OPTIOF,NFREQ,NCONV,NEQ,SIGMA,
     &          ZR(LSURDR),ZR(LDIAGR),ZC(LVEC),MXRESF,
     &          ZI(LRESUI),ZR(LRESUR),ZI(LPROD),ZC(LAUC))
            ELSE
C     ------------------------------------------------------------------
C     -------  SORENSEN PB QUADRATIQUE REEL   --------
C     -------  APPROCHE COMPLEXE              --------
C     ------------------------------------------------------------------
              CALL WPSORC (LMASSE, LAMOR, LMATRA,
     &           NEQ, NBVECT, NFREQ, TOLSOR, ZC(LVEC), ZC(LRESID),
     &           ZC(LWORKD), ZC(LWORKL), LONWL, ZL(LSELEC), ZC(LDSOR),
     &           SIGMA, ZC(LAUX), ZC(LWORKV), ZI(LPROD), ZI(LDDL),
     &           NEQACT,MAXITR, IFM, NIV, PRIRAM, ALPHA, NCONV, FLAGE,
     &           ZC(LAUC),ZR(LAUR))
              NFREQ = NCONV / 2
              CALL WP4VEC(NFREQ,NCONV,NEQ,SIGMA,
     &           ZC(LDSOR),ZC(LVEC),MXRESF,
     &           ZI(LRESUI),ZR(LRESUR),ZI(LPROD),ZC(LAUC))
            ENDIF
            DO 378 IMET = 1,NFREQ
              ZI(LRESUI-1+MXRESF+IMET) = 0
              ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
              ZK24(LRESUK-1+MXRESF+IMET) = 'SORENSEN'
 378        CONTINUE
          ELSE
C     ------------------------------------------------------------------
C     -------  SORENSEN PB QUADRATIQUE COMPLEXE   --------
C     -------  APPROCHE COMPLEXE                  --------
C     ------------------------------------------------------------------
            CALL WPSORC (LMASSE, LAMOR, LMATRA,
     &         NEQ, NBVECT, NFREQ, TOLSOR, ZC(LVEC), ZC(LRESID),
     &         ZC(LWORKD), ZC(LWORKL), LONWL, ZL(LSELEC), ZC(LDSOR),
     &         SIGMA, ZC(LAUX), ZC(LWORKV), ZI(LPROD), ZI(LDDL),
     &         NEQACT,MAXITR, IFM, NIV, PRIRAM, ALPHA, NCONV, FLAGE,
     &         ZC(LAUC),ZR(LAUR))
            NFREQ = NCONV / 2
            CALL WP5VEC(OPTIOF,NFREQ,NCONV,NEQ,ZC(LDSOR),ZC(LVEC),
     &         MXRESF,ZI(LRESUI),ZR(LRESUR),ZC(LAUC))
            DO 379 IMET = 1,NFREQ
              ZI(LRESUI-1+MXRESF+IMET) = 0
              ZR(LRESUR-1+IMET) = FREQOM(ZR(LRESUR-1+MXRESF+IMET))
              ZK24(LRESUK-1+MXRESF+IMET) = 'SORENSEN'
 379        CONTINUE
          ENDIF
        ENDIF
      ENDIF
C ---- NOMBRE DE MODES CONVERGES
      NCONV = NFREQ
      
C     ------------------------------------------------------------------
C     -------------------- CORRECTION : OPTION BANDE -------------------
C     ------------------------------------------------------------------

C     --- SI OPTION BANDE ON NE GARDE QUE LES FREQUENCES DANS LA BANDE
      MFREQ = NCONV
      IF (OPTIOF.EQ.'BANDE') THEN
        DO 110 IFREQ = MFREQ - 1,0
          IF (ZR(LRESUR+MXRESF+IFREQ).GT.OMEMAX .OR.
     &      ZR(LRESUR+MXRESF+IFREQ).LT.OMEMIN )
     &      NCONV = NCONV - 1
110     CONTINUE
        IF (MFREQ.NE.NCONV) CALL U2MESS('I','ALGELINE2_17')
      ENDIF


C     ------------------------------------------------------------------
C     -------------- CALCUL DES PARAMETRES GENERALISES  ----------------
C     ----------- CALCUL DE LA NORME D'ERREUR SUR LE MODE  -------------
C     ---------------- STOCKAGE DES VECTEURS PROPRES  ------------------
C     ------------------------------------------------------------------

C     --- POSITION MODALE NEGATIVE DES MODES INTERDITE
      KNEGA = 'NON'
      NPARR = NBPARR
      IF (TYPCON.EQ.'MODE_ACOU') NPARR = 7
      IF ((.NOT.LC).AND.(LKR)) THEN
        CALL VPPARA(MODES,TYPCON,KNEGA,LRAIDE,LMASSE,LAMOR,
     &              MXRESF,NEQ,NCONV,OMECOR,ZI(LDDL),ZI(LPROD),
     &              ZR(LVEC),CBID, NBPARI, NPARR, NBPARK, NOPARA,'    ',
     &              ZI(LRESUI), ZR(LRESUR), ZK24(LRESUK),KTYP)
      ELSE
        CALL VPPARA(MODES,TYPCON,KNEGA,LRAIDE,LMASSE,LAMOR,
     &              MXRESF,NEQ,NCONV,OMECOR,ZI(LDDL),ZI(LPROD),
     &              RBID,ZC(LVEC), NBPARI, NPARR, NBPARK, NOPARA,'    ',
     &              ZI(LRESUI), ZR(LRESUR), ZK24(LRESUK),KTYP)
      ENDIF

C     --- IMPRESSIONS LIEES A LA METHODE ---
      CALL VPWECF (' ', TYPRES, NCONV, MXRESF, ZI(LRESUI), ZR(LRESUR),
     &  ZK24(LRESUK), LAMOR,KTYP)
      CALL TITRE

C     ------------------------------------------------------------------
C     ----------- CONTROLE DE VALIDITE DES MODES CALCULES  -------------
C     ------------------------------------------------------------------

      CALL GETVTX('VERI_MODE','STOP_ERREUR',1,1,1,OPTIOV,LMF)
      IF (OPTIOV.EQ.'OUI') THEN
        CTYP = 'E'
      ELSE
       CTYP = 'A'
      ENDIF

      CALL GETVR8('VERI_MODE','SEUIL',1,1,1,SEUIL,LMF)
      CALL GETVR8('VERI_MODE','PREC_SHIFT',1,1,1,PRECDC,LMF)
      CALL GETVTX('VERI_MODE','STURM',1,1,1,OPTIOV,LMF)
      IF (OPTIOV.EQ.'NON') THEN
        OPTIOV = ' '
      ELSE
        OPTIOV = OPTIOF
        IF ((LC).OR.(.NOT.LKR)) THEN
          OPTIOV = ' '
          CALL U2MESS('I','ALGELINE2_73')
        ENDIF
      ENDIF

      LMAT(1) = LRAIDE
      LMAT(2) = LMASSE
      LMAT(3) = LMTPSC
      CALL VPCNTL
     &  (CTYP, MODES, OPTIOV, OMEMIN, OMEMAX, SEUIL, NCONV, ZI(LRESUI),
     &   LMAT, OMECOR, PRECDC, IERX, VPINF, VPMAX, NPREC, ZR(LRESUR),
     &   ZR(LRESUR+3*MXRESF), ZR(LRESUR+MXRESF), TYPRES, STURM, NBLAGR)
      CALL GETVTX('VERI_MODE','STOP_ERREUR',1,1,1,OPTIOV,LMF)

      IF ((OPTIOV.EQ.'OUI').AND.(IERX.NE.0))
     &  CALL U2MESS('F','ALGELINE2_74')

      IF (FLAGE) CALL ASSERT(.FALSE.)
 999  CONTINUE

C     ------------------------------------------------------------------
C     ----------- CALCUL DE SENSIBILITE                   --------------
C     ------------------------------------------------------------------
      CALL GETVID(' ','SENSIBILITE',1,IERD,1,K8BID,IRET)
      IF (IRET.NE.0) THEN
        IF ((LKR).AND.(.NOT.LC)) THEN
          CALL SEMORE(LRAIDE,LAMOR,LMASSE,NEQ,MXRESF,NCONV,
     &            ZR(LRESUR),ZR(LVEC),
     &            NBPARI,NBPARR,NBPARK,NBPARA,NOPARA,
     &            ZI(LRESUI),ZK24(LRESUK))
        ELSE
          CALL SEMOCO(LRAIDE,LAMOR,LMASSE,NEQ,MXRESF,NCONV,
     &            ZR(LRESUR),ZC(LVEC),
     &            NBPARI,NBPARR,NBPARK,NBPARA,NOPARA,
     &            ZI(LRESUI),ZK24(LRESUK))
        ENDIF
      ENDIF

C     ------------------------------------------------------------------

 9999 CONTINUE
      CALL JEDEMA()
C
C     FIN DE OP0045
C
      END

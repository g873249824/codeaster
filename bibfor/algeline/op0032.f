      SUBROUTINE OP0032()
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 19/12/2011   AUTEUR BERRO H.BERRO 
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
C     EIGENVALUE-COUNTING METHODS FOR GEP OR QEP
C     ------------------------------------------------------------------
C RESPONSABLE BOITEAU O.BOITEAU
C TOLE CRP_20 
C
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16              ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                  ZK32
      CHARACTER*80                                            ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER      ISLVK,ISLVI,JREFA,NPREC,ITEST,NMULTC,LAMOR,
     &             EXPO,PIVOT1,PIVOT2,MXDDL,NBRSS,IERD,I,II,IFAPM,
     &             NBLAGR,NBCINE,NEQACT,NEQ,LTYPME,NITERC,
     &             LTYPRE,L,LBRSS,LMASSE,LRAIDE,LDDL,LDYNAM,NK,
     &             LPROD,IRET,ICOMP,IERX,NBFREQ,KREFA,
     &             IFM,NIV,NBTETC,NAUX,NBTET0,NBTET1,NBMODE(1),
     &             NBTET2,NBEV0,NBEV1,NBEV2,MITERC,IARG,IBID
      REAL*8       OMEGA2,OMGMIN,OMGMAX,OMIN,OMAX,FCORIG,OMECOR,RAUX,
     &             FMIN,FMAX,PRECDC,FREQOM,MANTIS,RAYONC,DIMC1,
     &             CALPAR(2),CALPAC(3),CALPAF(2),RBID
      COMPLEX*16   CENTRC,ZIMC1,CBID
      LOGICAL      ULEXIS,LTEST,LC 
      CHARACTER*1  TYPEP,TPPARN(1),TPPARR(2),TPPARC(3),TPPARF(2)
      CHARACTER*3  IMPR
      CHARACTER*8  TYPCON,TYPMET,TYPCHA,TABLE
      CHARACTER*16 CONCEP,NOMCMD,TYPMOD,
     &             NMPARN(1),NMPARR(2),NMPARC(3),NMPARF(2)
      CHARACTER*19 MASSE,RAIDE,DYNAM,SOLVEU,AMOR,MATREF
      CHARACTER*24 VALK(2),METRES,K24RC,KBID
      PARAMETER   ( MXDDL=1,MITERC=10000,NMULTC=2)
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFMAJ()
      CALL INFNIV(IFM,NIV)

C-----------------------------------------------------------------------
C------------------ INITIALIZATIONS/READING OF THE USER-DATA -----------
C-----------------------------------------------------------------------


C     --- FOR SAVE TIME IN FACTORIZATION PROCEDURE OF 'STURM' ---
      EXPO=-9999      
      FMIN = 0.D0

C     --- OUTPUT CONCEPT ---
      CALL GETRES( TABLE , CONCEP , NOMCMD )

C     --- READ OF MATRICES, CHECK OF REFERENCES ---
C     --- COMPUTATION OF THE MATRIX DESCRIPTORS ---

      CALL GETVID(' ','MATR_A',1,IARG,1,RAIDE,L)
      CALL GETVID(' ','MATR_B',1,IARG,1,MASSE,L)
      AMOR=' '
      CALL GETVID(' ','MATR_C',1,IARG,1,AMOR,LAMOR)
      IF (LAMOR.EQ.0) THEN
        LC=.FALSE.
      ELSE
        LC=.TRUE.
      ENDIF
      CALL VRREFE(MASSE,RAIDE,IRET)
      IF ( IRET .NE. 0 ) THEN
        VALK(1) = RAIDE
        VALK(2) = MASSE
        CALL U2MESK('F','ALGELINE2_30', 2 ,VALK)
      ENDIF
      CALL MTDSCR(MASSE)
      CALL JEVEUO(MASSE//'.&INT','E',LMASSE)
      CALL MTDSCR(RAIDE)
      CALL JEVEUO(RAIDE//'.&INT','E',LRAIDE)
C   --- REFERENCE MATRICE TO BE USE AS A PATTERN FOR BUILDING THE ---
C   --- DYNAMIC MATRICES (THE ISSUE IS SYMMETRIC OR NOT)          ---
      MATREF=RAIDE
      IF (ZI(LMASSE+4).EQ.0) MATREF=MASSE
      IF (ZI(LRAIDE+4).EQ.0) MATREF=RAIDE        
      IF (LC) THEN
        CALL MTDSCR(AMOR)
        CALL JEVEUO(AMOR//'.&INT','E',LAMOR)
        IF (ZI(LAMOR+4).EQ.0) MATREF=AMOR
      ENDIF

C     --- READING/TREATEMENT SD LINEAR SOLVER  ---
      CALL JEVEUO(RAIDE//'.REFA','L',JREFA)
      SOLVEU='&&OP0032.SOLVEUR'
      CALL CRESOL(SOLVEU)
      CALL JEVEUO(SOLVEU//'.SLVK','L',ISLVK)
      CALL JEVEUO(SOLVEU//'.SLVI','L',ISLVI)
      NPREC=ZI(ISLVI)
      METRES=ZK24(ISLVK)
      IF ((METRES(1:4).NE.'LDLT').AND.(METRES(1:8).NE.'MULT_FRO').AND.
     &    (METRES(1:5).NE.'MUMPS')) CALL U2MESS('F','ALGELINE5_71')


C     --- TYPE OF EIGENVALUE-COUNTING METHOD ---
      CALL GETVTX('COMPTAGE','METHODE',1,IARG,1,TYPMET,LTYPME)

C     --- AUTOMATIC PARAMETRIZATION WITH 'AUTO'                 ---
      IF (TYPMET(1:4).EQ.'AUTO') THEN
        IF (ZI(LMASSE+3)*ZI(LMASSE+4)*ZI(LRAIDE+3)*ZI(LRAIDE+4).NE.1
     &      .OR.LC) THEN
          TYPMET='APM'    
        ELSE
          TYPMET='STURM'
        ENDIF
      ENDIF

C     --- KIND OF COMPUTATION : REAL (GEP), DYNAMIC OR BUCKLING    ---
      CALL GETVTX(' ','TYPE_MODE',1,IARG,1,TYPMOD,LTYPRE)
      IF (TYPMOD(1:4).EQ.'REEL') THEN
        CALL GETVR8(' ','FREQ_MIN' ,1,IARG,1,FMIN,L)
        CALL GETVR8(' ','FREQ_MAX' ,1,IARG,1,FMAX,L)
        OMIN = OMEGA2(FMIN)
        OMAX = OMEGA2(FMAX)
        CALPAR(1) = FMIN
        CALPAR(2) = FMAX
      ELSE IF (TYPMOD(1:8).EQ.'COMPLEXE') THEN
        CALL GETVTX(' ','FREQ_TYPE_CONTOUR',1,IARG,1,TYPCON,L)
        CALL GETVR8(' ','FREQ_RAYON_CONTOUR',1,IARG,1,RAYONC,L)
        CALL GETVC8(' ','FREQ_CENTRE_CONTOUR',1,IARG,1,CENTRC,L)
        CALPAC(1) = DBLE(CENTRC)
        CALPAC(2) = DIMAG(CENTRC)    
        CALPAC(3) = RAYONC     
      ELSE IF (TYPMOD(1:10).EQ.'FLAMBEMENT') THEN
        CALL GETVR8(' ','CHAR_CRIT_MIN' ,1,IARG,1,OMIN,L)
        CALL GETVR8(' ','CHAR_CRIT_MAX' ,1,IARG,1,OMAX,L)
        CALPAF(1) = OMIN
        CALPAF(2) = OMAX         
      ELSE
        CALL ASSERT(.FALSE.)      
      ENDIF

C     --- TEMPORARY EXCLUSION RULES                             --- 
C     --- + DEFAULT VALUES                                      ---
      IF ((TYPMOD(1:8).EQ.'COMPLEXE').AND.
     &    (TYPMET(1:3).NE.'APM')) THEN
        CALL U2MESS('I','ALGELINE4_20')
        TYPMET='APM'
      ENDIF
      IF ((TYPMOD(1:8).NE.'COMPLEXE').AND.
     &    (TYPMET(1:5).NE.'STURM')) THEN
        CALL U2MESS('I','ALGELINE4_20')
        TYPMET='STURM'
      ENDIF
      
C     --- GET THE PARAMETERS OF THE METHOD                      --- 
C     --- INITIALIZATION JUST IN CASE                           ---
      FCORIG=1.D-2
      PRECDC=1.D-2
      NBRSS=5
      NBTETC=40
      NITERC=3     
      IF (TYPMET(1:5).EQ.'STURM') THEN
        CALL GETVR8('COMPTAGE','SEUIL_FREQ',1,IARG,1,FCORIG,L)
        CALL GETVR8('COMPTAGE','PREC_SHIFT',1,IARG,1,PRECDC,L)
        CALL GETVIS('COMPTAGE','NMAX_ITER_SHIFT',1,IARG,1,NBRSS,LBRSS)
        IF (OMIN.GE.OMAX) CALL U2MESS('F','ALGELINE2_29')
      ELSE IF (TYPMET(1:3).EQ.'APM') THEN      
        CALL GETVIS('COMPTAGE','NBPOINT_CONTOUR',1,IARG,1,NBTETC,L)
        CALL GETVIS('COMPTAGE','NMAX_ITER_CONTOUR',1,IARG,1,NITERC,L)
C     --- TEMPORARY, WE UNPLUG THE USE OF ROMBOUT METHOD, IT NEEDS ---
C     --- TO BE MORE RELIABLE                                      ---
        TYPCHA='LDLT'
C        TYPCHA='ROMBOUT'
C        CALL GETVTX('COMPTAGE','POLYNOME_CHARAC',1,IARG,1,TYPCHA,L)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF

C-----------------------------------------------------------------------
C-------------------- EXCLUSION RULES, PARTICULAR CASES ----------------
C-----------------------------------------------------------------------


C     --- EXCLUSION RULE IF NONSYMETRIC OR COMPLEXE GEP OR QEP  ---
      IF ((ZI(LMASSE+3)*ZI(LMASSE+4)*ZI(LRAIDE+3)*ZI(LRAIDE+4).NE.1
     &      .OR.LC)) THEN
        IF (TYPMOD(1:8).NE.'COMPLEXE')
     &    CALL U2MESS('F','ALGELINE4_10')
      ENDIF

C     --- CURRENT SCOPE OF USE OF THE OPTION TYPCHA='ROMBOUT'   ---
      IF ((TYPMET(1:3).EQ.'APM').AND.(TYPCHA(1:7).EQ.'ROMBOUT')) THEN
        IF (LC.OR.(ZK24(JREFA+9)(1:4).EQ.'GENE').OR.
     &     (ZI(LMASSE+3)*ZI(LMASSE+4)*ZI(LRAIDE+3)*ZI(LRAIDE+4).NE.1))
     &    CALL U2MESS('F','ALGELINE4_17')
      ENDIF


C     --- PARTICULAR CASE 1: METHODE='APM'+MUMPS, WE FORCE MF   ---
C     --- OR LDLT DEPENDING ON WHETHER MATRICE IS ASSEMBLED OR  ---
C     --- GENERALIZED                                           ---
      IF ((TYPMET(1:3).EQ.'APM').AND.(METRES(1:5).EQ.'MUMPS'))
     &  CALL CRSVL3(SOLVEU,NPREC,RAIDE)
      NPREC=ZI(ISLVI)
      METRES=ZK24(ISLVK)


C-----------------------------------------------------------------------
C-------------------------- PRE-TRAITEMENTS ----------------------------
C-----------------------------------------------------------------------

C     --- PREPARATION FOR THE COMPUTATION OF THE DYNAMIC MATRIX --- 
C     --- IN GEP ONLY DYNAM, IN QEP DYNAM            ---    
      IF ((TYPMET(1:5).EQ.'STURM').OR.
     &   ((TYPMET(1:3).EQ.'APM').AND.(TYPCHA(1:4).EQ.'LDLT'))) THEN
        DYNAM = '&&OP0032.MATR_DYNAM'
        IF (TYPMET(1:5).EQ.'STURM') THEN
C     --- IF STURM TEST, DYNAM'TYPE IS THE SAME AS RAIDE'S ONE: ---
C     --- OFTEN REAL                                            ---
          CALL MTDEFS(DYNAM,RAIDE,'V',' ')
        ELSE
C     --- IF APM TEST, DYNAM'TYPE IS ALWAYS COMPLEX.            ---
          CALL MTDEFS(DYNAM,MATREF,'V','C')
        ENDIF
        CALL JEVEUO(DYNAM(1:19)//'.REFA','E',KREFA)
        ZK24(KREFA-1+7)=SOLVEU
        CALL MTDSCR(DYNAM)
        CALL JEVEUO(DYNAM(1:19)//'.&INT','E',LDYNAM)
      ENDIF
      
C     --- COMPUTATION OF THE LAGRANGE MULTIPLIERS ---
      IF (TYPMET(1:5).EQ.'STURM') THEN
        NEQ = ZI(LRAIDE+2)
        CALL WKVECT('&&OP0032.POSITION.DDL','V V I',NEQ*MXDDL,LDDL)
        CALL WKVECT('&&OP0032.DDL.BLOQ.CINE','V V I',NEQ,LPROD)
        CALL VPDDL(RAIDE, MASSE, NEQ, NBLAGR, NBCINE, NEQACT, ZI(LDDL),
     &             ZI(LPROD),IERD)
        OMECOR = OMEGA2(FCORIG)
      ENDIF

C-----------------------------------------------------------------------
C-----------------------------STURM METHOD -----------------------------
C-----------------------------------------------------------------------
      IF (TYPMET(1:5).EQ.'STURM') THEN
C     --- STEP1: STURM WITH THE LOWER BOUND ---
        OMGMIN = OMIN
        ICOMP = 0
  10    CONTINUE
        CALL VPSTUR(LRAIDE,OMGMIN,LMASSE,LDYNAM,MANTIS,
     &              EXPO,PIVOT1,IERX,SOLVEU)
        IF (IERX .NE. 0 ) THEN
          IF (ABS(OMGMIN) .LT. OMECOR) THEN
            OMGMIN=-OMECOR
            IF (TYPMOD(1:4).EQ.'REEL') THEN
              WRITE(IFM,1600) FREQOM(OMGMIN)
            ELSE
              WRITE(IFM,3600) OMGMIN
            ENDIF
          ELSE
            IF (OMGMIN .GT. 0.D0) THEN
              OMGMIN = (1.D0-PRECDC) * OMGMIN
            ELSE
              OMGMIN = (1.D0+PRECDC) * OMGMIN
            ENDIF
          ENDIF
          ICOMP = ICOMP + 1
          IF (ICOMP.GT.NBRSS) THEN
            CALL U2MESS('A','ALGELINE2_31')
          ELSE
            IF (TYPMOD(1:4).EQ.'REEL') THEN
              WRITE(IFM,1700) (PRECDC*100.D0),FREQOM(OMGMIN)
            ELSE
              WRITE(IFM,3700) (PRECDC*100.D0),OMGMIN
            ENDIF
            GOTO 10
          ENDIF
        ENDIF
C
C     --- STEP2: STURM WITH THE LOWER BOUND ---
        OMGMAX = OMAX
        ICOMP = 0
  20    CONTINUE
        CALL VPSTUR(LRAIDE,OMGMAX,LMASSE,LDYNAM,MANTIS,
     &              EXPO,PIVOT2,IERX,SOLVEU)
        IF (IERX .NE. 0 ) THEN
          IF (ABS(OMGMAX) .LT. OMECOR) THEN
            OMGMAX=OMECOR
            IF (TYPMOD(1:4).EQ.'REEL') THEN
              WRITE(IFM,1800) FREQOM(OMGMAX)
            ELSE
              WRITE(IFM,3800) OMGMAX
            ENDIF
          ELSE
            IF (OMGMAX .GT. 0.D0 ) THEN
              OMGMAX = (1.D0 + PRECDC) * OMGMAX
            ELSE
              OMGMAX = (1.D0 - PRECDC) * OMGMAX
            ENDIF
          ENDIF
          ICOMP = ICOMP + 1
          IF (ICOMP.GT.NBRSS) THEN
            CALL U2MESS('A','ALGELINE2_32')
          ELSE
            IF (TYPMOD(1:4).EQ.'REEL') THEN
              WRITE(IFM,1900) (PRECDC*100.D0),FREQOM(OMGMAX)
            ELSE
              WRITE(IFM,3900) (PRECDC*100.D0),OMGMAX
            ENDIF
            GOTO 20
          ENDIF
        ENDIF

C-----------------------------------------------------------------------
C------------------------ ARGUMENT PRINCIPAL METHOD --------------------
C-----------------------------------------------------------------------
C   --- COMBO OF THE WORK OF H.J.JUNG (HYUNDAI)/O.BERTRAND (PHD INRIA)
      ELSE IF (TYPMET(1:3).EQ.'APM') THEN

C   --- VALUE TO START SOME SELF-TESTING PROCEDURES: ONLY FOR ---
C   --- DEVELOPPERS AND FOR DEBBUGING PHASE                   ---
        LTEST=.FALSE.
        ITEST=0
C       LTEST=.TRUE.

C   --- FOR PRINT IN THE FILE IFAPM THE DISPLAY Z/ARG(PC(Z)) ONLY  ---
C   --- FOR DEBUGGING ISSUES                                       ---
        IFAPM=18
        IMPR='OUI'
        IMPR='NON'

C   --- FOR TEST ISSUE ONLY (SEE APM012/APTEST)---
        IF ((LTEST).AND.(TYPCHA(1:7).EQ.'ROMBOUT')) THEN
          IF (ITEST.EQ.3) THEN
            NK=20
          ELSE IF (ITEST.EQ.4) THEN
            NK=10
          ELSE IF (ITEST.EQ.1) THEN
            NK=4
          ELSE IF (ITEST.EQ.0) THEN
            NK=2
          ENDIF
        ELSE
          NK=ZI(LMASSE+2)
        ENDIF
C   --- STEPS 0/1/2 OF THE APM ALGORITHM IF WE USE ROMBOUT VARIANT ---
        IF (TYPCHA(1:7).EQ.'ROMBOUT')     
     &    CALL APM012(NK,K24RC,LTEST,ITEST,RAYONC,CENTRC,LRAIDE,
     &                LMASSE,SOLVEU)

C   --- STEPS 3, 4 AND 5 OF THE APM ALGORITHM
C   --- ITERATION LOOP TO DETERMINE THE STABILIZED NUMBER OF   ---
C   --- EIGENVALUES. TRICKS TO LIMIT THE NUMBER OF COMPUTATION ---
C   --- WITH THE PARAMETERS MITERC AND NMULTC
        NBTET0=MIN(MITERC,MAX(1,NBTETC/NMULTC))
        NBTET1=MIN(MITERC,NBTETC)       
        NBTET2=MIN(MITERC,NBTETC*NMULTC)
        PIVOT1=0
        PIVOT2=-9999
        NBEV0=0
        NBEV1=0
        NBEV2=0
        DO 300 II=1,NITERC
          IF (II.EQ.1) THEN
            IF (IMPR.EQ.'NON')
     &        CALL APM345(NBTET0,TYPCON,RAYONC,CENTRC,NK,K24RC,NBEV0,
     &                  LTEST,TYPCHA,LRAIDE,LMASSE,LDYNAM,SOLVEU,LAMOR,
     &                  LC,IMPR,IFAPM)
              CALL APM345(NBTET1,TYPCON,RAYONC,CENTRC,NK,K24RC,NBEV1,
     &                  LTEST,TYPCHA,LRAIDE,LMASSE,LDYNAM,SOLVEU,LAMOR,
     &                  LC,IMPR,IFAPM)
          ENDIF
          IF (IMPR.EQ.'NON')
     &      CALL APM345(NBTET2,TYPCON,RAYONC,CENTRC,NK,K24RC,NBEV2,
     &                  LTEST,TYPCHA,LRAIDE,LMASSE,LDYNAM,SOLVEU,LAMOR,
     &                  LC,IMPR,IFAPM)

          WRITE(IFM,4000)NBTET0,NBTET1,NBTET2,NBEV0,NBEV1,NBEV2


C   --- SHIFT OF THE THREE LEVELS OF DISCRETISATIONS ---
C   --- TO CONTINUE THE HEURISTIC                    ---
          IF (((NBEV0.NE.NBEV1).OR.(NBEV1.NE.NBEV2)).AND.
     &        (IMPR.EQ.'NON')) THEN
            NBTET0=NBTET1
            NBTET1=NBTET2
            NBTET2=NMULTC*NBTET2
            
            NBEV0=NBEV1
            NBEV1=NBEV2

C   --- ERROR MESSAGES      
            IF (NBTET2.GT.MITERC)
     &        CALL U2MESI('F','ALGELINE4_13',1,MITERC)
            IF (II.EQ.NITERC) CALL U2MESI('F','ALGELINE4_14',1,NITERC)

          ELSE IF (IMPR.EQ.'NON') THEN
C    --- THE HEURISTIC CONVERGES
            PIVOT2=NBEV1
            WRITE(IFM,4010)
            GOTO 301
          ELSE IF (IMPR.EQ.'OUI') THEN
            WRITE(IFM,4020)
            CALL ASSERT(.FALSE.)
          ENDIF
  300   CONTINUE
  301   CONTINUE
        IF (TYPCHA(1:7).EQ.'ROMBOUT') CALL JEDETR(K24RC)
        IF (PIVOT2.LT.0) CALL U2MESS('F','ALGELINE4_22')
                     
      ELSE
C   --- ILLEGAL OPTION ---
        CALL ASSERT(.FALSE.)
      ENDIF

C-----------------------------------------------------------------------
C-------------------------- POSTTRAITEMENTS ----------------------------
C-----------------------------------------------------------------------

      IF ((TYPMET(1:5).EQ.'STURM').OR.
     &   ((TYPMET(1:3).EQ.'APM').AND.(TYPCHA(1:4).EQ.'LDLT'))) THEN
C   --- DESTRUCTION OF THE DYNAMIC MATRIX
        CALL DETRSD('MATR_ASSE',DYNAM)
      ENDIF

C   --- PRINT THE RESULTS TO THE MSG FILE AND SAVE  THE EVALUATED ---
C   --- NUMBER OF FREQUENCIES AS WELL AS THE CALCULATION PARAMS   ---
C   --- (FREQ_MIN, FREQ_MAX, ETC. ) TO AN SD_TABLE                ---

      IF (TYPMET(1:3).EQ.'APM') THEN
        TYPEP='C'
        IF (TYPCON(1:6).EQ.'CERCLE') THEN
          DIMC1=RAYONC
          ZIMC1=CENTRC
        ENDIF
      ELSE IF (TYPMET(1:5).EQ.'STURM') THEN
        TYPEP='R'
        TYPCON=' '
        DIMC1=0.D0
        ZIMC1=DCMPLX(0.D0,0.D0)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
      CALL VPECST(IFM,TYPMOD,OMGMIN,OMGMAX,PIVOT1,PIVOT2,
     &            NBFREQ,NBLAGR,TYPEP,TYPCON,DIMC1,ZIMC1)
     
      CALL TBCRSD (TABLE, 'G')
      CALL TITRE

      NMPARN(1) = 'NB_MODE'
      NMPARR(1) = 'FREQ_MIN'
      NMPARR(2) = 'FREQ_MAX'
      NMPARC(1) = 'CENTRE_R'
      NMPARC(2) = 'CENTRE_I'
      NMPARC(3) = 'RAYON'
      NMPARF(1) = 'CHAR_CRIT_MIN'
      NMPARF(2) = 'CHAR_CRIT_MAX'
      
      TPPARN(1) = 'I'
      TPPARR(1) = 'R'
      TPPARR(2) = 'R'
      TPPARC(1) = 'R'
      TPPARC(2) = 'R'
      TPPARC(3) = 'R'
      TPPARF(1) = 'R'
      TPPARF(2) = 'R'
      
      NBMODE(1) = NBFREQ
      
      CALL TBAJPA (TABLE,1,NMPARN,TPPARN)
      CALL TBAJPA (TABLE,2,NMPARR,TPPARR)
      CALL TBAJPA (TABLE,3,NMPARC,TPPARC)
      CALL TBAJPA (TABLE,2,NMPARF,TPPARF)

      CALL TBAJLI (TABLE,1,NMPARN,NBMODE,RBID,CBID,KBID,0)
      
      IF (TYPMOD(1:4).EQ.'REEL') THEN
        CALL TBAJLI (TABLE,2,NMPARR,IBID,CALPAR,CBID,KBID,1)
      ELSE IF (TYPMOD(1:8).EQ.'COMPLEXE') THEN
        CALL TBAJLI (TABLE,3,NMPARC,IBID,CALPAC,CBID,KBID,1)
      ELSE IF (TYPMOD(1:10).EQ.'FLAMBEMENT') THEN
        CALL TBAJLI (TABLE,2,NMPARF,IBID,CALPAF,CBID,KBID,1)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
      
      CALL JEDEMA()

C-----------------------------------------------------------------------
C-------------------------- FORTRAN PRINT FORMAT -----------------------
C-----------------------------------------------------------------------
 1600 FORMAT('LA BORNE MINIMALE EST INFERIEURE A LA FREQUENCE ',
     &       'DE CORPS RIGIDE ON LA MODIFIE, ELLE DEVIENT',1PE12.5)
 1700 FORMAT('ON DIMINUE LA BORNE MINIMALE DE: ',1PE12.5,' POURCENTS',/,
     &        'LA BORNE MINIMALE DEVIENT: ',6X,1PE12.5)
 1800 FORMAT('LA BORNE MAXIMALE EST INFERIEURE A LA FREQUENCE ',
     &       'DE CORPS RIGIDE ON LA MODIFIE, ELLE DEVIENT: ',1PE12.5)
 1900 FORMAT('ON AUGMENTE LA BORNE MAXIMALE DE: ',1PE12.5,' POURCENTS',/
     &       ,'LA BORNE MAXIMALE DEVIENT:',8X,1PE12.5,/)
 3600 FORMAT('LA BORNE MINIMALE EST INFERIEURE A LA CHARGE CRITIQUE ',
     &       'NULLE ON LA MODIFIE, ELLE DEVIENT',1PE12.5)
 3700 FORMAT('ON DIMINUE LA BORNE MINIMALE DE: ',1PE12.5,' POURCENTS',/,
     &        'LA BORNE MINIMALE DEVIENT: ',6X,1PE12.5)
 3800 FORMAT('LA BORNE MAXIMALE EST INFERIEURE A LA CHARGE CRITIQUE ',
     &       'NULLE ON LA MODIFIE, ELLE DEVIENT: ',1PE12.5)
 3900 FORMAT('ON AUGMENTE LA BORNE MAXIMALE DE: ',1PE12.5,' POURCENTS',/
     &       ,'LA BORNE MAXIMALE DEVIENT:',8X,1PE12.5,/)
 4000 FORMAT('(METHODE APM) POUR LES 3 NIVEAUX DE DISCRETISATION '
     &       'SUIVANTS',/,
     &       ' --- ',I5,' --- ',I5,' --- ',I5,' ---',/,
     &       ' NOMBRE DE VALEURS PROPRES DETECTEES ',/,
     &       ' --- ',I5,' --- ',I5,' --- ',I5,' ---')
 4010 FORMAT('(METHODE APM) CONVERGENCE DE L''HEURISTIQUE ')
 4020 FORMAT('(METHODE APM) ATTENTION CALCUL DE TEST POUR IMPRIMER LA',
     &       ' COURBE DES NOMBRES DE TOURS ')

      END

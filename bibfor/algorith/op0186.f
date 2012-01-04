      SUBROUTINE OP0186()
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/01/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE                            DURAND C.DURAND
C TOLE CRP_20
C ----------------------------------------------------------------------
C     COMMANDE:  THER_NON_LINE

C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       11/02/02 (OB): IMPLANTATION DES CALCULS DE SENSIBILITE.
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
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
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------

C 0.2  ==> ARGUMENTS

C 0.3. ==> VARIABLES LOCALES
      LOGICAL LOSTAT,MATCST,COECST,REASMA,ARRET,CONVER,ITEMAX,
     &        REASVC,REASVT,REASMT,REASRG,REASMS,PREM,LSECHA,LASSEM,
     &        RECHLI,DIDERN,FINPAS,LEVOL,FORCE,LNONL
      INTEGER PARMEI(2),PARCRI(3),NUMINS,K,IERD,
     &        ICORET,NBCHAM,ITERHO,ITMAX,
     &        IFM,NIV,NOPT,NEQ,ITERAT,TYPESE,
     &        JTEMPP,JTEMPM,JTEMP,NBPASE,NRPASE,JTEMPI,I,JCRR
      INTEGER ITAB(2)
      INTEGER ETAUSR,NMSENN
      REAL*8 PARMER(2),TPSTHE(6),DELTAT,TIMET,TIMTDT,TPS1(4),
     &       TPS2(4),TPS3(4),TPEX,PARCRR(2),THETA,KHI,RHO,TESTR,TESTM,
     &       PARA(2),R8VIDE,DIINST,INSTAP,TCONSO
      REAL*8 RTAB(2),R8BID
      CHARACTER*1 CREAS,BASE
      CHARACTER*3 KREAS
      CHARACTER*4 TYPCAL
      CHARACTER*8 EVOLSC,NOPASE,MAILLA
      CHARACTER*8 K8BID
      CHARACTER*13 INPSCO
      CHARACTER*19 SDOBSE
      CHARACTER*16 TYSD
      CHARACTER*19 LISCHA,LISCH2
      CHARACTER*19 SOLVEU,MAPREC,SDDISC,SDCRIT
      CHARACTER*24 MODELE,MATE,CARELE,FOMULT,CHARGE,INFOCH,RESULT,TIME,
     &             TMPCHI,TMPCHF,COMPOR,VTEMP,VTEMPM,VTEMPP,
     &             VTEMPR,VEC2ND,VEC2NI,LISOPT,
     &             NUMEDD,MEDIRI,MATASS,CNDIRP,CNCHCI,
     &             CNRESI,VABTLA,VHYDR,VHYDRP,VAPRIN,VAPRMO
      CHARACTER*24 STYPSE,SDSENS,SDIETO,TPSCVT
      CHARACTER*76 FMT2,FMT3,FMT4
      CHARACTER*85 FMT1
      CHARACTER*8  K8B
      COMPLEX*16   C16BID

C ----------------------------------------------------------------------
      DATA LISCHA/'&&OP0186.LISCHA'/
      DATA SDCRIT/'&&OP0186.CRITERE'/
      DATA SOLVEU/'&&OP0186.SOLVEUR'/
      DATA MAPREC/'&&OP0186.MAPREC'/
      DATA RESULT/' '/
      DATA CNDIRP/1*' '/
      DATA CNCHCI/1*' '/
      DATA VEC2ND/'&&OP0186.2ND'/
      DATA VEC2NI/'&&OP0186.2NI'/
      DATA TMPCHI,TMPCHF/'&&OP0186.TCHI','&&OP0186.TCHF'/
      DATA VHYDR,VHYDRP/'&&OP0186.HY','&&OP0186.HYP'/
      DATA MEDIRI/' '/
      DATA MATASS/'&&MTHASS'/
      DATA FMT1/'(85(''-''))'/
      DATA FMT2/'(A,1X,A,6X,A,9X,A,6X,A,3X,A,3X,A,1X,A)'/
      DATA FMT3/'(A,16X,A,8X,A,6X,A,3X,A,6X,A,4X,A)'/
      DATA FMT4/'(A,12X,A,2X,A,17X,A,9X,A,4X,A)'/
      DATA SDDISC            /'&&OP0186.PARTPS'/
      DATA SDOBSE            /'&&OP0186.OBSER'/
      DATA SDSENS            /'&&OP0186.SDSENS'/
      DATA SDIETO            /'&&OP0186.SDIETO'/
C ----------------------------------------------------------------------

C     MESURE DE TEMPS CPU :

C      1 : PAS DE TEMPS
C      2 : ITERATIONS
C      3 : ACTUALISATIONS ET ARCHIVAGE

C ----------------------------------------------------------------------

      CALL JEMARQ()



C **********************************************************************
C                    RECUPERATION DES OPERANDES
C **********************************************************************

C--- RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)

C --- LECTURE DES OPERANDES DE LA COMMANDE
C
      CALL NXLECT(RESULT,MODELE,MATE  ,CARELE,MATCST,
     &            COECST,FOMULT,LISCHA,CHARGE,INFOCH,
     &            PARMEI,PARMER,SOLVEU,PARCRI,PARCRR,
     &            LISOPT,NOPT  ,COMPOR,EVOLSC,SDSENS)
      PARA(1) = PARMER(1)
      ITMAX   = PARCRI(3)
      RECHLI  = .FALSE.
      NBPASE  = NMSENN(SDSENS)
      CALL NTINPS(SDSENS,INPSCO)



C EST-ON DANS UN CALCUL DE SECHAGE ?
      IF (EVOLSC(1:1).NE.' ') THEN
        LSECHA = .TRUE.
        IF (NBPASE.GT.0) THEN
          CALL U2MESS('F','SENSIBILITE_31')
        END IF
      ELSE
        LSECHA = .FALSE.
      END IF
C --- CE BOOLEEN ARRET EST DESTINE AUX DEVELOPPEUR QUI VOUDRAIENT
C --- FORCER LE CALCUL MEME SI ON N'A PAS CONVERGENCE (ARRET=TRUE)
      ARRET = .FALSE.
      IF (PARMEI(2).GT.0) RECHLI = .TRUE.

C **********************************************************************
C    INITIALISATIONS ET DUPLICATION DES STRUCTURES DE DONNEES
C **********************************************************************
C
C --- INITIALISATIONS
C
      CALL NXINIT(RESULT,MODELE,MATE  ,CARELE,COMPOR,
     &            LISCHA,LISCH2,SOLVEU,PARA  ,NUMEDD,
     &            LOSTAT,LEVOL ,LNONL ,SDDISC,SDSENS,
     &            SDIETO,VHYDR ,SDOBSE,MAILLA,SDCRIT,
     &            TIME  )
      CALL ASSERT(LNONL)
C
      IF (LOSTAT) THEN
        NUMINS=0
      ELSE
        NUMINS=1
      ENDIF
      DELTAT=-1.D150

C --- CREATION DES OBJETS DE TRAVAIL ET DES STRUCTURES DE DONNEES
      CALL NTNSLE(SDSENS,0     ,'VTEMP ',VTEMP )
C --- BIZARRE: VTEMPM et VTEMPP SONT INTERVERTIS
C --- SI PAS INTERVERTIS: NOOK en SENSIBILTIE !
      CALL NTNSLE(SDSENS,0     ,'VTEMPM',VTEMPP)
      CALL NTNSLE(SDSENS,0     ,'VTEMPP',VTEMPM)
      CALL NTNSLE(SDSENS,0     ,'VTEMPR',VTEMPR)
      CALL COPISD('CHAMP_GD','V',VTEMP(1:19),VTEMPM(1:19))
      CALL COPISD('CHAMP_GD','V',VTEMP(1:19),VTEMPP(1:19))
      CALL COPISD('CHAMP_GD','V',VTEMP(1:19),VTEMPR(1:19))
      CALL COPISD('CHAMP_GD','V',VTEMP(1:19),VEC2ND(1:19))
      CALL COPISD('CHAMP_GD','V',VTEMP(1:19),VEC2NI(1:19))
      CALL COPISD('CHAMP_GD','V',VHYDR(1:19),VHYDRP(1:19))

C --- CALCUL DES MATRICES ELEMENTAIRES DES DIRICHLETS
      TYPCAL = 'THER'
      CALL MEDITH(TYPCAL,MODELE,CHARGE,INFOCH,MEDIRI)

C **********************************************************************
C                 BOUCLE SUR LES PAS DE TEMPS
C **********************************************************************

      CALL UTTCPU('CPU.OP0186.1','INIT',' ')
      CALL UTTCPR('CPU.OP0186.1',4,TPS1)
      TPEX = TPS1(3)
      CALL UTTCPU('CPU.OP0186.2','INIT',' ')
      CALL UTTCPU('CPU.OP0186.3','INIT',' ')
      CALL UTTCPR('CPU.OP0186.3',4,TPS3)
      PREM = .TRUE.
      REASRG = .FALSE.
      REASMS = .FALSE.
200   CONTINUE
C --- RECUPERATION DU PAS DE TEMPS ET DES PARAMETRES DE RESOLUTION

       IF (LOSTAT) THEN
          IF (.NOT.LEVOL) THEN
            INSTAP=0.D0
            DELTAT=-1.D150
            THETA=1.D0
            KHI=0.D0
          ELSE
            INSTAP=DIINST(SDDISC, NUMINS)
            DELTAT=-1.D150
            THETA=1.D0
            KHI=0.D0
          ENDIF
        ELSE
          INSTAP = DIINST(SDDISC, NUMINS)
          DELTAT = INSTAP-DIINST(SDDISC, NUMINS-1)
          THETA=PARMER(1)
          KHI=1.D0
        ENDIF
        PARA(2) = DELTAT



C --- MATRICE TANGENTE REACTUALISEE POUR UN NOUVEAU DT

        REASMA = .TRUE.

          CALL UTTCPU('CPU.OP0186.1','DEBUT',' ')
          TPSTHE(1) = INSTAP
          TPSTHE(2) = DELTAT
          TPSTHE(3) = THETA
          TPSTHE(4) = KHI
          TPSTHE(5) = R8VIDE()
          TPSTHE(6) = R8VIDE()
          CALL U2MESG('I','MECANONLINE6_6',0,' ',0,0,1,INSTAP)
          WRITE (IFM,FMT1)
          WRITE (IFM,FMT2) '|','ITERATION','RESIDU','RESIDU',
     &      'ITERATION','COEFFICIENT','ACTUALISATION','|'
          WRITE (IFM,FMT3) '|','RELATIF','ABSOLU','RECH. LIN.',
     &      'RECH. LIN.','MATRICE','|'
          WRITE (IFM,FMT4) '|','RESI_GLOB_RELA','RESI_GLOB_MAXI','RHO',
     &      'TANGENTE','|'
          WRITE (IFM,FMT1)
          CALL JELIRA(VTEMPM(1:19)//'.VALE','LONMAX',NEQ,K8BID)

C **********************************************************************
C                 BOUCLE SUR LES RESOLUTIONS
C LE PREMIER PASSAGE, NRPASE=0, EST CELUI DU CALCUL STD NON-LINEAIRE,
C LES AUTRES SONT CEUX, LINEAIRES, DES CALCULS DE SENSIBILITE
C **********************************************************************
          LASSEM = .TRUE.
          DO 50 NRPASE = 0,NBPASE

C RECUPERATION DE:
C NOPASE --> NOM DU PARAMETRE SENSIBLE
C RESULT --> NOM DE LA SD RESULTAT
C EN STANDARD:
C VTEMP  --> T+,I+1BIS
C VTEMPP --> T-
C EN SENSIBILITE:
C VTEMP  --> (DT/DS)-
C VAPRIN --> T+
C VAPRMO --> T-
            CALL NTNSLE(SDSENS,NRPASE,'NOPASE',NOPASE)
            CALL NTNSLE(SDSENS,NRPASE,'RESULT',RESULT)
            CALL NTNSLE(SDSENS,NRPASE,'VTEMP ',VTEMP )
            IF (NBPASE.NE.0 .AND. .NOT.LOSTAT .AND. NRPASE.EQ.0) THEN
C CALCUL STD TRANSITOIRE AVEC SENSIBILITE A SUIVRE
C --- BIZARRE: VTEMPM et VTEMPP SONT INTERVERTIS
C --- SI PAS INTERVERTIS: NOOK en SENSIBILTIE !
              CALL NTNSLE(SDSENS,NRPASE,'VTEMPM',VTEMPP)
            END IF
            IF (NRPASE.GT.0) THEN
C CALCUL DE SENSIBILITE
              CALL NTNSLE(SDSENS,0,'VTEMP ',VAPRIN)
              CALL NTNSLE(SDSENS,0,'VTEMPM',VAPRMO)

C REPERAGE DU TYPE DE DERIVATION
              CALL NTTYSE(NBPASE,INPSCO,NOPASE,TYPESE,STYPSE)

              IF (TYPESE.EQ.1) THEN
C PB DERIVEE INSENSIBLE ==> ON N'A PAS A RESOUDRE DE SYSTEME, CAR LA
C SOLUTION EST NULLE. ON CREER DONC UN CHAMP SOLUTION NUL VTEMPM/VHYDRP
                CALL JEVEUO(VTEMPM(1:19)//'.VALE','E',JTEMPI)
                DO 10 I = 1,NEQ
                  ZR(JTEMPI+I-1) = 0.D0
   10           CONTINUE
C POUR DECLENCHER L'ASSEMBLAGE MATRICE POUR LA PROCHAINE SENSIBILITE
                IF (NRPASE.EQ.1) THEN
                  LASSEM = .FALSE.
                ENDIF
                CALL U2MESK('A','SENSIBILITE_72', 1, NOPASE)
                GO TO 40
              ELSE IF (TYPESE.EQ.-1) THEN
                CALL U2MESS('F','SENSIBILITE_22')
              END IF
            ELSE IF (NRPASE.EQ.0) THEN
C CALCUL STD
              TYPESE = 0
              STYPSE = ' '
            END IF

C --- RECUPERATION DU CHAMP DE TEMPERATURE A T ET T+DT POUR LE SECHAGE
C     LOIS SECH_GRANGER ET SECH_NAPPE
            IF (LSECHA) THEN
              CALL GETTCO(EVOLSC,TYSD)
              IF (TYSD(1:9).EQ.'EVOL_THER') THEN
                CALL DISMOI('F','NB_CHAMP_UTI',EVOLSC,'RESULTAT',NBCHAM,
     &                      K8BID,IERD)
                IF (NBCHAM.GT.0) THEN
                  TIMET = INSTAP
                  TIMTDT = INSTAP + DELTAT
                  BASE = 'V'
                  CALL RSINCH(EVOLSC,'TEMP','INST',TIMET,TMPCHI,
     &                        'CONSTANT','CONSTANT',1,BASE,ICORET)
                  IF (ICORET.GE.10) THEN
                    CALL U2MESG('F', 'ALGORITH8_94', 1, EVOLSC,
     &                           1, ICORET, 1, TIMET)
                  END IF
                  CALL RSINCH(EVOLSC,'TEMP','INST',TIMTDT,TMPCHF,
     &                        'CONSTANT','CONSTANT',1,BASE,ICORET)
                  IF (ICORET.GE.10) THEN
                    CALL U2MESG('F', 'ALGORITH8_94', 1, EVOLSC,
     &                           1, ICORET, 1, TIMTDT)
                  END IF
                ELSE
                  CALL U2MESK('F','ALGORITH8_99',1,EVOLSC)
                END IF
              END IF
            END IF
C RE-ASSEMBLAGE DES SECONDS MEMBRES DE VECHTH/VECHNL
            REASVC = .TRUE.
C RE-ASSEMBLAGE DES SECONDS MEMBRES DE VETNTH
            REASVT = .TRUE.
C RE-ASSEMBLAGE DE LA MATRICE:
C SAUF POUR UN CALCUL MULTI-SENSIBILITES POUR LEQUEL, A CHAQUE PAS DE
C TEMPS, ON NE REASSEMBLE PAS LA MATRICE DU SYST DERIVE LINEAIRE. SAUF
C APRES UN CALCUL INSENSIBLE SITUE AU PREMIER RANG.
            IF ((NRPASE.GT.1) .AND. LASSEM) THEN
              REASMT = .FALSE.
            ELSE
              REASMT = .TRUE.
              LASSEM = .TRUE.
            END IF

C ======================================================================
C  ACTUALISATION DES MATRICES ET VECTEURS POUR LE NOUVEAU PAS DE TEMPS
C ======================================================================

C --- ACTUALISATION DU CHARGEMENT A TMOINS
C EN STD:
C ON ASSEMBLE LES SECONDS MEMBRES CHAR_THER_LINEAIRE+CHAR_THER_NONLIN+
C CHAR_THER_EVOLNI EN BETA DANS VEC2ND (IDEM EN RHO_CP DANS VEC2NI)
C ON ASSEMBLE LA MATRICE A = TANGENTE (MTAN_*) + DIRICHLET
C EN SENSIBILITE:
C IDEM POUR LE SECOND MEMBRE (EN RHO_CP DANS VEC2ND) ET POUR LA MATRICE
C (OU ON REMPLACE (DT/DS)- PAR T+)
            CALL NXACMV(MODELE,MATE,CARELE,FOMULT,CHARGE,LISCHA,INFOCH,
     &                  NUMEDD,SOLVEU,LOSTAT,TIME,TPSTHE,REASVC,REASVT,
     &                  REASMT,REASRG,REASMS,CREAS,VTEMP,VHYDR,TMPCHI,
     &                  TMPCHF,VEC2ND,VEC2NI,MATASS,MAPREC,CNDIRP,
     &                  CNCHCI,MEDIRI,COMPOR,TYPESE,STYPSE,NOPASE,
     &                  VAPRIN,VAPRMO)

C RESOLUTION DU SYSTEME LINEAIRE EN SENSIBILITE NON INSENSIBLE
C ON RESOUT A(T+) * (DT/DS)+ = B(T-,T+,(DT/DS)-)
C A = MATASS, B=VEC2ND, SOLUTION=VTEMPM

            IF (TYPESE.NE.0) THEN
              CALL RESOUD(MATASS,MAPREC,VEC2ND,SOLVEU,CNCHCI,'V',VTEMPM,
     &                    ' ',0,R8BID,C16BID,.TRUE.)

C ON STOCKE LA SOLUTION VTEMPM DANS VTEMP
              GO TO 40
            END IF

C ======================================================================
C                        PHASE DE PREDICTION
C ======================================================================
C SECONDS MEMBRES ASSEMBLES B
C EN STATIONNAIRE: |VEC2ND - RESI_THER - (BT)*LAGRANGE|
C                  | DIRICHLET - B*TEMPERATURE INIT   |
C EN TRANSITOIRE : |            VEC2NI                |
C                  |           DIRICHLET              |
C SYSTEME LINEAIRE RESOLU:  A * (T+,1 - T-) = B
C SOLUTION: VTEMP= T- ET VTEMPM = T+,1

            CALL NXPRED(MODELE,MATE,CARELE,CHARGE,INFOCH,NUMEDD,SOLVEU,
     &                  LOSTAT,TIME,NEQ,MATASS,MAPREC,VTEMP,VTEMPM,
     &                  VTEMPP,VHYDR,VHYDRP,TMPCHI,TMPCHF,COMPOR,CNDIRP,
     &                  CNCHCI,VEC2ND,VEC2NI,PREM)
            PREM = .FALSE.

C ======================================================================
C              ITERATIONS DE LA METHODE DE NEWTON-RAPHSON
C ======================================================================

            ITERAT = 0
            ITEMAX = .FALSE.
            CONVER = .FALSE.

C --- REPRISE DE LA BOUCLE D'ITERATIONS DE NEWTON-RAPHSON

   20       CONTINUE

C --- DOIT ON REACTUALISER LA MATRICE TANGENTE

            CALL UTTCPU('CPU.OP0186.2','DEBUT',' ')
            ITERAT = ITERAT + 1
            REASMA = .FALSE.
            KREAS = 'NON'
            IF (ITERAT.GE.ITMAX) ITEMAX = .TRUE.
            IF ((PARMEI(1).NE.0)) THEN
              IF (MOD(ITERAT,PARMEI(1)).EQ.0) THEN
                REASMA = .TRUE.
                KREAS = 'OUI'
              END IF
            END IF

C ON ASSEMBLE LE SECOND MEMBRE B= |VEC2ND - RESI_THER - (BT)*LAGRANGE|
C                                 |             0                    |
C SYSTEME LINEAIRE RESOLU:  A * (T+,I+1 - T+,I) = B
C SOLUTION: VTEMPP = T+,I+1 - T+,I

            CALL NXNEWT(MODELE,MATE,CARELE,CHARGE,LISCHA,INFOCH,NUMEDD,
     &                  SOLVEU,TIME,NEQ,MATASS,MAPREC,CNCHCI,VTEMP,
     &                  VTEMPM,VTEMPP,VEC2ND,MEDIRI,CONVER,VHYDR,VHYDRP,
     &                  TMPCHI,TMPCHF,COMPOR,VABTLA,CNRESI,PARCRI,
     &                  PARCRR,REASMA,TESTR,TESTM)

C --- SI NON CONVERGENCE ALORS RECHERCHE LINEAIRE
C       (CALCUL DE RHO) SUR L INCREMENT VTEMPP
C --- ACTUALISATION DE LA TEMPERATURE VTEMPM AVEC L INCREMENT VTEMPP
C     MULTIPLIE PAR RHO
            RHO = 0.D0
            ITERHO = 0
            IF (.NOT.CONVER) THEN
              IF (RECHLI) THEN

C ON CALCULE LE RHO/ VTEMPR = T+,I+1BIS = T+,1 + RHO * (T+,I+1 - T+,I)
C MINIMISE VEC2ND - RESI_THER(T+,I+1BIS) - (BT)*LAGRANGE
                CALL NXRECH(MODELE,MATE,CARELE,CHARGE,INFOCH,NUMEDD,
     &                      TIME,NEQ,COMPOR,VTEMPM,VTEMPP,VTEMPR,
     &                      VTEMP,VHYDR,VHYDRP,TMPCHI,TMPCHF,VEC2ND,
     &                      VABTLA,CNRESI,RHO,ITERHO,PARMER,PARMEI)
              ELSE
                RHO = 1.D0
              END IF
              CALL JEVEUO(VTEMPP(1:19)//'.VALE','L',JTEMPP)
              CALL JEVEUO(VTEMPM(1:19)//'.VALE','E',JTEMPM)
              CALL JEVEUO(VTEMP(1:19)//'.VALE','L',JTEMP)

C SOLUTION: VTEMPM = VTEMPR = T+,I+1BIS
              DO 30 K = 1,NEQ
                ZR(JTEMPM+K-1) = ZR(JTEMPM+K-1) + RHO*ZR(JTEMPP+K-1)
   30         CONTINUE
            END IF

            WRITE (IFM,
     &      '(A,1X,I5,6X,1PE12.5,4X,1PE12.5,7X,I2,5X,1PE12.5,8X,A,6X,A)'
     &        ) '|',ITERAT,TESTR,TESTM,ITERHO,RHO,KREAS,'|'

            IF (ITEMAX .AND. .NOT.CONVER) THEN
              WRITE (IFM,FMT1)
              CALL U2MESS('I','MECANONLINE6_31')
            ENDIF
            CALL UTTCPU('CPU.OP0186.2','FIN',' ')
            CALL UTTCPR('CPU.OP0186.2',4,TPS2)
            IF ((.NOT.CONVER) .AND. (.NOT.ITEMAX)) THEN
              IF (2.D0*TPS2(4).GT.0.95D0*TPS2(1)-TPS3(4)) THEN
                WRITE (IFM,FMT1)
                ITAB(1) = NUMINS
                RTAB(1) = TPS2(4)
                RTAB(2) = TPS2(1)
                CALL UTEXCM(28,'DISCRETISATION2_79',0,K8B,1,ITAB,2,RTAB)
              ELSE
                GO TO 20
              END IF
            ELSE IF ((.NOT.CONVER) .AND. ITEMAX .AND. (.NOT.ARRET)) THEN
              WRITE (IFM,FMT1)
              ITAB(1) = NUMINS
              ITAB(2) = ITERAT
              CALL UTEXCM(22,'MECANONLINE_85', 0, K8B, 2, ITAB, 0, RTAB)
            END IF
            WRITE (IFM,FMT1)
C
C --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
C
            IF ( ETAUSR().EQ.1 ) THEN
               CALL SIGUSR()
            ENDIF
C
C ======================================================================
C                   ACTUALISATIONS ET ARCHIVAGE
C ======================================================================
C INDIRECTION POUR PB INSENSIBLE (TYPESE.EQ.1)
   40       CONTINUE

            CALL UTTCPU('CPU.OP0186.3','DEBUT',' ')

            IF (NRPASE.EQ.0) CALL COPISD('CHAMP_GD','V',VHYDRP(1:19),
     &                                   VHYDR(1:19))

C ==> ON DOIT GARDER LA TEMPERATURE DU PAS DE TEMPS PRECEDENT SI
C     TOUT CE QUI SUIT EST REUNI :
C  . IL Y AURA UN CALCUL DE DERIVEE
C  . ON EST EN TRANSITOIRE
C  . ON EST DANS LE CALCUL STANDARD
C VTEMP --> VTEMPP STRUCTURE RECONNUE COMME T-=VAPRMO POUR LE CALCUL
C DE SENSIBILITE QUI VA SUIVRE
            IF (NBPASE.NE.0 .AND. .NOT.LOSTAT .AND.
     &          NRPASE.EQ.0) CALL COPISD('CHAMP_GD','V',VTEMP(1:19),
     &                                   VTEMPP(1:19))
            IF (NIV.EQ.2) THEN
              WRITE (IFM,*)
              WRITE (IFM,*) '**************************************'
              WRITE (IFM,*) ' THER_NON_LINE: OP00186'
              WRITE (IFM,*)
              WRITE (IFM,*) ' T+ (OU DT/DS)+       :',VTEMP
              WRITE (IFM,*) ' T-                   :',VTEMPP
              WRITE (IFM,*)
            END IF

C ======================================================================
C -- PREPARATION DES PARAMETRES ARCHIVEES ------------------------------
C ======================================================================
            IF (CONVER) THEN
              CALL JEVEUO(SDCRIT(1:19)//'.CRTR','E',JCRR)
              ZR(JCRR+0) = ITERAT
              ZR(JCRR+1) = ITERHO
              ZR(JCRR+2) = TESTR
              ZR(JCRR+3) = TESTM
              ZR(JCRR+4) = RHO
            END IF

            FINPAS = DIDERN(SDDISC, NUMINS)

            CALL JEVEUO(VTEMPM(1:19)//'.VALE','L',JTEMPP)
            CALL JEVEUO(VTEMP(1:19)//'.VALE','E',JTEMP)
C VTEMPM --> VTEMP
            DO 145 K = 1,NEQ
              ZR(JTEMP+K-1) = ZR(JTEMPP+K-1)
 145        CONTINUE
            CALL UTTCPU('CPU.OP0186.3','FIN',' ')
            CALL UTTCPR('CPU.OP0186.3',4,TPS3)

C --- FIN BOUCLE SUR LES RESOLUTIONS PB STD/PB DERIVEE
   50     CONTINUE
C
C ------- ARCHIVAGE
C
          IF (.NOT.LEVOL) THEN
            FORCE = .TRUE.
          ELSE
            FORCE = .FALSE.
          ENDIF
          CALL NTARCH(NUMINS,MODELE,MATE  ,CARELE,LNONL ,
     &                PARA  ,SDDISC,SDCRIT,SDSENS,SDIETO,
     &                LISCH2,FORCE )
C
C ------- OBSERVATION EVENTUELLE
C
          IF (LEVOL) THEN
            CALL NTOBSV(MAILLA,SDSENS,SDIETO,SDOBSE,NUMINS,
     &                  INSTAP)
          ENDIF
C
C ------- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
C
          IF ( ETAUSR().EQ.1 ) THEN
             CALL SIGUSR()
          ENDIF
C
C ------- TEMPS DISPONIBLE POUR CONTINUER ?
C
          CALL UTTCPU('CPU.OP0186.1','FIN',' ')
          CALL UTTCPR('CPU.OP0186.1',4,TPS1)
          TCONSO=TPS1(3) - TPEX
          CALL IMPFOT(TCONSO,TPSCVT)
          CALL U2MESK('I','MECANONLINE7_1',1,TPSCVT) 
          WRITE (IFM,'(/)')
          TPEX = TPS1(3)
          IF (TPS1(4).GT.0.48D0*TPS1(1)) THEN
            ITAB(1) = NUMINS
            RTAB(1) = TPS2(4)
            RTAB(2) = TPS2(1)
            CALL UTEXCM(28,'DISCRETISATION2_80',0,K8BID,1,ITAB,2,RTAB)
          END IF

      IF (FINPAS) GOTO 500

C----- NOUVEAU PAS DE TEMPS
        IF (LOSTAT) THEN
          LOSTAT=.FALSE.
        ENDIF
        NUMINS = NUMINS + 1
      GOTO 200
C

500   CONTINUE
C

C **********************************************************************
C                         CALCUL DES OPTIONS
C **********************************************************************

C --- CALCUL DES OPTIONS

      CALL NTOPTC(RESULT,MODELE,MATE,CARELE,CHARGE,INFOCH,LISOPT,NOPT,
     &            PARCRR(1))

      CALL TITRE()
C
C --- DESTRUCTION DE TOUTES LES MATRICES CREEES
C
      CALL DETMAT()

      CALL JEDEMA()
C
      END

      SUBROUTINE OP0171()
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 15/11/2011   AUTEUR DELMAS J.DELMAS 
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
C
      IMPLICIT NONE
C ----------------------------------------------------------------------
C     COMMANDE:  THER_NON_LINE_MO
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'OP0171' )
C
      LOGICAL      MATCST,COECST,PREM,REASMT,REASVT
      INTEGER      PARCRI(9),IIFM,JLAGPP,JLAGPM,JLAGP,JINST
      INTEGER      IBID,K,NEQ,IAUX,IRET
      INTEGER      ITMAXL,ITERL,IFM,NIV,IUNIFI,NUM
      INTEGER      IOCC,N1,N2
      INTEGER      JTEMP,JTEMPM,JTEMPP,J2ND,LONCH,LGLAP
      INTEGER      NBPASE, ETAUSR
      INTEGER      JLCHA,IALICH,NCHAR,JINFC,JINF
      INTEGER      I,JFCHA ,IALIFC
      REAL*8       TPSTHE(6),TPSNP1,TESTN,TESTR
      REAL*8       TPS1(4),TPS2(4),TPEX
      REAL*8       PARCRR(9),TESTI,EPSR,EPSL
      REAL*8       R8AUX(1)
      COMPLEX*16   CBID
      CHARACTER*1  CI1,CI2,CREAS,CE1,CE2
      CHARACTER*4  TYPCAL
      CHARACTER*8  K8BID
      CHARACTER*8 BASENO
      CHARACTER*13 INPSCO
      CHARACTER*16 K16BID,NOMCMD,NOMCVG
      CHARACTER*19 INFCHA,SOLVEU,MAPREC, LISCHA
      CHARACTER*24 MODELE,MATE,CARELE,FOMULT,CHARGE,INFOCH
      CHARACTER*24 NOMCH,VTEMP,VTEMPM,VTEMPP,VEC2ND
      CHARACTER*24 RESULT,LIGRMO,TEMPEV,TEMPIN
      CHARACTER*24 TIME,MEDIRI,MATASS,NOOJB,NUMEDD
      CHARACTER*24 CNDIRP,CNCHCI,CNCHTP
      CHARACTER*24 CHLAPM,CHLAPP,CNRESI, NOOBJ
      CHARACTER*76 FMT
      CHARACTER*8  VALK
      INTEGER      VALI(2)
      REAL*8       VALR(2)
      INTEGER      IARG
C
C ----------------------------------------------------------------------
C
      DATA INFCHA                 /'&&OP0171.INFCHA'/
      DATA SOLVEU                 /'&&OP0171.SOLVEUR'/
      DATA MAPREC                 /'&&OP0171.MAPREC'/
      DATA RESULT  /' '/
      DATA CNDIRP,CNCHTP          /2*' '/
      DATA CNCHCI,CNRESI    /2*' '/
      DATA CHLAPM,CHLAPP          /'&&OP0171.CLPM','&&OP0171.CLPP'/
      DATA VTEMP,VEC2ND           /'&&OP0171.TH'  ,'&&OP0171.2ND'/
      DATA VTEMPM,VTEMPP          /'&&OP0171.THM' ,'&&OP0171.THP'/
      DATA MEDIRI                 /' '/
      DATA MATASS                 /'&&MTHASS'/
      DATA FMT                    /'(76(''*''))'/
C
C ======================================================================
C                    RECUPERATION DES OPERANDES
C ======================================================================
      CALL JEMARQ()
C
C-----RECUPERATION DU NIVEAU D'IMPRESSION
C
      CALL INFMAJ
C
      CALL INFNIV(IFM,NIV)
C---------------------------------------------------------------------
      CE1 = ' '
      CE2 = ' '
C
C               12   345678   90123
      INPSCO = '&&'//NOMPRO//'_PSCO'
C
C     DETERMINATION DU NOM DE LA SD INFO_CHARGE
C             12345678    90123    45678901234
      NOOBJ ='12345678'//'.1234'//'.EXCIT.INFC'
      CALL GNOMSD(NOOBJ,10,13)
      LISCHA = NOOBJ(1:19)
C
C --- LECTURE DES OPERANDES DE LA COMMANDE
C
C --- NOM UTILISATEUR DU CONCEPT RESULTAT CREE PAR LA COMMANDE
C
      CALL GETRES (RESULT,K16BID,NOMCMD)
C
C --- DONNEES
C
C               12   345678
      BASENO = '&&'//NOMPRO
      IAUX = 1
      CALL PSLECT ( ' ', IBID, BASENO, RESULT, IAUX,
     &              NBPASE, INPSCO, IRET )
C
      CALL NTDOTH ( MODELE, MATE, CARELE, FOMULT, MATCST,
     &              COECST, INFCHA,
     &              NBPASE, INPSCO,K8BID, IBID )
      CHARGE = INFCHA//'.LCHA'
      INFOCH = INFCHA//'.INFC'
C
C --- PARAMETRES DONNES APRES LE MOT-CLE FACTEUR SOLVEUR
C
      CALL CRESOL (SOLVEU)
C
C --- RECUPERATION DU CRITERE DE CONVERGENCE
C
      NOMCVG = 'CONVERGENCE'
      CALL GETFAC(NOMCVG,IOCC)
      IF ( IOCC .EQ. 1 ) THEN
        CALL GETVR8(NOMCVG,'CRIT_TEMP_RELA',1,IARG,1,PARCRR(4),
     &                                                   PARCRI(4))
        CALL GETVR8(NOMCVG,'CRIT_ENTH_RELA',1,IARG,1,PARCRR(6),
     &                                                   PARCRI(6))
C
        CALL GETVIS(NOMCVG,'ITER_GLOB_MAXI',1,IARG,1,PARCRI(1),N1)
C
        CALL GETVTX(NOMCVG,'ARRET',1,IARG,1,K8BID,N1)
        PARCRI(9) = 0
        IF ( N1 .GT. 0 ) THEN
          IF ( K8BID  .EQ. 'NON' ) THEN
            PARCRI(9) = 1
          ENDIF
        ENDIF
       ENDIF
       ITMAXL = PARCRI(1)
       EPSR   = PARCRR(4)
       EPSL   = PARCRR(6)
C
C ======================================================================
C
      TIME   = RESULT(1:8)//'.CHTPS'
C
C --- NUMEROTATION ET CREATION DU PROFIL DE LA MATRICE
      NOOJB='12345678.00000.NUME.PRNO'
      CALL GNOMSD ( NOOJB,10,14 )
      NUMEDD=NOOJB(1:14)
      CALL NUMERO (' ',MODELE,INFCHA,SOLVEU,'VG',NUMEDD)

      CALL VTCREB (VTEMP,NUMEDD,'V','R',NEQ)
C
C
      CALL GETVID('ETAT_INIT','EVOL_THER',1,IARG,1,TEMPEV,N1)
      IF(N1 .GT. 0) THEN
        CALL GETVIS('ETAT_INIT','NUME_ORDRE',1,IARG,1,NUM,N2)
        IF(N2 .LE. 0) THEN
           CALL ASSERT(.FALSE.)
        ELSE
           CALL RSEXCH(TEMPEV, 'TEMP', NUM, TEMPIN, IRET)
           IF (IRET.GT.0) THEN
             CALL ASSERT(.FALSE.)
           END IF
        END IF
        CALL VTCOPY (TEMPIN, VTEMP)
       END IF
C ======================================================================
C
      LIGRMO = MODELE(1:8)//'.MODELE'
      R8AUX(1) = 0.D0
      CALL MECACT ('V',CHLAPM,'MODELE',LIGRMO,'NEUT_R',1,'X1',
     &             IBID,R8AUX,CBID,K8BID)
C
      TPSNP1 = 0.D0
      PREM = .TRUE.
C
C --- MATRICE DE RIGIDITE ASSOCIEE AUX LAGRANGE
C
      TYPCAL = 'THER'
      CALL MEDITH ( TYPCAL, MODELE, CHARGE, INFOCH, MEDIRI )
C
C ======================================================================
C
      CALL UTTCPU('CPU.OP0171.1','INIT',' ')
      CALL UTTCPU('CPU.OP0171.1','DEBUT',' ')
      CALL UTTCPR('CPU.OP0171.1',4,TPS1)
      TPEX = TPS1(3)
      CALL UTTCPU('CPU.OP0171.2','INIT',' ')
C
      TPSTHE(1) = TPSNP1
      TPSTHE(2) = 0.D0
      TPSTHE(3) = 0.D0
      TPSTHE(4) = 0.D0
      TPSTHE(5) = 0.D0
      TPSTHE(6) = 0.D0
      WRITE (IFM,FMT)
C
C --- DUPLICATION DES STRUCTURES DE DONNEES ET RECUPERATION D'ADRESSES
C
      CALL COPISD('CHAMP_GD','V',VTEMP(1:19),VTEMPM(1:19))
      CALL COPISD('CHAMP_GD','V',VTEMP(1:19),VTEMPP(1:19))
      CALL COPISD('CHAMP_GD','V',VTEMP(1:19),VEC2ND(1:19))
      CALL JEVEUO (VTEMP(1:19 )//'.VALE','E',JTEMP)
      CALL JEVEUO (VTEMPM(1:19)//'.VALE','E',JTEMPM)
      CALL JEVEUO (VTEMPP(1:19)//'.VALE','E',JTEMPP)
      CALL JEVEUO (VEC2ND(1:19)//'.VALE','E',J2ND)
      CALL JELIRA (VEC2ND(1:19)//'.VALE','LONMAX',LONCH,K8BID)
C
C --- COMPTEUR ET CRITERES D'ARRET
C
      ITERL = 0
      TESTI = 1.D0
      TESTR = 1.D0
      REASVT = .TRUE.
      REASMT = .TRUE.
      WRITE (IFM,FMT)
      WRITE (IFM,10002)
10002 FORMAT ('*',1X,'ITERATION',1X,'*',1X,'CRIT_TEMPER',1X,'*',1X,
     &     'VALE_TEST_TEMPER',1X,'*',1X,'CRIT_ENTHAL',1X,'*',1X,
     &     'VALE_TEST_ENTHAL',1X,'*')
10001 FORMAT ('*',3X,I4,A1,7X,4(1PD11.3,A1,3X),3X,'*')

      WRITE (IFM,FMT)
C
C ======================================================================
C        ITERATIONS DU PROBLEME DE TRANSPORT EN THERMIQUE N_LINEAIRE
C ======================================================================
C
 2000  CONTINUE
          CALL UTTCPU('CPU.OP0171.2','DEBUT',' ')
C
C --- ACTUALISATION EVENTUELLE DES VECTEURS ET DES MATRICES
C
          CALL NTTCMV (MODELE,MATE,CARELE,FOMULT,CHARGE,INFCHA,
     &                 INFOCH,NUMEDD,SOLVEU,TIME,CHLAPM,
     &                 TPSTHE,TPSNP1,REASVT,REASMT,CREAS,
     &                 VTEMP,VTEMPM,VEC2ND,MATASS,MAPREC,
     &                 CNDIRP,CNCHCI,CNCHTP)
          REASMT = .TRUE.
          REASVT = .FALSE.
C
C --- ARRET DES ITERATIONS
C
          IF (  (TESTI.GT.EPSR .OR. TESTR .GT. EPSL)
     &                         .AND. ITERL.LT.ITMAXL) THEN
C
C *** ON CONTINUE...
C
            ITERL = ITERL + 1
C
C - ITERATIONS INTERNES
C
          CALL NTTAIN (MODELE,MATE,CARELE,CHARGE,INFOCH,NUMEDD,SOLVEU,
     &                 TIME,EPSR,LONCH,MATASS,MAPREC,CNCHCI,CNRESI,
     &                 VTEMP,VTEMPM,VTEMPP,VEC2ND,CHLAPM,CHLAPP,CI1,
     &                 CI2,TESTI)
C
C - ACTUALISATION DU CHAMP ENTHALPIE
C
      IF (PREM) THEN
C
        CALL JELIRA (CHLAPP(1:19)//'.CELV','LONUTI',LGLAP,K8BID)
        CALL JEVEUO (CHLAPP(1:19)//'.CELV','L',JLAGP)
        CALL COPISD('CHAMP_GD','V',CHLAPP(1:19),CHLAPM(1:19))
        PREM = .FALSE.
C
      ELSE
C
        CALL JEVEUO(CHLAPM(1:19)//'.CELV','E',JLAGPM)
        CALL JEVEUO(CHLAPP(1:19)//'.CELV','L',JLAGPP)
        TESTR = 0.D0
        TESTN = 0.D0
        DO 200 K = 1,LGLAP
          TESTR = TESTR + (ZR(JLAGPP+K-1)-ZR(JLAGPM+K-1))**2
          TESTN = TESTN + ZR(JLAGPP+K-1)**2
          ZR(JLAGPM+K-1) = ZR(JLAGPP+K-1)
 200    CONTINUE
        TESTR = SQRT(TESTR/TESTN)
C
      ENDIF
C
C - EVALUATION DE LA CONVERGENCE ET AFFICHAGE
C
             IIFM = IUNIFI ('MESSAGE')
         WRITE(IIFM,10001) ITERL,CE1,EPSR,CE2,TESTI,CE1,EPSL,CE2,TESTR
             CALL UTTCPU('CPU.OP0171.2','FIN',' ')
             CALL UTTCPR('CPU.OP0171.2',4,TPS2)
C
C --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
C
            IF ( ETAUSR().EQ.1 ) THEN
               CALL SIGUSR()
            ENDIF
C
C - Y A-T-IL ASSEZ DE TEMPS POUR REFAIRE UNE ITERATION ?
C
            IF (TPS2(4).GT.0.8D0*TPS2(1)-TPS2(4)) THEN
              VALI(1) = ITERL
              VALR(1) = TPS2(4)
              VALR(2) = TPS2(1)
              CALL UTEXCM(28,'DISCRETISATION2_79',0,VALK,1,VALI,2,VALR)
            END IF
C
C - ON VA REFAIRE UNE ITERATION
C
            GO TO 2000
C
C *** ON S'ARRETE... (CONVERGENCE OU NOMBRE MAX D'ITERATIONS ATTEINT)
C
          ELSE
C
C
            IF ((PARCRI(9).EQ.0).AND.(ITERL.GE.ITMAXL)) THEN
              WRITE (IFM,FMT)
              CALL UTEXCP(22, 'MECANONLINE_83')
            ENDIF
C
          ENDIF
C
C --- FIN DES ITERATIONS
C
C --- COPIE DE LA SD INFO_CHARGE DANS LA BASE GLOBALE
          CALL GETFAC('EXCIT',NCHAR)
          CALL JEDETR(LISCHA//'.LCHA')
          CALL WKVECT(LISCHA//'.LCHA','G V K24',NCHAR,JLCHA)
          CALL JEVEUO(INFCHA//'.LCHA','L',IALICH)
          CALL JEDETR(LISCHA//'.FCHA')
          CALL WKVECT(LISCHA//'.FCHA','G V K24',NCHAR,JFCHA)
          CALL JEVEUO(FOMULT,'L',IALIFC)
          DO 51 I=1,NCHAR
            ZK24(JLCHA+I-1)=ZK24(IALICH+I-1)
            ZK24(JFCHA+I-1)=ZK24(IALIFC+I-1)
 51       CONTINUE
          CALL JEDETR(LISCHA//'.INFC')
          CALL WKVECT(LISCHA//'.INFC','G V IS',2*NCHAR+1,JINFC)
          CALL JEVEUO(INFCHA//'.INFC','L',JINF)
          DO 52 I=1,2*NCHAR+1
            ZI(JINFC+I-1)=ZI(JINF+I-1)
 52       CONTINUE

          CALL UTTCPU('CPU.OP0171.1','FIN',' ')
          CALL UTTCPR('CPU.OP0171.1',4,TPS1)
          WRITE(IFM,FMT)
          WRITE(IFM,'(A,21X,A,1PE10.2,21X,A)')
     &                                 '*','DUREE:',TPS1(3)-TPEX,'*'
          WRITE(IFM,FMT)
          WRITE(IFM,'(/)')
C
C ======================================================================
C                   STOCKAGE DU RESULTAT
C ======================================================================
C
          CALL RSCRSD('G',RESULT,'EVOL_THER',1)
          CALL RSEXCH(RESULT,'TEMP',0,NOMCH,IRET)
          CALL RSADPA(RESULT,'E',1,'INST',0,0,JINST,K8BID)
          ZR(JINST) = 0.D0
          CALL COPISD('CHAMP_GD','G',VTEMPP(1:19),NOMCH(1:19))
          CALL RSNOCH(RESULT,'TEMP',0,' ')
C
C      ARCHIVAGE DU MODELE, MATERIAU, CARA_ELEM ET DE LA SD CHARGE
C
          CALL RSSEPA(RESULT(1:8),0,MODELE(1:8),MATE(1:8),CARELE(1:8),
     &                     LISCHA)
C
      CALL TITRE ()
C
C ----------------------------------------------------------------------
      CALL JEDEMA()
      END

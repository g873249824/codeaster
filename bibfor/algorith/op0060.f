      SUBROUTINE OP0060()
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
C TOLE CRP_20
C     ------------------------------------------------------------------
C     COMMANDE DYNA_LINE_HARM : CALCUL DYNAMIQUE HARMONIQUE POUR UN
C     SYSTEME CONSERVATIF OU DISSIPATIF Y COMPRIS LES SYSTEMES COUPLES
C     FLUIDE-STRUCTURE
C     ------------------------------------------------------------------
C
      IMPLICIT NONE
C
C ==> COMMUNS
C
C     ----- DEBUT DES COMMUNS JEVEUX -----------------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C     ----- FIN DES COMMUNS JEVEUX -------------------------------------
C
C ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'OP0060' )

      INTEGER      IBID,NBOLD
      REAL*8       RBID
      COMPLEX*16   CBID
      CHARACTER*8  K8BID
      CHARACTER*19 K19BID
      CHARACTER*24 K24BID, BLAN24

      INTEGER NBPASE, NRPASE
      CHARACTER*8 BASENO, CONCEP,RESUCO
      CHARACTER*19 VECASS,  RESULT
      CHARACTER*13 INPSCO

      INTEGER NBSYM, I, J, NBVECT, IVECT, N1, N2, TYPESE
      INTEGER LAMOR1, LAMOR, LIMPE, LFREQ, NBFREQ, LACCE
      INTEGER NVA, NEQ, NBMAT
      INTEGER IE,JREFA, ETAUSR
      INTEGER IFREQ, IEQ, INOM, IAUX, JAUX, IER
      INTEGER LCC, LFON, LADRVE, LTYPVE, LPUISS, LPHASE, L
      INTEGER LREFE, LSECMB,JSECMB,JSOLUT,JVEZER
      INTEGER ICOEF, ICODE
      INTEGER IADR, LVALE, LINST, IRET, IRESOL, LADPA,JORD

      INTEGER LMAT(4),LPRO,NBORD,ICOMB
      INTEGER LRESU,LCCRE,IRESU,NBEXRE,IFRE2, JPOMR, JREFE
      LOGICAL       LVECAS, SENSCH, NEWCAL

      REAL*8   DEPI, R8DEPI, DGRD, R8DGRD, OMEGA2, FREQ, OMEGA
      REAL*8   RVAL, PHASE, ALPHA
      REAL*8   COEF(6), TPS1(4),RESURE,RESUIM
      REAL*8   RTAB(2)
      REAL*8   PREC, EPS0
      COMPLEX*16    CALPHA, CVAL,CALP,CZERO

      CHARACTER*1   TYPRES, TYPCST(4), BL
      CHARACTER*8   NOMDDL, NOMSYM(3), NOPASE, BLAN8
      CHARACTER*8   CHMAT,CARAEL,K8B
      CHARACTER*14  NUMDDL,NUMDL1,NUMDL2,NUMDL3
      CHARACTER*16  TYPCON, NOMCMD, TYSD
      CHARACTER*19  LIFREQ, MASSE, RAIDE, AMOR, DYNAM, IMPE, CHAMNO
      CHARACTER*19  INFCHA,SOLVEU,MAPREC,SECMBR,SOLUTI,VEZERO,CRGC
      CHARACTER*19  CHAM19, CHAMN2, NOMT, NOMI
      CHARACTER*24  MODELE,CARELE,MATE,FOMULT, VACOMP
      CHARACTER*24  VDEPL, VADIRI, VACHAM, NOMAT(4)
      DATA CRGC     /'&&OP0060_GCPC'/
C     ------------------------------------------------------------------
C     -----------------------------------------------------------------
C
C===============
C 1. PREALABLES
C===============
C
C====
C 1.0  ==> STANDARD
C====
      CALL JEMARQ()
      CALL INFMAJ()

C====
C 1.1  ==> INITIALISATIONS DIVERSES
C====
      BL = ' '
C               123456789012345678901234
      BLAN8  = '        '
      BLAN24 = '                        '
      DEPI  = R8DEPI()
      DGRD  = R8DGRD()
      TYPRES = 'C'
      LAMOR1 = 0
      CZERO = DCMPLX(0.0D0,0.0D0)

C====
C 1.2. ==> NOM DES STRUCTURES
C====
      BASENO = '&&'//NOMPRO

C              12345678 90123
      INPSCO = BASENO//'_PSCO'

C              12345678 9012345678901234
      INFCHA = BASENO//'.INFCHA'
      FOMULT = INFCHA // '.FCHA'

C     NOM DE L'OBJET MAPREC
      MAPREC = '&&OP0060.MAPREC'
C     SECOND MEMBRE ET VECTEUR NUL
      SECMBR = '&&OP0060.SECMBR'
      SOLUTI = '&&OP0060.SOLUTI'
      VEZERO = '&&OP0060.VEZERO'
C
C============================================
C 2. LES DONNEES,  RECUPERATION DES OPERANDES
C============================================
C
C====
C 2.0  ==> NOM UTILISATEUR DU CONCEPT RESULTAT CREE PAR LA COMMANDE
C====
      CALL GETRES(CONCEP,TYPCON,NOMCMD)
C
C ON VERIFIE SI LE CONCEPT EST REENTRANT
      NEWCAL = .TRUE.
      CALL JEEXIN(CONCEP//'           .DESC',IBID)
      IF (IBID.NE.0) THEN
        CALL GETVID(' ','RESULTAT',1,1,1,RESUCO,IBID)
        IF (IBID.NE.0) THEN
          CALL GETTCO(RESUCO,TYSD)
          IF (TYSD.EQ.TYPCON) THEN
            NEWCAL = .FALSE.
            IF (CONCEP.NE.RESUCO) THEN
C Le concept est reentrant et la sortie est identique a l'entree
              CALL U2MESS('F','ALGORITH9_28')
            ENDIF
          ELSE
            CALL U2MESS('F','ALGORITH9_29')
          ENDIF
        ELSE
          NEWCAL = .TRUE.
        ENDIF
      ENDIF

C====
C 2.1. ==> VERIFICATIONS DE PREMIER NIVEAU
C====
      CALL GETVTX(BL,'NOM_CHAM',1,1,3,NOMSYM,NBSYM)
      IF (NBSYM .GE.0 ) THEN
        DO 1 I=1,NBSYM
           DO 12 J=I+1,NBSYM
             IF ( NOMSYM(I).EQ. NOMSYM(J) ) THEN
               CALL U2MESS('F','ALGORITH9_30')
             ENDIF
  12      CONTINUE
  1     CONTINUE
      ENDIF

C====
C 2.2 ==> SENSIBILITE : LECTURE DES NOMS DES PARAMETRES ET TEST
C====
      IAUX = 1
      CALL PSLECT ( ' ', IBID, BASENO, CONCEP, IAUX,
     &                NBPASE, INPSCO, IRET )

      IF (TYPCON.EQ.'HARM_GENE' .AND. NBPASE.GT.0 ) THEN
        CALL U2MESK('F','SENSIBILITE_92',1,TYPCON)
      ENDIF

C===
C 2.3 ==> LISTE DES FREQUENCES POUR LE CALCUL ---
C====
      CALL GETVID(BL,'LIST_FREQ',0,1,1,LIFREQ,N1)
      IF ( N1 .GT. 0 ) THEN
         CALL JEVEUO(LIFREQ//'.VALE','L',LFREQ)
         CALL JELIRA(LIFREQ//'.VALE','LONMAX',NBFREQ,K8BID)
      ELSE
         CALL GETVR8(BL,'FREQ',0,1,0,RBID,NBFREQ)
         NBFREQ = - NBFREQ
         CALL WKVECT(BASENO//'.LISTE.FREQ','V V R',NBFREQ,LFREQ)
         CALL GETVR8(BL,'FREQ',0,1,NBFREQ,ZR(LFREQ),NBFREQ)
      ENDIF
C====
C 2.4 ==> NOM_CHAM CALCULES ---
C====
      IF (TYPCON.EQ.'ACOU_HARMO') THEN
        NBSYM = 1
        NOMSYM(1) = 'PRES'
      ELSE
        CALL GETVTX(BL,'NOM_CHAM',1,1,3,NOMSYM,NBSYM)
        IF (NBSYM .EQ. 0) THEN
          NBSYM = 3
          NOMSYM(1) = 'DEPL'
          NOMSYM(2) = 'VITE'
          NOMSYM(3) = 'ACCE'
        ENDIF
      ENDIF


C====
C 2.5 ==> OBTENTION DES DIFFRENTS CHARGEMENTS ASSEMBLES INDEPENDANTS
C         DE LA FREQUENCE, 3 CAS :
C     ---  "VECT_ASSE"
C     ---  CHARGE RELLE
C     ---  CHARGE COMPLEXE
C====
C 2.5.1 IDENTIFICATION DU TYPE DE CHARGEMENT EN ENTREE ET TEST
      LVECAS = .FALSE.
      SENSCH = .FALSE.

      CALL GETVID('EXCIT','VECT_ASSE',1,1,0,CHAMNO,NVA)
      IF ( NVA .NE. 0 )    LVECAS = .TRUE.

C   SENSCH = .TRUE. SI IL Y A UN CALCUL DE SENSIBILITE SUR 1 CHARGEMENT
      DO 251 , NRPASE = 1 , NBPASE
        CALL PSNSLE ( INPSCO, NRPASE, 1, NOPASE )
        CALL METYSE ( NBPASE, INPSCO, NOPASE, TYPESE, K24BID )
        IF ( TYPESE.EQ.2 .OR. TYPESE.EQ.5 ) THEN
          SENSCH = .TRUE.
        ENDIF
 251  CONTINUE

      IF (LVECAS .AND. SENSCH) THEN
        CALL U2MESS('F','SENSIBILITE_93')
      ENDIF
C
C 2.5.2  "VECT_ASSE" EN ENTREE: IL FAUT JUSTE RECUPERER LES DIFFERENTS
C                                                              VECTEURS
      IF ( LVECAS ) THEN
        CALL GETFAC('EXCIT',NBVECT)

        CALL WKVECT(BASENO//'.COEF_C'      ,'V V C  ',NBVECT,LCC)
        CALL WKVECT(BASENO//'.LIST.FONC'   ,'V V K24',NBVECT,LFON)
        CALL WKVECT(BASENO//'.ADRES.VECASS','V V I  ',NBVECT,LADRVE)
        CALL WKVECT(BASENO//'.TYPE.VECASS ','V V K8 ',NBVECT,LTYPVE)
        CALL WKVECT(BASENO//'.PUIS_PULS   ','V V I  ',NBVECT,LPUISS)
        CALL WKVECT(BASENO//'.PHAS_DEGR   ','V V C  ',NBVECT,LPHASE)
        DO 25 IVECT = 1, NBVECT
          CALL GETVID('EXCIT','VECT_ASSE',IVECT,1,1,CHAMNO,L)
          CALL JEVEUO(CHAMNO//'.VALE','L',ZI(LADRVE+IVECT-1))
          CALL JELIRA(CHAMNO//'.VALE','TYPE',IBID,ZK8(LTYPVE+IVECT-1))
          ZK24(LFON+IVECT-1)=' '
          CALL GETVID('EXCIT','FONC_MULT',IVECT,1,1,
     &                ZK24(LFON+IVECT-1),L)
          IF (L .EQ.0 ) THEN
            CALL GETVID('EXCIT','FONC_MULT_C',IVECT,1,1,
     &                  ZK24(LFON+IVECT-1),L)
            IF (L .EQ.0 ) THEN
              CALL GETVC8('EXCIT','COEF_MULT_C',IVECT,1,1,
     &                    ZC(LCC+IVECT-1),L)
              IF (L .EQ.0 ) THEN
                 CALL GETVR8('EXCIT','COEF_MULT',IVECT,1,1,RVAL,L)
                 ZC(LCC+IVECT-1)=RVAL
              ENDIF
            ENDIF
          ENDIF
          PHASE = 0.D0
          CALL GETVR8('EXCIT','PHAS_DEG',IVECT,1,1,PHASE,N1)
          ZC(LPHASE+IVECT-1) = EXP(DCMPLX(0.D0,PHASE*DGRD))
         CALL GETVIS('EXCIT','PUIS_PULS',IVECT,1,1,ZI(LPUISS+IVECT-1),L)
  25    CONTINUE

        IF (NBPASE.GT.0) THEN
          MODELE = BLAN24
          MATE   = BLAN24
          CARELE   = BLAN24
          CALL NMDOME ( MODELE, MATE, CARELE, INFCHA, NBPASE, INPSCO,
     &                  BLAN8, IBID)
          FOMULT = INFCHA // '.FCHA'
        ENDIF

      ELSE
C
C 2.5.3  TYPE "CHARGE" EN ENTREE
C
        CALL DYLACH( NBPASE, INPSCO, INFCHA, FOMULT, MODELE, MATE,
     &                                 CARELE, VADIRI, VACHAM)

      ENDIF

      CALL GETFAC('EXCIT_RESU',NBEXRE)
      IF ( NBEXRE.NE.0 ) THEN

        CALL WKVECT(BASENO//'.COEF_CRE'    ,'V V C  ',NBEXRE,LCCRE)
        CALL WKVECT(BASENO//'.LISTRESU'    ,'V V K8 ',NBEXRE,LRESU)

        DO 252 IRESU = 1, NBEXRE
          CALL GETVID('EXCIT_RESU','RESULTAT',IRESU,1,1,
     &                ZK8(LRESU+IRESU-1),L)
          CALL GETVC8('EXCIT_RESU','COEF_MULT_C',IRESU,1,1,
     &                ZC(LCCRE+IRESU-1),L)

 252    CONTINUE
      ENDIF
C
C====
C 2.6 ==> PREMIER MEMBRE
C     RECUPERATION DES DESCRIPTEURS DES MATRICES ET DES MATRICES
C====
      RAIDE=BLAN8
      MASSE=BLAN8
      AMOR=BLAN8
      CALL DYLEMA (BASENO, NBMAT, NOMAT, RAIDE, MASSE, AMOR, IMPE)
      CALL ASSERT(NBMAT.LE.4)
      CALL GETVID(BL,'MATR_AMOR'    ,0,1,1,K19BID ,LAMOR)
      CALL GETVID(BL,'MATR_IMPE_PHI',0,1,1,K19BID ,LIMPE)
      CALL GETVR8('AMOR_MODAL','AMOR_REDUIT',1,1,0,RBID,N1)
      CALL GETVID('AMOR_MODAL','LIST_AMOR',1,1,0,K8BID,N2)
      IF (N1.NE.0.OR.N2.NE.0)    LAMOR1 = 1

C ---------------------------------------------------------------
C     TEST POUR VERIFIER QUE LES MATRICES SONT TOUTES BASEES SUR
C     LA MEME NUMEROTATION
C ---------------------------------------------------------------
      NUMDL1=BL
      NUMDL2=BL
      NUMDL3=BL
      CALL DISMOI('F','NOM_NUME_DDL',RAIDE,'MATR_ASSE',IBID,
     &                                                   NUMDL1,IE)
      CALL DISMOI('F','NOM_NUME_DDL',MASSE,'MATR_ASSE',IBID,
     &                                                   NUMDL2,IE)
      IF (LAMOR.NE.0) THEN
        CALL DISMOI('F','NOM_NUME_DDL',AMOR,'MATR_ASSE',IBID,
     &                                                   NUMDL3,IE)
      ELSE
        NUMDL3=NUMDL2
      ENDIF
      IF ((NUMDL1.NE.NUMDL2).OR.(NUMDL1.NE.NUMDL3).OR.
     & (NUMDL2.NE.NUMDL3)) THEN
      CALL U2MESS('F','ALGORITH9_34')
      ELSE
         NUMDDL=NUMDL2
      ENDIF

C============================================
C 3. ==> ALLOCATION DES RESULTATS
C============================================
C
      IF (NEWCAL) CALL UTCRRE(NBPASE,INPSCO,NBFREQ)

C     COMPLEMENT : RENSEIGNEMENT DU .REFD
      DO 31 , NRPASE = 0 , NBPASE
        IAUX = NRPASE
        JAUX = 3
        CALL GETRES(RESULT,TYPCON,NOMCMD)
        CALL PSNSLE ( INPSCO, IAUX, JAUX, RESULT )
        IF (NEWCAL) THEN
          CALL WKVECT(RESULT//'.REFD','G V K24',7,LREFE)
          NBOLD=0
        ELSE
          CALL JEVEUO(RESULT//'.REFD','E',LREFE)
          CALL RSORAC(RESULT,'LONUTI',IBID,RBID,K8BID,CBID,RBID,
     &            'ABSOLU',NBOLD,1,IBID)
          CALL RSAGSD(RESULT,NBFREQ+NBOLD)
        ENDIF
        ZK24(LREFE  ) = RAIDE
        ZK24(LREFE+1) = MASSE
        ZK24(LREFE+2) = AMOR
        ZK24(LREFE+3  ) = NUMDDL
        ZK24(LREFE+4) = ' '
        ZK24(LREFE+5) = ' '
        ZK24(LREFE+6) = ' '
        CALL JELIBE(RESULT//'.REFD')
 31   CONTINUE
C

C============================================
C 4. ==> CALCUL DES TERMES DEPENDANT DE LA FREQUENCE ET RESOLUTION
C         DU SYSTEME FREQUENCE PAR FREQUENCE
C============================================

C====
C 4.1. ==> PREPARATION DU CALCUL ---
C====

      DO 41 I=1, NBMAT
         CALL JEVEUO(NOMAT(I),'L',LMAT(I))
 41   CONTINUE
      NEQ = ZI(LMAT(1)+2)
      TYPCST(1) = 'R'
      TYPCST(2) = 'R'
      TYPCST(3) = 'C'
      TYPCST(4) = 'C'
      COEF(1)   = 1.D0
C
C     CREATION DE LA MATRICE DYNAMIQUE
      DYNAM = BASENO//'.DYNAMIC_MX'

      JPOMR=0
      DO 15 ICOMB = 1,NBMAT
C        ON RECHERCHE UNE EVENTUELLE MATRICE NON SYMETRIQUE
         NOMI=NOMAT(ICOMB)
         CALL JEVEUO(NOMI//'.REFA','L',JREFE)
         IF ( ZK24(JREFE-1+9).EQ.'MR' ) THEN
            JPOMR=ICOMB
         ENDIF
   15 CONTINUE
      IF (JPOMR.EQ.0) THEN
         IF (LAMOR.NE.0) THEN
            CALL MTDEFS(DYNAM,AMOR,'V',TYPRES)
         ELSE
            CALL MTDEFS(DYNAM,RAIDE,'V',TYPRES)
         ENDIF
      ELSE
         NOMT = NOMAT(JPOMR)
         CALL MTDEFS(DYNAM,NOMT,'V',TYPRES)
      ENDIF
      CALL MTDSCR(DYNAM)
C
C     CREATION DU VECTEUR SECOND-MEMBRE/SOLUTION STANDARD
C        SUIVI DES VECTEURS SECOND-MEMBRE/SOLUTION DERIVES
      VECASS = BASENO//'.SECOND.MBR'
      CALL WKVECT(VECASS,'V V C',NEQ*(NBPASE+1),LSECMB)

C     CREATION SD TEMPORAIRES

      CALL VTCREM(SECMBR,DYNAM,'V',TYPRES)
      CALL COPISD('CHAMP_GD','V',SECMBR,VEZERO)
      CALL JEVEUO(SECMBR(1:19)//'.VALE','E',JSECMB)
      CALL JEVEUO(VEZERO(1:19)//'.VALE','E',JVEZER)
      CALL ZINIT(NEQ,CZERO,ZC(JVEZER),1)

      SOLVEU='&&OP0060.SOLVEUR'
      CALL CRESOL(SOLVEU)

C====
C 4.2 ==> BOUCLE SUR LES FREQUENCES ---
C====
      CALL UTTCPU('CPU.OP0060', 'INIT',' ')

      DO 42 IFREQ = 1,NBFREQ
        CALL UTTCPU('CPU.OP0060', 'DEBUT',' ')
C
C 4.2.1     --- CALCUL DES COEFF. DEPENDANT DE LA FREQ. ---
C
        FREQ = ZR(LFREQ-1+IFREQ)
        OMEGA = DEPI*FREQ

        COEF(2) = - OMEGA2(FREQ)
        ICOEF = 2
        IF ((LAMOR.NE.0).OR.(LAMOR1.NE.0)) THEN
          COEF(3) = 0.D0
          COEF(4) = OMEGA
          ICOEF   = 4
        ENDIF
        IF (LIMPE.NE.0) THEN
          COEF(ICOEF+1) = 0.D0
          COEF(ICOEF+2) = COEF(2) * DEPI * FREQ
        ENDIF
C
C 4.2.2     --- CALCUL DU SECOND MEMBRE STANDARD---
C
        NRPASE = 0
C
C      4.2.2.A   CAS VECT_ASSE
C
        IF ( LVECAS ) THEN
          DO 121 IEQ  = 0,NEQ-1
            ZC(LSECMB+IEQ) = DCMPLX(0.D0,0.D0)
  121       CONTINUE
            ALPHA = 1.D0
            DO 124 IVECT = 1,NBVECT
              IF (ZK24(LFON+IVECT-1).EQ.' ') THEN
                CALP=ZC(LCC+IVECT-1)
              ELSE
                CALL JEVEUO(ZK24(LFON+IVECT-1)(:19)//'.PROL','L',
     &                                                      LPRO)
                IF (ZK24(LPRO).EQ.'FONCT_C') THEN
                  CALL FOINTC('F',ZK24(LFON+IVECT-1),1,'FREQ',FREQ,
     &                        RESURE,RESUIM,IER)
                  CALP=DCMPLX(RESURE,RESUIM)
                ELSE
                  CALL FOINTE('F ',ZK24(LFON+IVECT-1),1,'FREQ',FREQ,
     &                                                 ALPHA,IER)
                  CALP=ALPHA
                ENDIF
              ENDIF
              CALPHA = CALP*ZC(LPHASE+IVECT-1)
              IF ( ZI(LPUISS+IVECT-1) .NE. 0) THEN
                 CALPHA = CALPHA * OMEGA**ZI(LPUISS+IVECT-1)
              ENDIF
              IADR = ZI(LADRVE+IVECT-1)
              IF ( ZK8(LTYPVE+IVECT-1)(1:1) .EQ. 'R' ) THEN
                DO 122 IEQ  = 0,NEQ-1
                  ZC(LSECMB+IEQ) = ZC(LSECMB+IEQ) +
     &                                     CALPHA*ZR(IADR+IEQ)
  122           CONTINUE
              ELSEIF ( ZK8(LTYPVE+IVECT-1)(1:1) .EQ. 'C' ) THEN
                DO 123 IEQ  = 0,NEQ-1
                  ZC(LSECMB+IEQ) = ZC(LSECMB+IEQ) +
     &                                 CALPHA*ZC(IADR+IEQ)
  123           CONTINUE
              ELSE
                CALL U2MESS('F','ALGORITH9_35')
              ENDIF
  124       CONTINUE
        ELSE
C
C     4.2.2.B   CAS CHARGE
C
          CALL DY2MBR( NBPASE, NRPASE, INPSCO, BASENO, INFCHA, NUMDDL,
     &              FREQ, FOMULT, MODELE, MATE, CARELE, VADIRI, VACHAM,
     &                                           NEQ, LSECMB)

        ENDIF

C
C   Chargement venant d'un RESU a IFREQ
C
        IF ( NBEXRE .NE. 0 ) THEN
          CHAMN2  = '&&OP0060.CHAMN2'
          CALL JEEXIN(CHAMN2(1:19)//'.REFE',IRET)
          IF (IRET.NE.0) THEN
            CALL DETRSD('CHAM_NO',CHAMN2(1:19))
          END IF
          CALL VTCREB(CHAMN2,NUMDDL,'V','C',NEQ)
          PREC=1.D-6
          EPS0 =1.D-12
          DO 210 IRESU = 1, NBEXRE
            IF (ABS(FREQ).GT.EPS0) THEN
              CALL RSORAC(ZK8(LRESU+IRESU-1),'FREQ',IBID,FREQ,K8BID,
     &                    CBID,PREC,'RELATIF',IFRE2,1,IBID)
            ELSE
              CALL RSORAC(ZK8(LRESU+IRESU-1),'FREQ',IBID,FREQ,K8BID,
     &                    CBID,EPS0,'ABSOLU',IFRE2,1,IBID)
            ENDIF
            CALL RSEXCH(ZK8(LRESU+IRESU-1),'DEPL',IFRE2,CHAM19,IRET)
            CALL VTCOPY(CHAM19,CHAMN2)
            CALL JEVEUO(CHAMN2//'.VALE','L',LVALE)
            DO 211 IEQ  = 0,NEQ-1
              ZC(LSECMB+IEQ) = ZC(LSECMB+IEQ) +
     &                         ZC(LVALE+IEQ)*ZC(LCCRE+IRESU-1)
  211       CONTINUE
            CALL JELIBE(CHAM19//'.VALE')
  210     CONTINUE
        ENDIF

C 4.2.3     --- CALCUL DE LA MATRICE DYNAMIQUE ---
C
C                 12345678
        NOMDDL = '        '
        CALL MTCMBL(NBMAT,TYPCST,COEF,NOMAT,DYNAM, NOMDDL,' ','ELIM=')

        CALL JEVEUO(DYNAM(1:19)//'.REFA','E',JREFA)
        ZK24(JREFA-1+8) = ' '
C
C
C 4.2.4     --- FACTORISATION DE LA MATRICE DYNAMIQUE ---
C
C SE PROCURER LE NOM DE LA SD SOLVEUR
        CALL PRERES(SOLVEU,'V',ICODE,MAPREC,DYNAM,IBID,-9999)
        IF ((ICODE.EQ.1).OR.(ICODE.EQ.2)) THEN
          CALL U2MESR('I', 'DYNAMIQUE_14', 1, FREQ)
        ENDIF
C
C 4.2.5    --- RESOLUTION DU SYSTEME, CELUI DU CHARGEMENT STANDARD ---
C
        CALL ZCOPY(NEQ,ZC(LSECMB),1,ZC(JSECMB),1)
        CALL RESOUD(DYNAM,MAPREC,SECMBR,SOLVEU,VEZERO,'V',SOLUTI,CRGC,0,
     &              RBID,CBID,.TRUE.)
        CALL JEVEUO(SOLUTI(1:19)//'.VALE','L',JSOLUT)
        CALL ZCOPY(NEQ,ZC(JSOLUT),1,ZC(LSECMB),1)
        CALL JEDETR(SOLUTI)
C
C 4.2.6    --- TRAITEMENT DES DERIVATIONS , LORSQU IL Y EN A
C
C   4.2.6.A  SAUVEGARDE DU CHAMP SOLUTION CHSOL DANS VDEPL
C
        IF (NBPASE.GT.0) THEN
C         NOM DES STRUCTURES,   JAUX=4 => VARIABLE PRINCIPALE
          JAUX = 4
          CALL PSNSLE ( INPSCO, NRPASE, JAUX, VDEPL )

          CALL JEEXIN(VDEPL(1:19)//'.REFE',IRESOL)
          IF (IRESOL.EQ.0) CALL VTCREM(VDEPL(1:19),MASSE,'V',TYPRES)
          CALL JEVEUO(VDEPL(1:19)//'.VALE','E',LVALE)

          JAUX = 16
          CALL PSNSLE ( INPSCO, NRPASE, JAUX, VACOMP )
          CALL JEEXIN(VACOMP(1:19)//'.REFE',IRESOL)
          IF (IRESOL.EQ.0) CALL VTCREM(VACOMP(1:19),MASSE,'V',TYPRES)
          CALL JEVEUO(VACOMP(1:19)//'.VALE','E',LACCE)

          DO 426 IEQ = 0, NEQ-1
            ZC(LVALE+IEQ) = ZC(LSECMB+IEQ)
            ZC(LACCE+IEQ) = COEF(2)*ZC(LSECMB+IEQ)
  426     CONTINUE

C
C   4.2.6.B   CALCUL ET/OU ASSEMBLAGE DES DIFF. 2NDS MEMBRES DERIVES
C
          DO 427 , NRPASE = 1 , NBPASE

            CALL DY2MBR( NBPASE, NRPASE, INPSCO, BASENO, INFCHA, NUMDDL,
     &              FREQ, FOMULT, MODELE, MATE, CARELE, VADIRI, VACHAM,
     &                                NEQ, LSECMB+NEQ*NRPASE)

C
C    4.2.6.C RESOLUTION DES SYSTEMES
C
            CALL ZCOPY(NEQ,ZC(LSECMB+NEQ*NRPASE),1,ZC(JSECMB),1)
            CALL RESOUD(DYNAM,MAPREC,SECMBR,SOLVEU,VEZERO,'V',SOLUTI,
     &                  CRGC,0,RBID,CBID,.TRUE.)
            CALL JEVEUO(SOLUTI(1:19)//'.VALE','L',JSOLUT)
            CALL ZCOPY(NEQ,ZC(JSOLUT),1,ZC(LSECMB+NEQ*NRPASE),1)
            CALL JEDETR(SOLUTI)

 427      CONTINUE

        ENDIF

C
C 4.2.8   --- ARCHIVAGE ---
C        CREATION D'UN CHAMNO DANS L'OBJET RESULTAT
C
        DO 521 , NRPASE = 0 , NBPASE
C
C         NOM DES STRUCTURES,  JAUX=3 => LE NOM DU RESULTAT
          IAUX = NRPASE
          JAUX = 3
          CALL PSNSLE ( INPSCO, IAUX, JAUX, RESULT )

          DO 130 INOM =1, NBSYM
            CALL RSEXCH(RESULT,NOMSYM(INOM),IFREQ+NBOLD,CHAMNO,IER)
            IF ( IER .EQ. 0 ) THEN
             CALL U2MESK('A','ALGORITH2_64',1,CHAMNO)
            ELSEIF ( IER .EQ. 100 ) THEN
               CALL VTCREM(CHAMNO,MASSE,'G',TYPRES)
C              -- VTCREM CREE TOUJOURS DES CHAM_NO. PARFOIS IL FAUT LES
C                 DECLARER CHAM_GENE :
               IF (TYPCON.EQ.'HARM_GENE') THEN
                  CALL JEECRA(CHAMNO//'.DESC','DOCU',0,'VGEN')
C GLUTE CAR ON A UTILISE VTCRE[ABM] POUR UN CHAM_GENE QUI A UN .REFE
C DE TAILLE 2 ET NON 4 COMME UN CHAM_NO
                  CALL JUVECA (CHAMNO//'.REFE',2)
               ENDIF
            ELSE
               CALL U2MESS('F','ALGORITH2_65')
            ENDIF
            CALL JEVEUO(CHAMNO//'.VALE','E',LVALE)
C
C           RECOPIE DANS L'OBJET RESULTAT  ---
            IF ((NOMSYM(INOM) .EQ. 'DEPL' ).OR.
     &         ( NOMSYM(INOM) .EQ. 'PRES' ))THEN
               DO 131 IEQ = 0, NEQ-1
                  ZC(LVALE+IEQ) = ZC(LSECMB+NEQ*NRPASE+IEQ)
  131          CONTINUE
CR COPISD('CHAMP_GD','V',CHAMNO ,VDEPL(1:19))
            ELSEIF ( NOMSYM(INOM) .EQ. 'VITE' ) THEN
               CVAL = DCMPLX(0.D0,DEPI*FREQ)
               DO 132 IEQ = 0, NEQ-1
                  ZC(LVALE+IEQ) = CVAL * ZC(LSECMB+NEQ*NRPASE+IEQ)
  132          CONTINUE
            ELSEIF ( NOMSYM(INOM) .EQ. 'ACCE' ) THEN
               RVAL = COEF(2)
               DO 133 IEQ = 0, NEQ-1
                  ZC(LVALE+IEQ) = RVAL * ZC(LSECMB+NEQ*NRPASE+IEQ)
  133          CONTINUE
            ENDIF
            CALL RSNOCH(RESULT,NOMSYM(INOM),IFREQ+NBOLD,BL)
            CALL JELIBE(CHAMNO//'.VALE')
  130     CONTINUE
C
C         RECOPIE DE LA FREQUENCE DE STOCKAGE
          CALL RSADPA(RESULT,'E',1,'FREQ',IFREQ+NBOLD,0,LINST,K8BID)
          ZR(LINST) = FREQ
C
 521    CONTINUE
C
C       --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
C
        IF ( ETAUSR().EQ.1 ) THEN
           CALL SIGUSR()
        ENDIF
C
        CALL UTTCPU('CPU.OP0060', 'FIN',' ')
        CALL UTTCPR('CPU.OP0060', 4, TPS1)
        IF ( TPS1(4) .GT. .90D0*TPS1(1)  .AND. I .NE. NBFREQ ) THEN
          RTAB(1) = TPS1(4)
          RTAB(2) = TPS1(1)
          CALL UTEXCM(28,'DYNAMIQUE_13',0,K8BID,1,IFREQ,2,RTAB)
        ENDIF
C
C FIN BOUCLE FREQUENCE
 42   CONTINUE

C DESTRUCTION SD TEMPORAIRES

      CALL JEDETR(SECMBR)
      CALL JEDETR(VEZERO)
C
C --- STOCKAGE : MODELE,CARA_ELEM,CHAM_MATER
      IF(TYPCON(1:9).NE.'HARM_GENE')THEN
        CALL DISMOI('F','NOM_MODELE',RAIDE,'MATR_ASSE',IBID,MODELE,IRET)
        CALL DISMOI('F','CHAM_MATER',RAIDE,'MATR_ASSE',IBID,CHMAT,IRET)
        CALL DISMOI('F','CARA_ELEM',RAIDE,'MATR_ASSE',IBID,CARAEL,IRET)
        CALL JEVEUO(CONCEP//'           .ORDR','L',JORD)
        CALL JELIRA(CONCEP//'           .ORDR','LONUTI',NBORD,K8B)
        DO  43 I=1,NBORD
          CALL RSADPA(CONCEP,'E',1,'MODELE',ZI(JORD+I-1),0,LADPA,K8B)
          ZK8(LADPA) = MODELE(1:8)
          CALL RSADPA(CONCEP,'E',1,'CHAMPMAT',ZI(JORD+I-1),0,LADPA,K8B)
          ZK8(LADPA) = CHMAT
          CALL RSADPA(CONCEP,'E',1,'CARAELEM',ZI(JORD+I-1),0,LADPA,K8B)
          ZK8(LADPA) = CARAEL
 43     CONTINUE
      ENDIF


      CALL TITRE
C
      CALL JEDEMA()
      END

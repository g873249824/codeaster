      SUBROUTINE OP0144()
      IMPLICIT NONE
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C-----------------------------------------------------------------------
C
C     OPERATEUR "CALC_FLUI_STRU"
C
C-----------------------------------------------------------------------
      INCLUDE 'jeveux.h'
C     UN COMMON AJOUTE POUR RESORBER UNE GLUTE ANTIQUE (VOIR HISTOR):
      CHARACTER*8  TYPFLU
      COMMON  / KOP144 / TYPFLU

      INTEGER      IBID,NBCONN,ICONN
      INTEGER      NCMP,NCMPMX,JCORR2
      REAL*8       R8B
      COMPLEX*16   C16B
      LOGICAL      TMODE,CALCUL(2)
      CHARACTER*8  NOMBM,MAILLA,K8B,GRAN,NOMCMP(6)
      CHARACTER*16 CONCEP,CMD,NOMPAR
      CHARACTER*19 NOMU,CHAM19,PRCHNO
      CHARACTER*24 DESC,NUMO,VITE,FREQ,MASG,FACT
      CHARACTER*24 NUMOI,FSIC,NOMCHA,MATRIA,REFEBM,CHREFE,CHDESC,CHVALE
      CHARACTER*32 NOMVAR
      INTEGER      IARG
C
C-----------------------------------------------------------------------
      INTEGER I ,IACMP ,IAMOR ,IAV ,ICMP ,IDEC ,IDESC
      INTEGER IEC ,IER ,IFACT ,IFM ,IFR ,IFREQ ,IFSIC
      INTEGER II ,IMASG ,INEC ,INO ,INUMO ,IO ,IPAR
      INTEGER IREFBM ,IREFE ,IRET ,ITYPFL ,IUNIFI ,IV ,IVITE
      INTEGER J ,JCDESC ,JCREFE ,JDESC ,JJ ,JPRNO ,LONG
      INTEGER NBAM ,NBCOMP ,NBNO ,NBNOEU ,NBOCC ,NBPAR ,NBPV
      INTEGER NEC ,NIVDEF ,NIVPAR ,NUMGD, INDIK8
      REAL*8 AMOR ,RBID ,UMIN ,VMAX ,VMIN ,VMOY ,VPAS

C-----------------------------------------------------------------------
      DATA         NOMCMP /'DX      ','DY      ','DZ      ',
     &                     'DRX     ','DRY     ','DRZ     '/
C
C-----------------------------------------------------------------------
C     OBJETS CREES SUR LA BASE GLOBALE
C
C     NOMU//'.DESC'
C     NOMU//'.REMF'
C     NOMU//'.NUMO'
C     NOMU//'.VITE'
C     NOMU//'.FREQ'
C     NOMU//'.MASG'
C     NOMU//'.FACT'
C
C     TABLE DES NOMS DES CHAMPS DE DEPLACEMENTS AUX NOEUDS
C
C     OBJETS ASSOCIES AU PROF_CHNO COMMUN A TOUS LES CHAMPS DE
C     DEPLACEMENTS AUX NOEUDS
C     NOMU(1:8)//'.C01.YY1XX1.LILI'
C     NOMU(1:8)//'.C01.YY1XX1.LPRN'
C     NOMU(1:8)//'.C01.YY1XX1.PRNO'
C     NOMU(1:8)//'.C01.YY1XX1.NUEQ'
C     NOMU(1:8)//'.C01.YY1XX1.DEEQ'
C     CES OBJETS SONT CREES PAR LA ROUTINE CRPRNO
C
C     OBJETS ASSOCIES AUX CHAMPS DE DEPLACEMENTS AUX NOEUDS
C     NOMU(1:8)//'.C01.YYYXXX.DESC'
C     NOMU(1:8)//'.C01.YYYXXX.REFE'
C     NOMU(1:8)//'.C01.YYYXXX.VALE'
C
C-----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFMAJ()
C
      CALL GETRES(NOMU,CONCEP,CMD)
      CALL GETVIS('BASE_MODALE','NUME_ORDRE',1,IARG,0,IBID,NBNO)
      CALL GETVR8('BASE_MODALE','AMOR_REDUIT',1,IARG,0,RBID,NBAM)
      CALL GETVR8('BASE_MODALE','AMOR_REDUIT_CONN',1,IARG,0,RBID,NBCONN)
      IFR = IUNIFI('RESULTAT')
      IFM = IUNIFI('MESSAGE')
      WRITE(IFR,1000)
C
C
C --- 0.VERIFICATIONS AVANT EXECUTION ---
C
      IF (NBNO.NE.0 .AND. NBAM.NE.0 .AND. NBAM.NE.NBNO) THEN
        CALL U2MESS('F','ALGELINE2_82')
      ENDIF

      IF (NBNO.NE.0 .AND. NBCONN.NE.0 .AND. NBCONN.NE.NBNO) THEN
        CALL U2MESS('F','ALGELINE2_83')
      ENDIF
C
C --- 1.RECUPERATION DES CARACTERISTIQUES MODALES AVANT COUPLAGE ---
C
      CALL GETVID('BASE_MODALE','MODE_MECA',1,IARG,1,NOMBM,ZI)
C
      TMODE = .FALSE.
      CALCUL(1)=.FALSE.
      CALCUL(2)=.FALSE.
      IF (NBNO.EQ.0) THEN
        TMODE = .TRUE.
        NUMOI = NOMBM//'           .ORDR'
        CALL JELIRA(NUMOI,'LONUTI',NBNO,K8B)
        CALL ASSERT(NBAM.EQ.0 .OR. ABS(NBAM).EQ.NBNO)
      ELSE
        NBNO = ABS(NBNO)
      ENDIF
C
C --- 1.1.CREATION ET REMPLISSAGE DE L'OBJET .NUMO
C
      NUMO = NOMU//'.NUMO'
      CALL WKVECT(NUMO,'G V I',NBNO,INUMO)
      IF (TMODE) THEN
        DO 10 I = 1,NBNO
          ZI(INUMO+I-1) = I
  10    CONTINUE
      ELSE
        CALL GETVIS('BASE_MODALE','NUME_ORDRE',1,IARG,NBNO,
     &              ZI(INUMO),IBID)
      ENDIF
C
C --- 1.2.CREATION D'UN VECTEUR TEMPORAIRE POUR LES AMORTISSEMENTS
C
      CALL WKVECT('&&OP0144.TEMP.AMOR','V V R',NBNO,IAMOR)
      CALL WKVECT('&&OP0144.CONNORS.AMOR','V V R',NBNO,ICONN)
      IF (NBAM.NE.0) THEN
        CALL GETVR8('BASE_MODALE','AMOR_REDUIT',1,IARG,0,AMOR,IBID)
        CALL GETVR8('BASE_MODALE','AMOR_REDUIT',1,IARG,NBNO,
     &              ZR(IAMOR),IBID)
        CALCUL(1)=.TRUE.
      ELSE IF (NBCONN.EQ.0) THEN
        CALCUL(1)=.TRUE.
        CALL GETVR8('BASE_MODALE','AMOR_UNIF',1,IARG,1,AMOR,IBID)
        DO 20 I = 1,NBNO
          ZR(IAMOR+I-1) = AMOR
  20    CONTINUE
      ENDIF

      IF (NBCONN.NE.0) THEN
        CALL GETVR8('BASE_MODALE','AMOR_REDUIT_CONN',1,IARG,NBNO,
     &               ZR(ICONN),IBID)
        CALCUL(2)=.TRUE.
      ENDIF
C
C
C --- 2.RECUPERATION DE LA PLAGE DE VITESSES D'ECOULEMENT ---
C
C --- 2.1.CREATION ET REMPLISSAGE DE L'OBJET .VITE
C
      CALL GETVR8('VITE_FLUI','VITE_MIN',1,IARG,1,VMIN,ZI)
      CALL GETVR8('VITE_FLUI','VITE_MAX',1,IARG,1,VMAX,ZI)
      CALL GETVIS('VITE_FLUI','NB_POIN ',1,IARG,1,NBPV,ZI)
      IF (VMIN.GT.VMAX) THEN
        UMIN = VMIN
        VMIN = VMAX
        VMAX = UMIN
        CALL U2MESS('A','ALGELINE2_85')
      ENDIF
C
      VITE = NOMU//'.VITE'
      CALL WKVECT(VITE,'G V R',NBPV,IVITE)
      IF (NBPV.EQ.1) THEN
        VMOY = (VMIN+VMAX)/2.D0
        WRITE(IFM,*)'UNE SEULE VITESSE D''ECOULEMENT ETUDIEE :'//
     &              ' VMOY = (VMIN+VMAX)/2'
        ZR(IVITE) = VMOY
      ELSE
        VPAS = (VMAX-VMIN)/(NBPV-1)
        DO 30 IV = 1,NBPV
          ZR(IVITE+IV-1) = VMIN + (IV-1)*VPAS
  30    CONTINUE
      ENDIF
C
C --- 2.2.CREATION DE L'OBJET .FREQ
C
      FREQ = NOMU//'.FREQ'
      CALL WKVECT(FREQ,'G V R',2*NBNO*NBPV,IFREQ)
C
C
C --- 3.RECUPERATION DU CONCEPT TYPE_FLUI_STRU   ---
C
C --- 3.1.CREATION ET REMPLISSAGE DE L'OBJET .REMF
C
      CALL WKVECT(NOMU//'.REMF','G V K8',2,IREFE)
      CALL GETVID(' ','TYPE_FLUI_STRU',0,IARG,1,TYPFLU,IBID)
      ZK8(IREFE)   = TYPFLU
      ZK8(IREFE+1) = NOMBM
C
C --- 3.2.DETERMINATION DU TYPE DE LA CONFIGURATION ETUDIEE
C
      FSIC = TYPFLU//'           .FSIC'
      CALL JEVEUO(FSIC,'L',IFSIC)
      ITYPFL = ZI(IFSIC)
C
C
C --- 4.RECUPERATION DES NIVEAUX D'IMPRESSION ---
C
      NIVPAR = 0
      NIVDEF = 0
      CALL GETFAC('IMPRESSION',NBOCC)
      IF (NBOCC.NE.0) THEN
        CALL GETVTX('IMPRESSION','PARA_COUPLAGE',1,IARG,1,K8B,IBID)
        IF (K8B(1:3).EQ.'OUI') NIVPAR = 1
        CALL GETVTX('IMPRESSION','DEFORMEE',1,IARG,1,K8B,IBID)
        IF (K8B(1:3).EQ.'OUI') NIVDEF = 1
      ENDIF
C
C
C --- 5.CREATION ET REMPLISSAGE DE L'OBJET .DESC ---
C
      DESC = NOMU//'.DESC'
      CALL WKVECT(DESC,'G V K16',1,IDESC)
      ZK16(IDESC) = 'DEPL'
C
C
C --- 6.CREATION ET REMPLISSAGE DE LA TABLE DES NOMS DES CHAMPS ---
C ---   DE DEPLACEMENTS MODAUX                                  ---
C ---   SIMULTANEMENT ON CREE LES OBJETS .REFE , .DESC ET .VALE ---
C ---   ASSOCIES A CHACUN DES CHAMPS                            ---
C ---   POUR LE PREMIER CHAMP ON CREE LE PROF_CHNO QUI VAUT     ---
C ---   ENSUITE POUR TOUS LES AUTRES CHAMPS                     ---
C
C --- 6.1.RECUPERATION D'INFORMATIONS NECESSAIRES
C ---     A LA CREATION DES OBJETS ASSOCIES AUX CHAMPS
C ---     A LA CREATION DU PROF_CHNO COMMUN
C
      REFEBM = NOMBM//'           .REFD'
      CALL JEVEUO(REFEBM,'L',IREFBM)
      MATRIA = ZK24(IREFBM)
C
      CALL DISMOI('F','NOM_MAILLA',MATRIA,'MATR_ASSE',IBID,MAILLA,IRET)
      CALL JELIRA(MAILLA//'.NOMNOE','NOMUTI',NBNOEU,K8B)
      LONG = 6*NBNOEU
C
      GRAN = 'DEPL_R  '
      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',GRAN),NUMGD)
      CALL JEVEUO(JEXNUM('&CATA.GD.NOMCMP',NUMGD),'L',IACMP)
      CALL JEVEUO(JEXATR('&CATA.GD.NOMCMP','LONCUM'),'L',IAV)
      NBCOMP = ZI(IAV+NUMGD) - ZI(IAV+NUMGD-1)
C
      CALL DISMOI('F','NB_EC',GRAN,'GRANDEUR',NEC,K8B,IER)
      CALL WKVECT('&&OP0144.DESC_NOEUD','V V I',NEC*NBNOEU,JDESC)
      DO 40 INO = 1,NBNOEU
        DO 50 ICMP = 1,6
          J = INDIK8(ZK8(IACMP),NOMCMP(ICMP),1,NBCOMP)
          IF (J.NE.0) THEN
            IEC = (J-1)/30 + 1
            JJ = J - 30*(IEC-1)
            ZI(JDESC+(INO-1)*NEC+IEC-1) =
     &              IOR(ZI(JDESC+(INO-1)*NEC+IEC-1),2**JJ)
          ENDIF
  50    CONTINUE
  40  CONTINUE
C
C --- 6.2.CREATION DE LA STRUCTURE TABLE
C
      IF (ITYPFL.EQ.3) THEN
        NBPAR = NBPV
      ELSE
        NBPAR = 1
      ENDIF
      CALL TBCRSD ( NOMU, 'G' )
      CALL TBAJPA ( NOMU, 1, 'NOM_CHAM', 'K24' )
C
C --- 6.31.CREATION DE L'OBJET .MASG
C
      MASG = NOMU//'.MASG'
      CALL WKVECT(MASG,'G V R',NBNO*NBPAR,IMASG)
C
C --- 6.32.CREATION DE L'OBJET .FACT
C
      FACT = NOMU//'.FACT'
      CALL WKVECT(FACT,'G V R',3*NBNO*NBPAR,IFACT)
C
C --- 6.4.REMPLISSAGE DE LA TABLE (NOMS DES CHAMPS) ET CREATION
C ---     SIMULTANEE DES OBJETS ASSOCIES AUX CHAMPS
C
      NOMCHA(1:13)  = NOMU(1:8)//'.C01.'
C
      DO 60 IO = 1,NBNO
C
        WRITE(NOMVAR,'(I3.3)') ZI(INUMO+IO-1)
        NOMCHA(14:16) = NOMVAR(1:3)
C
        DO 70 IPAR = 1,NBPAR
C
          WRITE(NOMPAR,'(I3.3)') IPAR
          NOMCHA(17:24) = NOMPAR(1:3)//'     '
C
          CALL TBAJLI ( NOMU, 1, 'NOM_CHAM',
     &                        IBID, R8B, C16B, NOMCHA, 0 )
C
C --------CREATION DU CHAMP
          CHAM19 = NOMCHA(1:19)
C .DESC
          CHDESC = CHAM19//'.DESC'
          CALL WKVECT(CHDESC,'G V I',2,JCDESC)
          CALL JEECRA(CHDESC,'DOCU',0,'CHNO')
          ZI(JCDESC)   = NUMGD
          ZI(JCDESC+1) = 6
C .VALE
          CHVALE = CHAM19//'.VALE'
          CALL JECREO(CHVALE,'G V R')
          CALL JEECRA(CHVALE,'LONMAX',LONG,K8B)
C .REFE
          CHREFE = CHAM19//'.REFE'
          CALL WKVECT(CHREFE,'G V K24',4,JCREFE)
          ZK24(JCREFE) = MAILLA
C
C --------AU PREMIER PASSAGE CREATION DU PROF_CHNO
          IF (IO.EQ.1 .AND. IPAR.EQ.1) THEN
            ZK24(JCREFE+1) = CHAM19
            CALL CRPRNO(CHAM19,'G',NBNOEU,LONG)
            CALL JEVEUO(CHAM19//'.PRNO','E',JPRNO)
            IDEC = 1
            II = 0
            DO 80 INO = 1,NBNOEU
              ZI(JPRNO-1+(NEC+2)*(INO-1)+1) = IDEC
              ZI(JPRNO-1+(NEC+2)*(INO-1)+2) = 6
              DO 90 INEC = 1,NEC
                II = II + 1
                ZI(JPRNO-1+(NEC+2)*(INO-1)+2+INEC) = ZI(JDESC+II-1)
  90          CONTINUE
              IDEC = IDEC + 6
  80        CONTINUE
            PRCHNO = CHAM19

C           -- CALCUL DE L'OBJET .DEEQ :
            CALL CMPCHA(CHAM19,'&&OP0144.NOMCMP','&&OP0144.CORR1',
     &              '&&OP0144.CORR2',NCMP,NCMPMX)
            CALL JEVEUO('&&OP0144.CORR2','L',JCORR2)
            CALL PTEEQU(PRCHNO,'G',LONG,NUMGD,NCMP,ZI(JCORR2))
            CALL JEDETR('&&OP0144.NOMCMP')
            CALL JEDETR('&&OP0144.CORR1')
            CALL JEDETR('&&OP0144.CORR2')

          ELSE
            ZK24(JCREFE+1) = PRCHNO
          ENDIF
C
  70    CONTINUE
C
  60  CONTINUE
C
C
C --- 7.LANCEMENT DU CALCUL EN FONCTION DU TYPE DE LA CONFIGURATION ---
C ---   ETUDIEE                                                     ---
C
      IF (ITYPFL.EQ.1) THEN
C
        CALL FLUST1 ( NOMU, TYPFLU, NOMBM, ZI(INUMO), ZR(IAMOR),
     &                ZR(ICONN), ZR(IFREQ), ZR(IMASG), ZR(IFACT),
     &                ZR(IVITE),NBNO, CALCUL, NBPV, NIVPAR, NIVDEF )
C
      ELSE IF (ITYPFL.EQ.2) THEN
C
        CALL FLUST2 ( NOMU, TYPFLU, NOMBM, MAILLA, ZI(INUMO), ZR(IAMOR),
     &                ZR(IFREQ), ZR(IMASG), ZR(IFACT), ZR(IVITE),
     &                NBNO, NBPV, NIVPAR, NIVDEF )
C
      ELSE IF (ITYPFL.EQ.3) THEN
C
        CALL FLUST3 ( NOMU, TYPFLU, NOMBM, ZI(INUMO), ZR(IAMOR),
     &                ZR(IFREQ), ZR(IMASG), ZR(IFACT), ZR(IVITE),
     &                NBNO, NBPV, NIVPAR, NIVDEF )
C
      ELSE
C
        CALL FLUST4 ( NOMU, TYPFLU, NOMBM, MAILLA, ZI(INUMO), ZR(IAMOR),
     &                ZR(IFREQ), ZR(IMASG), ZR(IFACT), ZR(IVITE),
     &                NBNO, NBPV, NIVPAR, NIVDEF )
C
      ENDIF
C
C
      CALL JEDEMA()
      CALL JEDETC('G','&&MEFCEN',1)
 1000 FORMAT(/,80('-'))
      END

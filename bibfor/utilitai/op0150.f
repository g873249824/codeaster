      SUBROUTINE OP0150()
      IMPLICIT NONE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 16/05/2011   AUTEUR PELLET J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     BUT:
C       LECTURE D'UN RESULTAT SUR FICHIER EXTERNE AU FORMAT :
C        * UNV (IDEAS)
C        * ENSIGHT
C        * MED
C
C ......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)

      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='OP0150')
      INTEGER LXLGUT
      INTEGER NDIM
      INTEGER NTO,NNU,JLIST,NBORDR,NBNOCH,NVAR
      INTEGER NBVARI,JNUME,NP,ICH,NIS
      INTEGER IRET,NFOR,NBTITR,JTITR,LL
      INTEGER I,LONG,IER
      INTEGER LORDR,IORD,NC
      INTEGER IBID,NBV,NBTROU
      INTEGER NFIC
      INTEGER MFICH,N1,PRECIS,JINST
      INTEGER LNOMA,IFM,NIVINF,ULISOP
      REAL*8 EPSI
      CHARACTER*3 PROLZ
      CHARACTER*4 ACCE
      CHARACTER*8 RESU,NOMA,NOMO,TYPCHA
      CHARACTER*8 CRIT,BLAN8
      CHARACTER*8 CHMAT,CARAEL,MODELE
      CHARACTER*8 K8BID
      CHARACTER*8 PARAM,NORACI
      CHARACTER*10 ACCES
      CHARACTER*16 NOMCMD,CONCEP,TYPRES,FICH
      CHARACTER*16 LINOCH(100),FORM,NOCH,K16NOM
      CHARACTER*19 LISTR8,LISTIS,NOMCH,LIGREL
      CHARACTER*19 PRCHND
      CHARACTER*24 VALK(2)
      CHARACTER*24 OPTION
      COMPLEX*16 CBID
      REAL*8 RBID
      CHARACTER*64 NOCHMD

      CHARACTER*8 NOMGD
      INTEGER N2
      INTEGER NBCMPV,IAUX,N3

      INTEGER IINST,NCHAR

      CHARACTER*24 NCMPVA,NCMPVM
      CHARACTER*7 LCMPVA
      PARAMETER (LCMPVA='NOM_CMP')
      CHARACTER*11 LCMPVM
      PARAMETER (LCMPVM='NOM_CMP_MED')
      INTEGER JCMPVA,JCMPVM

      CHARACTER*72 REP

C ----------------------------------------------------------------------

      CALL JEMARQ()

C              12345678
      BLAN8 = '        '
      CHMAT  = BLAN8
      CARAEL = BLAN8
      MODELE = BLAN8

      CALL GETRES(RESU,CONCEP,NOMCMD)
      CALL GETVTX(' ','TYPE_RESU',0,1,1,TYPRES,N1)
      CALL ASSERT(TYPRES.EQ.CONCEP)
      CALL GETVTX(' ','NOM_FICHIER',0,1,1,FICH,NFIC)

      CALL INFMAJ
      CALL INFNIV(IFM,NIVINF)
C
C     --- FORMAT ---
      CALL GETVTX(' ','FORMAT',0,1,1,FORM,NFOR)
      CALL GETVIS(' ','UNITE',0,1,1,MFICH,N1)
      IF ((N1.GT.0) .AND. (FORM.NE.'MED')) THEN
        K16NOM = ' '
        IF (ULISOP(MFICH,K16NOM).EQ.0) THEN
          CALL ULOPEN(MFICH,' ',' ','NEW','O')
        END IF
      END IF
      CALL GETVTX(' ','NOM_FICHIER',0,1,1,FICH,N1)
C
C     ---  LISTE DES CHAMPS A LIRE ---
      CALL GETFAC('FORMAT_MED',N1)
      IF (N1.GT.0) THEN
        NBNOCH = N1
        IF (NBNOCH.GT.100) THEN
          NBNOCH = -NBNOCH
        ELSE
          DO 10,I = 1,NBNOCH
            CALL GETVTX('FORMAT_MED','NOM_CHAM',I,1,1,LINOCH(I),N1)
   10     CONTINUE
        END IF
      ELSE
        CALL GETVTX(' ','NOM_CHAM',0,1,100,LINOCH,NBNOCH)
      END IF
      IF (NBNOCH.LT.0) CALL U2MESS('F','UTILITAI2_86')
C
C     --- NOMBRE DE VARIABLES INTERNES A LIRE ---
      CALL GETVIS(' ','NB_VARI',0,1,1,NBVARI,NVAR)
C
C     --- MAILLAGE ---
      CALL GETVID(' ','MAILLAGE',0,1,1,NOMA,NBV)
C
C     --- MODELE ---
      CALL GETVID(' ','MODELE',0,1,1,NOMO,NBV)
      IF (NBV.NE.0) THEN
        LIGREL = NOMO//'.MODELE'
        CALL JEVEUO(LIGREL//'.LGRF','L',LNOMA)
        NOMA = ZK8(LNOMA)
      END IF
C
C     --- QUELS SONT LES INSTANTS A RELIRE ---
      NNU=0
      NIS=0
      CALL GETVTX(' ','TOUT_ORDRE',0,1,1,K8BID,NTO)
      IF (NTO.NE.0) THEN
        ACCES = 'TOUT_ORDRE'
        NBORDR = 100
        IINST=0
        GO TO 20
      END IF

      CALL GETVIS(' ','NUME_ORDRE',0,1,0,IBID,NNU)
      IF (NNU.NE.0) THEN
        ACCES = 'NUME_ORDRE'
        LISTIS = '&&'//NOMPRO
        NBORDR = -NNU
        CALL WKVECT(LISTIS//'.VALE','V V I',NBORDR,JNUME)
        CALL GETVIS(' ','NUME_ORDRE',0,1,NBORDR,ZI(JNUME),N1)
C       ICI ON TRIE POUR QUE LE .ORDR DE LA SD_RESULTAT
C       PRODUITE SOIT STRICTEMENT CROISSANT
        CALL UTTRII(ZI(JNUME),NBORDR)
        IINST=0
        GO TO 20
      END IF

      CALL GETVID(' ','LIST_ORDRE',0,1,1,LISTIS,NNU)
      IF (NNU.NE.0) THEN
        ACCES = 'LIST_ORDRE'
        IINST=0
        CALL JEVEUO(LISTIS//'.VALE','L',JNUME)
        CALL JELIRA(LISTIS//'.VALE','LONMAX',NBORDR,K8BID)
        CALL UTTRII(ZI(JNUME),NBORDR)
        GO TO 20
      END IF

      CALL GETVR8(' ','INST',0,1,0,RBID,NIS)
      IF (NIS.NE.0) THEN
        ACCES = 'INST'
        LISTR8 = '&&'//NOMPRO
        NBORDR = -NIS
        IINST=1
        CALL WKVECT(LISTR8//'.VALE','V V R',NBORDR,JLIST)
        CALL GETVR8(' ','INST',0,1,NBORDR,ZR(JLIST),N1)
        GO TO 20
      END IF

      CALL GETVID(' ','LIST_INST',0,1,1,LISTR8,NIS)
      IF (NIS.NE.0) THEN
        ACCES = 'LIST_INST'
        IINST=1
        CALL JEVEUO(LISTR8//'.VALE','L',JLIST)
        CALL JELIRA(LISTR8//'.VALE','LONMAX',NBORDR,K8BID)
        GO TO 20
      END IF

      CALL GETVR8(' ','FREQ',0,1,0,RBID,NIS)
      IF (NIS.NE.0) THEN
        ACCES = 'FREQ'
        LISTR8 = '&&'//NOMPRO
        NBORDR = -NIS
        IINST=1
        CALL WKVECT(LISTR8//'.VALE','V V R',NBORDR,JLIST)
        CALL GETVR8(' ','FREQ',0,1,NBORDR,ZR(JLIST),N1)
        GO TO 20
      END IF

      CALL GETVID(' ','LIST_FREQ',0,1,1,LISTR8,NIS)
      IF (NIS.NE.0) THEN
        ACCES = 'LIST_FREQ'
        IINST=1
        CALL JEVEUO(LISTR8//'.VALE','L',JLIST)
        CALL JELIRA(LISTR8//'.VALE','LONMAX',NBORDR,K8BID)
        GO TO 20
      END IF

   20 CONTINUE
C
C     --- LECTURE DE LA PRECISION ET DU CRITERE ---
      CALL GETVR8(' ','PRECISION',0,1,1,EPSI,NP)
      CALL GETVTX(' ','CRITERE',0,1,1,CRIT,NC)
      PRECIS = 0
      IF (NP.NE.0) PRECIS = 1
C
C     --- NOMBRE DE VARIABLES INTERNES A LIRE ---
      CALL GETVIS(' ','NB_VARI',0,1,1,NBVARI,NVAR)
C
C     --- CREATION DE LA STRUCTURE DE DONNEES RESULTAT ---
      CALL RSCRSD('G',RESU,TYPRES,NBORDR)

      ACCE = 'INST'
      CALL RSEXPA(RESU,0,'FREQ',IRET)
      IF (IRET.GT.0) ACCE = 'FREQ'

C- ON VERIFIE SI LE CHAMP DEMANDE EST COMPATIBLE AVEC LE TYPE DE RESUTAT

      DO 30 ICH = 1,NBNOCH
        CALL RSUTCH(RESU,LINOCH(ICH),1,NOMCH,IRET)
        IF (IRET.NE.0) THEN
          VALK (1) = TYPRES
          VALK (2) = LINOCH(ICH)
          CALL U2MESG('F','UTILITAI8_24',2,VALK,0,0,0,0.D0)
        END IF
   30 CONTINUE



      IF (FORM.EQ.'IDEAS') THEN
C     =========================
C
        CALL JEEXIN(NOMA//'           .TITR',IRET)
        IF (IRET.EQ.0) THEN
          CALL U2MESS('A','UTILITAI2_87')
        ELSE
          CALL JEVEUO(NOMA//'           .TITR','L',JTITR)
          CALL JELIRA(NOMA//'           .TITR','LONMAX',NBTITR,K8BID)
          IF (NBTITR.GE.1) THEN
            IF (ZK80(JTITR) (10:31).NE.'AUTEUR=INTERFACE_IDEAS') THEN
              CALL U2MESS('A','UTILITAI2_87')
            END IF
          ELSE
            CALL U2MESS('A','UTILITAI2_87')
          END IF
        END IF
C
C     --- LECTURE
C
        CALL LRIDEA(RESU,TYPRES,LINOCH,NBNOCH,NOMCMD,LISTR8,LISTIS,
     &              PRECIS,CRIT,EPSI,ACCES,MFICH,NOMA,LIGREL,NBVARI)
C
C     --- FIN LECTURE
C
      ELSE IF (FORM.EQ.'IDEAS_DS58') THEN
C     ================================
C
        CALL JEEXIN(NOMA//'           .TITR',IRET)
        IF (IRET.EQ.0) THEN
          CALL U2MESS('A','UTILITAI2_87')
        ELSE
          CALL JEVEUO(NOMA//'           .TITR','L',JTITR)
          CALL JELIRA(NOMA//'           .TITR','LONMAX',NBTITR,K8BID)
          IF (NBTITR.GE.1) THEN
            IF (ZK80(JTITR) (10:31).NE.'AUTEUR=INTERFACE_IDEAS') THEN
              CALL U2MESS('A','UTILITAI2_87')
            END IF
          ELSE
            CALL U2MESS('A','UTILITAI2_87')
          END IF
        END IF
C
C     --- LECTURE
C
        CALL LECT58(MFICH,RESU,NOMA,TYPRES,ACCES,LISTR8,LISTIS,PRECIS,
     &              CRIT,EPSI,LINOCH,NBNOCH)
C
C     --- FIN LECTURE
C
      ELSE IF (FORM.EQ.'ENSIGHT') THEN
C     ================================
C
        CALL JEEXIN(LIGREL//'.LGRF',IRET)
        IF (IRET.EQ.0) THEN
          CALL U2MESS('F','UTILITAI2_88')
        ELSE
          CALL DISMOI('F','DIM_GEOM',NOMO,'MODELE',NDIM,K8BID,IER)
          IF (.NOT.(NDIM.EQ.2.OR.NDIM.EQ.3))
     &         CALL U2MESS('F','MODELISA2_6')
        END IF

        IF (NBNOCH.NE.1 .OR. LINOCH(1).NE.'PRES') THEN
          CALL U2MESS('F','UTILITAI2_89')
        END IF

        CALL GETVTX(' ','NOM_FICHIER',0,1,1,FICH,NFIC)
        LL = LEN(FICH)
        DO 40 I = 1,LL
          IF (FICH(I:I).NE.' ') GO TO 40
          LONG = I - 1
          GO TO 50
   40   CONTINUE
   50   CONTINUE
C
C     --- LECTURE
C
        CALL LRENSI(FICH,LONG,LINOCH,NDIM,NOMO,NOMA,RESU)
C
C     --- FIN LECTURE
C
      ELSE IF (FORM.EQ.'MED') THEN
C     =============================
C
C       ON VERIFIE QUE LE PHENOMENE DU MODELE FOURNI EST COHERENT AVEC
C       LA SD RESULTAT
        CALL GETVID(' ','MODELE',0,1,1,NOMO,NBV)
        IF (NBV.EQ.1) THEN
           CALL LRVEMO(NOMO)
        ENDIF

C       CREATION DE L'OBJET .REFD DANS LES MODE_MECA
        IF ((TYPRES.EQ.'MODE_MECA').OR.(TYPRES.EQ.'MODE_MECA_C')) THEN
          CALL LRREFD(RESU,PRCHND)
        ENDIF

        DO 260 I = 1,NBNOCH
          OPTION = ' '
          PARAM  = ' '

          CALL GETVTX('FORMAT_MED','NOM_CHAM',I,1,1,NOCH,N1)

          CALL CARCHA(NOCH,NOMGD,TYPCHA,OPTION,PARAM)

C         NOM DU CHAMP MED
          CALL GETVTX('FORMAT_MED','NOM_CHAM_MED',I,1,1,NOCHMD,N1)
            IF(N1.EQ.0)THEN
C                     12345678901234567890123456789012
              NOCHMD='________________________________'//
     &               '________________________________'
              CALL GETVTX('FORMAT_MED','NOM_RESU',I,1,1,NORACI,N2)
              NCHAR=LXLGUT(NORACI)
              NOCHMD(1:NCHAR)=NORACI(1:NCHAR)
              NCHAR=LXLGUT(NOCH)
              NOCHMD(9:8+NCHAR)=NOCH(1:NCHAR)
              NOCHMD(9+NCHAR:64)=' '
            ENDIF

C         NOM DES COMPOSANTES VOULUES
          NCMPVA = '&&'//NOMPRO//'.'//LCMPVA
          NCMPVM = '&&'//NOMPRO//'.'//LCMPVM
C         NOM_CMP ASTER ?
          NBCMPV=0
          CALL GETVTX('FORMAT_MED',LCMPVA,I,1,0,REP,IAUX)
          IF (IAUX.LT.0) THEN
            NBCMPV = -IAUX
          ENDIF

C         NOM_CMP MED ?
          CALL GETVTX('FORMAT_MED',LCMPVM,I,1,0,REP,IAUX)
          IF (-IAUX.NE.NBCMPV) THEN
            VALK(1) = LCMPVA
            VALK(2) = LCMPVM
            CALL U2MESK('F','UTILITAI2_95', 2 ,VALK)
          ENDIF
          IF (NBCMPV.GT.0) THEN
            CALL WKVECT(NCMPVA,'V V K8',NBCMPV,JCMPVA)
            CALL GETVTX('FORMAT_MED',LCMPVA,I,1,NBCMPV,ZK8(JCMPVA),IAUX)
            CALL WKVECT(NCMPVM,'V V K16',NBCMPV,JCMPVM)
            CALL GETVTX('FORMAT_MED',LCMPVM,I,1,NBCMPV,ZK16(JCMPVM),
     &                     IAUX)
          ENDIF

C         PROLONGEMENT PAR ZERO OU NOT A NUMBER
          CALL GETVTX(' ', 'PROL_ZERO', 0, 1, 1, PROLZ, IAUX)
          IF (PROLZ.NE.'OUI') THEN
            PROLZ = 'NAN'
          ENDIF
          CALL LRFMED(RESU,I,MFICH,NOMGD,TYPCHA,OPTION,PARAM,NOCHMD,
     &                  ACCES,NBORDR,NNU,NIS,NTO,JNUME,JLIST,NOMA,
     &                  NBCMPV,NCMPVA,
     &                  NCMPVM,PROLZ,IINST,CRIT,EPSI,LIGREL,LINOCH,ACCE)
260      CONTINUE
C
C     POUR LES FORMATS NON PREVUS
C     ===========================
      ELSE
         CALL ASSERT(.FALSE.)
      END IF

C - STOCKAGE EVENTUEL : MODELE, CHAM_MATER, CARA_ELEM, EXCIT
C   --------------------------------------------------------
      CALL GETVID(' ','CHAM_MATER',0,1,0,K8BID,N1)
      CALL GETVID(' ','CARA_ELEM',0,1,0,K8BID,N2)
      CALL GETVID(' ','MODELE',0,1,0,K8BID,N3)
C
      IF (((N1.NE.0).OR.(N2.NE.0).OR.(N3.NE.0)).AND.
     &    ((TYPRES.EQ.'EVOL_CHAR').OR.(TYPRES.EQ.'HARM_GENE'))) THEN
        IF ((N3.NE.0).AND.(FORM.EQ.'ENSIGHT')) THEN
          CALL U2MESK('I','UTILITAI5_98',1,TYPRES)
          GOTO 265
        ELSE
          CALL U2MESK('A','UTILITAI5_93',1,TYPRES)
          GOTO 265
        ENDIF
      ENDIF
C
      IF (N1.NE.0) CALL GETVID(' ','CHAM_MATER',0,1,1,CHMAT,IRET)
      IF (N2.NE.0) CALL GETVID(' ','CARA_ELEM',0,1,1,CARAEL,IRET)
      IF (N3.NE.0) CALL GETVID(' ','MODELE',0,1,1,MODELE,IRET)
C
      CALL LRCOMM(RESU,TYPRES,NBORDR,CHMAT,CARAEL,MODELE)
C
265   CONTINUE
C
C     -- MESSAGE D'INFORMATION SUR CE QU'ON A LU :
C     --------------------------------------------
      IF (NIVINF.GE.2) THEN
        WRITE (IFM,*) ' LECTURE DES CHAMPS:'
        DO 270 ICH = 1,NBNOCH
          WRITE (IFM,*) '    CHAMP : ',LINOCH(ICH)
  270   CONTINUE

        CALL WKVECT('&&'//NOMPRO//'.NUME_ORDR','V V I',NBORDR,LORDR)
        CALL RSORAC(RESU,'TOUT_ORDRE',IBID,RBID,K8BID,CBID,EPSI,CRIT,
     &            ZI(LORDR),NBORDR,NBTROU)
        DO 280 IORD = 1,NBORDR
          CALL RSADPA(RESU,'L',1,ACCE,ZI(LORDR+IORD-1),0,JINST,K8BID)
          WRITE (IFM,*) '    NUMERO D''ORDRE : ',ZI(LORDR+IORD-1),
     &        '    '//ACCES//' : ',ZR(JINST)
  280   CONTINUE
      END IF

      CALL TITRE

C     -- CREATION D'UN .REFD VIDE SI NECESSAIRE :
C     ---------------------------------------------------
      IF( TYPRES.EQ.'HARM_GENE'  .OR.
     &    TYPRES.EQ.'DYNA_TRANS' .OR.
     &    TYPRES.EQ.'DYNA_HARMO' .OR.
     &    TYPRES(1:9).EQ.'MODE_MECA' )THEN
         CALL AJREFD(' ',RESU,'FORCE')
      ENDIF

      CALL JEDEMA()
      END

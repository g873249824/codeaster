      SUBROUTINE OP0150(IER)
C     -----------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 14/04/2003   AUTEUR DURAND C.DURAND 
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
C TOLE CRP_20 CRS_512
C     LECTURE D'UN RESULTAT SUR FICHIER EXTERNE AU FORMAT
C         - UNV (IDEAS)
C         - ENSIGHT
C         _ MED

C     -----------------------------------------------------------------

      IMPLICIT NONE

C 0.1. ==> ARGUMENTS

      INTEGER IER

C 0.2. ==> COMMUNS
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
C     -----  FIN  COMMUNS NORMALISES  JEVEUX --------------------------

C 0.3. ==> VARIABLES LOCALES

      CHARACTER*6 NOMPRO
      PARAMETER (NOMPRO='OP0150')
      INTEGER NTYMAX
      PARAMETER (NTYMAX=28)

      INTEGER NDIM, TYPGEO(NTYMAX),LETYPE
      INTEGER NBTYP,NNOTYP(NTYMAX),NITTYP(NTYMAX)
      INTEGER RENUMD(NTYMAX)

      INTEGER NTO,NNU,JLIST,NBORDR,NBNOCH,NVAR
      INTEGER NBVARI,JNUME,NP,ICH,NIS,NPAS
      INTEGER IRET,NFOR,NBTITR,JTITR,LL
      INTEGER I,LONG,IO,NSCAL,NVECT,NFLAG
      INTEGER IPAS,I1,I2,NBNO,INOPR,NCARLU
      INTEGER I21,NLIG,IPRES,NBGR,NFACHA
      INTEGER IDEC,JCELD,NBELGR,IEL,IMA,LIEL
      INTEGER INO,NNO,II,IADNO,IAD,JCELV
      INTEGER LORDR,IORD,NBORLU,NC,INDIIS
      INTEGER IBID,NBV,NBTROU,NSTAR,J,IREST
      INTEGER TE,TYPELE,NBGREL,NFIC,NBELEM,IGR
      INTEGER MFICH,N1,PRECIS,JINST,ITPS
      INTEGER LNOMA,IFM,NIV
      REAL*8 EPSI
      CHARACTER*1 KBID
      CHARACTER*3 DATA58
      CHARACTER*4 ACCE
      CHARACTER*8 RESU,NOMA,NOMO,TYPCHA,NPRFCN
      CHARACTER*8 K8B,CRIT,CHAINE
      CHARACTER*8 LPAIN(1),LPAOUT(1),K8BID
      CHARACTER*8 NOMTYP(NTYMAX)
      CHARACTER*10 ACCES
      CHARACTER*16 NOMCMD,CONCEP,TYPRES,FICH
      CHARACTER*19 LISTR8,LISTIS,NOMCH,LIGRMO,LIGREL
      CHARACTER*19 CHPRES,NOMPRN
      CHARACTER*16 DIR,NOMTE,LINOCH(100),FORM,NOCH
      CHARACTER*24 LCHIN(1),LCHOUT(1)
      CHARACTER*24 NOLIEL
      CHARACTER*80 K80B,FIRES,FIPRES,FIGEOM,FIC80B
      CHARACTER*24 CHGEOM,OPTION,CONNEX
      COMPLEX*16 CBID
      REAL*8 RBID
      CHARACTER*32 NOCHMD,NOMAMD
      CHARACTER*200 NOFIMD
      INTEGER TYPENT,TYPGOM
      INTEGER EDNOEU
      PARAMETER (EDNOEU=3)
      INTEGER EDMAIL
      PARAMETER (EDMAIL=0)
      INTEGER EDNONO
      PARAMETER (EDNONO=-1)
      INTEGER TYPNOE
      PARAMETER (TYPNOE=0)
      CHARACTER*19 PREFIX
      CHARACTER*8 SAUX08

      CHARACTER*8 CHANOM,NOMGD
      INTEGER NUMPT,NUMORD,INUM
      INTEGER NBCMPV,IAUX

      CHARACTER*24 NCMPVA,NCMPVM
      CHARACTER*7 LCMPVA
      PARAMETER (LCMPVA='NOM_CMP')
      CHARACTER*11 LCMPVM
      PARAMETER (LCMPVM='NOM_CMP_MED')
      INTEGER JCMPVA,JCMPVM

      CHARACTER*72 REP
      CHARACTER*32 K32B

      LOGICAL EXISTM

C     -----------------------------------------------------------------

      CALL JEMARQ()

      CALL GETRES(RESU,CONCEP,NOMCMD)
      CALL GETVTX(' ','TYPE_RESU',0,1,1,TYPRES,N1)
      CALL ASSERT(TYPRES.EQ.CONCEP)
      CALL GETVTX(' ','NOM_FICHIER',0,1,1,FICH,NFIC)

      CALL INFMAJ
      CALL INFNIV(IFM,NIV)


C     --- FORMAT ---

      CALL GETVTX(' ','FORMAT',0,1,1,FORM,NFOR)
      CALL GETVIS(' ','UNITE',0,1,1,MFICH,N1)
      IF ((N1.GT.0) .AND. (FORM.NE.'MED')) CALL ASOPEN(MFICH,' ')
      CALL GETVTX(' ','NOM_FICHIER',0,1,1,FICH,N1)

C     --- RESULTAT , CHAMPS ---

      CALL GETVTX(' ','NOM_CHAM',0,1,100,LINOCH,NBNOCH)
      IF (NBNOCH.LT.0) THEN
        CALL UTMESS('F',NOMPRO,'LE NOMBRE DE CHAMPS A LIRE '//
     &              'EST SUPERIEUR A 100')
      END IF

C     --- NOMBRE DE VARIABLES INTERNES A LIRE ---

      CALL GETVIS(' ','NB_VARI',0,1,1,NBVARI,NVAR)

C     --- MAILLAGE ---

      CALL GETVID(' ','MAILLAGE',0,1,1,NOMA,NBV)

C     --- MODELE ---

      CALL GETVID(' ','MODELE',0,1,1,NOMO,NBV)
      IF (NBV.NE.0) THEN
        LIGREL = NOMO//'.MODELE'
        CALL JEVEUO(LIGREL//'.NOMA','L',LNOMA)
        NOMA = ZK8(LNOMA)
      END IF

C     --- QUELS SONT LES INSTANTS A RELIRE ---

      CALL GETVTX(' ','TOUT_ORDRE',0,1,1,K8B,NTO)
      IF (NTO.NE.0) THEN
        ACCES = 'TOUT_ORDRE'
        NBORDR = 100
        GO TO 10
      END IF

      CALL GETVIS(' ','NUME_ORDRE',0,1,0,IBID,NNU)
      IF (NNU.NE.0) THEN
        ACCES = 'NUME_ORDRE'
        LISTIS = '&&'//NOMPRO
        NBORDR = -NNU
        CALL WKVECT(LISTIS//'.VALE','V V I',NBORDR,JNUME)
        CALL GETVIS(' ','NUME_ORDRE',0,1,NBORDR,ZI(JNUME),N1)
        GO TO 10
      END IF

      CALL GETVID(' ','LIST_ORDRE',0,1,1,LISTIS,NNU)
      IF (NNU.NE.0) THEN
        ACCES = 'LIST_ORDRE'
        CALL JEVEUO(LISTIS//'.VALE','L',JNUME)
        CALL JELIRA(LISTIS//'.VALE','LONMAX',NBORDR,K8B)
        GO TO 10
      END IF

      CALL GETVR8(' ','INST',0,1,0,RBID,NIS)
      IF (NIS.NE.0) THEN
        ACCES = 'INST'
        LISTR8 = '&&'//NOMPRO
        NBORDR = -NIS
        CALL WKVECT(LISTR8//'.VALE','V V R',NBORDR,JLIST)
        CALL GETVR8(' ','INST',0,1,NBORDR,ZR(JLIST),N1)
        GO TO 10
      END IF

      CALL GETVID(' ','LIST_INST',0,1,1,LISTR8,NIS)
      IF (NIS.NE.0) THEN
        ACCES = 'LIST_INST'
        CALL JEVEUO(LISTR8//'.VALE','L',JLIST)
        CALL JELIRA(LISTR8//'.VALE','LONMAX',NBORDR,K8B)
        GO TO 10
      END IF

      CALL GETVR8(' ','FREQ',0,1,0,RBID,NIS)
      IF (NIS.NE.0) THEN
        ACCES = 'FREQ'
        LISTR8 = '&&'//NOMPRO
        NBORDR = -NIS
        CALL WKVECT(LISTR8//'.VALE','V V R',NBORDR,JLIST)
        CALL GETVR8(' ','FREQ',0,1,NBORDR,ZR(JLIST),N1)
        GO TO 10
      END IF

      CALL GETVID(' ','LIST_FREQ',0,1,1,LISTR8,NIS)
      IF (NIS.NE.0) THEN
        ACCES = 'LIST_FREQ'
        CALL JEVEUO(LISTR8//'.VALE','L',JLIST)
        CALL JELIRA(LISTR8//'.VALE','LONMAX',NBORDR,K8B)
        GO TO 10
      END IF

   10 CONTINUE
      NBORLU = NBORDR

C     --- LECTURE DE LA PRECISION ET DU CRITERE ---

      CALL GETVR8(' ','PRECISION',0,1,1,EPSI,NP)
      CALL GETVTX(' ','CRITERE',0,1,1,CRIT,NC)
      PRECIS = 0
      IF (NP.NE.0) PRECIS = 1

C     --- NOMBRE DE VARIABLES INTERNES A LIRE ---

      CALL GETVIS(' ','NB_VARI',0,1,1,NBVARI,NVAR)

C     --- CREATION DE LA STRUCTURE DE DONNEES RESULTAT ---

      CALL RSCRSD(RESU,TYPRES,NBORDR)

C- ON VERIFIE SI LE CHAMP DEMANDE EST COMPATIBLE AVEC LE TYPE DE RESUTAT

      DO 20 ICH = 1,NBNOCH
        CALL RSUTCH(RESU,LINOCH(ICH),1,NOMCH,IRET)
        IF (IRET.NE.0) THEN
          CALL UTDEBM('F',NOMCMD,'LE CHAMP DEMANDE EST INCOMPATIBLE'//
     &                ' AVEC LE TYPE DE RESULTAT')
          CALL UTIMPK('L',' TYPE DE RESULTAT :',1,TYPRES)
          CALL UTIMPK('L','     NOM DU CHAMP :',1,LINOCH(ICH))
          CALL UTFINM
        END IF
   20 CONTINUE



      IF (FORM.EQ.'IDEAS') THEN
C     =========================

        CALL JEEXIN(NOMA//'           .TITR',IRET)
        IF (IRET.EQ.0) THEN
          CALL UTMESS('A',NOMPRO,'LE MAILLAGE DOIT ETRE ISSU'//
     &          ' D''IDEAS POUR GARANTIR LA COHERENCE ENTRE LE MAILLAGE'
     &                //' ET LES RESULTATS LUS')
        ELSE
          CALL JEVEUO(NOMA//'           .TITR','L',JTITR)
          CALL JELIRA(NOMA//'           .TITR','LONMAX',NBTITR,K8B)
          IF (NBTITR.GE.1) THEN
            IF (ZK80(JTITR) (10:31).NE.'AUTEUR=INTERFACE_IDEAS') THEN
              CALL UTMESS('A',NOMPRO,'LE MAILLAGE DOIT ETRE ISSU'//
     &          ' D''IDEAS POUR GARANTIR LA COHERENCE ENTRE LE MAILLAGE'
     &                    //' ET LES RESULTATS LUS')
            END IF
          ELSE
            CALL UTMESS('A',NOMPRO,'LE MAILLAGE DOIT ETRE ISSU'//
     &          ' D''IDEAS POUR GARANTIR LA COHERENCE ENTRE LE MAILLAGE'
     &                  //' ET LES RESULTATS LUS')
          END IF
        END IF

C     --- LECTURE

        CALL LRIDEA(RESU,TYPRES,LINOCH,NBNOCH,NOMCMD,LISTR8,LISTIS,
     &              PRECIS,CRIT,EPSI,ACCES,MFICH,NOMA,LIGREL,NBVARI)

      ELSE IF (FORM.EQ.'IDEAS_DS58') THEN
C     ================================

        CALL JEEXIN(NOMA//'           .TITR',IRET)
        IF (IRET.EQ.0) THEN
          CALL UTMESS('A',NOMPRO,'LE MAILLAGE DOIT ETRE ISSU'//
     &          ' D''IDEAS POUR GARANTIR LA COHERENCE ENTRE LE MAILLAGE'
     &                //' ET LES RESULTATS LUS')
        ELSE
          CALL JEVEUO(NOMA//'           .TITR','L',JTITR)
          CALL JELIRA(NOMA//'           .TITR','LONMAX',NBTITR,K8B)
          IF (NBTITR.GE.1) THEN
            IF (ZK80(JTITR) (10:31).NE.'AUTEUR=INTERFACE_IDEAS') THEN
              CALL UTMESS('A',NOMPRO,'LE MAILLAGE DOIT ETRE ISSU'//
     &          ' D''IDEAS POUR GARANTIR LA COHERENCE ENTRE LE MAILLAGE'
     &                    //' ET LES RESULTATS LUS')
            END IF
          ELSE
            CALL UTMESS('A',NOMPRO,'LE MAILLAGE DOIT ETRE ISSU'//
     &          ' D''IDEAS POUR GARANTIR LA COHERENCE ENTRE LE MAILLAGE'
     &                  //' ET LES RESULTATS LUS')
          END IF
        END IF

C     --- LECTURE

        CALL LECT58(MFICH,RESU,NOMA,TYPRES,ACCES,LISTR8,LISTIS,PRECIS,
     &              CRIT,EPSI)

C     --- LECTURE

      ELSE IF (FORM.EQ.'ENSIGHT') THEN
C     ================================

        CALL JEEXIN(LIGREL//'.NOMA',IRET)
        IF (IRET.EQ.0) THEN
          CALL UTMESS('F','LRIDEA',' LE MOT CLE MODELE EST'//
     &                ' OBLIGATOIRE POUR UN CHAMP DE TYPE CHAM_ELEM')
        ELSE
          CALL DISMOI('F','DIM_GEOM',NOMO,'MODELE',NDIM,K8BID,IER)
        END IF

        IF (NBNOCH.NE.1 .OR. LINOCH(1).NE.'PRES') THEN
          CALL UTMESS('F','LRIDEA',' LE FORMAT ENSIGHT N''ACCEPTE '//
     &                'QUE LE CHAMP PRES')
        END IF

        CALL GETVTX(' ','NOM_FICHIER',0,1,1,FICH,NFIC)
        LL = LEN(FICH)
        DO 30 I = 1,LL
          IF (FICH(I:I).NE.' ') GO TO 30
          LONG = I - 1
          GO TO 40
   30   CONTINUE
   40   CONTINUE
        DIR = 'DONNEES_ENSIGHT'//'/'
        FIC80B = FICH
        FIRES = DIR//FICH(1:LONG)
        OPEN (99,FILE=FIRES)

C  LECTURE DU FICHIER RESULTS (PAS DE TEMPS
C                              ET FICHIERS GEOM ET PRES)
        READ (99,'(3I8)',ERR=260,END=260,IOSTAT=IO) NSCAL,NVECT,
     &    NFLAG
        READ (99,'(1I8)',ERR=260,END=260,IOSTAT=IO) NPAS

        CALL WKVECT('&&'//NOMPRO//'.INST','V V R',NPAS,IPAS)
        READ (99,'(6(E12.5))',ERR=260,END=260,
     &    IOSTAT=IO) (ZR(IPAS-1+I),I=1,NPAS)
        I1 = 0
        I2 = 0
        IF (NFLAG.GT.0) THEN
          READ (99,'(2I8)',ERR=260,END=260,IOSTAT=IO) I1,I2
        ELSE
          IF (NPAS.NE.1) THEN
            CALL UTMESS('F',NOMPRO,'NFLAG ETANT EGAL A 0, ON NE '//
     &                  'PEUT PAS AVOIR PLUS D''UN INSTANT.')
          END IF
        END IF
        READ (99,'(A80)',ERR=260,END=260,IOSTAT=IO) FIGEOM
        FIGEOM = DIR//FIGEOM
        READ (99,'(A80)',ERR=260,END=260,IOSTAT=IO) FIPRES
        FIPRES = DIR//FIPRES

        FIC80B = FIGEOM
        OPEN (98,FILE=FIGEOM)
C  LECTURE DU FICHIER GEOM (NUMEROS DE NOEUDS)
        READ (98,'(A80)',ERR=260,END=260,IOSTAT=IO) K80B
        READ (98,'(A80)',ERR=260,END=260,IOSTAT=IO) K80B
        READ (98,'(1I8)',ERR=260,END=260,IOSTAT=IO) NBNO
        CALL WKVECT('&&'//NOMPRO//'.NUMNOEU','V V I',NBNO,INOPR)
        DO 50 I = 1,NBNO
          READ (98,'(1I8)',ERR=260,IOSTAT=IO) ZI(INOPR-1+I)
   50   CONTINUE

        NSTAR = 0
        NCARLU = 0
        LL = LEN(FIPRES)
        DO 60 I = 1,LL
          IF (FIPRES(I:I).EQ.'*') THEN
            NSTAR = NSTAR + 1
          END IF
          IF (NSTAR.GT.0 .AND. FIPRES(I:I).EQ.' ') GO TO 70
          NCARLU = NCARLU + 1
   60   CONTINUE
   70   CONTINUE
        LL = NCARLU
        IF (NSTAR.GE.8) THEN
          CALL UTDEBM('F',NOMCMD,
     &                'LE NOMBRE D''ASTERISQUES POUR LES NOMS'//
     &                ' DE FICHIERS ENSIGHT DE PRESSION EST TROP GRAND'
     &                //' IL EST LIMITE A 7')
          CALL UTIMPI('L',' NOMBRE D''ASTERISQUES :',1,NSTAR)
          CALL UTFINM
        END IF

        CHGEOM = NOMA//'.COORDO'

        LPAIN(1) = 'PGEOMER'
        LCHIN(1) = CHGEOM

        LPAOUT(1) = 'PPRES_R'
        CHPRES = '&&CHPRES'
        LCHOUT(1) = CHPRES
        LIGRMO = NOMO//'.MODELE'
        OPTION = 'TOU_INI_ELNO'
        CALL CALCUL('S',OPTION,LIGRMO,1,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V')


C       -- ON VERIFIE QUE LE CHAM_ELEM N'EST PAS TROP DYNAMIQUE :
        CALL CELVER(CHPRES,'NBVARI_CST','STOP',IBID)
        CALL CELVER(CHPRES,'NBSPT_1','STOP',IBID)

        CALL JEVEUO(CHPRES//'.CELD','L',JCELD)
        CALL JEVEUO(CHPRES//'.CELV','E',JCELV)

C  BOUCLE SUR LES PAS DE TEMPS ET LECTURE DES PRESSIONS
C  ----------------------------------------------------

        DO 210 ITPS = 1,NPAS

          I21 = I1 + (ITPS-1)*I2
          CALL CODENT(I21,'D0',CHAINE)
          IF (NSTAR.GT.0) THEN
            FIPRES = FIPRES(1:LL-NSTAR)//CHAINE(9-NSTAR:8)
          END IF
          FIC80B = FIPRES
          OPEN (97,FILE=FIPRES)
          READ (97,'(A80)',ERR=260,END=260,IOSTAT=IO) K80B
          CALL WKVECT('&&'//NOMPRO//'.PRES.'//CHAINE,'V V R',NBNO,IPRES)
          NLIG = NBNO/6
          DO 80 I = 1,NLIG
            READ (97,'(6(E12.5))') (ZR(IPRES-1+6* (I-1)+J),J=1,6)
   80     CONTINUE
          IREST = NBNO - 6*NLIG
          IF (IREST.GT.0) THEN
            READ (97,'(6(E12.5))',ERR=260,END=260,
     &        IOSTAT=IO) (ZR(IPRES-1+6*NLIG+J),J=1,IREST)
          END IF

C  REMPLISSAGE DU .VALE DU CHAM_ELEM DE PRES_R

          CONNEX = NOMA//'.CONNEX'
          NOLIEL = LIGRMO//'.LIEL'
          NBGR = NBGREL(LIGRMO)

          IF (NDIM.GE.3) THEN
            NFACHA = 0
            DO 140 IGR = 1,NBGR
              IDEC = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+8)
              TE = TYPELE(LIGRMO,IGR)
              CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)

              IF (NOMTE.EQ.'MECA_FACE3' .OR. NOMTE.EQ.'MECA_FACE4' .OR.
     &            NOMTE.EQ.'MECA_FACE6' .OR. NOMTE.EQ.'MECA_FACE8' .OR.
     &            NOMTE.EQ.'MECA_FACE9' .OR. NOMTE.EQ.'MEQ4QU4' .OR.
     &            NOMTE.EQ.'MEDSQU4' .OR. NOMTE.EQ.'MEDSTR3' .OR.
     &            NOMTE.EQ.'MEGRDKT') THEN
                NBELGR = NBELEM(LIGRMO,IGR)
                CALL JEVEUO(JEXNUM(NOLIEL,IGR),'L',LIEL)
                DO 130 IEL = 1,NBELGR
                  IMA = ZI(LIEL-1+IEL)
                  CALL JEVEUO(JEXNUM(CONNEX,IMA),'L',IADNO)
                  CALL JELIRA(JEXNUM(CONNEX,IMA),'LONMAX',NNO,KBID)
                  DO 90 INO = 1,NNO
                    II = INDIIS(ZI(INOPR),ZI(IADNO-1+INO),1,NBNO)
                    IF (II.EQ.0) GO TO 110
   90             CONTINUE

C   LA MAILLE IMA EST CHARGEE EN PRESSION

                  NFACHA = NFACHA + 1
                  IAD = JCELV - 1 + IDEC - 1 + NNO* (IEL-1)
                  DO 100 I = 1,NNO
                    II = INDIIS(ZI(INOPR),ZI(IADNO-1+I),1,NBNO)
                    ZR(IAD+I) = ZR(IPRES-1+II)
  100             CONTINUE
                  GO TO 130
  110             CONTINUE

C   LA MAILLE IMA N'EST PAS CHARGEE EN PRESSION

                  IAD = JCELV - 1 + IDEC - 1 + NNO* (IEL-1)
                  DO 120 I = 1,NNO
                    ZR(IAD+I) = 0.0D0
  120             CONTINUE

  130           CONTINUE
              ELSE
                CALL UTMESS('A',NOMPRO,'ELEMENT NON PREVU '//NOMTE)
              END IF
  140       CONTINUE
          END IF

          IF (NDIM.EQ.2 .OR. (NDIM.GE.3.AND.NFACHA.EQ.0)) THEN
            DO 200 IGR = 1,NBGR
              IDEC = ZI(JCELD-1+ZI(JCELD-1+4+IGR)+8)
              TE = TYPELE(LIGRMO,IGR)
              CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',TE),NOMTE)

              IF (NOMTE.EQ.'MEPLSE2' .OR. NOMTE.EQ.'MEAXSE2' .OR.
     &            NOMTE.EQ.'MEPLSE3' .OR. NOMTE.EQ.'MEAXSE3') THEN
                NBELGR = NBELEM(LIGRMO,IGR)
                CALL JEVEUO(JEXNUM(NOLIEL,IGR),'L',LIEL)
                DO 190 IEL = 1,NBELGR
                  IMA = ZI(LIEL-1+IEL)
                  CALL JEVEUO(JEXNUM(CONNEX,IMA),'L',IADNO)
                  CALL JELIRA(JEXNUM(CONNEX,IMA),'LONMAX',NNO,KBID)
                  DO 150 INO = 1,NNO
                    II = INDIIS(ZI(INOPR),ZI(IADNO-1+INO),1,NBNO)
                    IF (II.EQ.0) GO TO 170
  150             CONTINUE

C   LA MAILLE IMA EST CHARGEE EN PRESSION

                  IAD = JCELV - 1 + IDEC - 1 + 2*NNO* (IEL-1)
                  DO 160 I = 1,NNO
                    II = INDIIS(ZI(INOPR),ZI(IADNO-1+I),1,NBNO)
                    ZR(IAD+2*I-1) = ZR(IPRES-1+II)
                    ZR(IAD+2*I) = 0.0D0
  160             CONTINUE
                  GO TO 190
  170             CONTINUE

C   LA MAILLE IMA N'EST PAS CHARGEE EN PRESSION

                  IAD = JCELV - 1 + IDEC - 1 + 2*NNO* (IEL-1)
                  DO 180 I = 1,2*NNO
                    ZR(IAD+I) = 0.0D0
  180             CONTINUE

  190           CONTINUE
              END IF
  200       CONTINUE

          END IF

          CALL RSEXCH(RESU,LINOCH(1),ITPS,NOMCH,IRET)
          IF (IRET.EQ.100) THEN
          ELSE IF (IRET.EQ.110) THEN
            CALL RSAGSD(RESU,0)
            CALL RSEXCH(RESU,LINOCH(1),ITPS,NOMCH,IRET)
          ELSE
            CALL UTDEBM('F',NOMCMD,'APPEL ERRONE')
            CALL UTIMPK('L','  RESULTAT : ',1,RESU)
            CALL UTIMPI('L','  ARCHIVAGE NUMERO : ',1,ITPS)
            CALL UTIMPI('L','  CODE RETOUR DE RSEXCH : ',1,IRET)
            CALL UTIMPK('L','  PROBLEME CHAMP : ',1,NOMCH)
            CALL UTFINM()
          END IF
          CALL COPISD('CHAMP_GD','G',CHPRES,NOMCH)
          CALL RSNOCH(RESU,LINOCH(1),ITPS,' ')
          CALL RSADPA(RESU,'E',1,'INST',ITPS,0,JINST,K8B)
          ZR(JINST) = ZR(IPAS-1+ITPS)

          CALL JEDETR('&&'//NOMPRO//'.PRES.'//CHAINE)

  210   CONTINUE



      ELSE IF (FORM.EQ.'MED') THEN
C     =============================
        CALL GETFAC('FORMAT_MED',N1)
        IF (N1.NE.NBNOCH) THEN
          CALL UTMESS('F','LIRE_RESU','OCCURENCES DE FORMAT_MED '//
     &    'DIFFERENTES DU NOMBRE DE CHAMPS DEMANDES')
        ENDIF
        DO 220 I=1,NBNOCH
           CALL GETVTX('FORMAT_MED','NOM_CHAM_MED',I,1,1,NOCHMD,N1)

           IF (N1.EQ.0) THEN
              CALL UTMESS('F','LIRE_RESU','NOM_CHAM_MED ? (SVP)')
           END IF

           CALL GETVTX('FORMAT_MED','NOM_CHAM',I,1,1,NOCH,N1)
           IF ((TYPRES(1:9).EQ.'EVOL_THER').AND.
     &                     (NOCH(1:4).NE.'TEMP')) THEN
         CALL UTMESS('F','LIRE_RESU','EVOL_THER - CHAMP TEMP UNIQMT')
           ENDIF
           IF (NOCH(1:4).EQ.'TEMP')      THEN 
               NOMGD  = 'TEMP_R  '
               TYPCHA = 'NOEU    '
           ENDIF
           IF (NOCH(1:4).EQ.'DEPL')      THEN 
               NOMGD  = 'DEPL_R  '
               TYPCHA = 'NOEU    '
           ENDIF
           IF (NOCH(1:9).EQ.'SIEF_ELNO') THEN 
               NOMGD  = 'SIEF_R'
               TYPCHA = 'ELNO    '
           ENDIF
           IF (NOCH(1:9).EQ.'EPSA_ELNO') THEN 
               NOMGD  = 'EPSA_R'
               TYPCHA = 'ELNO    '
           ENDIF
           IF (NOCH(1:9).EQ.'VARI_ELNO') THEN 
               NOMGD  = 'VARI_R'
               TYPCHA = 'ELNO    '
           ENDIF

C          ==> NOM DES COMPOSANTES VOULUES
 
           NCMPVA = '&&'//NOMPRO//'.'//LCMPVA
           NCMPVM = '&&'//NOMPRO//'.'//LCMPVM
           CALL GETVTX('FORMAT_MED','NOM_CMP_IDEM',I,1,1,REP,IAUX)

C          ==> C'EST PAR IDENTITE DE NOMS
           IF (IAUX.NE.0) THEN
             IF (REP.EQ.'OUI') THEN
               NBCMPV = 0
             ELSE
               CALL UTMESS('F',NOMPRO,'NOM_CMP_IDEM EST CURIEUX :'//REP)
             END IF
           ELSE

C          ==> C'EST PAR ASSOCIATION DE LISTE
  
             CALL GETVTX('FORMAT_MED',LCMPVA,I,1,0,REP,IAUX)
             IF (IAUX.LT.0) THEN
               NBCMPV = -IAUX
             END IF

             CALL GETVTX('FORMAT_MED',LCMPVM,I,1,0,REP,IAUX)
             IF (-IAUX.NE.NBCMPV) THEN
               CALL UTMESS('F',NOMPRO,LCMPVA//' ET '//LCMPVM//
     &                     ' : NOMBRE '//'DE COMPOSANTES INCOMPATIBLE.')
             END IF

             IF (NBCMPV.GT.0) THEN
               CALL WKVECT(NCMPVA,'V V K8',NBCMPV,JCMPVA)
               CALL GETVTX('FORMAT_MED',LCMPVA,I,1,NBCMPV,ZK8(JCMPVA),
     &                     IAUX)
               CALL WKVECT(NCMPVM,'V V K8',NBCMPV,JCMPVM)
               CALL GETVTX('FORMAT_MED',LCMPVM,I,1,NBCMPV,ZK8(JCMPVM),
     &                     IAUX)
             END IF

           END IF

           CALL CODENT(MFICH,'G',SAUX08)
           NOFIMD = 'fort.'//SAUX08
           WRITE (IFM,*) NOMPRO,' : NOM DU FICHIER MED : ',NOFIMD

           PREFIX = '&&'//NOMPRO//'.MED'
           CALL JEDETC('V',PREFIX,1)

C     -- RECUPERATION DU NOMBRE DE PAS DE TEMPS DANS LE CHAMP
C     --------------------------------------------

           IF (TYPCHA(1:2).EQ.'NO') THEN
             TYPENT  = EDNOEU
             TYPGOM  = TYPNOE
             CALL MDCHIN(NOFIMD,NOCHMD,TYPENT,TYPGOM,PREFIX,NPAS,IRET)
             CALL JEVEUO(PREFIX//'.INST','L',IPAS)
             CALL JEVEUO(PREFIX//'.NUME','L',INUM)
C
C CREATION D UN PROF_CHNO COMMUN A TOUS LES CHAM_NO
C
             CALL GCNCON('_',NPRFCN)
             NOMPRN=NPRFCN//'.PROF_CHNO '
C
           ELSEIF (TYPCHA(1:2).EQ.'EL') THEN
             CALL MDEXPM ( NOFIMD, NOMAMD, EXISTM, NDIM, IRET )
             CALL LRMTYP ( NDIM, NBTYP, NOMTYP,
     &                     NNOTYP, NITTYP, TYPGEO, RENUMD )
             TYPENT = EDMAIL
             NOMPRN = ' '
             DO 71 , LETYPE = 1 , NBTYP
               IAUX    = RENUMD(LETYPE)
               TYPGOM  = TYPGEO(IAUX)
               CALL MDCHIN(NOFIMD,NOCHMD,TYPENT,TYPGOM,PREFIX,
     &                     NPAS,IRET)
               IF (NPAS.NE.0) THEN
                 CALL JEVEUO(PREFIX//'.INST','L',IPAS)
                 CALL JEVEUO(PREFIX//'.NUME','L',INUM)
                 GOTO 72
               ENDIF
 71          CONTINUE
           ENDIF
 72        CONTINUE

C     -- BOUCLE SUR LES PAS DE TEMPS
C     --------------------------------------------

           DO 230 ITPS = 1,NPAS
             CHANOM = '&&CHTEMP'
             K32B = '                                '
             NUMPT = ZI(INUM+2*ITPS-2)
             NUMORD = ZI(INUM+2*ITPS-1)
             CALL LRCHME(CHANOM,NOCHMD,K32B,NOMA,TYPCHA,NOMGD,NUMPT,
     &                   NUMORD,NBCMPV,NCMPVA,NCMPVM,MFICH,NOMPRN,IRET)

             IF (NUMORD.EQ.EDNONO) THEN
               NUMORD = NUMPT
             END IF

             CALL RSEXCH(RESU,LINOCH(I),NUMORD,NOMCH,IRET)
             IF (IRET.EQ.100) THEN
             ELSE IF (IRET.EQ.110) THEN
               CALL RSAGSD(RESU,0)
               CALL RSEXCH(RESU,LINOCH(I),NUMORD,NOMCH,IRET)
             ELSE
               CALL UTDEBM('F',NOMCMD,'APPEL ERRONE')
               CALL UTIMPK('L','  RESULTAT : ',1,RESU)
               CALL UTIMPI('L','  ARCHIVAGE NUMERO : ',1,ITPS)
               CALL UTIMPI('L','  CODE RETOUR DE RSEXCH : ',1,IRET)
               CALL UTIMPK('L','  PROBLEME CHAMP : ',1,CHANOM)
               CALL UTFINM()
             END IF
             CALL COPISD('CHAMP_GD','G',CHANOM,NOMCH)
             CALL RSNOCH(RESU,LINOCH(I),NUMORD,' ')
             CALL RSADPA(RESU,'E',1,'INST',NUMORD,0,JINST,K8B)
             ZR(JINST) = ZR(IPAS-1+ITPS)
             IF (TYPCHA(1:2).EQ.'NO') THEN
                 CALL DETRSD('CHAM_NO',CHANOM)
             ELSE
                 CALL DETRSD('CHAM_ELEM',CHANOM)
             ENDIF
  230      CONTINUE
  220   CONTINUE


      ELSE
        CALL UTMESS('F',NOMPRO,'STOP 1')
      END IF

C     -- QUELQUES VERIFS APRES LA LECTURE :
C     --------------------------------------------
      CALL RSORAC(RESU,'LONUTI',IBID,RBID,K8B,CBID,EPSI,CRIT,NBORDR,1,
     &            NBTROU)
      IF (NBORDR.LE.0) THEN
        CALL UTMESS('F',NOMCMD,'AUCUN CHAMP LU.')
      END IF
      CALL WKVECT('&&'//NOMPRO//'.NUME_ORDR','V V I',NBORDR,LORDR)
      CALL RSORAC(RESU,'TOUT_ORDRE',IBID,RBID,K8B,CBID,EPSI,CRIT,
     &            ZI(LORDR),NBORDR,NBTROU)
      ACCE = 'INST'
      CALL RSEXPA(RESU,0,'FREQ',IRET)
      IF (IRET.GT.0) ACCE = 'FREQ'


C     -- MESSAGE D'INFORMATION SUR CE QU'ON A LU :
C     --------------------------------------------
      IF (NIV.GE.1) THEN
        WRITE (IFM,*) ' LECTURE DES CHAMPS:'
        DO 240 ICH = 1,NBNOCH
          WRITE (IFM,*) '    CHAMP : ',LINOCH(ICH)
  240   CONTINUE

        IF (NIV.GE.2) THEN
          DO 250 IORD = 1,NBORDR
            CALL RSADPA(RESU,'L',1,ACCE,ZI(LORDR+IORD-1),0,JINST,K8B)
            WRITE (IFM,*) '    NUMERO D''ORDRE : ',ZI(LORDR+IORD-1),
     &        '    '//ACCES//' : ',ZR(JINST)
  250     CONTINUE
        END IF
      END IF


      IF (NTO.EQ.0) THEN
        IF (NBORDR.NE.NBORLU) THEN
          CALL UTMESS('F',NOMCMD,'ON N''A PAS LU TOUS LES CHAMPS.')
        END IF
      END IF


      CALL TITRE
      GO TO 280

  260 CONTINUE


C     -- MESSAGE D'ERREUR DE LECTURE :
C     --------------------------------------------
      IF (IO.LT.0) THEN
        CALL UTDEBM('F',NOMCMD,
     &             'FIN DE FICHIER DANS LA LECTURE DES FICHIERS ENSIGHT'
     &              )
      ELSE IF (IO.GT.0) THEN
        CALL UTDEBM('F',NOMCMD,
     &              'ERREUR DANS LA LECTURE DU FICHIER ENSIGHT')
      END IF
      CALL UTIMPK('L',' PROBLEME POUR LE FICHIER: ',1,FIC80B)
      CALL UTFINM
      GO TO 280

  270 CONTINUE
      CALL UTMESS('F',NOMCMD,'ERREUR DANS LA LECTURE DU FICHIER IDEAS')
  280 CONTINUE

      CALL JEDETC('V','&&',1)
      CALL JEDEMA()
      END

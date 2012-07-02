      SUBROUTINE RDTRES(RESU1,RESU2,NOMA1,NOMA2,CORRN,CORRM,IOCC)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8 NOMA1,NOMA2,RESU1,RESU2
      CHARACTER*24 CORRN,CORRM
      INTEGER IOCC
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE PELLET J.PELLET
C-------------------------------------------------------------------
C BUT: REDUIRE UNE SD_RESULTAT SUR UN MAILLAGE REDUIT
C
C  RESU1  : IN  : LA SD_RESULTAT A REDUIRE
C  RESU2  : OUT : LA SD_RESULTAT REDUITE
C  NOMA1  : IN  : MAILLAGE AVANT REDUCTION
C  NOMA2  : IN  : MAILLAGE REDUIT
C  IOCC   : IN  : NUMERO DE L'OCURENCE DU MOT-CLE FACTEUR RESU
C  CORRN  : IN  : NOM DE L'OBJET CONTENANT LA CORRESPONDANCE
C                 INO_RE -> INO
C  CORRM  : IN  : NOM DE L'OBJET CONTENANT LA CORRESPONDANCE
C                 IMA_RE -> IMA
C-------------------------------------------------------------------
C
      INTEGER I,NBORDR,IBID,NBPARA,JPA,NBAC,NBPA,IAD1,IAD2,J
      INTEGER IRET,NBSYM,ISYM,IORDR,JORDR,N1,J1,IMA2,IMA1
      INTEGER NBGREL,IGR,JCORRM,IEL,NBMA1,NBMA2,JCOINV,CRET
      INTEGER ITE,JMAIL2
      REAL*8 PREC
      CHARACTER*1 KBID
      CHARACTER*16 TYPRES,NOMSYM(200),NOPARA
      CHARACTER*8 MODEL1,CRIT,TYPE,MODEL2,KCHML
      CHARACTER*19 CHP,CHPRE,LIGREL
      LOGICAL ACCENO,REDPOS
      INTEGER      IARG
C     -----------------------------------------------------------------

      CALL JEMARQ()

      CALL ASSERT(NOMA1.NE.NOMA2)
      CALL ASSERT(RESU1.NE.RESU2)
      CALL ASSERT(CORRN.NE.' ')
      CALL ASSERT(CORRM.NE.' ')



C     1- FABRICATION DU LIGREL REDUIT (LIGREL) SI NECESSAIRE :
C     --------------------------------------------------------
      CALL DISMOI('F','EXI_CHAM_ELEM',RESU1,'RESULTAT',IBID,KCHML,IRET)
      IF (KCHML.EQ.'OUI') THEN
        CALL DISMOI('F','MODELE_1',RESU1,'RESULTAT',IBID,MODEL1,IRET)
        CALL ASSERT(MODEL1(1:1).NE.'#')
        CALL ASSERT(MODEL1.NE.' ')
      ELSE
        MODEL1=' '
      ENDIF
      IF (MODEL1.NE.' ') THEN
C       1.1- ON RESTREINT LE LIGREL DU MODELE SUR LES MAILLES RETENUES :
        CALL EXLIMA('RESTREINT',1,'V',MODEL1,LIGREL)

C       1.2- IL FAUT ENSUITE TRANSFERER LE LIGREL DE NOMA1 SUR NOMA2 :
C       1.2.1  OBJET .LGRF A MODIFIER :
        CALL JEVEUO(LIGREL//'.LGRF','E',J1)
        CALL ASSERT(ZK8(J1-1+1).EQ.NOMA1)
        ZK8(J1-1+1)=NOMA2
C       1.2.2  OBJET .NBNO A MODIFIER :
        CALL JEVEUO(LIGREL//'.NBNO','E',J1)
        ZI(J1-1+1)=0

C       1.2.3 OBJET .LIEL A MODIFIER :
C       -- ON A BESOIN DE LA CORRESPONDANCE INVERSE :
        CALL JEVEUO(CORRM,'L',JCORRM)
        CALL DISMOI('F','NB_MA_MAILLA',NOMA1,'MAILLAGE',NBMA1,KBID,IRET)
        CALL DISMOI('F','NB_MA_MAILLA',NOMA2,'MAILLAGE',NBMA2,KBID,IRET)
        CALL WKVECT('&&RDTRES.CORRM_INV','V V I',NBMA1,JCOINV)
        DO 10,IMA2=1,NBMA2
          IMA1=ZI(JCORRM-1+IMA2)
          CALL ASSERT(IMA1.GT.0)
          ZI(JCOINV-1+IMA1)=IMA2
   10   CONTINUE

        CALL JELIRA(LIGREL//'.LIEL','NUTIOC',NBGREL,KBID)
        DO 30,IGR=1,NBGREL
          CALL JELIRA(JEXNUM(LIGREL//'.LIEL',IGR),'LONMAX',N1,KBID)
          CALL JEVEUO(JEXNUM(LIGREL//'.LIEL',IGR),'E',J1)
          DO 20,IEL=1,N1-1
            IMA1=ZI(J1-1+IEL)
            IMA2=ZI(JCOINV-1+IMA1)
            ZI(J1-1+IEL)=IMA2
   20     CONTINUE
   30   CONTINUE

C       1.2.4  OBJETS A DETRUIRE :
        CALL JEDETR(LIGREL//'.NEMA')
        CALL JEDETR(LIGREL//'.SSSA')
        CALL JEDETR(LIGREL//'.PRNS')
        CALL JEDETR(LIGREL//'.LGNS')
C       1.2.5  OBJETS A RECONSTRUIRE :
        CALL JEDETR(LIGREL//'.PRNM')
        CALL INITEL(LIGREL)
        CALL JEDETR(LIGREL//'.REPE')
        CALL CORMGI('V',LIGREL)

C       1.2.5  CONSTRUCTION D'UN "FAUX" MODELE NECESSAIRE
C              A IRCHME / ELGA :
        MODEL2=RESU2
        CALL WKVECT(MODEL2//'.MAILLE','V V I',NBMA2,JMAIL2)
        DO 31,IGR=1,NBGREL
          CALL JELIRA(JEXNUM(LIGREL//'.LIEL',IGR),'LONMAX',N1,KBID)
          CALL JEVEUO(JEXNUM(LIGREL//'.LIEL',IGR),'E',J1)
          ITE=ZI(J1-1+N1)
          DO 21,IEL=1,N1-1
            IMA2=ZI(J1-1+IEL)
            CALL ASSERT(IMA2.GT.0)
            CALL ASSERT(IMA2.LE.NBMA2)
            ZI(JMAIL2-1+IMA2)=ITE
   21     CONTINUE
   31   CONTINUE


      ELSE
        LIGREL=' '
        MODEL2=' '
      ENDIF



C     2- ALLOCATION DE RESU2 :
C     ------------------------------------
      CALL GETVR8('RESU','PRECISION',1,IARG,1,PREC,N1)
      CALL GETVTX('RESU','CRITERE',1,IARG,1,CRIT,N1)
      CALL RSUTNU(RESU1,'RESU',IOCC,'&&RDTRES.NUME_ORDRE',NBORDR,
     &            PREC,CRIT,IRET)
      IF (IRET.NE.0) THEN
        CALL U2MESK('F','CALCULEL4_61',1,RESU1)
      ENDIF
      IF (NBORDR.EQ.0) THEN
        CALL U2MESK('F','CALCULEL4_62',1,RESU1)
      ENDIF
      CALL JEVEUO('&&RDTRES.NUME_ORDRE','L',JORDR)
      CALL GETTCO(RESU1,TYPRES)
      CALL RSCRSD('V',RESU2,TYPRES,NBORDR)



C     3- ON CALCULE LES CHAMPS DE RESU2 :
C     ------------------------------------
      CALL RSUTC4(RESU1,'RESU',IOCC,200,NOMSYM,NBSYM,ACCENO)
      CALL ASSERT(NBSYM.GT.0)
      CRET=0
      DO 50,ISYM=1,NBSYM
        REDPOS=.TRUE.
        DO 40,I=1,NBORDR
          IORDR=ZI(JORDR+I-1)
          CALL RSEXCH(RESU1,NOMSYM(ISYM),IORDR,CHP,IRET)
          IF (IRET.GT.0)GOTO 40
          CALL RSEXCH(RESU2,NOMSYM(ISYM),IORDR,CHPRE,IRET)

C         -- REDUCTION DU CHAMP :
          CALL RDTCHP(CORRN,CORRM,CHP,CHPRE,'V',NOMA1,NOMA2,
     &                LIGREL,CRET)
          IF ( CRET.EQ.0 ) THEN
            CALL RSNOCH(RESU2,NOMSYM(ISYM),IORDR)
          ELSE
            REDPOS=.FALSE.
          ENDIF
   40   CONTINUE
        IF ( .NOT.REDPOS )
     &    CALL U2MESK('A','CALCULEL4_7',1,NOMSYM(ISYM))
   50 CONTINUE


C     4- ON RECOPIE LES VARIABLES D'ACCES :
C     ------------------------------------
      CALL RSNOPA(RESU1,2,'&&RDTRES.NOMS_PARA',NBAC,NBPA)
      NBPARA=NBAC+NBPA
      CALL JEVEUO('&&RDTRES.NOMS_PARA','L',JPA)
      DO 70,I=1,NBORDR
        IORDR=ZI(JORDR+I-1)
        DO 60 J=1,NBPARA
          NOPARA=ZK16(JPA-1+J)

C         -- CERTAINS PARAMETRES NE DOIVENT PAS ETRE RECOPIES:
          IF (NOPARA.EQ.'CARAELEM') GOTO 60
          IF (NOPARA.EQ.'CHAMPMAT') GOTO 60
          IF (NOPARA.EQ.'EXCIT') GOTO 60

          CALL RSADPA(RESU1,'L',1,NOPARA,IORDR,1,IAD1,TYPE)
          CALL RSADPA(RESU2,'E',1,NOPARA,IORDR,1,IAD2,TYPE)
          IF (NOPARA.EQ.'MODELE') CALL ASSERT(TYPE.EQ.'K8')
          IF (TYPE.EQ.'I') THEN
            ZI(IAD2)=ZI(IAD1)
          ELSEIF (TYPE.EQ.'R') THEN
            ZR(IAD2)=ZR(IAD1)
          ELSEIF (TYPE.EQ.'C') THEN
            ZC(IAD2)=ZC(IAD1)
          ELSEIF (TYPE.EQ.'K80') THEN
            ZK80(IAD2)=ZK80(IAD1)
          ELSEIF (TYPE.EQ.'K32') THEN
            ZK32(IAD2)=ZK32(IAD1)
          ELSEIF (TYPE.EQ.'K24') THEN
            ZK24(IAD2)=ZK24(IAD1)
          ELSEIF (TYPE.EQ.'K16') THEN
            ZK16(IAD2)=ZK16(IAD1)
          ELSEIF (TYPE.EQ.'K8') THEN
            IF (NOPARA.NE.'MODELE') THEN
              ZK8(IAD2)=ZK8(IAD1)
            ELSE
              ZK8(IAD2)=MODEL2
            ENDIF
          ELSE
            CALL ASSERT(.FALSE.)
          ENDIF
   60   CONTINUE
   70 CONTINUE
      CALL JEDETR('&&RDTRES.NOMS_PARA')
      CALL JEDETR('&&RDTRES.NUME_ORDRE')
      CALL JEDETR('&&RDTRES.CORRM_INV')


      CALL JEDEMA()
      END

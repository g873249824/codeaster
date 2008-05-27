      SUBROUTINE PEWEIB(RESU,MODELE,MATE,CARA,CHMAT,NCHAR,LCHAR,NH,
     &                  NBOCC,IRESU,NOMCMD)
      IMPLICIT NONE
      INTEGER IRESU,NCHAR,NH,NBOCC
      CHARACTER*(*) RESU,MODELE,MATE,CARA,NOMCMD,LCHAR(*)
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 26/05/2008   AUTEUR DESROCHES X.DESROCHES 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     OPERATEUR   POST_ELEM
C     ( TRAITEMENT DU MOT CLE-FACTEUR "WEIBULL" )
C     OPERATEUR   RECA_WEIBULL
C     ( RECALAGE DE LA METHODE DE WEIBULL )
C     ------------------------------------------------------------------

C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      REAL*8 VALR(3)
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
      CHARACTER*32 JEXNOM,JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER NBPARR,NBPARD,NBMTCM,ANOMMT,INUM,NBOUT
      INTEGER VALI
      INTEGER IBID,IBIK,MXVALE,IFM,NIV
      INTEGER ND,NG,NI,NM,NP,NQ,NR,NT,I,N1,N2,N3
      INTEGER IRET,NBORDR,JORD,JINS,NC,NBGRMA,JGR,IG,NBMA,JAD
      INTEGER NBMAIL,JMA,IM,NUME,IMC,IER
      INTEGER NUMORD,IAINST,IORD,NBMTRC,LVALE,NBIN,IOCC
      PARAMETER (MXVALE=3,NBPARR=7,NBPARD=5)
      REAL*8 R8B,RTVAL(MXVALE),PREC,INST,VALER(4),VREF,COESYM,MREF,SREF,
     &       PROBAW,SIGMAW
      CHARACTER*1 BASE
      CHARACTER*2 CODRET
      CHARACTER*8 K8B,NOMA,RESUL,CRIT,CHMAT,NOMLIG,NOMMAI,
     &            TYPARR(NBPARR),TYPARD(NBPARD),LPAIN(9),LPAOUT(2),
     &            VALEK(2)
      CHARACTER*16 TYPRES,OPTION,OPTIO2,OPTCAL(2),TOPTCA(2),NOMRC,
     &             NOPARR(NBPARR),NOPARD(NBPARD),MOTCL1,MOTCL2,MOTCL3
      CHARACTER*19 CHELEM,KNUM,KINS,TABTYP(3),CHVARC
      CHARACTER*24 CHGEOM,CHCARA(15),CHHARM
      CHARACTER*24 VALK(2)
      CHARACTER*24 MLGGMA,MLGNMA,LIGREL,LCHIN(9),COMPOR
      CHARACTER*24 LCHOUT(2),CONTG,DEFOG,VARIG,DEPLA,SSOUP
      CHARACTER*24 KVALRC,KVALRK
      LOGICAL OPTI
      COMPLEX*16 C16B

      DATA NOPARR/'NUME_ORDRE','INST','LIEU','ENTITE','SIGMA_WEIBULL',
     &     'PROBA_WEIBULL','SIGMA_WEIBULL**M'/
      DATA TYPARR/'I','R','K8','K8','R','R','R'/
      DATA NOPARD/'LIEU','ENTITE','SIGMA_WEIBULL','PROBA_WEIBULL',
     &     'SIGMA_WEIBULL**M'/
      DATA TYPARD/'K8','K8','R','R','R'/
      DATA TABTYP/'NOEU#DEPL_R','NOEU#TEMP_R','ELEM#ENER_R'/
      DATA CHVARC/'&&PEWEIB.CHVARC'/
C     ------------------------------------------------------------------
      CALL JEMARQ()

C --- RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFNIV(IFM,NIV)

      IF (NOMCMD(1:12).EQ.'RECA_WEIBULL') THEN
        OPTI = .TRUE.
        MOTCL1 = ' '
        MOTCL2 = 'RESU'
        MOTCL3 = 'RESU'
        BASE='V'
      ELSE IF (NOMCMD(1:9).EQ.'POST_ELEM') THEN
        OPTI = .FALSE.
        MOTCL1 = 'WEIBULL'
        MOTCL2 = ' '
        MOTCL3 = 'WEIBULL'
        BASE='G'
      END IF

      INST = 0.D0

      ND = 0
      IF (.NOT.OPTI) CALL GETVID(' ','CHAM_GD',1,1,1,CONTG,ND)
      IF(ND.NE.0)THEN
         CALL CHPVE2('F',CONTG,3,TABTYP,IER)
      ENDIF
      NI = 0
      IF (.NOT.OPTI) CALL GETVR8(' ','INST',1,1,1,INST,NI)

      IF (.NOT.OPTI) THEN
        CALL GETVID(MOTCL2,'RESULTAT',1,1,1,RESUL,NR)
      ELSE
        CALL GETVID(MOTCL2,'EVOL_NOLI',IRESU,1,1,RESUL,NR)
      END IF
      CALL GETVTX(MOTCL1,'OPTION',1,1,1,OPTCAL(1),NP)
      CALL GETVTX(MOTCL1,'CORR_PLAST',1,1,1,OPTCAL(2),NQ)
      IF (NBOCC.GT.1) THEN
        DO 10 I = 2,NBOCC
          CALL GETVTX(MOTCL1,'OPTION',I,1,1,TOPTCA(1),N1)
          CALL GETVTX(MOTCL1,'CORR_PLAST',I,1,1,TOPTCA(2),N2)
          IF ((TOPTCA(1).NE.OPTCAL(1)) .OR.
     &        (TOPTCA(2).NE.OPTCAL(2))) CALL U2MESS('F','UTILITAI3_83')
   10   CONTINUE
      END IF

      OPTION = 'WEIBULL'
      CALL MECHAM(OPTION,MODELE,NCHAR,LCHAR,CARA,NH,CHGEOM,CHCARA,
     &            CHHARM,IRET)
      IF (IRET.NE.0) GO TO 100
      NOMA = CHGEOM(1:8)
      MLGNMA = NOMA//'.NOMMAI'
      MLGGMA = NOMA//'.GROUPEMA'

      NOMLIG = '&&PEWEIB'
      CALL EXLIMA(MOTCL3,'V',MODELE,NOMLIG,LIGREL)

C     CREATION CARTE CONSTANTE ET NULLE SUR TOUT LE MAILLAGE
      CALL MECACT('V','&&PEWEIB.SIGIE','MAILLA',NOMA,'DOMMAG',1,'DOMA',
     &            IBID,0.D0,C16B,K8B)

      KNUM = '&&PEWEIB.NUME_ORDRE'
      KINS = '&&PEWEIB.INSTANT'
      IF (ND.NE.0) THEN
        NBORDR = 1
        CALL WKVECT(KNUM,'V V I',NBORDR,JORD)
        ZI(JORD) = 1
        CALL WKVECT(KINS,'V V R',NBORDR,JINS)
        ZR(JINS) = INST
        CALL TBCRSD(RESU,BASE)
        CALL TBAJPA(RESU,NBPARD,NOPARD,TYPARD)
      ELSE
        CALL GETTCO(RESUL,TYPRES)
        IF (TYPRES(1:9).NE.'EVOL_NOLI') THEN
          CALL U2MESS('F','UTILITAI3_84')
        END IF

        NP = 0
        IF (.NOT.OPTI) CALL GETVR8(' ','PRECISION',1,1,1,PREC,NP)
        NC = 0
        IF (.NOT.OPTI) CALL GETVTX(' ','CRITERE',1,1,1,CRIT,NC)

        IF (.NOT.OPTI) THEN
          CALL RSUTNU(RESUL,MOTCL2,1,KNUM,NBORDR,PREC,CRIT,IRET)
        ELSE
          CALL RSUTNU(RESUL,MOTCL2,IRESU,KNUM,NBORDR,PREC,CRIT,IRET)
        END IF

        IF (IRET.NE.0) GO TO 90
        CALL JEVEUO(KNUM,'L',JORD)
C        --- ON RECUPERE LES INSTANTS ---
        CALL WKVECT(KINS,'V V R',NBORDR,JINS)
        CALL JEEXIN(RESUL//'           .INST',IRET)
        IF (IRET.NE.0) THEN
          DO 20 IORD = 1,NBORDR
            NUMORD = ZI(JORD+IORD-1)
            CALL RSADPA(RESUL,'L',1,'INST',NUMORD,0,IAINST,K8B)
            ZR(JINS+IORD-1) = ZR(IAINST)
   20     CONTINUE
        END IF
        CALL TBCRSD(RESU,BASE)
        CALL TBAJPA(RESU,NBPARR,NOPARR,TYPARR)
      END IF

C     --- VERIF D'HOMOGENEITE WEIBULL ---

      IF (.NOT.OPTI) THEN
        CALL GETVID(MOTCL2,'CHAM_MATER',IRESU,1,1,CHMAT,N3)
        IF(N3.EQ.0) CHMAT = MATE(1:8)
      END IF
      CALL JELIRA(CHMAT//'.CHAMP_MAT .VALE','LONMAX',NBMTCM,K8B)
      CALL WKVECT('&&PEWEIB.L_NOM_MAT','V V K8',NBMTCM,ANOMMT)
      NOMRC = 'WEIBULL         '
      CALL CHMRCK(CHMAT,NOMRC,ZK8(ANOMMT),NBMTRC)
      IF (NBMTRC.GT.1) THEN
        VALI = NBMTRC
        VALK (1) = K8B
        VALK (2) = K8B
        CALL U2MESG('A', 'UTILITAI6_60',2,VALK,1,VALI,0,0.D0)
      END IF

C     --- RECUPERATION DES PARAMETRES DE LA RC WEIBULL ---
      KVALRC(1:8) = ZK8(ANOMMT)
      KVALRC(9:24) = '.WEIBULL   .VALR'
      KVALRK(1:8) = ZK8(ANOMMT)
      KVALRK(9:24) = '.WEIBULL   .VALK'
      CALL JEVEUO(KVALRC,'L',IBID)
      CALL JEVEUO(KVALRK,'L',IBIK)
      CALL JELIRA(KVALRK,'LONMAX',IMC,K8B)
      SREF = 0.D0
      DO 30 I = 1,IMC
        IF (ZK8(IBIK+I-1).EQ.'SIGM_CNV') SREF = ZR(IBID+I-1)
        IF (ZK8(IBIK+I-1).EQ.'M       ') MREF = ZR(IBID+I-1)
        IF (ZK8(IBIK+I-1).EQ.'VOLU_REF') VREF = ZR(IBID+I-1)
   30 CONTINUE
C CAS WEIBULL_FO
      IF (SREF.EQ.0.D0) THEN
        DO 40 I = 1,IMC
          IF (ZK8(IBIK+I-1).EQ.'SIGM_REF') SREF = ZR(IBID+I-1)
   40   CONTINUE
        VALR (1) = MREF
        VALR (2) = VREF
        VALR (3) = SREF
        CALL U2MESG('I', 'UTILITAI6_61',0,' ',0,0,3,VALR)
C CAS WEIBULL
      ELSE
        VALR (1) = MREF
        VALR (2) = VREF
        VALR (3) = SREF
        CALL U2MESG('I', 'UTILITAI6_62',0,' ',0,0,3,VALR)
      END IF

      CALL WKVECT('&&PEWEIB.TRAV1','V V R',MXVALE,LVALE)
      DO 80 IORD = 1,NBORDR
        CALL JEMARQ()
        CALL JERECU('V')
        NUMORD = ZI(JORD+IORD-1)
        INST = ZR(JINS+IORD-1)
        VALER(1) = INST

        CALL RSEXCH(RESUL,'COMPORTEMENT',NUMORD,COMPOR,IRET)
        IF (NR.NE.0) THEN
          CALL RSEXCH(RESUL,'SIEF_ELGA',NUMORD,CONTG,IRET)
          IF (IRET.GT.0) THEN
            CALL U2MESS('F','UTILITAI3_85')
          END IF
          CALL RSEXCH(RESUL,'VARI_ELGA',NUMORD,VARIG,IRET)
          IF (IRET.GT.0) THEN
            CALL U2MESS('F','UTILITAI3_86')
          END IF
          CALL RSEXCH(RESUL,'DEPL',NUMORD,DEPLA,IRET)
          IF (IRET.GT.0) THEN
            CALL U2MESS('F','UTILITAI3_87')
          END IF
        END IF

C        --- DANS LE CAS D'UNE OPTION AVEC CORRECTION DE DEFORMATION
C            RECUPERATION DES DEFORMATIONS DE GREEN LAGRANGE ---

        IF (OPTCAL(2).EQ.'OUI') THEN
          CALL RSEXCH(RESUL,'EPSG_ELGA_DEPL',NUMORD,DEFOG,IRET)
          IF (IRET.GT.0) THEN
            CALL U2MESS('F','UTILITAI3_88')
          END IF
        ELSE
          DEFOG = '&&PEWEIB.EPSG'
        END IF

C        --- RECUPERATION DU CHAMP DE TEMPERATURE
C            UTILE POUR LE CAS OU SIGU(T)
        CALL VRCINS(MODELE,MATE,CARA,INST,CHVARC,CODRET)

C        --- AFFECTATION D'UNE CARTE CONSTANTE SUR LE MAILLAGE :
C            OPTION DE CALCUL WEIBULL ---

        SSOUP = OPTCAL(1)//OPTCAL(2)
        CALL MECACT('V','&&PEWEIB.CH.SOUSOP','MAILLA',NOMA,'NEUT_K24',1,
     &              'Z1',IBID,R8B,C16B,SSOUP)

        OPTIO2 = 'WEIBULL'
        CHELEM = '&&PEWEIB.WEIBULL'
        NBIN = 9
        LCHIN(1) = CHGEOM
        LPAIN(1) = 'PGEOMER'
        LCHIN(2) = CONTG
        LPAIN(2) = 'PCONTRG'
        LCHIN(3) = VARIG
        LPAIN(3) = 'PVARIPG'
        LCHIN(4) = DEFOG
        LPAIN(4) = 'PDEFORR'
        LCHIN(5) = MATE
        LPAIN(5) = 'PMATERC'
        LCHIN(6) = '&&PEWEIB.CH.SOUSOP'
        LPAIN(6) = 'PSOUSOP'
C  EN ENTREE : CHELEM DES SIGI MAX ATTEINTE AU COURS DU TEMPS
        LCHIN(7) = '&&PEWEIB.SIGIE'
        LPAIN(7) = 'PDOMMAG'
C  EN ENTREE : CHELEM DES VARIABLES DE COMMANDES
        LCHIN(8) = CHVARC
        LPAIN(8) = 'PVARCPR'
        LCHIN(9) = COMPOR
        LPAIN(9) = 'PCOMPOR'
        NBOUT = 2
        LCHOUT(1) = CHELEM
        LPAOUT(1) = 'PWEIBUL'
        LCHOUT(2) = '&&PEWEIB.SIGIS'
        LPAOUT(2) = 'PSIGISG'
        CALL CALCUL('S',OPTIO2,LIGREL,NBIN,LCHIN,LPAIN,NBOUT,LCHOUT,
     &              LPAOUT,'V')

C        RECOPIE DE SIGIS DANS SIGIE
        CALL COPISD('CHAMP_GD','V','&&PEWEIB.SIGIS','&&PEWEIB.SIGIE')

        DO 70 IOCC = 1,NBOCC
          IF (.NOT.OPTI) THEN
            INUM = IOCC
          ELSE
            INUM = IRESU
          END IF
          CALL GETVTX(MOTCL3,'TOUT',INUM,1,0,K8B,NT)
          CALL GETVEM(NOMA,'MAILLE',MOTCL3,'MAILLE',INUM,1,0,K8B,NM)
          CALL GETVEM(NOMA,'GROUP_MA',MOTCL3,'GROUP_MA',INUM,1,0,K8B,NG)
          CALL GETVR8(MOTCL3,'COEF_MULT',INUM,1,1,COESYM,N1)

          IF (NT.NE.0) THEN
            CALL MESOMM(CHELEM,MXVALE,IBID,ZR(LVALE),C16B,0,IBID)
            PROBAW = COESYM*ZR(LVALE)
            SIGMAW = PROBAW* (SREF**MREF)
            PROBAW = 1.0D0 - EXP(-PROBAW)
            RTVAL(3) = SIGMAW
            RTVAL(2) = PROBAW
            RTVAL(1) = SIGMAW** (1.0D0/MREF)
            VALEK(1) = NOMA
            VALEK(2) = 'TOUT'
            IF (NR.NE.0) THEN
              VALER(2) = RTVAL(1)
              VALER(3) = RTVAL(2)
              VALER(4) = RTVAL(3)
              CALL TBAJLI(RESU,NBPARR,NOPARR,NUMORD,VALER,C16B,VALEK,0)
            ELSE
              CALL TBAJLI(RESU,NBPARD,NOPARD,NUMORD,RTVAL,C16B,VALEK,0)
            END IF
          END IF

          IF (NG.NE.0) THEN
            NBGRMA = -NG
            CALL WKVECT('&&PEWEIB_GROUPM','V V K8',NBGRMA,JGR)
            CALL GETVEM(NOMA,'GROUP_MA',MOTCL3,'GROUP_MA',INUM,1,NBGRMA,
     &                  ZK8(JGR),NG)
            VALEK(2) = 'GROUP_MA'
            DO 50 IG = 1,NBGRMA
              NOMMAI = ZK8(JGR+IG-1)
              CALL JEEXIN(JEXNOM(MLGGMA,NOMMAI),IRET)
              IF (IRET.EQ.0) THEN
                CALL U2MESK('A','UTILITAI3_46',1,NOMMAI)
                GO TO 50
              END IF
              CALL JELIRA(JEXNOM(MLGGMA,NOMMAI),'LONMAX',NBMA,K8B)
              IF (NBMA.EQ.0) THEN
                CALL U2MESK('A','UTILITAI3_47',1,NOMMAI)
                GO TO 50
              END IF
              CALL JEVEUO(JEXNOM(MLGGMA,NOMMAI),'L',JAD)
              CALL MESOMM(CHELEM,MXVALE,IBID,ZR(LVALE),C16B,NBMA,
     &                    ZI(JAD))
              SIGMAW = COESYM*ZR(LVALE)* (SREF**MREF)
              PROBAW = SIGMAW/ (SREF**MREF)
              PROBAW = 1.0D0 - EXP(-PROBAW)
              RTVAL(3) = SIGMAW
              RTVAL(2) = PROBAW
              RTVAL(1) = SIGMAW** (1.0D0/MREF)
              VALEK(1) = NOMMAI
              IF (NR.NE.0) THEN
                VALER(2) = RTVAL(1)
                VALER(3) = RTVAL(2)
                VALER(4) = RTVAL(3)
                CALL TBAJLI(RESU,NBPARR,NOPARR,NUMORD,VALER,C16B,VALEK,
     &                      0)
              ELSE
                CALL TBAJLI(RESU,NBPARD,NOPARD,NUMORD,RTVAL,C16B,VALEK,
     &                      0)
              END IF
   50       CONTINUE
            CALL JEDETR('&&PEWEIB_GROUPM')
          END IF

          IF (NM.NE.0) THEN
            NBMAIL = -NM
            CALL WKVECT('&&PEWEIB_MAILLE','V V K8',NBMAIL,JMA)
            CALL GETVEM(NOMA,'MAILLE',MOTCL3,'MAILLE',INUM,1,NBMAIL,
     &                  ZK8(JMA),NM)
            VALEK(2) = 'MAILLE'
            DO 60 IM = 1,NBMAIL
              NOMMAI = ZK8(JMA+IM-1)
              CALL JEEXIN(JEXNOM(MLGNMA,NOMMAI),IRET)
              IF (IRET.EQ.0) THEN
                CALL U2MESK('A','UTILITAI3_49',1,NOMMAI)
                GO TO 60
              END IF
              CALL JENONU(JEXNOM(MLGNMA,NOMMAI),NUME)
              CALL MESOMM(CHELEM,MXVALE,IBID,ZR(LVALE),C16B,1,NUME)
              PROBAW = COESYM*ZR(LVALE)
              SIGMAW = PROBAW* (SREF**MREF)
              PROBAW = 1.0D0 - EXP(-PROBAW)
              RTVAL(3) = SIGMAW
              RTVAL(2) = PROBAW
              RTVAL(1) = SIGMAW** (1.0D0/MREF)
              VALEK(1) = NOMMAI
              IF (NR.NE.0) THEN
                VALER(2) = RTVAL(1)
                VALER(3) = RTVAL(2)
                VALER(4) = RTVAL(3)
                CALL TBAJLI(RESU,NBPARR,NOPARR,NUMORD,VALER,C16B,VALEK,
     &                      0)
              ELSE
                CALL TBAJLI(RESU,NBPARD,NOPARD,NUMORD,RTVAL,C16B,VALEK,
     &                      0)
              END IF
   60       CONTINUE
            CALL JEDETR('&&PEWEIB_MAILLE')
          END IF
   70   CONTINUE
        CALL JEDETR('&&PEWEIB.PAR')
        CALL JEDETR('&&PEWEIB.EPSG')
        CALL JEDETR('&&PEWEIB.CH.SOUSOP')
        CALL JEDEMA()
   80 CONTINUE
C FIN BOUCLE SUR LES NUMEROS D ORDRE
   90 CONTINUE
      CALL JEDETR('&&PEWEIB.SIGIE')
      CALL JEDETR('&&PEWEIB.SIGIS')
      CALL JEDETC('V','&&PEWEIB',1)
  100 CONTINUE

      CALL JEDEMA()
      END

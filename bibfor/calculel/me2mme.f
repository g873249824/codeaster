      SUBROUTINE ME2MME(MODELZ,NCHAR,LCHAR,MATE,CARAZ,EXITIM,TIME,
     &                  MATELZ,NH,BASEZ)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/02/2013   AUTEUR PELLET J.PELLET 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE  CRP_20
      IMPLICIT NONE

C     ARGUMENTS:
C     ----------
      INCLUDE 'jeveux.h'

      CHARACTER*8 MODELE,CARA,KBID,LCMP(5)
      CHARACTER*(*) MODELZ,CARAZ,MATELZ,LCHAR(*),MATE,BASEZ
      CHARACTER*19 MATEL
      REAL*8 TIME
      LOGICAL EXITIM,LFONC
      INTEGER NCHAR
C ----------------------------------------------------------------------

C     CALCUL DES SECONDS MEMBRES ELEMENTAIRES

C     ENTREES:

C     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
C        MODELZ : NOM DU MODELE
C        NCHAR  : NOMBRE DE CHARGES
C        LCHAR  : LISTE DES CHARGES
C        MATE   : CHAMP DE MATERIAUX
C        CARAZ  : CHAMP DE CARAC_ELEM
C        MATELZ : NOM DU MATEL (N RESUELEM) PRODUIT
C        NH     : NUMERO DE L'HARMONIQUE DE FOURIER
C        BASEZ  : NOM DE LA BASE

C        EXITIM : VRAI SI L'INSTANT EST DONNE
C        TIME   : INSTANT DE CALCUL

C     SORTIES:
C     SONT TRAITES LES CHARGEMENTS :
C        LCHAR(ICHA)//'.CHME.CIMPO'
C        LCHAR(ICHA)//'.CHME.FORNO'
C        LCHAR(ICHA)//'.CHME.F3D3D'
C        LCHAR(ICHA)//'.CHME.FCO2D'
C        LCHAR(ICHA)//'.CHME.FCO3D'
C        LCHAR(ICHA)//'.CHME.F2D3D'
C        LCHAR(ICHA)//'.CHME.F1D3D'
C        LCHAR(ICHA)//'.CHME.F2D2D'
C        LCHAR(ICHA)//'.CHME.F1D2D'
C        LCHAR(ICHA)//'.CHME.F1D1D'
C        LCHAR(ICHA)//'.CHME.PESAN'
C        LCHAR(ICHA)//'.CHME.ROTAT'
C        LCHAR(ICHA)//'.CHME.FELEC'
C        LCHAR(ICHA)//'.CHME.FL1??'
C        LCHAR(ICHA)//'.CHME.PRESS'
C        LCHAR(ICHA)//'.CHME.EPSIN'
C        LCHAR(ICHA)//'.CHME.TEMPE'
C        LCHAR(ICHA)//'.CHME.VNOR'
C        LCHAR(ICHA)//'.CHME.ONDE'
C        LCHAR(ICHA)//'.CHME.EVOL.CHAR'

C ----------------------------------------------------------------------

C     FONCTIONS EXTERNES:
C     -------------------

C     VARIABLES LOCALES:
C     ------------------
      COMPLEX*16 CBID
      LOGICAL EXICAR
      CHARACTER*1 BASE
      CHARACTER*2 CODRET
      INTEGER NBIN
C-----------------------------------------------------------------------
      INTEGER IBID,ICHA,IER,IERD,IFLA,ILIRES,IRET
      INTEGER J,JVEASS,NH
C-----------------------------------------------------------------------
      PARAMETER(NBIN=43)
      CHARACTER*8 LPAIN(NBIN),LPAOUT(1),NOMA,EXIELE
      CHARACTER*16 OPTION
      CHARACTER*19 PINTTO,CNSETO,HEAVTO,LONCHA,BASLOC,LSN,LST,STANO
      CHARACTER*19 PMILTO,FISSNO,PINTER
      CHARACTER*24 CHGEOM,LCHIN(NBIN),LCHOUT(1),KCMP(5)
      CHARACTER*24 LIGRMO,LIGRCH,CHTIME,CHLAPL,CHCARA(18)
      CHARACTER*24 CHHARM
      CHARACTER*19 CHVARC,CHVREF

      CHARACTER*19 RESUFV(3)
      CHARACTER*24 CHARGE
      INTEGER JAD,I
      LOGICAL LTEMP,LTREF


      CALL JEMARQ()
      MODELE=MODELZ
      CARA=CARAZ
      MATEL=MATELZ
      BASE=BASEZ

      DO 10,I=1,NBIN
        LCHIN(I)=' '
        LPAIN(I)=' '
   10 CONTINUE

      CHVARC='&&ME2MME.VARC'
      CHVREF='&&ME2MME.VARC.REF'


C     -- CALCUL DE .RERR:
      CALL MEMARE(BASE,MATEL,MODELE,MATE,CARA,'CHAR_MECA')

C     -- S'IL N' Y A PAS D'ELEMENTS CLASSIQUES, ON RESSORT:
      CALL DISMOI('F','EXI_ELEM',MODELE,'MODELE',IBID,EXIELE,IERD)


C     -- ON VERIFIE LA PRESENCE PARFOIS NECESSAIRE DE CARA_ELEM
C        ET CHAM_MATER :

      CALL MEGEOM(MODELE,CHGEOM)
      CALL MECARA(CARA,EXICAR,CHCARA)

C     LES CHAMPS "IN" PRIS DANS CARA_ELEM SONT NUMEROTES DE 21 A 32 :
C     ---------------------------------------------------------------
      LPAIN(21)='PCAARPO'
      LCHIN(21)=CHCARA(9)
      LPAIN(22)='PCACOQU'
      LCHIN(22)=CHCARA(7)
      LPAIN(23)='PCADISM'
      LCHIN(23)=CHCARA(3)
      LPAIN(24)='PCAGEPO'
      LCHIN(24)=CHCARA(5)
      LPAIN(25)='PCAGNBA'
      LCHIN(25)=CHCARA(11)
      LPAIN(26)='PCAGNPO'
      LCHIN(26)=CHCARA(6)
      LPAIN(27)='PCAMASS'
      LCHIN(27)=CHCARA(12)
      LPAIN(28)='PCAORIE'
      LCHIN(28)=CHCARA(1)
      LPAIN(29)='PCASECT'
      LCHIN(29)=CHCARA(8)
      LPAIN(30)='PCINFDI'
      LCHIN(30)=CHCARA(15)
      LPAIN(31)='PFIBRES'
      LCHIN(31)=CHCARA(17)
      LPAIN(32)='PNBSP_I'
      LCHIN(32)=CHCARA(16)
      ILIRES=0

C  ---VERIFICATION DE L'EXISTENCE D'UN MODELE X-FEM-------
      CALL EXIXFE(MODELE,IER)

      IF (IER.NE.0) THEN

C  ---  CAS DU MODELE X-FEM-----------

        ILIRES=ILIRES+1
        PINTTO=MODELE(1:8)//'.TOPOSE.PIN'
        CNSETO=MODELE(1:8)//'.TOPOSE.CNS'
        HEAVTO=MODELE(1:8)//'.TOPOSE.HEA'
        LONCHA=MODELE(1:8)//'.TOPOSE.LON'
        PMILTO=MODELE(1:8)//'.TOPOSE.PMI'
        BASLOC=MODELE(1:8)//'.BASLOC'
        LSN=MODELE(1:8)//'.LNNO'
        LST=MODELE(1:8)//'.LTNO'
        STANO=MODELE(1:8)//'.STNO'
        FISSNO=MODELE(1:8)//'.FISSNO'
        PINTER=MODELE(1:8)//'.TOPOFAC.OE'
      ELSE
        PINTTO='&&ME2MME.PINTTO.BID'
        CNSETO='&&ME2MME.CNSETO.BID'
        HEAVTO='&&ME2MME.HEAVTO.BID'
        LONCHA='&&ME2MME.LONCHA.BID'
        BASLOC='&&ME2MME.BASLOC.BID'
        PMILTO='&&ME2MME.PMILTO.BID'
        LSN='&&ME2MME.LNNO.BID'
        LST='&&ME2MME.LTNO.BID'
        STANO='&&ME2MME.STNO.BID'
        FISSNO='&&ME2MME.FISSNO.BID'
        PINTER='&&ME2MME.PINTER.BID'
      ENDIF

      IF (IER.NE.0) THEN
        LPAIN(33)='PPINTTO'
        LCHIN(33)=PINTTO
        LPAIN(34)='PHEAVTO'
        LCHIN(34)=HEAVTO
        LPAIN(35)='PLONCHA'
        LCHIN(35)=LONCHA
        LPAIN(36)='PCNSETO'
        LCHIN(36)=CNSETO
        LPAIN(37)='PBASLOR'
        LCHIN(37)=BASLOC
        LPAIN(38)='PLSN'
        LCHIN(38)=LSN
        LPAIN(39)='PLST'
        LCHIN(39)=LST
        LPAIN(40)='PSTANO'
        LCHIN(40)=STANO
        LPAIN(41)='PPMILTO'
        LCHIN(41)=PMILTO
        LPAIN(42)='PFISNO'
        LCHIN(42)=FISSNO
        LPAIN(43)='PPINTER'
        LCHIN(43)=PINTER
      ENDIF
C ----- REMPLISSAGE DES CHAMPS D'ENTREE


      NOMA=CHGEOM(1:8)
      CALL VRCINS(MODELE,MATE,CARA,TIME,CHVARC,CODRET)
      CALL VRCREF(MODELE,MATE(1:8),CARA,CHVREF(1:19))

      IF (NCHAR.EQ.0)GOTO 60
      CALL JEEXIN(MATEL//'.RELR',IRET)
      IF (IRET.GT.0) CALL JEDETR(MATEL//'.RELR')

      LPAOUT(1)='PVECTUR'
      LCHOUT(1)=MATEL(1:8)//'.VEXXX'
      LPAIN(1)='PGEOMER'
      LCHIN(1)=CHGEOM
      LPAIN(2)='PMATERC'
      LCHIN(2)=MATE
      LPAIN(3)='PVARCPR'
      LCHIN(3)=CHVARC

      IFLA=0

      LIGRMO=MODELE//'.MODELE'

C        -- EN PRINCIPE, EXITIM EST TOUJOURS .TRUE.
      CHTIME='&&ME2MME.CH_INST_R'
      CALL MECACT('V',CHTIME,'MODELE',LIGRMO,'INST_R  ',1,'INST   ',
     &            IBID,TIME,CBID,KBID)
      LPAIN(5)='PTEMPSR'
      LCHIN(5)=CHTIME



      DO 50 ICHA=1,NCHAR
        CALL DISMOI('F','TYPE_CHARGE',LCHAR(ICHA),'CHARGE',IBID,KBID,
     &              IERD)
        IF (KBID(5:7).EQ.'_FO') THEN
          LFONC=.TRUE.
        ELSE
          LFONC=.FALSE.
        ENDIF
        LIGRCH=LCHAR(ICHA)//'.CHME.LIGRE'
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.CIMPO',IRET)
        IF (IRET.NE.0) THEN

          IF (LFONC) THEN
            OPTION='MECA_DDLI_F'
            LPAIN(4)='PDDLIMF'
          ELSE
            OPTION='MECA_DDLI_R'
            LPAIN(4)='PDDLIMR'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.CIMPO.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRCH,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.FORNO',IRET)
        IF (IRET.NE.0) THEN
          IF (LFONC) THEN
            OPTION='CHAR_MECA_FORC_F'
            LPAIN(4)='PFORNOF'
          ELSE
            OPTION='CHAR_MECA_FORC_R'
            LPAIN(4)='PFORNOR'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.FORNO.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRCH,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF

C      -- SI LE MODELE NE CONTIENT PAS D'ELEMENTS CLASSIQUES, ON SAUTE:
C      ----------------------------------------------------------------
        IF (EXIELE(1:3).EQ.'NON')GOTO 50
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.F3D3D',IRET)
        IF (IRET.NE.0) THEN
          IF (LFONC) THEN
            OPTION='CHAR_MECA_FF3D3D'
            LPAIN(4)='PFF3D3D'
          ELSE
            OPTION='CHAR_MECA_FR3D3D'
            LPAIN(4)='PFR3D3D'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.F3D3D.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.FCO2D',IRET)
        IF (IRET.NE.0) THEN

          IF (LFONC) THEN
            OPTION='CHAR_MECA_FFCO2D'
            LPAIN(4)='PFFCO2D'
          ELSE
            OPTION='CHAR_MECA_FRCO2D'
            LPAIN(4)='PFRCO2D'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.FCO2D.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.FCO3D',IRET)
        IF (IRET.NE.0) THEN

          IF (LFONC) THEN
            OPTION='CHAR_MECA_FFCO3D'
            LPAIN(4)='PFFCO3D'
          ELSE
            OPTION='CHAR_MECA_FRCO3D'
            LPAIN(4)='PFRCO3D'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.FCO3D.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.F2D3D',IRET)
        IF (IRET.NE.0) THEN

          IF (LFONC) THEN
            OPTION='CHAR_MECA_FF2D3D'
            LPAIN(4)='PFF2D3D'
          ELSE
            OPTION='CHAR_MECA_FR2D3D'
            LPAIN(4)='PFR2D3D'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.F2D3D.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.F1D3D',IRET)
        IF (IRET.NE.0) THEN

          IF (LFONC) THEN
            OPTION='CHAR_MECA_FF1D3D'
            LPAIN(4)='PFF1D3D'
          ELSE
            OPTION='CHAR_MECA_FR1D3D'
            LPAIN(4)='PFR1D3D'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.F1D3D.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.F2D2D',IRET)
        IF (IRET.NE.0) THEN

          IF (LFONC) THEN
            OPTION='CHAR_MECA_FF2D2D'
            LPAIN(4)='PFF2D2D'
          ELSE
            OPTION='CHAR_MECA_FR2D2D'
            LPAIN(4)='PFR2D2D'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.F2D2D.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.F1D2D',IRET)
        IF (IRET.NE.0) THEN
          IF (LFONC) THEN
            OPTION='CHAR_MECA_FF1D2D'
            LPAIN(4)='PFF1D2D'
          ELSE
            OPTION='CHAR_MECA_FR1D2D'
            LPAIN(4)='PFR1D2D'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.F1D2D.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.F1D1D',IRET)
        IF (IRET.NE.0) THEN
          IF (LFONC) THEN
            OPTION='CHAR_MECA_FF1D1D'
            LPAIN(4)='PFF1D1D'
          ELSE
            OPTION='CHAR_MECA_FR1D1D'
            LPAIN(4)='PFR1D1D'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.F1D1D.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.PESAN',IRET)
        IF (IRET.NE.0) THEN
          OPTION='CHAR_MECA_PESA_R'
          LPAIN(2)='PMATERC'
          LCHIN(2)=MATE
          LPAIN(4)='PPESANR'
          LCHIN(4)=LIGRCH(1:13)//'.PESAN.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.ROTAT',IRET)
        IF (IRET.NE.0) THEN
          OPTION='CHAR_MECA_ROTA_R'
          LPAIN(2)='PMATERC'
          LCHIN(2)=MATE
          LPAIN(4)='PROTATR'
          LCHIN(4)=LIGRCH(1:13)//'.ROTAT.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.EPSIN',IRET)
        IF (IRET.NE.0) THEN
          LPAIN(2)='PMATERC'
          LCHIN(2)=MATE
          IF (LFONC) THEN
            OPTION='CHAR_MECA_EPSI_F'
            LPAIN(4)='PEPSINF'
          ELSE
            OPTION='CHAR_MECA_EPSI_R'
            LPAIN(4)='PEPSINR'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.EPSIN.DESC'
          CALL MEHARM(MODELE,NH,CHHARM)
          LPAIN(13)='PHARMON'
          LCHIN(13)=CHHARM
          LPAIN(15)='PCOMPOR'
          LCHIN(15)=MATE(1:8)//'.COMPOR'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.FELEC',IRET)
        IF (IRET.NE.0) THEN
          OPTION='CHAR_MECA_FRELEC'
          LPAIN(4)='PFRELEC'
          LCHIN(4)=LIGRCH(1:13)//'.FELEC.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
C         -- LA BOUCLE 30 SERT A TRAITER LES FORCES ELECTRIQUES LAPLACE

        DO 20 J=1,99
          LCHIN(13)(1:17)=LIGRCH(1:13)//'.FL1'
          CALL CODENT(J,'D0',LCHIN(13)(18:19))
          LCHIN(13)=LCHIN(13)(1:19)//'.DESC'
          CALL JEEXIN(LCHIN(13),IRET)
          IF (IRET.EQ.0)GOTO 30
          LPAIN(12)='PHARMON'
          LCHIN(12)=' '
          LPAIN(13)='PLISTMA'
          IF (IFLA.EQ.0) THEN
            CHLAPL='&&ME2MME.CH_FLAPLA'
            LCMP(1)='NOMAIL'
            LCMP(2)='NOGEOM'
            KCMP(1)=NOMA
            KCMP(2)=CHGEOM(1:19)
            CALL MECACT('V',CHLAPL,'MAILLA',NOMA,'FLAPLA  ',2,LCMP(1),
     &                  IBID,TIME,CBID,KCMP(1))
            IFLA=1
          ENDIF
          OPTION='CHAR_MECA_FRLAPL'
          LPAIN(4)='PFLAPLA'
          LCHIN(4)=CHLAPL
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
   20   CONTINUE
   30   CONTINUE
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.PRESS',IRET)
        IF (IRET.NE.0) THEN
          IF (LFONC) THEN
            OPTION='CHAR_MECA_PRES_F'
            LPAIN(4)='PPRESSF'
          ELSE
            OPTION='CHAR_MECA_PRES_R'
            LPAIN(4)='PPRESSR'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.PRESS.DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.VNOR ',IRET)
        IF (IRET.NE.0) THEN
          IF (LFONC) THEN
            OPTION='CHAR_MECA_VNOR_F'
            LPAIN(4)='PSOURCF'
          ELSE
            OPTION='CHAR_MECA_VNOR'
            LPAIN(4)='PSOURCR'
          ENDIF
          LCHIN(4)=LIGRCH(1:13)//'.VNOR .DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL JEEXIN(LIGRCH(1:13)//'.VEASS',IRET)
        IF (IRET.GT.0) THEN
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL JEVEUO(LIGRCH(1:13)//'.VEASS','L',JVEASS)
          CALL COPISD('CHAMP_GD',BASE,ZK8(JVEASS),LCHOUT(1))
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.ONDE ',IRET)
        IF (IRET.NE.0) THEN
          IF (LFONC) THEN
            OPTION='CHAR_MECA_ONDE_F'
            LPAIN(4)='PONDECF'
          ELSE
            OPTION='CHAR_MECA_ONDE'
            LPAIN(4)='PONDECR'
          ENDIF

          LCHIN(4)=LIGRCH(1:13)//'.ONDE .DESC'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,
     &                LPAOUT,BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF
C ====================================================================
C CHARGE DE TYPE EVOL_CHAR

        CHARGE='&&ME2MME.INTERF.NMDEPR'
        CALL WKVECT(CHARGE,'V V K24',1,JAD)
        ZK24(JAD)=LCHAR(ICHA)

        RESUFV(1)='&&ME2MME.VE001'
        RESUFV(2)='&&ME2MME.VE002'
        RESUFV(3)='&&ME2MME.VE003'

        CALL NMDEPR(MODELE,LIGRMO,CARA,CHARGE,1,TIME,RESUFV)

        DO 40 I=1,3
          CALL EXISD('CHAMP_GD',RESUFV(I),IRET)
          IF (IRET.NE.0) THEN
            ILIRES=ILIRES+1
            CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
            CALL COPISD('CHAMP_GD',BASE,RESUFV(I),LCHOUT(1))
            CALL DETRSD('CHAMP_GD',RESUFV(I))
            CALL REAJRE(MATEL,LCHOUT(1),BASE)
          ENDIF
   40   CONTINUE
        CALL JEDETR(CHARGE)

C ====================================================================
C CHARGE DE TYPE ONDE_PLANE :
        CALL EXISD('CHAMP_GD',LIGRCH(1:13)//'.ONDPL',IRET)
        IF (IRET.NE.0) THEN
          OPTION='ONDE_PLAN'
          LPAIN(4)='PONDPLA'
          LCHIN(4)=LIGRCH(1:13)//'.ONDPL'
          LPAIN(6)='PONDPLR'
          LCHIN(6)=LIGRCH(1:13)//'.ONDPR'
          ILIRES=ILIRES+1
          CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
          CALL CALCUL('S',OPTION,LIGRMO,6,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &                BASE,'OUI')
          CALL REAJRE(MATEL,LCHOUT(1),BASE)
        ENDIF

C ====================================================================
   50 CONTINUE


C ====================================================================
C       -- CHARGEMENT DE DILATATION THERMIQUE :
      CALL NMVCD2('TEMP',MATE,LTEMP,LTREF)
      IF (LTEMP) THEN
        CALL VRCINS(MODELE,MATE,CARA,TIME,CHVARC,CODRET)
        OPTION='CHAR_MECA_TEMP_R'
        LPAIN(2)='PMATERC'
        LCHIN(2)=MATE
        LPAIN(4)='PVARCRR'
        LCHIN(4)=CHVREF
        CALL MEHARM(MODELE,NH,CHHARM)
        LPAIN(13)='PHARMON'
        LCHIN(13)=CHHARM
        LPAIN(16)=' '
        LCHIN(16)=' '
        ILIRES=ILIRES+1
        CALL CODENT(ILIRES,'D0',LCHOUT(1)(12:14))
        CALL CALCUL('S',OPTION,LIGRMO,NBIN,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &              BASE,'OUI')
        CALL REAJRE(MATEL,LCHOUT(1),BASE)
        CALL DETRSD('CHAMP_GD',CHVARC)
      ENDIF




   60 CONTINUE
      CALL DETRSD('CHAMP_GD',CHVARC)
      CALL DETRSD('CHAMP_GD',CHVREF)

      CALL JEDEMA()
      END

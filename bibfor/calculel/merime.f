      SUBROUTINE MERIME(MODELZ,NCHAR,LCHAR,MATE,CARAZ,EXITIM,TIME,
     &                  COMPOR,MATELZ,NH,BASEZ)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER NCHAR,NH
      REAL*8 TIME
      CHARACTER*(*) MODELZ,CARAZ,MATELZ
      CHARACTER*8 MODELE,CARA,MATEL
      CHARACTER*(*) LCHAR(*),MATE,BASEZ,COMPOR
      CHARACTER*(1) BASE
      LOGICAL EXITIM
C ----------------------------------------------------------------------
C MODIF CALCULEL  DATE 22/10/2007   AUTEUR PELLET J.PELLET 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C                          DE MERIME...  PROSPER YOUP-LA-BOUM!

C     CALCUL DES MATRICES ELEMENTAIRES DE RIGIDITE MECA

C ----------------------------------------------------------------------
C IN  : MODELZ : NOM DU MODELE  (PAS OBLIGATOIRE)
C IN  : NCHAR  : NOMBRE DE CHARGES
C IN  : LCHAR  : LISTE DES CHARGES
C IN  : MATE   : CARTE DE MATERIAU
C IN  : CARAZ  : CHAMP DE CARAC_ELEM
C IN  : MATELZ : NOM DU MATR_ELEM RESULTAT
C IN  : EXITIM : VRAI SI L'INSTANT EST DONNE
C IN  : TIME   : INSTANT DE CALCUL
C IN  : NH     : NUMERO D'HARMONIQUE DE FOURIER
C IN  : BASEZ  : NOM DE LA BASE
C IN  : COMPOR : COMPOR POUR LES MULTIFIBRE (POU_D_EM)
C ----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
C     ------------------------------------------------------------------
      CHARACTER*8 K8B,LPAIN(25),LPAOUT(2),STATUT,NOMRES,NOMGD,KBID
      CHARACTER*16 OPTION,NOMCMD,TYPRES
      CHARACTER*19 NOMFON,CHVARC
      CHARACTER*24 LIGRMO,LIGRCH,LCHIN(25),LCHOUT(2)
      CHARACTER*24 CHGEOM,CHCARA(15),CHTEMP,CHTREF,CHHARM
      CHARACTER*24 CHCHAR,ARGU,CHTIME
      COMPLEX*16 CBID
      DATA CHVARC/'&&MERIME.CH_VARC_R'/

      CALL JEMARQ()
      MODELE = MODELZ
      CARA = CARAZ
      MATEL = MATELZ
      BASE = BASEZ

      CALL GETRES(NOMFON,TYPRES,NOMCMD)
      OPTION = 'RIGI_MECA'
      CALL MECHAM(OPTION,MODELE,NCHAR,LCHAR,CARA,NH,CHGEOM,CHCARA,
     &            CHHARM,ICODE)

      CALL MECHPE(NCHAR,LCHAR,CHCHAR)

      IF (.NOT.EXITIM) TIME = 0.D0
      CHTIME = '&&MERIME.CHAMP_INST'
      CALL MECACT('V',CHTIME,'MODELE',MODELE//'.MODELE','INST_R',1,
     &            'INST',IBID,TIME,CBID,KBID)


      IF (NOMCMD.EQ.'MECA_STATIQUE'.OR.NOMCMD.EQ.'CALC_MATR_ELEM') THEN
        CALL VRCINS(MODELE,MATE(1:8),CARA,NCHAR,LCHAR,TIME,CHVARC)
      END IF


      CALL MEMARE(BASE,MATEL,MODELE,MATE,CARA,OPTION)
C     SI LA RIGIDITE EST CALCULEE SUR LE MODELE, ON ACTIVE LES S_STRUC:
      IF (ICODE.EQ.0 .OR. ICODE.EQ.2) THEN
        CALL JEVEUO(MATEL//'.REFE_RESU','E',IAREFE)
        ZK24(IAREFE-1+3) (1:3) = 'OUI'
      END IF

      CALL JEEXIN(MATEL//'.LISTE_RESU',IRET1)
      IF (IRET1.GT.0) CALL JEDETR(MATEL//'.LISTE_RESU')
      CALL WKVECT(MATEL//'.LISTE_RESU',BASE//' V K24',NCHAR+2,JLIRES)
      CALL JEECRA(MATEL//'.LISTE_RESU','LONUTI',0,' ')
      ILIRES = 0

      LPAOUT(1) = 'PMATUUR'
      LCHOUT(1) = MATEL//'.ME001'
      LPAOUT(2) = 'PMATUNS'
      LCHOUT(2) = MATEL//'.ME002'

      IF (ICODE.EQ.0) THEN
        LIGRMO = MODELE//'.MODELE'
        LPAIN(1) = 'PGEOMER'
        LCHIN(1) = CHGEOM
        LPAIN(2) = 'PMATERC'
        LCHIN(2) = MATE
        LPAIN(3) = 'PCAORIE'
        LCHIN(3) = CHCARA(1)
        LPAIN(4) = 'PCADISK'
        LCHIN(4) = CHCARA(2)
        LPAIN(5) = 'PCAGNPO'
        LCHIN(5) = CHCARA(6)
        LPAIN(6) = 'PCACOQU'
        LCHIN(6) = CHCARA(7)
        LPAIN(7) = 'PCASECT'
        LCHIN(7) = CHCARA(8)
        LPAIN(8) = 'PCAARPO'
        LCHIN(8) = CHCARA(9)
        LPAIN(9) = 'PHARMON'
        LCHIN(9) = CHHARM
        LPAIN(10) = 'PPESANR'
        LCHIN(10) = CHCHAR
        LPAIN(11) = 'PGEOME2'
        LCHIN(11) = ' '
        LPAIN(12) = ' '
        LCHIN(12) = CHGEOM
        LPAIN(13) = 'PCAGNBA'
        LCHIN(13) = CHCARA(11)
        LPAIN(14) = 'PCAMASS'
        LCHIN(14) = CHCARA(12)
        LPAIN(15) = 'PCAPOUF'
        LCHIN(15) = CHCARA(13)
        LPAIN(16) = 'PCAGEPO'
        LCHIN(16) = CHCARA(5)
        LPAIN(17) = 'PVARCPR'
        LCHIN(17) = CHVARC
        LPAIN(18) = 'PTEMPSR'
        LCHIN(18) = CHTIME
        LPAIN(19) = 'PNBSP_I'
        LCHIN(19) = CHCARA(1) (1:8)//'.CANBSP'
        LPAIN(20) = 'PFIBRES'
        LCHIN(20) = CHCARA(1) (1:8)//'.CAFIBR'
        LPAIN(21) = 'PCOMPOR'
        LCHIN(21) = COMPOR
        CALL CALCUL('S',OPTION,LIGRMO,21,LCHIN,LPAIN,2,LCHOUT,LPAOUT,
     &              BASE)
        CALL JEEXIN(LCHOUT(1)(1:19)//'.RESL',IRET)
        IF (IRET.NE.0) THEN
          ILIRES = ILIRES + 1
          ZK24(JLIRES-1+ILIRES) = LCHOUT(1)
        ENDIF
        CALL JEEXIN(LCHOUT(2)(1:19)//'.RESL',IRET)
        IF (IRET.NE.0) THEN
          ILIRES = ILIRES + 1
          ZK24(JLIRES-1+ILIRES) = LCHOUT(2)
        ENDIF
        CALL JEECRA(MATEL//'.LISTE_RESU','LONUTI',ILIRES,' ')
      END IF

      DO 10 ICHA = 1,NCHAR
        LIGRCH = LCHAR(ICHA) (1:8)//'.CHME.LIGRE'
        ARGU = LCHAR(ICHA) (1:8)//'.CHME.LIGRE.LIEL'
        CALL JEEXIN(ARGU,IRET)
        IF (IRET.LE.0) GO TO 10
        LCHIN(1) = LCHAR(ICHA) (1:8)//'.CHME.CMULT'
        ARGU = LCHAR(ICHA) (1:8)//'.CHME.CMULT.DESC'
        CALL JEEXIN(ARGU,IRET)
        IF (IRET.LE.0) GO TO 10

        LPAIN(1) = 'PDDLMUR'
        ILIRES = ILIRES + 1
        CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
        OPTION = 'MECA_DDLM_R'
        CALL CALCUL('S',OPTION,LIGRCH,1,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &              BASE)
        CALL JEEXIN(LCHOUT(1)(1:19)//'.RESL',IRET)
        IF (IRET.NE.0) THEN
          ZK24(JLIRES-1+ILIRES) = LCHOUT(1)
          CALL JEECRA(MATEL//'.LISTE_RESU','LONUTI',ILIRES,' ')
        ELSE
          ILIRES = ILIRES - 1
        END IF
   10 CONTINUE
      CALL JEDETC('V','&&MECHTE',1)
      CALL DETRSD('CHAMP_GD',CHTIME)

      CALL JEDEMA()
      END

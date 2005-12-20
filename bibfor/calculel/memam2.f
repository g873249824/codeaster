      SUBROUTINE MEMAM2(OPTION,MODELE,NCHAR,LCHAR,MATE,CARA,EXITIM,TIME,
     &                  CHACCE,VECEL,BASEZ,LIGREZ)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER NCHAR
      REAL*8 TIME
      CHARACTER*8 LCHAR(*)
      CHARACTER*(*) OPTION,MODELE,CHACCE,MATE,CARA,VECEL,BASEZ,LIGREZ
      LOGICAL EXITIM
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 11/09/2002   AUTEUR VABHHTS J.PELLET 
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
C     CALCULE LES VECTEURS ELEMENTAIRES ( MASSE_MECA * CHACCE )

C ----------------------------------------------------------------------
C IN  : OPTION : OPTION DE CALCUL
C IN  : MODELE : NOM DU MODELE (OBLIGATOIRE)
C IN  : NCHAR  : NOMBRE DE CHARGES
C IN  : LCHAR  : LISTE DES CHARGES
C IN  : MATE   : CARTE DE MATERIAUX
C IN  : CARA   : CHAMP DE CARAC_ELEM
C IN  : EXITIM : VRAI SI L'INSTANT EST DONNE
C IN  : TIME   : INSTANT DE CALCUL
C IN  : CHACCE : CHAMP D'ACCELERATION
C IN  : VECEL  : NOM DU VECT_ELEM RESULTAT
C IN  : BASEZ  : NOM DE LA BASE
C IN  : LIGREZ  : (SOUS-)LIGREL DE MODELE POUR CALCUL REDUIT
C                  SI ' ', ON PREND LE LIGREL DU MODELE
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
C ----------------------------------------------------------------------
      CHARACTER*1 BASE
      CHARACTER*8 K8B,LPAIN(17),LPAOUT(1),NEWNOM
      CHARACTER*24 LIGRMO,LCHIN(17),LCHOUT(1)
      CHARACTER*24 CHGEOM,CHCARA(15),CHTEMP,CHTREF,CHHARM,VECELZ

      CALL JEMARQ()
      NEWNOM = '.0000000'
      VECELZ = VECEL
      BASE = BASEZ
      IF (MODELE(1:1).EQ.' ') CALL UTMESS('F','MEMAM2',
     &                             'IL FAUT UN MODELE.')

      NH = 0
      CALL MECHAM('MASS_MECA',MODELE,NCHAR,LCHAR,CARA,NH,CHGEOM,CHCARA,
     &            CHHARM,ICODE)
      CALL MECHTE(MODELE,NCHAR,LCHAR,MATE,EXITIM,TIME,CHTREF,CHTEMP)

      CALL MEMARE(BASE,VECEL,MODELE,MATE,CARA,OPTION)
      CALL JEVEUO(VECELZ(1:8)//'.REFE_RESU','E',IAREFE)
      ZK24(IAREFE-1+3) (1:3) = 'OUI'

      CALL JEEXIN(VECELZ(1:8)//'.LISTE_RESU',IRET)
      IF (IRET.GT.0) CALL JEDETR(VECELZ(1:8)//'.LISTE_RESU')
      CALL WKVECT(VECELZ(1:8)//'.LISTE_RESU',BASE//' V K24',2,JLIRES)
      CALL JEECRA(VECELZ(1:8)//'.LISTE_RESU','LONUTI',0,' ')
      IF (ICODE.EQ.2) GO TO 10

      LIGRMO = LIGREZ
      IF (LIGRMO.EQ.' ') LIGRMO = MODELE(1:8)//'.MODELE'

      LPAOUT(1) = 'PVECTUR'

      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PMATERC'
      LCHIN(2) = MATE
      LPAIN(3) = 'PTEMPER'
      LCHIN(3) = CHTEMP
      LPAIN(4) = 'PCAGNPO'
      LCHIN(4) = CHCARA(6)
      LPAIN(5) = 'PCAGEPO'
      LCHIN(5) = CHCARA(5)
      LPAIN(6) = 'PCACOQU'
      LCHIN(6) = CHCARA(7)
      LPAIN(7) = 'PCADISM'
      LCHIN(7) = CHCARA(3)
      LPAIN(8) = 'PCAORIE'
      LCHIN(8) = CHCARA(1)
      LPAIN(9) = 'PCASECT'
      LCHIN(9) = CHCARA(8)
      LPAIN(10) = 'PCAARPO'
      LCHIN(10) = CHCARA(9)
      LPAIN(11) = 'PCACABL'
      LCHIN(11) = CHCARA(10)
      LPAIN(12) = 'PCAGNBA'
      LCHIN(12) = CHCARA(11)
      LPAIN(13) = 'PCAPOUF'
      LCHIN(13) = CHCARA(13)
      LPAIN(14) = 'PDEPLAR'
      LCHIN(14) = CHACCE
      LPAIN(15) = 'PNBSP_I'
      LCHIN(15) = CHCARA(1) (1:8)//'.CANBSP'
      LPAIN(16) = 'PFIBRES'
      LCHIN(16) = CHCARA(1) (1:8)//'.CAFIBR'

      LCHOUT(1) = '&&MEMAM2.???????'
      CALL GCNCO2(NEWNOM)
      LCHOUT(1) (10:16) = NEWNOM(2:8)
      CALL CORICH('E',LCHOUT(1),-1,IBID)
      CALL CALCUL('S',OPTION,LIGRMO,17,LCHIN,LPAIN,1,LCHOUT,LPAOUT,BASE)

      ILIRES = 0
      CALL EXISD('CHAMP_GD',LCHOUT(1) (1:19),IRET)
      IF (IRET.NE.0) THEN
        ILIRES = ILIRES + 1
        ZK24(JLIRES-1+ILIRES) = LCHOUT(1)
        CALL JEECRA(VECELZ(1:8)//'.LISTE_RESU','LONUTI',ILIRES,' ')
      END IF

   10 CONTINUE
      CALL DETRSD('CHAMP_GD',CHTEMP)

      CALL JEDEMA()
      END

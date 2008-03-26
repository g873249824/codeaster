      SUBROUTINE METNTH(MODELE,LCHAR,CARA,MATE,TIME,CHTNI,METRNL)


C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 25/03/2008   AUTEUR REZETTE C.REZETTE 
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

C     ARGUMENTS:
C     ----------
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*(*) LCHAR,MATE
      CHARACTER*24 MODELE,CARA,METRNL,PREFCH,TIME,CHTNI
C ----------------------------------------------------------------------

C     CALCUL DES MATRICES ELEMENTAIRES DE CONVECTION NATURELLE

C     ENTREES:

C     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
C        MODELE : NOM DU MODELE
C        LCHAR  : OBJET CONTENANT LA LISTE DES CHARGES
C        MATE   : CHAMP DE MATERIAUX
C        CARA   : CHAMP DE CARAC_ELEM
C        TIME   : CHAMPS DE TEMPSR
C        CHTNI  : IEME ITEREE DU CHAMP DE TEMPERATURE
C        METRNL : NOM DU MATR_ELEM (N RESUELEM) PRODUIT

C     SORTIES:
C        METRNL  : EST REMPLI.

C ----------------------------------------------------------------------

C     VARIABLES LOCALES:
C     ------------------
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------

      CHARACTER*32 JEXNUM,JEXNOM,JEXR8,JEXATR
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

C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
      CHARACTER*8 NOMCHA,LPAIN(7),LPAOUT(1),K8BID
      CHARACTER*8 BLANC,VITESS,DECENT
      CHARACTER*16 OPTION
      CHARACTER*24 LIGREL(2),LCHIN(7),LCHOUT(1),CHGEOM,CHCARA(15)
      CHARACTER*24 CHVITE,LIGRMO,CARTE,CONVCH,CARELE
      INTEGER IRET,ILIRES,IBID,ICHA
      INTEGER JLIRES,NCHAR,JCHAR,IALICH
      COMPLEX*16 CBID
      LOGICAL EXIGEO,EXICAR

C DEB-------------------------------------------------------------------

      CALL JEMARQ()
C     -- ON VERIFIE LA PRESENCE PARFOIS NECESSAIRE DE CARA_ELEM
      IF (MODELE(1:1).EQ.' ') THEN
        CALL U2MESS('F','CALCULEL3_50')
      END IF

      CALL JEEXIN(LCHAR,IRET)
      IF (IRET.NE.0) THEN
        CALL JELIRA(LCHAR,'LONMAX',NCHAR,K8BID)
        CALL JEVEUO(LCHAR,'L',JCHAR)
      ELSE
        NCHAR = 0
      END IF

      BLANC = '        '
      CALL MEGEOM(MODELE,BLANC,EXIGEO,CHGEOM)
      CALL MECARA(CARA,EXICAR,CHCARA)

      CALL JEEXIN(METRNL,IRET)
      IF (IRET.EQ.0) THEN
        METRNL = '&&METNTH           .RELR'
        CALL MEMARE('V',METRNL,MODELE(1:8),MATE,CARELE,
     &              'RIGI_THER_CONV_T')
      ELSE
        CALL JEDETR(METRNL)
      END IF

      CHVITE = '????'

      ICONV = 0

      LPAOUT(1) = 'PMATTTR'
      LCHOUT(1) = METRNL(1:8)//'.ME000'
      DO 10 ICHAR = 1,NCHAR
        NOMCHA = ZK24(JCHAR+ICHAR-1) (1:8)
        CONVCH = NOMCHA//'.CHTH'//'.CONVE'//'.VALE'
        CALL JEEXIN(CONVCH,IRET)
        IF (IRET.GT.0) THEN
          ICONV = ICONV + 1
          IF (ICONV.GT.1) CALL U2MESS('F','CALCULEL3_72')

          DECENT = 'OUI'
          OPTION = 'RIGI_THER_CONV'
          IF (DECENT.EQ.'OUI') OPTION = 'RIGI_THER_CONV_T'
          CALL MEMARE('V',METRNL,MODELE(1:8),MATE,CARA,OPTION)

          CALL JEVEUO(CONVCH,'L',JVITES)
          VITESS = ZK8(JVITES)
          CHVITE = VITESS
          CARTE = '&&METNTH'//'.CONVECT.DECENT'
          CALL MECACT('V',CARTE,'MODELE',MODELE(1:8)//'.MODELE',
     &                'NEUT_K24',1,'Z1',0,0.D0,CBID,DECENT)
          LPAIN(1) = 'PGEOMER'
          LCHIN(1) = CHGEOM
          LPAIN(2) = 'PMATERC'
          LCHIN(2) = MATE
          LPAIN(3) = 'PCACOQU'
          LCHIN(3) = CHCARA(7)
          LPAIN(4) = 'PTEMPSR'
          LCHIN(4) = TIME
          LPAIN(5) = 'PVITESR'
          LCHIN(5) = CHVITE
          LPAIN(7) = 'PNEUK24'
          LCHIN(7) = CARTE
          LPAIN(6) = 'PTEMPEI'
          LCHIN(6) = CHTNI


          LIGRMO = MODELE(1:8)//'.MODELE'
          ILIRES = 0
          ILIRES = ILIRES + 1
          CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
          CALL CALCUL('S',OPTION,LIGRMO,7,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &                'V')
          CALL REAJRE(METRNL,LCHOUT(1),'V')

        END IF
   10 CONTINUE

      CALL JEDEMA()

      END

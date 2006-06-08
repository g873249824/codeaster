      SUBROUTINE MEIMME(MODELE,NCHAR,LCHAR,MATE,MATEL)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER NCHAR
      CHARACTER*8 MODELE,LCHAR(*),MATEL
      CHARACTER*(*) MATE
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
C     CALCUL DES MATRICES ELEMENTAIRES D 'IMPEDANCE ACOUSTIQUE DANS LE
C     PHENOMENE MECANIQUE

C ----------------------------------------------------------------------
C IN  : MODELE : NOM DU MODELE
C IN  : NCHAR  : NOMBRE DE CHARGES
C IN  : LCHAR  : LISTE DES CHARGES
C IN  : MATE   : CARTE DE MATERIAU
C VAR : MATEL  : NOM  DU  MATELE (N RESUELEM) PRODUIT
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
      INTEGER NH
      REAL*8 TIME
      CHARACTER*8 K8B,CARA,LPAIN(4),LPAOUT(1)
      CHARACTER*16 OPTION
      CHARACTER*24 LIGRMO,LIGRCH,LCHIN(4),LCHOUT(1)
      CHARACTER*24 CHGEOM,CHCARA(15),CHTEMP,CHTREF,CHHARM
      LOGICAL EXITIM,LFONC

      CALL JEMARQ()
      IF (MODELE(1:1).EQ.' ') CALL UTMESS('F','MEIMME',
     &                             'IL FAUT UN MODELE.')

      CARA = ' '
      EXITIM = .FALSE.
      TIME = 0.D0
      NH = 0
      OPTION = 'IMPE_MECA'
      CALL MECHAM(OPTION,MODELE,NCHAR,LCHAR,CARA,NH,CHGEOM,CHCARA,
     &            CHHARM,ICODE)
      CALL MECHTE(MODELE,NCHAR,LCHAR,MATE,EXITIM,TIME,CHTREF,CHTEMP)

      CALL JEEXIN(MATEL//'.REFE_RESU',IRET)
      IF (IRET.GT.0) THEN
        CALL JEDETR(MATEL//'.REFE_RESU')
        CALL JEDETR(MATEL//'.LISTE_RESU')
      END IF
      CALL MEMARE('G',MATEL,MODELE,MATE,' ',OPTION)
      CALL WKVECT(MATEL//'.LISTE_RESU','G V K24',MAX(NCHAR,1),JLIRES)
      CALL JEECRA(MATEL//'.LISTE_RESU','LONUTI',0,' ')

      LPAOUT(1) = 'PMATUUR'
      LCHOUT(1) = MATEL//'.ME001'
      ILIRES = 0
      IF (LCHAR(1).NE.'        ') THEN

        LIGRMO = MODELE//'.MODELE'
        LPAIN(1) = 'PGEOMER'
        LCHIN(1) = CHGEOM

        LPAIN(3) = 'PMATERC'
        LCHIN(3) = MATE

        DO 10 ICHA = 1,NCHAR
          CALL DISMOI('F','TYPE_CHARGE',LCHAR(ICHA),'CHARGE',IBID,K8B,
     &                IERD)
          IF (K8B(5:7).EQ.'_FO') THEN
            LFONC = .TRUE.
          ELSE
            LFONC = .FALSE.
          END IF
C           LIGRCH = LCHAR(ICHA)//'.CHME.LIGRE'
          CALL EXISD('CHAMP_GD',LCHAR(ICHA)//'.CHME.IMPE ',IRET)
          IF (IRET.NE.0) THEN
            IF (LFONC) THEN
              OPTION = 'IMPE_MECA_F'
              LPAIN(2) = 'PIMPEDF'
            ELSE
              OPTION = 'IMPE_MECA'
              LPAIN(2) = 'PIMPEDR'
            END IF
            LCHIN(2) = LCHAR(ICHA)//'.CHME.IMPE .DESC'
            ILIRES = ILIRES + 1
            CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
            CALL CALCUL('S',OPTION,LIGRMO,3,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &                  'G')
            CALL EXISD('CHAMP_GD',LCHOUT(1) (1:19),IRET)
            IF (IRET.NE.0) THEN
              ZK24(JLIRES-1+ILIRES) = LCHOUT(1)
              CALL JEECRA(MATEL//'.LISTE_RESU','LONUTI',ILIRES,' ')
            ELSE
              ILIRES = ILIRES - 1
            END IF
          END IF
   10   CONTINUE
      END IF
   20 CONTINUE
      CALL JEDEMA()
      END

      SUBROUTINE MEONME(MODELE,NCHAR,LCHAR,MATE,MATEL)
      IMPLICIT REAL*8 (A-H,O-Z)
      INCLUDE 'jeveux.h'
      INTEGER NCHAR
      CHARACTER*8 MODELE,LCHAR(*)
      CHARACTER*19 MATEL
      CHARACTER*(*) MATE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 13/06/2012   AUTEUR COURTOIS M.COURTOIS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     CALCUL DES MATRICES ELEMENTAIRES D 'IMPEDANCE PAR ONDE INCIDENTE
C     ACOUSTIQUE DANS LE PHENOMENE MECANIQUE


C ----------------------------------------------------------------------
C IN  : MODELE : NOM DU MODELE
C IN  : NCHAR  : NOMBRE DE CHARGES
C IN  : LCHAR  : LISTE DES CHARGES
C IN  : MATE   : CARTE DE MATERIAU
C VAR : MATEL  : NOM  DU  MATELE (N RESUELEM) PRODUIT
C ----------------------------------------------------------------------
C     ------------------------------------------------------------------
      INTEGER NH
      CHARACTER*8 K8B,CARA,LPAIN(3),LPAOUT(1)
      CHARACTER*16 OPTION
      CHARACTER*24 LIGRMO,LCHIN(3),LCHOUT(1)
      CHARACTER*24 CHGEOM,CHCARA(18),CHHARM
      LOGICAL LFONC

      CALL JEMARQ()
      IF (MODELE(1:1).EQ.' ') CALL U2MESS('F','CALCULEL2_82')

      CARA = ' '
      NH = 0
      OPTION = 'CHAR_MECA'
      CALL MECHAM(OPTION,MODELE,NCHAR,LCHAR,CARA,NH,CHGEOM,CHCARA,
     &            CHHARM,ICODE)

      CALL JEEXIN(MATEL//'.RERR',IRET)
      IF (IRET.GT.0) THEN
        CALL JEDETR(MATEL//'.RERR')
        CALL JEDETR(MATEL//'.RELR')
      END IF
      CALL MEMARE('G',MATEL,MODELE,MATE,' ',OPTION)

      LPAOUT(1) = 'PMATUUR'
      LCHOUT(1) = MATEL(1:8)//'.ME001'
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

          CALL EXISD('CHAMP_GD',LCHAR(ICHA)//'.CHME.ONDE ',IRET)
          IF (IRET.NE.0) THEN
            IF (LFONC) THEN
              OPTION = 'ONDE_FLUI_F'
              LPAIN(2) = 'PONDECF'
            ELSE
              OPTION = 'ONDE_FLUI'
              LPAIN(2) = 'PONDECR'
            END IF
            LCHIN(2) = LCHAR(ICHA)//'.CHME.ONDE .DESC'
            ILIRES = ILIRES + 1
            CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
            CALL CALCUL('S',OPTION,LIGRMO,3,LCHIN,LPAIN,1,LCHOUT,LPAOUT,
     &                  'G','OUI')
            CALL REAJRE(MATEL,LCHOUT(1),'G')
          END IF
   10   CONTINUE
      END IF
      CALL JEDEMA()
      END

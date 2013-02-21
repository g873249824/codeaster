      SUBROUTINE MEMAAC(MODELE,MATE,MATEL)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*8 MODELE
      CHARACTER*19 MATEL
      CHARACTER*(*) MATE
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 12/02/2013   AUTEUR PELLET J.PELLET 
C ======================================================================
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

C     CALCUL DES MATRICES ELEMENTAIRES DE MASSE_ACOUSTIQUE
C                ( 'MASS_ACOU', ISO )

C     ENTREES:

C     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
C        MODELE : NOM DU MODELE
C*       MATE   : CARTE DE MATERIAU CODE
C        MATEL  : NOM DU MAT_ELE(N RESUELEM) PRODUIT

C     SORTIES:
C        MATEL  : EST CALCULE

C ----------------------------------------------------------------------

C     FONCTIONS EXTERNES:
C     -------------------

C     VARIABLES LOCALES:
C     ------------------
C*
C*
      CHARACTER*8 LPAIN(4),LPAOUT(1)
      CHARACTER*16 OPTION
C*
      CHARACTER*24 CHGEOM,LCHIN(4),LCHOUT(1)
      CHARACTER*24 LIGRMO


C-----------------------------------------------------------------------
      INTEGER ILIRES ,IRET
C-----------------------------------------------------------------------
      CALL JEMARQ()
      IF (MODELE(1:1).EQ.' ') THEN
        CALL U2MESS('F','CALCULEL3_50')
      END IF

      CALL MEGEOM(MODELE,CHGEOM)

      CALL JEEXIN(MATEL//'.RERR',IRET)
      IF (IRET.GT.0) THEN
        CALL JEDETR(MATEL//'.RERR')
        CALL JEDETR(MATEL//'.RELR')
      END IF
      CALL MEMARE('G',MATEL,MODELE,MATE,' ','MASS_ACOU')

      LPAOUT(1) = 'PMATTTC'
      LCHOUT(1) = MATEL(1:8)//'.ME000'
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
C**
      LPAIN(2) = 'PMATERC'
      LCHIN(2) = MATE
C**

      LIGRMO = MODELE//'.MODELE'
      OPTION = 'MASS_ACOU'
      ILIRES = 0
      ILIRES = ILIRES + 1
      CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
      CALL CALCUL('S',OPTION,LIGRMO,2,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'G',
     &               'OUI')
      CALL EXISD('CHAMP_GD',LCHOUT(1) (1:19),IRET)
      CALL REAJRE(MATEL,LCHOUT(1),'G')

      CALL JEDEMA()
      END

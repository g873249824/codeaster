      SUBROUTINE MEMSTH(MODELE,CARELE,MATE,INST,MEMASS)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 03/07/2012   AUTEUR PELLET J.PELLET 
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
      IMPLICIT NONE
      INCLUDE 'jeveux.h'
      CHARACTER*24 MODELE,CARELE,INST,MEMASS,MATE
C ----------------------------------------------------------------------
C CALCUL DES MATRICES ELEMENTAIRES DE MASSE THERMIQUE

C IN  MODELE  : NOM DU MODELE
C IN  CARELE  : CHAMP DE CARA_ELEM
C IN  MATE    : MATERIAU CODE
C IN  INST    : CARTE CONTENANT LA VALEUR DU TEMPS
C OUT MEMASS  : MATRICES ELEMENTAIRES



      CHARACTER*8 LPAIN(5),LPAOUT(1)
      CHARACTER*16 OPTION
      CHARACTER*24 LIGRMO,LCHIN(5),LCHOUT(1)
      CHARACTER*24 CHGEOM,CHCARA(18)
      CHARACTER*19 CHVARC
      REAL*8 TIME
      INTEGER IRET,ILIRES
      LOGICAL EXIGEO,EXICAR
      
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
      CHVARC = '&&NXACMV.CHVARC'

      CALL JEMARQ()
      CALL MEGEOM(MODELE,'      ',EXIGEO,CHGEOM)
      CALL MECARA(CARELE,EXICAR,CHCARA)
      
      CALL JEEXIN(MEMASS,IRET)
      IF (IRET.EQ.0) THEN
        MEMASS = '&&MEMASS           .RELR'
       CALL MEMARE('V',MEMASS(1:19),MODELE(1:8),MATE,CARELE,'MASS_THER')
      END IF
      LIGRMO = MODELE(1:8)//'.MODELE'

      LPAOUT(1) = 'PMATTTR'
      LCHOUT(1) = MEMASS(1:8)//'.ME001'
      ILIRES = 0

      IF (MODELE.NE.'        ') THEN
        LPAIN(1) = 'PGEOMER'
        LCHIN(1) = CHGEOM
        LPAIN(2) = 'PMATERC'
        LCHIN(2) = MATE
        LPAIN(3) = 'PCACOQU'
        LCHIN(3) = CHCARA(7)
        LPAIN(4) = 'PTEMPSR'
        LCHIN(4) = INST
        LPAIN(5) = 'PVARCPR'
        LCHIN(5) = CHVARC
        OPTION = 'MASS_THER'
        ILIRES = 1
        CALL CODENT(ILIRES,'D0',LCHOUT(1) (12:14))
        CALL CALCUL('S',OPTION,LIGRMO,5,LCHIN,LPAIN,1,LCHOUT,LPAOUT,'V',
     &                 'OUI')
        CALL JEDETR(MEMASS)
        CALL REAJRE(MEMASS, LCHOUT(1),'V')
      END IF
C FIN ------------------------------------------------------------------
      CALL JEDEMA()
      END
